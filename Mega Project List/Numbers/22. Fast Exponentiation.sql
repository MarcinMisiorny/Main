/*
* 
* Case: Fast Exponentiation
* Description: Ask the user to enter 2 integers a and b and output a^b (i.e. pow(a,b)) in O(lg n) time complexity.
* 
* My comment: 
* Just simple function.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_exponentiation 
(p_first_number NUMBER
,p_second_number NUMBER)
RETURN NUMBER
IS
    n_result NUMBER;
BEGIN
    n_result := 0;
    
    IF p_second_number = 0 THEN
        RETURN 1;
    END IF;
    
    IF MOD(p_second_number, 2) != 0 THEN
        n_result := p_first_number * fn_exponentiation(p_first_number, p_second_number - 1);
    ELSE
        n_result := fn_exponentiation(p_first_number, p_second_number / 2);
        n_result := n_result * n_result;
    END IF;
    
RETURN n_result;
END fn_exponentiation;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT  fn_exponentiation(4,5)
FROM    dual;

/* Script result: */
1024

---

/* Test: */
SELECT  fn_exponentiation(9,12)
FROM    dual;

/* Script result: */
282429536481

