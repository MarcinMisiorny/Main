/* 
* 
* Case: Fibonacci Sequence
* Description: Enter a number and have the program generate the Fibonacci sequence to that number or to the Nth number.
* 
* My comment:
* I additionally added calculated sequence and sum of elements - I think, that is more interesting solution.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */  

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_fibonacci_sequence
(p_n_value IN NUMBER)
IS
	ex_negative_number EXCEPTION;
	
	-- main calculating recursive function
	FUNCTION fn_calc_fibonacci_sequence
	(p_element IN NUMBER) 
	RETURN NUMBER 
	IS
		n_result NUMBER;
	BEGIN
		IF p_element < 2 THEN
			n_result := p_element;
		ELSE
			n_result := fn_calc_fibonacci_sequence(p_element - 2) + fn_calc_fibonacci_sequence(p_element - 1);
		END IF;
		
		RETURN n_result;
	END;
	
	-- function, which creates string with sequence's elements
	FUNCTION fn_create_sequence
	(p_element IN NUMBER)
	RETURN VARCHAR2 IS
		n_result VARCHAR2(500);
	BEGIN
		FOR i IN 1 .. p_element LOOP
			IF n_result IS NOT NULL THEN
				n_result := n_result || ', ' || LTRIM(TO_CHAR(fn_calc_fibonacci_sequence(i)));
			ELSE
				n_result := LTRIM(TO_CHAR(fn_calc_fibonacci_sequence(i)));
			END IF;
		END LOOP;
	
		RETURN n_result;
	END;
	
	-- function, which returns sum of sequence elements
	FUNCTION fn_sum_sequence_elements
	(p_element IN NUMBER)
	RETURN NUMBER IS
		n_result NUMBER;
	BEGIN
		n_result := 0;
	
		FOR i IN 1 .. p_element LOOP
			n_result := n_result + fn_calc_fibonacci_sequence(i);
		END LOOP;
	
		RETURN n_result;
	END;
BEGIN
	IF p_n_value < 0 THEN 
		RAISE ex_negative_number;
	END IF;

	DBMS_OUTPUT.PUT_LINE('List of Fibonacci numbers for n = ' || p_n_value || ' is: ' || fn_create_sequence(p_n_value));
	DBMS_OUTPUT.PUT_LINE('Fibonacci sequence for n = ' || p_n_value || ' is: ' || TO_CHAR(fn_calc_fibonacci_sequence(p_n_value)));
	DBMS_OUTPUT.PUT_LINE('Sum of Fibonacci numbers for n = ' || p_n_value || ' is: ' || TO_CHAR(fn_sum_sequence_elements(p_n_value)));
EXCEPTION
	WHEN ex_negative_number THEN
		RAISE_APPLICATION_ERROR(-20001,
		'Value of parameter "precision" should not be a negative number. Value given by user: '
		|| p_n_value);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        	RAISE_APPLICATION_ERROR(-20001,
        	'Value of parameter "precision" should not be a negative number. Value given by user: '
        	|| p_n_value);
END pr_fibonacci_sequence;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_fibonacci_sequence(20);

/* Script result: */
List of Fibonacci numbers for n = 20 is: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765
Fibonacci sequence for n = 20 is: 6765
Sum of Fibonacci numbers for n = 20 is: 17710

