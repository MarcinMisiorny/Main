/*
* --------------------------------------------
* Rozdział 11. Procedury i funkcje
* składowane – zadania
* --------------------------------------------
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
* Plik z zadaniami: 11Procedury_zadania.pdf
* 
* Prefiks zmiennych odnosi się do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Napisz procedurę PODWYZKA, która wszystkim pracownikom zespołu (parametr) podniesie płacę
--    podstawową o podany procent (parametr). Domyślnie podwyżka powinna wynosić 15%.

	CREATE OR REPLACE PROCEDURE podwyzka 
	(p_id_zespolu IN NUMBER
	,p_procent IN NUMBER) 
	IS
	BEGIN
		UPDATE	pracownicy
		SET	placa_pod = placa_pod + placa_pod * p_procent / 100
		WHERE	id_zesp = p_id_zespolu;
	END podwyzka;
	/


-- 2. Dodaj do powyższej procedury obsługę błędu – jeśli podano identyfikator nieistniejącego zespołu to procedura
--    powinna zasygnalizować odpowiedni błąd.

	CREATE OR REPLACE PROCEDURE podwyzka 
	(p_id_zespolu IN NUMBER
	,p_procent IN NUMBER) 
	IS
		n_czy_istnieje NUMBER;
		ex_bledny_zespol EXCEPTION;
	BEGIN
		SELECT	CASE
				WHEN EXISTS (SELECT  1 
					     FROM    zespoly 
					     WHERE   id_zesp = p_id_zespolu) 
				THEN 1 
				ELSE 0 
				END 
		INTO	n_czy_istnieje
		FROM	dual;
		
		IF n_czy_istnieje = 0 THEN
			RAISE ex_bledny_zespol;
		ELSE
			UPDATE	pracownicy
			SET	placa_pod = placa_pod + placa_pod * p_procent / 100
			WHERE	id_zesp = p_id_zespolu;
		END IF;
	EXCEPTION
		WHEN ex_bledny_zespol THEN
			RAISE_APPLICATION_ERROR(-20001, 'Podano identyfikator nieistniejącego zespołu');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END podwyzka;
	/


-- 3. Napisz procedurę LICZBA_PRACOWNIKOW, która dla podanej nazwy zespołu (parametr) zwróci
--    liczbę pracowników zatrudnionych w tym zespole. Liczba pracowników powinna być zwrócona przez
--    argument wyjściowy. Procedura powinna obsługiwać podanie nieprawidłowej nazwy zespołu.

	CREATE OR REPLACE PROCEDURE liczba_pracownikow
	(p_nazwa_zespolu IN VARCHAR2
	,p_liczba_pracownikow OUT NUMBER)
	IS
		n_czy_istnieje NUMBER;
		ex_bledny_zespol EXCEPTION;
	BEGIN
		SELECT	CASE
				WHEN EXISTS (SELECT  1 
					     FROM    zespoly 
					     WHERE   nazwa = p_nazwa_zespolu) 
				THEN 1 
				ELSE 0 
				END
		INTO	n_czy_istnieje
		FROM	dual;
		
		IF n_czy_istnieje = 0 THEN
			RAISE ex_bledny_zespol;
		ELSE
			SELECT	COUNT(*)
			INTO	p_liczba_pracownikow
			FROM	pracownicy p
			JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
			WHERE	z.nazwa = p_nazwa_zespolu;
		END IF;
	EXCEPTION
		WHEN ex_bledny_zespol THEN
			RAISE_APPLICATION_ERROR(-20001, 'Podano nazwę nieistniejącego zespołu');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);	
	END liczba_pracownikow;
	/
	
	--sprawdzenie
	DECLARE
		v_nazwa_zespolu VARCHAR2(30);
		n_liczba_pracownikow NUMBER;
		v_komunikat VARCHAR2(50);
	BEGIN
		v_nazwa_zespolu := 'ALGORYTMY';
		
		liczba_pracownikow(v_nazwa_zespolu
				  ,n_liczba_pracownikow);
		
		IF n_liczba_pracownikow = 0 THEN
			v_komunikat := 'Zespół ' || v_nazwa_zespolu || ' nie ma pracowników.';
		ELSIF n_liczba_pracownikow = 1 THEN
			v_komunikat := 'Zespół ' || v_nazwa_zespolu || ' ma 1 pracownika.';
		ELSE
			v_komunikat := 'Zespół ' || v_nazwa_zespolu || ' ma ' || n_liczba_pracownikow || ' pracowników.';
		END IF;
		
		DBMS_OUTPUT.PUT_LINE(v_komunikat);
	END;
	/


-- 4. Napisz procedurę NOWY_PRACOWNIK, która będzie służyła do wstawiania nowych pracowników.
--    Procedura powinna przyjmować nazwisko nowego pracownika, nazwę zespołu, nazwisko jego szefa i
--    wartość płacy podstawowej. Domyślną datą zatrudnienia jest bieżąca data, domyślnym etatem
--    STAŻYSTA. Procedura powinna obsługiwać błędy podania błędnego zespołu i błędnego nazwiska
--    szefa.

	CREATE OR REPLACE PROCEDURE nowy_pracownik
	(p_nazwisko_pracownika IN VARCHAR2
	,p_nazwa_zespolu_pracownika IN VARCHAR2
	,p_nazwisko_szefa_pracownika IN VARCHAR2
	,p_placa_pod_pracownika IN NUMBER)
	IS
		n_czy_istnieje_zespol NUMBER;
		n_id_zespolu NUMBER;
		n_czy_istnieje_szef NUMBER;
		n_id_szefa NUMBER;
		
		ex_nie_istnieje_zespol EXCEPTION;
		ex_nie_istnieje_szef EXCEPTION;
	BEGIN
		SELECT	CASE
				WHEN EXISTS (SELECT  1 
					     FROM    zespoly 
					     WHERE   nazwa = p_nazwa_zespolu_pracownika) 
				THEN 1 
				ELSE 0 
				END
		INTO	n_czy_istnieje_zespol
		FROM	dual;
		
		IF n_czy_istnieje_zespol = 0 THEN
			RAISE ex_nie_istnieje_zespol;
		ELSIF n_czy_istnieje_zespol = 1 THEN
			SELECT	id_zesp
			INTO	n_id_zespolu
			FROM	zespoly
			WHERE	nazwa = p_nazwa_zespolu_pracownika;
		END IF;
		
		SELECT	CASE
				WHEN EXISTS (SELECT  1 
					     FROM    pracownicy p
					     WHERE   p.nazwisko = p_nazwisko_szefa_pracownika
					     AND     (SELECT  COUNT(*)
						      FROM    pracownicy
						      WHERE   id_szefa = p.id_prac) > 0) 
				THEN 1 
				ELSE 0 
				END
		INTO	n_czy_istnieje_szef
		FROM	dual;
		
		IF n_czy_istnieje_szef = 0 THEN
			RAISE ex_nie_istnieje_szef;
		ELSIF n_czy_istnieje_szef = 1 THEN
			SELECT	id_prac
			INTO	n_id_szefa
			FROM	pracownicy
			WHERE	nazwisko = p_nazwisko_szefa_pracownika;
		END IF;
		
		INSERT INTO pracownicy	(ID_PRAC
					,NAZWISKO
					,ETAT
					,ID_SZEFA
					,ZATRUDNIONY 
					,PLACA_POD
					,PLACA_DOD
					,ID_ZESP)
		VALUES 
					((SELECT  MAX(id_prac) + 10
					  FROM	  pracownicy)
					,UPPER(p_nazwisko_pracownika)
					,'STAZYSTA'
					,n_id_szefa
					,SYSDATE
					,p_placa_pod_pracownika
					,NULL
					,n_id_zespolu);
		
	EXCEPTION
		WHEN ex_nie_istnieje_zespol THEN
			RAISE_APPLICATION_ERROR(-20001, 'Podano nazwę nieistniejącego zespołu');
		WHEN ex_nie_istnieje_szef THEN
			RAISE_APPLICATION_ERROR(-20002, 'Podano błędne nazwisko szefa');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);	
	END nowy_pracownik;
	/


-- 5. Napisz funkcję PLACA_NETTO, która dla podanej płacy brutto (parametr) i podanej stawki podatku
--    (parametr o wartości domyślnej 20%) wyliczy płacę netto.
	
	CREATE OR REPLACE FUNCTION placa_netto
	(p_placa_brutto NUMBER
	,p_podatek NUMBER DEFAULT 20
	)
	RETURN NUMBER
	IS
		n_placa_netto NUMBER;
	BEGIN
		n_placa_netto := ROUND(p_placa_brutto / (1 + (p_podatek / 100)), 2);
	
		RETURN n_placa_netto;
	END placa_netto;
	/


-- 6. Napisz funkcję SILNIA, która dla danego n obliczy n! = 1 * 2 * ... * n (zastosuj iterację)

	--wersja 1, z pętlą WHILE
	CREATE OR REPLACE FUNCTION silnia
	(p_N NUMBER)
	RETURN NUMBER
	IS
		n_silnia NUMBER;
		n_poczatkowe_n NUMBER;
		n_suma NUMBER;
	BEGIN
		n_silnia := p_N;
		n_poczatkowe_n := p_N;
		n_suma := 1;
		
		WHILE n_silnia > 0 LOOP
			n_suma := n_silnia * n_suma;
			n_silnia := n_silnia - 1;
		END LOOP;
		
		RETURN n_suma;
	END silnia;
	/

	--wersja 2, z pętlą FOR
	CREATE OR REPLACE FUNCTION silnia
	(p_N NUMBER)
	RETURN NUMBER
	IS
		n_silnia NUMBER;
		n_poczatkowe_n NUMBER;
		n_suma NUMBER;
	BEGIN
		n_silnia := p_N;
		n_poczatkowe_n := p_N;
		n_suma := 1;
		
		FOR i IN 1 .. n_poczatkowe_n LOOP
			n_suma := n_suma * n_silnia;
			n_silnia := n_silnia - 1;
		END LOOP;
		
		RETURN n_suma;
	END silnia;
	/


-- 7. Napisz rekurencyjną wersję funkcji SILNIA
	
	CREATE OR REPLACE FUNCTION silnia
	(p_N NUMBER)
	RETURN NUMBER
	IS
	BEGIN
		IF p_N <= 1 THEN
			RETURN 1;
		ELSE
			RETURN p_N * silnia(p_N - 1);
		END IF;
	END silnia;
	/


-- 8. Napisz funkcję, która dla daty zatrudnienia pracownika wylicza staż pracy w latach.

	ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

	CREATE OR REPLACE FUNCTION staz_pracy
	(p_data DATE)
	RETURN NUMBER
	IS
		n_staz_w_latach NUMBER;
	BEGIN
		n_staz_w_latach := TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), TO_DATE(p_data, 'YYYY-MM-DD'))/12);
		
		RETURN n_staz_w_latach;
	END staz_pracy;
	/

	--sprawdzenie
	SELECT	nazwisko
		,staz_pracy(zatrudniony) AS staz_pracy 
	FROM	pracownicy;

