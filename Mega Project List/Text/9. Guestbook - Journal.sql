
/*
*
* Case: Guestbook / Journal
* Description:  A simple application that allows people to add comments or write journal entries. It can allow comments or not 
* and timestamps for all entries. Could also be made into a shout box. Optional: Deploy it on Google App Engine or Heroku 
* or any other PaaS (if possible, of course).
* 
* My comment:
* Simple procedure, which is using a dynamic SQL. 
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

CREATE OR REPLACE PROCEDURE pr_journal
(p_input_text IN VARCHAR2 DEFAULT NULL)
IS
    n_records_count NUMBER;
    d_creation_date DATE;

    TYPE t_journal_ref_cur_type IS REF CURSOR;
    c_journal t_journal_ref_cur_type;

    TYPE r_record IS RECORD (time DATE
                            ,text VARCHAR2(4000));
    row_r_record r_record;
    
    PROCEDURE pr_check_table IS
        n_flag NUMBER;
    BEGIN
        SELECT CASE WHEN EXISTS (SELECT 1 FROM user_tables WHERE table_name = 'TB_OUR_JOURNAL') THEN 1 ELSE 0 END 
        INTO n_flag
        FROM dual;
    
        IF n_flag = 0 THEN
            EXECUTE IMMEDIATE 'CREATE TABLE tb_our_journal (time DATE DEFAULT SYSTIMESTAMP, text VARCHAR2 (4000))';
        END IF;
    END;
BEGIN
    pr_check_table;

    IF p_input_text IS NOT NULL THEN
        -- if table doesn't exists, there will be exception if we wouldn't use EXECUTE IMMEDIATE, dynamic SQL is just necessary here
        EXECUTE IMMEDIATE
        'INSERT INTO tb_our_journal(text) values (:p_input_text)'
        USING IN p_input_text;
    ELSE
        -- I need to count records in a separate query - for dynamic SQL and REF CURSORs there is no %ROWCOUNT method 
        EXECUTE IMMEDIATE
        'SELECT COUNT(*) FROM tb_our_journal'
        INTO n_records_count;
        
        IF n_records_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('We don''t have any data in our journal, please add some.');
        ELSE
            EXECUTE IMMEDIATE
            'SELECT CREATED FROM all_objects WHERE object_name = ''TB_OUR_JOURNAL'''
            INTO d_creation_date;
            
            DBMS_OUTPUT.PUT_LINE('Our journal. Created: ' || TO_CHAR(d_creation_date, 'YYYY-MM-DD HH24:MM:SS')); 
            DBMS_OUTPUT.NEW_LINE;
            
            OPEN c_journal 
            FOR 'SELECT * FROM tb_our_journal';
            
            LOOP
                FETCH c_journal 
                INTO row_r_record;
                EXIT WHEN c_journal%NOTFOUND;
                
                DBMS_OUTPUT.PUT_LINE('Time: ' || TO_CHAR(row_r_record.time, 'YYYY-MM-DD HH24:MM:SS') || ', entry: "' || row_r_record.text || '"');
            END LOOP;
        END IF;
    END IF;
END pr_journal;

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */


/* Script result: */


