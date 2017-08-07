/*
*
* Case: Find PI to the Nth Digit
* Description: Enter a number and have the program generate PI up to that many decimal places. Keep a limit to how far the program will go.
* 
* My comment:
* Scale in this case will be 1 and max avaliable precision will be 37. NUMBER datatype in Oracle has 38 significant digits.
* I've added an user defined exception - no matter how big number over 38 will be passed as "precision" parameter, function will return 38 signs only.
* 
* To calculate value of pi, I'm basing on Arcsine Function/Inverse Sine Function.
* In my case my parameter is 1, but it can be any other number between -1 and 1. This is because the Arcsin function is undefined for arguments greater than 1 or less than -1.
* 
*/
  

----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */

CREATE OR REPLACE FUNCTION pi 
(precision IN NUMBER) 
RETURN NUMBER
IS
  n_pi NUMBER;
  ex_too_big_number EXCEPTION;
  ex_negative_number EXCEPTION;
BEGIN
    IF precision > 38 THEN
		RAISE ex_too_big_number;
    ELSIF precision < 0 THEN 
		RAISE ex_negative_number;
    END IF;

    SELECT ROUND(2 * ( ASIN(SQRT(1 - POWER(1, 2))) + ABS(ASIN(1))), precision) --Arcsine Function/Inverse Sine Function, calculate pi
    INTO   n_pi
    FROM   dual;

    RETURN n_pi;
EXCEPTION
  WHEN ex_too_big_number THEN
	RAISE_APPLICATION_ERROR(-20001,
    'Max avaliable input value of parameter "precision" is 38. Value given by you: '
    || precision);
  WHEN ex_negative_number THEN
    RAISE_APPLICATION_ERROR(-20002,
    'Value of "precision" parameter cannot be a negative number. Value given by you: '
    || precision);
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20999, 
    'Generic error.');
END;

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT pi(38)
FROM   dual; 


/* Query result: */
3.1415926535897932384626433832795028842
