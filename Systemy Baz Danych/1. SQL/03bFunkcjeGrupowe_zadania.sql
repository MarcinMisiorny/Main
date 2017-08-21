/*
* --------------------------------------------
* Rozdzia³ 3b. Podzia³ na grupy, klauzula GROUP BY -
* zadania
* --------------------------------------------
* 
* Plik z zadaniami: 03bFunkcjeGrupowe_zadania.pdf
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wyœwietl najni¿sz¹ i najwy¿sz¹ pensjê w firmie. Wyœwietl informacjê o ró¿nicy dziel¹cej najlepiej i najgorzej
--    zarabiaj¹cych pracowników.

	SELECT	MIN(placa_pod) AS minimum
			,MAX(placa_pod) AS maksimum
			,MAX(placa_pod) - MIN(placa_pod) AS ró¿nica
	FROM	pracownicy;
	
--------------------------------------------------------
-- 2. Wyœwietl œrednie pensje dla wszystkich etatów. Wyniki uporz¹dkuj wg malej¹cej œredniej pensji.

	SELECT	etat
			,AVG(placa_pod) AS srednia_placa
	FROM	pracownicy
	GROUP BY etat
	ORDER BY AVG(placa_pod) DESC;
	
--------------------------------------------------------
-- 3. Wyœwietl liczbê profesorów zatrudnionych w Instytucie

	SELECT	COUNT(etat) AS profesorowie
	FROM	pracownicy
	WHERE	etat = 'PROFESOR';
	
--------------------------------------------------------
-- 4. ZnajdŸ sumaryczne miesiêczne p³ace dla ka¿dego zespo³u. Nie zapomnij o p³acach dodatkowych.

	SELECT	id_zesp
			,SUM(placa_pod + NVL(placa_dod, 0)) AS sumaryczne_place
	FROM	pracownicy
	GROUP BY id_zesp; 
	
--------------------------------------------------------
-- 5. Zmodyfikuj zapytanie z zadania poprzedniego w taki sposób, aby jego wynikiem by³a sumaryczna miesiêczna p³aca w
--    zespole, który wyp³aca swoim pracownikom najwiêcej pieniêdzy.

	SELECT	MAX(SUM(placa_pod + NVL(placa_dod, 0))) AS maksymalna_sumaryczna_placa
	FROM	pracownicy
	GROUP BY id_zesp;
	
--------------------------------------------------------
-- 6. Dla ka¿dego pracownika wyœwietl pensjê najgorzej zarabiaj¹cego podw³adnego. Wyniki uporz¹dkuj wg malej¹cej

	SELECT	id_szefa
			,MIN(placa_pod) AS minimalna
	FROM	pracownicy
	GROUP BY id_szefa;
	
--------------------------------------------------------
-- 7. Wyœwietl numery zespo³ów wraz z liczb¹ pracowników w ka¿dym zespole. Wyniki uporz¹dkuj wg malej¹cej liczby

	SELECT	id_zesp
			,COUNT(id_zesp) AS ilu_pracuje
	FROM	pracownicy
	GROUP BY id_zesp
	ORDER BY ilu_pracuje DESC;
	
--------------------------------------------------------
-- 8. Zmodyfikuj zapytanie z zadania poprzedniego, aby wyœwietliæ numery tylko tych zespo³ów, które zatrudniaj¹ wiêcej
--	  ni¿ 3 pracowników.

	SELECT	id_zesp
			,COUNT(id_zesp) AS ilu_pracuje
	FROM	pracownicy
	GROUP BY id_zesp
	HAVING COUNT(id_zesp) > 3
	ORDER BY ilu_pracuje DESC;
	
--------------------------------------------------------
-- 9. SprawdŸ, czy identyfikatory pracowników s¹ unikalne. Wyœwietl zdublowane wartoœci identyfikatorów.

	SELECT	id_prac
	FROM	pracownicy
	GROUP BY id_prac
	HAVING COUNT(*) > 1;
	
--------------------------------------------------------
-- 10. Wyœwietl œrednie pensje wyp³acane w ramach poszczególnych etatów i liczbê zatrudnionych na danym etacie. Pomiñ
--	   pracowników zatrudnionych po 1990 roku.

	SELECT	etat
			,AVG(placa_pod) AS srednia
			,COUNT(*) AS liczba
	FROM	pracownicy
	WHERE	zatrudniony <= '1990-01-01'
	GROUP BY etat;
	
--------------------------------------------------------
-- 11. Zbuduj zapytanie, które wyœwietli œrednie i maksymalne pensje asystentów i profesorów w poszczególnych zespo³ach
--	   (weŸ pod uwagê zarówno p³ace podstawowe jak i dodatkowe). Dokonaj zaokr¹glenia pensji do wartoœci ca³kowitych.
--	   Wynik zapytania posortuj wg identyfikatorów zespo³ów i nazw etatów.

	SELECT	id_zesp
			,etat
			,ROUND(AVG(placa_pod + NVL(placa_dod, 0)), 0) AS œrednia
			,ROUND(MAX(placa_pod + NVL(placa_dod, 0)), 0) AS maksymalna
	FROM	pracownicy
	WHERE	etat IN ('ASYSTENT', 'PROFESOR')
	GROUP BY id_zesp, etat
	ORDER BY id_zesp, etat;
	
--------------------------------------------------------		 
-- 12. Zbuduj zapytanie, które wyœwietli, ilu pracowników zosta³o zatrudnionych w poszczególnych latach. Wynik posortuj
--	   rosn¹co ze wzglêdu na rok zatrudnienia.

	SELECT	EXTRACT (YEAR FROM zatrudniony) AS rok
			,COUNT(*) AS ilu_pracowników
	FROM	pracownicy
	GROUP BY EXTRACT (YEAR FROM zatrudniony)
	ORDER BY rok ASC;
	
--------------------------------------------------------
-- 13. Zbuduj zapytanie, które policzy liczbê liter w nazwiskach pracowników i wyœwietli liczbê nazwisk z dan¹ liczb¹ liter.
--	   Wynik zapytania posortuj rosn¹co wg liczby liter w nazwiskach.

	SELECT	LENGTH(nazwisko) AS ile_liter
			,COUNT(*) AS w_ilu_nazwiskach
	FROM	pracownicy
	GROUP BY LENGTH (nazwisko)
	ORDER BY ile_liter;
	
--------------------------------------------------------
-- 14. Zbuduj zapytanie, które wyliczy, ilu pracowników w swoim nazwisku posiada chocia¿ jedn¹ literê „a” lub „A”, a ilu
--	   chocia¿ jedn¹ literê „e” lub „E”.

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

