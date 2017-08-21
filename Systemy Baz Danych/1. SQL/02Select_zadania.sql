/*
* --------------------------------------------
* Rozdział 2. Język bazy danych - SQL – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 02Select_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wyświetl całość informacji z relacji ZESPOLY.

	SELECT	*
	FROM 	zespoly; 

--------------------------------------------------------
-- 2. Wyświetl całość informacji z relacji PRACOWNICY.

	SELECT	*
	FROM	pracownicy;
	
--------------------------------------------------------
-- 3. Wyświetl nazwiska i roczne dochody pracowników.

	SELECT	nazwisko
		,placa_pod * 12
	FROM	pracownicy; 
	
--------------------------------------------------------
-- 4. Wyświetl nazwy etatów i sumaryczne miesięczne dochody pracowników (z uwzględnieniem płac dodatkowych)

	SELECT	etat
		,placa_pod + NVL(placa_dod, 0)
	FROM	pracownicy; 
	
--------------------------------------------------------
-- 5. Wyświetl całość informacji o zespołach sortując wynik według nazw zespołów

	SELECT	*
	FROM	zespoly
	ORDER BY nazwa; 
	
--------------------------------------------------------
-- 6. Wyświetl listę etatów (bez duplikatów) na których zatrudnieni są pracownicy Instytutu.

	SELECT	DISTINCT etat
	FROM	pracownicy
	ORDER BY etat;

--------------------------------------------------------
-- 7. Wyświetl wszystkie informacje o asystentach pracujących w Instytucie.

	SELECT	*
	FROM	pracownicy
	WHERE	ETAT = 'ASYSTENT'; 
	
--------------------------------------------------------
-- 8. Wybierz poniższe dane o pracownikach zespołów 30 i 40 w kolejności malejących zarobków.

	SELECT	id_prac
		,nazwisko
		,etat
		,placa_pod
		,id_zesp
	FROM	pracownicy 
	WHERE	ID_ZESP IN (30, 40)
	ORDER BY placa_pod DESC; 

--------------------------------------------------------
-- 9. Wybierz dane o pracownikach których płace podstawowe mieszczą się w przedziale 300 do 800 zł.

	SELECT	nazwisko
		,id_zesp
		,placa_pod
	FROM	pracownicy
	WHERE	placa_pod BETWEEN 300 AND 800; 

--------------------------------------------------------
-- 10. Wyświetl poniższe informacje o pracownikach, których nazwisko kończy się na SKI

	SELECT	nazwisko
		,etat
		,id_zesp
	FROM	pracownicy 
	WHERE	nazwisko LIKE '%SKI'; 

--------------------------------------------------------  
-- 11. Wyświetl poniższe informacje o tych pracownikach, którzy zarabiają powyżej 1000 złotych i posiadają szefa.

	SELECT	id_prac
		,id_szefa
		,nazwisko
		,placa_pod
	FROM	pracownicy 
	WHERE	placa_pod > 1000
	AND 	id_szefa IS NOT NULL;
	
--------------------------------------------------------
-- 12. Wyświetl nazwiska i identyfikatory zespołów pracowników zatrudnionych w zespole nr 20, których nazwisko 
--	   zaczyna się na ‘M’ lub kończy na ‘SKI’.

	SELECT	nazwisko
		,id_zesp
	FROM	pracownicy WHERE id_zesp = 20
	AND	(nazwisko LIKE 'M%'
	OR	nazwisko LIKE '%SKI');
	
--------------------------------------------------------	   
-- 13. Wyświetl nazwiska, etaty i stawki godzinowe tych pracowników, którzy nie są ani adiunktami ani
--     asystentami ani stażystami i którzy nie zarabiają w przedziale od 400 do 800 złotych. Wyniki
--     uszereguj według stawek godzinowych pracowników (przyjmij 20-dniowy miesiąc pracy i 8-godzinny dzień pracy).

	SELECT	nazwisko
		,etat
		,placa_pod / 20 / 8 AS stawka
	FROM	pracownicy 
	WHERE	etat NOT IN ('ADIUNKT', 'ASYSTENT', 'STAZYSTA')
	AND	placa_pod NOT BETWEEN 400 AND 800
	ORDER BY stawka; 
	
--------------------------------------------------------
-- 14.  Wyświetl poniższe informacje o pracownikach, dla których suma płacy podstawowej i dodatkowej
--		jest wyższa niż 1000 złotych. Wyniki uporządkuj według nazw etatów. Jeżeli dwóch pracowników
--		ma ten sam etat, to posortuj ich według nazwisk.

	SELECT	nazwisko
		,etat
		,placa_pod
		,placa_dod
	FROM	pracownicy
	WHERE	placa_pod + NVL(placa_dod, 0) > 1000
	ORDER BY etat, nazwisko; 
			
--------------------------------------------------------		 
-- 15. Wyświetl poniższe informacje o profesorach, wyniki uporządkuj według malejących płac.

--
--	PROFESOROWIE
--	----------------------------------------------
--	BLAZEWICZ PRACUJE OD 01-05-1973 I ZARABIA 1350
--	SLOWINSKI PRACUJE OD 01-09-1977 I ZARABIA 1070
--	BRZEZINSKI PRACUJE OD 01-07-1968 I ZARABIA 960
--	MORZY PRACUJE OD 15-09-1975 I ZARABIA 830
--

	SELECT	nazwisko 
		|| ' PRACUJE OD ' 
		|| zatrudniony 
		|| ' I ZARABIA ' 
		|| placa_pod AS profesorowie
	FROM	pracownicy
	WHERE	etat = 'PROFESOR'
	ORDER BY placa_pod DESC;
	
	
