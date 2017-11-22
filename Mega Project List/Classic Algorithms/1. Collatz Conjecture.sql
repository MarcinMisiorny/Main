/*
*
* Case: Collatz Conjecture
* Description: Start with a number n > 1. Find the number of steps it takes to reach one using the following process: If n is even, 
* divide it by 2. If n is odd, multiply it by 3 and add 1.
* 
* My comment:
* Smiple to implement algorithm.
*
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_collatz_conjecture
(p_input_number NUMBER)
IS
    n_calculations NUMBER;
    v_result VARCHAR2(2000);
    
    ex_negative_number EXCEPTION;
BEGIN
    IF p_input_number < 0 THEN 
      RAISE ex_negative_number;
    END IF;

    n_calculations := p_input_number;
    v_result := p_input_number;
   
    WHILE n_calculations != 1 LOOP
        IF MOD(n_calculations, 2) = 0 THEN
            n_calculations := n_calculations / 2;
        ELSE
            n_calculations := 3 * n_calculations + 1;
        END IF;
           
        v_result := v_result || ', ' || n_calculations;
    END LOOP;
   
    DBMS_OUTPUT.PUT_LINE(v_result);
EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001, 'Input number cannot be a negative number.');
END pr_collatz_conjecture;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_collatz_conjecture(15);

/* Script result: */
15, 46, 23, 70, 35, 106, 53, 160, 80, 40, 20, 10, 5, 16, 8, 4, 2, 1

---

/* Test: */
EXECUTE pr_collatz_conjecture(53152);

/* Script result: */
53152, 26576, 13288, 6644, 3322, 1661, 4984, 2492, 1246, 623, 1870, 935, 2806, 1403, 4210, 2105, 6316, 3158, 1579, 4738, 2369, 7108, 3554, 1777, 
5332, 2666, 1333, 4000, 2000, 1000, 500, 250, 125, 376, 188, 94, 47, 142, 71, 214, 107, 322, 161, 484, 242, 121, 364, 182, 91, 274, 137, 412, 
206, 103, 310, 155, 466, 233, 700, 350, 175, 526, 263, 790, 395, 1186, 593, 1780, 890, 445, 1336, 668, 334, 167, 502, 251, 754, 377, 1132, 566, 
283, 850, 425, 1276, 638, 319, 958, 479, 1438, 719, 2158, 1079, 3238, 1619, 4858, 2429, 7288, 3644, 1822, 911, 2734, 1367, 4102, 2051, 6154, 3077, 
9232, 4616, 2308, 1154, 577, 1732, 866, 433, 1300, 650, 325, 976, 488, 244, 122, 61, 184, 92, 46, 23, 70, 35, 106, 53, 160, 80, 40, 20, 10, 5, 16, 
8, 4, 2, 1

