/*
* 
* Case: Happy numbers
* Description: A happy number is defined by the following process. Starting with any positive integer, replace the number by the sum 
* of the squares of its digits, and repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which 
* does not include 1. Those numbers for which this process ends in 1 are happy numbers, while those that do not end in 1 are unhappy numbers. 
* Display an example of your output here. Find first 8 happy numbers.
* 
* My comment: 
* Simple procedure, which is listing X following happy numbers, starting with given value. 
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_happy_numbers
(p_start_number NUMBER
,p_how_many NUMBER)
IS
    n_iteration_counter NUMBER;
    n_next_number NUMBER;
    v_msg_error VARCHAR2(50); 
    v_msg VARCHAR2(2000); 
    v_happy_numbers VARCHAR2(2000);
    b_is_it_happy BOOLEAN;
    
    ex_negative_number EXCEPTION;
    
    FUNCTION fn_check_happy_number
    (p_input_number NUMBER)
    RETURN BOOLEAN
    IS
        n_happy_number NUMBER;
        n_calculations NUMBER;
        n_counter NUMBER;
        b_is_sad BOOLEAN;
        b_result BOOLEAN;
        
        TYPE t_tab IS TABLE OF NUMBER;
        t_check_repeats t_tab := t_tab();
    BEGIN
        n_happy_number := p_input_number;
        n_calculations := 0;
        n_counter := 0;
    
        WHILE n_happy_number != 1 LOOP
            t_check_repeats.extend;
            n_counter := n_counter + 1;
            n_calculations := 0;
        
            FOR i IN 1 .. LENGTH(n_happy_number) LOOP
                n_calculations := n_calculations + POWER(SUBSTR(n_happy_number, i, 1), 2);
            END LOOP;
        
            n_happy_number := 0;
    
            IF n_counter != 1 THEN  
                b_is_sad := n_calculations MEMBER OF t_check_repeats;
    
                IF b_is_sad THEN
                    b_result := FALSE;
                    EXIT;
                END IF;
            END IF;
        
            t_check_repeats(n_counter) := n_calculations;
            n_happy_number := n_calculations;
        END LOOP;
    
        IF n_happy_number = 1 THEN
            b_result := TRUE;
        END IF; 
        
    RETURN b_result;
    END fn_check_happy_number;
BEGIN
    IF p_start_number < 0 THEN
        v_msg_error := '"p_start_number"';
        RAISE ex_negative_number;
    ELSIF p_how_many < 0 THEN
        v_msg_error := '"p_how_many"';
        RAISE ex_negative_number;
    END IF;

    n_iteration_counter := 0;
    n_next_number := p_start_number - 1;
    
    WHILE n_iteration_counter != p_how_many LOOP
        n_next_number := n_next_number + 1;
        b_is_it_happy := fn_check_happy_number(n_next_number);
        
        IF b_is_it_happy THEN
            n_iteration_counter := n_iteration_counter + 1;
            
            IF v_happy_numbers IS NULL THEN
                v_happy_numbers := TO_CHAR(n_next_number);
            ELSE
                v_happy_numbers := TO_CHAR(v_happy_numbers) || ', ' || n_next_number;
            END IF;
        END IF;
    END LOOP;
    
    IF p_how_many = 1 THEN
        v_msg := p_how_many || ' following happy number (include start number "' || p_start_number || '" in calcullations) is: ' || v_happy_numbers;
    ELSE
        v_msg := p_how_many || ' following happy numbers (include start number "' || p_start_number || '" in calcullations) are: ' || v_happy_numbers;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
    
EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001, 'Parameter ' || v_msg_error || ' cannot be less than 0.');
END pr_happy_numbers;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: First 20 happy numbers*/
EXECUTE pr_happy_numbers(1, 20);

/* Script result: */
20 following happy numbers (include start number "1" in calcullations) are: 1, 7, 10, 13, 19, 23, 28, 31, 32, 44, 49, 68, 70, 79, 82, 86, 91, 94, 97, 100

---

/* Test: */
EXECUTE pr_happy_numbers(532, 4);

/* Script result: */
4 following happy numbers (include start number "532" in calcullations) are: 536, 556, 563, 565

---

/* Test: */
EXECUTE pr_happy_numbers(28577, 32);

/* Script result: */
32 following happy numbers (include start number "28577" in calcullations) are: 28586, 28594, 28605, 28612, 28615, 28621, 28625, 28634, 28643, 28650, 
28651, 28652, 28658, 28666, 28685, 28704, 28717, 28723, 28732, 28738, 28740, 28755, 28771, 28778, 28783, 28787, 28789, 28798, 28801, 28810, 28837, 28856

