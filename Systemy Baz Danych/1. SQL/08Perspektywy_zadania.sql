/*
* --------------------------------------------
* Rozdział 8. Perspektywy – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 08Perspektywy_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------

-- 1. Zdefiniuj perspektywę ASYSTENCI udostępniającą następujące informacje o asystentach
--    zatrudnionych w Instytucie.
	
	CREATE OR REPLACE VIEW asystenci (id 
					 ,nazwisko
					 ,placa
					 ,staż_pracy) 
	AS
	SELECT	id_prac
		,nazwisko
		,placa_pod
		,'lat: '
		|| EXTRACT (YEAR FROM (SYSDATE - zatrudniony) YEAR TO MONTH)
		||', miesięcy: '
		||EXTRACT (MONTH FROM (SYSDATE - zatrudniony) YEAR TO MONTH)
	FROM	pracownicy
	WHERE	etat = 'ASYSTENT';

-------------------------------------------------------- 
-- 2. Zdefiniuj perspektywę PLACE udostępniającą następujące dane: numer zespołu, średnią,
--    minimalną i maksymalną płacę w zespole (miesięczna płaca wraz z dodatkami), fundusz
--    płac (SUMa pieniędzy wypłacanych miesięcznie pracownikom) oraz liczbę wypłacanych
--    pensji i dodatków. Wyświetl całość informacji udostępnianych przez perspektywę.
	
	CREATE OR REPLACE VIEW place (id_zesp
				     ,srednia
				     ,minimum
				     ,maximum
				     ,fundusz
				     ,l_pensji
				     ,l_dodatków) 
	AS
	SELECT	id_zesp
		,ROUND(AVG(placa_pod + NVL(placa_dod, 0)), 2)
		,MIN(placa_pod + NVL(placa_dod, 0))
		,MAX(placa_pod + NVL(placa_dod, 0))
		,SUM(placa_pod + NVL(placa_dod, 0))
		,COUNT(placa_pod) AS l_pensji
		,COUNT(placa_dod) AS l_dodatków
	FROM	pracownicy
	GROUP BY id_zesp
	ORDER BY id_zesp ASC;

--------------------------------------------------------
-- 3. Korzystając z perspektywy PLACE wyświetl nazwiska i płace tych pracowników, którzy
--    zarabiają mniej niż średnia w ich zespole.
	
	SELECT	p.nazwisko
		,p.placa_pod + NVL(p.placa_dod, 0) AS placa_pod
	FROM	pracownicy p
	JOIN	place pl ON (p.id_zesp = pl.id_zesp)
	WHERE	p.placa_pod + NVL(p.placa_dod, 0) < pl.srednia;

--------------------------------------------------------
-- 4. Zdefiniuj perspektywę PLACE_MINIMALNE wyświetlającą pracowników zarabiających
--    poniżej 700 złotych. Perspektywa musi zapewniać weryfikację danych, w taki sposób, aby
--    za jej pomocą nie można było podnieść pensji pracownika powyżej pułapu 700 złotych.
	
	CREATE OR REPLACE VIEW place_minimalne 
	AS
	SELECT	id_prac
		,nazwisko
		,etat
		,placa_pod
	FROM	pracownicy
	WHERE	placa_pod < 700 
	WITH CHECK OPTION CONSTRAINT za_wysoka_placa;
	
--------------------------------------------------------
-- 5. Spróbuj za pomocą perspektywy PLACE_MINIMALNE zwiększyć pensję pracownika

	UPDATE	place_minimalne
	SET	placa_pod = 800 
	WHERE	nazwisko = 'HAPKE' 
  
	--skutek:
  
	SQL Error: ORA-01402: naruszenie klauzuli WHERE dla perspektywy z WITH CHECK OPTION 01402. 00000 - "view WITH CHECK OPTION where-clause violation" 
  
--------------------------------------------------------  
-- 6. Stwórz perspektywę PRAC_SZEF prezentującą informacje o pracownikach i ich
--    przełożonych. Zwróć uwagę na to, aby można było przez perspektywę PRAC_SZEF
--    wstawiać nowych pracowników oraz modyfikować i usuwać istniejących pracowników.

	CREATE OR REPLACE VIEW prac_szef (id_prac
					 ,id_szefa
					 ,pracownik
					 ,etat
					 ,szef) 
	AS
	SELECT	p.id_prac
		,p.id_szefa
		,p.nazwisko
		,p.etat
		,(SELECT  nazwisko
		  FROM	  pracownicy
		  WHERE	  id_prac = p.id_szefa)
	FROM	pracownicy p;

	--sprawdzenie działania:
	
	INSERT INTO prac_szef (ID_PRAC
			      ,ID_SZEFA
			      ,PRACOWNIK
			      ,ETAT)
	VALUES		
			      (280
			      ,150
			      ,'Kowalski'
			      ,'PROFESOR');
	            
	UPDATE	prac_szef
	SET	id_szefa = 140
	WHERE	id_prac = 280;
	
	DELETE
	FROM	prac_szef 
	WHERE	id_prac = 280; 
	
-------------------------------------------------------- 
-- 7. Stwórz perspektywę ZAROBKI wyświetlającą poniższe informacje o pracownikach.
--    Perspektywa musi zapewniać kontrolę pensji pracownika (pensja pracownika nie może
--    być wyższa niż pensja jego szefa).
	
	CREATE OR REPLACE VIEW zarobki  (id_prac
					,nazwisko
					,etat
					,placa_pod) 
	AS
	SELECT	p.id_prac
		,p.nazwisko
		,p.etat
		,p.placa_pod
	FROM	pracownicy p WHERE p.placa_pod < (SELECT  placa_pod
						  FROM	  pracownicy
						  WHERE	  id_prac = p.id_szefa) 
	WITH CHECK OPTION CONSTRAINT placa_szefa_wyzsza;
	
	--sprawdzenie działania:
	
	UPDATE	zarobki
	SET	placa_pod = 2000 
	WHERE	nazwisko = 'BIALY';
	
	SQL Error: ORA-01402: naruszenie klauzuli
	WHERE dla perspektywy z WITH CHECK OPTION 01402. 00000 - "view WITH CHECK OPTION where-clause violation" 

-------------------------------------------------------- 
-- 8. Wyświetl informacje ze słownika bazy danych dotyczące możliwości wstawiania,
--    modyfikowania i usuwania za pomocą perspektywy PRAC_SZEF
	
	SELECT	column_name
		,updatable
		,insertable
		,deletable
	FROM	user_updatable_columns 
	WHERE	table_name = 'PRAC_SZEF'; 
  
--------------------------------------------------------  
-- 9. Napisz zapytanie, które wyświetli nazwiska i pensje trzech najlepiej zarabiających
--    pracowników. Posłuż się pseudokolumną ROWNUM.
	
	SELECT	t.nazwisko
		,t.placa_pod
	FROM	(SELECT  ROWNUM AS rnum
			 ,nazwisko
			 ,placa_pod
		FROM	 pracownicy
		ORDER BY placa_pod DESC
		) t 
	WHERE	t.rnum <= 3; 
		
--------------------------------------------------------	 
-- 10. Napisz zapytanie, które wyświetli „drugą piątkę” pracowników zgodnie z ich zarobkami.
--     Posłuż się pseudokolumną ROWNUM.
	
	SELECT	e.*
	FROM	(SELECT ROWNUM AS ranking
			,t.nazwisko
			,t.placa_pod
			,t.etat
		 FROM	(SELECT  nazwisko
				,placa_pod
				,etat
			FROM	pracownicy
			ORDER BY placa_pod DESC
			) t 
		) e 
	WHERE	e.ranking >= 5
	AND	e.ranking <= 10;

