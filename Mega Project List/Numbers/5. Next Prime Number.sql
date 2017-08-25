/*
* 
* Case: Next Prime Number
* Description: Have the program find prime numbers until the user chooses to stop asking for the next one.
* 
* My comment:
* I need to have a popup window, where user should ask for next prime number to find. PL/SQL is executed inside the database engine, 
* and the database engine has no access to the popup window, except one window where "&" or ":" signs are in the code. Those means, that is
* a bind variable - the tool (SQL*Plus, SQL Developer or something else) parses over the PL/SQL block and sees the &-Signs/:-Signs, 
* so it asks what to replace them with. Once the input is given, the PL/SQL-Block - including the entered values - is given to the database 
* for execution.). I can't do this in pure PL/SQL - I would need to create some front-end program, that will first collect the values 
* and then sends them to the database.
* 
* I've needed a small update of this case - instead of popup window, I've turn requirements in different form - formal parameters 
* of procedure. User should input from which number program should start and how much prime numbers he want receive.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 
	
CREATE OR REPLACE PROCEDURE pr_prime_list
(n_start_number IN NUMBER
,n_how_many_primes IN NUMBER
)
IS
	n_start_number_val NUMBER;
	n_counter NUMBER;
	v_msg VARCHAR2(500);
	v_result VARCHAR2(4000);

	-- function finding prime numbers
	FUNCTION fn_is_prime
	(p_input_number NUMBER)
	RETURN BOOLEAN
	IS
		n_flag NUMBER;
		v_return BOOLEAN;
		
		ex_negative_number EXCEPTION;
	BEGIN
		n_flag := 1;
		
		IF p_input_number <= 0 THEN
			RAISE ex_negative_number;
		ELSIF p_input_number < 2 THEN
			v_return := FALSE;
		END IF;
	
		FOR i IN 2 .. FLOOR(p_input_number / 2) LOOP
			IF MOD (p_input_number, i) = 0 THEN
				n_flag := 0;
				EXIT;
			END IF;
		END LOOP;
	
		IF n_flag = 1 THEN
			v_return := TRUE;
		ELSE
			v_return := FALSE;
		END IF;
		
	RETURN v_return;
	EXCEPTION
		WHEN ex_negative_number THEN
			RAISE_APPLICATION_ERROR(-20001,
			'Input number cannot be a negative number. Value given by user: '
			|| p_input_number);
	END;
BEGIN
	n_start_number_val := n_start_number;
	n_counter := 0;

	WHILE n_counter != n_how_many_primes LOOP
		n_start_number_val := n_start_number_val + 1;
		IF fn_is_prime(n_start_number_val) THEN
			IF v_result IS NULL THEN
				v_result := TO_CHAR(n_start_number_val);
			ELSE
				v_result := v_result || ', ' || TO_CHAR(n_start_number_val);
			END IF;
			
			n_counter := n_counter + 1;
		END IF;
	END LOOP;

	IF n_how_many_primes = 1 THEN
		v_msg := 'Next prime number after ' || TO_CHAR(n_start_number) || ' is: ' ;
	ELSE
		v_msg := TO_CHAR(n_how_many_primes) || ' next prime numbers after ' || TO_CHAR(n_start_number) || ' are: ' ;
	END IF;

	DBMS_OUTPUT.PUT_LINE(v_msg || v_result);
END pr_prime_list;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_prime_list(1,20);

/* Script result: */
20 next prime numbers after 1 are: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71

---
/* Test: */
EXECUTE pr_prime_list(8891,34);

/* Script result: */
34 next prime numbers after 8891 are: 8893, 8923, 8929, 8933, 8941, 8951, 8963, 8969, 8971, 8999, 9001, 9007, 9011, 9013, 9029, 9041, 9043, 
9049, 9059, 9067, 9091, 9103, 9109, 9127, 9133, 9137, 9151, 9157, 9161, 9173, 9181, 9187, 9199, 9203

---
/* Test: */
EXECUTE pr_prime_list(452152853,1);

/* Script result: */
Next prime number after 452152853 is: 452152903

