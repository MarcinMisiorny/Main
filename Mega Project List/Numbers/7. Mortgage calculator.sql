/*
* 
* Case: Mortgage Calculator
* Description: Calculate the monthly payments of a fixed term mortgage over given Nth terms at a given interest rate. Also figure out 
* how long it will take the user to pay back the loan. For added complexity, add an option for users to select the compounding interval 
* (Monthly, Weekly, Daily, Continually).
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_mortgage_calculator
(n_amount_borrowed NUMBER
,n_interest_rate NUMBER
,n_number_of_payments NUMBER)
IS
	n_interest_rate_val NUMBER;
	n_number_of_payments_val NUMBER;
	v_payoff_date VARCHAR2(20);
	n_result NUMBER;
	v_total_payments VARCHAR2(20);
	v_total_interest VARCHAR2(20);
	v_error_msg VARCHAR2(20);
	v_error_parameter_msg VARCHAR2(10);
	
	ex_negative_number EXCEPTION;
BEGIN
	IF n_amount_borrowed < 1 THEN
		v_error_msg := '"amount borrowed"';
		v_error_parameter_msg := TO_CHAR(n_amount_borrowed);
		RAISE ex_negative_number;
	ELSIF n_interest_rate < 1 THEN
		v_error_msg := '"interest rate"';
		v_error_parameter_msg := TO_CHAR(n_interest_rate);
		RAISE ex_negative_number;
	ELSIF n_number_of_payments < 1 THEN
		v_error_msg := '"number of payments"';
		v_error_parameter_msg := TO_CHAR(n_number_of_payments);
		RAISE ex_negative_number;
	END IF;
	

	n_interest_rate_val := n_interest_rate / 100 / 12; 
	n_number_of_payments_val := n_number_of_payments * 12; 
	v_payoff_date := TO_CHAR(SYSDATE + (30 * ((12 * 30) + 5)), 'MON-YYYY');
	
	n_result := ROUND(n_amount_borrowed * n_interest_rate_val * ((POWER((1 + n_interest_rate_val), n_number_of_payments_val)) / (POWER((1 + n_interest_rate_val), n_number_of_payments_val) - 1)) ,2);
	
	v_total_payments := TRIM(TO_CHAR(ROUND(n_result * n_number_of_payments_val, 2), '999G999G999D99'));
	v_total_interest := TRIM(TO_CHAR(ROUND((n_result * n_number_of_payments_val) - n_amount_borrowed, 2), '999G999G999D99')) ;
	
	DBMS_OUTPUT.PUT_LINE('Monthly pay: ' || TRIM(TO_CHAR(n_result, '999G999G999D99')) || CHR(13)
					     || 'Total of ' || n_number_of_payments_val || ' mortgage payments: ' || v_total_payments || CHR(13)
					     || 'Total interest: ' || v_total_interest || CHR(13)
					     || 'Mortgage payoff date: ' || v_payoff_date || CHR(13)
					     || CHR(13)
					     || 'Payment per week: ' || TRIM(TO_CHAR(ROUND(n_result / 4, 2), '999G999G999D99')) || CHR(13)
					     || 'Payment per year: ' || TRIM(TO_CHAR(ROUND(n_result * 12, 2), '999G999G999D99')));

EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001,
        'Parameter ' || v_error_msg || ' cannot be less than 1. Value given by User: ' || v_error_parameter_msg);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
END pr_mortgage_calculator;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_mortgage_calculator(300000, 5, 30);

/* Script result: */
Monthly pay: 1,610.46
Total of 360 mortgage payments: 579,765.60
Total interest: 279,765.60
Mortgage payoff date: AUG-2047

Payment per week: 402.62
Payment per year: 19,325.52

