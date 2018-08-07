/*
*
* Case: Check if Palindrome
* Description: Checks if the string entered by the user is a palindrome. That is that it reads the same forwards as backwards like “racecar”
* 
* My comment:
* Simple procedure.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_is_palindrome
(p_input_string IN VARCHAR2)
IS
    v_cleared_string VARCHAR2(100);
    v_reversed_string VARCHAR2(100);
begin
    v_cleared_string := REPLACE(p_input_string, ' ', '');   

    FOR i IN REVERSE 1 .. LENGTH(v_cleared_string) LOOP
        v_reversed_string := v_reversed_string || SUBSTR(v_cleared_string, i, 1);
    END LOOP;
    
    IF v_cleared_string = v_reversed_string THEN
        DBMS_OUTPUT.PUT_LINE(v_cleared_string || ' is a palindrome');  
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_cleared_string || ' is not a palindrome');
    END IF;  
END pr_is_palindrome;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_is_palindrome('Honorificabilitudinitatibus');

/* Script result: */
Honorificabilitudinitatibus is not a palindrome

---

/* Test: */
EXECUTE pr_is_palindrome('racecar');

/* Script result: */
racecar is a palindrome

---

/* Test: */
EXECUTE pr_is_palindrome('Floccinaucinihilipilification');

/* Script result: */
Floccinaucinihilipilification is not a palindrome

