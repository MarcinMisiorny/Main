/*
* --------------------------------------------
* Rozdział 5. Rozszerzenie grupowania
* --------------------------------------------
* 
* Plik z zadaniami: 07_Rozszerzenia_grupowania_cw.pdf
* 
* Pliki tworzące bazę do ćwiczeń: rozszerzenia_init.sql
* 
*/

--------------------------------------------------------
-- 1. Zbuduj zapytanie, które utworzy kostkę o wymiarach KATEGORIA i ROK. 
--    Komórki kostki zawierają łączne ilości sprzedaży produktów danej kategorii w danym dniu. 

	SELECT	p1.kategoria
		,p2.rok
		,SUM(p2.ilosc_sprzed) AS sprzedano
	FROM	produkty p1
	JOIN	produkcja p2 ON (p1.produkt_id = p2.produkt_id)
	GROUP BY CUBE(p1.kategoria, p2.rok);

--------------------------------------------------------
-- 2. Zbuduj zapytanie wyliczające sumy ilości sprzedaży produktów w poszczególnych kategorii w poszczególnych miesiącach. 
--    Wynik ma zawierać podsumowania sprzedaży w poszczególnych kategoriach i podsumowanie całości.

	SELECT	p1.kategoria
		,p2.miesiac
		,p2.rok
		,SUM(p2.ilosc_sprzed) AS sprzedano
	FROM	produkty p1
	JOIN	produkcja p2 ON (p1.produkt_id = p2.produkt_id)
	GROUP BY ROLLUP(p1.kategoria, p2.miesiac, p2.rok);

--------------------------------------------------------
-- 3. Rozszerz poprzednie zapytanie, tak aby uzyskać poniższy wynik.

	SELECT	p1.kategoria
		,p2.miesiac
		,p2.rok
		,SUM(p2.ilosc_sprzed) AS sprzedano
		,GROUPING(p1.kategoria) AS sum_kat
		,GROUPING(p2.miesiac) AS sum_mies
		,GROUPING(p2.rok) AS sum_all
	FROM	produkty p1
	JOIN	produkcja p2 ON (p1.produkt_id = p2.produkt_id)
	GROUP BY GROUPING SETS((p1.kategoria, p2.miesiac, p2.rok), (p2.rok, p2.miesiac), (p2.rok), ());

--------------------------------------------------------
-- 4. Zbuduj zapytanie, które będzie zawierało: (1) sumy ilości sprzedaży produktów w 
--    poszczególnych latach, (2) sumy ilości sprzedaży poszczególnych kategorii, (3) łączną sumę produkcji.

	SELECT	p1.nazwa
		,p1.kategoria
		,p2.rok
		,SUM(p2.ilosc_sprzed) AS "SUM(ILOSC_SPRZED)"
	FROM	produkty p1
	JOIN	produkcja p2 ON (p1.produkt_id = p2.produkt_id)
	GROUP BY GROUPING SETS((p1.nazwa, p2.rok), (p1.kategoria, p2.rok), ())
	ORDER BY p1.nazwa, p2.rok;

--------------------------------------------------------
-- 5. Zmodyfikuj poprzednie zapytanie tak, aby zamiast pustych kolumn pojawiał się tekst "Dowolna"/"Dowolny".

	SELECT	DECODE(GROUPING(p1.nazwa), 0, p1.nazwa, 'Dowolna') AS nazwa
		,DECODE(GROUPING(p1.kategoria), 0, p1.kategoria, 'Dowolna') AS kategoria
		,DECODE(GROUPING(p2.rok), 0, TO_CHAR(p2.rok), 'Dowolny') AS rok
		,SUM(p2.ilosc_sprzed) AS "SUM(ILOSC_SPRZED)"
	FROM	produkty p1
	JOIN	produkcja p2 ON (p1.produkt_id = p2.produkt_id)
	GROUP BY GROUPING SETS((p1.nazwa, p2.rok), (p1.kategoria, p2.rok), ())
	ORDER BY p1.nazwa, p2.rok;

