/*
* --------------------------------------------
* Rozdział 5. Podzapytania – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 05Podzapytania_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Wyświetl nazwiska i etaty pracowników pracujących w tym samym zespole co pracownik o nazwisku Brzeziński.

	SELECT	nazwisko
		,etat
		,id_zesp
	FROM	pracownicy
	WHERE	id_zesp = (SELECT  id_zesp
			   FROM	   pracownicy
			   WHERE   nazwisko = 'BRZEZINSKI'); 
		
--------------------------------------------------------	 
-- 2. Wyświetl poniższe dane o najdłużej zatrudnionym profesorze.

	SELECT	nazwisko
		,etat
		,zatrudniony
	FROM	pracownicy 
	WHERE	zatrudniony = (SELECT  MIN(zatrudniony)
			       FROM    pracownicy); 
	 
--------------------------------------------------------	 
-- 3. Wyświetl najkrócej pracujących pracowników każdego zespołu. Uszereguj wyniki zgodnie z kolejnością zatrudnienia.

	SELECT	nazwisko
		,zatrudniony
		,id_zesp
	FROM	pracownicy 
	WHERE	(zatrudniony, id_zesp) IN (SELECT  MAX(zatrudniony)
						   ,id_zesp
					   FROM	   pracownicy
					   GROUP BY id_zesp)
	ORDER BY zatrudniony ASC; 

--------------------------------------------------------
-- 4. Wyświetl zespoły, które nie zatrudniają pracowników.

	SELECT	id_zesp
		,nazwa
		,adres
	FROM	zespoly
	WHERE	id_zesp NOT IN (SELECT	DISTINCT id_zesp
				FROM	pracownicy);
		
--------------------------------------------------------	 
-- 5. Wyświetl poniższe informacje o pracownikach zarabiających więcej niż średnia pensja dla ich etatu.

	SELECT	p.nazwisko
		,p.placa_pod
		,p.etat
	FROM	pracownicy p WHERE placa_pod > (SELECT	AVG(placa_pod)
						FROM	pracownicy
						WHERE	etat = p.etat); 
	 
--------------------------------------------------------	 
-- 6. Wyświetl nazwiska i pensje pracowników którzy zarabiają co najmniej 75% pensji swojego szefa.

	SELECT	p.nazwisko
		,p.placa_pod
	FROM	pracownicy p 
	WHERE	placa_pod > 0.75 * (SELECT  placa_pod
				    FROM    pracownicy
				    WHERE   id_prac = p.id_szefa); 
	 
--------------------------------------------------------	 
-- 7. Wyświetl nazwiska tych profesorów, którzy wśród swoich podwładnych nie mają żadnych stażystów.

	SELECT	p.nazwisko
	FROM	pracownicy p 
	WHERE	etat = 'PROFESOR'
	AND	p.id_prac != ALL (SELECT  id_szefa
				  FROM	  pracownicy
				  WHERE	  etat = 'STAZYSTA');
	
--------------------------------------------------------	 
-- 8. Stosując podzapytanie skorelowane wyświetl informacje o zespole nie zatrudniającym żadnych pracowników.

	SELECT	z.id_zesp
		,z.nazwa
		,z.adres
	FROM	zespoly z WHERE z.id_zesp NOT IN (SELECT  id_zesp
						  FROM	  pracownicy
						  WHERE	  z.id_zesp = id_zesp);
	 
--------------------------------------------------------	 
-- 9. Wyświetl numer zespołu wypłacającego miesięcznie swoim pracownikom najwięcej pieniędzy.

	SELECT	p.id_zesp
		,SUM(p.placa_pod) AS suma
	FROM	pracownicy p
	GROUP BY p.id_zesp
	HAVING SUM(p.placa_pod) = (SELECT  MAX(SUM(placa_pod))
				   FROM	   pracownicy
				   GROUP BY id_zesp); 
   
--------------------------------------------------------  
-- 10. Wyświetl nazwiska i pensje trzech najlepiej zarabiających pracowników. Zastosuj podzapytanie.
	
	SELECT	p.nazwisko
		,p.placa_pod
	FROM	pracownicy p
	WHERE	(SELECT  COUNT(*)
		 FROM	 pracownicy
		 WHERE	 placa_pod > p.placa_pod) < 3;
	 
--------------------------------------------------------	 
-- 11. Wyświetl dla każdego roku liczbę zatrudnionych w nim pracowników. Wynik uporządkuj zgodnie z liczbą zatrudnionych.

	SELECT	EXTRACT (YEAR FROM p.zatrudniony) AS rok
		,COUNT(*) AS liczba
	FROM	pracownicy p
	GROUP BY EXTRACT (YEAR FROM zatrudniony)
	ORDER BY liczba DESC; 
	
--------------------------------------------------------
-- 12. Zmodyfikuj powyższe zapytanie w ten sposób, aby wyświetlać tylko rok, w którym przyjęto najwięcej pracowników.
	
	SELECT	EXTRACT (YEAR FROM p.zatrudniony) AS rok
		,COUNT(*) AS liczba
	FROM	pracownicy p
	HAVING	COUNT(*) = (SELECT  MAX(COUNT(*))
			    FROM    pracownicy
			    GROUP BY EXTRACT (YEAR FROM zatrudniony))
	GROUP BY EXTRACT (YEAR FROM zatrudniony);
	
--------------------------------------------------------
-- 13. Wyświetl poniższe informacje o tych pracownikach, którzy zarabiają mniej niż średnia płaca dla ich etatu.

	SELECT	p.nazwisko
		,p.etat
		,p.placa_pod
		,z.nazwa
	FROM	pracownicy p
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	WHERE	placa_pod < (SELECT  AVG(placa_pod)
			     FROM    pracownicy
			     WHERE   etat = p.etat); 
	 
--------------------------------------------------------	 
-- 14. Zmodyfikuj powyższe zapytanie w ten sposób, aby zamiast nazwy zespołu wyświetlać średnią płacę dla
--     danego etatu.
	
	SELECT	p.nazwisko
		,p.etat
		,p.placa_pod
		,z.srednia_placa_w_zespole
	FROM	(SELECT	etat
			,AVG(placa_pod) AS srednia_placa_w_zespole
		FROM	pracownicy z
		GROUP BY  etat) z
	JOIN	pracownicy p ON (p.etat = z.etat) 
	WHERE	p.placa_pod < srednia_placa_w_zespole
	ORDER BY p.etat;
	

	--dodatkowe przykłady pokazujące średnią dla etatu i średnią dla zespołu pracownika, dwa sposoby
	
	SELECT	p.nazwisko
		,p.etat
		,p.placa_pod
		,z.srednia_zespolowa
		,e.srednia_etatowa
	FROM	(SELECT	id_zesp
			,AVG(p.placa_pod) AS srednia_zespolowa
		 FROM	pracownicy p
		 GROUP BY p.id_zesp) z
	JOIN	pracownicy p ON (p.id_zesp = z.id_zesp)
	JOIN	(SELECT	etat
			,AVG(p.placa_pod) AS srednia_etatowa
		 FROM	pracownicy p
		 GROUP BY p.etat) e ON (p.etat = e.etat);
	
	---
	
	SELECT	nazwisko
		,etat
		,placa_pod
		,(SELECT  AVG(placa_pod)
		  FROM	  pracownicy
		  WHERE	  id_zesp = p.id_zesp) AS srednia_zespolowa
		,(SELECT  AVG(placa_pod)
		  FROM	  pracownicy
		  WHERE   etat = p.etat) AS srednia_etatowa
	FROM pracownicy p; 

--------------------------------------------------------
-- 15. Wyświetl nazwiska profesorów i liczbę ich podwładnych. Wyświetl tylko profesorów zatrudnionych na
--     Piotrowie.

	SELECT	nazwisko
		,(SELECT  COUNT(*)
		  FROM	  pracownicy
		  WHERE	  id_szefa = p.id_prac) AS podwladni
	FROM	pracownicy p
	NATURAL JOIN zespoly
	WHERE	etat = 'PROFESOR'
	AND	adres LIKE 'PIOTROWO%'
	ORDER BY podwladni DESC; 

--------------------------------------------------------
-- 16. Dla każdego profesora wyświetl jego nazwisko, średnią płacą w jego zespole i największą płacę w
--     Instytucie. Zastosuj podzapytanie w klauzuli SELECT.

	SELECT	nazwisko
		,(SELECT  AVG(placa_pod)
		  FROM	  pracownicy
		  WHERE	  id_zesp = p.id_zesp) AS srednia
		,(SELECT  MAX(placa_pod)
		  FROM	  pracownicy) AS maksymalna
		  FROM	  pracownicy p
	WHERE   etat = 'PROFESOR'; 
	
--------------------------------------------------------
-- 17. Dla każdego pracownika wyświetl jego nazwisko oraz nazwę zespołu w którym pracuje dany pracownik.
--     Posłuż się podzapytaniem w klauzuli SELECT.

	SELECT	nazwisko
		,(SELECT  nazwa
		  FROM	  zespoly
		  WHERE	  id_zesp = p.id_zesp) AS zespol
	FROM	pracownicy p; 
  
 -------------------------------------------------------- 
-- 18. Wyświetl informacje o asystentach pracujących na Piotrowie. Klauzula FROM powinno wyglądać
--     następująco: FROM ASYSTENCI NATURAL JOIN PIOTROWO. Zastosuj klauzulę WITH.
 
	WITH asystenci AS
		(SELECT	 *
		 FROM	 pracownicy
		 WHERE	 etat = 'ASYSTENT')
		,piotrowo AS
		(SELECT	 *
		 FROM	 zespoly
		 WHERE	 adres = 'PIOTROWO 3A')
	SELECT	nazwisko
		,etat
		,nazwa
		,adres
	FROM	asystenci
	NATURAL JOIN piotrowo; 
  
--------------------------------------------------------  
-- 19. Wyświetl poniższe informacje o wszystkich (pośrednich i bezpośrednich) podwładnych Brzezińskiego.

	SELECT	nazwisko
		,id_prac
		,id_szefa
		,LEVEL
	FROM	pracownicy CONNECT BY PRIOR id_prac = id_szefa
	START WITH nazwisko = 'BRZEZINSKI';

