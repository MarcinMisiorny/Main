/*
* 
* Case: Factorial Finder
* Description: The Factorial of a positive integer, n, is defined as the product of the sequence n, n-1, n-2, ...1 and the factorial of zero, 
* 0, is defined as being 1. Solve this using both loops and recursion.
* 
* My comment:
* Simple procedure and function. 
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_factorial
(p_value NUMBER)
RETURN NUMBER
IS
    n_factor NUMBER;
    n_count NUMBER;
    n_result NUMBER;
BEGIN
    n_factor := p_value;
    n_count := p_value;
    n_result := 1;
    
    FOR i IN 1 .. n_count LOOP
        n_result := n_result * n_factor;
        n_factor := n_factor - 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(p_value || '! = ' || n_result);
END pr_factorial;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_factorial(5);

/* Script result: */
5! = 120

---

/* Test: */
EXECUTE pr_factorial(12);

/* Script result: */
12! = 479001600

----------------------------------------------------------------------------------------------------------------------------------------------

/* Recursive version */

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_factorial
(p_value NUMBER)
RETURN NUMBER
IS
    n_result NUMBER;
BEGIN
    IF p_value <= 1 THEN
        n_result := 1;
    ELSE
        n_result := p_value * fn_factorial(p_value - 1);
    END IF;
	
RETURN n_result;
END fn_factorial;
/

----------------------------------------------------------------------------------------------------------------------------------------------
	
/* Test: */
SELECT   fn_factorial(5) 
FROM     dual;

/* Script result: */
120

---

/* Test: */
SELECT   fn_factorial(15) 
FROM     dual;

/* Script result: */
1307674368000

