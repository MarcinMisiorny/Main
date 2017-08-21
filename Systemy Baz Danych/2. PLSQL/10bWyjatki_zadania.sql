/*
* --------------------------------------------
* Rozdzia³ 10b. Wyj¹tki – zadania
* --------------------------------------------
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
* Plik z zadaniami: 10bWyjatki_zadania.pdf
* 
* Prefiks zmiennych odnosi siê do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Rozszerz program z zadania 5 czêœci 1. rozdzia³u 10. o obs³ugê b³êdu wpisania niepoprawnej
--	  nazwy etatu (etat uznajemy za niepoprawny jeœli nie istnieje opisuj¹cy go rekord w relacji
--	  ETATY). Wykorzystaj mechanizm obs³ugi wyj¹tku NO_DATA_FOUND.

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


-- 2. Napisz program, wykorzystuj¹cy kursor, który odczyta informacje o wszystkich profesorach i
--	  przyzna im podwy¿kê w wysokoœci 10% sumy p³ac podstawowych ich podw³adnych. Jeœli po
--	  podwy¿ce pensja któregoœ z profesorów przekroczy³aby 2000 z³otych, program powinien zg³osiæ
--	  b³¹d ORA-20010 i wypisaæ komunikat „Pensja po podwy¿ce przekroczy³aby 2000!” (skorzystaj
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
					RAISE_APPLICATION_ERROR(-20001, i.nazwisko || ' - pensja po podwy¿ce przekroczy³aby 2000!');
				ELSE
					UPDATE	pracownicy p
					SET		placa_pod = placa_pod + j.podwyzka
					WHERE	p.nazwisko = j.nazwisko;
				END IF;
			END LOOP;
		END LOOP;
	END;
	/
	
-- 3. Napisz program, który spróbuje dodaæ do relacji PRACOWNICY rekord, opisuj¹cy nowego
--	  pracownika. U¿ytkownik ma podaæ identyfikator i nazwisko nowego pracownika, identyfikator
--	  zespo³u, do którego ma nale¿eæ pracownik, oraz p³acê podstawow¹ pracownika. Obs³u¿,
--	  wykorzystuj¹c sekcjê obs³ugi OTHERS i funkcjê SQLCODE nastêpuj¹ce sytuacje b³êdne przy
--	  wykonaniu polecenia INSERT INTO:
--	  · u¿ytkownik poda³ identyfikator, którego wartoœæ dubluje istniej¹ce ju¿ identyfikatory
--	  pracowników – wartoœæ SQLCODE = -1,
--	  · u¿ytkownik nie poda³ wartoœci identyfikatora – wartoœæ SQLCODE = -1400,
--	  · u¿ytkownik poda³ wartoœæ p³acy mniejsz¹ ni¿ 101 (w relacji PRACOWNICY zdefiniowano
--	  ograniczenie CHECK okreœlaj¹ce minimaln¹ wartoœæ p³acy pracownika na 101) – wartoœæ
--	  SQLCODE = -2290.
--	  · u¿ytkownik poda³ identyfikator nieistniej¹cego zespo³u – wartoœæ SQLCODE = -2291.
--	  Po wyst¹pieniu ka¿dej z ww. sytuacji powinien zostaæ wypisany na ekranie odpowiedni
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
			DBMS_OUTPUT.PUT_LINE('Podano identyfikator, którego wartoœæ dubluje istniej¹ce ju¿ identyfikatory. SQLCODE = ' || SQLCODE);
		WHEN EX_PUSTY_IDENTYFIKATOR THEN
			DBMS_OUTPUT.PUT_LINE('Nie podano identyfikatora pracownika. SQLCODE = ' || SQLCODE);
		WHEN ex_zbyt_mala_placa THEN
			DBMS_OUTPUT.PUT_LINE('Pensja pracownika nie mo¿e byæ ni¿sza niz 101, podano: ' || n_placa_pod || '. SQLCODE = ' || SQLCODE);
		WHEN ex_nieistniejacy_zespol THEN
			DBMS_OUTPUT.PUT_LINE('Podano identyfikator zespolu który nie istnieje. SQLCODE = ' || SQLCODE);
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END;
	/

-- 4. Napisz program, którego zadaniem bêdzie zapytanie u¿ytkownika o nazwisko pracownika a
--	  nastêpnie usuniêcie wskazanego pracownika. Program powinien obs³ugiwaæ nastêpuj¹ce
--	  sytuacje:
--	  a) u¿ytkownik poda nazwisko nieistniej¹cego pracownika – program powinien zakoñczyæ siê
--	  b³êdem ORA-20020 i komunikatem „Nie istnieje taki pracownik”,
--	  b) u¿ytkownik poda nazwisko, które wskazuje na wiêcej ni¿ jednego pracownika – program
--	  powinien zakoñczyæ siê b³êdem ORA-20030 i komunikatem „Niejednoznaczne wskazanie
--	  pracownika”,
--	  c) u¿ytkownik poda poprawne nazwisko, jednak pracownik, który ma byæ usuniêty, jest
--	  prze³o¿onym innych pracowników – program powinien zakoñczyæ siê b³êdem ORA-20040 i
--	  komunikatem „Nie mo¿esz usun¹æ prze³o¿onego”.
--	  Sytuacjê c) obs³u¿ w³asnym wyj¹tkiem, skojarzonym z b³êdem systemowym ORA-2292, który
--	  jest generowany przy próbie usuniêcia rekordu, dla którego istniej¹ przywi¹zane kluczem obcym
--	  rekordy w innej relacji (czyli przechwytuj w³asny wyj¹tek, generowany przez polecenie
--	  DELETE). Przetestuj dzia³anie programu, próbuj¹c usun¹æ pracownika WEGLARZ (sytuacja c),
--	  pracownika XYZ (sytuacja a) i pracownika dodanego w zadaniu 3. (poprawne usuniêcie).

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
	
		DBMS_OUTPUT.PUT_LINE('Usuniêto pracownika: ' || v_nazwisko);
	EXCEPTION
		WHEN ex_usuniecie_przelozonego THEN
			RAISE_APPLICATION_ERROR(-20040, 'Nie mo¿esz usun¹æ prze³o¿onego');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END;
	/

