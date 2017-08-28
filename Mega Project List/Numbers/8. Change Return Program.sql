/*
* 
* Case: Change Return Program
* Description: The user enters a cost and then the amount of money given. The program will figure out the change and the number 
* of quarters, dimes, nickels, pennies needed for the change.
* 
* My comment:
* Bills are expressed in polish currency [PLN], except 500 PLN banknote - it's hard to receive, not only in shops, but also in the banks. 
* 
* I could show result as simple list with repetitions, for example: 200, 200, 50, 20, 10, 10, 0.10, 0.02 but this result is not satisfying me.
* I wanted to put every banknote to varray/nested table/associative array, count in loop distinct elements and show it to User as 
* "count x banknote" result, but sadly there is no "regexp_count like" function for collections in PL/SQL. I've used my author's solution, 
* based on SQL and recursion (cursor c_parsing) - working with collections could be in this case a lot more laborious.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_change_return
(n_cost NUMBER
,n_amount_given NUMBER)
IS
	CURSOR c_parsing(p_input_string VARCHAR2) IS
	SELECT	TO_NUMBER(banknote) AS banknote
			,COUNT(banknote) AS quantity
	FROM(SELECT	TRIM(regexp_substr(p_input_string, '[^;]+', 1, LEVEL)) AS banknote
		 FROM	dual
		 CONNECT BY INSTR(p_input_string, ';', 1, LEVEL - 1) > 0)
	GROUP BY banknote
	ORDER BY banknote DESC;
	
	n_amount NUMBER;
	v_result VARCHAR2(1000);
	v_banknote_formated VARCHAR2(5);
	v_error_msg VARCHAR2(20);
	v_error_parameter_msg VARCHAR2(10);
	
	TYPE bills IS VARRAY(14) OF NUMBER;
	n_varr_bill bills; 	
    
	ex_negative_number EXCEPTION;
	ex_wrong_amount EXCEPTION;
BEGIN
	IF n_cost < 0.01 THEN
		v_error_msg := '"cost"';
		v_error_parameter_msg := TO_CHAR(n_cost);
		RAISE ex_negative_number;
	ELSIF n_amount_given < 0.01 THEN
		v_error_msg := '"amount given"';
		v_error_parameter_msg := TO_CHAR(n_amount_given);
		RAISE ex_negative_number;
	END IF;
	
	IF n_cost > n_amount_given THEN
		RAISE ex_wrong_amount;
	ELSIF n_cost = n_amount_given THEN
		DBMS_OUTPUT.PUT_LINE('You gave good amount, there is no change to receive.');
	ELSE	
		n_amount := n_amount_given - n_cost;
		
		n_varr_bill := bills(200, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01); -- fill array with bills
		
		WHILE n_amount != 0 LOOP
			FOR i IN n_varr_bill.FIRST .. n_varr_bill.LAST LOOP
				IF n_varr_bill(i) <= n_amount THEN
					IF v_result IS NULL THEN
						v_result := n_varr_bill(i);
					ELSE
						v_result := v_result || ';' || n_varr_bill(i);
					END IF;
					n_amount := n_amount - n_varr_bill(i);
					EXIT;
				END IF;
			END LOOP;
		END LOOP;
	
	
		DBMS_OUTPUT.PUT_LINE('The following is the change you would receive:' || CHR(13));
		
		FOR i IN c_parsing(v_result) LOOP
			IF i.banknote < 1 THEN
				v_banknote_formated := TO_CHAR(i.banknote, 'FM0.90'); --formatting coins with leading zero
			ELSE
				v_banknote_formated := TO_CHAR(i.banknote);
			END IF;
			
			DBMS_OUTPUT.PUT_LINE(i.quantity || 'x ' || v_banknote_formated || ' PLN');
		END LOOP;
	END IF;

EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001,
        'Parameter ' || v_error_msg || ' cannot be less than 0.01. Value given by User: ' || v_error_parameter_msg);
	WHEN ex_wrong_amount THEN
		RAISE_APPLICATION_ERROR(-20002,
		'Your cost (' || n_cost || ' PLN) is greater than your given amount (' || n_amount_given ||' PLN).');
END pr_change_return;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_change_return(299.99, 300);

/* Script result: */
The following is the change you would receive:
1x 0.01 PLN

---
/* Test: */
EXECUTE pr_change_return(1351.55, 1500);

/* Script result: */
The following is the change you would receive:
1x 100 PLN
2x 20 PLN
1x 5 PLN
1x 2 PLN
1x 1 PLN
2x 0.20 PLN
1x 0.05 PLN

