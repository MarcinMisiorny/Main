/*
* 
* Case: Tax calculator
* Description: Asks the user to enter a cost and either a country or state tax. It then returns the tax plus the total cost with tax.
* 
* My comment:
* Simple procedure. 
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_tax_calculator
(p_amount IN NUMBER
,p_tax_rate IN NUMBER
,p_unit IN VARCHAR2 DEFAULT 'NETTO')
IS
    n_final_amount NUMBER;
    n_calculated_tax NUMBER;
    n_tax_rate NUMBER;
    v_msg_error VARCHAR2(50);
   
    ex_wrong_unit EXCEPTION;
    ex_negative_number EXCEPTION;
BEGIN
    IF p_amount < 0 THEN
        v_msg_error := '"p_amount"';
        RAISE ex_negative_number;
    ELSIF p_tax_rate < 0 THEN
        v_msg_error := '"p_tax_rate"';
        RAISE ex_negative_number;
    END IF;
    
    IF p_unit NOT IN ('BRUTTO', 'NETTO') THEN
        RAISE ex_wrong_unit;
    END IF;
   
    IF p_tax_rate > 1 THEN
        n_tax_rate := p_tax_rate / 100;
    ELSE
        n_tax_rate := p_tax_rate;
    END IF;
   
    IF p_unit = 'BRUTTO' THEN
        n_final_amount := ROUND(p_amount / (1 + n_tax_rate), 2);
        n_calculated_tax := p_amount - n_final_amount;
    ELSE
        n_final_amount := ROUND(p_amount * (1 + n_tax_rate), 2);
        n_calculated_tax := n_final_amount - p_amount;
    END IF;
   
    IF p_unit = 'BRUTTO' THEN
        DBMS_OUTPUT.PUT_LINE('Brutto amount: ' || p_amount);
        DBMS_OUTPUT.PUT_LINE('Netto amount: ' || n_final_amount);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Netto amount: ' || n_final_amount);
        DBMS_OUTPUT.PUT_LINE('Brutto amount: ' || p_amount);
    END IF;
   
    DBMS_OUTPUT.PUT_LINE('Tax rate: ' || n_tax_rate * 100 ||'%');
    DBMS_OUTPUT.PUT_LINE('Tax amount: ' || n_calculated_tax);
EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001, 'Parameter ' || v_msg_error || ' cannot be less than 0.');
    WHEN ex_wrong_unit THEN
        RAISE_APPLICATION_ERROR(-20002, 'Incorrect unit. Avaliable: ''BRUTTO'', ''NETTO''.');
END pr_tax_calculator;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_tax_calculator(1000, 23);

/* Script result: */
Netto amount: 1230
Brutto amount: 1000
Tax rate: 23%
Tax amount: 230

---

/* Test: */
EXECUTE pr_tax_calculator(4528.63, 8, 'BRUTTO');

/* Script result: */
Brutto amount: 4528,63
Netto amount: 4193,18
Tax rate: 8%
Tax amount: 335,45

