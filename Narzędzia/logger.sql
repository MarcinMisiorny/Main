-- CONFIG ON SYS USER
GRANT EXECUTE ON UTL_FILE TO MY_TEST_USER;
CREATE DIRECTORY LOGS AS '/apps/app/oracledb/oracle-base/oradata/logs';
GRANT READ, WRITE ON DIRECTORY LOGS TO MY_TEST_USER;
/* Optional when you want compile package as MY_TEST_USER*/ 
GRANT CREATE PROCEDURE TO MY_TEST_USER;

-------------------------------------------------------

-- PACKAGE
CREATE OR REPLACE PACKAGE logs
IS
    PROCEDURE pr_log
    (p_log_text IN VARCHAR2
    ,p_mode IN VARCHAR2 DEFAULT 'I'
    ,p_file_name IN VARCHAR2 DEFAULT NULL
    ,p_logs_directory IN VARCHAR2 DEFAULT NULL);

    PROCEDURE pr_log_error
    (p_log_error_text IN VARCHAR2 DEFAULT NULL
    ,p_error_file_name IN VARCHAR2 DEFAULT NULL
    ,p_error_logs_directory IN VARCHAR2 DEFAULT NULL);
END logs;


CREATE OR REPLACE PACKAGE BODY logs
IS
    --variables
    v_default_log_file_name VARCHAR2(200) := TO_CHAR(SYSDATE, 'YYYYMMDD') || '_[USER]=' || USER || '_[SESSIONID]=' || USERENV('SESSIONID') || '.log.txt';
    v_default_logs_directory VARCHAR2(50) := 'LOGS';
    v_line_sign VARCHAR2(1) := '-';
    v_long_line VARCHAR2(100) := RPAD(v_line_sign, 79 , v_line_sign);
    v_short_line VARCHAR2(30) := RPAD(v_line_sign, 20 , v_line_sign);
    v_log_header VARCHAR2(500) := v_long_line || CHR(10) 
                                 || v_short_line || ' LOG START: ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF6') || ' ' || v_short_line || CHR(10)
                                 || v_short_line || ' USER: ' || RPAD(USER || ' ', 52, v_line_sign) || CHR(10)
                                 || v_short_line || ' SESSION_ID: ' || RPAD(USERENV('SESSIONID') || ' ', 46, v_line_sign) || CHR(10)
                                 || v_long_line;
    
    -- functions and procedures
    -- open file, put into file, close file
    PROCEDURE pr_log
    (p_log_text IN VARCHAR2
    ,p_mode IN VARCHAR2 DEFAULT 'I'
    ,p_file_name IN VARCHAR2 DEFAULT NULL
    ,p_logs_directory IN VARCHAR2 DEFAULT NULL)
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        f_log_file_handler UTL_FILE.FILE_TYPE;
        v_mode_label VARCHAR2(20) DEFAULT ' [INFO]  ';
        n_file_exists NUMBER;
        v_logfile_name VARCHAR2(500) DEFAULT v_default_log_file_name;
        v_logs_directory VARCHAR2(50) DEFAULT v_default_logs_directory;
    BEGIN
        IF p_file_name IS NOT NULL THEN
            v_logfile_name := p_file_name;
        END IF;
 
        IF p_logs_directory IS NOT NULL THEN
            v_logs_directory := p_logs_directory;
        END IF;
        
        IF UPPER(p_mode) = 'D' THEN
            v_mode_label := ' [DEBUG] ';
        ELSIF UPPER(p_mode) = 'E' THEN
            v_mode_label := ' [ERROR] ';
        END IF;
    
        n_file_exists := DBMS_LOB.FILEEXISTS(BFILENAME(v_logs_directory, v_logfile_name)); -- check if file exists
        f_log_file_handler := UTL_FILE.FOPEN(v_logs_directory, v_logfile_name, 'A');
       
        IF n_file_exists = 1 THEN -- if file exists, add line, if not, add header and line
            UTL_FILE.PUT_LINE(f_log_file_handler, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF6') || v_mode_label || p_log_text);
        ELSE
            UTL_FILE.PUT_LINE(f_log_file_handler, v_log_header || CHR(10) || CHR(10) || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF6') || v_mode_label || p_log_text);
        END IF;

        UTL_FILE.FCLOSE(f_log_file_handler);
    EXCEPTION
        WHEN OTHERS THEN
            IF UTL_FILE.IS_OPEN(f_log_file_handler) THEN
                UTL_FILE.FCLOSE(f_log_file_handler);
            END IF;
            
            RAISE_APPLICATION_ERROR(-20001, $$PLSQL_UNIT || ': Error during initialize file or add log line to the file: "' || v_logfile_name || '".' || CHR(10) || 'ERROR DETAILS: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK, TRUE);
    END pr_log;

    --log for errors, it can log errors in different files in different places
    PROCEDURE pr_log_error
    (p_log_error_text IN VARCHAR2 DEFAULT NULL
    ,p_error_file_name IN VARCHAR2 DEFAULT NULL
    ,p_error_logs_directory IN VARCHAR2 DEFAULT NULL)
    IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        logs.pr_log('User''s defined error message: "' 
                   || COALESCE(p_log_error_text, '-') 
                   || '"'
                   || CHR(10)  
                   || SYS.DBMS_UTILITY.FORMAT_ERROR_STACK
                   || SYS.DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                   || SYS.DBMS_UTILITY.FORMAT_CALL_STACK
                   ,'E'
                   ,p_error_file_name
                   ,p_error_logs_directory);
    END pr_log_error;
    
    /*Usage example:
    ...
    EXCEPTION
        WHEN OTHERS THEN
            logs.pr_log_error;
      RAISE;         
    ...
    */

END logs; 

