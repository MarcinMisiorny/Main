/*
* --------------------------------------------
* Rozdzia� 8. Perspektywy � zadania
* --------------------------------------------
* 
* Plik z zadaniami: 08Perspektywy_zadania.pdf
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
*/

--------------------------------------------------------

-- 1. Zdefiniuj perspektyw� ASYSTENCI udost�pniaj�c� nast�puj�ce informacje o asystentach
--	  zatrudnionych w Instytucie.
	
	CREATE OR REPLACE VIEW asystenci (id 
									 ,nazwisko
									 ,placa
									 ,sta�_pracy) 
	AS
	SELECT	id_prac
			,nazwisko
			,placa_pod
			,'lat: '
			|| EXTRACT (YEAR FROM (SYSDATE - zatrudniony) YEAR TO MONTH)
			||', miesi�cy: '
			||EXTRACT (MONTH FROM (SYSDATE - zatrudniony) YEAR TO MONTH)
	FROM	pracownicy
	WHERE	etat = 'ASYSTENT';

-------------------------------------------------------- 
-- 2. Zdefiniuj perspektyw� PLACE udost�pniaj�c� nast�puj�ce dane: numer zespo�u, �redni�,
--	  minimaln� i maksymaln� p�ac� w zespole (miesi�czna p�aca wraz z dodatkami), fundusz
--	  p�ac (SUMa pieni�dzy wyp�acanych miesi�cznie pracownikom) oraz liczb� wyp�acanych
--	  pensji i dodatk�w. Wy�wietl ca�o�� informacji udost�pnianych przez perspektyw�.
	
	CREATE OR REPLACE VIEW place (id_zesp
								 ,srednia
								 ,minimum
								 ,maximum
								 ,fundusz
								 ,l_pensji
								 ,l_dodatk�w) 
	AS
	SELECT	id_zesp
			,ROUND(AVG(placa_pod + NVL(placa_dod, 0)), 2)
			,MIN(placa_pod + NVL(placa_dod, 0))
			,MAX(placa_pod + NVL(placa_dod, 0))
			,SUM(placa_pod + NVL(placa_dod, 0))
			,COUNT(placa_pod) AS l_pensji
			,COUNT(placa_dod) AS l_dodatk�w
	FROM	pracownicy
	GROUP BY id_zesp
	ORDER BY id_zesp ASC;

--------------------------------------------------------
-- 3. Korzystaj�c z perspektywy PLACE wy�wietl nazwiska i p�ace tych pracownik�w, kt�rzy
--	  zarabiaj� mniej ni� �rednia w ich zespole.
	
	SELECT	p.nazwisko
			,p.placa_pod + NVL(p.placa_dod, 0) AS placa_pod
	FROM	pracownicy p
	JOIN	place pl ON (p.id_zesp = pl.id_zesp)
	WHERE	p.placa_pod + NVL(p.placa_dod, 0) < pl.srednia;

--------------------------------------------------------
-- 4. Zdefiniuj perspektyw� PLACE_MINIMALNE wy�wietlaj�c� pracownik�w zarabiaj�cych
--	  poni�ej 700 z�otych. Perspektywa musi zapewnia� weryfikacj� danych, w taki spos�b, aby
--	  za jej pomoc� nie mo�na by�o podnie�� pensji pracownika powy�ej pu�apu 700 z�otych.
	
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
-- 5. Spr�buj za pomoc� perspektywy PLACE_MINIMALNE zwi�kszy� pensj� pracownika

	UPDATE	place_minimalne
	SET		placa_pod = 800 
	WHERE	nazwisko = 'HAPKE' 
  
	--skutek:
  
	SQL Error: ORA-01402: naruszenie klauzuli WHERE dla perspektywy z WITH CHECK OPTION 01402. 00000 - "view WITH CHECK OPTION where-clause violation" 
  
--------------------------------------------------------  
-- 6. Stw�rz perspektyw� PRAC_SZEF prezentuj�c� informacje o pracownikach i ich
--	  prze�o�onych. Zwr�� uwag� na to, aby mo�na by�o przez perspektyw� PRAC_SZEF
--	  wstawia� nowych pracownik�w oraz modyfikowa� i usuwa� istniej�cych pracownik�w.

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

	--sprawdzenie dzia�ania:
	
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
-- 7. Stw�rz perspektyw� ZAROBKI wy�wietlaj�c� poni�sze informacje o pracownikach.
--	  Perspektywa musi zapewnia� kontrol� pensji pracownika (pensja pracownika nie mo�e
--	  by� wy�sza ni� pensja jego szefa).
	
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
	
	--sprawdzenie dzia�ania:
	
	UPDATE	zarobki
	SET		placa_pod = 2000 
	WHERE	nazwisko = 'BIALY';
	
	SQL Error: ORA-01402: naruszenie klauzuli
	WHERE dla perspektywy z WITH CHECK OPTION 01402. 00000 - "view WITH CHECK OPTION where-clause violation" 

-------------------------------------------------------- 
-- 8. Wy�wietl informacje ze s�ownika bazy danych dotycz�ce mo�liwo�ci wstawiania,
--	  modyfikowania i usuwania za pomoc� perspektywy PRAC_SZEF
	
	SELECT	column_name
			,updatable
			,insertable
			,deletable
	FROM	user_updatable_columns 
	WHERE	table_name = 'PRAC_SZEF'; 
  
--------------------------------------------------------  
-- 9. Napisz zapytanie, kt�re wy�wietli nazwiska i pensje trzech najlepiej zarabiaj�cych
--	  pracownik�w. Pos�u� si� pseudokolumn� ROWNUM.
	
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
-- 10. Napisz zapytanie, kt�re wy�wietli �drug� pi�tk� pracownik�w zgodnie z ich zarobkami.
--	   Pos�u� si� pseudokolumn� ROWNUM.
	
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

