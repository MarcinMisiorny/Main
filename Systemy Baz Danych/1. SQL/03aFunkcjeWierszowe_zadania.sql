/*
* --------------------------------------------
* Rozdział 3a. Funkcje znakowe i liczbowe,
* konwersja, funkcje działające na datach
* i funkcje polimorficzne – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 03aFunkcjeWierszowe_zadania.pdf
* 
* Plik tworzący bazę do ćwiczeń: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Dla każdego pracownika wygeneruj kod składający się z dwóch pierwszych liter jego etatu i jego numeru

	SELECT	nazwisko,
	SUBSTR(etat, 1, 2) 
	|| id_prac AS kod
	FROM	pracownicy;

--------------------------------------------------------
-- 2. Wydaj wojnę literom „K”, „L”, „M” zamieniając je wszystkie na literę „X” w nazwiskach pracowników

	SELECT	nazwisko,
	TRANSLATE(nazwisko, 'KLM', 'XXX') AS wojna_literom
	FROM	pracownicy; 

--------------------------------------------------------
-- 3. Wyświetl nazwiska pracowników którzy posiadają literę „L” w pierwszej połowie swojego nazwiska.

	SELECT	nazwisko
	FROM	pracownicy
	WHERE	INSTR(nazwisko, 'L') BETWEEN 1 AND (LENGTH(nazwisko)) / 2; 

--------------------------------------------------------
-- 4. Wyświetl nazwiska i płace pracowników powiększone o 15% i zaokrąglone do liczb całkowitych

	SELECT	nazwisko
		,ROUND(placa_pod * 1.15) AS podwyzka
	FROM	pracownicy; 

--------------------------------------------------------  
-- 5. Każdy pracownik odłożył 20% swoich miesięcznych zarobków na 10-letnią lokatę oprocentowaną 10% w skali roku i
--    kapitalizowaną co roku. Wyświetl informację o tym, jaki zysk będzie miał każdy pracownik po zamknięciu lokaty.

	SELECT	nazwisko
		,placa_pod
		,placa_pod * 0.2 AS inwestycja
		,placa_pod * 0.2 * POWER(1.1, 10) AS kapital
		,placa_pod * 0.2 * POWER(1.1, 10) - placa_pod * 0.2 AS zysk
	FROM	pracownicy; 
	
--------------------------------------------------------  
-- 6. Policz, jaki staż miał każdy pracownik 1 stycznia 2000 roku.

	SELECT	nazwisko
		,zatrudniony
		,ROUND((DATE '2000-01-01' - zatrudniony) / 365) AS staz_w_2000
	FROM	pracownicy; 

--------------------------------------------------------  
-- 7. Wyświetl poniższe informacje o datach przyjęcia pracowników zespołu 20

	SELECT	nazwisko
		,TO_CHAR(zatrudniony, 'MONTH'
		||' ,'
		||' DD'
		||' YYYY') AS data_zatrudnienia
	FROM	pracownicy 
	WHERE	id_zesp = 20; 

--------------------------------------------------------  
-- 8. Sprawdź, jaki mamy dziś dzień tygodnia

	SELECT	TO_CHAR(SYSDATE, 'day') AS dzis
	FROM	dual; 

--------------------------------------------------------	
-- 9. Przyjmij, że Mielżyńskiego i Strzelecka należą do dzielnicy Stare Miasto, Piotrowo należy do dzielnicy Nowe Miasto a
--    Włodkowica należy do dzielnicy Grunwald. Wyświetl poniższy raport (skorzystaj z wyrażenia CASE)

	SELECT	nazwa
		,adres
		,CASE
			WHEN adres LIKE 'PIOTROWO%' THEN 'NOWE MIASTO'
			WHEN adres LIKE 'WLODKOWICA%' THEN 'GRUNWALD'
			ELSE 'STARE MIASTO'
		END AS dzielnica
	FROM	zespoly; 

--------------------------------------------------------
-- 10. Dla każdego pracownika wyświetl informację o tym, czy jego pensja jest mniejsza niż, równa lub większa niż 480

	SELECT	nazwisko
		,placa_pod
		,CASE
			WHEN placa_pod < 480 THEN 'Poniżej 480'
			WHEN placa_pod = 480 THEN 'Dokładnie 480'
			ELSE 'Powyżej 480'
		END AS próg
	FROM	pracownicy
	ORDER BY placa_pod DESC;
	
--------------------------------------------------------	
-- 11. (dla chętnych) Napisz to samo zapytanie przy pomocy funkcji DECODE

	SELECT	nazwisko
		,placa_pod
		,DECODE(SIGN(placa_pod / 480 - 1) + 1
		,0
		,'Poniżej 480'
		,1
		,'Dokładnie 480'
		,'Powyżej 480') AS próg
	FROM	pracownicy
	ORDER BY placa_pod DESC;

