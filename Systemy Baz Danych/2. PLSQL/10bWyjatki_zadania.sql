/*
* --------------------------------------------
* Rozdzia� 10b. Wyj�tki � zadania
* --------------------------------------------
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
* Plik z zadaniami: 10bWyjatki_zadania.pdf
* 
* Prefiks zmiennych odnosi si� do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Rozszerz program z zadania 5 cz�ci 1. rozdzia�u 10. o obs�ug� b��du wpisania niepoprawnej
--	  nazwy etatu (etat uznajemy za niepoprawny je�li nie istnieje opisuj�cy go rekord w relacji
--	  ETATY). Wykorzystaj mechanizm obs�ugi wyj�tku NO_DATA_FOUND.

	DECLARE
		CURSOR c_wypisz_pracownikow (p_etat VARCHAR2) IS
		SELECT	nazwisko
		FROM	pracownicy 
		WHERE	etat = p_etat
		ORDER BY nazwisko;
		
		v_etat pracownicy.etat%TYPE;
		v_nazwa etaty.nazwa%TYPE;
	BEGIN
		v_etat := UPPER(:podaj_etat);
		
		SELECT	nazwa
		INTO	v_nazwa
		FROM	etaty
		WHERE	nazwa = v_etat;
 
		FOR i IN c_wypisz_pracownikow(v_nazwa) LOOP
			DBMS_OUTPUT.PUT_LINE(i.nazwisko);
		END LOOP;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20001, 'Nie istnieje etat o nazwie ' || v_etat);
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);		
	END;
	/


-- 2. Napisz program, wykorzystuj�cy kursor, kt�ry odczyta informacje o wszystkich profesorach i
--	  przyzna im podwy�k� w wysoko�ci 10% sumy p�ac podstawowych ich podw�adnych. Je�li po
--	  podwy�ce pensja kt�rego� z profesor�w przekroczy�aby 2000 z�otych, program powinien zg�osi�
--	  b��d ORA-20010 i wypisa� komunikat �Pensja po podwy�ce przekroczy�aby 2000!� (skorzystaj
--	  z procedury RAISE APPLICATION ERROR).
	
	DECLARE
		CURSOR c_profesorowie IS
		SELECT	nazwisko
				,placa_pod as pensja_profesora
		FROM	pracownicy
		WHERE	etat = 'PROFESOR';
		
		CURSOR c_kwota_podwyzki(p_nazwisko VARCHAR2) IS
		SELECT	p.nazwisko
				,SUM(pr.placa_pod * 0.1) AS podwyzka 
		FROM	pracownicy p
		JOIN	pracownicy pr ON (p.id_prac = pr.id_szefa)
		WHERE	p.etat = 'PROFESOR' 
		AND		p.nazwisko = p_nazwisko
		GROUP BY p.nazwisko;
	BEGIN
		FOR i IN c_profesorowie LOOP
			FOR j IN c_kwota_podwyzki(i.nazwisko) LOOP
				IF i.pensja_profesora + j.podwyzka > 2000 THEN
					RAISE_APPLICATION_ERROR(-20001, i.nazwisko || ' - pensja po podwy�ce przekroczy�aby 2000!');
				ELSE
					UPDATE	pracownicy p
					SET		placa_pod = placa_pod + j.podwyzka
					WHERE	p.nazwisko = j.nazwisko;
				END IF;
			END LOOP;
		END LOOP;
	END;
	/
	
-- 3. Napisz program, kt�ry spr�buje doda� do relacji PRACOWNICY rekord, opisuj�cy nowego
--	  pracownika. U�ytkownik ma poda� identyfikator i nazwisko nowego pracownika, identyfikator
--	  zespo�u, do kt�rego ma nale�e� pracownik, oraz p�ac� podstawow� pracownika. Obs�u�,
--	  wykorzystuj�c sekcj� obs�ugi OTHERS i funkcj� SQLCODE nast�puj�ce sytuacje b��dne przy
--	  wykonaniu polecenia INSERT INTO:
--	  � u�ytkownik poda� identyfikator, kt�rego warto�� dubluje istniej�ce ju� identyfikatory
--	  pracownik�w � warto�� SQLCODE = -1,
--	  � u�ytkownik nie poda� warto�ci identyfikatora � warto�� SQLCODE = -1400,
--	  � u�ytkownik poda� warto�� p�acy mniejsz� ni� 101 (w relacji PRACOWNICY zdefiniowano
--	  ograniczenie CHECK okre�laj�ce minimaln� warto�� p�acy pracownika na 101) � warto��
--	  SQLCODE = -2290.
--	  � u�ytkownik poda� identyfikator nieistniej�cego zespo�u � warto�� SQLCODE = -2291.
--	  Po wyst�pieniu ka�dej z ww. sytuacji powinien zosta� wypisany na ekranie odpowiedni
--	  komunikat.

	DECLARE
		CURSOR c_identyfikatory IS
		SELECT	id_prac 
		FROM	pracownicy;

		CURSOR c_czy_istnieje_zespol(p_identyfikator_zespolu NUMBER) IS
		SELECT	CASE
				WHEN EXISTS (SELECT 1 
							 FROM	zespoly 
							 WHERE	id_zesp = p_identyfikator_zespolu) 
				THEN 1 
				ELSE 0 
				END
		FROM	dual;
	
		n_identyfikator NUMBER;
		v_nazwisko VARCHAR2(30);
		n_placa_pod NUMBER;
		n_identyfikator_zespolu NUMBER;
		n_czy_istnieje_zespol NUMBER;
	
		ex_dubel_identyfikatora EXCEPTION;
		ex_pusty_identyfikator EXCEPTION;
		ex_zbyt_mala_placa EXCEPTION;
		ex_nieistniejacy_zespol EXCEPTION;
		
		PRAGMA EXCEPTION_INIT(ex_dubel_identyfikatora, -1);
		PRAGMA EXCEPTION_INIT(ex_pusty_identyfikator, -1400);
		PRAGMA EXCEPTION_INIT(ex_zbyt_mala_placa, -2290);
		PRAGMA EXCEPTION_INIT(ex_nieistniejacy_zespol, -2291);
	BEGIN
		n_identyfikator := &podaj_id_pracownika;
		n_placa_pod := &podaj_place_podstawowa_pracownika;
		v_nazwisko := &podaj_nazwisko_pracownika;
		n_identyfikator_zespolu := &podaj_id_zespolu_pracownika;
	
		FOR i IN c_identyfikatory LOOP
			IF n_identyfikator = i.id_prac THEN
				RAISE ex_dubel_identyfikatora;
			END IF;
		END LOOP;
	
		IF n_identyfikator IS NULL THEN
			RAISE ex_pusty_identyfikator;
		END IF;
		
		IF n_placa_pod < 101 THEN
			RAISE ex_zbyt_mala_placa;
		END IF;
		
		OPEN c_czy_istnieje_zespol(n_identyfikator_zespolu);
		
		FETCH	c_czy_istnieje_zespol
		INTO	n_czy_istnieje_zespol;
		
		IF n_czy_istnieje_zespol = 0 THEN
			RAISE ex_nieistniejacy_zespol;
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
								(n_identyfikator
								,UPPER(v_nazwisko)
								,NULL
								,NULL
								,SYSDATE
								,n_placa_pod
								,NULL
								,n_identyfikator_zespolu);
	EXCEPTION
		WHEN ex_dubel_identyfikatora THEN
			DBMS_OUTPUT.PUT_LINE('Podano identyfikator, kt�rego warto�� dubluje istniej�ce ju� identyfikatory. SQLCODE = ' || SQLCODE);
		WHEN EX_PUSTY_IDENTYFIKATOR THEN
			DBMS_OUTPUT.PUT_LINE('Nie podano identyfikatora pracownika. SQLCODE = ' || SQLCODE);
		WHEN ex_zbyt_mala_placa THEN
			DBMS_OUTPUT.PUT_LINE('Pensja pracownika nie mo�e by� ni�sza niz 101, podano: ' || n_placa_pod || '. SQLCODE = ' || SQLCODE);
		WHEN ex_nieistniejacy_zespol THEN
			DBMS_OUTPUT.PUT_LINE('Podano identyfikator zespolu kt�ry nie istnieje. SQLCODE = ' || SQLCODE);
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END;
	/

-- 4. Napisz program, kt�rego zadaniem b�dzie zapytanie u�ytkownika o nazwisko pracownika a
--	  nast�pnie usuni�cie wskazanego pracownika. Program powinien obs�ugiwa� nast�puj�ce
--	  sytuacje:
--	  a) u�ytkownik poda nazwisko nieistniej�cego pracownika � program powinien zako�czy� si�
--	  b��dem ORA-20020 i komunikatem �Nie istnieje taki pracownik�,
--	  b) u�ytkownik poda nazwisko, kt�re wskazuje na wi�cej ni� jednego pracownika � program
--	  powinien zako�czy� si� b��dem ORA-20030 i komunikatem �Niejednoznaczne wskazanie
--	  pracownika�,
--	  c) u�ytkownik poda poprawne nazwisko, jednak pracownik, kt�ry ma by� usuni�ty, jest
--	  prze�o�onym innych pracownik�w � program powinien zako�czy� si� b��dem ORA-20040 i
--	  komunikatem �Nie mo�esz usun�� prze�o�onego�.
--	  Sytuacj� c) obs�u� w�asnym wyj�tkiem, skojarzonym z b��dem systemowym ORA-2292, kt�ry
--	  jest generowany przy pr�bie usuni�cia rekordu, dla kt�rego istniej� przywi�zane kluczem obcym
--	  rekordy w innej relacji (czyli przechwytuj w�asny wyj�tek, generowany przez polecenie
--	  DELETE). Przetestuj dzia�anie programu, pr�buj�c usun�� pracownika WEGLARZ (sytuacja c),
--	  pracownika XYZ (sytuacja a) i pracownika dodanego w zadaniu 3. (poprawne usuni�cie).

	DECLARE
		CURSOR c_czy_istnieje_pracownik(p_nazwisko VARCHAR2) IS
		SELECT	CASE
				WHEN EXISTS (SELECT 1 
							 FROM	pracownicy 
							 WHERE	nazwisko = p_nazwisko) 
				THEN 1 
				ELSE 0 
				END
		FROM	dual;
		
		CURSOR c_ilu_pracownikow(p_nazwisko VARCHAR2) IS
		SELECT	COUNT(*)
		FROM	pracownicy
		WHERE	nazwisko = p_nazwisko;
		
		CURSOR c_czy_ma_podwladnych(p_nazwisko VARCHAR2) IS
		SELECT	CASE
				WHEN EXISTS (SELECT	1 
							 FROM	pracownicy p
							 JOIN	pracownicy pr ON (p.id_prac = pr.id_szefa)
							 WHERE	p.nazwisko = p_nazwisko)
				THEN 1 
				ELSE 0 
				END
		FROM	dual;
							 
		v_nazwisko VARCHAR2(30);
		n_czy_istnieje_pracownik NUMBER;
		n_ilu_pracownikow NUMBER;
		n_czy_ma_podwladnych NUMBER;
		
		ex_usuniecie_przelozonego EXCEPTION;
		
		PRAGMA EXCEPTION_INIT(ex_usuniecie_przelozonego, -2292);
	BEGIN
		v_nazwisko := UPPER(:podaj_nazwisko_pracownika);
		
		OPEN c_czy_istnieje_pracownik(v_nazwisko);
		
		FETCH	c_czy_istnieje_pracownik
		INTO	n_czy_istnieje_pracownik;
		
		IF n_czy_istnieje_pracownik = 0 THEN
			RAISE_APPLICATION_ERROR(-20020, 'Nie istnieje taki pracownik');
		END IF;
		
		OPEN c_ilu_pracownikow(v_nazwisko);
		
		FETCH	c_ilu_pracownikow
		INTO	n_ilu_pracownikow;
		
		IF n_ilu_pracownikow > 1 THEN
			RAISE_APPLICATION_ERROR(-20030, 'Niejednoznaczne wskazanie pracownika');
		END IF;
		
		OPEN c_czy_ma_podwladnych(v_nazwisko);
		
		FETCH	c_czy_ma_podwladnych
		INTO	n_czy_ma_podwladnych;
		
		IF n_czy_ma_podwladnych = 1 THEN
			RAISE ex_usuniecie_przelozonego;
		END IF;		
		
		DELETE 
		FROM	pracownicy
		WHERE	nazwisko = v_nazwisko;
	
		DBMS_OUTPUT.PUT_LINE('Usuni�to pracownika: ' || v_nazwisko);
	EXCEPTION
		WHEN ex_usuniecie_przelozonego THEN
			RAISE_APPLICATION_ERROR(-20040, 'Nie mo�esz usun�� prze�o�onego');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END;
	/

