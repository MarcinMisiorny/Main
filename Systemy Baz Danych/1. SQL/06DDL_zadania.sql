/*
* --------------------------------------------
* Rozdział 6. Język definiowania danych DDL –
* zadania
* --------------------------------------------
* 
* Plik z zadaniami: 06DDL_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Utwórz poniższe relacje.

-- 
-- Nazwa relacji: PROJEKTY
-- Nazwa		Typ					Rozmiar		Własności
-- ID_PROJEKTU		Liczba całkowita			4		Klucz podstawowy o nazwie PROJEKTY_PK
-- OPIS_PROJEKTU	Łańcuch znaków zmiennej długości	20		Wymagany, klucz unikalny o nazwie PROJEKTY_UK
-- DATA_ROZPOCZECIA	Data							Domyślnie data systemowa
-- DATA_ZAKONCZENIA	Data							Późniejsza niż DATA_ROZPOCZECIA, ograniczenie ma nosić nazwę PROJEKTY_DATY_CHK
-- FUNDUSZ		Liczba					7,2		Większy lub równy 0, ograniczenie ma nosić nazwę PROJEKTY_FUNDUSZ_CHK
-- 
-- 
-- Nazwa relacji: PRZYDZIALY
-- Nazwa		Typ					Rozmiar		Własności
-- ID_PROJEKTU		Liczba całkowita			4		Niepusty klucz obcy o nazwie PRZYDZIALY_FK_01 do kolumny ID_PROJEKTU w relacji PROJEKTY
-- NR_PRACOWNIKA	Liczba całkowita			6		Niepusty klucz obcy o nazwie PRZYDZIALY_FK_02 do kolumny ID_PRAC w relacji PRACOWNICY
-- OD			Data							Domyślnie data systemowa
-- DO			Data							Późniejsza niż OD, ograniczenie ma nosić nazwę PRZYDZIALY_DATY_CHK
-- STAWKA		Liczba					7,2		Większa od 0, ograniczenie ma nosić nazwę PRZYDZIALY_STAWKA_CHK
-- ROLA			Łańcuch znaków o zmiennej długości	20		Dopuszczalne wartości to: ‘KIERUJĄCY’ ‘ANALITYK’ ‘PROGRAMISTA’; ograniczenie ma nosić 
--																		nazwę PRZYDZIALY_ROLA_CHK
--																					
-- Kluczem podstawowym relacji PRZYDZIALY jest para atrybutów (ID_PROJEKTU, NR_PRACOWNIKA), nazwa klucza to PRZYDZIALY_PK.
-- 


	CREATE TABLE projekty 
	(id_projektu NUMBER(4) CONSTRAINT projekty_pk PRIMARY KEY
        ,opis_projektu VARCHAR2(20) NOT NULL CONSTRAINT projekty_uk UNIQUE
        ,data_rozpoczecia DATE DEFAULT SYSDATE
        ,data_zakonczenia DATE 
	,fundusz NUMBER(7,2) CONSTRAINT projekty_fundusz_chk CHECK (fundusz >= 0) 
	,CONSTRAINT projekty_daty_chk CHECK (data_zakonczenia > data_rozpoczecia));


	CREATE TABLE przydzialy 
	(id_projektu NUMBER (4) NOT NULL CONSTRAINT przydzialy_fk_01 REFERENCES PROJEKTY(id_projektu)
        ,nr_pracownika NUMBER(6) NOT NULL CONSTRAINT przydzialy_fk_02 REFERENCES PRACOWNICY(id_prac)
        ,od DATE DEFAULT SYSDATE
        ,DO DATE, stawka NUMBER (7,2) CONSTRAINT przydzialy_stawka_chk CHECK (stawka > 0)
	,rola VARCHAR2(20) CONSTRAINT przydzialy_rola_chk CHECK (rola IN ('KIERUJĄCY', 'ANALITYK', 'PROGRAMISTA'))
	,CONSTRAINT przydzialy_daty_chk CHECK (DO > od), CONSTRAINT przydzialy_pk PRIMARY KEY (id_projektu, nr_pracownika));
--------------------------------------------------------
-- 2. Dodaj do relacji PRZYDZIALY atrybut GODZINY, będący liczbą całkowitą o
--    maksymalnej wartości równej 9999.

	ALTER TABLE przydzialy ADD godziny NUMBER(4); 

--------------------------------------------------------
-- 3. Dodaj do utworzonych przez siebie relacji komentarze i wyświetl te komentarze.

	COMMENT ON TABLE projekty IS 'Lista projektów prowadzonych przez pracowników';
	COMMENT ON TABLE przydzialy IS 'Informacje o przydziale poszczególnych pracowników do projektów';

--------------------------------------------------------					 
-- 4. Wyświetl informacje o ograniczeniach założonych na relacji PRZYDZIALY

	SELECT	constraint_name
		,constraint_type
		,search_condition
	FROM	user_constraints
	WHERE	table_name = 'PRZYDZIALY';

--------------------------------------------------------
-- 5. Wyłącz tymczasowo sprawdzanie unikalności opisów projektów.

	ALTER TABLE projekty DISABLE CONSTRAINT projekty_uk; 
  
--------------------------------------------------------
-- 6. Zwiększ maksymalny rozmiar atrybutu OPIS_PROJEKTU do 30 znaków.

	ALTER TABLE projekty MODIFY opis_projektu VARCHAR2(30);

--------------------------------------------------------
-- 7. Utwórz relację PRACOWNICY_ZESPOLY zawierającą poniższe dane (roczna płaca to
--    dwunastokrotność płacy podstawowej plus płaca dodatkowa). Posłuż się mechanizmem
--    tworzenia relacji w oparciu o zapytanie.

	CREATE TABLE pracownicy_zespoly (nazwisko
					,posada
					,roczna_placa
					,zespol
					,adres_pracy) AS
	SELECT	p.nazwisko
		,p.etat
		,(p.placa_pod * 12) + NVL(p.placa_dod, 0) 
		,z.nazwa AS zespol
		,z.adres AS adres_pracy
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp);
	
--------------------------------------------------------
--8. Aktywuj wyłączone w punkcie 5. ograniczenie.
	
	ALTER TABLE projekty ENABLE CONSTRAINT projekty_uk;

