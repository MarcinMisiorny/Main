/*
* --------------------------------------------
* Rozdzia� 13. Wyzwalacze bazy danych � zadania
* --------------------------------------------
* 
* Plik tworz�cy baz� do �wicze�: Pldemobld.sql
* 
* Plik z zadaniami: 13Wyzwalacze_zadania.pdf
* 
* Prefiks zmiennych odnosi si� do ich typu, np. n_zmienna to zmienna o typie NUMBER, v_zmienna - typ VARCHAR2, etc.
* 
*/

--------------------------------------------------------
-- 1. Napisz wyzwalacz, kt�ry b�dzie automatycznie przyznawa� kolejne identyfikatory nowym zespo�om.
--	  Warto�ci dla identyfikator�w powinny by� generowane przez sekwencj�. Przetestuj dzia�anie
--	  wyzwalacza z poni�szymi poleceniami.
--	  
--	  INSERT INTO ZESPOLY(NAZWA) VALUES('KRYPTOGRAFIA');
--	  1 wiersz zosta� utworzony.
--	  
--	  INSERT INTO ZESPOLY(NAZWA) SELECT substr('NOWE '||NAZWA,1,20) FROM ZESPOLY
--	  WHERE ID_ZESP in (10,20);
--	  2 wiersze zosta�y utworzone.

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
	
-- 2. Dodaj do relacji ZESPOLY atrybut LICZBA_PRACOWNIKOW. Napisz zlecenie SQL kt�re
--	  zainicjuje pocz�tkowe warto�ci atrybutu. Napisz wyzwalacz wierszowy, kt�ry b�dzie piel�gnowa�
--	  warto�� tego atrybutu. Przetestuj dzia�anie wyzwalacza.

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


-- 3. Zdefiniuj relacj� HISTORIA o schemacie (ID_PRAC, PLACA_POD, ETAT, ZESPOL,
--	  MODYFIKACJA). Napisz wyzwalacz, kt�ry po ka�dej modyfikacji warto�ci p�acy podstawowej, etatu
--	  lub zespo�u w relacji PRACOWNICY b�dzie wpisywa� warto�ci historyczne do relacji HISTORIA
--	  (warto�ci sprzed modyfikacji).

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


-- 4. Zdefiniuj perspektyw� SZEFOWIE(SZEF, PRACOWNICY) zawieraj�c� nazwisko szefa i liczb� jego
--	  podw�adnych. Napisz procedur� wyzwalan� kt�ra umo�liwi, za pomoc� powy�szej perspektywy,
--	  usuwanie szef�w wraz z kaskadowym usuni�ciem wszystkich podw�adnych danego szefa. Je�li
--	  podw�adny usuwanego szefa sam jest szefem innych pracownik�w, przerwij dzia�anie wyzwalacza
--	  b��dem o numerze ORA-20001 i komunikacie �Jeden z podw�adnych usuwanego pracownika jest
--	  szefem innych pracownik�w. Usuwanie anulowane!�.
--	  
--	  Przywr�� usuni�te rekordy wycofuj�c poleceniem ROLLBACK transakcj�, w kt�rej nast�pi�o
--	  usuni�cie pracownika MORZY.

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
			RAISE_APPLICATION_ERROR(-20001, 'Jeden z podw�adnych usuwanego pracownika jest szefem innych pracownik�w. Usuwanie anulowane!');
	END;
	/


-- 5. W relacji PRACOWNICY usu� ograniczenie referencyjne FK_ID_SZEFA (klucz obcy mi�dzy
--	  pracownikiem a jego szefem), nast�pnie utw�rz je ponownie z cech� usuwania kaskadowego.
--	  
--	  Zdefiniuj teraz wyzwalacz wierszowy o nazwie USUN_PRAC. Wyzwalacz ma uruchamia� si� po
--	  wykonaniu operacji DELETE na relacji PRACOWNICY. Jedynym zadaniem wyzwalacza b�dzie
--	  wypisanie na ekranie, za pomoc� procedury DBMS_OUTPUT.PUT_LINE, nazwiska usuwanego
--	  pracownika. Przetestuj dzia�anie wyzwalacza usuwaj�c z relacji PRACOWNICY rekord opisuj�cy
--	  pracownika o nazwisko MORZY. Nie zapomnij przed wykonaniem polecenia DELETE ustawi�
--	  zmiennej SERVEROUTPUT na warto�� ON. Po zako�czeniu zadania wycofaj transakcj� przy pomocy
--	  polecenia ROLLBACK;
--	  
--	  Wykonaj ponownie zadanie 5. Tym razem wyzwalacz USUN_PRAC ma si� uruchamia� przed
--	  wykonaniem operacji DELETE na relacji PRACOWNICY. Por�wnaj otrzymane teraz wyniki z
--	  wynikami z pierwszej cz�ci zadania.

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
	-- w zale�no�ci od kolejno�ci zdefiniowania wykonywania wyzwalacza, 
	-- nazwisko jest wypisywane na pocz�tku lub na ko�cu wykonywania operacji
	-- 

