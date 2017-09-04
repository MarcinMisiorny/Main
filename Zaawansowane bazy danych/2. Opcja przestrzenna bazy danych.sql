/*
* --------------------------------------------
* Rozdział 2. Funkcje Oracle Spatial, opcja przestrzenna bazy danych
* --------------------------------------------
* 
* Plik z zadaniami: ZSBD_cw_02.pdf
* 
* Pliki tworzące bazę do ćwiczeń: country_boundaries.sql, major_cities.sql, rivers.sql, streets_and_railroads.sql
* 
*/

--------------------------------------------------------
-- 1. Utwórz tabelę o nazwie FIGURY z dwoma kolumnami.
--	  a. ID - NUMER(1) - klucz podstawowy
--	  b. KSZTALT - MDSYS.SDO_GEOMETRY
	
	CREATE TABLE figury (id NUMBER(1) PRIMARY KEY
						,ksztalt MDSYS.SDO_GEOMETRY); 

--------------------------------------------------------
-- 2. Wstaw do tabeli FIGURY trzy pokazane na rysunku poniżej kształty
	
	INSERT INTO figury 
	VALUES 		(1
				,MDSYS.SDO_GEOMETRY(2003
									,NULL
									,NULL
									,MDSYS.SDO_ELEM_INFO_ARRAY(1
															  ,1003
															  ,4)
									,MDSYS.SDO_ORDINATE_ARRAY(7
															 ,5
															 ,5
															 ,7
															 ,3
															 ,5)
									)
				);
				
				
	INSERT INTO figury 
	VALUES 		(2
				,MDSYS.SDO_GEOMETRY(2003
									,NULL
									,NULL
									,MDSYS.SDO_ELEM_INFO_ARRAY(1
															  ,1003
															  ,3)
				,MDSYS.SDO_ORDINATE_ARRAY(1
										 ,1
										 ,5
										 ,5)
									)
				);
				
	INSERT INTO figury 
	VALUES 		(3
				,MDSYS.SDO_GEOMETRY(2002
									,NULL
									,NULL
									,MDSYS.SDO_ELEM_INFO_ARRAY(1
															  ,4
															  ,2
															  ,1
															  ,2
															  ,1
															  ,5
															  ,2
															  ,2)
				MDSYS.SDO_ORDINATE_ARRAY(3
										,2
										,6
										,2
										,7
										,3
										,8
										,2
										,7
										,1)
										)
				);

--------------------------------------------------------
-- 3. Dodaj do tabeli FIGURY geometrię nieprawidłową - zweryfikuj to funkcją
-- 	  SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT. Usuń nieprawidłową geometrię.
	
	INSERT INTO figury 
	VALUES 		(4
				,MDSYS.SDO_GEOMETRY(2003
									,NULL
									,NULL
									,MDSYS.SDO_ELEM_INFO_ARRAY(1
															  ,1003
															  ,4)
									,MDSYS.SDO_ORDINATE_ARRAY(7
															 ,5
															 ,5
															 ,7
															 ,4
															 ,8)
									)
				);
	
	SELECT 	id
			,SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) AS stan
	FROM 	figury;
	
	DELETE 
	FROM 	figury
	WHERE	SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01)<>'TRUE';
 
--------------------------------------------------------
-- 4. Zarejestruj stworzone przez Ciebie geometrie w słowniku bazy danych (metadanych). Domyślna
-- 	  tolerancja niech wynosi 0.01.

INSERT INTO USER_SDO_GEOM_METADATA 
VALUES ('FIGURY'
		,'KSZTALT'
		,MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X'
												  ,0
												  ,10
												  ,0.01)
		,MDSYS.SDO_DIM_ELEMENT('Y'
							  ,0
							  ,10
							  ,0.01))
		,NULL);
 
--------------------------------------------------------
-- 5. Stwórz indeks R-drzewo na utworzonej przez Ciebie tabeli.

	CREATE INDEX figury_idx ON figury(ksztalt)
	INDEXTYPE IS MDSYS.SPATIAL_INDEX;
 
--------------------------------------------------------
-- 6. Sprawdź za pomocą operatora SDO_FILTER, które z utworzonych geometrii mają coś
--	  wspólnego z punktem (3,3). Czy wynik jest prawidłowy? Zadaj to samo pytanie o punkty (5,5) i (7,2).
	
	SELECT 	id 
	FROM 	figury
	WHERE 	SDO_FILTER(ksztalt, MDSYS.SDO_GEOMETRY(2001, NULL,	MDSYS.SDO_POINT_TYPE(5, 5, NULL), NULL, NULL),'querytype=JOIN') = 'TRUE';
 
--------------------------------------------------------
-- 7. Wykorzystując operator SDO_NN i znajdź dziewięć najbliższych miast od Warszawy
	SELECT 	mc2.admin_name AS miasto
	FROM 	major_cities mc1
	JOIN	major_cities mc2 ON (mc1.id = mc2.id)
	WHERE 	SDO_NN(mc1.geom, mc2.geom,'sdo_num_res=10') = 'TRUE'
	AND 	mc1.admin_name = 'Warszawa' 
	AND 	mc2.admin_name != 'Warszawa';
	
--------------------------------------------------------
-- 8. Sprawdź które miasta znajdują się w odległości 100 km od Warszawy. Skorzystaj z operatora
--	  SDO_WITHIN_DISTANCE. Wynik porównaj z wynikiem z zadania powyżej.
	
	SELECT 	mc2.admin_name AS miasto
	FROM 	major_cities mc1
	JOIN	major_cities mc2 ON (mc1.id = mc2.id)
	WHERE	SDO_WITHIN_DISTANCE(mc1.geom, mc2.geom, 'distance=100 unit=KM') = 'TRUE'
	AND		mc1.admin_name = 'Warszawa' 
	AND		mc2.admin_name != 'Warszawa';

--------------------------------------------------------
-- 9. Korzystając z operatora SDO_RELATE wyświetl wszystkie miasta leżące na Słowacji.
	
	SELECT 	c.cntry_name AS kraj
			,m.city_name AS miasto
	FROM 	country_boundaries c, major_cities m
	WHERE 	SDO_RELATE(m.GEOM, c.GEOM, 'mask=INSIDE querytype=WINDOW') = 'TRUE'
	AND 	c.cntry_name = 'Slovakia';

--------------------------------------------------------
-- 10. Znajdź odległości pomiędzy Polską a krajami nie graniczącymi z nią. Wykorzystaj operator SDO_RELATE oraz funkcję SDO_DISTANCE.
	
	SELECT 	a.cntry_name AS panstwo
			,SDO_GEOM.SDO_DISTANCE(a.GEOM, pl.GEOM, 10, 'unit=KM') AS odl
	FROM 	country_boundaries a, country_boundaries pl
	WHERE 	SDO_RELATE(a.GEOM, pl.GEOM,	'mask=touch or equal querytype=WINDOW')<>'TRUE'
	AND 	pl.cntry_name = 'Poland';

--------------------------------------------------------
-- 11. Znajdź sąsiadów Polski oraz odczytaj długość granicy z każdym z nich..
	SELECT 	s.cntry_name
			,SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(s.GEOM, p.GEOM, 1), 1, 'unit=KM')
	FROM 	country_boundaries s, country_boundaries p
	WHERE 	SDO_RELATE(p.GEOM, s.GEOM, 'mask=TOUCH querytype=JOIN')	= 'TRUE'
	AND 	p.cntry_name = 'Poland';

--------------------------------------------------------
-- 12. Podaj nazwę Państwa, którego fragment przechowywany w bazie danych jest największy.
	SELECT 	s.cntry_name
	FROM 	country_boundaries s
	WHERE 	SDO_GEOM.SDO_AREA(s.GEOM,1) = (SELECT	MAX(SDO_GEOM.SDO_AREA(b.GEOM, 1))
										   FROM 	country_boundaries b);
 
--------------------------------------------------------
-- 13. Wyznacz pole minimalnego ograniczającego prostokąta (MBR), w którym znajdują się Warszawa i Łódź.
	SELECT 	SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(w.GEOM, l.GEOM, 1))
	FROM 	major_cities w, major_cities l
	WHERE 	w.city_name='Warsaw'
	AND 	l.city_name='Lodz' 

--------------------------------------------------------
-- 14. Podaj długość tych z rzek, które przepływają przez terytorium Polski. Ogranicz swoje obliczenia tylko do tych fragmentów, które leżą na terytorium Polski
	SELECT	DISTINCT a.name
			,SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(a.GEOM, b.GEOM, 10), 10, 'unit=KM'))
	FROM 	rivers a, country_boundaries b
	WHERE 	b.cntry_name = 'Poland'
	AND 	SDO_RELATE(b.GEOM, a.GEOM, 'mask=ANYINTERACT querytype=JOIN')='TRUE'
	GROUP BY a.name ; 

