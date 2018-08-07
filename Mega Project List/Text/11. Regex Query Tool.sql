/*
*
* Case: Regex Query Tool
* Description: A tool that allows the user to enter a text string and then in a separate control enter a regex pattern. 
* It will run the regular expression against the source text and return any matches or flag errors in the regular expression.
* 
* My comment:
* Simple procedure.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE pr_regex_query
(p_string IN VARCHAR2
,p_pattern IN VARCHAR2)
IS
    v_match VARCHAR2(100);
    n_instr NUMBER;
    n_counter NUMBER;
    b_found BOOLEAN;
    
    TYPE t_position IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    t_position_tab t_position;
BEGIN
    n_counter := 0;
    b_found := TRUE;
    
    WHILE b_found LOOP
        n_counter := n_counter + 1;
        v_match := REGEXP_SUBSTR(p_string, p_pattern, 1, n_counter);
        n_instr := REGEXP_INSTR(p_string, p_pattern, 1, n_counter);

        IF v_match IS NOT NULL THEN
            t_position_tab(n_counter) := n_instr;
        ELSE 
            b_found := FALSE; 
        END IF;
    END LOOP;
    
    IF t_position_tab.COUNT > 0 THEN
        FOR i IN t_position_tab.FIRST .. t_position_tab.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('Found ' || i || ' occurence: "' || p_pattern || '" at position ' || t_position_tab(i) || ' of string');
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('There is no occurence of "' || p_pattern || '" in this string');
    END IF;
END pr_regex_query;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_regex_query('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'Excepteur');

/* Script result: */
There is no occurence of "Excepteur" in this string.

---

EXECUTE pr_regex_query('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 'Lorem');

/* Script result: */
Found 1 occurence: "Lorem" at position 1 of string

---

EXECUTE pr_regex_query('One, two, three, four, five, six, seven, eight, ten, one, two, three, four, five, six, seven, eight, ten, one, two, three, four, five', 'two');
/* Script result: */
Found 1 occurence: "two" at position 6 of string
Found 2 occurence: "two" at position 59 of string
Found 3 occurence: "two" at position 112 of string