/*
* --------------------------------------------
* Rozdzia³ 8. Perspektywy – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 08Perspektywy_zadania.pdf
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
*/

--------------------------------------------------------

-- 1. Zdefiniuj perspektywê ASYSTENCI udostêpniaj¹c¹ nastêpuj¹ce informacje o asystentach
--	  zatrudnionych w Instytucie.
	
	CREATE OR REPLACE VIEW asystenci (id 
									 ,nazwisko
									 ,placa
									 ,sta¿_pracy) 
	AS
	SELECT	id_prac
			,nazwisko
			,placa_pod
			,'lat: '
			|| EXTRACT (YEAR FROM (SYSDATE - zatrudniony) YEAR TO MONTH)
			||', miesiêcy: '
			||EXTRACT (MONTH FROM (SYSDATE - zatrudniony) YEAR TO MONTH)
	FROM	pracownicy
	WHERE	etat = 'ASYSTENT';

-------------------------------------------------------- 
-- 2. Zdefiniuj perspektywê PLACE udostêpniaj¹c¹ nastêpuj¹ce dane: numer zespo³u, œredni¹,
--	  minimaln¹ i maksymaln¹ p³acê w zespole (miesiêczna p³aca wraz z dodatkami), fundusz
--	  p³ac (SUMa pieniêdzy wyp³acanych miesiêcznie pracownikom) oraz liczbê wyp³acanych
--	  pensji i dodatków. Wyœwietl ca³oœæ informacji udostêpnianych przez perspektywê.
	
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
-- 3. Korzystaj¹c z perspektywy PLACE wyœwietl nazwiska i p³ace tych pracowników, którzy
--	  zarabiaj¹ mniej ni¿ œrednia w ich zespole.
	
	SELECT	p.nazwisko
			,p.placa_pod + NVL(p.placa_dod, 0) AS placa_pod
	FROM	pracownicy p
	JOIN	place pl ON (p.id_zesp = pl.id_zesp)
	WHERE	p.placa_pod + NVL(p.placa_dod, 0) < pl.srednia;

--------------------------------------------------------
-- 4. Zdefiniuj perspektywê PLACE_MINIMALNE wyœwietlaj¹c¹ pracowników zarabiaj¹cych
--	  poni¿ej 700 z³otych. Perspektywa musi zapewniaæ weryfikacjê danych, w taki sposób, aby
--	  za jej pomoc¹ nie mo¿na by³o podnieœæ pensji pracownika powy¿ej pu³apu 700 z³otych.
	
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
-- 5. Spróbuj za pomoc¹ perspektywy PLACE_MINIMALNE zwiêkszyæ pensjê pracownika

	UPDATE	place_minimalne
	SET		placa_pod = 800 
	WHERE	nazwisko = 'HAPKE' 
  
	--skutek:
  
	SQL Error: ORA-01402: naruszenie klauzuli WHERE dla perspektywy z WITH CHECK OPTION 01402. 00000 - "view WITH CHECK OPTION where-clause violation" 
  
--------------------------------------------------------  
-- 6. Stwórz perspektywê PRAC_SZEF prezentuj¹c¹ informacje o pracownikach i ich
--	  prze³o¿onych. Zwróæ uwagê na to, aby mo¿na by³o przez perspektywê PRAC_SZEF
--	  wstawiaæ nowych pracowników oraz modyfikowaæ i usuwaæ istniej¹cych pracowników.

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
			,(SELECT	nazwisko
			  FROM		pracownicy
			  WHERE		id_prac = p.id_szefa)
	FROM	pracownicy p;

	--sprawdzenie dzia³ania:
	
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
	SET		id_szefa = 140
	WHERE	id_prac = 280;
	
	DELETE
	FROM	prac_szef 
	WHERE	id_prac = 280; 
	
-------------------------------------------------------- 
-- 7. Stwórz perspektywê ZAROBKI wyœwietlaj¹c¹ poni¿sze informacje o pracownikach.
--	  Perspektywa musi zapewniaæ kontrolê pensji pracownika (pensja pracownika nie mo¿e
--	  byæ wy¿sza ni¿ pensja jego szefa).
	
	CREATE OR REPLACE VIEW zarobki  (id_prac
									,nazwisko
									,etat
									,placa_pod) 
	AS
	SELECT	p.id_prac
			,p.nazwisko
			,p.etat
			,p.placa_pod
	FROM	pracownicy p WHERE p.placa_pod < (SELECT	placa_pod
											  FROM		pracownicy
											  WHERE		id_prac = p.id_szefa) 
	WITH CHECK OPTION CONSTRAINT placa_szefa_wyzsza;
	
	--sprawdzenie dzia³ania:
	
	UPDATE	zarobki
	SET		placa_pod = 2000 
	WHERE	nazwisko = 'BIALY';
	
	SQL Error: ORA-01402: naruszenie klauzuli
	WHERE dla perspektywy z WITH CHECK OPTION 01402. 00000 - "view WITH CHECK OPTION where-clause violation" 

-------------------------------------------------------- 
-- 8. Wyœwietl informacje ze s³ownika bazy danych dotycz¹ce mo¿liwoœci wstawiania,
--	  modyfikowania i usuwania za pomoc¹ perspektywy PRAC_SZEF
	
	SELECT	column_name
			,updatable
			,insertable
			,deletable
	FROM	user_updatable_columns 
	WHERE	table_name = 'PRAC_SZEF'; 
  
--------------------------------------------------------  
-- 9. Napisz zapytanie, które wyœwietli nazwiska i pensje trzech najlepiej zarabiaj¹cych
--	  pracowników. Pos³u¿ siê pseudokolumn¹ ROWNUM.
	
	SELECT	t.nazwisko
			,t.placa_pod
	FROM	(SELECT ROWNUM AS rnum
					,nazwisko
					,placa_pod
			FROM	pracownicy
			ORDER BY placa_pod DESC
			) t 
	WHERE	t.rnum <= 3; 
		
--------------------------------------------------------	 
-- 10. Napisz zapytanie, które wyœwietli „drug¹ pi¹tkê” pracowników zgodnie z ich zarobkami.
--	   Pos³u¿ siê pseudokolumn¹ ROWNUM.
	
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
	AND		e.ranking <= 10;

