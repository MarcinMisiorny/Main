/*
* --------------------------------------------
* Rozdzia³ 9. Wprowadzenie do PL/SQL – zadania
* --------------------------------------------
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
* Plik z zadaniami: 09PLSQL_zadania.pdf
* 
* Prefiks zmiennych odnosi siê do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Zadeklaruj zmienne v_tekst i v_liczba o wartoœciach odpowiednio „Witaj, œwiecie!” i 1000.456.
--	  Wyœwietl wartoœci tych zmiennych.

	DECLARE
		v_tekst VARCHAR2(20) := 'Witaj œwiecie!';
		v_liczba NUMBER := 1000.456;
	BEGIN
		DBMS_OUTPUT.PUT_LINE('Zmienna v_tekst: ' || v_tekst);
		DBMS_OUTPUT.PUT_LINE('Zmienna v_liczba: ' || v_liczba);
	END;
	/
	
--------------------------------------------------------
-- 2. Do zmiennych zadeklarowanych w zadaniu 1 dodaj odpowiednio: do zmiennej v_tekst wartoœæ
--	  „Witaj, nowy dniu!”, do zmiennej v_liczba dodaj wartoœæ 1015. Wyœwietl wartoœci tych
--	  zmiennych.

	DECLARE
		v_tekst VARCHAR2(20) := 'Witaj œwiecie!';
		v_liczba NUMBER := 1000.456;
	BEGIN
		v_tekst := v_tekst || ' Witaj, nowy dniu!';
		v_liczba := v_liczba + POWER(10, 15);
		
		DBMS_OUTPUT.PUT_LINE('Zmienna v_tekst: ' || v_tekst);
		DBMS_OUTPUT.PUT_LINE('Zmienna v_liczba: ' || v_liczba);
	END;
	/
	
--------------------------------------------------------
-- 3. Napisz program dodaj¹cy do siebie dwie liczby. Liczby, które maj¹ byæ do siebie dodane,
--	  powinny byæ podawane dynamicznie z konsoli.

	DECLARE
		n_liczba_1 NUMBER;
		n_liczba_2 NUMBER;
		n_wynik NUMBER;
	BEGIN
		/* Uwaga. Nigdy nie nale¿y przypisywaæ wartoœci do zmiennych podstawianych w bloku deklaracji, 
		poniewa¿ w sekcji obs³ugi wyj¹tków nie mo¿na przechwyciæ zg³oszonych tu wyj¹tków zwi¹zanych
		z b³êdami przypisywania. Takie przypisania zawsze powinny znajdowaæ siê w sekcji wykonawczej. */
		
		n_liczba_1 := &podaj_pierwsz¹_liczbê;
		n_liczba_2 := &podaj_drug¹_liczbê;	
		
		n_wynik := n_liczba_1 + n_liczba_2;
		
		DBMS_OUTPUT.PUT_LINE('Wynik dodawania ' || n_liczba_1 || ' i ' || n_liczba_2 || ' to: ' || n_wynik);
	END;
	/
	
--------------------------------------------------------
-- 4. Napisz program, który oblicza pole powierzchni ko³a i obwód ko³a o podanym promieniu.
--	  W programie pos³u¿ siê zdefiniowan¹ przez siebie sta³¹ PI = 3.14.

	DECLARE
		n_pi CONSTANT NUMBER := 3.14;
		n_promien NUMBER := &podaj_promieñ_okrêgu;
		n_obwod NUMBER;
		n_pole NUMBER;
	BEGIN
		n_obwod := 2 * n_pi * n_promien;
		n_pole := n_pi * POWER(n_promien, 2);
	
		DBMS_OUTPUT.PUT_LINE('Obwód ko³a o promieniu równym ' || n_promien || ' wynosi: ' || n_obwod || ' jednostek');
		DBMS_OUTPUT.PUT_LINE('Pole ko³a o promieniu równym ' || n_promien || ' wynosi: ' || n_pole || ' jednostek');
	END;
	/
	
--------------------------------------------------------
-- 5. Napisz program, który wyœwietli poni¿sze informacje o najlepiej zarabiaj¹cym pracowniku
--	  Instytutu. Program powinien korzystaæ ze zmiennych v_nazwisko i v_etat o typach identycznych
--	  z typami atrybutów, odpowiednio: nazwisko i etat w relacji pracownicy.

--	  Najlepiej zarabia pracownik WEGLARZ.
--	  Pracuje on jako DYREKTOR.

	DECLARE
		v_nazwisko pracownicy.nazwisko%TYPE;
		v_etat pracownicy.etat%TYPE;
	BEGIN
		--jednowierszowy kursor niejawny
		SELECT	nazwisko
				,etat 
		INTO	v_nazwisko
				,v_etat 
		FROM	pracownicy 
		WHERE	placa_pod = (SELECT	MAX(placa_pod) 
							 FROM	pracownicy);
	
		DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik '|| v_nazwisko || '.');
		DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || v_etat || '.');
	END;
	/

--------------------------------------------------------
-- 6. Napisz program dzia³aj¹cy identycznie jak program z zadania poprzedniego, tym razem jednak
--	  u¿yj zmiennych rekordowych.

	DECLARE
		r_najlepiej_zarabiajacy pracownicy%ROWTYPE;
	BEGIN
		SELECT	* 
		INTO	r_najlepiej_zarabiajacy
		FROM	pracownicy
		WHERE	placa_pod = (SELECT	MAX(placa_pod) 
							 FROM	pracownicy);
	
		DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || r_najlepiej_zarabiajacy.nazwisko || '.');
		DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || r_najlepiej_zarabiajacy.etat || '.');
	END;
	/

--------------------------------------------------------
-- 7. Zdefiniuj w oparciu o typ NUMBER w³asny podtyp o nazwie PIENIADZE i zdefiniuj zmienn¹
--	  tego typu. Wczytaj do niej roczne zarobki prof. S³owiñskiego.

	DECLARE
		SUBTYPE pieniadze IS NUMBER;
		n_pensja_roczna pieniadze;
		v_nazwisko pracownicy.nazwisko%TYPE;
	BEGIN
		SELECT	nazwisko
				,placa_pod * 12 
		INTO	v_nazwisko
				,n_pensja_roczna
		FROM	pracownicy
		WHERE	nazwisko = 'SLOWINSKI';
	
		DBMS_OUTPUT.PUT_LINE('Pracownik ' || v_nazwisko || ' zarabia rocznie ' || n_pensja_roczna);
	END;
	/
	
--------------------------------------------------------
-- 8. Napisz program, który bêdzie wyœwietla³, w zale¿noœci od wyboru u¿ytkownika, bie¿¹c¹ datê
--	  systemow¹ (1. przypadek) lub bie¿¹cy czas systemowy (2 przypadek). Pos³u¿ siê instrukcj¹ IF THEN ELSE

	DECLARE
		n_parametr NUMBER;
		v_wynik VARCHAR2(20);
		v_data_systemowa v_wynik%TYPE;
		v_obecna_godzina v_wynik%TYPE;
	BEGIN
		n_parametr := &podaj_parametr_1_lub_2;

		SELECT	TO_CHAR(SYSDATE, 'DD-MM-YYYY') 
		INTO	v_data_systemowa 
		FROM	dual;
		
		SELECT	TO_CHAR(SYSDATE, 'HH24:MM:SS') 
		INTO	v_obecna_godzina 
		FROM	dual;

		IF n_parametr = 1 THEN
			v_wynik := v_data_systemowa;
		ELSE 
			v_wynik := v_obecna_godzina;
		END IF;
	
		DBMS_OUTPUT.PUT_LINE(v_wynik);
	END;
	/
	
--------------------------------------------------------
-- 9. Napisz program dzia³aj¹cy identycznie jak program z zadania poprzedniego, tym razem pos³u¿
--	  siê instrukcj¹ CASE.

	DECLARE
		n_parametr NUMBER;
		v_wynik VARCHAR2(20);
		v_data_systemowa v_wynik%TYPE;
		v_obecna_godzina v_wynik%TYPE;
	BEGIN
		n_parametr := &podaj_parametr_1_lub_2;
		
		SELECT	TO_CHAR(SYSDATE, 'DD-MM-YYYY') 
		INTO	v_data_systemowa 
		FROM	dual;
		
		SELECT	TO_CHAR(SYSDATE, 'HH24:MM:SS') 
		INTO	v_obecna_godzina 
		FROM	dual;
	
		CASE n_parametr
			WHEN 1 THEN
				v_wynik := v_data_systemowa;
			ELSE
				v_wynik := v_obecna_godzina;
		END CASE;
	
		DBMS_OUTPUT.PUT_LINE (v_wynik);
	END;
	/
	
--------------------------------------------------------
-- 10. Napisz program, który bêdzie dzia³a³ tak d³ugo, jak d³ugo nie nadejdzie 25 sekunda dowolnej minuty.

	DECLARE
		n_sekunda NUMBER;
	BEGIN
		n_sekunda := 1;
	
		WHILE n_sekunda != 25 LOOP
			SELECT	TO_CHAR(SYSDATE, 'SS')
			INTO	n_sekunda 
			FROM	dual;
		END LOOP;
		
		DBMS_OUTPUT.PUT_LINE ('Nadesz³a '|| n_sekunda || ' sekunda!');
	END;
	/
	
--------------------------------------------------------
-- 11. Napisz program, który dla podanego przez u¿ytkownika n obliczy wartoœæ wyra¿enia
--	   n! = 1 * 2 * 3 * ... * n

-- wersja z pêtl¹ FOR

	DECLARE
		n_silnia NUMBER;
		n_poczatkowe_n NUMBER;
		n_suma NUMBER;
	
	BEGIN
		n_silnia := &podaj_n;
		n_poczatkowe_n := n_silnia;
		n_suma := 1;
		
		FOR i IN 1.. n_poczatkowe_n LOOP
			n_suma := n_suma * n_silnia;
			n_silnia := n_silnia - 1;
		END LOOP;
	
		DBMS_OUTPUT.PUT_LINE('Silnia dla n = ' ||n_poczatkowe_n|| ' wynosi ' || n_suma); 
	END;
	/
	
-- wersja z pêtl¹ WHILE
	DECLARE
		n_silnia NUMBER;
		n_poczatkowe_n NUMBER;
		n_suma NUMBER;
	BEGIN
		n_silnia := &podaj_n;
		n_poczatkowe_n := n_silnia;
		n_suma := 1;
		
		WHILE n_silnia > 0 LOOP
			n_suma := n_silnia * n_suma;
			n_silnia := n_silnia - 1;
		END LOOP;
			
		DBMS_OUTPUT.PUT_LINE('Silnia dla n = ' || n_poczatkowe_n || ' wynosi ' || n_suma); 
	END;
	/
	
--------------------------------------------------------
-- 12. Napisz program który wyliczy, kiedy w XXI wieku bêd¹ pi¹tki przypadaj¹ce na 13 dzieñ
--	   miesi¹ca.
	
	ALTER SESSION SET NLS_TERRITORY = 'POLAND'; --zmiana parametrów sesji, aby pi¹tek by³ pi¹tym dniem tygodnia
	
	DECLARE
		d_data_pocz DATE;
		v_data_bierzaca VARCHAR2(10);
		v_dzien_miesiaca VARCHAR2(2);
		v_numer_dnia_tygodnia VARCHAR2(1);
	BEGIN
		d_data_pocz := TO_DATE('1999-12-31', 'YYYY-MM-DD');
		v_dzien_miesiaca := TO_CHAR(d_data_pocz, 'dd');
		v_numer_dnia_tygodnia := TO_CHAR(d_data_pocz, 'd');
	
		WHILE d_data_pocz <= '2101-01-01' LOOP
			IF (v_dzien_miesiaca = 13 AND v_numer_dnia_tygodnia = 5 ) THEN
				DBMS_OUTPUT.PUT_LINE(TO_CHAR(d_data_pocz, 'DD-MM-YYYY'));
			END IF;
	
			d_data_pocz := d_data_pocz + 7; -- 1999-12-31 to pi¹tek, dlatego nie trzeba iterowaæ dzieñ po dniu, mo¿na od razu tygniami
	
			v_dzien_miesiaca := TO_CHAR(d_data_pocz, 'dd');
			v_numer_dnia_tygodnia := TO_CHAR(d_data_pocz, 'd');
		END LOOP;
	END;  

