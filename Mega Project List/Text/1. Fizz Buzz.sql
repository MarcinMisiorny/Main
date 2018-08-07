/*
*
* Case: Fizz Buzz
* Description: Write a program that prints the numbers from 1 to 100. But for multiples of three print “Fizz” instead of the number 
* and for the multiples of five print “Buzz”. For numbers which are multiples of both three and five print “FizzBuzz”.
* 
* My comment:
* Just simple procedure.
* 
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_fizzbuzz 
IS
BEGIN
    FOR i IN 1 .. 100 LOOP
        IF MOD(i,3) = 0 THEN
            IF MOD(i,5) = 0 THEN
                DBMS_OUTPUT.PUT_LINE(i || ': FizzBuzz');
            ELSE
                DBMS_OUTPUT.PUT_LINE(i || ': Fizz');
            END IF;
        ELSIF MOD(i, 5) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(i || ': Buzz'); 
        ELSE
           DBMS_OUTPUT.PUT_LINE(i); 
        END IF;
    END LOOP;
END pr_fizzbuzz;

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_fizzbuzz;

/* Script result: */
1
2
3: Fizz
4
5: Buzz
6: Fizz
7
8
9: Fizz
10: Buzz
11
12: Fizz
13
14
15: FizzBuzz
16
17
18: Fizz
19
20: Buzz
21: Fizz
22
23
24: Fizz
25: Buzz
26
27: Fizz
28
29
30: FizzBuzz
31
32
33: Fizz
34
35: Buzz
36: Fizz
37
38
39: Fizz
40: Buzz
41
42: Fizz
43
44
45: FizzBuzz
46
47
48: Fizz
49
50: Buzz
51: Fizz
52
53
54: Fizz
55: Buzz
56
57: Fizz
58
59
60: FizzBuzz
61
62
63: Fizz
64
65: Buzz
66: Fizz
67
68
69: Fizz
70: Buzz
71
72: Fizz
73
74
75: FizzBuzz
76
77
78: Fizz
79
80: Buzz
81: Fizz
82
83
84: Fizz
85: Buzz
86
87: Fizz
88
89
90: FizzBuzz
91
92
93: Fizz
94
95: Buzz
96: Fizz
97
98
99: Fizz
100: Buzz

 