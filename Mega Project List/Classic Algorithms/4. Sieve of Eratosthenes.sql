/*
*
* Case: Sieve of Eratosthenes
* Description: The sieve of Eratosthenes is one of the most efficient ways to find all of the smaller primes (below 10 million or so).
* 
* My comment:
* Another algorithm smiple to implement, just for find primes.
*
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_sieve_of_eratosthenes
(p_lower_limit NUMBER
,p_upper_limit NUMBER)
IS
    v_error_msg VARCHAR2(50);
    v_result VARCHAR2(2000);
    ex_negative_number EXCEPTION;
    ex_wrong_values EXCEPTION;
BEGIN
    IF p_lower_limit < 0 THEN
        v_error_msg := '"p_lower_limit"';
        RAISE ex_negative_number;
    ELSIF p_upper_limit < 0 THEN
        v_error_msg := '"p_upper_limit"'; 
        RAISE ex_negative_number;
    END IF;
    
    IF p_upper_limit < p_lower_limit THEN
        RAISE ex_wrong_values;
    END IF;
    
    FOR i IN p_lower_limit .. p_upper_limit LOOP
        IF i = 1 THEN
            NULL;
        ELSE
            IF i IN (2, 3, 5, 7) THEN
                IF v_result IS NULL THEN
                     v_result := i;
                ELSE
                    v_result := v_result || ', ' || i;
                END IF;
            ELSE
                IF MOD(i,2) != 0 THEN
                    IF MOD(i,3) != 0 THEN
                        IF MOD(i,5) != 0 THEN
                            IF MOD(i,7) != 0 THEN
                                IF v_result IS NULL THEN
                                    v_result := i;
                                ELSE
                                    v_result := v_result || ', ' || i;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_result);
    
EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001, 'Parameter ' || v_error_msg || ' cannot be a negative number.');
    WHEN ex_wrong_values THEN
        RAISE_APPLICATION_ERROR(-20002, 'Value of parameter "p_lower_limit" cannot be bigger than value of "p_upper_limit".');
            
END pr_sieve_of_eratosthenes;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_sieve_of_eratosthenes(1, 100);

/* Script result: */
2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97

---

/* Test: */
EXECUTE pr_sieve_of_eratosthenes(5863, 7284);

/* Script result: */
5863, 5867, 5869, 5879, 5881, 5891, 5893, 5897, 5899, 5903, 5909, 5911, 5917, 5921, 5923, 5927, 5933, 5939, 5941, 5947, 5951, 5953, 5959, 5963, 
5969, 5977, 5981, 5983, 5987, 5989, 5993, 6001, 6007, 6011, 6017, 6019, 6023, 6029, 6031, 6037, 6043, 6047, 6049, 6053, 6059, 6061, 6067, 6071, 
6073, 6077, 6079, 6089, 6091, 6101, 6103, 6107, 6109, 6113, 6119, 6121, 6127, 6131, 6133, 6137, 6143, 6149, 6151, 6157, 6161, 6163, 6169, 6173, 
6179, 6187, 6191, 6193, 6197, 6199, 6203, 6211, 6217, 6221, 6227, 6229, 6233, 6239, 6241, 6247, 6253, 6257, 6259, 6263, 6269, 6271, 6277, 6281, 
6283, 6287, 6289, 6299, 6301, 6311, 6313, 6317, 6319, 6323, 6329, 6331, 6337, 6341, 6343, 6347, 6353, 6359, 6361, 6367, 6371, 6373, 6379, 6383, 
6389, 6397, 6401, 6403, 6407, 6409, 6413, 6421, 6427, 6431, 6437, 6439, 6443, 6449, 6451, 6457, 6463, 6467, 6469, 6473, 6479, 6481, 6487, 6491, 
6493, 6497, 6499, 6509, 6511, 6521, 6523, 6527, 6529, 6533, 6539, 6541, 6547, 6551, 6553, 6557, 6563, 6569, 6571, 6577, 6581, 6583, 6589, 6593, 
6599, 6607, 6611, 6613, 6617, 6619, 6623, 6631, 6637, 6641, 6647, 6649, 6653, 6659, 6661, 6667, 6673, 6677, 6679, 6683, 6689, 6691, 6697, 6701, 
6703, 6707, 6709, 6719, 6721, 6731, 6733, 6737, 6739, 6743, 6749, 6751, 6757, 6761, 6763, 6767, 6773, 6779, 6781, 6787, 6791, 6793, 6799, 6803, 
6809, 6817, 6821, 6823, 6827, 6829, 6833, 6841, 6847, 6851, 6857, 6859, 6863, 6869, 6871, 6877, 6883, 6887, 6889, 6893, 6899, 6901, 6907, 6911, 
6913, 6917, 6919, 6929, 6931, 6941, 6943, 6947, 6949, 6953, 6959, 6961, 6967, 6971, 6973, 6977, 6983, 6989, 6991, 6997, 7001, 7003, 7009, 7013, 
7019, 7027, 7031, 7033, 7037, 7039, 7043, 7051, 7057, 7061, 7067, 7069, 7073, 7079, 7081, 7087, 7093, 7097, 7099, 7103, 7109, 7111, 7117, 7121, 
7123, 7127, 7129, 7139, 7141, 7151, 7153, 7157, 7159, 7163, 7169, 7171, 7177, 7181, 7183, 7187, 7193, 7199, 7201, 7207, 7211, 7213, 7219, 7223, 
7229, 7237, 7241, 7243, 7247, 7249, 7253, 7261, 7267, 7271, 7277, 7279, 7283



