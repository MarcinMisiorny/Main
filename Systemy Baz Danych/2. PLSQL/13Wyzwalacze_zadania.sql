/*
* --------------------------------------------
* Rozdzia³ 13. Wyzwalacze bazy danych – zadania
* --------------------------------------------
* 
* Plik tworz¹cy bazê do æwiczeñ: Pldemobld.sql
* 
* Plik z zadaniami: 13Wyzwalacze_zadania.pdf
* 
* Prefiks zmiennych odnosi siê do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Napisz wyzwalacz, który bêdzie automatycznie przyznawa³ kolejne identyfikatory nowym zespo³om.
--	  Wartoœci dla identyfikatorów powinny byæ generowane przez sekwencjê. Przetestuj dzia³anie
--	  wyzwalacza z poni¿szymi poleceniami.
--	  
--	  INSERT INTO ZESPOLY(NAZWA) VALUES('KRYPTOGRAFIA');
--	  1 wiersz zosta³ utworzony.
--	  
--	  INSERT INTO ZESPOLY(NAZWA) SELECT substr('NOWE '||NAZWA,1,20) FROM ZESPOLY
--	  WHERE ID_ZESP in (10,20);
--	  2 wiersze zosta³y utworzone.

	CREATE SEQUENCE seq_id_zesp
	START WITH 100 
	INCREMENT BY 10 
	NOMAXVALUE;

	CREATE OR REPLACE TRIGGER trigger_id_zesp
	BEFORE INSERT ON zespoly
	FOR EACH ROW
	BEGIN
		IF :NEW.id_zesp IS NULL THEN
			:NEW.id_zesp := seq_id_zesp.NEXTVAL;
		END IF;
	END;
	/
	
-- 2. Dodaj do relacji ZESPOLY atrybut LICZBA_PRACOWNIKOW. Napisz zlecenie SQL które
--	  zainicjuje pocz¹tkowe wartoœci atrybutu. Napisz wyzwalacz wierszowy, który bêdzie pielêgnowa³
--	  wartoœæ tego atrybutu. Przetestuj dzia³anie wyzwalacza.

	ALTER TABLE ZESPOLY ADD LICZBA_PRACOWNIKOW NUMBER;

	UPDATE	zespoly z
	SET		z.liczba_pracownikow = (SELECT	COUNT(*) 
									FROM	pracownicy 
									WHERE	id_zesp = z.id_zesp);

	CREATE OR REPLACE TRIGGER trigger_liczba_pracownikow
	AFTER INSERT OR UPDATE OR DELETE ON pracownicy
	BEGIN
		UPDATE	zespoly z
		SET		z.liczba_pracownikow = (SELECT	COUNT(*) 
										FROM	pracownicy 
										WHERE	id_zesp = z.id_zesp);
	END;
	/


-- 3. Zdefiniuj relacjê HISTORIA o schemacie (ID_PRAC, PLACA_POD, ETAT, ZESPOL,
--	  MODYFIKACJA). Napisz wyzwalacz, który po ka¿dej modyfikacji wartoœci p³acy podstawowej, etatu
--	  lub zespo³u w relacji PRACOWNICY bêdzie wpisywa³ wartoœci historyczne do relacji HISTORIA
--	  (wartoœci sprzed modyfikacji).

	CREATE TABLE historia
	(id_prac NUMBER
	,placa_pod NUMBER
	,etat VARCHAR2(20)
	,zespol VARCHAR2(20)
	,modyfikacja DATE);

	CREATE OR REPLACE TRIGGER trigger_historia
	BEFORE UPDATE OF placa_pod, etat, id_zesp OR DELETE ON pracownicy
	FOR EACH ROW
	BEGIN
		INSERT INTO historia (ID_PRAC
							 ,PLACA_POD
							 ,ETAT
							 ,ZESPOL
							 ,MODYFIKACJA)
		VALUES
							 (:OLD.id_prac
							 ,:OLD.placa_pod
							 ,:OLD.etat
							 ,(SELECT nazwa FROM zespoly where id_zesp = :OLD.id_zesp)
							 ,SYSDATE);
	END;
	/


-- 4. Zdefiniuj perspektywê SZEFOWIE(SZEF, PRACOWNICY) zawieraj¹c¹ nazwisko szefa i liczbê jego
--	  podw³adnych. Napisz procedurê wyzwalan¹ która umo¿liwi, za pomoc¹ powy¿szej perspektywy,
--	  usuwanie szefów wraz z kaskadowym usuniêciem wszystkich podw³adnych danego szefa. Jeœli
--	  podw³adny usuwanego szefa sam jest szefem innych pracowników, przerwij dzia³anie wyzwalacza
--	  b³êdem o numerze ORA-20001 i komunikacie „Jeden z podw³adnych usuwanego pracownika jest
--	  szefem innych pracowników. Usuwanie anulowane!”.
--	  
--	  Przywróæ usuniête rekordy wycofuj¹c poleceniem ROLLBACK transakcjê, w której nast¹pi³o
--	  usuniêcie pracownika MORZY.

	CREATE OR REPLACE VIEW szefowie (szef
									,pracownicy)
	AS
	SELECT	p.nazwisko AS szef
			,COUNT(pr.nazwisko) AS podwladny
	FROM	pracownicy p
	JOIN	pracownicy pr ON (p.id_prac = pr.id_szefa)
	GROUP BY p.nazwisko
	ORDER BY szef;

	CREATE OR REPLACE TRIGGER trigger_szefowie
	INSTEAD OF DELETE ON szefowie
	FOR EACH ROW
	DECLARE
		CURSOR c_podwladni(p_id_prac NUMBER) IS
		SELECT	id_prac 
		FROM	pracownicy
		WHERE	id_szefa = p_id_prac;
		
		n_id_szefa NUMBER;
		n_czy_pracown_ma_podwladn NUMBER;
		
		ex_szef_szefa EXCEPTION;
	BEGIN
		SELECT	id_prac
		INTO	n_id_szefa
		FROM	pracownicy
		WHERE	nazwisko = :OLD.szef;
		
		FOR i IN c_podwladni(n_id_szefa) LOOP
			SELECT	CASE 
					WHEN EXISTS (SELECT	1 
								 FROM	pracownicy p
								 WHERE	p.id_szefa = i.id_prac)
					THEN 1 
					ELSE 0 
					END
			INTO	n_czy_pracown_ma_podwladn
			FROM	dual;
		
			IF n_czy_pracown_ma_podwladn = 1 THEN
				RAISE ex_szef_szefa;
			END IF;
		END LOOP;
	
			DELETE
			FROM	pracownicy
			WHERE	id_szefa = n_id_szefa;
			
			DELETE
			FROM	pracownicy
			WHERE	id_prac = n_id_szefa;
	EXCEPTION
		WHEN ex_szef_szefa THEN
			RAISE_APPLICATION_ERROR(-20001, 'Jeden z podw³adnych usuwanego pracownika jest szefem innych pracowników. Usuwanie anulowane!');
	END;
	/


-- 5. W relacji PRACOWNICY usuñ ograniczenie referencyjne FK_ID_SZEFA (klucz obcy miêdzy
--	  pracownikiem a jego szefem), nastêpnie utwórz je ponownie z cech¹ usuwania kaskadowego.
--	  
--	  Zdefiniuj teraz wyzwalacz wierszowy o nazwie USUN_PRAC. Wyzwalacz ma uruchamiaæ siê po
--	  wykonaniu operacji DELETE na relacji PRACOWNICY. Jedynym zadaniem wyzwalacza bêdzie
--	  wypisanie na ekranie, za pomoc¹ procedury DBMS_OUTPUT.PUT_LINE, nazwiska usuwanego
--	  pracownika. Przetestuj dzia³anie wyzwalacza usuwaj¹c z relacji PRACOWNICY rekord opisuj¹cy
--	  pracownika o nazwisko MORZY. Nie zapomnij przed wykonaniem polecenia DELETE ustawiæ
--	  zmiennej SERVEROUTPUT na wartoœæ ON. Po zakoñczeniu zadania wycofaj transakcjê przy pomocy
--	  polecenia ROLLBACK;
--	  
--	  Wykonaj ponownie zadanie 5. Tym razem wyzwalacz USUN_PRAC ma siê uruchamiaæ przed
--	  wykonaniem operacji DELETE na relacji PRACOWNICY. Porównaj otrzymane teraz wyniki z
--	  wynikami z pierwszej czêœci zadania.

	ALTER TABLE pracownicy 
	DROP CONSTRAINT fk_id_szefa;
	
	ALTER TABLE pracownicy 
	ADD CONSTRAINT fk_id_szefa
	FOREIGN KEY (id_szefa)
	REFERENCES pracownicy(id_prac) 
	ON DELETE CASCADE;

	CREATE OR REPLACE TRIGGER usun_prac
	AFTER DELETE ON pracownicy
	FOR EACH ROW
	BEGIN
		DBMS_OUTPUT.PUT_LINE(:OLD.nazwisko);
	END;
	/

	-- po wykonaniu
	-- 
	-- DELETE 
	-- FROM pracownicy 
	-- WHERE nazwisko = 'MORZY';
	-- 
	-- zostanie wypisane na ekranie:
	-- 
	-- MATYSIAK
	-- ZAKRZEWICZ
	-- MORZY
	
	CREATE OR REPLACE TRIGGER usun_prac
	BEFORE DELETE ON pracownicy
	FOR EACH ROW
	BEGIN
		DBMS_OUTPUT.PUT_LINE(:OLD.nazwisko);
	END;
	/

	-- po wykonaniu
	-- 
	-- DELETE 
	-- FROM pracownicy 
	-- WHERE nazwisko = 'MORZY';
	-- 
	-- zostanie wypisane na ekranie:
	-- 
	-- MORZY
	-- MATYSIAK
	-- ZAKRZEWICZ

	-- 
	-- Wniosek: 
	-- 
	-- w zale¿noœci od kolejnoœci zdefiniowania wykonywania wyzwalacza, 
	-- nazwisko jest wypisywane na pocz¹tku lub na koñcu wykonywania operacji
	-- 

