/*
*
* Case: Pig Latin
* Description: Pig Latin is a game of alterations played on the English language game. To create the Pig Latin form of an English word 
* the initial consonant sound is transposed to the end of the word and an ay is affixed (Ex.: "banana" would yield anana-bay). 
* Read Wikipedia for more information on rules.
* 
* My comment:
* Simple procedure.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_pig_latin
(p_input_string IN VARCHAR2)
IS
    n_counter NUMBER;
    v_temp_string VARCHAR2(100);
    v_result VARCHAR2(100);
    
    ex_space EXCEPTION;
BEGIN
    IF INSTR(p_input_string, ' ') > 0 THEN
        RAISE ex_space;
    END IF;

    n_counter := 1;

    IF SUBSTR(p_input_string, 1, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') THEN
        v_result := p_input_string || 'way';
    ELSE
        WHILE SUBSTR(p_input_string, n_counter, 1) NOT IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') LOOP
            IF v_temp_string IS NOT NULL THEN
                v_temp_string := v_temp_string || SUBSTR(p_input_string, n_counter, 1);
            ELSE
                v_temp_string := SUBSTR(p_input_string, n_counter, 1);
            END IF;
            
            n_counter := n_counter + 1;
        END LOOP;
        
        v_result := SUBSTR(p_input_string, LENGTH(v_temp_string) + 1, LENGTH(p_input_string)) || v_temp_string || 'ay';
        
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_result);
EXCEPTION
    WHEN ex_space THEN
        RAISE_APPLICATION_ERROR(-20001, 'Found space in input string, if you put a sentence, remove it - this procedure is for single words (without spaces) only.');
END pr_pig_latin;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_pig_latin('racer');

/* Script result: */
acerray

---

/* Test: */
EXECUTE pr_pig_latin('fox');

/* Script result: */
oxfay

---

/* Test: */
EXECUTE pr_pig_latin('moving');

/* Script result: */
ovingmay

