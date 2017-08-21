/*
* --------------------------------------------
* Rozdzia³ 7. Jêzyk manipulowania danymi DML
* – zadania
* --------------------------------------------
* 
* Plik z zadaniami: 07DML_zadania.pdf
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
*  
*/

--------------------------------------------------------
-- 1. Wstaw do relacji PROJEKTY nastêpuj¹ce krotki

-- 
-- atrybut				wartoœæ					wartoœæ
-- ID_PROJEKTU			1						2
-- OPIS_PROJEKTU		Indeksy bitmapowe		Sieci komputerowe
-- DATA_ROZPOCZECIA		2 kwietnia 1999 r.		12 listopada 2000 r.
-- DATA_ZAKONCZENIA		31 sierpnia 2001 r.	
-- FUNDUSZ				25 000					19 000
--	

	INSERT INTO projekty (ID_PROJEKTU
						 ,OPIS_PROJEKTU
						 ,DATA_ROZPOCZECIA
						 ,DATA_ZAKONCZENIA
						 ,FUNDUSZ)
	VALUES		
						 (1
						 ,'Indeksy bitmapowe'
						 ,'1999-04-02'
						 ,'2001-08-31'
						 ,25000);
			
	INSERT INTO projekty (ID_PROJEKTU
						 ,OPIS_PROJEKTU
						 ,DATA_ROZPOCZECIA 
						 ,DATA_ZAKONCZENIA,
						 ,FUNDUSZ)
	VALUES		
						 (2
						 ,'Sieci komputerowe'
						 ,'2000-11-12'
						 ,NULL
						 ,19000); 

--------------------------------------------------------
-- 2. Wstaw do relacji PRZYDZIALY nastêpuj¹ce krotki

-- 
-- atrybut			wartoœæ					wartoœæ
-- ID_PROJEKTU		1						1
-- NR_PRACOWNIKA	170						140
-- OD				10 kwietnia 1999 r.		1 grudnia 2000 r.
-- DO				10 maja 1999 r.
-- STAWKA			1 000					1 500
-- ROLA				KIERUJ¥CY				ANALITYK
-- GODZINY			20						40
-- 

	INSERT INTO przydzialy  (ID_PROJEKTU
							,NR_PRACOWNIKA
							,OD
							,DO
							,STAWKA
							,ROLA
							,GODZINY)
	VALUES		
							(1
							,170
							,'1999-04-10'
							,'1999-05-10'
							,1000
							,'KIERUJ¥CY'
							,20);
			
			
	INSERT INTO przydzialy  (ID_PROJEKTU
							,NR_PRACOWNIKA
							,OD
							,DO
							,STAWKA
							,ROLA
							,GODZINY)
	VALUES		
							(1
							,140
							,'2000-12-01'
							,NULL
							,1500
							,'ANALITYK'
							,40); 

--------------------------------------------------------		
-- 3. Podnieœ stawkê pracownika o numerze 170 do 1200 z³otych (relacja PRZYDZIALY).
	
	UPDATE	przydzialy
	SET		stawka = 1200
	WHERE	nr_pracownika = 170; 
	
--------------------------------------------------------
-- 4. Zmieñ datê zakoñczenia projektu ‘Indeksy bitmapowe’ na 31 grudnia 2001 r. i zmniejsz
--	  fundusz tego projektu do 19000 z³otych.

	UPDATE	projekty
	SET		data_zakonczenia = '2001-12-31'
			,fundusz = 19000 
	WHERE opis_projektu = 'Indeksy bitmapowe'; 
		
--------------------------------------------------------	  
-- 5. Wstaw dwie propozycje w³asnych projektów.

	INSERT INTO projekty (ID_PROJEKTU
						 ,OPIS_PROJEKTU
						 ,DATA_ROZPOCZECIA
						 ,DATA_ZAKONCZENIA
						 ,FUNDUSZ)
	VALUES		
						 (3
						 ,'BIG DATA'
						 ,'2011-11-02'
						 ,'2014-12-31'
						 ,36000);
			
	INSERT INTO projekty (ID_PROJEKTU
						 ,OPIS_PROJEKTU
						 ,DATA_ROZPOCZECIA
						 ,DATA_ZAKONCZENIA
						 ,FUNDUSZ)
	VALUES		
						 (4
						 ,'eWnioski'
						 ,'2015-04-02'
						 ,'2015-06-20'
						 ,9999);

--------------------------------------------------------
-- 6. Usuñ informacje o projektach do których nie przydzielono ¿adnych pracowników.
	
	DELETE
	FROM	projekty p
	WHERE NOT EXISTS (SELECT	id_projektu
					  FROM		przydzialy
					  WHERE		id_projektu = p.id_projektu);
	 
--------------------------------------------------------	 
-- 7. Wszystkim pracownikom podnieœ p³acê podstawow¹ o 10% œredniej p³acy podstawowej
--	  w ich zespole (relacja PRACOWNICY).

	UPDATE	pracownicy p
	SET		p.placa_pod = p.placa_pod + (SELECT AVG(placa_pod) * 0.1
										 FROM	pracownicy
										 WHERE	p.id_zesp = id_zesp);

--------------------------------------------------------
--8. Podnieœ do œredniej pracowniczej p³acê podstawow¹ najmniej zarabiaj¹cym pracownikom.
	
	UPDATE	pracownicy
	SET		placa_pod = (SELECT ROUND(AVG(placa_pod), 2)
						 FROM	pracownicy)
	WHERE	placa_pod = (SELECT	MIN(placa_pod)
						 FROM	pracownicy); 
		
--------------------------------------------------------	 
-- 9. Uaktualnij p³ace dodatkowe pracowników zespo³u 20. Nowe p³ace dodatkowe maj¹ byæ
--	  równe œredniej p³acy podstawowej pracowników, których prze³o¿onym jest prof. Morzy.

	UPDATE	pracownicy
	SET		placa_dod = (SELECT AVG(p.placa_pod)
						 FROM	pracownicy p
						 WHERE	p.id_szefa = (SELECT id_prac
											  FROM	 pracownicy
											  WHERE  id_prac = p.id_szefa
											  AND	 nazwisko = 'MORZY')) 
	WHERE id_zesp = 20;
	
-------------------------------------------------------- 
-- 10. Pracownikom zespo³u o nazwie SYSTEMY ROZPROSZONE daj 25% podwy¿kê (p³aca
--	   podstawowa). Zastosuj modyfikacjê po³¹czenia.

	UPDATE (SELECT	p.placa_pod
			FROM	pracownicy p
			JOIN	zespoly z USING(id_zesp)
			WHERE	z.nazwa = 'SYSTEMY ROZPROSZONE')
	SET		placa_pod = placa_pod + 0.25 * placa_pod;

-------------------------------------------------------- 
-- 11. Usuñ bezpoœrednich podw³adnych pracownika o nazwisku Morzy. Zastosuj usuwanie
--	   krotek z wyniku po³¹czenia relacji.

	DELETE
	FROM (SELECT	p.nazwisko AS pracownik
					,e.nazwisko AS szef
		  FROM		pracownicy p
		  JOIN		pracownicy e ON (e.id_prac = p.id_szefa)
		  WHERE		e.nazwisko = 'MORZY'); 
	 
--------------------------------------------------------	 
-- 12. Wyœwietl aktualn¹ zawartoœæ relacji PRACOWNICY.

	SELECT	*
	FROM	pracownicy; 
  
--------------------------------------------------------  
-- 13. Utwórz sekwencjê MYSEQ rozpoczynaj¹c¹ siê od 300 i zwiêkszaj¹c¹ siê w ka¿dym kroku o 10.

	CREATE SEQUENCE myseq
	START WITH 300 
	INCREMENT BY 10 
	NOMAXVALUE; 
	
--------------------------------------------------------  
-- 14. Wykorzystaj utworzon¹ sekwencjê do wstawienia nowego sta¿ysty o nazwisku
--	   Tr¹bczyñski do relacji Pracownicy.
	
	INSERT INTO pracownicy  (ID_PRAC
							,NAZWISKO
							,ETAT
							,ID_SZEFA
							,ZATRUDNIONY
							,PLACA_POD
							,PLACA_DOD
							,ID_ZESP)
	VALUES		
							(myseq.NEXTVAL
							,'TRABCZYNSKI'
							,'STAZYSTA'
							,130
							,'2015-11-21'
							,1000
							,NULL
							,30);

--------------------------------------------------------
-- 15. Zmodyfikuj pracownikowi Tr¹bczyñskiemu p³acê dodatkow¹ na wartoœæ wskazywan¹
--	   przez sekwencjê.
	
	UPDATE	pracownicy
	SET		placa_dod = myseq.NEXTVAL
	WHERE	id_prac = 300;
 
-------------------------------------------------------- 
-- 16. Usuñ pracownika o nazwisku Tr¹bczyñski.
	
	DELETE
	FROM	pracownicy 
	WHERE	id_prac = 300; 
	
-------------------------------------------------------- 
-- 17. Stwórz now¹ sekwencjê o niskiej wartoœci maksymalnej. Zaobserwuj, co siê dzieje, gdy
--	   nastêpuje „przepe³nienie” sekwencji.

	CREATE SEQUENCE myseqtest
	START WITH 1 
	INCREMENT BY 1 
	MAXVALUE 3;
	
	SELECT	myseqtest.NEXTVAL
	FROM	dual; --wywolane trzykrotnie
	
	
	--Po tym nastepuje: 
	
	ORA-08004: SEQUENCE MYSEQTEST.NEXTVAL exceeds MAXVALUE
	AND cannot be instantiated 08004. 00000 - "sequence %s.NEXTVAL %s %sVALUE and cannot be instantiated" *cause: instantiating NEXTVAL would violate one OF MAX/MINVALUE *Action:
	ALTER the SEQUENCE so that a NEW value can be requested ------------

