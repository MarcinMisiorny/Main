/*
* 
* Case: Calculator
* Description: A simple calculator to do basic operators. Make it a scientific calculator for added complexity.
* 
* My comment:
* It's hard to make good calculator without graphical interface, so I made simple calculator as function - in a procedural languages like PL/SQL, 
* complex calculator is IMHO a triumph of form over content and there is no need to do this more complexity.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_calc
(n_first_number NUMBER
,v_operation VARCHAR2
,n_second_number NUMBER)
RETURN NUMBER
IS
	v_result NUMBER;
BEGIN
	IF v_operation = '+' THEN
		v_result := n_first_number + n_second_number;
	ELSIF v_operation = '-'  THEN
		v_result := n_first_number - n_second_number;
	ELSIF v_operation = '*'  THEN
		v_result := n_first_number * n_second_number;
	ELSIF v_operation = '/'  THEN
		v_result := n_first_number / n_second_number;
	ELSIF v_operation = 'MOD'  THEN
		v_result := MOD(n_first_number, n_second_number);
	ELSIF v_operation = 'POWER'  THEN
		v_result := POWER(n_first_number, n_second_number);
	ELSIF v_operation = 'LOG'  THEN
		v_result := LOG(n_first_number, n_second_number);
	END IF;
RETURN v_result;
END fn_calc;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT	fn_calc(2,'+',2)
FROM	dual;

/* Script result: */
4

---
/* Test: */
SELECT	fn_calc(351,'POWER',7)
FROM	dual;

/* Script result: */
656371650784449951

