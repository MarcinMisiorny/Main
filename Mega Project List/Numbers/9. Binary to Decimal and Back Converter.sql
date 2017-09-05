/*
* 
* Case: Binary to Decimal and Back Converter
* Description: Develop a converter to convert a decimal number to binary or a binary number to its decimal equivalent.
* 
* My comment:
* Two simple converting functions.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

--Binary to Decimal
CREATE OR REPLACE FUNCTION fn_bin2dec 
(p_input_bin IN VARCHAR2) 
RETURN NUMBER 
IS
	n_result NUMBER;
	v_current_digit CHAR(1);
	n_current_digit_dec NUMBER;
	n_counter NUMBER;
	
	ex_wrong_length EXCEPTION;
	ex_wrong_number EXCEPTION;
BEGIN
	IF LENGTH(p_input_bin) != 8 THEN
		RAISE ex_wrong_length;
	END IF;

	n_result := 0;
	n_counter := 0;
	
	FOR i IN 1 .. LENGTH(p_input_bin) LOOP
		n_counter := n_counter + 1;
		v_current_digit := SUBSTR(p_input_bin, i, 1);
		IF v_current_digit > 1 THEN
			RAISE ex_wrong_number;
		ELSE
			n_current_digit_dec := TO_NUMBER(v_current_digit);
			n_result := (n_result * 2) + n_current_digit_dec;
		END IF;
	END LOOP;
  
RETURN n_result;
EXCEPTION
	WHEN ex_wrong_length THEN
		RAISE_APPLICATION_ERROR(-20001, 'Length of input number must be equal 8. Current length: ' || LENGTH(p_input_bin));
	WHEN ex_wrong_number THEN
		RAISE_APPLICATION_ERROR(-20002, 'The binary number must consists only 0 and 1. Found "' || v_current_digit || '" on position ' || n_counter);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
END fn_bin2dec;
/

--Decimal to Binary
CREATE OR REPLACE FUNCTION fn_dec2bin 
(p_input_dec IN NUMBER) 
RETURN VARCHAR2 
IS
	v_binary_value VARCHAR2(64);
	v_temp NUMBER;
	
	ex_negative_number EXCEPTION;
	ex_too_big_number EXCEPTION;
	ex_wrong_number EXCEPTION;
BEGIN
	IF p_input_dec < 1 THEN
		RAISE ex_negative_number;
	ELSIF p_input_dec > 255 THEN
		RAISE ex_too_big_number;
	ELSIF INSTR(TO_CHAR(p_input_dec), ',') > 0 THEN
		RAISE ex_wrong_number;
	END IF;

	v_temp := p_input_dec;
	
	WHILE (v_temp > 0) LOOP
		v_binary_value := MOD(v_temp, 2) || v_binary_value;
		v_temp := TRUNC(v_temp / 2);
	END LOOP;
	
	v_binary_value := LPAD(v_binary_value, 8, '0');
RETURN v_binary_value;
EXCEPTION
	WHEN ex_negative_number THEN
		RAISE_APPLICATION_ERROR(-20001, 'Input digit cannot be less or equal 0.  Value given by User: ' || p_input_dec);
	WHEN ex_too_big_number THEN
		RAISE_APPLICATION_ERROR(-20002, 'Input digit cannot be greater than 255.  Value given by User: ' || p_input_dec);
	WHEN ex_wrong_number THEN
		RAISE_APPLICATION_ERROR(-20003, 'Input digit must be an integer.  Number given by User: ' || p_input_dec);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
END fn_dec2bin;
/

----------------------------------------------------------------------------------------------------------------------------------------------

--Binary to Decimal
/* Test: */
SELECT	fn_bin2dec('01000111')
FROM	dual;

/* Script result: */
71

---
--Decimal to Binary
/* Test: */
SELECT	fn_dec2bin(31)
FROM	dual;

/* Script result: */
00011111

