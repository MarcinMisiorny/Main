/*
* 
* Case: Prime Factorization
* Description: Have the user enter a number and find all Prime Factors (if there are any) and display them.
* 
* My comment:
* Fast algorithm to find prime factors of a number. 
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_prime_factorization
(p_input IN NUMBER)
IS
	n_temp_input NUMBER; 
	n_p NUMBER; 
	v_result VARCHAR2(2000);
	
	ex_negative_number EXCEPTION;
	ex_too_low_number EXCEPTION;
BEGIN
	IF p_input <= 0 THEN
		RAISE ex_negative_number; 
	ELSIF p_input < 2 THEN
		RAISE ex_too_low_number;
	END IF;
	
	n_temp_input := p_input; 
	n_p := 2;

	WHILE n_temp_input >= POWER(n_p, 2) LOOP -- prime factorization algorithm on the p_input copy - function parameter cannot be used as an assignment target (PLS-00363)
		IF MOD (n_temp_input, n_p) = 0 THEN
			IF v_result IS NULL THEN
				v_result := TO_CHAR(n_p);
			ELSE
				v_result := v_result || ' * ' || TO_CHAR(n_p);
			END IF;
			n_temp_input := n_temp_input/n_p;
		ELSE
			n_p := n_p + 1;
		END IF;
	END LOOP;
	
	IF v_result IS NULL THEN
		v_result := 'List of prime factors for ' || p_input || ' is: ' || TO_CHAR(n_temp_input) || ', it''s a prime number.';
	ELSE
		v_result := 'List of prime factors for ' || p_input || ' is: ' || v_result || ' * ' || TO_CHAR(n_temp_input);
	END IF;
	
	 DBMS_OUTPUT.PUT_LINE(v_result);
EXCEPTION
	WHEN ex_negative_number THEN
		RAISE_APPLICATION_ERROR(-20001,
		'Input parameter cannot be a negative number. Value given by user: '
		|| p_input);
	WHEN ex_too_low_number THEN
		RAISE_APPLICATION_ERROR(-20002,
		'Input parameter cannot be less than 2. Value given by user: '
		|| p_input);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
END pr_prime_factorization;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_prime_factorization(330);

/* Script result: */
List of prime factors for 330 is: 2 * 3 * 5 * 11

---
/* Test: */
EXECUTE pr_prime_factorization(456123753553);

/* Script result: */
List of prime factors for 456123753553 is: 13 * 881 * 1811 * 21991

---
/* Test: */
EXECUTE pr_prime_factorization(2017);

/* Script result: */
List of prime factors for 2017 is: 2017, it's a prime number.

