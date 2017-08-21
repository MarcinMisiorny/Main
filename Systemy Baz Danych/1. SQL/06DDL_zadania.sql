/*
* --------------------------------------------
* Rozdzia� 6. J�zyk definiowania danych DDL �
* zadania
* --------------------------------------------
* 
* Plik z zadaniami: 06DDL_zadania.pdf
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Utw�rz poni�sze relacje.

-- 
-- Nazwa relacji: PROJEKTY
-- Nazwa				Typ									Rozmiar		W�asno�ci
-- ID_PROJEKTU			Liczba ca�kowita					4			Klucz podstawowy o nazwie PROJEKTY_PK
-- OPIS_PROJEKTU		�a�cuch znak�w zmiennej d�ugo�ci	20			Wymagany, klucz unikalny o nazwie PROJEKTY_UK
-- DATA_ROZPOCZECIA		Data											Domy�lnie data systemowa
-- DATA_ZAKONCZENIA		Data											P�niejsza ni� DATA_ROZPOCZECIA, ograniczenie ma nosi� nazw� PROJEKTY_DATY_CHK
-- FUNDUSZ				Liczba								7,2			Wi�kszy lub r�wny 0, ograniczenie ma nosi� nazw� PROJEKTY_FUNDUSZ_CHK
-- 
-- 
-- Nazwa relacji: PRZYDZIALY
-- Nazwa				Typ									Rozmiar		W�asno�ci
-- ID_PROJEKTU			Liczba ca�kowita					4			Niepusty klucz obcy o nazwie PRZYDZIALY_FK_01 do kolumny ID_PROJEKTU w relacji PROJEKTY
-- NR_PRACOWNIKA		Liczba ca�kowita					6			Niepusty klucz obcy o nazwie PRZYDZIALY_FK_02 do kolumny ID_PRAC w relacji PRACOWNICY
-- OD					Data											Domy�lnie data systemowa
-- DO					Data											P�niejsza ni� OD, ograniczenie ma nosi� nazw� PRZYDZIALY_DATY_CHK
-- STAWKA				Liczba								7,2			Wi�ksza od 0, ograniczenie ma nosi� nazw� PRZYDZIALY_STAWKA_CHK
-- ROLA					�a�cuch znak�w o zmiennej d�ugo�ci	20			Dopuszczalne warto�ci to: �KIERUJ�CY� �ANALITYK� �PROGRAMISTA�; ograniczenie ma nosi� 
--																		nazw� PRZYDZIALY_ROLA_CHK
--																					
-- Kluczem podstawowym relacji PRZYDZIALY jest para atrybut�w (ID_PROJEKTU, NR_PRACOWNIKA), nazwa klucza to PRZYDZIALY_PK.
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
							,rola VARCHAR2(20) CONSTRAINT przydzialy_rola_chk CHECK (rola IN ('KIERUJ�CY', 'ANALITYK', 'PROGRAMISTA'))
							,CONSTRAINT przydzialy_daty_chk CHECK (DO > od), CONSTRAINT przydzialy_pk PRIMARY KEY (id_projektu, nr_pracownika));
--------------------------------------------------------
-- 2. Dodaj do relacji PRZYDZIALY atrybut GODZINY, b�d�cy liczb� ca�kowit� o
--	  maksymalnej warto�ci r�wnej 9999.

	ALTER TABLE przydzialy ADD godziny NUMBER(4); 

--------------------------------------------------------
-- 3. Dodaj do utworzonych przez siebie relacji komentarze i wy�wietl te komentarze.

	COMMENT ON TABLE projekty IS 'Lista projekt�w prowadzonych przez pracownik�w';
	COMMENT ON TABLE przydzialy IS 'Informacje o przydziale poszczeg�lnych pracownik�w do projekt�w';

--------------------------------------------------------					 
-- 4. Wy�wietl informacje o ograniczeniach za�o�onych na relacji PRZYDZIALY

	SELECT	constraint_name
			,constraint_type
			,search_condition
	FROM	user_constraints
	WHERE	table_name = 'PRZYDZIALY';

--------------------------------------------------------
-- 5. Wy��cz tymczasowo sprawdzanie unikalno�ci opis�w projekt�w.

	ALTER TABLE projekty DISABLE CONSTRAINT projekty_uk; 
  
--------------------------------------------------------
-- 6. Zwi�ksz maksymalny rozmiar atrybutu OPIS_PROJEKTU do 30 znak�w.

	ALTER TABLE projekty MODIFY opis_projektu VARCHAR2(30);

--------------------------------------------------------
-- 7. Utw�rz relacj� PRACOWNICY_ZESPOLY zawieraj�c� poni�sze dane (roczna p�aca to
--	  dwunastokrotno�� p�acy podstawowej plus p�aca dodatkowa). Pos�u� si� mechanizmem
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
--8. Aktywuj wy��czone w punkcie 5. ograniczenie.
	
	ALTER TABLE projekty ENABLE CONSTRAINT projekty_uk;

