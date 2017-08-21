/*
* --------------------------------------------
* Rozdział 12. Pakiety, dynamiczny SQL – zadania
* --------------------------------------------
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
* Plik z zadaniami: 12Pakiety_zadania.pdf
* 
* Prefiks zmiennych odnosi się do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Napisz pakiet KONWERSJA zawierający funkcje CELS_TO_FAHR (konwertującą skalę Celsjusza na
--    skalę Fahrenheita) i FAHR_TO_CELS (konwertującą skalę Fahrenheita na skalę Celsjusza).
--    Wskazówka:
--    TC = 5/9 * (TF - 32) TF = 9/5 * TC + 32

	CREATE OR REPLACE PACKAGE konwersja
	IS
		FUNCTION cels_to_fahr 
		(p_wartosc IN NUMBER) 
		RETURN NUMBER;
		
		FUNCTION fahr_to_cels 
		(p_wartosc IN NUMBER) 
		RETURN NUMBER;
	END;
	/
	
	CREATE OR REPLACE PACKAGE BODY konwersja
	IS
		FUNCTION cels_to_fahr
		(p_wartosc NUMBER)
		RETURN NUMBER
		IS
			n_wynik NUMBER;
		BEGIN
			n_wynik := 9/5 * p_wartosc + 32;
			 
			RETURN n_wynik;
		END cels_to_fahr;
		
		FUNCTION fahr_to_cels
		(p_wartosc NUMBER)
		RETURN NUMBER
		IS
			n_wynik NUMBER;
		BEGIN
			n_wynik := 5/9 * (p_wartosc - 32);
			
			RETURN n_wynik;
		END fahr_to_cels;
	END;
	/


-- 2. Przetestuj działanie zmiennych pakietowych. W tym celu utwórz pakiet o nazwie ZMIENNE, w jego
--    specyfikacji zadeklaruj:
--    · zmienną vLicznik typu numerycznego, zmienną zainicjalizuj wartością 0,
--    · procedury: ZwiekszLicznik, ZmniejszLicznik oraz funkcję PokazLicznik.
--    Następnie w ciele pakietu zaimplementuj:
--    · procedurę ZwiekszLicznik – jej zadaniem będzie zwiększenie aktualnej wartości zmiennej
--    vLicznik o 1 i wypisanie na konsoli tekstu „Zwiększono”,
--    · procedurę ZmniejszLicznik – jej zadaniem będzie zmniejszenie aktualnej wartości zmiennej
--    vLicznik o 1 i wypisanie na konsoli tekstu „Zmniejszono”,
--    · funkcję PokazLicznik – jej wartością zwracaną będzie aktualna wartości zmiennej vLicznik,
--    · część inicjalizacyjną pakietu – dokona ona ustawienia wartości zmiennej vLicznik na 1 i wypisze
--    na konsoli tekst „Zainicjalizowano”.

	CREATE OR REPLACE PACKAGE zmienne
	IS
		vlicznik NUMBER;
		
		PROCEDURE zwiekszlicznik;
		PROCEDURE zmniejszlicznik;
		
		FUNCTION pokazlicznik
		RETURN NUMBER;
	END;
	/
	
	CREATE OR REPLACE PACKAGE BODY ZMIENNE
	IS
		PROCEDURE zwiekszlicznik
		IS
		BEGIN
			vlicznik := vlicznik + 1;
			
			DBMS_OUTPUT.PUT_LINE('Zwiększono');
		END zwiekszlicznik;
		
		PROCEDURE zmniejszlicznik
		IS
		BEGIN
			vlicznik := vlicznik - 1;
			
			DBMS_OUTPUT.PUT_LINE('Zmniejszono');
		END zmniejszlicznik;
		
		FUNCTION pokazlicznik
		RETURN NUMBER
		IS
		BEGIN
			RETURN vlicznik;
		END pokazlicznik;
	BEGIN
		vlicznik := 1;
		
		DBMS_OUTPUT.PUT_LINE('Zainicjalizowano');
	END;
	/


-- 3. Zaprojektuj procedurę IleRekordow, której parametrem będzie nazwa relacji. Procedura ma za zadanie
--    wypisać liczbę rekordów relacji. Przy konstrukcji funkcji wykorzystaj mechanizm dynamicznego SQL’a.

	CREATE OR REPLACE PROCEDURE ilerekordow 
	(p_nazwa_relacji IN VARCHAR2)
	IS
		v_sql_stmt VARCHAR2(100);
		n_ile_rekordow NUMBER;
	BEGIN
		-- UWAGA! Nie można tu zastosować 'SELECT COUNT(*) FROM :nazwa_relacji',
		-- ponieważ spowoduje to ORA-00903: invalid table name
		-- Tips: Identifiers (table names, column names and so forth) cannot be bound. 
		
		v_sql_stmt := 'SELECT	COUNT(*)
			       FROM	' 
			       || p_nazwa_relacji;
		 
		EXECUTE IMMEDIATE v_sql_stmt
		INTO 		  n_ile_rekordow;
	
		DBMS_OUTPUT.PUT_LINE('Liczba rekordów relacji ' || UPPER(p_nazwa_relacji) || ': ' || n_ile_rekordow);
	END ilerekordow;
	/


-- 4. Zaprojektuj pakiet o nazwie MODYFIKACJE. Pakiet ma zawierać następujące procedury:
--    · DodajKolumne(relacja, kolumna, typ_wartości) – dodaje do wskazanej parametrem relacji nową
--    kolumnę (parametr) o danym typie wartości (parametr),
--    · UsuńKolumne(relacja, kolumna) – usuwa ze wskazanej parametrem relacji wskazaną kolumnę
--    (parametr),
--    · ZmieńTypKolumny(relacja, kolumna, typ_wartości, czy_zachować_dane) – zmienia typ kolumny
--    (parametr) wskazanej relacji (parametr) na podany (parametr), ostatni parametr ma wskazywać,
--    czy dane modyfikowanej kolumny mają zostać zachowane czy też usunięte.
--    Pakiet ma wykorzystywać mechanizm dynamicznego SQL’a.

	CREATE OR REPLACE PACKAGE modyfikacje
	IS
		PROCEDURE dodajkolumne 
		(p_relacja IN VARCHAR2
		,p_kolumna IN VARCHAR2
		,p_typ_wartosci IN VARCHAR2);
		
		PROCEDURE usunkolumne
		(p_relacja IN VARCHAR2
		,p_kolumna IN VARCHAR2);
		
		PROCEDURE zmientypkolumny
		(p_relacja IN VARCHAR2
		,p_kolumna IN VARCHAR2
		,p_typ_wartosci IN VARCHAR2
		,p_czy_zachowac_dane IN VARCHAR2);
	END;
	/
	
	CREATE OR REPLACE PACKAGE BODY modyfikacje
	IS
		PROCEDURE dodajkolumne 
		(p_relacja IN VARCHAR2
		,p_kolumna IN VARCHAR2
		,p_typ_wartosci IN VARCHAR2)
		IS
			v_sql_stmt VARCHAR2(100);
		BEGIN
			v_sql_stmt := 'ALTER TABLE ' 
				      || p_relacja 
				      || ' ADD '
				      || p_kolumna 
				      || ' '
				      || p_typ_wartosci;

			EXECUTE IMMEDIATE v_sql_stmt;
		END;
		
		PROCEDURE usunkolumne
		(p_relacja IN VARCHAR2
		,p_kolumna IN VARCHAR2)
		IS
			v_sql_stmt VARCHAR2(100);
		BEGIN
			v_sql_stmt := 'ALTER TABLE ' 
				      || p_relacja 
				      || ' DROP COLUMN '
				      || p_kolumna;

			EXECUTE IMMEDIATE v_sql_stmt;
		END;
		
		PROCEDURE zmientypkolumny
		(p_relacja IN VARCHAR2
		,p_kolumna IN VARCHAR2
		,p_typ_wartosci IN VARCHAR2
		,p_czy_zachowac_dane IN VARCHAR2)
		IS
			v_sql_1_stmt VARCHAR2(100);
			v_sql_2_stmt VARCHAR2(100);
		BEGIN
			IF UPPER(p_czy_zachowac_dane) IN ('1', 'Y', 'T', 'TAK') THEN
				v_sql_1_stmt := 'ALTER TABLE ' 
						|| p_relacja 
						|| ' MODIFY '
						|| p_kolumna 
						|| ' '
						|| p_typ_wartosci;
							
				EXECUTE IMMEDIATE v_sql_1_stmt;
			ELSIF UPPER(p_czy_zachowac_dane) IN ('0', 'N', 'NIE') THEN
				v_sql_1_stmt := 'ALTER TABLE ' 
						|| p_relacja 
						|| ' MODIFY '
						|| p_kolumna 
						|| ' '
						|| p_typ_wartosci;
				
				v_sql_2_stmt := 'UPDATE '
						|| p_relacja
						|| ' SET '
						|| p_kolumna
						|| ' = NULL';
				
				EXECUTE IMMEDIATE v_sql_1_stmt;
				EXECUTE IMMEDIATE v_sql_2_stmt;
			END IF;
		END;
	END;
	/

