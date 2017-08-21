/*
* --------------------------------------------
* Rozdział 4. Połączenia – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 04Polaczenia_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wyświetl nazwiska, etaty, numery zespołów i nazwy zespołów wszystkich pracowników.

	SELECT	p.nazwisko
		,p.etat
		,p.id_zesp
		,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp); 

--------------------------------------------------------
-- 2. Wyświetl wszystkich pracowników z ul. Piotrowo 3a. Uporządkuj wyniki według nazwisk pracowników.

	SELECT	p.nazwisko
		,p.etat
		,p.id_zesp
		,z.adres
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	z.adres LIKE 'PIOTROWO%'
	ORDER BY p.nazwisko;

--------------------------------------------------------
-- 3. Wyświetl nazwiska, miejsca pracy oraz nazwy zespołów tych pracowników, których miesięczna pensja

	SELECT	p.nazwisko
		,z.adres
		,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	p.placa_pod > 400; 

--------------------------------------------------------
-- 4. Dla każdego pracownika wyświetl jego kategorię płacową i widełki płacowe w jakich mieści się pensja

	SELECT	p.nazwisko
		,p.placa_pod
		,e.nazwa AS kat_plac
		,e.placa_min
		,e.placa_max
	FROM	pracownicy p
	JOIN	etaty e ON (p.placa_pod BETWEEN e.placa_min AND e.placa_max)
	ORDER BY e.placa_min ASC; 

--------------------------------------------------------
-- 5. Wyświetl nazwiska i etaty pracowników, których rzeczywiste zarobki odpowiadają widełkom płacowym

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
-- 6. Wyświetl nazwiska, etaty, wynagrodzenia, kategorie płacowe i nazwy zespołów pracowników nie będących
--	  asystentami. Wyniki uszereguj zgodnie z malejącym wynagrodzeniem.

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
-- 7. Wyświetl poniższe informacje o tych pracownikach, którzy są asystentami lub adiunktami i których roczne
--    dochody przekraczają 5500. Roczne dochody to dwunastokrotność płacy podstawowej powiększona o
--    ewentualną płacę dodatkową. Ostatni atrybut to nazwa kategorii płacowej pracownika.

	SELECT	p.nazwisko
		p.etat
		p.placa_pod * 12 + NVL(placa_dod, 0) AS roczna_placa,
		z.nazwa,
		e.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	JOIN	etaty e ON (p.etat = e.nazwa)
	WHERE	p.placa_pod * 12 + NVL(placa_dod, 0) > 5500
	AND	p.etat IN ('ASYSTENT', 'ADIUNKT')
	ORDER BY roczna_placa DESC; 

--------------------------------------------------------
-- 8. Wyświetl nazwiska i numery pracowników wraz z numerami i nazwiskami ich szefów.

	SELECT	p.id_prac
		,p.nazwisko
		,s.id_prac
		,s.nazwisko
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	ORDER BY p.id_prac ASC; 

--------------------------------------------------------
-- 9. Zmodyfikuj powyższe zlecenie w ten sposób, aby było możliwe wyświetlenie pracownika WEGLARZ
--    (który nie ma szefa).

	SELECT	p.id_prac
		,p.nazwisko
		,s.id_prac
		,s.nazwisko
	FROM	pracownicy p
	LEFT JOIN  pracownicy s ON (p.id_szefa = s.id_prac)
	ORDER BY p.id_prac ASC; 

--------------------------------------------------------
-- 10. Dla każdego zespołu wyświetl liczbę zatrudnionych w nim pracowników i ich średnią płacę.

	SELECT	z.nazwa
		,COUNT(p.id_prac) AS liczba
		,NVL(AVG(p.placa_pod), 0) AS średnia
	FROM	zespoly z
	LEFT JOIN  pracownicy p ON (p.id_zesp = z.id_zesp)
	GROUP BY z.nazwa
	ORDER BY z.nazwa; 

--------------------------------------------------------
-- 11. Dla każdego pracownika posiadającego podwładnych wyświetl ich liczbę. Wyniki posortuj zgodnie z

	SELECT	s.nazwisko
		,COUNT(*) AS liczba
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.id_szefa = s.id_prac)
	GROUP BY s.nazwisko
	ORDER BY COUNT(*) DESC; 

--------------------------------------------------------
-- 12. Wyświetl nazwiska i daty zatrudnienia pracowników, którzy zostali zatrudnieni nie później niż 10 lat (3650
--	   dni) po swoich przełożonych.

	SELECT	 p.nazwisko
		,p.zatrudniony
		,s.nazwisko
		,s.zatrudniony
	FROM	pracownicy p
	JOIN	pracownicy s ON (p.zatrudniony < s.zatrudniony + 3650)
	AND	p.id_szefa = s.id_prac; 
	
--------------------------------------------------------
-- 13. Wyświetl nazwy etatów, na które przyjęto pracowników zarówno w 1992 jak i 1993 roku.

	SELECT	etat
	FROM	pracownicy
	WHERE	EXTRACT(YEAR FROM zatrudniony) = '1992' 
	INTERSECT
	SELECT	etat
	FROM	pracownicy WHERE EXTRACT(YEAR FROM zatrudniony) = '1993';
								
--------------------------------------------------------
-- 14. Wyświetl numer zespołu który nie zatrudnia żadnych pracowników.

	SELECT	id_zesp
	FROM	zespoly 
	MINUS
	SELECT	p.id_zesp
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp);
	
--------------------------------------------------------
-- 15. Wyświetl poniższy raport.

-- 
-- NAZWISKO	   PLACA_POD	PROG
-- --------------- ---------	---------------------
-- ZAKRZEWICZ	   208		Poniżej 480 złotych
-- BIALY	   250		Poniżej 480 złotych
-- MATYSIAK	   371		Poniżej 480 złotych
-- MAREK	   410,2	Poniżej 480 złotych
-- JEZIERSKI	   439,7	Poniżej 480 złotych
-- HAPKE	   480		Dokladnie 480 złotych
-- KONOPKA	   480		Dokladnie 480 złotych
-- KOSZLAJDA	   590		Powyżej 480 złotych
-- KROLIKOWSKI	   645,5	Powyżej 480 złotych
-- MORZY	   830		Powyżej 480 złotych
-- BRZEZINSKI	   960		Powyżej 480 złotych
-- SLOWINSKI	   1070		Powyżej 480 złotych
-- BLAZEWICZ	   1350		Powyżej 480 złotych
-- WEGLARZ	   1730		Powyżej 480 złotych
-- 
	
	SELECT	nazwisko
		,placa_pod
		,'Powyżej 480 zotych' AS prog
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
		,'Poniżej 480 zotych' AS prog
	FROM	pracownicy
	WHERE	placa_pod < 480
	ORDER BY placa_pod;
	
	
