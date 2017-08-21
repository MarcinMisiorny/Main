/*
* --------------------------------------------
* Rozdzia³ 10a. Kursory – zadania
* --------------------------------------------
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
* Plik z zadaniami: 10aKursory_zadania.pdf
* 
* Prefiks zmiennych odnosi siê do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Zdefiniuj kursor zawieraj¹cy nazwiska i daty zatrudnienia wszystkich asystentów. Pos³u¿ siê
--	  tym kursorem do wyœwietlenia nastêpuj¹cych informacji (wykorzystaj polecenia OPEN-FETCH-CLOSE).

	DECLARE
		CURSOR c_pracownicy IS
		SELECT	nazwisko
				,zatrudniony
		FROM	pracownicy
		WHERE	etat = 'ASYSTENT'
		ORDER BY zatrudniony;
		
		row_c_pracownicy c_pracownicy%ROWTYPE;
	BEGIN
		OPEN c_pracownicy;
		LOOP
			FETCH	c_pracownicy 
			INTO	row_c_pracownicy;
			
			EXIT WHEN c_pracownicy%NOTFOUND;
			
			DBMS_OUTPUT.PUT_LINE(row_c_pracownicy.nazwisko || ' pracuje od '|| TO_CHAR(row_c_pracownicy.zatrudniony, 'DD-MM-YYYY')); 
		END LOOP;
	END;
	/

--------------------------------------------------------
-- 2. Zdefiniuj kursor, dziêki któremu bêdzie mo¿na wyœwietliæ 3 najlepiej zarabiaj¹cych
--	  pracowników. Pos³u¿ siê atrybutem kursora %ROWCOUNT.
	
	DECLARE
		CURSOR c_zarobki_prac IS
		SELECT	nazwisko
		FROM	pracownicy
		ORDER BY placa_pod DESC;
		
		v_nazwisko pracownicy.nazwisko%TYPE;
	BEGIN
		OPEN c_zarobki_prac;
		LOOP
			FETCH	c_zarobki_prac 
			INTO	v_nazwisko;
			
			EXIT WHEN c_zarobki_prac%ROWCOUNT > 3;
			
			DBMS_OUTPUT.PUT_LINE(c_zarobki_prac%ROWCOUNT || ' : ' || v_nazwisko); 
		END LOOP;
	END;
	/

--------------------------------------------------------
-- 3. Zbuduj kursor, który pozwoli Ci zwiêkszyæ o 20% p³acê podstawow¹ pracowników
--	  zatrudnionych w poniedzia³ek. Pos³u¿ siê pêtl¹ FOR z kursorem.
	
	ALTER SESSION SET NLS_TERRITORY = 'POLAND'; --zmiana parametrów sesji, aby poniedzia³ek by³ pierwszym dniem tygodnia
	
	DECLARE
		CURSOR c_podwyzka IS
		SELECT	id_prac
		FROM	pracownicy
		WHERE	TO_CHAR(zatrudniony, 'd') = 1
		FOR UPDATE;
	BEGIN
		FOR i IN c_podwyzka LOOP
			UPDATE	pracownicy
			SET 	placa_pod = placa_pod * 1.2
			WHERE 	CURRENT OF c_podwyzka;
		END LOOP;
	END;
	/

--------------------------------------------------------
-- 4. Zdefiniuj kursor, który pos³u¿y do dokonania nastêpuj¹cej modyfikacji: pracownikom zespo³u
--	  ALGORYTMY podnieœ p³acê dodatkow¹ o 100 z³otych, pracownikom zespo³u
--	  ADMINISTRACJA podnieœ p³acê dodatkow¹ o 150 z³otych a w pozosta³ych zespo³ach usuñ
--	  sta¿ystów.

	DECLARE
		CURSOR c_modyfikacje IS
		SELECT	p.etat AS etat
				,z.nazwa AS nazwa_zespolu
		FROM	pracownicy p
		JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
		FOR UPDATE;
	BEGIN
		FOR i IN c_modyfikacje LOOP
			IF i.nazwa_zespolu = 'ALGORYTMY' THEN
				UPDATE	pracownicy
				SET		placa_dod = NVL(placa_dod, 0) + 100
				WHERE	CURRENT OF c_modyfikacje;
			ELSIF i.nazwa_zespolu = 'ADMINISTRACJA' THEN
				UPDATE	pracownicy
				SET		placa_dod = NVL(placa_dod, 0) + 150
				WHERE	CURRENT OF c_modyfikacje; 
			ELSIF i.nazwa_zespolu NOT IN ('ALGORYTMY', 'ADMINISTRACJA') 
				AND i.etat = 'STAZYSTA' THEN
				DELETE FROM pracownicy 
				WHERE CURRENT OF c_modyfikacje;
			END IF;
		END LOOP; 
	END;
	/

--------------------------------------------------------
-- 5. Napisz program, który zapyta u¿ytkownika o ¿¹dany etat a nastêpnie wyœwietli nazwiska
--	  wszystkich pracowników posiadaj¹cych dany etat. Zastosuj pêtlê FOR z kursorem
--	  sparametryzowanym.
	
	DECLARE
		CURSOR c_wypisz_pracownikow (p_etat VARCHAR2) IS
		SELECT	nazwisko
		FROM	pracownicy 
		WHERE	etat = p_etat
		ORDER BY nazwisko;
		
		v_etat pracownicy.etat%TYPE;
	BEGIN
		v_etat := UPPER(:podaj_etat);
	
		FOR i IN c_wypisz_pracownikow(v_etat) LOOP
			DBMS_OUTPUT.PUT_LINE(i.nazwisko);
		END LOOP; 
	END;
	/

--------------------------------------------------------
-- 6. Napisz program, który wyœwietli na ekranie zestawienie pracowników wg etatów w
--	  nastêpuj¹cym formacie:

--	  Etat: <nazwa etatu>
--	  <lp> <nazwisko_pracownika>, pensja: <p³aca podstawowa + p³aca dodatkowa>
--	  …
--	  Liczba pracowników: <liczba pracowników na danym etacie>
--	  Œrednia p³aca na etacie: <œrednia p³aca pracowników na etacie>
--	  …
--	  Jeœli na etacie nie ma ¿adnych pracowników, w miejsce œredniej pensji powinien pojawiæ siê
--	  napis „brak”. Przyk³adowy wynik dzia³ania programu:
--	  Etat: ADIUNKT
--	  1 KOSZLAJDA, pensja: 590,00
--	  2 KROLIKOWSKI, pensja: 645,50
--	  Liczba pracowników: 2
--	  Œrednia pensja: 617,75
--	  Etat: ASYSTENT
--	  1 HAPKE, pensja: 570,00
--	  2 JEZIERSKI, pensja: 520,20
--	  3 KONOPKA, pensja: 480,00
--	  Liczba pracowników: 3
--	  Œrednia pensja: 523,40
--	  Etat: DYREKTOR
--	  1 WEGLARZ, pensja: 2 150,50
--	  Liczba pracowników: 1
--	  Œrednia pensja: 2 150,50
--	  Etat: PROFESOR
--	  1 BLAZEWICZ, pensja: 1 560,00
--	  2 BRZEZINSKI, pensja: 960,00
--	  3 SLOWINSKI, pensja: 1 070,00
--	  Liczba pracowników: 3
--	  Œrednia pensja: 1 196,67
--	  Etat: SEKRETARKA
--	  1 MAREK, pensja: 410,20
--	  Liczba pracowników: 1
--	  Œrednia pensja: 410,20
--	  Etat: STAZYSTA
--	  1 BIALY, pensja: 420,60
--	  Liczba pracowników: 1
--	  Œrednia pensja: 420,60

--	  W rozwi¹zaniu pos³u¿ siê dwoma kursorami: jednym na relacji ETATY, drugim na relacji
--	  PRACOWNICY. Drugi kursor ma byæ kursorem sparametryzowanym.
	
	DECLARE
		CURSOR c_etaty IS
		SELECT	DISTINCT nazwa 
		FROM	etaty 
		ORDER BY nazwa; 
		
		CURSOR c_pensje_pracownikow(p_etat VARCHAR2) IS
		SELECT	ROWNUM AS lp
				,osoba.*
		FROM	(SELECT nazwisko
						,TRIM(TO_CHAR(placa_pod + NVL(placa_dod, 0), '999G999D99')) AS pensja
				FROM	pracownicy
				WHERE	etat = p_etat
				ORDER BY nazwisko) osoba;
		
		v_srednia_pensja VARCHAR2(10);
		n_liczba_osob NUMBER;
	BEGIN
		FOR i IN c_etaty LOOP
			DBMS_OUTPUT.PUT_LINE('Etat: ' || i.nazwa); 
		
			FOR j IN c_pensje_pracownikow(i.nazwa) LOOP
				DBMS_OUTPUT.PUT_LINE(j.lp || ' ' || j.nazwisko || ', pensja: ' || j.pensja);
			END LOOP;
		
			SELECT	COUNT(*)
					,TRIM(NVL(TO_CHAR(AVG(placa_pod + NVL(placa_dod, 0)), '999G999D99'), 'Brak'))
			INTO	n_liczba_osob
					,v_srednia_pensja
			FROM	pracownicy 
			WHERE	etat = i.nazwa;
		
			DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || n_liczba_osob);
			DBMS_OUTPUT.PUT_LINE('Œrednia pensja: ' || v_srednia_pensja);
			DBMS_OUTPUT.NEW_LINE;
		END LOOP;
	END;

--------------------------------------------------------
-- 7. Zaprojektuj program, w którym wykorzystasz zmienn¹ kursorow¹ s³abo typowan¹. Program ma
--	  znaleŸæ zespó³, którego pracownicy maj¹ sumarycznie najd³u¿szy sta¿ pracy (pierwsze u¿ycie
--	  zmiennej kursorowej), wypisaæ nazwê znalezionego zespo³u, a nastêpnie listê pracowników tego
--	  zespo³u, dla ka¿dego pracownika program ma podaæ sta¿ pracy w latach i miesi¹cach (drugie
--	  u¿ycie zmiennej kursorowej). 

--	  Przyk³adowy wynik dzia³ania programu:
--	  Zespó³ z najd³u¿szym sta¿em: SYSTEMY ROZPROSZONE
--	  BRZEZINSKI, sta¿: lat: 44, miesiêcy: 7
--	  JEZIERSKI, sta¿: lat: 20, miesiêcy: 4
--	  KONOPKA, sta¿: lat: 19, miesiêcy: 4
--	  KOSZLAJDA, sta¿: lat: 27, miesiêcy: 11
--	  KROLIKOWSKI, sta¿: lat: 35, miesiêcy: 5

	
	DECLARE	
		TYPE t_ref_cur IS REF CURSOR;	
		c_ref_cur t_ref_cur;
	
		v_nazwa VARCHAR2(20);	
		v_nazwisko VARCHAR2(30);	
		n_lata NUMBER;	
		n_miesiace NUMBER;	
	BEGIN
		OPEN c_ref_cur FOR SELECT	nazwa	
						   FROM		(SELECT	z.nazwa	
											,SUM(TRUNC(SYSDATE) - zatrudniony) AS sumaryczny_staz --w dniach	
									FROM	pracownicy p	
									JOIN	zespoly z ON (p.id_zesp = z.id_zesp)	
									GROUP BY z.nazwa	
									ORDER BY sumaryczny_staz DESC	
									FETCH FIRST 1 ROW ONLY) zespolowy_najwyzszy_staz;
		
		FETCH	c_ref_cur	
		INTO	v_nazwa;
	
		DBMS_OUTPUT.PUT_LINE('Zespó³ z najd³u¿szym sta¿em: ' || v_nazwa);

		OPEN c_ref_cur FOR SELECT	p.nazwisko	
									,TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), p.zatrudniony)/12) AS lata	
									,TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), p.zatrudniony) -	
									(TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), p.zatrudniony) / 12) * 12)) AS miesiace	
						   FROM		pracownicy p	
						   JOIN		zespoly z ON (p.id_zesp = z.id_zesp)	
						   WHERE	z.nazwa = v_nazwa	
						   ORDER BY p.nazwisko;
			
		LOOP	
			FETCH	c_ref_cur	
			INTO	v_nazwisko	
					,n_lata	
					,n_miesiace;		
	
			EXIT WHEN c_ref_cur%NOTFOUND;			
	
			DBMS_OUTPUT.PUT_LINE(v_nazwisko || ', sta¿: lat: ' || n_lata || ', miesiêcy: ' || n_miesiace);					
		END LOOP;	
	END;
	/

--------------------------------------------------------
-- 8. Spróbuj rozwi¹zaæ zadanie 6. stosuj¹c wyra¿enie CURSOR.

	--wersja z podzapytaniami w klauzuli SELECT obliczaj¹cymi liczbê pracowników na etacie i œredni¹ pensjê na etacie
	DECLARE
		TYPE t_ref_pracownicy IS REF CURSOR;
		c_ref_pracownicy t_ref_pracownicy;
		
		CURSOR c_raport IS
		SELECT	e.nazwa
				,CURSOR(SELECT	nazwisko
								,TRIM(TO_CHAR(placa_pod + NVL(placa_dod, 0), '999G999D99')) AS pensja 
						FROM	pracownicy
						WHERE	etat = e.nazwa
						ORDER BY nazwisko) AS pracownik 
				,(SELECT	COUNT(*)
				  FROM		pracownicy
				  WHERE		etat = e.nazwa) AS ilu_pracownikow
				,(SELECT	TRIM(NVL(TO_CHAR(AVG(placa_pod + NVL(placa_dod, 0)), '999G999D99'), 'Brak')) AS srednia_pensja
				  FROM		pracownicy
				  WHERE		etat = e.nazwa) AS srednia_pensja 
		FROM	etaty e
		ORDER BY e.nazwa; 
		
		v_nazwa VARCHAR2(20);
		v_nazwisko VARCHAR2(20);
		v_pensja VARCHAR2(10);
		n_liczba_osob NUMBER;
		v_srednia_pensja VARCHAR2(10);
	BEGIN
		OPEN c_raport;
		
		LOOP
			FETCH	c_raport
			INTO	v_nazwa
					,c_ref_pracownicy
					,n_liczba_osob
					,v_srednia_pensja;
			
			EXIT WHEN c_raport%NOTFOUND;
			
			DBMS_OUTPUT.PUT_LINE('Etat: ' || v_nazwa);
				
				LOOP
					FETCH	c_ref_pracownicy
					INTO	v_nazwisko
							,v_pensja;
					
					EXIT WHEN c_ref_pracownicy%NOTFOUND;
					DBMS_OUTPUT.PUT_LINE(c_ref_pracownicy%ROWCOUNT || ' ' || v_nazwisko || ', pensja: ' || v_pensja);
				END LOOP;
		
			DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || n_liczba_osob);
			DBMS_OUTPUT.PUT_LINE('Œrednia pensja: ' || v_srednia_pensja);
			DBMS_OUTPUT.NEW_LINE;
		END LOOP;
	END;
	/

	-- wersja tylko z wyra¿eniem CURSOR	
	DECLARE
		TYPE t_ref_pracownicy IS REF CURSOR;
		c_ref_pracownicy t_ref_pracownicy;
		c_ref_ilu_pracownikow t_ref_pracownicy;
		c_ref_srednia_pensja t_ref_pracownicy;
		
		CURSOR c_raport IS
		SELECT	e.nazwa
				,CURSOR(SELECT	nazwisko
								,TRIM(TO_CHAR(placa_pod + NVL(placa_dod, 0), '999G999D99')) AS pensja 
						FROM	pracownicy
						WHERE	etat = e.nazwa
						ORDER BY nazwisko) AS pracownik 
				,CURSOR(SELECT	COUNT(*)
						FROM	pracownicy
						WHERE	etat = e.nazwa) AS ilu_pracownikow
				,CURSOR(SELECT	TRIM(NVL(TO_CHAR(AVG(placa_pod + NVL(placa_dod, 0)), '999G999D99'), 'Brak')) AS srednia_pensja
						FROM	pracownicy
						WHERE	etat = e.nazwa) AS srednia_pensja 
		FROM	etaty e
		ORDER BY e.nazwa; 
		
		v_nazwa VARCHAR2(20);
		v_nazwisko VARCHAR2(20);
		v_pensja VARCHAR2(10);
		n_liczba_osob NUMBER;
		v_srednia_pensja VARCHAR2(10);
	BEGIN
		OPEN c_raport;
		
		LOOP
			FETCH	c_raport
			INTO	v_nazwa
					,c_ref_pracownicy
					,c_ref_ilu_pracownikow
					,c_ref_srednia_pensja;
			
			EXIT WHEN c_raport%NOTFOUND;
			
			DBMS_OUTPUT.PUT_LINE('Etat: ' || v_nazwa);
				
				LOOP
					FETCH	c_ref_pracownicy
					INTO	v_nazwisko
							,v_pensja;
					
					EXIT WHEN c_ref_pracownicy%NOTFOUND;
					DBMS_OUTPUT.PUT_LINE(c_ref_pracownicy%ROWCOUNT || ' ' || v_nazwisko || ', pensja: ' || v_pensja);
				END LOOP;
				
			FETCH	c_ref_ilu_pracownikow
			INTO	n_liczba_osob;
							
			DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || n_liczba_osob);
			
			FETCH	c_ref_srednia_pensja
			INTO	v_srednia_pensja;
			
			DBMS_OUTPUT.PUT_LINE('Œrednia pensja: ' || v_srednia_pensja);
			
			DBMS_OUTPUT.NEW_LINE;
		END LOOP;
	END;
	/

