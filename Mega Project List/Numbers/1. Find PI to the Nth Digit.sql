/*
*
* Case: Find PI to the Nth Digit
* Description: Enter a number and have the program generate PI up to that many decimal places. Keep a limit to how far the program will go.
* 
* My comment:
* Scale in this case will be 1 and max avaliable precision will be 37. Oracle's NUMBER datatype has 38 significant digits.
* I've added an user defined exception - no matter how big number over 38 will be passed as "precision" parameter, 
* function will return 38 signs only.
* 
* To calculate value of pi, I'm basing on Arcsine Function/Inverse Sine Function.
* In my case, my parameter is 1, but it can be any other number between -1 and 1, include 0. 
* This is because the Arcsin function is undefined for arguments greater than 1 or less than -1.
* 
*/
  

----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */

CREATE OR REPLACE FUNCTION fn_pi 
(p_precision IN NUMBER) 
RETURN NUMBER
IS
  n_pi NUMBER;
  ex_too_big_number EXCEPTION;
  ex_negative_number EXCEPTION;
BEGIN
  IF p_precision > 38 THEN
    RAISE ex_too_big_number;
  ELSIF p_precision < 0 THEN 
    RAISE ex_negative_number;
  END IF;

  n_pi := ROUND(2 * (ASIN(SQRT(1 - POWER(1, 2))) + ABS(ASIN(1))), p_precision); --Arcsine Function/Inverse Sine Function, calculate pi

  RETURN n_pi;
EXCEPTION
  WHEN ex_too_big_number THEN
    RAISE_APPLICATION_ERROR(-20001,
    'Max possible input value of parameter "precision" is 38. Value given by user: '
    || p_precision);
  WHEN ex_negative_number THEN
    RAISE_APPLICATION_ERROR(-20002,
    'Value of parameter "precision" cannot be a negative number. Value given by user: '
    || p_precision);
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20999, 
    'Generic error.');
END fn_pi;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT fn_pi(38)
FROM   dual; 


/* Query result: */
3.1415926535897932384626433832795028842
