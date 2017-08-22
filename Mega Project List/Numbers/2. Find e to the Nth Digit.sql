/*
*
* Case: Find e to the Nth Digit
* Description: Just like the previous problem, but with e instead of PI. Enter a number and have the program 
* generate e up to that many decimal places. Keep a limit to how far the program will go.
* 
* My comment:
* To resolve this case I can use SQL function EXP(1) or evaluate value of e by myself, for example as the sum of the infinite 
* series 1/n!, where n = 0 and next e iterations strive for infinity. In second version I will use recursive function to calculate n!.
* 
* Analogous to the previous case "Find PI to the Nth Digit", there will be 38 precision of digits.
* 
*/

----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

-- first version, based on built in EXP function
CREATE OR REPLACE FUNCTION fn_e_v1
(p_precision IN NUMBER) 
RETURN NUMBER
IS
	n_e NUMBER;
	
	ex_negative_number EXCEPTION;
	ex_too_big_number EXCEPTION;
BEGIN
	IF p_precision < 0 THEN 
		RAISE ex_negative_number;
	ELSIF p_precision > 38 THEN
		RAISE ex_too_big_number;
	END IF;
	
	n_e := ROUND(EXP(1), p_precision);

	RETURN n_e;
EXCEPTION
	WHEN ex_too_big_number THEN
        	RAISE_APPLICATION_ERROR(-20001,
        	'Max possible input value of parameter "precision" is 38. Value given by user: '
       		|| p_precision);
	WHEN ex_negative_number THEN
        	RAISE_APPLICATION_ERROR(-20002,
        	'Value of parameter "precision" cannot be a negative number. Value given by user: '
        	|| p_precision);
END fn_e_v1;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT fn_e_v1(38)
FROM   dual; 

/* Script result: */
2.71828182845904523536028747135266249776

----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

-- second version, sum of the infinite series
CREATE OR REPLACE FUNCTION fn_e_v2
(p_precision IN NUMBER) 
RETURN NUMBER
IS
	n_result NUMBER;
	
	ex_negative_number EXCEPTION;
	ex_too_big_number EXCEPTION;
	
	-- factorial recursive function
	FUNCTION fn_factorial
	( p_n NUMBER ) RETURN NUMBER IS
		n_result NUMBER;

	BEGIN
		IF p_n IN (0, 1) THEN
			n_result:= 1;
		ELSE
			n_result := p_n * fn_factorial(p_n - 1);
		END IF;
	RETURN n_result;
	END fn_factorial;
BEGIN
	IF p_precision < 0 THEN 
		RAISE ex_negative_number;
	ELSIF p_precision > 38 THEN
		RAISE ex_too_big_number;
	END IF;
	
	n_result := 0;
	
	FOR i IN 0 .. 35 LOOP -- start at 0, it eventuates from mathematical formula of the infinite series; 35 iterations is enough to get e
		n_result := n_result + (1/fn_factorial(i));
	END LOOP;
	
	RETURN n_result;
EXCEPTION
	WHEN ex_too_big_number THEN
        	RAISE_APPLICATION_ERROR(-20001,
        	'Max possible input value of parameter "precision" is 38. Value given by user: '
        	|| p_precision);
	WHEN ex_negative_number THEN
        	RAISE_APPLICATION_ERROR(-20002,
        	'Value of parameter "precision" cannot be a negative number. Value given by user: '
        	|| p_precision);
END fn_e_v2;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT fn_e_v2(38)
FROM   dual; 

/* Script result: */
2.71828182845904523536028747135266249776

