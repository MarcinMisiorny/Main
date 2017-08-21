/*
* --------------------------------------------
* Rozdzia³ 12. Pakiety, dynamiczny SQL – zadania
* --------------------------------------------
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
* Plik z zadaniami: 12Pakiety_zadania.pdf
* 
* Prefiks zmiennych odnosi siê do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Napisz pakiet KONWERSJA zawieraj¹cy funkcje CELS_TO_FAHR (konwertuj¹c¹ skalê Celsjusza na
--	  skalê Fahrenheita) i FAHR_TO_CELS (konwertuj¹c¹ skalê Fahrenheita na skalê Celsjusza).
--	  Wskazówka:
--	  TC = 5/9 * (TF - 32) TF = 9/5 * TC + 32

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


-- 2. Przetestuj dzia³anie zmiennych pakietowych. W tym celu utwórz pakiet o nazwie ZMIENNE, w jego
--	  specyfikacji zadeklaruj:
--	  · zmienn¹ vLicznik typu numerycznego, zmienn¹ zainicjalizuj wartoœci¹ 0,
--	  · procedury: ZwiekszLicznik, ZmniejszLicznik oraz funkcjê PokazLicznik.
--	  Nastêpnie w ciele pakietu zaimplementuj:
--	  · procedurê ZwiekszLicznik – jej zadaniem bêdzie zwiêkszenie aktualnej wartoœci zmiennej
--	  vLicznik o 1 i wypisanie na konsoli tekstu „Zwiêkszono”,
--	  · procedurê ZmniejszLicznik – jej zadaniem bêdzie zmniejszenie aktualnej wartoœci zmiennej
--	  vLicznik o 1 i wypisanie na konsoli tekstu „Zmniejszono”,
--	  · funkcjê PokazLicznik – jej wartoœci¹ zwracan¹ bêdzie aktualna wartoœci zmiennej vLicznik,
--	  · czêœæ inicjalizacyjn¹ pakietu – dokona ona ustawienia wartoœci zmiennej vLicznik na 1 i wypisze
--	  na konsoli tekst „Zainicjalizowano”.

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
			
			DBMS_OUTPUT.PUT_LINE('Zwiêkszono');
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


-- 3. Zaprojektuj procedurê IleRekordow, której parametrem bêdzie nazwa relacji. Procedura ma za zadanie
--	  wypisaæ liczbê rekordów relacji. Przy konstrukcji funkcji wykorzystaj mechanizm dynamicznego
--	  SQL’a.

	CREATE OR REPLACE PROCEDURE ilerekordow 
	(p_nazwa_relacji IN VARCHAR2)
	IS
		v_sql_stmt VARCHAR2(100);
		n_ile_rekordow NUMBER;
	BEGIN
		v_sql_stmt := 'SELECT	COUNT(*)
					   FROM		' 
					   || p_nazwa_relacji;
		
		EXECUTE IMMEDIATE v_sql_stmt
		INTO			  n_ile_rekordow;
	
		DBMS_OUTPUT.PUT_LINE('Liczba rekordów relacji ' || UPPER(p_nazwa_relacji) || ': ' || n_ile_rekordow);
	END ilerekordow;
	/


-- 4. Zaprojektuj pakiet o nazwie MODYFIKACJE. Pakiet ma zawieraæ nastêpuj¹ce procedury:
--	  · DodajKolumne(relacja, kolumna, typ_wartoœci) – dodaje do wskazanej parametrem relacji now¹
--	  kolumnê (parametr) o danym typie wartoœci (parametr),
--	  · UsuñKolumne(relacja, kolumna) – usuwa ze wskazanej parametrem relacji wskazan¹ kolumnê
--	  (parametr),
--	  · ZmieñTypKolumny(relacja, kolumna, typ_wartoœci, czy_zachowaæ_dane) – zmienia typ kolumny
--	  (parametr) wskazanej relacji (parametr) na podany (parametr), ostatni parametr ma wskazywaæ,
--	  czy dane modyfikowanej kolumny maj¹ zostaæ zachowane czy te¿ usuniête.
--	  Pakiet ma wykorzystywaæ mechanizm dynamicznego SQL’a.

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

