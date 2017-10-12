CREATE OR REPLACE PACKAGE walidatory
IS
    FUNCTION fn_waliduj_pesel (p_pesel IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_iban (p_numer_iban IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_dowod_osobisty (p_numer_dowodu IN VARCHAR2) RETURN BOOLEAN;
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
	
	FUNCTION fn_waliduj_dowod_osobisty
    (p_numer_dowodu IN VARCHAR2)
    RETURN BOOLEAN
    IS
       
        n_liczba_kontrolna NUMBER;
        v_litery VARCHAR2(3);
        n_liczby NUMBER;
        n_suma_czynnikow_litery NUMBER;
        n_suma_czynnikow_liczby NUMBER;
        b_wynik BOOLEAN;
       
        TYPE t_tab IS VARRAY(5) OF INTEGER;
        t_wagi t_tab := t_tab(7, 3, 1, 7, 3);
    BEGIN
       
        n_suma_czynnikow_litery := 0;
        n_suma_czynnikow_liczby := 0;
        v_litery := SUBSTR(p_numer_dowodu, 1, 3);
        n_liczby := SUBSTR(p_numer_dowodu, 5, LENGTH(p_numer_dowodu));
        n_liczba_kontrolna := SUBSTR(p_numer_dowodu, 4, 1);
       
        FOR i IN 1 .. LENGTH(v_litery) LOOP
            n_suma_czynnikow_litery := n_suma_czynnikow_litery + ((ASCII(SUBSTR(v_litery, i, 1)) - 55) * t_wagi(i));
        END LOOP;
       
        FOR i IN 1 .. LENGTH(n_liczby) LOOP
            n_suma_czynnikow_liczby := n_suma_czynnikow_liczby + (SUBSTR(n_liczby, i, 1) * t_wagi(i));
        END LOOP;
       
        IF MOD(n_suma_czynnikow_litery + n_suma_czynnikow_liczby, 10) = n_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;
       
    RETURN b_wynik;
    EXCEPTION
       WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_dowod_osobisty;

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

