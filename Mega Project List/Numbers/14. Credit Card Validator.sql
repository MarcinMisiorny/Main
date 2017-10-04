/*
* 
* Case: Credit Card Validator
* Description: Takes in a credit card number from a common credit card vendor (Visa, MasterCard, American Express, Discoverer) and validates 
* it to make sure that it is a valid number (look into how  credit cards use a checksum).
* 
* My comment:
* Simple procedure with Luhn algorithm and most known issuing networks. 
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_validate_credit_card_number 
(p_card_number NUMBER)
IS
    v_reverse_digits VARCHAR2(20);
    n_computed_number NUMBER;
    n_industry_identifier NUMBER;
    v_issuer_category VARCHAR2(100);
    n_issuer_id_number NUMBER;
    v_issuing_network VARCHAR2(100);
    
    ex_wrong_length EXCEPTION;
    ex_negative_number EXCEPTION;
BEGIN
    IF LENGTH(p_card_number) NOT BETWEEN 12 AND 19 THEN
        RAISE ex_wrong_length;
    END IF;
    
    IF p_card_number < 0 THEN
        RAISE ex_negative_number;
    END IF;
    
    n_computed_number := 0;
    n_industry_identifier := SUBSTR(p_card_number, 1, 1);
    n_issuer_id_number := SUBSTR(p_card_number, 1, 6);
    
    --Luhn algorithm
    FOR i IN REVERSE 1..LENGTH(p_card_number) - 1 LOOP
        v_reverse_digits := v_reverse_digits || SUBSTR(p_card_number, i, 1);
    END LOOP;
  
    FOR i IN 1..LENGTH(v_reverse_digits) LOOP
        IF MOD(i, 2) != 0 THEN
            IF (SUBSTR(v_reverse_digits, i, 1) * 2) > 9 THEN
                n_computed_number := n_computed_number + ((SUBSTR(v_reverse_digits, i, 1) * 2) - 9);
            ELSE
                n_computed_number := n_computed_number + (SUBSTR(v_reverse_digits, i, 1) * 2);
            END IF;
        ELSE
             n_computed_number := n_computed_number + SUBSTR(v_reverse_digits, i, 1);
        END IF;
    END LOOP;
    
    --Issuer category
    CASE n_industry_identifier
        WHEN 0 THEN v_issuer_category := 'ISO/TC 68 and other industry assignments';
        WHEN 1 THEN v_issuer_category := 'Airlines';
        WHEN 2 THEN v_issuer_category := 'Airlines, financial and other future industry assignments';
        WHEN 3 THEN v_issuer_category := 'Travel and entertainment';
        WHEN 4 THEN v_issuer_category := 'Banking and financial';
        WHEN 5 THEN v_issuer_category := 'Banking and financial';
        WHEN 6 THEN v_issuer_category := 'Merchandising and banking/financial';
        WHEN 7 THEN v_issuer_category := 'Petroleum and other future industry assignments';
        WHEN 8 THEN v_issuer_category := 'Healthcare, telecommunications and other future industry assignments';
        WHEN 9 THEN v_issuer_category := 'For assignment by national standards bodies';
    END CASE;
    
    --Issuing network, most konwn
    IF SUBSTR(n_issuer_id_number, 1, 2) IN (34, 37) THEN
        v_issuing_network := 'American Express';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) = 5610 OR n_issuer_id_number BETWEEN 560221 AND 560225 THEN
        v_issuing_network := 'Bankcard';
    ELSIF SUBSTR(n_issuer_id_number, 1, 2) = 62 THEN
        v_issuing_network := 'China UnionPay';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) IN (2014, 2149) THEN
        v_issuing_network := 'Diners Club enRoute';
    ELSIF SUBSTR(n_issuer_id_number, 1, 2) = 36 OR SUBSTR(n_issuer_id_number, 1, 2) IN (38, 39) OR SUBSTR(n_issuer_id_number, 1, 3) BETWEEN 300 AND 305 OR SUBSTR(n_issuer_id_number, 1, 4) = 3095 THEN
        v_issuing_network := 'Diners Club International';
    ELSIF SUBSTR(n_issuer_id_number, 1, 2) IN (54, 55) THEN
        v_issuing_network := 'Diners Club United States and Canada [MasterCard co-branded]';
    ELSIF SUBSTR(n_issuer_id_number, 1, 2) IN (64, 65) OR SUBSTR(n_issuer_id_number, 1, 4) = 6011 THEN
        v_issuing_network := 'Discover Card';
    ELSIF SUBSTR(n_issuer_id_number, 1, 3) = 636 THEN
        v_issuing_network := 'InterPayment';
    ELSIF SUBSTR(n_issuer_id_number, 1, 3) BETWEEN 637 AND 639 THEN
        v_issuing_network := 'InstaPayment';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) BETWEEN 3528 AND 3589 THEN
        v_issuing_network := 'JCB';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) IN (6304, 6706, 6771, 6709) THEN
        v_issuing_network := 'Laser';
    ELSIF SUBSTR(n_issuer_id_number, 1, 1) = 6 OR SUBSTR(n_issuer_id_number, 1, 2) = 50 OR SUBSTR(n_issuer_id_number, 1, 2) BETWEEN 56 AND 58 THEN
        v_issuing_network := 'Maestro';
    ELSIF SUBSTR(n_issuer_id_number, 1, 1) = 4 THEN
        v_issuing_network := 'Visa [or Dankort, Visa co-branded]';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) IN (5019, 4175, 4571) THEN
        v_issuing_network := 'Dankort';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) BETWEEN 2200 AND 2204 THEN
        v_issuing_network := 'MIR';
    ELSIF SUBSTR(n_issuer_id_number, 1, 2) BETWEEN 51 AND 55 OR  SUBSTR(n_issuer_id_number, 1, 4) BETWEEN 2221 AND 2720 THEN
        v_issuing_network := 'MasterCard';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) IN (6334, 6767) THEN
        v_issuing_network := 'Solo';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) IN (4903, 4905, 4911, 4936, 6333, 6759) OR n_issuer_id_number IN (564182, 633110) THEN
        v_issuing_network := 'Switch';
    ELSIF SUBSTR(n_issuer_id_number, 1, 1) = 1 THEN
        v_issuing_network := 'UATP';
    ELSIF n_issuer_id_number BETWEEN 506099 AND 506198 OR n_issuer_id_number BETWEEN 650002 AND 650027 THEN
        v_issuing_network := 'Verve';
    ELSIF n_issuer_id_number BETWEEN 979200 AND 979289 THEN
        v_issuing_network := 'TROY';
    ELSIF SUBSTR(n_issuer_id_number, 1, 4) = 5392 THEN
        v_issuing_network := 'CARDGUARD EAD BG ILS';
    ELSE
        v_issuing_network := 'Unknown issuing network in context of this program.';
    END IF;
    
    IF MOD(n_computed_number * 9, 10) != SUBSTR(p_card_number, LENGTH(p_card_number), 1) THEN
        DBMS_OUTPUT.PUT_LINE('Number ' || p_card_number || ' is not valid credit card number.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Number ' || p_card_number || ' is valid credit card number.' || CHR(13));
        DBMS_OUTPUT.PUT_LINE('Major industry identifier: ' || n_industry_identifier || '. Issuer category: ' || v_issuer_category || '.' || CHR(13));
        DBMS_OUTPUT.PUT_LINE('Issuing network: ' || v_issuing_network || '.');
    END IF;
EXCEPTION
    WHEN ex_wrong_length THEN
        RAISE_APPLICATION_ERROR(-20001, 'Length of credit card number should be between 12 and 19 digits long. Length of card number given: ' || LENGTH(p_card_number) || '.');
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20002, 'Credit card number cannot be a negative number.');
END pr_validate_credit_card_number;

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_validate_credit_card_number(4556987535498321);

/* Script result: */
Number 4556987535498321 is valid credit card number.
Major industry identifier: 4. Issuer category: Banking and financial.
Issuing network: Visa [or Dankort, Visa co-branded].

---

/* Test: */
EXECUTE pr_validate_credit_card_number(342081029142095);

/* Script result: */
Number 342081029142095 is valid credit card number.
Major industry identifier: 3. Issuer category: Travel and entertainment.
Issuing network: American Express.

---

/* Test: */
EXECUTE pr_validate_credit_card_number(6011886805538085);

/* Script result: */
Number 6011886805538085 is valid credit card number.
Major industry identifier: 6. Issuer category: Merchandising and banking/financial.
Issuing network: Discover Card.

---

/* Test: */
EXECUTE pr_validate_credit_card_number(5162419459214397);

/* Script result: */
Number 5162419459214397 is not valid credit card number.

