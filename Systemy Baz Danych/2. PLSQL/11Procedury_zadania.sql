/*
* --------------------------------------------
* Rozdzia� 11. Procedury i funkcje
* sk�adowane � zadania
* --------------------------------------------
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
* Plik z zadaniami: 11Procedury_zadania.pdf
* 
* Prefiks zmiennych odnosi si� do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Napisz procedur� PODWYZKA, kt�ra wszystkim pracownikom zespo�u (parametr) podniesie p�ac�
--	  podstawow� o podany procent (parametr). Domy�lnie podwy�ka powinna wynosi� 15%.

	CREATE OR REPLACE PROCEDURE podwyzka 
	(p_id_zespolu IN NUMBER
	,p_procent IN NUMBER) 
	IS
	BEGIN
		UPDATE	PRACOWNICY
		SET		placa_pod = placa_pod + placa_pod * p_procent / 100
		WHERE	id_zesp = p_id_zespolu;
	END podwyzka;
	/


-- 2. Dodaj do powy�szej procedury obs�ug� b��du � je�li podano identyfikator nieistniej�cego zespo�u to procedura
--	  powinna zasygnalizowa� odpowiedni b��d.

	CREATE OR REPLACE PROCEDURE podwyzka 
	(p_id_zespolu IN NUMBER
	,p_procent IN NUMBER) 
	IS
		n_czy_istnieje NUMBER;
		ex_bledny_zespol EXCEPTION;
	BEGIN
		SELECT	CASE
				WHEN EXISTS (SELECT 1 
							 FROM	zespoly 
							 WHERE	id_zesp = p_id_zespolu) 
				THEN 1 
				ELSE 0 
				END 
		INTO	n_czy_istnieje
		FROM	dual;
		
		IF n_czy_istnieje = 0 THEN
			RAISE ex_bledny_zespol;
		ELSE
			UPDATE	pracownicy
			SET		placa_pod = placa_pod + placa_pod * p_procent / 100
			WHERE	id_zesp = p_id_zespolu;
		END IF;
	EXCEPTION
		WHEN ex_bledny_zespol THEN
			RAISE_APPLICATION_ERROR(-20001, 'Podano identyfikator nieistniej�cego zespo�u');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END podwyzka;
	/


-- 3. Napisz procedur� LICZBA_PRACOWNIKOW, kt�ra dla podanej nazwy zespo�u (parametr) zwr�ci
--	  liczb� pracownik�w zatrudnionych w tym zespole. Liczba pracownik�w powinna by� zwr�cona przez
--	  argument wyj�ciowy. Procedura powinna obs�ugiwa� podanie nieprawid�owej nazwy zespo�u.

	CREATE OR REPLACE PROCEDURE liczba_pracownikow
	(p_nazwa_zespolu IN VARCHAR2
	,p_liczba_pracownikow OUT NUMBER)
	IS
		n_czy_istnieje NUMBER;
		ex_bledny_zespol EXCEPTION;
	BEGIN
		SELECT	CASE
				WHEN EXISTS (SELECT	1 
							 FROM	zespoly 
							 WHERE	nazwa = p_nazwa_zespolu) 
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
			RAISE_APPLICATION_ERROR(-20001, 'Podano nazw� nieistniej�cego zespo�u');
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
			v_komunikat := 'Zesp� ' || v_nazwa_zespolu || ' nie ma pracownik�w.';
		ELSIF n_liczba_pracownikow = 1 THEN
			v_komunikat := 'Zesp� ' || v_nazwa_zespolu || ' ma 1 pracownika.';
		ELSE
			v_komunikat := 'Zesp� ' || v_nazwa_zespolu || ' ma ' || n_liczba_pracownikow || ' pracownik�w.';
		END IF;
		
		DBMS_OUTPUT.PUT_LINE(v_komunikat);
	END;
	/


-- 4. Napisz procedur� NOWY_PRACOWNIK, kt�ra b�dzie s�u�y�a do wstawiania nowych pracownik�w.
--	  Procedura powinna przyjmowa� nazwisko nowego pracownika, nazw� zespo�u, nazwisko jego szefa i
--	  warto�� p�acy podstawowej. Domy�ln� dat� zatrudnienia jest bie��ca data, domy�lnym etatem
--	  STA�YSTA. Procedura powinna obs�ugiwa� b��dy podania b��dnego zespo�u i b��dnego nazwiska
--	  szefa.

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
				WHEN EXISTS (SELECT	1 
							 FROM	zespoly 
							 WHERE	nazwa = p_nazwa_zespolu_pracownika) 
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
				WHEN EXISTS (SELECT	1 
							 FROM	pracownicy p
							 WHERE	p.nazwisko = p_nazwisko_szefa_pracownika
							 AND	(SELECT	COUNT(*)
									 FROM	pracownicy
									 WHERE	id_szefa = p.id_prac) > 0) 
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
								((SELECT	MAX(id_prac) + 10
								  FROM		pracownicy)
								,UPPER(p_nazwisko_pracownika)
								,'STAZYSTA'
								,n_id_szefa
								,SYSDATE
								,p_placa_pod_pracownika
								,NULL
								,n_id_zespolu);
		
	EXCEPTION
		WHEN ex_nie_istnieje_zespol THEN
			RAISE_APPLICATION_ERROR(-20001, 'Podano nazw� nieistniej�cego zespo�u');
		WHEN ex_nie_istnieje_szef THEN
			RAISE_APPLICATION_ERROR(-20002, 'Podano b��dne nazwisko szefa');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);	
	END nowy_pracownik;
	/


-- 5. Napisz funkcj� PLACA_NETTO, kt�ra dla podanej p�acy brutto (parametr) i podanej stawki podatku
--	  (parametr o warto�ci domy�lnej 20%) wyliczy p�ac� netto.
	
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


-- 6. Napisz funkcj� SILNIA, kt�ra dla danego n obliczy n! = 1 * 2 * ... * n (zastosuj iteracj�)

	--wersja 1, z p�tl� WHILE
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

	--wersja 2, z p�tl� FOR
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
		
		FOR i IN 1.. n_poczatkowe_n LOOP
			n_suma := n_suma * n_silnia;
			n_silnia := n_silnia - 1;
		END LOOP;
		
		RETURN n_suma;
	END silnia;
	/


-- 7. Napisz rekurencyjn� wersj� funkcji SILNIA
	
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


-- 8. Napisz funkcj�, kt�ra dla daty zatrudnienia pracownika wylicza sta� pracy w latach.

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

