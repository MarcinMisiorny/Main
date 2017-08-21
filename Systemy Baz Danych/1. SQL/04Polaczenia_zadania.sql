/*
* --------------------------------------------
* Rozdzia³ 4. Po³¹czenia – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 04Polaczenia_zadania.pdf
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wyœwietl nazwiska, etaty, numery zespo³ów i nazwy zespo³ów wszystkich pracowników.

	SELECT	p.nazwisko
			,p.etat
			,p.id_zesp
			,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp); 

--------------------------------------------------------
-- 2. Wyœwietl wszystkich pracowników z ul. Piotrowo 3a. Uporz¹dkuj wyniki wed³ug nazwisk pracowników.

	SELECT	p.nazwisko
			,p.etat
			,p.id_zesp
			,z.adres
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	z.adres LIKE 'PIOTROWO%'
	ORDER BY p.nazwisko;

--------------------------------------------------------
-- 3. Wyœwietl nazwiska, miejsca pracy oraz nazwy zespo³ów tych pracowników, których miesiêczna pensja

	SELECT	p.nazwisko
			,z.adres
			,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	p.placa_pod > 400; 

--------------------------------------------------------
-- 4. Dla ka¿dego pracownika wyœwietl jego kategoriê p³acow¹ i wide³ki p³acowe w jakich mieœci siê pensja

	SELECT	p.nazwisko
			,p.placa_pod
			,e.nazwa AS kat_plac
			,e.placa_min
			,e.placa_max
	FROM	pracownicy p
	JOIN	etaty e ON (p.placa_pod BETWEEN e.placa_min AND e.placa_max)
	ORDER BY e.placa_min ASC; 

--------------------------------------------------------
-- 5. Wyœwietl nazwiska i etaty pracowników, których rzeczywiste zarobki odpowiadaj¹ wide³kom p³acowym

	SELECT	p.nazwisko
			,p.etat
			,p.placa_pod
			,e.nazwa
			,e.placa_min
			,e.placa_max
	FROM	pracownicy p
	JOIN	etaty e ON (p.placa_pod BETWEEN e.placa_min AND e.placa_max)
	WHERE	e.nazwa = 'SEKRETARKA'
	ORDER BY e.placa_min ASC; 

--------------------------------------------------------
-- 6. Wyœwietl nazwiska, etaty, wynagrodzenia, kategorie p³acowe i nazwy zespo³ów pracowników nie bêd¹cych
--	  asystentami. Wyniki uszereguj zgodnie z malej¹cym wynagrodzeniem.

	SELECT	p.nazwisko
			,p.etat
			,p.placa_pod
			,e.nazwa
			,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	JOIN	etaty e ON (p.placa_pod BETWEEN e.placa_min AND e.placa_max)
	WHERE	p.etat != 'ASYSTENT'
	ORDER BY p.placa_pod DESC; 

--------------------------------------------------------
-- 7. Wyœwietl poni¿sze informacje o tych pracownikach, którzy s¹ asystentami lub adiunktami i których roczne
--    dochody przekraczaj¹ 5500. Roczne dochody to dwunastokrotnoœæ p³acy podstawowej powiêkszona o
--    ewentualn¹ p³acê dodatkow¹. Ostatni atrybut to nazwa kategorii p³acowej pracownika.

	SELECT	p.nazwisko
			p.etat
			p.placa_pod * 12 + NVL(placa_dod, 0) AS roczna_placa,
			z.nazwa,
			e.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	JOIN	etaty e ON (p.etat = e.nazwa)
	WHERE	p.placa_pod * 12 + NVL(placa_dod, 0) > 5500
	AND		p.etat IN ('ASYSTENT', 'ADIUNKT')
	ORDER BY roczna_placa DESC; 

--------------------------------------------------------
-- 8. Wyœwietl nazwiska i numery pracowników wraz z numerami i nazwiskami ich szefów.

	SELECT	p.id_prac
			,p.nazwisko
			,s.id_prac
			,s.nazwisko
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	ORDER BY p.id_prac ASC; 

--------------------------------------------------------
-- 9. Zmodyfikuj powy¿sze zlecenie w ten sposób, aby by³o mo¿liwe wyœwietlenie pracownika WEGLARZ
--    (który nie ma szefa).

	SELECT	p.id_prac
			,p.nazwisko
			,s.id_prac
			,s.nazwisko
	FROM	pracownicy p
	LEFT JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	ORDER BY p.id_prac ASC; 

--------------------------------------------------------
-- 10. Dla ka¿dego zespo³u wyœwietl liczbê zatrudnionych w nim pracowników i ich œredni¹ p³acê.

	SELECT	z.nazwa
			,COUNT(p.id_prac) AS liczba
			,NVL(AVG(p.placa_pod), 0) AS œrednia
	FROM	zespoly z
	LEFT JOIN	pracownicy p ON (p.id_zesp = z.id_zesp)
	GROUP BY z.nazwa
	ORDER BY z.nazwa; 

--------------------------------------------------------
-- 11. Dla ka¿dego pracownika posiadaj¹cego podw³adnych wyœwietl ich liczbê. Wyniki posortuj zgodnie z

	SELECT	s.nazwisko
			,COUNT(*) AS liczba
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	GROUP BY s.nazwisko
	ORDER BY COUNT(*) DESC; 

--------------------------------------------------------
-- 12. Wyœwietl nazwiska i daty zatrudnienia pracowników, którzy zostali zatrudnieni nie póŸniej ni¿ 10 lat (3650
--	   dni) po swoich prze³o¿onych.

	SELECT	 p.nazwisko
			,p.zatrudniony
			,s.nazwisko
			,s.zatrudniony
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.zatrudniony < s.zatrudniony + 3650)
	AND		p.id_szefa = s.id_prac; 
	
--------------------------------------------------------
-- 13. Wyœwietl nazwy etatów, na które przyjêto pracowników zarówno w 1992 jak i 1993 roku.

	SELECT	etat
	FROM	pracownicy
	WHERE	EXTRACT(YEAR FROM zatrudniony) = '1992' 
	INTERSECT
	SELECT	etat
	FROM	pracownicy WHERE EXTRACT(YEAR FROM zatrudniony) = '1993';
								
--------------------------------------------------------
-- 14. Wyœwietl numer zespo³u który nie zatrudnia ¿adnych pracowników.

	SELECT	id_zesp
	FROM	zespoly 
	MINUS
	SELECT	p.id_zesp
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp);
	
--------------------------------------------------------
-- 15. Wyœwietl poni¿szy raport.

-- 
-- NAZWISKO			PLACA_POD	PROG
-- --------------- ---------	---------------------
-- ZAKRZEWICZ		208			Poni¿ej 480 z³otych
-- BIALY			250			Poni¿ej 480 z³otych
-- MATYSIAK			371			Poni¿ej 480 z³otych
-- MAREK			410,2		Poni¿ej 480 z³otych
-- JEZIERSKI		439,7		Poni¿ej 480 z³otych
-- HAPKE			480			Dokladnie 480 z³otych
-- KONOPKA			480			Dokladnie 480 z³otych
-- KOSZLAJDA		590			Powy¿ej 480 z³otych
-- KROLIKOWSKI		645,5		Powy¿ej 480 z³otych
-- MORZY			830			Powy¿ej 480 z³otych
-- BRZEZINSKI		960			Powy¿ej 480 z³otych
-- SLOWINSKI		1070		Powy¿ej 480 z³otych
-- BLAZEWICZ		1350		Powy¿ej 480 z³otych
-- WEGLARZ			1730		Powy¿ej 480 z³otych
-- 
	
	SELECT	nazwisko
			,placa_pod
			,'Powy¿ej 480 zotych' AS prog
	FROM	pracownicy
	WHERE	placa_pod > 480
	UNION
	SELECT	nazwisko
			,placa_pod
			,'Dokadnie 480 zotych' AS prog
	FROM	pracownicy
	WHERE	placa_pod = 480
	UNION
	SELECT	nazwisko
			,placa_pod
			,'Poni¿ej 480 zotych' AS prog
	FROM	pracownicy
	WHERE	placa_pod < 480
	ORDER BY placa_pod;
	
	