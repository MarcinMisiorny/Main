CREATE OR REPLACE PACKAGE walidatory
IS
    FUNCTION fn_waliduj_pesel (p_pesel IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_iban (p_numer_iban IN VARCHAR2) RETURN BOOLEAN;
END walidatory;
/


CREATE OR REPLACE PACKAGE BODY walidatory
IS
    FUNCTION fn_waliduj_pesel
    (p_pesel IN VARCHAR2)
    RETURN BOOLEAN
    IS
        n_temp NUMBER;
        b_czy_poprawny BOOLEAN;
    BEGIN
        n_temp := MOD((1 * SUBSTR(p_pesel, 1, 1) + 
                       3 * SUBSTR(p_pesel, 2, 1) +
                       7 * SUBSTR(p_pesel, 3, 1) +
                       9 * SUBSTR(p_pesel, 4, 1) +
                       1 * SUBSTR(p_pesel, 5, 1) +
                       3 * SUBSTR(p_pesel, 6, 1) +
                       7 * SUBSTR(p_pesel, 7, 1) +
                       9 * SUBSTR(p_pesel, 8, 1) +
                       1 * SUBSTR(p_pesel, 9, 1) +
                       3 * SUBSTR(p_pesel, 10, 1) +
                       1 * SUBSTR(p_pesel, 11, 1)) ,10); 
    
        IF n_temp = 0 THEN  
            b_czy_poprawny := TRUE; 
        ELSE
            b_czy_poprawny := FALSE;
        END IF;
        
    RETURN b_czy_poprawny;
    EXCEPTION 
        WHEN OTHERS THEN RETURN FALSE;
    END fn_waliduj_pesel;


    FUNCTION fn_waliduj_iban
    (p_numer_iban IN VARCHAR2)
    RETURN BOOLEAN
    IS
        v_iban VARCHAR2(50);
        v_iban_zlaczenie VARCHAR2(50);
        v_iban_odwrocony VARCHAR2(50);
        v_suma_kontrolna_kod_kraju VARCHAR2(4);
        v_suma_kontrolna VARCHAR2(2);
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
        
    BEGIN
        n_suma_czynnikow := 0;
        v_iban := REPLACE(REPLACE(p_numer_iban, '-', ''), ' ', '');
        v_suma_kontrolna := SUBSTR(v_iban, 3, 2);
        v_suma_kontrolna_kod_kraju := ASCII(SUBSTR(v_iban, 1, 1)) - 55 || ASCII(SUBSTR(v_iban, 2, 1)) - 55;
        v_iban_zlaczenie := SUBSTR(v_iban, 5, LENGTH(v_iban)) || v_suma_kontrolna_kod_kraju || v_suma_kontrolna;
    
        FOR i IN REVERSE 1 .. LENGTH(v_iban_zlaczenie) LOOP
            v_iban_odwrocony := v_iban_odwrocony || SUBSTR(v_iban_zlaczenie, i, 1);
        END LOOP;
    
        FOR i IN 1 .. LENGTH(v_iban_odwrocony) LOOP
            n_suma_czynnikow := n_suma_czynnikow + (SUBSTR(v_iban_odwrocony, i, 1) * MOD(POWER(10, i - 1), 97));
        END LOOP;
    
        IF MOD(n_suma_czynnikow, 97) = 1 THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;
        
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN 
            RETURN FALSE;
    END fn_waliduj_iban;

END walidatory;
/

