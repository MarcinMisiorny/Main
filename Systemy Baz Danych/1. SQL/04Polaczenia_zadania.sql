/*
* --------------------------------------------
* Rozdzia� 4. Po��czenia � zadania
* --------------------------------------------
* 
* Plik z zadaniami: 04Polaczenia_zadania.pdf
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wy�wietl nazwiska, etaty, numery zespo��w i nazwy zespo��w wszystkich pracownik�w.

	SELECT	p.nazwisko
			,p.etat
			,p.id_zesp
			,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp); 

--------------------------------------------------------
-- 2. Wy�wietl wszystkich pracownik�w z ul. Piotrowo 3a. Uporz�dkuj wyniki wed�ug nazwisk pracownik�w.

	SELECT	p.nazwisko
			,p.etat
			,p.id_zesp
			,z.adres
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	z.adres LIKE 'PIOTROWO%'
	ORDER BY p.nazwisko;

--------------------------------------------------------
-- 3. Wy�wietl nazwiska, miejsca pracy oraz nazwy zespo��w tych pracownik�w, kt�rych miesi�czna pensja

	SELECT	p.nazwisko
			,z.adres
			,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	p.placa_pod > 400; 

--------------------------------------------------------
-- 4. Dla ka�dego pracownika wy�wietl jego kategori� p�acow� i wide�ki p�acowe w jakich mie�ci si� pensja

	SELECT	p.nazwisko
			,p.placa_pod
			,e.nazwa AS kat_plac
			,e.placa_min
			,e.placa_max
	FROM	pracownicy p
	JOIN	etaty e ON (p.placa_pod BETWEEN e.placa_min AND e.placa_max)
	ORDER BY e.placa_min ASC; 

--------------------------------------------------------
-- 5. Wy�wietl nazwiska i etaty pracownik�w, kt�rych rzeczywiste zarobki odpowiadaj� wide�kom p�acowym

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
-- 6. Wy�wietl nazwiska, etaty, wynagrodzenia, kategorie p�acowe i nazwy zespo��w pracownik�w nie b�d�cych
--	  asystentami. Wyniki uszereguj zgodnie z malej�cym wynagrodzeniem.

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
-- 7. Wy�wietl poni�sze informacje o tych pracownikach, kt�rzy s� asystentami lub adiunktami i kt�rych roczne
--    dochody przekraczaj� 5500. Roczne dochody to dwunastokrotno�� p�acy podstawowej powi�kszona o
--    ewentualn� p�ac� dodatkow�. Ostatni atrybut to nazwa kategorii p�acowej pracownika.

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
-- 8. Wy�wietl nazwiska i numery pracownik�w wraz z numerami i nazwiskami ich szef�w.

	SELECT	p.id_prac
			,p.nazwisko
			,s.id_prac
			,s.nazwisko
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	ORDER BY p.id_prac ASC; 

--------------------------------------------------------
-- 9. Zmodyfikuj powy�sze zlecenie w ten spos�b, aby by�o mo�liwe wy�wietlenie pracownika WEGLARZ
--    (kt�ry nie ma szefa).

	SELECT	p.id_prac
			,p.nazwisko
			,s.id_prac
			,s.nazwisko
	FROM	pracownicy p
	LEFT JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	ORDER BY p.id_prac ASC; 

--------------------------------------------------------
-- 10. Dla ka�dego zespo�u wy�wietl liczb� zatrudnionych w nim pracownik�w i ich �redni� p�ac�.

	SELECT	z.nazwa
			,COUNT(p.id_prac) AS liczba
			,NVL(AVG(p.placa_pod), 0) AS �rednia
	FROM	zespoly z
	LEFT JOIN	pracownicy p ON (p.id_zesp = z.id_zesp)
	GROUP BY z.nazwa
	ORDER BY z.nazwa; 

--------------------------------------------------------
-- 11. Dla ka�dego pracownika posiadaj�cego podw�adnych wy�wietl ich liczb�. Wyniki posortuj zgodnie z

	SELECT	s.nazwisko
			,COUNT(*) AS liczba
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	GROUP BY s.nazwisko
	ORDER BY COUNT(*) DESC; 

--------------------------------------------------------
-- 12. Wy�wietl nazwiska i daty zatrudnienia pracownik�w, kt�rzy zostali zatrudnieni nie p�niej ni� 10 lat (3650
--	   dni) po swoich prze�o�onych.

	SELECT	 p.nazwisko
			,p.zatrudniony
			,s.nazwisko
			,s.zatrudniony
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.zatrudniony < s.zatrudniony + 3650)
	AND		p.id_szefa = s.id_prac; 
	
--------------------------------------------------------
-- 13. Wy�wietl nazwy etat�w, na kt�re przyj�to pracownik�w zar�wno w 1992 jak i 1993 roku.

	SELECT	etat
	FROM	pracownicy
	WHERE	EXTRACT(YEAR FROM zatrudniony) = '1992' 
	INTERSECT
	SELECT	etat
	FROM	pracownicy WHERE EXTRACT(YEAR FROM zatrudniony) = '1993';
								
--------------------------------------------------------
-- 14. Wy�wietl numer zespo�u kt�ry nie zatrudnia �adnych pracownik�w.

	SELECT	id_zesp
	FROM	zespoly 
	MINUS
	SELECT	p.id_zesp
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp);
	
--------------------------------------------------------
-- 15. Wy�wietl poni�szy raport.

-- 
-- NAZWISKO			PLACA_POD	PROG
-- --------------- ---------	---------------------
-- ZAKRZEWICZ		208			Poni�ej 480 z�otych
-- BIALY			250			Poni�ej 480 z�otych
-- MATYSIAK			371			Poni�ej 480 z�otych
-- MAREK			410,2		Poni�ej 480 z�otych
-- JEZIERSKI		439,7		Poni�ej 480 z�otych
-- HAPKE			480			Dokladnie 480 z�otych
-- KONOPKA			480			Dokladnie 480 z�otych
-- KOSZLAJDA		590			Powy�ej 480 z�otych
-- KROLIKOWSKI		645,5		Powy�ej 480 z�otych
-- MORZY			830			Powy�ej 480 z�otych
-- BRZEZINSKI		960			Powy�ej 480 z�otych
-- SLOWINSKI		1070		Powy�ej 480 z�otych
-- BLAZEWICZ		1350		Powy�ej 480 z�otych
-- WEGLARZ			1730		Powy�ej 480 z�otych
-- 
	
	SELECT	nazwisko
			,placa_pod
			,'Powy�ej 480 zotych' AS prog
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
			,'Poni�ej 480 zotych' AS prog
	FROM	pracownicy
	WHERE	placa_pod < 480
	ORDER BY placa_pod;
	
	