/*
*
* Case: Count Vowels
* Description: Enter a string and the program counts the number of vowels in the text. For added complexity have it report a sum of each vowel found.
* 
* My comment:
* Simple procedure with array - when done, shows counts.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_vovels_count 
(p_input_string IN VARCHAR2)
IS
    TYPE t_vowels IS TABLE OF NUMBER INDEX BY VARCHAR2(1);
    t_vowels_count t_vowels;
    v_ldx VARCHAR2(1);
begin
    FOR i IN 1 .. LENGTH(p_input_string) LOOP
        IF SUBSTR(p_input_string, i, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') THEN
            IF t_vowels_count.EXISTS(SUBSTR(p_input_string, i, 1)) THEN
                t_vowels_count(SUBSTR(p_input_string, i, 1)) := t_vowels_count(SUBSTR(p_input_string, i, 1)) + 1;
            ELSE
                t_vowels_count(SUBSTR(p_input_string, i, 1)) := 1;
            END IF;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('String: ' || p_input_string);
    DBMS_OUTPUT.PUT_LINE('Vowels count:');
    
    v_ldx := t_vowels_count.first;
    
    WHILE v_ldx IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(v_ldx || ': ' || t_vowels_count(v_ldx));
        
        v_ldx := t_vowels_count.next(v_ldx);  
    END LOOP;     
END pr_vovels_count;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_vovels_count('Oracle');

/* Script result: */
String: Oracle
Vowels count:
O: 1
a: 1
e: 1

---

/* Test: */
EXECUTE pr_vovels_count('Honorificabilitudinitatibus');

/* Script result: */
String: Honorificabilitudinitatibus
Vowels count:
a: 2
i: 7
o: 2
u: 2

---

/* Test: */
EXECUTE pr_vovels_count('Pneumonoultramicroscopicsilicovolcanoconiosis');

/* Script result: */
String: Pneumonoultramicroscopicsilicovolcanoconiosis
Vowels count:
a: 2
e: 1
i: 6
o: 9
u: 2
