/*
*
* Case: Fibonacci Sequence
* Description: Enter a number and have the program generate the Fibonacci sequence to that number or to the Nth number.
*
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

CREATE OR REPLACE FUNCTION fn_fibonacci_sequence
(p_value IN NUMBER) 
RETURN NUMBER 
IS
n_result NUMBER;
BEGIN
	IF p_value < 2 THEN
		n_result := p_value;
	ELSE
		n_result := fn_fibonacci_sequence(p_value - 2) + fn_fibonacci_sequence(p_value - 1);
	END IF;
	
	RETURN n_result;
END fn_fibonacci_sequence;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT fn_fibonacci_sequence(31)
FROM   dual; 

/* Query result: */
1346269

