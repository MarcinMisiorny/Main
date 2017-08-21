/*
* --------------------------------------------
* Rozdział 3b. Podział na grupy, klauzula GROUP BY -
* zadania
* --------------------------------------------
* 
* Plik z zadaniami: 03bFunkcjeGrupowe_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wyświetl najniższą i najwyższą pensję w firmie. Wyświetl informację o różnicy dzielącej najlepiej i najgorzej
--    zarabiających pracowników.

	SELECT	MIN(placa_pod) AS minimum
		,MAX(placa_pod) AS maksimum
		,MAX(placa_pod) - MIN(placa_pod) AS różnica
	FROM	pracownicy;
	
--------------------------------------------------------
-- 2. Wyświetl średnie pensje dla wszystkich etatów. Wyniki uporządkuj wg malejącej średniej pensji.

	SELECT	etat
		,AVG(placa_pod) AS srednia_placa
	FROM	pracownicy
	GROUP BY etat
	ORDER BY AVG(placa_pod) DESC;
	
--------------------------------------------------------
-- 3. Wyświetl liczbę profesorów zatrudnionych w Instytucie

	SELECT	COUNT(etat) AS profesorowie
	FROM	pracownicy
	WHERE	etat = 'PROFESOR';
	
--------------------------------------------------------
-- 4. Znajdź sumaryczne miesięczne płace dla każdego zespołu. Nie zapomnij o płacach dodatkowych.

	SELECT	id_zesp
		,SUM(placa_pod + NVL(placa_dod, 0)) AS sumaryczne_place
	FROM	pracownicy
	GROUP BY id_zesp; 
	
--------------------------------------------------------
-- 5. Zmodyfikuj zapytanie z zadania poprzedniego w taki sposób, aby jego wynikiem była sumaryczna miesięczna płaca w
--    zespole, który wypłaca swoim pracownikom najwięcej pieniędzy.

	SELECT	MAX(SUM(placa_pod + NVL(placa_dod, 0))) AS maksymalna_sumaryczna_placa
	FROM	pracownicy
	GROUP BY id_zesp;
	
--------------------------------------------------------
-- 6. Dla każdego pracownika wyświetl pensję najgorzej zarabiającego podwładnego. Wyniki uporządkuj wg malejącej

	SELECT	id_szefa
		,MIN(placa_pod) AS minimalna
	FROM	pracownicy
	GROUP BY id_szefa;
	
--------------------------------------------------------
-- 7. Wyświetl numery zespołów wraz z liczbą pracowników w każdym zespole. Wyniki uporządkuj wg malejącej liczby

	SELECT	id_zesp
		,COUNT(id_zesp) AS ilu_pracuje
	FROM	pracownicy
	GROUP BY id_zesp
	ORDER BY ilu_pracuje DESC;
	
--------------------------------------------------------
-- 8. Zmodyfikuj zapytanie z zadania poprzedniego, aby wyświetlić numery tylko tych zespołów, które zatrudniają więcej
--	  niż 3 pracowników.

	SELECT	id_zesp
		,COUNT(id_zesp) AS ilu_pracuje
	FROM	pracownicy
	GROUP BY id_zesp
	HAVING COUNT(id_zesp) > 3
	ORDER BY ilu_pracuje DESC;
	
--------------------------------------------------------
-- 9. Sprawdź, czy identyfikatory pracowników są unikalne. Wyświetl zdublowane wartości identyfikatorów.

	SELECT	id_prac
	FROM	pracownicy
	GROUP BY id_prac
	HAVING COUNT(*) > 1;
	
--------------------------------------------------------
-- 10. Wyświetl średnie pensje wypłacane w ramach poszczególnych etatów i liczbę zatrudnionych na danym etacie. Pomiń
--	   pracowników zatrudnionych po 1990 roku.

	SELECT	etat
		,AVG(placa_pod) AS srednia
		,COUNT(*) AS liczba
	FROM	pracownicy
	WHERE	zatrudniony <= '1990-01-01'
	GROUP BY etat;
	
--------------------------------------------------------
-- 11. Zbuduj zapytanie, które wyświetli średnie i maksymalne pensje asystentów i profesorów w poszczególnych zespołach
--	   (weź pod uwagę zarówno płace podstawowe jak i dodatkowe). Dokonaj zaokrąglenia pensji do wartości całkowitych.
--	   Wynik zapytania posortuj wg identyfikatorów zespołów i nazw etatów.

	SELECT	id_zesp
		,etat
		,ROUND(AVG(placa_pod + NVL(placa_dod, 0)), 0) AS średnia
		,ROUND(MAX(placa_pod + NVL(placa_dod, 0)), 0) AS maksymalna
	FROM	pracownicy
	WHERE	etat IN ('ASYSTENT', 'PROFESOR')
	GROUP BY id_zesp, etat
	ORDER BY id_zesp, etat;
	
--------------------------------------------------------		 
-- 12. Zbuduj zapytanie, które wyświetli, ilu pracowników zostało zatrudnionych w poszczególnych latach. Wynik posortuj
--	   rosnąco ze względu na rok zatrudnienia.

	SELECT	EXTRACT (YEAR FROM zatrudniony) AS rok
		,COUNT(*) AS ilu_pracowników
	FROM	pracownicy
	GROUP BY EXTRACT (YEAR FROM zatrudniony)
	ORDER BY rok ASC;
	
--------------------------------------------------------
-- 13. Zbuduj zapytanie, które policzy liczbę liter w nazwiskach pracowników i wyświetli liczbę nazwisk z daną liczbą liter.
--	   Wynik zapytania posortuj rosnąco wg liczby liter w nazwiskach.

	SELECT	LENGTH(nazwisko) AS ile_liter
		,COUNT(*) AS w_ilu_nazwiskach
	FROM	pracownicy
	GROUP BY LENGTH (nazwisko)
	ORDER BY ile_liter;
	
--------------------------------------------------------
-- 14. Zbuduj zapytanie, które wyliczy, ilu pracowników w swoim nazwisku posiada chociaż jedną literę „a” lub „A”, a ilu
--	   chociaż jedną literę „e” lub „E”.

	SELECT	COUNT(CASE
			WHEN INSTR(nazwisko,'A') > 0
				OR INSTR(nazwisko,'a') > 0 
			THEN 1
			ELSE NULL
			END) AS ile_nazwisk_z_a
		,COUNT(CASE
			WHEN INSTR(nazwisko,'E') > 0
				OR INSTR(nazwisko,'e') > 0 
			THEN 1
			ELSE NULL
			END) AS ile_nazwisk_z_e
	FROM	pracownicy;

