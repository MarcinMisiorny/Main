/*
* --------------------------------------------
* Rozdzia� 3b. Podzia� na grupy, klauzula GROUP BY -
* zadania
* --------------------------------------------
* 
* Plik z zadaniami: 03bFunkcjeGrupowe_zadania.pdf
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wy�wietl najni�sz� i najwy�sz� pensj� w firmie. Wy�wietl informacj� o r�nicy dziel�cej najlepiej i najgorzej
--    zarabiaj�cych pracownik�w.

	SELECT	MIN(placa_pod) AS minimum
			,MAX(placa_pod) AS maksimum
			,MAX(placa_pod) - MIN(placa_pod) AS r�nica
	FROM	pracownicy;
	
--------------------------------------------------------
-- 2. Wy�wietl �rednie pensje dla wszystkich etat�w. Wyniki uporz�dkuj wg malej�cej �redniej pensji.

	SELECT	etat
			,AVG(placa_pod) AS srednia_placa
	FROM	pracownicy
	GROUP BY etat
	ORDER BY AVG(placa_pod) DESC;
	
--------------------------------------------------------
-- 3. Wy�wietl liczb� profesor�w zatrudnionych w Instytucie

	SELECT	COUNT(etat) AS profesorowie
	FROM	pracownicy
	WHERE	etat = 'PROFESOR';
	
--------------------------------------------------------
-- 4. Znajd� sumaryczne miesi�czne p�ace dla ka�dego zespo�u. Nie zapomnij o p�acach dodatkowych.

	SELECT	id_zesp
			,SUM(placa_pod + NVL(placa_dod, 0)) AS sumaryczne_place
	FROM	pracownicy
	GROUP BY id_zesp; 
	
--------------------------------------------------------
-- 5. Zmodyfikuj zapytanie z zadania poprzedniego w taki spos�b, aby jego wynikiem by�a sumaryczna miesi�czna p�aca w
--    zespole, kt�ry wyp�aca swoim pracownikom najwi�cej pieni�dzy.

	SELECT	MAX(SUM(placa_pod + NVL(placa_dod, 0))) AS maksymalna_sumaryczna_placa
	FROM	pracownicy
	GROUP BY id_zesp;
	
--------------------------------------------------------
-- 6. Dla ka�dego pracownika wy�wietl pensj� najgorzej zarabiaj�cego podw�adnego. Wyniki uporz�dkuj wg malej�cej

	SELECT	id_szefa
			,MIN(placa_pod) AS minimalna
	FROM	pracownicy
	GROUP BY id_szefa;
	
--------------------------------------------------------
-- 7. Wy�wietl numery zespo��w wraz z liczb� pracownik�w w ka�dym zespole. Wyniki uporz�dkuj wg malej�cej liczby

	SELECT	id_zesp
			,COUNT(id_zesp) AS ilu_pracuje
	FROM	pracownicy
	GROUP BY id_zesp
	ORDER BY ilu_pracuje DESC;
	
--------------------------------------------------------
-- 8. Zmodyfikuj zapytanie z zadania poprzedniego, aby wy�wietli� numery tylko tych zespo��w, kt�re zatrudniaj� wi�cej
--	  ni� 3 pracownik�w.

	SELECT	id_zesp
			,COUNT(id_zesp) AS ilu_pracuje
	FROM	pracownicy
	GROUP BY id_zesp
	HAVING COUNT(id_zesp) > 3
	ORDER BY ilu_pracuje DESC;
	
--------------------------------------------------------
-- 9. Sprawd�, czy identyfikatory pracownik�w s� unikalne. Wy�wietl zdublowane warto�ci identyfikator�w.

	SELECT	id_prac
	FROM	pracownicy
	GROUP BY id_prac
	HAVING COUNT(*) > 1;
	
--------------------------------------------------------
-- 10. Wy�wietl �rednie pensje wyp�acane w ramach poszczeg�lnych etat�w i liczb� zatrudnionych na danym etacie. Pomi�
--	   pracownik�w zatrudnionych po 1990 roku.

	SELECT	etat
			,AVG(placa_pod) AS srednia
			,COUNT(*) AS liczba
	FROM	pracownicy
	WHERE	zatrudniony <= '1990-01-01'
	GROUP BY etat;
	
--------------------------------------------------------
-- 11. Zbuduj zapytanie, kt�re wy�wietli �rednie i maksymalne pensje asystent�w i profesor�w w poszczeg�lnych zespo�ach
--	   (we� pod uwag� zar�wno p�ace podstawowe jak i dodatkowe). Dokonaj zaokr�glenia pensji do warto�ci ca�kowitych.
--	   Wynik zapytania posortuj wg identyfikator�w zespo��w i nazw etat�w.

	SELECT	id_zesp
			,etat
			,ROUND(AVG(placa_pod + NVL(placa_dod, 0)), 0) AS �rednia
			,ROUND(MAX(placa_pod + NVL(placa_dod, 0)), 0) AS maksymalna
	FROM	pracownicy
	WHERE	etat IN ('ASYSTENT', 'PROFESOR')
	GROUP BY id_zesp, etat
	ORDER BY id_zesp, etat;
	
--------------------------------------------------------		 
-- 12. Zbuduj zapytanie, kt�re wy�wietli, ilu pracownik�w zosta�o zatrudnionych w poszczeg�lnych latach. Wynik posortuj
--	   rosn�co ze wzgl�du na rok zatrudnienia.

	SELECT	EXTRACT (YEAR FROM zatrudniony) AS rok
			,COUNT(*) AS ilu_pracownik�w
	FROM	pracownicy
	GROUP BY EXTRACT (YEAR FROM zatrudniony)
	ORDER BY rok ASC;
	
--------------------------------------------------------
-- 13. Zbuduj zapytanie, kt�re policzy liczb� liter w nazwiskach pracownik�w i wy�wietli liczb� nazwisk z dan� liczb� liter.
--	   Wynik zapytania posortuj rosn�co wg liczby liter w nazwiskach.

	SELECT	LENGTH(nazwisko) AS ile_liter
			,COUNT(*) AS w_ilu_nazwiskach
	FROM	pracownicy
	GROUP BY LENGTH (nazwisko)
	ORDER BY ile_liter;
	
--------------------------------------------------------
-- 14. Zbuduj zapytanie, kt�re wyliczy, ilu pracownik�w w swoim nazwisku posiada chocia� jedn� liter� �a� lub �A�, a ilu
--	   chocia� jedn� liter� �e� lub �E�.

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

