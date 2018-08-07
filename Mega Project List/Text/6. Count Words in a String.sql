/*
*
* Case: Count Words in a String
* Description: Counts the number of individual words in a string. For added complexity read these strings in from a text file and generate a summary.
* 
* My comment:
* Simple procedure.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_count_words
(p_input_string IN VARCHAR2)
IS
    n_words_count NUMBER;
BEGIN
    n_words_count := REGEXP_COUNT(p_input_string, '\w+');
    DBMS_OUTPUT.PUT_LINE('In string "' || p_input_string || CASE WHEN n_words_count = 1 THEN '" there is ' || n_words_count || ' word' ELSE '" there are ' || n_words_count || ' words' END);  
END pr_count_words;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_count_words('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');

/* Script result: */
In string "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." there are 69 words

---

/* Test: */
EXECUTE pr_count_words('One, two, three, four, five, six, seven, eight, ten, one, two, three, four, five, six, seven, eight, ten, one, two, three, four, five');

/* Script result: */
In string "One, two, three, four, five, six, seven, eight, ten, one, two, three, four, five, six, seven, eight, ten, one, two, three, four, five" there are 23 words
