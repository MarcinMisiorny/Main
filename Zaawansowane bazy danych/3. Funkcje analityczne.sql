/*
* --------------------------------------------
* Rozdział 3. Funkcje analityczne
* --------------------------------------------
* 
* Plik z zadaniami: ZSBD_cw_03.pdf
* 
* Pliki tworzące bazę do ćwiczeń: spbd_funkcje.dmp, spbd_funkcje.sql
* 
*/

--------------------------------------------------------
-- 1. Wyświetl ranking (rzadki i gęsty) kwot transakcji dla konta '11-11111111' 
--	  z podziałem na kategorie operacji. 

	SELECT	RANK() OVER (PARTITION BY kategoria ORDER BY kwota DESC)
			,RANK
			,DENSE_RANK() OVER (PARTITION BY kategoria ORDER BY kwota DESC) AS dense_rank
			,kategoria
			,data
			,kwota 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	ORDER BY kategoria, kwota DESC; 

--------------------------------------------------------
-- 2. Wyświetl percentyle oraz pozycje procentowe rankingu wpłat pensji na konto '11-11111111' 

	SELECT	CUME_DIST() OVER (ORDER BY kwota) AS cume_dist
			,PERCENT_RANK() OVER (ORDER BY kwota) AS percent_rank
			,kwota 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	AND		kategoria = 'PENSJA' 
	ORDER BY kwota; 

--------------------------------------------------------
-- 3. Wyświetl podział wpłat i wypłat związanych z pensją i rachunkiem za telefon na cztery grupy w 
-- 	  zależności od wysokości wpłaty/wypłaty. 

	SELECT	NTILE(4) OVER (ORDER BY kwota) AS ntile 
			,ROW_NUMBER() OVER (ORDER BY kwota) AS row_number 
			,kwota
			,data
			,kategoria 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	AND		kategoria IN ('PENSJA','RACHUNEK ZA TELEFON')
	ORDER BY kwota; 

--------------------------------------------------------
-- 4. Znajdź trzy najwyższe wpłaty 

	SELECT	najwyzsze_wyplaty.kwota
			,najwyzsze_wyplaty.data
			,najwyzsze_wyplaty.nr_konta 
	FROM	(SELECT	kwota
					,data
					,nr_konta
					,RANK() OVER (ORDER BY kwota DESC) AS ranking 
			FROM	transakcje) najwyzsze_wyplaty 
	WHERE najwyzsze_wyplaty.ranking <= 3;

--------------------------------------------------------
-- 5. Dla każdej transakcji przedstaw jej datę, kwotę na jaką opiewała oraz saldo po 
--	  wykonaniu operacji, średnią kwotę operacji z ostatniego roku, minimalną kwotę z 3 ostatnich 
--	  operacji, oraz liczbę operacji wykonanych od 6 miesięcy wstecz do 6 miesięcy po transakcji. 
--	  Zapytanie ogranicz do konta nr '11-11111111' 

	SELECT	kwota
			,data
			,SUM(kwota) OVER (ORDER BY data) saldo
			,AVG(kwota) OVER (ORDER BY data RANGE INTERVAL '12' MONTH PRECEDING) AS avg12
			,MIN(kwota) OVER (ORDER BY data rows 3 PRECEDING) AS min3
			,COUNT(*) OVER (ORDER BY data RANGE BETWEEN	INTERVAL '6' MONTH PRECEDING 
							AND INTERVAL '6' MONTH FOLLOWING) AS count6_6 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	ORDER BY data; 

--------------------------------------------------------
-- 6. Dla każdej transakcji przedstaw jej kwotę, datę i kategorię, oraz średnią kwotę operacji 
--	  wchodzących w skład tej samej kategorii i udział kwoty transakcji do wszystkich transakcji z tej 
--	  samej kategorii. Zapytanie ogranicz do konta nr '11-11111111' 

	SELECT	kwota
			,data
			,kategoria
			,AVG(kwota) OVER (PARTITION BY kategoria) AS avg_k
			,kwota/SUM(kwota) OVER (PARTITION BY kategoria) AS ratio_to_report 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	ORDER BY kategoria, data; 

--------------------------------------------------------
-- 7. Wyświetl salda kroczące dla konta nr '11-11111111'. Wykorzystaj funkcję LEAD do znalezienia 
--	  daty następnej operacji na koncie (w wyniku której zmieni się saldo) 

	SELECT	kwota
			,SUM(kwota) OVER (ORDER BY data) AS saldo
			,data AS od_dnia
			,LEAD(data,1) OVER (ORDER BY data) AS do_dnia
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	ORDER BY data; 

--------------------------------------------------------
-- 8. Dla każdego roku wyświetl kwotę i datę największego przychodu. 

	SELECT	TO_CHAR(data,'YYYY') AS rok
			,MAX(kwota) AS przychod
			,MAX(data) KEEP (DENSE_RANK LAST ORDER BY kwota) AS dzien 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	GROUP BY TO_CHAR(data,'YYYY'); 

--------------------------------------------------------
-- 9. Dla każdego roku wyświetl medianę wartości kwotowej transakcji na koncie nr '11-11111111' 

	SELECT	TO_CHAR(data,'YYYY') AS rok
			,PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY kwota) AS disc
			,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY kwota) AS cont 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	GROUP BY TO_CHAR(data,'YYYY'); 

--------------------------------------------------------
-- 10. Sprawdź, w którym miejscu w rankingu znalazłaby się wpłata 3000 zł.
 
	SELECT	RANK(3000) WITHIN GROUP (ORDER BY SUM(kwota) DESC) AS gdzie_3000 
	FROM	transakcje 
	GROUP BY nr_konta, TO_CHAR(data,'YYYY'); 

--------------------------------------------------------
-- 11. Porównaj efektywność znalezienia trzech największych transakcji za pomocą funkcji 
--	   analitycznej i za pomocą tradycyjnego podzapytania SQL 

SET AUTOTRACE ON EXPLAIN;
	
	SELECT	rank.kwota
			,rank.data
			,rank.nr_konta 
	FROM 	(SELECT	kwota
					,data
					,nr_konta
					,RANK() OVER (ORDER BY kwota DESC) AS ranking 
			 FROM	transakcje) rank
	WHERE	rank.ranking <= 3; 
		
	Plan hash value: 1702447718
	
	---------------------------------------------------------------------------------------
	| Id  | Operation                | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
	---------------------------------------------------------------------------------------
	|   0 | SELECT STATEMENT         |            |    48 |  2496 |     4  (25)| 00:00:01 |
	|*  1 |  VIEW                    |            |    48 |  2496 |     4  (25)| 00:00:01 |
	|*  2 |   WINDOW SORT PUSHED RANK|            |    48 |  1200 |     4  (25)| 00:00:01 |
	|   3 |    TABLE ACCESS FULL     | TRANSAKCJE |    48 |  1200 |     3   (0)| 00:00:01 |
	---------------------------------------------------------------------------------------
	
	Predicate Information (identified by operation id):
	---------------------------------------------------
	
	1 - filter("RANK"."RANKING"<=3)
	2 - filter(RANK() OVER ( ORDER BY INTERNAL_FUNCTION("KWOTA") DESC )<=3)
 
	----------------------------------------------------------------------------------------------------------
 
 	SELECT	kwota
			,data
			,nr_konta 
	FROM	transakcje T1 
	WHERE	3 >= (SELECT	COUNT(*) 
				  FROM		transakcje 
				  WHERE		kwota >= T1.kwota); 
  
	Plan hash value: 742604707
	
	----------------------------------------------------------------------------------
	| Id  | Operation           | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
	----------------------------------------------------------------------------------
	|   0 | SELECT STATEMENT    |            |     1 |    25 |    75   (0)| 00:00:01 |
	|*  1 |  FILTER             |            |       |       |            |          |
	|   2 |   TABLE ACCESS FULL | TRANSAKCJE |    48 |  1200 |     3   (0)| 00:00:01 |
	|   3 |   SORT AGGREGATE    |            |     1 |     5 |            |          |
	|*  4 |    TABLE ACCESS FULL| TRANSAKCJE |     2 |    10 |     3   (0)| 00:00:01 |
	----------------------------------------------------------------------------------
	
	Predicate Information (identified by operation id):
	---------------------------------------------------
	
	1 - filter( (SELECT COUNT(*) FROM "TRANSAKCJE" "TRANSAKCJE" WHERE 
				"KWOTA">=:B1)<=3)
	4 - filter("KWOTA">=:B1)
	
--------------------------------------------------------
--------------------------------------------------------
-- 1. Dla każdego konta wyświetl saldo na rachunku i miejsce w rankingu kont ustalonego 
--	 w oparciu o wielkość salda 

	SELECT	nr_konta
			,SUM (kwota) AS saldo
			,RANK() OVER (ORDER BY SUM(kwota) DESC)
	FROM	transakcje 
	GROUP BY nr_konta;

--------------------------------------------------------
-- 2. Dla konta 11-11111111 podziel wszystkie transakcje na cztery równe części pod 
--	 względem czasu wykonania. Czy wyniki są niedeterministyczne? 

	SELECT	NTILE(4) OVER (ORDER BY data) AS ntile, 
			,kwota
			,data
			,kategoria 
	FROM	transakcje 
	WHERE	nr_konta = '11-11111111' 
	ORDER BY ntile, data, kwota; 

--------------------------------------------------------
-- 3. Dla każdego z kont znajdź najwcześniej wykonaną transakcję.

	SELECT	najwczesniejsza_transakcja.*
	FROM	(SELECT nr_konta
					,data
					,kwota
					,RANK() OVER (PARTITION BY nr_konta ORDER BY data ASC) AS ranking
			FROM	transakcje) najwczesniejsza_transakcja
	WHERE	najwczesniejsza_transakcja.ranking = 1;
	
--------------------------------------------------------
-- 4. Dla każdego z kont znajdź rok, w którym wykonano największą liczbę transakcji 

	SELECT	najwiecej_transakcji.nr_konta
			,najwiecej_transakcji.rok
			,najwiecej_transakcji.ranking
	FROM	(SELECT	nr_konta
					,EXTRACT(YEAR FROM data) AS rok
					,COUNT(*) AS liczba_transakcji
					,RANK() OVER (PARTITION BY nr_konta ORDER BY COUNT(*) DESC) AS ranking
			FROM	transakcje 
			GROUP BY nr_konta, EXTRACT(YEAR FROM data)
			ORDER BY liczba_transakcji DESC) najwiecej_transakcji
	WHERE	najwiecej_transakcji.ranking = 1
	ORDER BY najwiecej_transakcji.nr_konta;

--------------------------------------------------------
-- 5. Dla każdej transakcji przedstaw datę, kwotę na jaką opiewała, oraz średnią kwotę z 
--	  transakcji bankowych mających miejsce co najwyżej 6 miesięcy wcześniej. Czy był taki 
--	  moment, w którym średnia ta była ujemna? 
	
	SELECT  data
			,kwota
			,ROUND(AVG(kwota) OVER (ORDER BY data RANGE INTERVAL '6' MONTH PRECEDING), 2) AS srednia
	FROM transakcje
	ORDER BY data ASC, kwota DESC;

	--Tak, np. 98/03/22; -170

--------------------------------------------------------
-- 6. Dla każdej transakcji przedstaw datę, kwotę na jaką opiewała i stan bankowego 
--	  skarbca w momencie jej zaksięgowania. Czy kiedykolwiek stan ten był ujemny? Jaki 
--	  był stan na koniec dnia 99/12/24? 

	SELECT  data
			,kwota
			,SUM(kwota) OVER (ORDER BY data) AS stan
	FROM  transakcje
	ORDER BY data ASC, kwota DESC;

	-- Stan skarbca nigdy nie był ujemny.
	-- Stan na koniec dnia 99/12/24 to 13859.

--------------------------------------------------------
-- 7. Dla każdego konta znajdź transakcje, które doprowadziły do stanu debetowego. 
--	  Podaj numer konta, datę transakcji, kwotę na jaką opiewała oraz saldo rachunku po transakcji. 

	SELECT  *
	FROM (SELECT  nr_konta
				  ,data
				  ,kwota
				  ,SUM(kwota) OVER (ORDER BY data) AS stan
		 FROM	  transakcje
		 ORDER BY data ASC, kwota DESC) transakcje
	WHERE transakcje.stan < 0;

--------------------------------------------------------
-- 8. Dla każdego konta wyświetl daty i kwoty wynikające z transakcji o kategorii PENSJA. 
--	  Dla każdej transakcji podaj kwotę, o jaką różni się kwota transakcji od średniej pensji 
--	  zaksięgowanej na tym koncie. 

	SELECT  nr_konta
			,data
			,kwota
			,kwota - AVG(kwota) OVER (PARTITION BY nr_konta ORDER BY data ROWS BETWEEN UNBOUNDED PRECEDING 
									  AND UNBOUNDED FOLLOWING) AS roznica
	FROM  transakcje
	WHERE kategoria = 'PENSJA'
	ORDER BY nr_konta, data;

--------------------------------------------------------
-- 9. Dla każdego roku podaj rok, sumę kwot zaksięgowanych w danym roku, oraz różnicę 
--	  pomiędzy sumą kwot zaksięgowanych w roku bieżącym a sumą kwot zaksięgowanych w roku wcześniejszym. 

	SELECT	EXTRACT(YEAR FROM data) AS rok
			,SUM(kwota) AS rok_biezacy
			,SUM(kwota) - LAG(SUM(kwota), 1) OVER (ORDER BY EXTRACT(YEAR FROM data)) AS roznica 
	FROM	transakcje
	GROUP BY EXTRACT(YEAR FROM data);

--------------------------------------------------------
-- 10. Gdyby w jakimś roku suma kwot zaksięgowanych osiągnęła 3000, to który z kolei 
--	   byłby to rok w rankingu lat pod względem sumy zaksięgowanych kwot? 

	SELECT	RANK(3000) WITHIN GROUP (ORDER BY SUM(kwota) DESC) AS ktory 
	FROM	transakcje 
	GROUP BY EXTRACT(YEAR FROM data); 


--------------------------------------------------------
-- 11. Czy potrafiłbyś napisać zapytanie będące odpowiednikiem zadania pierwszego bez 
-- 	   użycia funkcji analitycznych? Jeśli tak, to porównaj liczbę operacji I/O (consistent 
-- 	   gets) konieczną do wykonania obu wariantów rozwiązań dla tego samego zadania. 

	-- zapytanie
	SELECT	* 
	FROM (SELECT	transakcje.*
					,ROWNUM FROM (SELECT	nr_konta
											,SUM(kwota) AS suma
								  FROM		transakcje
								  GROUP BY nr_konta
								  ORDER BY suma DESC) transakcje)
	ORDER BY nr_konta;
	
	-- plan wykonania zapytania dla zadania pierwszego
	Plan hash value: 3720525757
 
	----------------------------------------------------------------------------------
	| Id  | Operation           | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
	----------------------------------------------------------------------------------
	|   0 | SELECT STATEMENT    |            |     3 |    51 |     5  (40)| 00:00:01 |
	|   1 |  WINDOW SORT        |            |     3 |    51 |     5  (40)| 00:00:01 |
	|   2 |   HASH GROUP BY     |            |     3 |    51 |     5  (40)| 00:00:01 |
	|   3 |    TABLE ACCESS FULL| TRANSAKCJE |    48 |   816 |     3   (0)| 00:00:01 |
	----------------------------------------------------------------------------------
	
	--plan wykonania zapytania dla tradycyjnego zapytania, bez funkcji analitycznych
	Plan hash value: 4156883275
	
	--------------------------------------------------------------------------------------
	| Id  | Operation               | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
	--------------------------------------------------------------------------------------
	|   0 | SELECT STATEMENT        |            |     3 |   129 |     6  (50)| 00:00:01 |
	|   1 |  SORT ORDER BY          |            |     3 |   129 |     6  (50)| 00:00:01 |
	|   2 |   VIEW                  |            |     3 |   129 |     5  (40)| 00:00:01 |
	|   3 |    COUNT                |            |       |       |            |          |
	|   4 |     VIEW                |            |     3 |    90 |     5  (40)| 00:00:01 |
	|   5 |      SORT ORDER BY      |            |     3 |    51 |     5  (40)| 00:00:01 |
	|   6 |       HASH GROUP BY     |            |     3 |    51 |     5  (40)| 00:00:01 |
	|   7 |        TABLE ACCESS FULL| TRANSAKCJE |    48 |   816 |     3   (0)| 00:00:01 |
	--------------------------------------------------------------------------------------
	
	-- Wniosek: 
	-- zapytania tradycyjne są bardziej kosztowne niż zapytania wykorzystujące funkcje analityczne
	
