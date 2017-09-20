/*
* --------------------------------------------
* Rozdział 4. Opcja obiektowa
* --------------------------------------------
* 
* Plik z zadaniami: ZSBD_cw_04.pdf
* 
*/

--------------------------------------------------------
-- 1. Utwórz typ obiektowy pracownik.

    CREATE TYPE pracownik AS OBJECT (nazwisko VARCHAR2(20)
                                    ,pensja NUMBER(6,2)
                                    ,etat VARCHAR2(15)
                                    ,data_ur DATE);

--------------------------------------------------------
-- 2. Utwórz tabelę obiektową i wstaw do niej obiekt reprezentujący pracownika Kowalskiego

    CREATE TABLE PracownicyObjTab OF pracownik;
    
    INSERT INTO    PracownicyObjTab 
    VALUES         (NEW pracownik('Kowalski'
                                 ,2500
                                 ,'ASYSTENT'
                                 ,DATE '1965-07-01'));
    
--------------------------------------------------------
-- 3. Wyświetl zawartość tabeli obiektowej w trybie dostępu relacyjnego i obiektowego.

    SELECT   *
    FROM     PracownicyObjTab;
    
    SELECT   VALUE(p)
    FROM     PracownicyObjTab p;

--------------------------------------------------------
-- 4. Utwórz tabelę, która będzie zawierała obiektowy atrybut. Wstaw do tabeli krotkę zawierającą obiekt.
    
    CREATE TABLE ProjektyTab (symbol CHAR(6)
                             ,nazwa VARCHAR(100)
                             ,budzet NUMBER
                             ,kierownik pracownik);
    
    INSERT INTO ProjektyTab 
    VALUES ('AB 001'
           ,'Projekt X'
           ,20000
           ,NEW pracownik('Nowak'
                         ,3200
                         ,'ADIUNKT'
                         ,null));
 
--------------------------------------------------------
-- 5. Wyświetl zawartość nowoutworzonej tabeli. Sprawdź, jak funkcjonuje dostęp do składowych obiektów za pomocą notacji kropkowej.

    SELECT  nazwa
            ,kierownik
    FROM    ProjektyTab;
    
    SELECT  p.kierownik.nazwisko
    FROM    ProjektyTab p;
 
--------------------------------------------------------
-- 6. Dodaj do definicji typu pracownik funkcję wyznaczającą wiek pracownika oraz metodę służącą do przyznania pracownikowi podwyżki

    ALTER TYPE pracownik
    REPLACE AS OBJECT (nazwisko VARCHAR2(20)
                      ,pensja NUMBER(6,2)
                      ,etat VARCHAR2(15)
                      ,data_ur DATE
                      ,MEMBER FUNCTION wiek RETURN NUMBER
                      ,MEMBER PROCEDURE podwyzka(p_kwota NUMBER));
    
    
    CREATE OR REPLACE TYPE BODY pracownik 
    AS
        MEMBER FUNCTION wiek 
        RETURN NUMBER 
        IS
        BEGIN
            RETURN EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_ur);
        END wiek;
    
        MEMBER PROCEDURE podwyzka
        (p_kwota NUMBER) 
        IS
        BEGIN
            pensja := pensja + p_kwota;
        END podwyzka;
    END;
    /

--------------------------------------------------------
-- 7. Wyświetl wiek pracowników umieszczonych w tabeli PracownicyObjTab. Następnie, przyznaj 200 zł podwyżki 
--    kierownikowi projektu 'AB 001' (tabela ProjektyTab)
    
    SELECT  p.nazwisko
            ,p.data_ur
            ,p.wiek()
    FROM    PracownicyObjTab p;
    
    DECLARE
        l_kierownik pracownik;
    BEGIN
        SELECT  kierownik
        INTO    l_kierownik
        FROM    ProjektyTab
        WHERE   symbol = 'AB 001';
        
        l_kierownik.podwyzka(200);
        
        UPDATE    ProjektyTab
        SET       kierownik = l_kierownik
        WHERE    symbol = 'AB 001';
    END;
    
--------------------------------------------------------
-- 8. Wyświetl unikalne identyfikatory (OIDs) obiektów przechowywanych w tabeli PracownicyObjTab.

    SELECT  VALUE(p)
            ,REF(p)
    FROM    PracownicyObjTab p;
 
--------------------------------------------------------
-- 9. Dodaj do typu obiektowego pracownik metodę, za pomocą której będzie można porównywać ze sobą pracowników korzystając z ich pensji i wieku.
    
    ALTER TYPE pracownik 
    ADD MAP 
    MEMBER FUNCTION odwzoruj
    RETURN NUMBER 
    CASCADE INCLUDING TABLE DATA;
    
    CREATE OR REPLACE TYPE BODY pracownik 
    AS
        MEMBER FUNCTION wiek 
        RETURN NUMBER 
        IS
        BEGIN
            RETURN EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_ur);
        END wiek;
        
        MEMBER PROCEDURE podwyzka
        (p_kwota NUMBER) 
        IS
        BEGIN
            pensja := pensja + p_kwota;
        END podwyzka;
        
        MAP MEMBER FUNCTION odwzoruj 
        RETURN NUMBER
        IS
        BEGIN
            RETURN ROUND(pensja,-3) + wiek();
        END odwzoruj;
    END;
    /

--------------------------------------------------------
-- 10. Dodaj do tabeli PracownicyObjTab dwóch nowych pracowników i sprawdź działanie funkcji odwzorowującej.

    INSERT INTO PracownicyObjTab 
    VALUES (NEW pracownik('Nowak'
                         ,2000
                         ,'ADIUNKT'
                         ,DATE '1961-02-15'));
    
    INSERT INTO PracownicyObjTab
    VALUES (NEW pracownik('Janiak'
                         ,1800
                         ,'ASYSTENT'
                         ,DATE '1973-12-02'));
    
    SELECT  p.nazwisko
            ,p.pensja
            ,p.wiek()
    FROM    PracownicyObjTab p
    ORDER BY VALUE(p);
    
    SELECT  *
    FROM    PracownicyObjTab p
    WHERE   VALUE(p) > (SELECT  VALUE(r) 
                        FROM    PracownicyObjTab r
                        WHERE   r.nazwisko = 'Janiak');
 
    SELECT  p.nazwisko
            ,p.pensja
            ,p.odwzoruj()
    FROM    PracownicyObjTab p
    ORDER BY VALUE(p);
    
--------------------------------------------------------
-- 11. Do definicji typu obiektowego pracownik dodaj konstruktor. W ciele typu obiektowego umieść następnie implementację konstruktora.

    ALTER TYPE pracownik 
    REPLACE AS OBJECT (nazwisko VARCHAR2(20)
                      ,pensja NUMBER(6,2)
                      ,etat VARCHAR2(15)
                      ,data_ur DATE
                      ,MEMBER FUNCTION wiek RETURN NUMBER
                      ,MEMBER PROCEDURE podwyzka(p_kwota NUMBER)
                      ,MAP MEMBER FUNCTION odwzoruj RETURN NUMBER
                      ,CONSTRUCTOR FUNCTION pracownik(p_nazwisko VARCHAR2) RETURN SELF AS RESULT);
    
    CREATE OR REPLACE TYPE BODY pracownik 
    AS
        MEMBER FUNCTION wiek 
        RETURN NUMBER 
        IS
        BEGIN
            RETURN EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_ur);
        END wiek;
        
        MEMBER PROCEDURE podwyzka
        (p_kwota NUMBER) 
        IS
        BEGIN
            pensja := pensja + p_kwota;
        END podwyzka;
        
        MAP MEMBER FUNCTION odwzoruj 
        RETURN NUMBER 
        IS
        BEGIN
            RETURN ROUND(pensja,-3) + wiek();
        END odwzoruj;
        
        CONSTRUCTOR FUNCTION 
        pracownik(p_nazwisko VARCHAR2)
        RETURN SELF AS RESULT 
        IS
        BEGIN
            SELF.nazwisko := p_nazwisko; 
            SELF.pensja := 1000;
            SELF.etat := null; 
            SELF.data_ur := null;
        RETURN;
        END;
    END;
    /

--------------------------------------------------------
-- 12. Przetestuj działanie konstruktora tworząc nowy obiekt i wstawiając go do tabeli PracownicyObjTab.

    INSERT INTO PracownicyObjTab 
    VALUES (NEW pracownik('Dziamdziak')); 
 
--------------------------------------------------------
-- 13. Utwórz typy obiektowe Osoba i Adres. Wykorzystaj referencje do powiązania osób z adresami zamieszkania. 
--     Następnie, utwórz tabele obiektowe i wypełnij je przykładowymi danymi.

    CREATE TYPE adres AS OBJECT (ulica VARCHAR2(15)
                                ,dom NUMBER(4)
                                ,mieszkanie NUMBER(3));
    
    
    CREATE TYPE osoba AS OBJECT (nazwisko VARCHAR2(20)
                                ,imie VARCHAR2(15)
                                ,gdziemieszka REF adres);
    
    
    CREATE TABLE AdresyObjTab OF adres;
    
    CREATE TABLE OsobyObjTab OF osoba;
    
    ALTER TABLE OsobyObjTab 
    ADD SCOPE FOR(gdziemieszka) IS AdresyObjTab;
    
    INSERT INTO AdresyObjTab 
    VALUES (NEW adres('Kolejowa'
                     ,2
                     ,18));
                     
    INSERT INTO OsobyObjTab 
    VALUES (NEW osoba('Kowalska'
                     ,'Anna'
                     ,null));
                     
    INSERT INTO OsobyObjTab 
    VALUES (NEW osoba('Kowalski'
                     ,'Jan'
                     ,null));
                     
    UPDATE  OsobyObjTab o
    SET     o.gdziemieszka = (SELECT  REF(a) 
                              FROM    AdresyObjTab a
                              WHERE   a.ulica = 'Kolejowa');
 
--------------------------------------------------------
-- 14. Sprawdź różne sposoby wykorzystania nawigacji po referencjach.

    SELECT  o.imie
            ,o.nazwisko
            ,DEREF(o.gdziemieszka)
    FROM    OsobyObjTab o;
    
    SELECT  o.imie
            ,o.nazwisko
            ,o.gdziemieszka.ulica
            ,o.gdziemieszka.dom
    FROM    OsobyObjTab o;
    
    SELECT  o.imie
            ,o.nazwisko
            ,a.ulica
            ,a.dom
            ,a.mieszkanie
    FROM    OsobyObjTab o 
    JOIN    AdresyObjTab a ON (o.gdziemieszka = REF(a));

--------------------------------------------------------
-- 15. Zaobserwuj zjawisko wiszących referencji.

    DELETE
    FROM    AdresyObjTab a
    WHERE   a.ulica = 'Kolejowa';
    
    SELECT  *
    FROM    OsobyObjTab o
    WHERE   o.gdziemieszka IS NULL;
    
    SELECT  *
    FROM    OsobyObjTab o
    WHERE   o.gdziemieszka IS DANGLING; 

--------------------------------------------------------
--------------------------------------------------------
-- Tworzenie typów obiektowych

--------------------------------------------------------
-- 1. Zdefiniuj typ obiektowy reprezentujący SAMOCHODY. Każdy samochód powinien mieć
--    markę, model, liczbę kilometrów oraz datę produkcji i cenę. Stwórz tablicę obiektową i
--    wprowadź kilka przykładowych obiektów, obejrzyj zawartość tablicy

    CREATE TYPE samochod AS OBJECT (marka VARCHAR2(20)
                                   ,model VARCHAR2(20)
                                   ,kilometry NUMBER
                                   ,data_produkcji DATE
                                   ,cena NUMBER(10,2));
    /
    
    CREATE TABLE samochody OF samochod;
                                    
        
    INSERT INTO samochody (marka 
                          ,model 
                          ,kilometry
                          ,data_produkcji
                          ,cena)
    VALUES                ('FIAT'
                          ,'BRAVA'
                          ,60000
                          ,TO_DATE('1999-11-30')
                          ,25000);
    
    INSERT INTO samochody (marka 
                          ,model 
                          ,kilometry
                          ,data_produkcji
                          ,cena)
    VALUES                ('FORD'
                          ,'MONDEO'
                          ,80000
                          ,TO_DATE('1997-05-10')
                          ,45000);
    
    INSERT INTO samochody (marka 
                          ,model 
                          ,kilometry
                          ,data_produkcji
                          ,cena)
    VALUES                ('MAZDA'
                          ,'323'
                          ,12000
                          ,TO_DATE('2000-09-22')
                          ,52000);                            
    
    SELECT  * 
    FROM    samochody;
    
--------------------------------------------------------
-- 2. Stwórz tablicę WLASCICIELE zawierającą imiona i nazwiska właścicieli oraz atrybut
--    obiektowy SAMOCHOD. Wprowadź do tabeli przykładowe dane i wyświetl jej zawartość.

    CREATE TABLE wlasciciele (imie VARCHAR2(100)
                             ,nazwisko VARCHAR2(100)
                             ,auto samochod);


    INSERT INTO wlasciciele (imie 
                            ,nazwisko 
                            ,auto)
    VALUES                  ('Jan'
                            ,'Kowalski'
                            ,NEW samochod('FIAT'
                                         ,'SEICENTO'
                                         ,30000
                                         ,TO_DATE('2010-02-12')
                                         ,19500));


    INSERT INTO wlasciciele (imie 
                            ,nazwisko 
                            ,auto)
    VALUES                  ('Adam'
                            ,'Nowak'
                            ,NEW samochod('OPEL'
                                         ,'ASTRA'
                                         ,34000
                                         ,TO_DATE('2009-06-01')
                                         ,33700));
                         
                         
    SELECT  * 
    FROM    wlasciciele;

--------------------------------------------------------
-- 3. Wartość samochodu maleje o 10% z każdym rokiem. Dodaj do typu obiektowego SAMOCHOD
--    metodę wyliczającą na podstawie wieku i przebiegu aktualną wartość samochodu.

    ALTER TYPE samochod 
    REPLACE AS OBJECT (marka VARCHAR2(20) 
                      ,model VARCHAR2(20)                         
                      ,kilometry NUMBER                           
                      ,data_produkcji DATE                        
                      ,cena number(10,2) 
                      ,MEMBER FUNCTION wartosc RETURN NUMBER);              
    /

    CREATE OR REPLACE TYPE BODY samochod 
    IS
        MEMBER FUNCTION wartosc 
        RETURN NUMBER 
        IS
        cena_po_latach NUMBER;
        BEGIN
            cena_po_latach := cena;
            FOR i IN 1 .. (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_produkcji)) LOOP
                cena_po_latach := cena_po_latach * 0.9;
            END LOOP;
        RETURN ROUND(cena_po_latach, 2);
        END wartosc;
    END;
    /
    
    SELECT  s.marka
            ,s.cena
            ,s.wartosc() 
    FROM    samochody s;

--------------------------------------------------------
-- 4. Dodaj do typu SAMOCHOD metodę odwzorowującą, która pozwoli na porównywanie
--    samochodów na podstawie ich wieku i zużycia. Przyjmij, że 10000 km odpowiada jednemu rokowi wieku samochodu.

    ALTER TYPE samochod 
    ADD MAP MEMBER FUNCTION odwzoruj
    RETURN NUMBER CASCADE INCLUDING TABLE DATA;

    CREATE OR REPLACE TYPE BODY samochod
    IS
        MEMBER FUNCTION odwzoruj 
        RETURN NUMBER 
        IS
        n_porownanie NUMBER;
        BEGIN
            n_porownanie := (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_produkcji)) + (kilometry / 10000);
        RETURN n_porownanie;
        END odwzoruj;
    END;

--------------------------------------------------------
-- 5. Stwórz typ WLASCICIEL zawierający imię i nazwisko właściciela samochodu, dodaj do typu
--    SAMOCHOD referencje do właściciela. Wypełnij tabelę przykładowymi danymi.

    CREATE TYPE wlasciciel AS OBJECT (imie VARCHAR2(100)
                                     ,nazwisko VARCHAR2(100));
                                     
    
    ALTER TYPE samochod 
    REPLACE AS OBJECT (marka VARCHAR2(20) 
                      ,model VARCHAR2(20)                         
                      ,kilometry NUMBER                           
                      ,data_produkcji DATE                        
                      ,cena number(10,2) 
                      ,MEMBER FUNCTION wartosc RETURN NUMBER
                      ,MAP MEMBER FUNCTION odwzoruj    RETURN NUMBER CASCADE INCLUDING TABLE DATA
                      ,wlasciciel_samochodu REF wlasciciel);                                   
                                     
--------------------------------------------------------
-- 6. Zbuduj kolekcję (tablicę o zmiennym rozmiarze) zawierającą informacje o przedmiotach
--    (łańcuchy znaków). Wstaw do kolekcji przykładowe przedmioty, rozszerz kolekcję, wyświetl
--    zawartość kolekcji, usuń elementy z końca kolekcji

    DECLARE
        TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
        moje_przedmioty t_przedmioty := t_przedmioty('');
    BEGIN
        moje_przedmioty(1) := 'MATEMATYKA';
        moje_przedmioty.EXTEND(9);
        
        FOR i IN 2..10 LOOP
            moje_przedmioty(i) := 'PRZEDMIOT_' || i;
        END LOOP;
        
        FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
        END LOOP;
        
        moje_przedmioty.TRIM(2);
        
        FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
        DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
        
        moje_przedmioty.EXTEND();
        moje_przedmioty(9) := 9;
        
        DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
        DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
        
        moje_przedmioty.DELETE();
        DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
        DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    END; 

--------------------------------------------------------
-- 7. Zdefiniuj kolekcję (w oparciu o tablicę o zmiennym rozmiarze) zawierającą listę tytułów
--    książek. Wykonaj na kolekcji kilka czynności (rozszerz, usuń jakiś element, wstaw nową książkę)

    DECLARE
        TYPE t_tytuly IS TABLE OF VARCHAR2(100);
        tytul t_tytuly := t_tytuly();
    BEGIN
        tytul.EXTEND(5);
    
        tytul(1) := 'Władca Pierścieni';
        tytul(2) := 'Solaris';
        tytul(3) := 'Trzej muszkieterowie';
        tytul(4) := 'Hobbit';
        tytul(5) := 'Robot';
        
        FOR i IN tytul.FIRST .. tytul.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(tytul(i));
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE;
        
        tytul.TRIM(2);
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji: ' || tytul.count);
        
        FOR i IN tytul.FIRST .. tytul.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(tytul(i));
        END LOOP;
        
        tytul.EXTEND(2);
        
        tytul(1) := 'Władca Pierścieni - Powrót króla';
        tytul(4) := 'Podróż do wnętrza Ziemi';
        tytul(5) := 'Hrabia Monte Christo';
        
        DBMS_OUTPUT.NEW_LINE;
        
        FOR i IN tytul.FIRST .. tytul.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(tytul(i));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji: ' || tytul.count);
         
        tytul.DELETE;
        
        DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji po usunięciu: ' || tytul.count);
    END;
    /
  
--------------------------------------------------------
-- 8. Zbuduj kolekcję (tablicę zagnieżdżoną) zawierającą informacje o wykładowcach. Przetestuj
--    działanie kolekcji podobnie jak w przykładzie 6.

    DECLARE
        TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
        moi_wykladowcy t_wykladowcy := t_wykladowcy();
    BEGIN
        moi_wykladowcy.EXTEND(2);
        moi_wykladowcy(1) := 'MORZY';
        moi_wykladowcy(2) := 'WOJCIECHOWSKI';
        moi_wykladowcy.EXTEND(8);
        
        FOR i IN 3..10 LOOP
            moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
        END LOOP;
        
        FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END LOOP;
        
        moi_wykladowcy.TRIM(2);
        
        FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END LOOP;
        
        moi_wykladowcy.DELETE(5,7);
        
        DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
        DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
        
        FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            IF moi_wykladowcy.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
            END IF;
        END LOOP;
        
        moi_wykladowcy(5) := 'ZAKRZEWICZ';
        moi_wykladowcy(6) := 'KROLIKOWSKI';
        moi_wykladowcy(7) := 'KOSZLAJDA';
        
        FOR i IN moi_wykladowcy.FIRST() .. moi_wykladowcy.LAST() LOOP
            IF moi_wykladowcy.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
        DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    END;

--------------------------------------------------------
-- 9. Zbuduj kolekcję (w oparciu o tablicę zagnieżdżoną) zawierającą listę miesięcy. Wstaw do
--    kolekcji właściwe dane, usuń parę miesięcy, wyświetl zawartość kolekcji. 
    
    DECLARE
        TYPE t_miesiace IS TABLE OF VARCHAR2(15);
        miesiace t_miesiace := t_miesiace();
    BEGIN
        miesiace.EXTEND(12);
        
        DBMS_OUTPUT.PUT_LINE('Lista miesięcy:');
            FOR i IN 1 .. 12 LOOP
                miesiace(i) := TO_CHAR(TO_DATE('2017-' || LPAD(i, 2, '0') || '-01'), 'month');
            DBMS_OUTPUT.PUT_LINE(miesiace(i));
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE('Lista miesiące z "r" w nazwie:');
        
        FOR i IN miesiace.FIRST .. miesiace.LAST LOOP
            IF INSTR(miesiace(i), 'r') > 0 THEN
                DBMS_OUTPUT.PUT_LINE( miesiace(i));
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE('Co drugi miesiąc, od końca:');
        
        FOR i IN REVERSE miesiace.FIRST .. miesiace.LAST LOOP
            IF MOD(i, 2) != 0 THEN
                DBMS_OUTPUT.PUT_LINE( miesiace(i));
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji: ' || miesiace.count);
        
        miesiace.DELETE(7,12);
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji po usunięciu: ' || miesiace.count);
        
        FOR i IN miesiace.FIRST .. miesiace.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(i || ': ' || miesiace(i));
        END LOOP;
    END;

--------------------------------------------------------
-- 10. Sprawdź działanie obu rodzajów kolekcji w przypadku atrybutów bazodanowych.

    CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
    
    CREATE TYPE stypendium AS OBJECT (nazwa VARCHAR2(50)
                                     ,kraj VARCHAR2(30)
                                     ,jezyki jezyki_obce );
    
    CREATE TABLE stypendia OF stypendium;
    
    INSERT INTO stypendia 
    VALUES ('SOKRATES'
           ,'FRANCJA'
           ,jezyki_obce('ANGIELSKI'
                       ,'FRANCUSKI'
                       ,'NIEMIECKI'));
                       
    INSERT INTO stypendia 
    VALUES ('ERASMUS'
           ,'NIEMCY'
           ,jezyki_obce('ANGIELSKI'
                       ,'NIEMIECKI'
                       ,'HISZPANSKI'));
    
    SELECT  *
    FROM    stypendia;
    
    SELECT  s.jezyki
    FROM    stypendia s;
    
    UPDATE  STYPENDIA
    SET     jezyki = jezyki_obce('ANGIELSKI'
                                ,'NIEMIECKI'
                                ,'HISZPANSKI'
                                ,'FRANCUSKI')
    WHERE   nazwa = 'ERASMUS';
    
    CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
    
    CREATE TYPE semestr AS OBJECT (numer NUMBER
                                  ,egzaminy lista_egzaminow );
    
    CREATE TABLE semestry OF semestr
    NESTED TABLE egzaminy STORE AS tab_egzaminy;
    
    INSERT INTO semestry 
    VALUES (semestr(1
                   ,lista_egzaminow('MATEMATYKA'
                                   ,'LOGIKA'
                                   ,'ALGEBRA')));
    
    INSERT INTO semestry 
    VALUES (semestr(2
                   ,lista_egzaminow('BAZY DANYCH'
                                   ,'SYSTEMY OPERACYJNE')));
                                   
    SELECT  s.numer
            ,e.*
    FROM    semestry s
            ,TABLE(s.egzaminy) e;
    
    SELECT  e.*
    FROM    semestry s
            ,TABLE ( s.egzaminy ) e;
            
    SELECT  *
    FROM    TABLE (SELECT   s.egzaminy
                   FROM     semestry s 
                   WHERE    numer = 1 );
    
    INSERT INTO TABLE (SELECT   s.egzaminy
                       FROM     semestry s
                       WHERE    numer = 2 )
    VALUES ('METODY NUMERYCZNE');
    
    UPDATE TABLE (SELECT   s.egzaminy
                  FROM     semestry s
                  WHERE    numer = 2 ) e
    SET      e.column_value = 'SYSTEMY ROZPROSZONE'
    WHERE    e.column_value = 'SYSTEMY OPERACYJNE';
    
    DELETE
    FROM TABLE (SELECT  s.egzaminy
                FROM    semestry s
                WHERE   numer = 2 ) e
    WHERE    e.column_value = 'BAZY DANYCH';
    
--------------------------------------------------------
-- 11. Zbuduj tabelę ZAKUPY zawierającą atrybut zbiorowy KOSZYK_PRODUKTOW w postaci
--     tabeli zagnieżdżonej. Wstaw do tabeli przykładowe dane. Wyświetl zawartość tabeli, usuń
--     wszystkie transakcje zawierające wybrany produkt. 

    CREATE TABLE zakupy (
    );

--------------------------------------------------------
-- 12. Zbuduj hierarchię reprezentującą instrumenty muzyczne
    
    CREATE TYPE instrument AS OBJECT (nazwa VARCHAR2(20)
                                     ,dzwiek VARCHAR2(20)
                                     ,MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
    
    CREATE TYPE BODY instrument 
    AS
        MEMBER FUNCTION graj 
        RETURN VARCHAR2 
        IS
            BEGIN
            RETURN dzwiek;
        END;
    END;
    /
    
    CREATE TYPE instrument_dety UNDER instrument (material VARCHAR2(20)
                                                 ,OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2
                                                 ,MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2);
    
    CREATE OR REPLACE TYPE BODY instrument_dety 
    AS
        OVERRIDING MEMBER FUNCTION graj 
        RETURN VARCHAR2 
        IS
        BEGIN
            RETURN 'dmucham: ' || dzwiek;
        END;
            
        MEMBER FUNCTION graj(glosnosc VARCHAR2)
        RETURN VARCHAR2 
        IS
        BEGIN
            RETURN glosnosc || ':' || dzwiek;
        END;
    END;
    /
    
    CREATE TYPE instrument_klawiszowy UNDER instrument (producent VARCHAR2(20)
                                                       ,OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2);
    
    CREATE OR REPLACE TYPE BODY instrument_klawiszowy 
    AS
        OVERRIDING MEMBER FUNCTION graj 
        RETURN VARCHAR2 
        IS
        BEGIN
            RETURN 'stukam w klawisze: ' || dzwiek;
        END;
    END;
    /
    
    DECLARE
        tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
        trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
        fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
    BEGIN
        dbms_output.put_line(tamburyn.graj);
        dbms_output.put_line(trabka.graj);
        dbms_output.put_line(trabka.graj('glosno'));
        dbms_output.put_line(fortepian.graj);
    END;

--------------------------------------------------------
-- 13. Zbuduj hierarchię zwierząt i przetestuj klasy abstrakcyjne

    CREATE TYPE istota AS OBJECT (nazwa VARCHAR2(20)
                                 ,NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR)
    NOT INSTANTIABLE NOT FINAL;
    
    CREATE TYPE lew UNDER istota (liczba_nog NUMBER
                                 ,OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR);
    
    CREATE OR REPLACE TYPE BODY lew 
    AS
        OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) 
        RETURN CHAR 
        IS
        BEGIN
            RETURN 'upolowana ofiara: ' || ofiara;
        END;
    END;
    /
    
    DECLARE
        KrolLew lew := lew('LEW',4);
        InnaIstota istota := istota('JAKIES ZWIERZE');
    BEGIN
        DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
    END;

--------------------------------------------------------
-- 14. Zbadaj własność polimorfizmu na przykładzie hierarchii instrumentów

    DECLARE
        tamburyn instrument;
        cymbalki instrument;
        trabka instrument_dety;
        saksofon instrument_dety;
    BEGIN
        tamburyn := instrument('tamburyn','brzdek-brzdek');
        cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
        trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
        -- saksofon := instrument('saksofon','tra-taaaa');
        -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
    END;

--------------------------------------------------------
-- 15. Zbuduj tabelę zawierającą różne instrumenty. Zbadaj działanie funkcji wirtualnych
    
    CREATE TABLE instrumenty OF instrument;
    
    INSERT INTO instrumenty 
    VALUES (instrument('tamburyn'
                      ,'brzdek-brzdek'));
                    
    INSERT INTO instrumenty
    VALUES (instrument_dety('trabka'
                           ,'tra-tata'
                           ,'metalowa'));
                        
    INSERT INTO instrumenty
    VALUES (instrument_klawiszowy('fortepian'
                                 ,'pingping'
                                 ,'steinway'));
    
    SELECT  i.nazwa
            ,i.graj()
    FROM    instrumenty i;
    
--------------------------------------------------------
-- 16. Utwórz dodatkową tabelę PRZEDMIOTY i wypełnij ją przykładowymi danymi

    CREATE TABLE przedmioty(nazwa VARCHAR2(50)
                           ,nauczyciel NUMBER REFERENCES pracownicy(id_prac));
    
    INSERT INTO przedmioty 
    VALUES ('BAZY DANYCH'
           ,100);
    
    INSERT INTO przedmioty 
    VALUES ('SYSTEMY OPERACYJNE'
           ,100);
    
    INSERT INTO przedmioty 
    VALUES ('PROGRAMOWANIE'
           ,110);
    
    INSERT INTO przedmioty 
    VALUES ('SIECI KOMPUTEROWE'
           ,110);
    
    INSERT INTO przedmioty 
    VALUES ('BADANIA OPERACYJNE'
           ,120);
    
    INSERT INTO przedmioty 
    VALUES ('GRAFIKA KOMPUTEROWA'
           ,120);
    
    INSERT INTO przedmioty 
    VALUES ('BAZY DANYCH'
           ,130);
    
    INSERT INTO przedmioty 
    VALUES ('SYSTEMY OPERACYJNE'
           ,140);
    
    INSERT INTO przedmioty 
    VALUES ('PROGRAMOWANIE'
           ,140);
    
    INSERT INTO przedmioty 
    VALUES ('SIECI KOMPUTEROWE'
           ,140);
    
    INSERT INTO przedmioty 
    VALUES ('BADANIA OPERACYJNE'
           ,150);
    
    INSERT INTO przedmioty 
    VALUES ('GRAFIKA KOMPUTEROWA'
           ,150);
    
    INSERT INTO przedmioty 
    VALUES ('BAZY DANYCH'
           ,160);
    
    INSERT INTO przedmioty 
    VALUES ('SYSTEMY OPERACYJNE'
           ,160);
    
    INSERT INTO przedmioty 
    VALUES ('PROGRAMOWANIE'
           ,170);
    
    INSERT INTO przedmioty 
    VALUES ('SIECI KOMPUTEROWE'
           ,180);
    
    INSERT INTO przedmioty 
    VALUES ('BADANIA OPERACYJNE'
           ,180);
    
    INSERT INTO przedmioty 
    VALUES ('GRAFIKA KOMPUTEROWA'
           ,190);
    
    INSERT INTO przedmioty 
    VALUES ('GRAFIKA KOMPUTEROWA'
           ,200);
    
    INSERT INTO przedmioty 
    VALUES ('GRAFIKA KOMPUTEROWA'
           ,210);
    
    INSERT INTO przedmioty 
    VALUES ('PROGRAMOWANIE'
           ,220);
    
    INSERT INTO przedmioty 
    VALUES ('SIECI KOMPUTEROWE'
           ,220);
    
    INSERT INTO przedmioty 
    VALUES ('BADANIA OPERACYJNE'
           ,230);
    
--------------------------------------------------------
-- 17. Stwórz typ który będzie odpowiadał krotkom z relacji ZESPOLY

    CREATE TYPE zespol AS OBJECT (id_zesp NUMBER
                                 ,nazwa VARCHAR2(50)
                                 ,adres VARCHAR2(100));

--------------------------------------------------------
-- 18. Na bazie stworzonego typu zbuduj perspektywę obiektową przedstawiającą dane z relacji ZESPOLY w sposób obiektowy.

    CREATE OR REPLACE VIEW zespoly_v OF zespol
    WITH OBJECT identifier(id_zesp)
    AS  
    SELECT  id_zesp
            ,nazwa
            ,adres
    FROM    zespoly;
 
--------------------------------------------------------
-- 19. Utwórz typ tablicowy do przechowywania zbioru przedmiotów wykładanych przez każdego
--     nauczyciela. Stwórz typ odpowiadający krotkom z relacji PRACOWNICY. Każdy obiekt typu
--     pracownik powinien posiadać unikalny numer, nazwisko, etat, datę zatrudnienia, płacę
--     podstawową, miejsce pracy (referencja do właściwego zespołu) oraz zbiór wykładanych
--     przedmiotów. Typ powinien też zawierać metodę służącą do wyliczania liczby przedmiotów
--     wykładanych przez wykładowcę.

    CREATE TYPE przedmioty_tab AS TABLE OF VARCHAR2(100);
    /

    CREATE TYPE pracownik AS OBJECT (id_prac NUMBER
                                    ,nazwisko VARCHAR2(30)
                                    ,etat VARCHAR2(20)
                                    ,zatrudniony DATE
                                    ,placa_pod NUMBER(10,2)
                                    ,miejsce_pracy REF zespol
                                    ,przedmioty przedmioty_tab
                                    ,MEMBER FUNCTION ile_przedmiotow RETURN NUMBER);
    
    CREATE OR REPLACE TYPE BODY pracownik 
    AS
        MEMBER FUNCTION ile_przedmiotow 
        RETURN NUMBER IS
        BEGIN
            RETURN przedmioty.COUNT();
         END ile_przedmiotow;
    END;
    /
    
--------------------------------------------------------
-- 20. Na bazie stworzonego typu zbuduj perspektywę obiektową przedstawiającą dane z relacji
--     PRACOWNICY w sposób obiektowy.

    CREATE OR REPLACE VIEW pracownicy_v OF pracownik
    WITH OBJECT identifier(id_prac)
    AS     
    SELECT  id_prac
            ,nazwisko
            ,etat
            ,zatrudniony
            ,placa_pod
            ,MAKE_REF(zespoly_v, id_zesp)
            ,CAST(MULTISET(SELECT   nazwa
                           FROM     przedmioty 
                           WHERE    nauczyciel = p.id_prac) AS przedmioty_tab)
    FROM pracownicy p;

--------------------------------------------------------
-- 21. Sprawdź różne sposoby wyświetlania danych z perspektywy obiektowej

    SELECT  *
    FROM    pracownicy_v;
    
    SELECT  p.nazwisko
            ,p.etat
            ,p.miejsce_pracy.nazwa
    FROM    pracownicy_v p;
    
    SELECT  p.nazwisko
            ,p.ile_przedmiotow()
    FROM    pracownicy_v p;
    
    SELECT  *
    FROM    TABLE(SELECT   przedmioty
                  FROM     pracownicy_v 
                  WHERE    nazwisko = 'WEGLARZ' );
    
    SELECT  nazwisko
            ,CURSOR(SELECT  przedmioty
                    FROM    pracownicy_v
                    WHERE   id_prac = p.id_prac)
    FROM    pracownicy_v p;
    
--------------------------------------------------------
-- 22. Dane są poniższe relacje. Zbuduj interfejs składający się z dwóch typów i dwóch perspektyw
--     obiektowych, który umożliwi interakcję ze schematem relacyjnym. Typ odpowiadający
--     krotkom z relacji PISARZE powinien posiadać metodę wyznaczającą liczbę książek
--     napisanych przez danego pisarza. Typ odpowiadający krotkom z relacji KSIAZKI powinien
--     posiadać metodę wyznaczającą wiek książki (w latach).
    
    CREATE TABLE pisarze (id_pisarza NUMBER PRIMARY KEY
                         ,nazwisko VARCHAR2(20)
                         ,data_ur DATE);
    
    CREATE TABLE ksiazki (id_ksiazki NUMBER PRIMARY KEY
                         ,id_pisarza NUMBER NOT NULL REFERENCES pisarze
                         ,tytul VARCHAR2(50)
                         ,data_wydania DATE );
    
    INSERT INTO pisarze 
    VALUES (10
           ,'SIENKIEWICZ'
           ,DATE '1880-01-01');
    
    INSERT INTO pisarze 
    VALUES (20
           ,'PRUS'
           ,DATE '1890-04-12');
    
    INSERT INTO pisarze 
    VALUES (30
           ,'ZEROMSKI'
           ,DATE '1899-09-11');
    
    INSERT INTO ksiazki (id_ksiazki
                        ,id_pisarza
                        ,tytul
                        ,data_wydania)
    VALUES (10
           ,10
           ,'OGNIEM I MIECZEM'
           ,DATE '1990-01-05');
    
    INSERT INTO ksiazki(id_ksiazki
                       ,id_pisarza
                       ,tytul
                       ,data_wydania)
    VALUES(20
          ,10
          ,'POTOP'
          ,DATE '1975-12-09');
    
    INSERT INTO ksiazki(id_ksiazki
                       ,id_pisarza
                       ,tytul
                       ,data_wydania)
    VALUES(30
          ,10
          ,'PAN WOLODYJOWSKI'
          ,DATE '1987-02-15');
    
    INSERT INTO ksiazki(id_ksiazki
                       ,id_pisarza
                       ,tytul
                       ,data_wydania)
    VALUES (40
           ,20
           ,'FARAON'
           ,DATE '1948-01-21');
    
    INSERT INTO ksiazki(id_ksiazki
                       ,id_pisarza
                       ,tytul
                       ,data_wydania)
    VALUES (50
           ,20
           ,'LALKA'
           ,DATE '1994-08-01');
    
    INSERT INTO ksiazki(id_ksiazki
                       ,id_pisarza
                       ,tytul
                       ,data_wydania)
    VALUES (60
           ,30
           ,'PRZEDWIOSNIE'
           ,DATE '1938-02-02'); 
 
--------------------------------------------------------
-- 23. Zbuduj hierarchię aut (auto, auto osobowe, auto ciężarowe) i przetestuj następujące mechanizmy obiektowe:
--     • dziedziczenie: auto osobowe ma dodatkowe atrybuty określające liczbę miejsc
--     (atrybut numeryczny) oraz wyposażenie w klimatyzację (tak/nie). Auto ciężarowe ma
--     dodatkowy atrybut określający maksymalną ładowność (atrybut numeryczny)
--     • przesłanianie metod: zdefiniuj na nowo w typach AUTO_OSOBOWE i
--     AUTO_CIEZAROWE metodę określającą wartość auta. W przypadku auta
--     osobowego przyjmij, że fakt wyposażenia auta w klimatyzację zwiększa wartość auta
--     o 50%. W przypadku auta ciężarowego ładowność powyżej 10T zwiększa wartość
--     auta o 100%
--     • polimorfizm i późne wiązanie metod: wstaw do tabeli obiektowej przechowującej
--     auta dwa auta osobowe (jedno z klimatyzacją i drugie bez klimatyzacji) oraz dwa auta
--     ciężarowe (o ładownościach 8T i 12T).
--     Wyświetl markę i wartość każdego auta przechowywanego w tabeli obiektowej.
    
    CREATE TYPE auto AS OBJECT (marka VARCHAR2(20)
                               ,model VARCHAR2(20)
                               ,kilometry NUMBER
                               ,data_produkcji DATE
                               ,cena NUMBER(10,2)
                               ,MEMBER FUNCTION wartosc RETURN NUMBER);
    
    CREATE OR REPLACE TYPE BODY auto 
    AS
        MEMBER FUNCTION wartosc 
        RETURN NUMBER 
        IS
            wiek NUMBER;
            wartosc NUMBER;
        BEGIN
            wiek := ROUND(MONTHS_BETWEEN(SYSDATE, data_produkcji) / 12);
            wartosc := cena - (wiek * 0.1 * cena);
        
        IF (wartosc < 0) THEN
            wartosc := 0;
        END IF;
        
        RETURN wartosc;
        END wartosc;
    END;
    /
    
    CREATE TABLE auta OF auto;
    
    INSERT INTO auta 
    VALUES (auto('FIAT'
                ,'BRAVA'
                ,60000
                ,DATE '1999-11-30'
                ,25000));
    
    INSERT INTO auta 
    VALUES (auto('FORD'
                ,'MONDEO'
                ,80000
                ,DATE '1997-05-10'
                ,45000));
    
    INSERT INTO auta 
    VALUES (auto('MAZDA'
                ,'323'
                ,12000
                ,DATE '2000-09-22'
                ,52000)); 

