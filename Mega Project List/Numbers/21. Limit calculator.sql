/*
* 
* Case: Limit calculator
* Description: Ask the user to enter f(x) and the limit value, then return the value of the limit statement. 
* Optional: Make the calculator capable of supporting infinite limits.
* 
* My comment: 
* Only for few simple limits [maybe later I'll do advanced version].
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution (simplied version): */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_limit_calculator
(p_limit_value NUMBER
,p_equation VARCHAR2)
IS
    v_replaced_equation VARCHAR2(500);
    n_result NUMBER;

BEGIN
    v_replaced_equation := REGEXP_REPLACE(p_equation, '(\d+)x', '\1*'||p_limit_value);
    v_replaced_equation := REPLACE(REPLACE(v_replaced_equation, 'x', p_limit_value), '^', '**');
    
    EXECUTE IMMEDIATE
    'BEGIN :n_result := ' || v_replaced_equation || '; END;'
    USING OUT n_result;

    DBMS_OUTPUT.PUT_LINE('Equation result with limit of ' || p_limit_value || ' is: ' || n_result);
END pr_limit_calculator;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_limit_calculator(3, '(2x+5x^2-8x-13x)/(x^2-x)');

/* Script result: */
Equation result with limit of 3 is: -2

---
/* Test: */
EXECUTE pr_limit_calculator(4, '2x^4-x^2-8x');

/* Script result: */
Equation result with limit of 4 is: 464

