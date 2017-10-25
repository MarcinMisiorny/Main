/*
* 
* Case: Coin Flip Simulation
* Description: Write some code that simulates flipping a single coin however many times the user decides. The code should record the outcomes 
* and count the number of tails and heads.
* 
* My comment: 
* Simple procedure, based on built in DBMS_RANDOM package.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_coin_flip_simulator
(n_throws NUMBER)
IS
    n_throw NUMBER;
    n_heads NUMBER;
    n_tail NUMBER;
BEGIN
    n_throw := 0;
    n_heads := 0;
    n_tail := 0;
   
    FOR i IN 1 .. n_throws LOOP
        n_throw := ROUND(DBMS_RANDOM.VALUE);
       
        IF n_throw = 0 THEN
            n_heads := n_heads + 1;
        ELSE
            n_tail := n_tail + 1;
        END IF;
    END LOOP;
   
    DBMS_OUTPUT.PUT_LINE('For ' || n_throws || ' throws, there was ' || n_heads || ' heads and ' || n_tail || ' tails.');
END pr_coin_flip_simulator;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_coin_flip_simulator(500);

/* Script result: */
For 500 throws, there was 243 heads and 257 tails.

---

/* Test: */
EXECUTE pr_coin_flip_simulator(100000);

/* Script result: */
For 100000 throws, there was 50212 heads and 49788 tails.

---

/* Test: */
EXECUTE pr_coin_flip_simulator(10000000);

/* Script result: */
For 10000000 throws, there was 4999952 heads and 5000048 tails.

