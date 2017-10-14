CREATE OR REPLACE PACKAGE walidatory
IS
    FUNCTION fn_waliduj_pesel (p_pesel IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_iban (p_numer_iban IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_dowod_osobisty (p_numer_dowodu IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_nip (p_numer_nip IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_regon (p_numer_regon IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_numer_ksiegi (p_numer_ksiegi IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_numer_karty_kred (p_numer_karty VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_isbn_10 (p_numer_isbn_10 VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_isbn_13 (p_numer_isbn_13 VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_ean_13 (p_numer_ean_13 VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_ean_8 (p_numer_ean_8 VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_waliduj_ean_14 (p_numer_ean_14 VARCHAR2) RETURN BOOLEAN;
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
                       1 * SUBSTR(p_pesel, 11, 1)), 10); 
    
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

    FUNCTION fn_waliduj_nip
    (p_numer_nip IN VARCHAR2)
    RETURN BOOLEAN
    IS
        v_nip_oczyszczony VARCHAR2(10);
        n_liczba_kontrolna NUMBER;
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
       
        TYPE t_tab IS VARRAY(9) OF INTEGER;
        t_wagi t_tab := t_tab(6, 5, 7, 2, 3, 4, 5, 6, 7);
    BEGIN
        v_nip_oczyszczony := REPLACE(REPLACE(p_numer_nip, '-', ''), ' ', '');
        n_liczba_kontrolna := SUBSTR(v_nip_oczyszczony, LENGTH(v_nip_oczyszczony), 1);
        n_suma_czynnikow := 0;
       
        FOR i IN 1 .. LENGTH(v_nip_oczyszczony) - 1 LOOP
            n_suma_czynnikow := n_suma_czynnikow + (SUBSTR(v_nip_oczyszczony, i, 1) * t_wagi(i));
        END LOOP;
       
        IF MOD(n_suma_czynnikow, 11) = n_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;
       
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_nip;
 

    FUNCTION fn_waliduj_regon
    (p_numer_regon IN VARCHAR2)
    RETURN BOOLEAN
    IS
        v_regon_oczyszczony VARCHAR2(14);
        n_liczba_kontrolna NUMBER;
        n_suma_czynnikow NUMBER;
        n_mod_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
        
        TYPE t_tab_9 IS VARRAY(8) OF INTEGER;
        t_wagi_9 t_tab_9 := t_tab_9(8, 9, 2, 3, 4, 5, 6, 7);
       
        TYPE t_tab_14 IS VARRAY(13) OF INTEGER;
        t_wagi_14 t_tab_14 := t_tab_14(2, 4, 8, 5, 0, 9, 7, 3, 6, 1, 2, 4, 8);
       
    BEGIN
        v_regon_oczyszczony := REPLACE(REPLACE(p_numer_regon, '-', ''), ' ', '');
        n_liczba_kontrolna := SUBSTR(v_regon_oczyszczony, LENGTH(v_regon_oczyszczony), 1);
        n_suma_czynnikow := 0;
        n_mod_suma_czynnikow := 0;
       
        IF LENGTH(v_regon_oczyszczony) = 9 THEN
            FOR i IN 1 .. LENGTH(v_regon_oczyszczony) - 1 LOOP
                n_suma_czynnikow := n_suma_czynnikow + (SUBSTR(v_regon_oczyszczony, i, 1) * t_wagi_9(i));
            END LOOP;
        ELSE
            FOR i IN 1 .. LENGTH(v_regon_oczyszczony) - 1 LOOP
                n_suma_czynnikow := n_suma_czynnikow + (SUBSTR(v_regon_oczyszczony, i, 1) * t_wagi_14(i));
            END LOOP;
        END IF;
       
        IF MOD(n_suma_czynnikow, 11) = 10 THEN
            n_mod_suma_czynnikow := 0;
        END IF;
       
        IF MOD(n_suma_czynnikow, 11) = n_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;
       
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_regon;

    
    FUNCTION fn_waliduj_numer_ksiegi
    (p_numer_ksiegi IN VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(13);
        b_wynik BOOLEAN;
        n_liczba_kontrolna NUMBER;
        n_suma_czynnikow NUMBER;
        
        TYPE t_tab IS VARRAY(12) OF INTEGER;
        t_wagi t_tab := t_tab(1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7);
        
        FUNCTION fn_wartosc_ascii 
        (p_znak VARCHAR2)
        RETURN NUMBER
        IS
            n_wartosc NUMBER;
        BEGIN
            n_wartosc := 0;
            
            IF ASCII(p_znak) BETWEEN 48 AND 57 THEN
                n_wartosc := p_znak;
            ELSIF p_znak IN ('R', 'S', 'T', 'U') THEN
                n_wartosc := ASCII(p_znak) - 55;
            ELSIF p_znak IN ('W', 'Y', 'Z') THEN
                n_wartosc := ASCII(p_znak) - 56;
            ELSIF p_znak = 'X' THEN
                n_wartosc := 10;
            ELSE
                n_wartosc := ASCII(p_znak) - 54;
            END IF;
            
        RETURN n_wartosc;
        END;
    BEGIN
        v_numer_oczyszczony := REPLACE(p_numer_ksiegi, '/', '');
        n_liczba_kontrolna := SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1);
        n_suma_czynnikow := 0;        
        
        FOR i IN 1 .. LENGTH(v_numer_oczyszczony) - 1 LOOP
            n_suma_czynnikow := n_suma_czynnikow + (fn_wartosc_ascii(SUBSTR(v_numer_oczyszczony, i, 1)) * t_wagi(i));
        END LOOP;
        
        IF MOD(n_suma_czynnikow, 10) = n_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;
        
    RETURN b_wynik;
    END fn_waliduj_numer_ksiegi;

    
    FUNCTION fn_waliduj_numer_karty_kred
    (p_numer_karty VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(20);
        v_numer_odwrocony VARCHAR2(20);
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
    BEGIN
        v_numer_oczyszczony := REPLACE(REPLACE(p_numer_karty, '-', ''), ' ', '');
        n_suma_czynnikow := 0;
    
        FOR i IN REVERSE 1 .. LENGTH(v_numer_oczyszczony) - 1 LOOP
            v_numer_odwrocony := v_numer_odwrocony || SUBSTR(v_numer_oczyszczony, i, 1);
        END LOOP;
    
        FOR i IN 1..LENGTH(v_numer_odwrocony) LOOP
            IF MOD(i, 2) != 0 THEN
                IF (SUBSTR(v_numer_odwrocony, i, 1) * 2) > 9 THEN
                    n_suma_czynnikow := n_suma_czynnikow + ((SUBSTR(v_numer_odwrocony, i, 1) * 2) - 9);
                ELSE
                    n_suma_czynnikow := n_suma_czynnikow + (SUBSTR(v_numer_odwrocony, i, 1) * 2);
                END IF;
            ELSE
                n_suma_czynnikow := n_suma_czynnikow + SUBSTR(v_numer_odwrocony, i, 1);
            END IF;
        END LOOP;
    
        IF MOD(n_suma_czynnikow * 9, 10) = SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1) THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;
    
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_numer_karty_kred;
    
    
    FUNCTION fn_waliduj_isbn_10
    (p_numer_isbn_10 VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(20);
        v_numer_odwrocony VARCHAR2(20);
        v_liczba_kontrolna VARCHAR2(2);
        n_liczba_kontrolna_mod NUMBER;
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
    
    BEGIN
        v_numer_oczyszczony := REPLACE(p_numer_isbn_10, '-', '');
        n_suma_czynnikow := 0;
        
        IF INSTR(v_numer_oczyszczony, ' ') = 11 THEN
            v_numer_oczyszczony := SUBSTR(v_numer_oczyszczony, 1, 10);
        END IF;
        
        v_liczba_kontrolna := SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1);
        
        IF v_liczba_kontrolna = 'X' THEN
            v_liczba_kontrolna := 10;
        END IF;
    
        FOR i IN REVERSE 1 .. LENGTH(v_numer_oczyszczony) LOOP
            v_numer_odwrocony := v_numer_odwrocony || SUBSTR(v_numer_oczyszczony, i, 1);
        END LOOP;
        
        FOR i IN REVERSE 2 .. LENGTH(v_numer_odwrocony) LOOP
            n_suma_czynnikow := n_suma_czynnikow + SUBSTR(v_numer_odwrocony, i, 1) * i;
        END LOOP;
    
        n_liczba_kontrolna_mod := MOD(n_suma_czynnikow, 11);
        
        IF MOD(11 - n_liczba_kontrolna_mod, 11) = v_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;        
    
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_isbn_10;

    
    FUNCTION fn_waliduj_isbn_13
    (p_numer_isbn_13 VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(20);
        v_liczba_kontrolna VARCHAR2(2);
        n_waga INTEGER;
        n_liczba_kontrolna_mod NUMBER;
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
    
    BEGIN
        v_numer_oczyszczony := REPLACE(p_numer_isbn_13, '-', '');
        n_suma_czynnikow := 0;
        
        v_liczba_kontrolna := SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1);
        
        
        FOR i IN 1 .. LENGTH(v_numer_oczyszczony) - 1 LOOP
            IF MOD(i, 2) != 0 THEN
                n_waga := 1;
            ELSE
                n_waga := 3;
            END IF;
            
            n_suma_czynnikow := n_suma_czynnikow + SUBSTR(v_numer_oczyszczony, i, 1) * n_waga;
        END LOOP;
    
        n_liczba_kontrolna_mod := MOD(n_suma_czynnikow, 10);
        
        IF MOD(10 - n_liczba_kontrolna_mod, 10) = v_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;        
    
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_isbn_13;

    
    FUNCTION fn_waliduj_ean_13
    (p_numer_ean_13 VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(20);
        v_liczba_kontrolna VARCHAR2(2);
        n_waga INTEGER;
        n_liczba_kontrolna_mod NUMBER;
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
    
    BEGIN
        v_numer_oczyszczony := REPLACE(p_numer_ean_13, '-', '');
        n_suma_czynnikow := 0;
        
        v_liczba_kontrolna := SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1);
        
        
        FOR i IN 1 .. LENGTH(v_numer_oczyszczony) - 1 LOOP
            IF MOD(i, 2) != 0 THEN
                n_waga := 1;
            ELSE
                n_waga := 3;
            END IF;
            
            n_suma_czynnikow := n_suma_czynnikow + SUBSTR(v_numer_oczyszczony, i, 1) * n_waga;
        END LOOP;
    
        n_liczba_kontrolna_mod := MOD(n_suma_czynnikow, 10);
        
        IF MOD(10 - n_liczba_kontrolna_mod, 10) = v_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;        
    
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_ean_13;

    
    FUNCTION fn_waliduj_ean_8
    (p_numer_ean_8 VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(20);
        v_liczba_kontrolna VARCHAR2(2);
        n_waga INTEGER;
        n_liczba_kontrolna_mod NUMBER;
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
    
    BEGIN
        v_numer_oczyszczony := REPLACE(p_numer_ean_8, '-', '');
        n_suma_czynnikow := 0;
        
        v_liczba_kontrolna := SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1);
        
        
        FOR i IN 1 .. LENGTH(v_numer_oczyszczony) - 1 LOOP
            IF MOD(i, 2) != 0 THEN
                n_waga := 3;
            ELSE
                n_waga := 1;
            END IF;
            
            n_suma_czynnikow := n_suma_czynnikow + SUBSTR(v_numer_oczyszczony, i, 1) * n_waga;
        END LOOP;
    
        n_liczba_kontrolna_mod := MOD(n_suma_czynnikow, 10);
        
        IF MOD(10 - n_liczba_kontrolna_mod, 10) = v_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;        
    
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_ean_8;
    
    
    FUNCTION fn_waliduj_ean_14
    (p_numer_ean_14 VARCHAR2)
    RETURN BOOLEAN
    IS
        v_numer_oczyszczony VARCHAR2(20);
        v_liczba_kontrolna VARCHAR2(2);
        n_waga INTEGER;
        n_liczba_kontrolna_mod NUMBER;
        n_suma_czynnikow NUMBER;
        b_wynik BOOLEAN;
    
    BEGIN
        v_numer_oczyszczony := REPLACE(p_numer_ean_14, '-', '');
        n_suma_czynnikow := 0;
        
        v_liczba_kontrolna := SUBSTR(v_numer_oczyszczony, LENGTH(v_numer_oczyszczony), 1);
        
        
        FOR i IN 1 .. LENGTH(v_numer_oczyszczony) - 1 LOOP
            IF MOD(i, 2) != 0 THEN
                n_waga := 3;
            ELSE
                n_waga := 1;
            END IF;
            
            n_suma_czynnikow := n_suma_czynnikow + SUBSTR(v_numer_oczyszczony, i, 1) * n_waga;
        END LOOP;
    
        n_liczba_kontrolna_mod := MOD(n_suma_czynnikow, 10);
        
        IF MOD(10 - n_liczba_kontrolna_mod, 10) = v_liczba_kontrolna THEN
            b_wynik := TRUE;
        ELSE
            b_wynik := FALSE;
        END IF;        
    
    RETURN b_wynik;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END fn_waliduj_ean_14;
END walidatory;
/

