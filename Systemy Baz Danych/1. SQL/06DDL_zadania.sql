/*
* --------------------------------------------
* Rozdzia³ 6. Jêzyk definiowania danych DDL –
* zadania
* --------------------------------------------
* 
* Plik z zadaniami: 06DDL_zadania.pdf
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Utwórz poni¿sze relacje.

-- 
-- Nazwa relacji: PROJEKTY
-- Nazwa				Typ									Rozmiar		W³asnoœci
-- ID_PROJEKTU			Liczba ca³kowita					4			Klucz podstawowy o nazwie PROJEKTY_PK
-- OPIS_PROJEKTU		£añcuch znaków zmiennej d³ugoœci	20			Wymagany, klucz unikalny o nazwie PROJEKTY_UK
-- DATA_ROZPOCZECIA		Data											Domyœlnie data systemowa
-- DATA_ZAKONCZENIA		Data											PóŸniejsza ni¿ DATA_ROZPOCZECIA, ograniczenie ma nosiæ nazwê PROJEKTY_DATY_CHK
-- FUNDUSZ				Liczba								7,2			Wiêkszy lub równy 0, ograniczenie ma nosiæ nazwê PROJEKTY_FUNDUSZ_CHK
-- 
-- 
-- Nazwa relacji: PRZYDZIALY
-- Nazwa				Typ									Rozmiar		W³asnoœci
-- ID_PROJEKTU			Liczba ca³kowita					4			Niepusty klucz obcy o nazwie PRZYDZIALY_FK_01 do kolumny ID_PROJEKTU w relacji PROJEKTY
-- NR_PRACOWNIKA		Liczba ca³kowita					6			Niepusty klucz obcy o nazwie PRZYDZIALY_FK_02 do kolumny ID_PRAC w relacji PRACOWNICY
-- OD					Data											Domyœlnie data systemowa
-- DO					Data											PóŸniejsza ni¿ OD, ograniczenie ma nosiæ nazwê PRZYDZIALY_DATY_CHK
-- STAWKA				Liczba								7,2			Wiêksza od 0, ograniczenie ma nosiæ nazwê PRZYDZIALY_STAWKA_CHK
-- ROLA					£añcuch znaków o zmiennej d³ugoœci	20			Dopuszczalne wartoœci to: ‘KIERUJ¥CY’ ‘ANALITYK’ ‘PROGRAMISTA’; ograniczenie ma nosiæ 
--																		nazwê PRZYDZIALY_ROLA_CHK
--																					
-- Kluczem podstawowym relacji PRZYDZIALY jest para atrybutów (ID_PROJEKTU, NR_PRACOWNIKA), nazwa klucza to PRZYDZIALY_PK.
-- 


	CREATE TABLE projekty (id_projektu NUMBER(4) CONSTRAINT projekty_pk PRIMARY KEY
                          ,opis_projektu VARCHAR2(20) NOT NULL CONSTRAINT projekty_uk UNIQUE
                          ,data_rozpoczecia DATE DEFAULT SYSDATE
                          ,data_zakonczenia DATE 
						  ,fundusz NUMBER(7,2) CONSTRAINT projekty_fundusz_chk CHECK (fundusz >= 0) 
						  ,CONSTRAINT projekty_daty_chk CHECK (data_zakonczenia > data_rozpoczecia));


	CREATE TABLE przydzialy (id_projektu NUMBER (4) NOT NULL CONSTRAINT przydzialy_fk_01 REFERENCES PROJEKTY(id_projektu)
                            ,nr_pracownika NUMBER(6) NOT NULL CONSTRAINT przydzialy_fk_02 REFERENCES PRACOWNICY(id_prac)
                            ,od DATE DEFAULT SYSDATE
                            ,DO DATE, stawka NUMBER (7,2) CONSTRAINT przydzialy_stawka_chk CHECK (stawka > 0)
							,rola VARCHAR2(20) CONSTRAINT przydzialy_rola_chk CHECK (rola IN ('KIERUJ¥CY', 'ANALITYK', 'PROGRAMISTA'))
							,CONSTRAINT przydzialy_daty_chk CHECK (DO > od), CONSTRAINT przydzialy_pk PRIMARY KEY (id_projektu, nr_pracownika));
--------------------------------------------------------
-- 2. Dodaj do relacji PRZYDZIALY atrybut GODZINY, bêd¹cy liczb¹ ca³kowit¹ o
--	  maksymalnej wartoœci równej 9999.

	ALTER TABLE przydzialy ADD godziny NUMBER(4); 

--------------------------------------------------------
-- 3. Dodaj do utworzonych przez siebie relacji komentarze i wyœwietl te komentarze.

	COMMENT ON TABLE projekty IS 'Lista projektów prowadzonych przez pracowników';
	COMMENT ON TABLE przydzialy IS 'Informacje o przydziale poszczególnych pracowników do projektów';

--------------------------------------------------------					 
-- 4. Wyœwietl informacje o ograniczeniach za³o¿onych na relacji PRZYDZIALY

	SELECT	constraint_name
			,constraint_type
			,search_condition
	FROM	user_constraints
	WHERE	table_name = 'PRZYDZIALY';

--------------------------------------------------------
-- 5. Wy³¹cz tymczasowo sprawdzanie unikalnoœci opisów projektów.

	ALTER TABLE projekty DISABLE CONSTRAINT projekty_uk; 
  
--------------------------------------------------------
-- 6. Zwiêksz maksymalny rozmiar atrybutu OPIS_PROJEKTU do 30 znaków.

	ALTER TABLE projekty MODIFY opis_projektu VARCHAR2(30);

--------------------------------------------------------
-- 7. Utwórz relacjê PRACOWNICY_ZESPOLY zawieraj¹c¹ poni¿sze dane (roczna p³aca to
--	  dwunastokrotnoœæ p³acy podstawowej plus p³aca dodatkowa). Pos³u¿ siê mechanizmem
--	  tworzenia relacji w oparciu o zapytanie.

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
--8. Aktywuj wy³¹czone w punkcie 5. ograniczenie.
	
	ALTER TABLE projekty ENABLE CONSTRAINT projekty_uk;

