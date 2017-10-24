/*
* 
* Case: Number Names
* Description: Show how to spell out a number in English. You can use a preexisting implementation or roll your own, but you should support 
* inputs up to at least one million (or the maximum value of your language's default bounded integer type, if that's less). 
* Optional: Support for inputs other than positive integers (like zero, negative integers, and floating-point numbers).
* 
* My comment: 
* Simple procedure, based on built in Oracle functions and trick with the Julian calendar.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_number_names
(p_input_number NUMBER)
IS
    v_prefix VARCHAR2(10);
    n_integer_part NUMBER;
    n_fraction_part NUMBER;
    v_integer_in_words VARCHAR2(100);
    v_fraction_in_words VARCHAR2(100);
    v_full_number_name  VARCHAR2(300);
BEGIN
    IF INSTR(p_input_number, '-') = 1 THEN
        v_prefix := 'minus';
    END IF;
 
    IF p_input_number = 0 THEN
        v_full_number_name := 'zero'; 
    END IF;
    
    IF INSTR(p_input_number, ',') > 0 AND p_input_number != 0 THEN
        n_integer_part := REPLACE(SUBSTR(p_input_number, 1, INSTR(p_input_number, ',') - 1), '-', '');
        n_fraction_part := SUBSTR(p_input_number, INSTR(p_input_number, ',') + 1, LENGTH(p_input_number));
       
        v_integer_in_words := TO_CHAR(TO_DATE(n_integer_part, 'J'), 'jsp');
        v_fraction_in_words := TO_CHAR(TO_DATE(n_fraction_part, 'J'), 'jsp');
        
        IF v_prefix IS NOT NULL THEN
            v_full_number_name := v_prefix || ' ' || v_integer_in_words || ' point ' || v_fraction_in_words;
        ELSE
            v_full_number_name := v_integer_in_words || ' point ' || v_fraction_in_words;
        END IF;
    ELSIF p_input_number != 0 THEN
        v_integer_in_words := TO_CHAR(TO_DATE(ABS(p_input_number), 'J'), 'jsp');
        
        IF v_prefix IS NOT NULL THEN        
            v_full_number_name := v_prefix || ' ' || v_integer_in_words;
        ELSE
            v_full_number_name := v_integer_in_words;
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_full_number_name);
END pr_number_names;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_number_names(101.54);

/* Script result: */
one hundred one point fifty-four

---

/* Test: */
EXECUTE pr_number_names(0);

/* Script result: */
zero

---

/* Test: */
EXECUTE pr_number_names(-2598754.6821);

/* Script result: */
minus two million five hundred ninety-eight thousand seven hundred fifty-four point six thousand eight hundred twenty-one

