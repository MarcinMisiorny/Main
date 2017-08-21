/*
* --------------------------------------------
* Rozdzia³ 3a. Funkcje znakowe i liczbowe,
* konwersja, funkcje dzia³aj¹ce na datach
* i funkcje polimorficzne – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 03aFunkcjeWierszowe_zadania.pdf
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
*/

--------------------------------------------------------
-- 1. Dla ka¿dego pracownika wygeneruj kod sk³adaj¹cy siê z dwóch pierwszych liter jego etatu i jego numeru

	SELECT	nazwisko,
			SUBSTR(etat, 1, 2) 
			|| id_prac AS kod
	FROM	pracownicy;

--------------------------------------------------------
-- 2. Wydaj wojnê literom „K”, „L”, „M” zamieniaj¹c je wszystkie na literê „X” w nazwiskach pracowników

	SELECT	nazwisko,
			TRANSLATE(nazwisko, 'KLM', 'XXX') AS wojna_literom
	FROM	pracownicy; 

--------------------------------------------------------
-- 3. Wyœwietl nazwiska pracowników którzy posiadaj¹ literê „L” w pierwszej po³owie swojego nazwiska.

	SELECT	nazwisko
	FROM	pracownicy
	WHERE	INSTR(nazwisko, 'L') BETWEEN 1 AND (LENGTH(nazwisko)) / 2; 

--------------------------------------------------------
-- 4. Wyœwietl nazwiska i p³ace pracowników powiêkszone o 15% i zaokr¹glone do liczb ca³kowitych

	SELECT	nazwisko
			,ROUND(placa_pod * 1.15) AS podwyzka
	FROM	pracownicy; 

--------------------------------------------------------  
-- 5. Ka¿dy pracownik od³o¿y³ 20% swoich miesiêcznych zarobków na 10-letni¹ lokatê oprocentowan¹ 10% w skali roku i
--    kapitalizowan¹ co roku. Wyœwietl informacjê o tym, jaki zysk bêdzie mia³ ka¿dy pracownik po zamkniêciu lokaty.

	SELECT	nazwisko
			,placa_pod
			,placa_pod * 0.2 AS inwestycja
			,placa_pod * 0.2 * POWER(1.1, 10) AS kapital
			,placa_pod * 0.2 * POWER(1.1, 10) - placa_pod * 0.2 AS zysk
	FROM	pracownicy; 
	
--------------------------------------------------------  
-- 6. Policz, jaki sta¿ mia³ ka¿dy pracownik 1 stycznia 2000 roku.

	SELECT	nazwisko
			,zatrudniony
			,ROUND((DATE '2000-01-01' - zatrudniony) / 365) AS staz_w_2000
	FROM	pracownicy; 

--------------------------------------------------------  
-- 7. Wyœwietl poni¿sze informacje o datach przyjêcia pracowników zespo³u 20

	SELECT	nazwisko
			,TO_CHAR(zatrudniony, 'MONTH'
			||' ,'
			||' DD'
			||' YYYY') AS data_zatrudnienia
	FROM	pracownicy 
	WHERE	id_zesp = 20; 

--------------------------------------------------------  
-- 8. SprawdŸ, jaki mamy dziœ dzieñ tygodnia

	SELECT	TO_CHAR(SYSDATE, 'day') AS dzis
	FROM	dual; 

--------------------------------------------------------	
-- 9. Przyjmij, ¿e Miel¿yñskiego i Strzelecka nale¿¹ do dzielnicy Stare Miasto, Piotrowo nale¿y do dzielnicy Nowe Miasto a
--    W³odkowica nale¿y do dzielnicy Grunwald. Wyœwietl poni¿szy raport (skorzystaj z wyra¿enia CASE)

	SELECT	nazwa
			,adres
			,CASE
				WHEN adres LIKE 'PIOTROWO%' THEN 'NOWE MIASTO'
				WHEN adres LIKE 'WLODKOWICA%' THEN 'GRUNWALD'
				ELSE 'STARE MIASTO'
			END AS dzielnica
	FROM	zespoly; 

--------------------------------------------------------
-- 10. Dla ka¿dego pracownika wyœwietl informacjê o tym, czy jego pensja jest mniejsza ni¿, równa lub wiêksza ni¿ 480

	SELECT	nazwisko
			,placa_pod
			,CASE
				WHEN placa_pod < 480 THEN 'Poni¿ej 480'
				WHEN placa_pod = 480 THEN 'Dok³adnie 480'
				ELSE 'Powy¿ej 480'
			END AS próg
	FROM	pracownicy
	ORDER BY placa_pod DESC;
	
--------------------------------------------------------	
-- 11. (dla chêtnych) Napisz to samo zapytanie przy pomocy funkcji DECODE

	SELECT	nazwisko
			,placa_pod
			,DECODE(SIGN(placa_pod / 480 - 1) + 1
			,0
			,'Poni¿ej 480'
			,1
			,'Dok³adnie 480'
			,'Powy¿ej 480') AS próg
	FROM	pracownicy
	ORDER BY placa_pod DESC;

