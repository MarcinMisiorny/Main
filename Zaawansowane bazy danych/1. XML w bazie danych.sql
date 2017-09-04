/*
* --------------------------------------------
* Rozdział 1. Funkcje standardu SQL/XML 
* --------------------------------------------
* 
* Plik z zadaniami: ZSBD_cw_01.pdf
* 
* Pliki tworzące bazę do ćwiczeń: lp3.sql
* 
*/

--------------------------------------------------------
-- 1. Wykorzystaj funkcję XMLElement do wygenerowania znaczników XML. W tym celu wykonaj następujące polecenie:

	SELECT 	id_prac
			,XMLElement("PRACOWNIK", nazwisko) AS XML
	FROM 	pracownicy;

--------------------------------------------------------	
-- 2. Funkcja XMLElement może też przyjąć dodatkowy parametr który spowoduje dodanie atrybutów
--    do generowanych znaczników.

	SELECT	XMLElement("PRACOWNIK", XMLAttributes(id_prac), nazwisko) AS XML
	FROM	pracownicy;
	
--------------------------------------------------------	
-- 3. Funkcja XMLElement może zostać także wykorzystana do stworzenia znaczników zagnieżdżonych
--	  oraz do przygotowania mieszanej zawartości, gdzie znaczniki XML są wplecione w tekst i służą
--	  raczej jako adnotacje interesujących elementów w tekście.
	
	SELECT	XMLElement("PRACOWNIK", XMLAttributes(id_prac AS id)
			,XMLElement("NAZWISKO", nazwisko)
			,'pracuje jako '||etat||' i zarabia '
			,XMLElement("PLACA", placa_pod + NVL(placa_dod,0))) AS XML
	FROM	pracownicy;
	
--------------------------------------------------------	
-- 4. Wartości puste są obsługiwane inaczej przez funkcję XMLAttributes, a inaczej przez XMLElement.
-- 	Wykonaj poniższe zapytanie i sprawdź, jaką płacę dodatkową ma Słowiński. Porównaj uzyskany wynik z wynikiem drugiego zapytania.

	SELECT	XMLElement("PRACOWNIK"
					  ,XMLAttributes(id_prac, placa_pod, placa_dod), nazwisko) AS XML
	FROM	pracownicy;
	
	SELECT	XMLElement("PRACOWNIK"
					  ,XMLAttributes(id_prac AS id)
			,XMLElement("NAZWISKO", nazwisko)
			,XMLElement("DODATEK", placa_dod)) AS XML
	FROM	pracownicy;
	
--------------------------------------------------------	
-- 5. Funkcja XMLForest może być wykorzystana do utworzenia lasu elementów na podstawie podanej
--	  listy argumentów, przy czym argumenty mogą być wyrażeniami z aliasami. Przeanalizuj wynik
--	  wykonania następujących zapytań i sprawdź, w jaki sposób funkcja obsługuje wartości puste:

	SELECT	XMLElement("PRACOWNIK"
					 ,XMLAttributes(id_prac AS id)
			,XMLForest(nazwisko, placa_dod AS "DODATEK")) AS XML
	FROM	pracownicy;
	
	SELECT	XMLElement("PRACOWNIK",	XMLAttributes(id_prac AS "id")
			,XMLForest(nazwisko AS "NAZWISKO"
			,XMLForest(placa_pod AS "PODSTAWA", placa_dod AS "DODATEK")	AS "ZAROBKI")) AS XML
	FROM	pracownicy
	
--------------------------------------------------------	
-- 6. Kolejną funkcją jest funkcja XMLConcat, która łączy argumenty tworząc z nich jeden fragment
-- 	  XML. Funkcja posiada dwie postacie: (a) jedna jako parametr pobiera obiekt XMLSequenceType i
-- 	  konkatenuje wszystkie elementy do postaci pojedynczej instancji typu XMLType (b) druga postać
-- 	  konkatenuje dowolną liczbę instancji XMLType do jednej instancji XMLType
	
	SELECT	XMLConcat (XMLElement("SZEF", S.NAZWISKO )
			,XMLElement("PODWLADNY", P.NAZWISKO)) AS XML
	FROM	pracownicy p 
	JOIN 	pracownicy s ON (p.id_szefa = s.id_prac);
	
--------------------------------------------------------	
-- 7. Funkcja XMLConcat potrafi także wygenerować znacznik XML w oparciu o nazwy zaczerpnięte
--	  bezpośrednio ze słownika bazy danych. Sprawdź wynik poniższego zapytania.

	SELECT	XMLConcat(XMLSequence(CURSOR (SELECT	nazwisko
													,placa_pod
													,placa_dod
										  FROM pracownicy))) AS XML
	FROM	dual;
	
--------------------------------------------------------	
-- 8. Funkcja XMLAgg jest funkcją grupową, która buduje las elementów XML na podstawie wskazanej
--	  grupy rekordów. Funkcja umożliwia jawne sortowanie elementów wewnątrz grup.
	
	SELECT	XMLElement("ZESPOL"
			,XMLAttributes(z.id_zesp)
			,XMLElement("NAZWA", z.nazwa)
			,XMLElement("PRACOWNICY"
			,XMLAgg(XMLElement("PRACOWNIK", p.nazwisko )))) AS XML
	FROM	pracownicy p 
	JOIN	zespoly z ON (p.id_zesp = z.id_zesp)
	GROUP BY z.id_zesp, z.nazwa;
	
--------------------------------------------------------	
-- 9. Funkcja XMLColAttVal działa bardzo podobnie do funkcji XMLForest, ale
--	  a. wynikiem jest las elementów <column>,
--	  b. elementy <column> posiadają atrybut name którego wartość pochodzi od nazwy
--	  wyrażenia,
--	  c. zawartość elementu <column> jest wyznaczana na podstawie wyrażenia
	
	SELECT	XMLElement("PRACOWNIK"
			,XMLAttributes(id_prac AS ID)
			,XMLColAttVal(nazwisko AS NAZWISKO
			,placa_dod AS DODATEK)) AS XML
	FROM	pracownicy;
	
	SELECT	XMLElement("PRACOWNIK"
			,XMLAttributes(id_prac AS ID)
			,XMLColAttVal(nazwisko AS "NAZWISKO"
			,XMLColAttVal(placa_pod AS "PODSTAWA"
			,placa_dod AS "DODATEK") AS "ZAROBKI")) AS XML
	FROM	pracownicy;
	
--------------------------------------------------------	
-- 10. W przypadku chęci wykorzystania funkcji SQL/XML do generowania poprawnych dokumentów
--	   XML konieczne jest (a) zamknięcie całego dokumentu w pojedynczym znaczniku-korzeniu oraz (b)
--     przygotowanie preambuły dokumentu. Może do tego celu posłużyć funkcja XMLRoot.
	
	SELECT	XMLRoot(XMLElement("DOKUMENT"
			,SYS_XMLGEN('Chrząszcz brzmi w trzcinie', XMLFormat('FRAZA'))
			,XMLComment('Wiersz Jana Brzechwy')), VERSION '1.1' ) AS XML
	FROM	dual;
	
--------------------------------------------------------	
-- 11. Na koniec spójrzmy, w jaki sposób można szybko dokonać walidacji fragmentu XML.

	SELECT	XMLParse(CONTENT 'Ala ma <PIES>Asa</PIES>' WELLFORMED).isFragment()
	FROM 	dual; 
	
	
=======================================================	
	
-- Z poziomu Twojego konta w bazie danych dostępne są dane opisujące notowania Listy
-- Przebojów Programu III.
-- 
-- Korzystając z funkcji SQL/XML, napisz zapytania SQL, które wygenerują poniższe struktury:

--------------------------------------------------------
-- 1. Nazwiska i imiona prowadzących.
-- <Prowadzacy>
--  <Nazwisko>Kawecki</Nazwisko>
--  <Imie>Jarosław</Imie>
-- </Prowadzacy>
-- <Prowadzacy>
--  <Nazwisko>Kaczkowski</Nazwisko>
--  <Imie>Piotr</Imie>
-- </Prowadzacy>
-- <Prowadzacy>
--  <Nazwisko>Rogowiecki</Nazwisko>
--  <Imie>Roman</Imie>
-- </Prowadzacy>
-- <Prowadzacy>
--  <Nazwisko>Zamorski</Nazwisko>
--  <Imie>Wojciech</Imie>
-- </Prowadzacy>
-- . . .

	SELECT	XMLElement("Prowadzacy"
			,XMLElement("Nazwisko", p_nazwisko)
			,XMLElement("imie", p_imie)) AS XML
	FROM	lp3_prowadzacy
	ORDER BY p_nazwisko;

--------------------------------------------------------
-- 2. Utwory (tytuł i wykonawca). Zapytanie ogranicz tylko do tych utworów, których tytuły
--	  i wykonawcy rozpoczynają się od litery 'A'.
-- <NaLitereA wykonawca_id="3" utwor_id="2286">
--  <Nazwa>AC/DC</Nazwa>
--  <Utwor>Are You Ready?</Utwor>
-- </NaLitereA>
-- <NaLitereA wykonawca_id="1049" utwor_id="2803">
--  <Nazwa>Ace Of Base</Nazwa>
--  <Utwor>All That She Wants</Utwor>
-- </NaLitereA>
-- <NaLitereA wykonawca_id="1049" utwor_id="4359">
--  <Nazwa>Ace Of Base</Nazwa>
--  <Utwor>Always Have, Always Will</Utwor>
-- </NaLitereA>
-- . . .

	SELECT	XMLElement("NaLitereA"
					  ,XMLAttributes(w.w_id AS "wykonawca_id", u.u_w_id AS "utwor_id")
					  ,XMLElement("Nazwa", w.w_nazwa)
					  ,XMLElement("Utwor", u.u_tytul)) AS XML
	FROM	lp3_utwory u
	JOIN	lp3_wykonawcy w ON (u.u_w_id = w.w_id)
	WHERE 	w.w_nazwa LIKE 'A%'
	AND 	u.u_tytul LIKE 'A%' 
	ORDER BY w.w_nazwa, u.u_tytul;

--------------------------------------------------------
-- 3. Nazwy wykonawców i liczby ich utworów. Zapytanie ogranicz tylko do tych
-- wykonawców, którzy zamieścili na liście ponad 30 utworów.
-- <Najlepszy wykonawca_id="2">
--  <Nazwa>Maanam</Nazwa>
--  <Ile_utworow>62</Ile_utworow>
-- </Najlepszy>
-- <Najlepszy wykonawca_id="374">
--  <Nazwa>Madonna</Nazwa>
--  <Ile_utworow>47</Ile_utworow>
-- </Najlepszy>
-- <Najlepszy wykonawca_id="61">
--  <Nazwa>Lady Pank</Nazwa>
--  <Ile_utworow>46</Ile_utworow>
-- </Najlepszy>
-- . . .

	SELECT	XMLElement("Najlepszy"
						,XMLAttributes(w.w_id AS "wykonawca_id")
						,XMLElement("Nazwa", w.w_nazwa)
						,XMLElement("Ile_utworow", u.u_id)) AS XML
	FROM	lp3_notowania n
	JOIN 	lp3_miejsca m ON (n.n_id = m.m_n_id)
	JOIN 	lp3_utwory u ON (m.m_u_id = u.u_id)
	JOIN 	lp3_wykonawcy w ON (w.w_id = u.u_w_id)
	GROUP BY w.w_id, w.w_nazwa, u.u_id
	HAVING u.u_id > 30
	
--------------------------------------------------------
-- 4. Lista wszystkich utworów wykonawcy o nazwie "Pink Floyd".
-- <Wykonawca wykonawca_id="90">
--  <Nazwa>Pink Floyd</Nazwa>
--  <Utwor>When The Tigers Broke Free</Utwor>
--  <Utwor>The Hero</Utwor>
--  <Utwor>The Gunner&apos;s Dream</Utwor>
--  <Utwor>What Do You Want From Me</Utwor>
--  <Utwor>On The Turning Away</Utwor>
--  <Utwor>I Wish You Were Here</Utwor>
--  <Utwor>Learning To Fly</Utwor>
--  <Utwor>Take It Back</Utwor>
-- </Wykonawca> 

	SELECT	XMLElement("Wykonawca"
					  ,XMLAttributes(w.w_id AS "wykonawca_id")
					  ,XMLElement("Nazwa", w.w_nazwa)
					  ,XMLForest(u.u_tytul AS "Utwor" )) AS XML
	FROM	lp3_wykonawcy w 
	JOIN	lp3_utwory u ON (u.u_w_id = w.w_id)
	WHERE	w.w_nazwa = 'Pink Floyd';

--------------------------------------------------------
-- 5. Zgrupowane w jednym elemencie Notowanie informacje o pierwszym notowaniu
-- listy przebojów, jego prowadzącym oraz utworach, jakie się pojawiły.
-- <Notowanie Nr="1" Data="82/04/24">
--  <Prowadzacy>Niedźwiecki Marek</Prowadzacy>
--  <Utwor Lp="2">Maanam - O! Nie rób tyle hałasu</Utwor>
--  <Utwor Lp="3">AC/DC - For Those About To Rock</Utwor>
--  <Utwor Lp="4">TSA - 51</Utwor>
--  <Utwor Lp="6">ABBA - Visitors</Utwor>
--  <Utwor Lp="8">Perfect - Pepe Wróć</Utwor>
--  <Utwor Lp="10">Kombi - Słodka jest noc</Utwor>
--  <Utwor Lp="12">Kasa Chorych - Przed nami drzwi zamknięte</Utwor>
--  <Utwor Lp="14">Derek And The Dominos - Layla</Utwor>
--  <Utwor Lp="16">Rod Stewart - How Long</Utwor>
--  <Utwor Lp="25">Rick Springfield - Don&apos;t Talk To Strangers</Utwor>
--  <Utwor Lp="24">Klan - Z brzytwą na poziomki</Utwor>
--  <Utwor Lp="23">Adrian John Loveridge - 400 Dragons</Utwor>
--  <Utwor Lp="22">Lombard - Droga pani z TV</Utwor>
--  <Utwor Lp="21">Lindsey Buckingham - Trouble</Utwor>
--  <Utwor Lp="20">Stevie Wonder - That Girl</Utwor>
--  <Utwor Lp="19">Stevie Nicks - Edge Of Seventeen</Utwor>
-- . . .

	SELECT	XMLElement("Notowanie"
			,XMLAttributes(n.n_nr AS "Nr", n.n_data AS "Data")
			,XMLElement("Prowadzacy", p.p_nazwisko || ' ' || p.p_imie)
			,XMLAgg(XMLElement("Utwor"
							  ,XMLAttributes(m.m_lp AS "Lp")
							  ,w.w_nazwa || ' - ' || u.u_tytul))) AS XML
	FROM 	lp3_notowania n
	JOIN 	lp3_miejsca m ON (N.N_ID = M.M_N_ID)
	JOIN 	lp3_utwory u ON (m.m_u_id = u.u_id)
	JOIN 	lp3_wykonawcy w ON (w.w_id = u.u_w_id)
	JOIN 	lp3_prowadzacy p ON (N.N_P_ID = P.P_ID)
	WHERE 	n.n_nr = TO_CHAR(1)
	GROUP BY n.n_nr, n.n_data, p.p_nazwisko || ' ' || p.p_imie
	
--------------------------------------------------------
-- 6. Następujący dokument dotyczący tysięcznego notowania Listy Przebojów Trójki.
-- <Notowanie id="971">
--  <Nr>1000</Nr>
--  <Data>01/03/30</Data>
--  <Prowadzacy>
--  <Nazwisko>Niedźwiecki</Nazwisko>
--  <Imie>Marek</Imie>
--  </Prowadzacy>
--  <Miejsca>
--  <Miejsce>
--  <Lp>1</Lp>
--  <Wykonawca>Sting</Wykonawca>
--  <Tytul>A Thousand Years</Tytul>
--  </Miejsce>
--  <Miejsce>
--  <Lp>2</Lp> 
 
  	SELECT	XMLElement("Notowanie"
					  ,XMLAttributes(N.N_ID AS "id")
					  ,XMLElement("Nr", n.n_nr)
					  ,XMLElement("Data", n.n_data)
					  ,XMLElement("Prowadzacy"
								 ,XMLElement("Nazwisko", p.p_nazwisko)
								 ,XMLElement("Imie", p.p_imie))
					  ,XMLElement("Miejsca"
								 ,XMLAgg(XMLElement("Miejsce"
								 ,XMLElement("Lp", m.m_lp)
								 ,XMLElement("Wykonawca", w.w_nazwa)
								 ,XMLElement("Tytul", u.u_tytul)
      )))) AS XML
	FROM 	lp3_notowania n
	JOIN 	lp3_miejsca m ON (n.n_id = m.m_n_id)
	JOIN 	lp3_utwory u ON (m.m_u_id = u.u_id)
	JOIN 	lp3_wykonawcy w ON (w.w_id = u.u_w_id)
	JOIN 	lp3_prowadzacy p ON (n.n_p_id = p.p_id)
	WHERE 	n.n_nr = TO_CHAR(1000)
	GROUP BY n.n_id, n.n_nr, n.n_data, p.p_nazwisko, p.p_imie
	  
	  