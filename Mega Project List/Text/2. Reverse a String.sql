/*
*
* Case: Reverse a String
* Description: Enter a string and the program will reverse it and print it out.
* 
* My comment:
* Just simple procedure.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_reverse_string
(p_input_string IN VARCHAR2)
IS
    v_reversed_string VARCHAR2(4000);
BEGIN
    FOR i IN REVERSE 1 .. LENGTH(p_input_string) LOOP
        v_reversed_string := v_reversed_string || SUBSTR(p_input_string, i, 1);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_reversed_string); 
END pr_reverse_string;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_reverse_string('Oracle Corporation');

/* Script result: */
noitaroproC elcarO

---
/* Test: */
EXECUTE pr_reverse_string('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit 
anim id est laborum.');

/* Script result: */
.murobal tse di mina tillom tnuresed aiciffo iuq apluc ni tnus ,tnediorp non tatadipuc taceacco tnis ruetpecxE .rutairap allun taiguf ue erolod mullic 
esse tilev etatpulov ni tiredneherper ni rolod eruri etua siuD .tauqesnoc odommoc ae xe piuqila tu isin sirobal ocmallu noitaticrexe durtson siuq ,mainev 
minim da mine tU .auqila angam erolod te erobal tu tnudidicni ropmet domsuie od des ,tile gnicsipida rutetcesnoc ,tema tis rolod muspi meroL

