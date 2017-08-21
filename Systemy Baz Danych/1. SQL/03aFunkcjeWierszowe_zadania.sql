/*
* --------------------------------------------
* Rozdzia� 3a. Funkcje znakowe i liczbowe,
* konwersja, funkcje dzia�aj�ce na datach
* i funkcje polimorficzne � zadania
* --------------------------------------------
* 
* Plik z zadaniami: 03aFunkcjeWierszowe_zadania.pdf
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Dla ka�dego pracownika wygeneruj kod sk�adaj�cy si� z dw�ch pierwszych liter jego etatu i jego numeru

	SELECT	nazwisko,
			SUBSTR(etat, 1, 2) 
			|| id_prac AS kod
	FROM	pracownicy;

--------------------------------------------------------
-- 2. Wydaj wojn� literom �K�, �L�, �M� zamieniaj�c je wszystkie na liter� �X� w nazwiskach pracownik�w

	SELECT	nazwisko,
			TRANSLATE(nazwisko, 'KLM', 'XXX') AS wojna_literom
	FROM	pracownicy; 

--------------------------------------------------------
-- 3. Wy�wietl nazwiska pracownik�w kt�rzy posiadaj� liter� �L� w pierwszej po�owie swojego nazwiska.

	SELECT	nazwisko
	FROM	pracownicy
	WHERE	INSTR(nazwisko, 'L') BETWEEN 1 AND (LENGTH(nazwisko)) / 2; 

--------------------------------------------------------
-- 4. Wy�wietl nazwiska i p�ace pracownik�w powi�kszone o 15% i zaokr�glone do liczb ca�kowitych

	SELECT	nazwisko
			,ROUND(placa_pod * 1.15) AS podwyzka
	FROM	pracownicy; 

--------------------------------------------------------  
-- 5. Ka�dy pracownik od�o�y� 20% swoich miesi�cznych zarobk�w na 10-letni� lokat� oprocentowan� 10% w skali roku i
--    kapitalizowan� co roku. Wy�wietl informacj� o tym, jaki zysk b�dzie mia� ka�dy pracownik po zamkni�ciu lokaty.

	SELECT	nazwisko
			,placa_pod
			,placa_pod * 0.2 AS inwestycja
			,placa_pod * 0.2 * POWER(1.1, 10) AS kapital
			,placa_pod * 0.2 * POWER(1.1, 10) - placa_pod * 0.2 AS zysk
	FROM	pracownicy; 
	
--------------------------------------------------------  
-- 6. Policz, jaki sta� mia� ka�dy pracownik 1 stycznia 2000 roku.

	SELECT	nazwisko
			,zatrudniony
			,ROUND((DATE '2000-01-01' - zatrudniony) / 365) AS staz_w_2000
	FROM	pracownicy; 

--------------------------------------------------------  
-- 7. Wy�wietl poni�sze informacje o datach przyj�cia pracownik�w zespo�u 20

	SELECT	nazwisko
			,TO_CHAR(zatrudniony, 'MONTH'
			||' ,'
			||' DD'
			||' YYYY') AS data_zatrudnienia
	FROM	pracownicy 
	WHERE	id_zesp = 20; 

--------------------------------------------------------  
-- 8. Sprawd�, jaki mamy dzi� dzie� tygodnia

	SELECT	TO_CHAR(SYSDATE, 'day') AS dzis
	FROM	dual; 

--------------------------------------------------------	
-- 9. Przyjmij, �e Miel�y�skiego i Strzelecka nale�� do dzielnicy Stare Miasto, Piotrowo nale�y do dzielnicy Nowe Miasto a
--    W�odkowica nale�y do dzielnicy Grunwald. Wy�wietl poni�szy raport (skorzystaj z wyra�enia CASE)

	SELECT	nazwa
			,adres
			,CASE
				WHEN adres LIKE 'PIOTROWO%' THEN 'NOWE MIASTO'
				WHEN adres LIKE 'WLODKOWICA%' THEN 'GRUNWALD'
				ELSE 'STARE MIASTO'
			END AS dzielnica
	FROM	zespoly; 

--------------------------------------------------------
-- 10. Dla ka�dego pracownika wy�wietl informacj� o tym, czy jego pensja jest mniejsza ni�, r�wna lub wi�ksza ni� 480

	SELECT	nazwisko
			,placa_pod
			,CASE
				WHEN placa_pod < 480 THEN 'Poni�ej 480'
				WHEN placa_pod = 480 THEN 'Dok�adnie 480'
				ELSE 'Powy�ej 480'
			END AS pr�g
	FROM	pracownicy
	ORDER BY placa_pod DESC;
	
--------------------------------------------------------	
-- 11. (dla ch�tnych) Napisz to samo zapytanie przy pomocy funkcji DECODE

	SELECT	nazwisko
			,placa_pod
			,DECODE(SIGN(placa_pod / 480 - 1) + 1
			,0
			,'Poni�ej 480'
			,1
			,'Dok�adnie 480'
			,'Powy�ej 480') AS pr�g
	FROM	pracownicy
	ORDER BY placa_pod DESC;

