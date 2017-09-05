set define off

DROP TABLE  LP3_WYKONAWCY cascade constraints purge;
DROP TABLE  LP3_UTWORY cascade constraints purge;
DROP TABLE  LP3_PROWADZACY cascade constraints purge;
DROP TABLE  LP3_NOTOWANIA cascade constraints purge;
DROP TABLE  LP3_MIEJSCA cascade constraints purge;

CREATE TABLE  LP3_WYKONAWCY 
   (	W_ID NUMBER(5,0) NOT NULL ENABLE, 
	W_NAZWA VARCHAR2(200) NOT NULL ENABLE, 
	W_ZAGRANICZNA VARCHAR2(1), 
	W_PODGATUNEK VARCHAR2(50), 
	W_INFO VARCHAR2(200), 
	 PRIMARY KEY (W_ID) ENABLE, 
	 UNIQUE (W_NAZWA) ENABLE
   );
CREATE TABLE  LP3_UTWORY 
   (	U_ID NUMBER(5,0) NOT NULL ENABLE, 
	U_W_ID NUMBER(5,0) NOT NULL ENABLE, 
	U_TYTUL VARCHAR2(200) NOT NULL ENABLE, 
	 PRIMARY KEY (U_ID) ENABLE, 
	 UNIQUE (U_W_ID, U_TYTUL) ENABLE
   );
CREATE TABLE  LP3_PROWADZACY 
   (	P_ID NUMBER(2,0) NOT NULL ENABLE, 
	P_NAZWISKO VARCHAR2(50) NOT NULL ENABLE, 
	P_IMIE VARCHAR2(30), 
	 PRIMARY KEY (P_ID) ENABLE, 
	 UNIQUE (P_NAZWISKO, P_IMIE) ENABLE
   );
CREATE TABLE  LP3_NOTOWANIA 
   (	N_ID NUMBER(3,0), 
	N_NR VARCHAR2(20) NOT NULL ENABLE, 
	N_DATA DATE NOT NULL ENABLE, 
	N_P_ID NUMBER(2,0), 
	 PRIMARY KEY (N_ID) ENABLE, 
	 UNIQUE (N_NR) ENABLE
   );
CREATE TABLE  LP3_MIEJSCA 
   (	M_U_ID NUMBER(5,0) NOT NULL ENABLE, 
	M_N_ID NUMBER(3,0) NOT NULL ENABLE, 
	M_LP NUMBER(2,0) NOT NULL ENABLE, 
	M_W_ID NUMBER(10,0), 
	 PRIMARY KEY (M_U_ID, M_N_ID, M_LP) ENABLE
   );
ALTER TABLE  LP3_MIEJSCA ADD CONSTRAINT M_W_FK FOREIGN KEY (M_W_ID)
	  REFERENCES  LP3_WYKONAWCY (W_ID) ENABLE;
ALTER TABLE  LP3_UTWORY ADD FOREIGN KEY (U_W_ID)
	  REFERENCES  LP3_WYKONAWCY (W_ID) ENABLE;
ALTER TABLE  LP3_MIEJSCA ADD FOREIGN KEY (M_U_ID)
	  REFERENCES  LP3_UTWORY (U_ID) ENABLE;
ALTER TABLE  LP3_MIEJSCA ADD FOREIGN KEY (M_N_ID)
	  REFERENCES  LP3_NOTOWANIA (N_ID) ENABLE;
ALTER TABLE  LP3_NOTOWANIA ADD FOREIGN KEY (N_P_ID)
	  REFERENCES  LP3_PROWADZACY (P_ID) ENABLE;

insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (155, 'Kenny Loggins', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (61, 'Lady Pank', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (137, 'Madness', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (39, 'Exodus', 'N', 'THRASH METAL', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (157, 'Jajco && Kanary', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (158, 'Styx', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (26, 'Ultravox', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (8, 'Budka Suflera', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (159, 'Fun Boy Three', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (24, 'Thin Lizzy', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (90, 'Pink Floyd', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (47, 'Republika', 'T', 'ROCK', 'c:\PLOUG\HTML\Republika.htm');
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (160, 'Bananarama', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (161, 'China Crisis', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (5, 'Perfect', 'N', 'ROCK', 'c:\PLOUG\HTML\perfect.jpg');
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (59, 'David Bowie', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (164, 'The Outsiders', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (12, 'Lombard', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (62, 'Duran Duran', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (83, 'Stanisław Wenglorz', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (165, 'Hak', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (145, 'Michael Jackson', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (166, 'Talas', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (107, 'RSC', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (2, 'Maanam', 'N', 'ROCK', 'c:\PLOUG\HTML\MAANAM.htm');
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (49, 'Bajm', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (132, 'Banda i Wanda', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (127, 'Culture Club', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (167, 'Blancmange', 'T', 'NEW WAVE', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (45, '2+1', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (3, 'AC/DC', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (4, 'TSA', 'N', 'HARD ROCK', 'c:\PLOUG\HTML\TSA.htm');
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (6, 'ABBA', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (7, 'Jethro Tull', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (9, 'Kombi', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (10, 'J. Geils Band', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (11, 'Kasa Chorych', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (13, 'Derek And The Dominos', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (14, 'Human League', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (15, 'Rod Stewart', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (16, 'Grupa ABC', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (17, 'Paul Davi', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (18, 'Stevie Nicks', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (181, 'Jon Anderson && Vangelis', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (19, 'Stevie Wonder', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (20, 'Lindsey Buckingham', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (21, 'Adrian John Loveridge', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (22, 'Klan', 'T', 'PROGRESSIVE ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (402, 'Rick Springfield', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (25, 'Air Supply', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (27, 'Piotr Schulz && Alex Band', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (28, 'Joan Jett && The Blackhearts', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (29, 'Paul McCartney && Stevie Wonder', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (30, 'Vangelis', 'T', 'ELECTRONIC', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (31, 'The Stranglers', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (32, 'Cytrus', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (33, 'Izabela Trojanowska', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (34, 'Elton John', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (35, 'Greg Gee', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (36, 'Dżem', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (37, 'The Beatles', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (38, 'Tight Fit', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (40, 'John Miles', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (41, 'Queen', 'T', 'ROCK', 'c:\PLOUG\HTML\queen.jpg');
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (42, 'Adrian Gurvitz', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (43, 'Scorpions', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (44, 'Iron Maiden', 'T', 'METAL', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (46, 'Asia', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (48, 'Kim Wilde', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (50, 'Martyna Jakubowicz', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (51, 'Krzysztof Cugowski', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (52, 'ToTo', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (53, 'Rainbow', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (54, 'Jon Anderson', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (55, 'Paul McCartney', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (56, 'Secret Service', 'T', 'DISCO', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (57, 'The Steve Miller Band', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (58, 'Mike Oldfield', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (60, 'Kansas', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (63, 'Fleetwood Mac', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (64, 'R.E.O. Speedwagon', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (130, 'Urszula', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (66, 'Genesis', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (67, 'Adam Ant', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (68, 'Donna Summer', 'T', 'DISCO', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (69, 'Turbo', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (70, 'Robert Plant', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (71, 'Survivor', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (72, 'Roxy Music', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (73, 'Cheap Trick', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (74, 'Judas Priest', 'T', 'METAL', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (75, 'Soft Cell', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (76, 'Nazareth', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (77, 'Trio', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (78, 'Halina Frąckowiak', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (79, 'ABC', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (80, 'Anex', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (81, 'Go-Go''', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (82, 'Midge Ure', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (84, 'Joanna Wyatt', 'T', null, null);
commit;
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (85, 'Phil Collins', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (86, 'Hot Chocolate', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (338, 'Chicago', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (88, 'Urszula && Budka Suflera', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (89, 'Stalowy Bagaż', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (91, 'Gary Brooker', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (92, 'Dire Straits', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (321, 'Frida', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (94, 'Flash And The Pan', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (95, 'Elżbieta Mielczarek', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (201, 'Yazoo', 'T', 'ELECTRONIC', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (97, 'Różowe Czuby', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (98, 'Krzak', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (99, 'Maryla Rodowicz', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (428, 'Glenn Frey', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (101, 'Oddział Zamknięty', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (102, 'The Animals', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (103, 'Kate Bush', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (353, 'Don Henley', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (105, 'Agnetha Faltskog && Tomas Ledin', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (106, 'Marek Biliński', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (109, 'Kim Carnes', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (110, 'Stanisław Wenglorz && ZOO', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (656, 'Supertramp', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (112, 'Wały Jagiellońskie', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (113, 'Michael Jackson && Paul McCartney', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (114, 'Jajco', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (115, 'Dionne Warwick', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (116, 'Kapitan Nemo', 'N', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (117, 'Budgie', 'T', 'HARD ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (118, 'Breakout', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (119, 'Daryl Hall && John Oates', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (120, 'Seweryn Krajewski', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (121, 'Diana Ross', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (122, 'Olivia Newton John', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (123, 'Jean Michel Jarre', 'T', 'ELECTRONIC', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (124, 'Jacek Skubikowski', 'N', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (125, 'Bank', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (126, 'Mark Knopfler && Phil Lynott', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (128, 'A Flock Of Seagulls', 'T', 'NEW WAVE', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (129, 'Rezerwat', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (131, 'Mech', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (241, 'Slade', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (134, 'Men At Work', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (135, 'Krystyna Prońko', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (136, 'UFO', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (138, 'Argus', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (139, 'Elvis Presley', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (140, 'Vox', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (295, 'Chris DeBurgh', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (142, 'Sting', 'T', 'ROCK', 'c:\PLOUG\HTML\sting.jpg');
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (143, 'Christopher Cross', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (144, 'Street', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (153, 'Spandau Ballet', 'T', 'POP', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (154, 'Potop', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (146, 'Bill Hughes', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (147, 'Tears For Fears', 'T', 'ROCK', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (148, 'Klincz', 'N', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (243, 'The Thompson Twins', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (150, 'Stratus', 'T', null, null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (151, 'Kissing The Pink', 'T', 'ALTERNATIVE', null);
insert into LP3_WYKONAWCY (W_ID, W_NAZWA, W_ZAGRANICZNA, W_PODGATUNEK, W_INFO)
values (152, 'Journey', 'T', 'ROCK', null);
commit;
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (256, 155, 'Welcome To Heartlight');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (257, 61, 'Kryzysowa narzeczona');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (258, 137, 'Tomorrow''s Just Another Day');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (259, 39, 'Praktyczny kolor');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (260, 157, 'Czerwony autobus');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (261, 158, 'Mr. Roboto');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (262, 26, 'Visions In Blue');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (263, 8, 'Czas ołowiu');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (264, 159, 'Tunel Of Love');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (265, 24, 'Cold Sweat');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (266, 90, 'The Hero');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (267, 47, 'Halucynacje');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (268, 160, 'Na Na Hey Hey Kiss Him Goodbye');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (269, 161, 'Christian');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (270, 5, 'Wyspa, drzewo, zamek');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (271, 90, 'The Gunner''s Dream');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (272, 59, 'Let''s Dance');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (273, 164, 'Down Come The Tears');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (274, 12, 'Bye, Bye Jimi');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (275, 62, 'Is There Something I Should Know?');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (276, 83, 'Okno z widokiem na parlament');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (277, 165, 'Ołowiane głowy');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (278, 145, 'Beat It');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (279, 166, 'Sink Your Teeth Into That');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (280, 107, 'Fabryka snów');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (281, 2, 'Kocham Cię, kochanie moje');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (282, 49, 'Nie ma wody na pustyni');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (283, 132, 'Stylowe ramy');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (284, 127, 'Church Of The Poison Mind');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (285, 167, 'Waves');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (255, 45, 'Requiem dla samej siebie');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (2, 2, 'O! Nie rób tyle hałasu');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (3, 3, 'For Those About To Rock');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (4, 4, '51');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (5, 5, 'Opanuj się');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (6, 6, 'Visitors');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (7, 7, 'Flying Colours');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (8, 5, 'Pepe Wróć');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (9, 8, 'Teraz rób co chcesz');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (10, 9, 'Słodka jest noc');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (11, 10, 'Freeze Frame');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (12, 11, 'Przed nami drzwi zamknięte');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (13, 12, 'O jeden dreszcz');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (14, 13, 'Layla');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (15, 14, 'Do Or Die');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (16, 15, 'How Long');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (17, 16, 'Asfaltowe łąki');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (18, 17, '''65 Love Affair');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (19, 18, 'Edge Of Seventeen');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (1, 181, 'I''ll Find My Way Home');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (20, 19, 'That Girl');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (21, 20, 'Trouble');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (22, 12, 'Droga pani z TV');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (23, 21, '400 Dragons');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (24, 22, 'Z brzytwą na poziomki');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (25, 402, 'Don''t Talk To Strangers');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (26, 9, 'Królowie życia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (27, 24, 'Angel Of Death');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (28, 25, 'Sweet Dreams');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (29, 26, 'I Remember');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (30, 27, 'Czy możemy sami żyć');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (31, 28, 'I Love Rock And Roll');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (32, 29, 'Ebony And Ivory');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (33, 8, 'Bez satysfakcji');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (34, 5, 'Lokomotywa z ogłoszenia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (35, 30, 'Chariots Of Fire');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (36, 31, 'Golden Brown');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (37, 32, 'Kurza twarz');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (38, 33, 'Brylanty');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (39, 34, 'Empty Garden');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (40, 35, 'Rainbow Bridge');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (41, 36, 'Ballada o malarzu');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (42, 37, 'The Beatles Movie Medley');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (43, 38, 'The Lion Sleeps Tonight');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (44, 39, 'Piosenka bez sensu');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (45, 40, 'Music');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (46, 41, 'Body Language');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (47, 8, 'Kto zrobił mi ten żart');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (48, 42, 'Classic');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (49, 43, 'When The Smoke Is Going Down');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (50, 44, 'The Number Of The Beast');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (51, 4, 'Chodzą ludzie');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (52, 2, 'Paranoja jest goła');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (53, 39, 'Niedawno tak, pewnego dnia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (54, 45, 'Nic nie boli');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (55, 46, 'Heat Of The Moment');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (56, 47, 'Kombinat');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (57, 48, 'View From The Bridge');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (58, 9, 'Smak czerwonego wina');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (59, 49, 'W drodze do jej serca');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (60, 50, 'Kłopoty to jej specjalność');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (61, 43, 'No One Like You');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (62, 51, 'Zamiast kołysanki');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (63, 12, 'Ostatni taniec');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (64, 2, 'Espana Forever');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (65, 52, 'Rosanna');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (66, 53, 'Stone Cold');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (67, 54, 'Surrender');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (68, 6, 'When All Is Said And Done');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (69, 34, 'Blue Eyes');
commit;
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (70, 41, 'Las Palabras De Amor');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (71, 41, 'Staying Power');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (72, 55, 'Tug Of War');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (73, 56, 'Flash In The Night');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (74, 57, 'Abracadabra');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (75, 33, 'Karmazynowa noc');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (76, 19, 'Ribbon In The Sky');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (77, 58, 'Five Miles Out');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (78, 59, 'Cat People');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (79, 60, 'Play The Game Tonight');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (80, 61, 'Mała Lady Punk');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (81, 62, 'Hungry Like The Wolf');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (82, 2, 'Oprócz');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (83, 63, 'Hold Me, Thrill Me, Kiss Me, Kill Me');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (84, 64, 'Keep The Fire Burning');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (85, 130, 'Fatamorgana ''82');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (86, 4, 'Spółka');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (87, 66, 'Paperlate');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (88, 67, 'Goody Two Shoes');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (89, 68, 'Love Is In Control');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (90, 69, 'Dorosłe dzieci');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (91, 5, 'Chcemy być sobą');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (92, 70, 'Slow Dancer');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (93, 46, 'Sole Survival');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (94, 71, 'Eye Of The Tiger');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (95, 72, 'Avalon');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (96, 73, 'If You Want My Love');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (97, 74, 'Riding On The Wind');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (98, 75, 'Torch');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (99, 50, 'W domach z betonu nie ma wolnej miłości');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (100, 76, 'Dream On');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (101, 77, 'Da Da Da');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (102, 68, 'State Of Independence');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (103, 39, 'Jeszcze czekam');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (104, 78, 'Anna już tu nie mieszka');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (105, 70, 'Moonlight In Samosa');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (106, 60, 'Play On');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (107, 5, 'Nie bój się tego wszystkiego');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (108, 79, 'The Look Of Love');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (109, 80, 'East Valencia Drive');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (110, 81, 'Vacation');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (111, 11, 'Boogie dziadka Skiby');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (112, 82, 'No Regrets');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (113, 83, 'Emanueli część trzecia i ostatnia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (114, 84, 'Stupid Cupid');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (115, 5, 'Pocztówka do państwa Jareckich');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (116, 85, 'In The Air Tonight');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (117, 86, 'It started With A Kiss');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (118, 61, 'Minus 10 w Rio');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (119, 2, 'Jest już późno, piszę bzdury');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (120, 5, 'Autobiografia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (121, 33, 'Obce dni');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (122, 338, 'Hard To Say I''m Sorry');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (123, 88, 'Bogowie i demony');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (124, 4, 'Zwierzenia kontestatora');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (125, 63, 'Gipsy');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (126, 89, 'Synowie nocy');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (127, 90, 'When The Tigers Broke Free');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (128, 12, '?mierć dyskotece');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (129, 91, 'The Angler');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (130, 91, 'Lead Me To The Water');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (131, 92, 'Private Investigations');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (132, 321, 'I Know There''s Something Going On');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (133, 26, 'Reap The Wild Wind');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (134, 94, 'Waiting For A Train');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (135, 66, 'Evidence Of Autumn');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (136, 95, 'Poczekalnia PKP');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (137, 75, 'What');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (138, 41, 'Calling All Girls');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (139, 201, 'Don''t Go');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (140, 31, 'Strange Little Girl');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (141, 97, 'Dentysta sadysta');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (142, 47, 'Sexy Doll');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (143, 98, 'Kim jesteś');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (144, 99, 'Siedzę w Mławie');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (145, 428, 'She Can''t Let Go');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (146, 72, 'Take A Chance With Me');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (147, 2, 'Pałac (na piasku)');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (148, 101, 'Ten wasz świat');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (149, 102, 'House Of The Rising Sun');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (150, 103, 'All The Love');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (151, 92, 'Badges, Posters, Stickers And T-Shirts');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (152, 353, 'Johnny Can''t Read');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (153, 9, 'Inwazja z Plutona');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (154, 105, 'Never Again');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (155, 47, 'Telefony');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (156, 61, 'Tańcz, głupia tańcz');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (157, 6, 'The Day Before You Came');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (158, 106, 'Fontanna radości');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (159, 12, 'Taniec pingwina na szkle');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (160, 2, 'Parada nadzwyczaj wielkich słoni');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (161, 4, 'Trzy zapałki');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (162, 107, 'Życie jest teatrem');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (163, 50, 'Wielka fala');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (164, 85, 'Thru'' these Walls');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (165, 49, 'Józek, nie daruję Ci tej nocy');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (166, 109, 'Voyeur');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (167, 110, 'Stutonowy walec');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (168, 656, 'It''s Raining Again');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (169, 64, 'Sweet Time');
commit;
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (170, 112, 'Kukuła disco');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (171, 113, 'The Girl Is Mine');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (172, 8, 'Jolka, Jolka pamiętasz...');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (173, 114, 'Żółty pierścionek');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (174, 115, 'Heartbreaker');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (175, 116, 'Elektroniczna cywilizacja');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (176, 95, 'Wielkie koło');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (177, 14, 'Mirror Man');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (178, 31, 'European Female');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (179, 12, 'Diamentowa kula');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (180, 117, 'Hold On To Love');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (181, 118, 'To mój blues');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (182, 119, 'Maneater');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (183, 85, 'Do You Know Do You Care');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (184, 120, 'Jan Serce');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (185, 26, 'Hymn');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (186, 121, 'Muscles');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (187, 122, 'Heartattack');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (188, 5, 'Co za hałas, co za szum');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (189, 47, 'Biała flaga');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (190, 49, 'Różowa kula');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (191, 123, 'Souvenire Of China');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (192, 124, 'Dobre miejsce dla naiwnych');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (193, 125, 'Mija czas i nic');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (194, 126, 'Ode To Liberty');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (195, 89, 'Morze ognia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (196, 2, 'Nie poganiaj mnie, bo tracę oddech');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (197, 77, 'Anna, Let Me In, Let Me Out');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (198, 127, 'Do You Really Want To Hurt Me?');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (199, 128, 'Wishing');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (200, 6, 'Cassandra');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (201, 4, 'Na co Cię stać');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (202, 115, 'All The Love In The World');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (203, 129, 'Obserwator');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (204, 33, 'Nic naprawdę');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (205, 6, 'Under Attack');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (206, 5, 'Objazdowe, nieme kino');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (207, 130, 'Luz blues w niebie same dziury');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (208, 131, 'Jak to możliwe');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (209, 132, 'Fabryka marzeń');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (210, 85, 'You Can''t Hurry Love');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (211, 47, 'Gadające głowy');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (212, 241, 'C''Est La Vie (And Now The Waltz)');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (213, 134, 'Down Under');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (214, 61, 'Vademecum skauta');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (215, 135, 'Jesteś lekiem na całe zło');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (216, 136, 'Let It Rain');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (217, 107, 'Kradniesz mi moją duszę');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (218, 137, 'Our House');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (219, 138, 'Bal masek');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (220, 12, 'Znowu radio');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (221, 2, 'Granice');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (222, 139, 'The Elvis Medley');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (223, 140, 'Szczęśliwej drogi, już czas');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (224, 26, 'We Came To Dance');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (225, 117, 'Alison');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (226, 107, 'Bez znieczulenia');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (227, 295, 'Don''t Pay The Ferryman');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (228, 142, 'Spread A Little Happiness');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (229, 47, '?mierć w bikini');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (230, 4, 'Bez podtekstów');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (231, 95, 'Down And Out');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (232, 143, 'All Right');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (233, 52, 'Africa');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (234, 144, 'Dziewczyna o brązowych oczach');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (235, 8, 'Noc komety');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (236, 145, 'Billie Jean');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (237, 92, 'Twisting By The Pool');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (238, 75, 'Where The Heart Is');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (252, 135, 'Bożek gorzelny');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (253, 153, 'Communication');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (254, 154, 'Na oślep');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (239, 31, 'Midnight Summer Dream');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (240, 9, 'Nie ma jak szpan');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (241, 5, 'Idź precz');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (242, 129, 'Histeria');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (243, 146, 'Martin Eden');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (244, 147, 'Change');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (245, 2, 'Elektro Spiro Kontra Zanzara');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (246, 148, 'Słodki doping');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (247, 243, 'We''re Detective');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (248, 150, 'Spojrzenie zza krat');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (249, 151, 'The Last Film');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (250, 132, 'Cała biała');
insert into LP3_UTWORY (U_ID, U_W_ID, U_TYTUL)
values (251, 152, 'Separate Ways');
commit;
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (14, 'Baron', 'Piotr');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (17, 'Dragan', 'Alina');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (3, 'Kaczkowski', 'Piotr');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (2, 'Kawecki', 'Jarosław');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (21, 'Kostrzewa', 'Paweł');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (10, 'Majewski', 'Piotr');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (6, 'Mann', 'Wojciech');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (12, 'Miecugow', 'Grzegorz');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (1, 'Niedźwiecki', 'Marek');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (7, 'Niedźwiecki, Roman Rogowiecki', 'Marek');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (19, 'Pawlikowska', 'Beata');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (16, 'Pawlukiewicz', 'Marek');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (4, 'Rogowiecki', 'Roman');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (8, 'Sitek, Paweł Sito', 'Bożena');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (11, 'Sito', 'Paweł');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (24, 'Stelmach', 'Piotr');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (13, 'Strzyczkowski, Sławomir Szczęśniak', 'Kuba');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (15, 'Turowski', 'Rafał');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (18, 'Wiernik', 'Marek');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (5, 'Zamorski', 'Wojciech');
insert into LP3_PROWADZACY (P_ID, P_NAZWISKO, P_IMIE)
values (23, 'Żąda', 'Tomasz');
commit;
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (1, '1', to_date('24-04-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (2, '3', to_date('08-05-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (3, '4', to_date('15-05-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (4, '5', to_date('22-05-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (5, '6', to_date('29-05-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (6, '7', to_date('05-06-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (7, '9', to_date('19-06-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (8, '8', to_date('12-06-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (9, '10', to_date('26-06-1982', 'dd-mm-yyyy'), 2);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (10, '11', to_date('03-07-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (11, '12', to_date('10-07-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (12, '14', to_date('24-07-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (13, '15', to_date('31-07-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (14, '13', to_date('17-07-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (15, '16', to_date('07-08-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (16, '18', to_date('21-08-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (17, '17', to_date('14-08-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (18, '19', to_date('28-08-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (19, '21/22', to_date('18-09-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (20, '20', to_date('04-09-1982', 'dd-mm-yyyy'), 3);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (21, '23', to_date('25-09-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (22, '24', to_date('02-10-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (23, '25', to_date('09-10-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (24, '27', to_date('23-10-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (25, '26', to_date('16-10-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (26, '30', to_date('13-11-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (27, '29', to_date('06-11-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (28, '28', to_date('30-10-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (29, '31', to_date('20-11-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (30, '32', to_date('27-11-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (31, '33', to_date('04-12-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (32, '34', to_date('11-12-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (33, '35', to_date('18-12-1982', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (34, '36/37/38', to_date('08-01-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (35, '39', to_date('15-01-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (36, '42', to_date('05-02-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (37, '41', to_date('29-01-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (38, '40', to_date('22-01-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (39, '43', to_date('12-02-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (40, '44', to_date('19-02-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (41, '45', to_date('26-02-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (42, '48', to_date('19-03-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (43, '47', to_date('12-03-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (44, '46', to_date('05-03-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (45, '49', to_date('26-03-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (46, '51', to_date('09-04-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (47, '50', to_date('02-04-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (48, '52', to_date('16-04-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (49, '53', to_date('23-04-1983', 'dd-mm-yyyy'), 1);
insert into LP3_NOTOWANIA (N_ID, N_NR, N_DATA, N_P_ID)
values (50, '54', to_date('30-04-1983', 'dd-mm-yyyy'), 1);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 18, 3, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 18, 4, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (100, 18, 5, 76);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (96, 18, 6, 73);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 18, 7, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 18, 8, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 18, 9, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (102, 18, 10, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 18, 11, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (103, 18, 12, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 18, 13, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 18, 14, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (98, 18, 15, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 18, 16, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (104, 18, 17, 78);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (107, 18, 18, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (97, 18, 19, 74);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 18, 20, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (93, 18, 21, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (113, 18, 22, 83);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (114, 18, 23, 84);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (94, 18, 24, 71);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (106, 18, 25, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 18, 26, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 18, 27, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (116, 18, 28, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (112, 18, 29, 82);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (117, 18, 30, 86);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 19, 1, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 19, 2, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (100, 19, 3, 76);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 19, 4, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (103, 19, 5, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (107, 19, 6, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (118, 19, 7, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 19, 8, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 19, 9, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (113, 19, 10, 83);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 19, 11, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (102, 19, 12, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 19, 13, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 19, 14, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (116, 19, 15, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (104, 19, 16, 78);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 19, 17, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 19, 18, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 19, 19, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (117, 19, 20, 86);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 19, 21, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 19, 22, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (111, 19, 23, 11);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (112, 19, 24, 82);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (123, 19, 25, 88);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (124, 19, 26, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 19, 27, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (126, 19, 28, 89);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (127, 19, 29, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (128, 19, 30, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 20, 1, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 20, 2, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 20, 3, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 20, 4, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 20, 5, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 20, 6, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (103, 20, 7, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 20, 8, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (107, 20, 9, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (102, 20, 10, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (113, 20, 11, 83);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (96, 20, 12, 73);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (118, 20, 13, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 20, 14, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 20, 15, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (116, 20, 16, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (97, 20, 17, 74);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 20, 18, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 20, 19, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (129, 20, 20, 91);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (117, 20, 21, 86);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (114, 20, 22, 84);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 20, 23, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (111, 20, 24, 11);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (106, 20, 25, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (93, 20, 26, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (130, 20, 27, 91);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (112, 20, 28, 82);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 20, 29, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (109, 20, 30, 80);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 21, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 21, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 21, 3, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 21, 4, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 21, 5, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (131, 21, 6, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 21, 7, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (100, 21, 8, 76);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 21, 9, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (113, 21, 10, 83);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (118, 21, 11, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (116, 21, 12, 85);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 21, 13, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (107, 21, 14, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (103, 21, 15, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 21, 16, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (124, 21, 16, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (128, 21, 17, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 21, 18, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 21, 19, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 21, 20, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (112, 21, 20, 82);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 21, 21, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (126, 21, 21, 89);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (127, 21, 22, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (123, 21, 23, 88);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 21, 24, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (134, 21, 25, 94);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (111, 21, 26, 11);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 21, 27, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (136, 21, 28, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (137, 21, 29, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (129, 21, 30, 91);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 22, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 22, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 22, 3, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 22, 4, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 22, 5, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (131, 22, 6, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 22, 7, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (124, 22, 8, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 22, 9, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 22, 10, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (100, 22, 11, 76);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (116, 22, 12, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 22, 13, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (128, 22, 14, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (127, 22, 15, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (118, 22, 16, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 22, 17, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 22, 18, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (136, 22, 19, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (112, 22, 20, 82);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (126, 22, 21, 89);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (123, 22, 22, 88);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (134, 22, 23, 94);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 22, 24, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 22, 25, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 22, 26, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (137, 22, 27, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 22, 28, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (129, 22, 29, 91);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 22, 30, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 23, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 23, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 23, 3, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 23, 4, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (131, 23, 5, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 23, 6, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (124, 23, 6, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (127, 23, 7, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 23, 8, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 23, 9, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 23, 10, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 23, 11, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (128, 23, 12, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 23, 13, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (134, 23, 14, 94);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (141, 23, 15, 97);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 23, 16, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 23, 17, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (126, 23, 18, 89);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (136, 23, 19, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 23, 20, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (123, 23, 21, 88);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 23, 22, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 23, 23, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 23, 24, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (137, 23, 25, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (143, 23, 26, 98);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 23, 27, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (129, 23, 28, 91);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (144, 23, 29, 99);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (145, 23, 30, 428);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (146, 23, 30, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 24, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 24, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 24, 3, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 24, 4, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (131, 24, 5, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 24, 6, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 24, 7, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 24, 8, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 24, 9, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 24, 10, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (124, 24, 11, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 24, 12, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 24, 13, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (127, 24, 14, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 24, 15, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (141, 24, 16, 97);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (123, 24, 17, 88);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 24, 18, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (149, 24, 18, 102);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 24, 19, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 24, 20, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (137, 24, 21, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 24, 22, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (145, 24, 23, 428);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (143, 24, 24, 98);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 24, 25, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (146, 24, 26, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (151, 24, 27, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 24, 28, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (153, 24, 29, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (154, 24, 30, 105);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 25, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (131, 25, 2, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 25, 3, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 25, 4, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 25, 5, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 25, 6, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 25, 7, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (124, 25, 8, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 25, 9, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 25, 9, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (127, 25, 10, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 25, 11, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (115, 25, 12, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (141, 25, 13, 97);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 25, 14, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 25, 15, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 25, 16, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (136, 25, 17, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (134, 25, 18, 94);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 25, 19, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (123, 25, 20, 88);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 25, 21, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 25, 22, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (149, 25, 23, 102);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (145, 25, 24, 428);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (137, 25, 25, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (143, 25, 26, 98);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 25, 27, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (146, 25, 28, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (129, 25, 29, 91);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 25, 30, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 26, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 26, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 26, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 26, 4, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 26, 5, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 26, 6, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (156, 26, 7, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (149, 26, 8, 102);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 26, 9, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 26, 10, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 26, 11, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 26, 12, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (158, 26, 13, 106);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 26, 15, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 26, 16, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 26, 18, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (161, 26, 19, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 26, 21, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (154, 26, 23, 105);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (164, 26, 25, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 26, 26, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (166, 26, 28, 109);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 26, 30, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 27, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 27, 4, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (149, 27, 6, 102);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 27, 8, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 27, 9, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 27, 11, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 27, 12, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 27, 14, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 27, 16, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (159, 27, 17, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (158, 27, 19, 106);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (153, 27, 21, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 27, 23, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 27, 25, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 27, 26, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (164, 27, 28, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (162, 27, 30, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 28, 2, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 28, 4, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 28, 6, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 28, 7, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 28, 9, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (121, 28, 11, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (131, 28, 13, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (119, 28, 14, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (149, 28, 16, 102);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (143, 28, 18, 98);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (145, 28, 19, 428);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (125, 28, 21, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 28, 23, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 28, 25, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (169, 28, 26, 64);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (154, 28, 28, 105);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (151, 28, 30, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 29, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 29, 3, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 29, 5, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 29, 7, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 29, 9, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 29, 11, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 29, 12, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (158, 29, 13, 106);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (149, 29, 15, 102);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (159, 29, 17, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 29, 19, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (164, 29, 21, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (165, 29, 23, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 29, 25, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (175, 29, 27, 116);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (176, 29, 28, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 29, 30, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 30, 2, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 30, 4, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 30, 5, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 30, 7, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 30, 9, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (156, 30, 11, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 30, 13, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (138, 30, 15, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 30, 16, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 30, 18, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 30, 20, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (164, 30, 22, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (173, 30, 24, 114);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 30, 26, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (176, 30, 28, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (181, 30, 30, 118);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 31, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 31, 3, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 31, 5, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 31, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 31, 8, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 31, 10, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 31, 12, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 31, 14, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 31, 16, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 31, 18, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 31, 19, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (165, 31, 21, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (176, 31, 23, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (181, 31, 25, 118);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (183, 31, 27, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (185, 31, 29, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (186, 31, 30, 121);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 32, 2, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 32, 4, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 32, 6, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (161, 32, 8, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 32, 9, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 32, 11, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (171, 32, 13, 113);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 32, 15, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (175, 32, 17, 116);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (182, 32, 19, 119);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (176, 32, 21, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (173, 32, 23, 114);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (183, 32, 25, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (184, 32, 27, 120);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (186, 32, 29, 121);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 33, 1, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 33, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 33, 4, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 33, 6, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 33, 8, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 33, 10, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 33, 11, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (182, 33, 13, 119);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 33, 15, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (190, 33, 17, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (181, 33, 18, 118);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 33, 20, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (178, 33, 22, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (193, 33, 24, 125);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (183, 33, 26, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (186, 33, 27, 121);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (173, 33, 28, 114);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (187, 33, 29, 122);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (195, 33, 30, 89);

insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (165, 33, 30, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 34, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 34, 2, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 34, 3, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 34, 4, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 34, 5, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (182, 34, 6, 119);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 34, 7, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 34, 8, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (185, 34, 9, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 34, 10, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (190, 34, 11, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 34, 12, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 34, 13, 5);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 34, 14, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 34, 15, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 34, 16, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (171, 34, 17, 113);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (188, 34, 18, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (193, 34, 19, 125);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (178, 34, 20, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 34, 21, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (197, 34, 22, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (192, 34, 23, 124);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (187, 34, 24, 122);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 34, 25, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 34, 26, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (200, 34, 27, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (201, 34, 28, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (202, 34, 29, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (194, 34, 30, 126);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 35, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 35, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 35, 3, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (188, 35, 4, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 35, 5, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 35, 6, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 35, 7, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (182, 35, 8, 119);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (197, 35, 9, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (190, 35, 10, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (201, 35, 11, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 35, 12, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (203, 35, 13, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (185, 35, 14, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 35, 15, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (204, 35, 16, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (193, 35, 17, 125);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (205, 35, 18, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (178, 35, 19, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 35, 20, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 35, 21, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (202, 35, 22, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 35, 23, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (207, 35, 24, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (187, 35, 25, 122);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 35, 26, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (209, 35, 27, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (192, 35, 28, 124);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (200, 35, 29, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 35, 30, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 36, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 36, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 36, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 36, 4, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (211, 36, 5, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (197, 36, 6, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 36, 7, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 36, 8, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 36, 9, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 36, 10, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (205, 36, 11, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (201, 36, 12, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (204, 36, 13, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 36, 14, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (207, 36, 15, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 36, 16, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (203, 36, 17, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 36, 17, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 36, 18, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 36, 19, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 36, 20, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (209, 36, 21, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (216, 36, 22, 136);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 36, 23, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 36, 24, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (219, 36, 25, 138);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 36, 26, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (221, 36, 27, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 36, 28, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 36, 29, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 36, 30, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 36, 30, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 37, 1, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 37, 2, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 37, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (197, 37, 4, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (211, 37, 5, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 37, 6, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 37, 7, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (201, 37, 8, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 37, 9, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (203, 37, 10, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 37, 11, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 37, 12, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 37, 13, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (204, 37, 14, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 37, 15, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (207, 37, 16, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (205, 37, 17, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 37, 18, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (190, 37, 19, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 37, 20, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 37, 21, 61);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (202, 37, 22, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (209, 37, 23, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 37, 24, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 37, 25, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (226, 37, 26, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 37, 27, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 37, 28, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (216, 37, 29, 136);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 37, 30, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 38, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 38, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 38, 3, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 38, 4, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 38, 5, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (197, 38, 6, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (188, 38, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (201, 38, 8, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (190, 38, 9, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (203, 38, 10, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 38, 11, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (211, 38, 12, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 38, 13, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 38, 14, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (204, 38, 15, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 38, 16, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (193, 38, 17, 125);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (207, 38, 18, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (205, 38, 19, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 38, 20, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (202, 38, 21, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 38, 22, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (209, 38, 23, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 38, 24, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 38, 25, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 38, 26, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 38, 27, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 38, 28, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (187, 38, 29, 122);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (216, 38, 30, 136);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 39, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 39, 2, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 39, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 39, 4, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 39, 5, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 39, 6, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (211, 39, 7, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 39, 8, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 39, 9, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 39, 10, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 39, 11, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 39, 12, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 39, 13, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (197, 39, 14, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 39, 15, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (205, 39, 16, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 39, 16, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (201, 39, 17, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 39, 18, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (216, 39, 19, 136);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (221, 39, 20, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 39, 21, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (209, 39, 22, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 39, 23, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (219, 39, 24, 138);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 39, 25, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 39, 26, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 39, 27, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 39, 28, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (227, 39, 29, 295);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (228, 39, 30, 142);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 40, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 40, 2, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 40, 3, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 40, 4, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 40, 5, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 40, 6, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 40, 7, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 40, 8, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 40, 9, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (189, 40, 10, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 40, 11, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (221, 40, 12, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (199, 40, 13, 128);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 40, 14, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (191, 40, 15, 123);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 40, 16, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (211, 40, 17, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)

values (223, 40, 18, 140);

insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 40, 18, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (216, 40, 19, 136);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 40, 20, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 40, 21, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 40, 22, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 40, 23, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (231, 40, 24, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (227, 40, 25, 295);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (209, 40, 26, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (232, 40, 27, 143);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (233, 40, 28, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (234, 40, 29, 144);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 40, 30, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (228, 40, 30, 142);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 41, 1, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 41, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 41, 3, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 41, 4, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 41, 5, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 41, 6, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 41, 7, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (208, 41, 8, 131);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 41, 9, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (221, 41, 10, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 41, 12, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 41, 13, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 41, 14, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 41, 16, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 41, 18, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (227, 41, 20, 295);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (231, 41, 22, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 41, 23, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (232, 41, 25, 143);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (238, 41, 27, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 41, 29, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 42, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 42, 2, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 42, 4, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 42, 6, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 42, 8, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (237, 42, 10, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (240, 42, 11, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 42, 13, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 42, 15, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (243, 42, 17, 146);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 42, 18, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (246, 42, 20, 148);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (232, 42, 22, 143);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 42, 24, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (251, 42, 26, 152);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (253, 42, 28, 153);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (255, 42, 30, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 42, 30, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 43, 2, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 43, 4, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 43, 6, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 43, 8, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 43, 9, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 43, 11, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 43, 12, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 43, 14, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 43, 16, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (227, 43, 18, 295);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (237, 43, 20, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (248, 43, 22, 150);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (232, 43, 24, 143);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 43, 26, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (250, 43, 28, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (253, 43, 30, 153);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 44, 2, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 44, 4, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (206, 44, 6, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (221, 44, 8, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 44, 9, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 44, 11, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 44, 13, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 44, 15, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (214, 44, 16, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (215, 44, 18, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (233, 44, 19, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 44, 21, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (240, 44, 23, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (231, 44, 25, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (232, 44, 26, 143);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (248, 44, 27, 150);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 44, 29, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 45, 1, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 45, 3, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 45, 5, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 45, 7, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 45, 9, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (240, 45, 10, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (257, 45, 12, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 45, 13, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (220, 45, 15, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 45, 17, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (248, 45, 19, 150);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (250, 45, 21, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (252, 45, 23, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (254, 45, 25, 154);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (259, 45, 27, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (232, 45, 29, 143);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 46, 1, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 46, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (257, 46, 4, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 46, 6, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 46, 8, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 46, 10, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 46, 11, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 46, 13, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (251, 46, 15, 152);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (258, 46, 17, 137);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 46, 19, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (259, 46, 21, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (260, 46, 23, 157);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (264, 46, 25, 159);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (261, 46, 27, 158);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (267, 46, 29, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (269, 46, 30, 161);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 47, 2, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 47, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 47, 5, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 47, 7, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (243, 47, 9, 146);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 47, 10, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (237, 47, 12, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 47, 14, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 47, 16, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (248, 47, 18, 150);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (250, 47, 20, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (258, 47, 22, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 47, 24, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (260, 47, 26, 157);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (265, 47, 28, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (263, 47, 30, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (257, 48, 1, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 48, 3, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 48, 5, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 48, 7, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 48, 9, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 48, 11, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 48, 13, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (243, 48, 15, 146);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (253, 48, 17, 153);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (251, 48, 19, 152);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (271, 48, 21, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (259, 48, 22, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (260, 48, 23, 157);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (255, 48, 25, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (269, 48, 27, 161);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (273, 48, 29, 164);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (257, 49, 1, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 49, 3, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (270, 49, 5, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 49, 7, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 49, 8, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 49, 10, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 49, 12, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (263, 49, 14, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (272, 49, 16, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (262, 49, 17, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (275, 49, 18, 62);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (269, 49, 19, 161);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (260, 49, 20, 157);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (273, 49, 21, 164);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (255, 49, 22, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (261, 49, 23, 158);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (274, 49, 24, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (268, 49, 25, 160);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (276, 49, 26, 83);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (277, 49, 27, 165);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (278, 49, 28, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (279, 49, 29, 166);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (280, 49, 30, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (270, 50, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (257, 50, 2, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (267, 50, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 50, 4, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 50, 5, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (281, 50, 6, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 50, 7, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (275, 50, 8, 62);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 50, 9, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (272, 50, 10, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (271, 50, 11, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (263, 50, 12, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 50, 13, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 50, 14, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (273, 50, 15, 164);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 50, 16, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (269, 50, 17, 161);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (282, 50, 18, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (262, 50, 19, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 50, 20, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (255, 50, 21, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (278, 50, 22, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (277, 50, 23, 165);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (274, 50, 24, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (261, 50, 25, 158);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (283, 50, 26, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (276, 50, 27, 83);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (284, 50, 28, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (285, 50, 29, 167);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (280, 50, 30, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (2, 1, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 1, 3, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 1, 4, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (5, 1, 5, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (6, 1, 6, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (7, 1, 7, 7);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (8, 1, 8, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (9, 1, 9, 8);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (10, 1, 10, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (11, 1, 11, 10);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (12, 1, 12, 11);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (13, 1, 13, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (14, 1, 14, 13);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (15, 1, 15, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (16, 1, 16, 15);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (17, 1, 17, 16);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (18, 1, 18, 17);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (19, 1, 19, 18);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (20, 1, 20, 19);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (21, 1, 21, 20);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (22, 1, 22, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (23, 1, 23, 21);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (24, 1, 24, 22);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (25, 1, 25, 402);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (26, 1, 26, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 1, 27, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (28, 1, 28, 25);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (29, 1, 29, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (30, 1, 30, 27);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (2, 2, 1, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 2, 3, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 2, 4, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (32, 2, 5, 29);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (1, 2, 6, 181);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (5, 2, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (8, 2, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (6, 2, 8, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (33, 2, 9, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (14, 2, 10, 13);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (1, 1, 1, 181);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (12, 2, 11, 11);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (7, 2, 12, 7);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 2, 13, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 2, 14, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (36, 2, 15, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (13, 2, 16, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (20, 2, 17, 19);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (10, 2, 18, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (37, 2, 19, 32);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (23, 2, 20, 21);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 2, 21, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 2, 22, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (39, 2, 23, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 2, 24, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 2, 25, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 2, 26, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (43, 2, 27, 38);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (44, 2, 28, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (45, 2, 29, 40);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (25, 2, 30, 402);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 3, 1, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 3, 2, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (2, 3, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (32, 3, 4, 29);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 3, 5, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (1, 3, 6, 181);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 3, 7, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 3, 8, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (33, 3, 9, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 3, 10, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (8, 3, 11, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (6, 3, 12, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (5, 3, 13, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (36, 3, 14, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 3, 15, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (39, 3, 16, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (7, 3, 17, 7);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (37, 3, 18, 32);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (23, 3, 19, 21);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 3, 20, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 3, 21, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 3, 22, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (48, 3, 23, 42);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 3, 24, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 3, 25, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (43, 3, 26, 38);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 3, 27, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 3, 28, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 3, 29, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 3, 30, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 4, 1, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 4, 2, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (2, 4, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 4, 4, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (32, 4, 5, 29);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 4, 6, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 4, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (1, 4, 8, 181);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 4, 9, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 4, 10, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (33, 4, 11, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 4, 12, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (36, 4, 13, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (39, 4, 14, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (8, 4, 15, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (23, 4, 16, 21);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 4, 17, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (6, 4, 18, 6);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 4, 19, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 4, 20, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 4, 21, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (48, 4, 22, 42);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 4, 23, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 4, 24, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (43, 4, 25, 38);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 4, 26, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (53, 4, 27, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 4, 28, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 4, 29, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 4, 30, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 5, 1, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 5, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 5, 3, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (32, 5, 4, 29);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 5, 5, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (2, 5, 6, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 5, 7, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 5, 8, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 5, 9, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 5, 10, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 5, 11, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 5, 12, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (36, 5, 13, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (39, 5, 14, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (1, 5, 15, 181);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (33, 5, 16, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 5, 17, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 5, 18, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (48, 5, 19, 42);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 5, 20, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 5, 21, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 5, 22, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 5, 23, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (43, 5, 24, 38);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 5, 25, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 5, 26, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (53, 5, 27, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 5, 28, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (57, 5, 29, 48);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (58, 5, 30, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 6, 1, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 6, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 6, 3, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 6, 4, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 6, 5, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (32, 6, 6, 29);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 6, 7, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 6, 8, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 6, 9, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 6, 10, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 6, 11, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 6, 12, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (36, 6, 13, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 6, 14, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (2, 6, 15, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (39, 6, 16, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 6, 17, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 6, 17, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (48, 6, 18, 42);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 6, 19, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 6, 20, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 6, 21, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 6, 22, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 6, 23, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (57, 6, 24, 48);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (53, 6, 25, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (59, 6, 26, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 6, 27, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 6, 28, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (58, 6, 29, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (62, 6, 30, 51);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 7, 1, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 7, 2, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 7, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 7, 4, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 7, 5, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 7, 6, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 7, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 7, 8, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 7, 9, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 7, 10, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 7, 11, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 7, 12, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 7, 13, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 7, 14, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 7, 15, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 7, 16, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 7, 17, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 7, 18, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (57, 7, 19, 48);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (59, 7, 20, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (53, 7, 21, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 7, 22, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 7, 23, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 7, 24, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 7, 25, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 7, 26, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 7, 27, 43);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (58, 7, 28, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 7, 29, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 7, 30, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 8, 1, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 8, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 8, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 8, 4, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 8, 5, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 8, 6, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (4, 8, 7, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 8, 8, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 8, 9, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (34, 8, 10, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (32, 8, 11, 29);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (31, 8, 12, 28);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 8, 13, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 8, 14, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 8, 15, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (27, 8, 16, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (41, 8, 17, 36);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 8, 18, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 8, 19, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 8, 20, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (57, 8, 21, 48);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (59, 8, 22, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (53, 8, 23, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 8, 24, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 8, 25, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (62, 8, 26, 51);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 8, 27, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (58, 8, 28, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 8, 29, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 8, 30, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 9, 1, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 9, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 9, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 9, 4, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 9, 5, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 9, 6, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 9, 7, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 9, 8, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 9, 9, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 9, 10, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 9, 11, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 9, 12, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (57, 9, 13, 48);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 9, 14, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (59, 9, 15, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 9, 16, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (69, 9, 17, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 9, 18, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 9, 19, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (47, 9, 20, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (71, 9, 21, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 9, 22, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 9, 23, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (40, 9, 24, 35);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (3, 9, 25, 3);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (38, 9, 26, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (53, 9, 27, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (73, 9, 29, 56);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 10, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 10, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 10, 5, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 10, 6, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 10, 8, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 10, 10, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 10, 12, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 10, 14, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (51, 10, 16, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (59, 10, 18, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 10, 20, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 10, 22, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 10, 24, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (76, 10, 26, 19);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (78, 10, 28, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (73, 10, 30, 56);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 11, 2, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 11, 4, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 11, 5, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 11, 7, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 11, 9, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 11, 11, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 11, 13, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 11, 15, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 11, 17, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 11, 19, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 11, 21, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 11, 23, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (71, 11, 25, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (81, 11, 27, 62);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 11, 29, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 12, 1, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 12, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 12, 5, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 12, 7, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 12, 9, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 12, 11, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 12, 13, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 12, 15, 45);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 12, 17, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 12, 19, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 12, 21, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (78, 12, 23, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 12, 25, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (81, 12, 27, 62);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (89, 12, 29, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 13, 1, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 13, 3, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 13, 5, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 13, 7, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (86, 13, 9, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 13, 11, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 13, 13, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 13, 15, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 13, 17, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 13, 19, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 13, 21, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 13, 23, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (79, 13, 25, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (93, 13, 27, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (94, 13, 29, 71);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 14, 1, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 14, 3, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 14, 4, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 14, 6, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 14, 8, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 14, 10, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 14, 12, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (56, 14, 14, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 14, 16, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (69, 14, 18, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 14, 20, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (78, 14, 22, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (79, 14, 24, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (76, 14, 26, 19);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 14, 28, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (86, 14, 30, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 15, 2, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 15, 4, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 15, 6, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (96, 15, 8, 73);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 15, 10, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 15, 12, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 15, 14, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 15, 16, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 15, 18, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 15, 20, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (88, 15, 22, 67);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (92, 15, 24, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (94, 15, 26, 71);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (79, 15, 28, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 15, 30, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 16, 2, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 16, 4, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 16, 6, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (100, 16, 8, 76);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (102, 16, 10, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 16, 12, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 16, 14, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (98, 16, 16, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 16, 18, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 16, 19, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (93, 16, 21, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 16, 23, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (107, 16, 25, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (109, 16, 27, 80);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (111, 16, 29, 11);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (112, 16, 30, 82);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (96, 17, 2, 73);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 17, 5, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 17, 6, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 17, 8, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 17, 10, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 17, 12, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 17, 14, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 17, 16, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 17, 18, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 17, 20, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (104, 17, 22, 78);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 17, 24, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (98, 17, 25, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (109, 17, 27, 80);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 17, 29, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (88, 17, 30, 67);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 18, 2, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 26, 14, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (159, 26, 17, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 26, 19, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (153, 26, 20, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (162, 26, 22, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 26, 24, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (165, 26, 27, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (167, 26, 29, 110);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 27, 1, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 27, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 27, 5, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 27, 7, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 27, 10, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (135, 27, 12, 66);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (156, 27, 13, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 27, 15, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (143, 27, 18, 98);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 27, 20, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 27, 22, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (154, 27, 24, 105);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (161, 27, 27, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (167, 27, 29, 110);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 28, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 28, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (122, 28, 5, 338);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (140, 28, 8, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 28, 10, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 28, 12, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (133, 28, 15, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 28, 17, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (156, 28, 19, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (159, 28, 20, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (158, 28, 22, 106);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (150, 28, 24, 103);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (170, 28, 27, 112);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (153, 28, 29, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 29, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (105, 29, 4, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 29, 6, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (156, 29, 8, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (161, 29, 10, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (132, 29, 12, 321);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (162, 29, 14, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (139, 29, 16, 201);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 29, 18, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (171, 29, 20, 113);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 29, 22, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (173, 29, 24, 114);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 29, 26, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (167, 29, 29, 110);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 30, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 30, 3, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 30, 6, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 30, 8, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (161, 30, 10, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (147, 30, 12, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (158, 30, 14, 106);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (162, 30, 17, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (171, 30, 19, 113);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (175, 30, 21, 116);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (165, 30, 23, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (178, 30, 25, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 30, 27, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 30, 29, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 31, 2, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (174, 31, 4, 115);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (157, 31, 6, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (161, 31, 9, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 31, 11, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (171, 31, 13, 113);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (148, 31, 15, 101);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (175, 31, 17, 116);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 31, 20, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (178, 31, 22, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (173, 31, 24, 114);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (182, 31, 26, 119);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (184, 31, 28, 120);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 32, 1, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (160, 32, 3, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 32, 5, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (120, 32, 7, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (177, 32, 10, 14);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (142, 32, 12, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (179, 32, 14, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (152, 32, 16, 353);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (181, 32, 18, 118);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 32, 20, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (178, 32, 22, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (185, 32, 24, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (165, 32, 26, 49);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (187, 32, 28, 122);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (188, 32, 30, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (172, 33, 2, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (163, 33, 5, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (155, 33, 7, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (168, 33, 9, 656);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (171, 33, 12, 113);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (185, 33, 14, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (175, 33, 16, 116);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 33, 17, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (176, 33, 19, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (188, 33, 21, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (192, 33, 23, 124);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (194, 33, 25, 126);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 41, 11, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (180, 41, 14, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (210, 41, 15, 85);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 41, 17, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (196, 41, 19, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (233, 41, 21, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (237, 41, 24, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 41, 26, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (228, 41, 28, 142);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (240, 41, 30, 9);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 42, 3, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 42, 5, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 42, 7, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 42, 9, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 42, 12, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 42, 14, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 42, 16, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 42, 18, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 42, 19, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 42, 21, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (248, 42, 23, 150);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (250, 42, 25, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (252, 42, 27, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (254, 42, 29, 154);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 43, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 43, 3, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 43, 5, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 43, 7, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (224, 43, 9, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 43, 10, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (213, 43, 13, 134);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (240, 43, 15, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (221, 43, 17, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (233, 43, 19, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (246, 43, 21, 148);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 43, 23, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 43, 25, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (231, 43, 27, 95);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 43, 29, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 44, 1, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (225, 44, 3, 117);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (218, 44, 5, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (212, 44, 7, 241);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (198, 44, 10, 127);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (223, 44, 12, 140);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 44, 14, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 44, 17, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (227, 44, 19, 295);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (237, 44, 20, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 44, 22, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (246, 44, 24, 148);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (234, 44, 27, 144);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 44, 28, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (250, 44, 30, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 45, 2, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 45, 4, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 45, 6, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (237, 45, 8, 92);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (243, 45, 11, 146);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (222, 45, 13, 139);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 45, 14, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (217, 45, 16, 107);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 45, 18, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (253, 45, 20, 153);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (258, 45, 22, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (251, 45, 24, 152);

insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 45, 26, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (260, 45, 28, 157);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (261, 45, 30, 158);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 46, 3, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 46, 5, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 46, 7, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (243, 46, 9, 146);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 46, 12, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (253, 46, 14, 153);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (254, 46, 16, 154);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (252, 46, 18, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (250, 46, 20, 132);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (262, 46, 22, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (263, 46, 24, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (265, 46, 26, 24);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (266, 46, 28, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (268, 46, 30, 160);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 47, 1, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 47, 4, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 47, 6, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (257, 47, 8, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (235, 47, 10, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 47, 11, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (244, 47, 13, 147);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (240, 47, 15, 9);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (251, 47, 17, 152);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (253, 47, 19, 153);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (252, 47, 21, 135);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (259, 47, 23, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (254, 47, 25, 154);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (262, 47, 27, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (261, 47, 29, 158);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (267, 48, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (245, 48, 4, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (247, 48, 6, 243);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (229, 48, 8, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (241, 48, 10, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (242, 48, 12, 129);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (230, 48, 14, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (258, 48, 16, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (270, 48, 18, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (263, 48, 20, 8);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (262, 48, 23, 26);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (272, 48, 24, 59);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (261, 48, 26, 158);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (268, 48, 28, 160);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (274, 48, 30, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (267, 49, 2, 47);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (239, 49, 4, 31);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (236, 49, 6, 145);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (249, 49, 9, 151);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (256, 49, 11, 155);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (271, 49, 13, 90);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (258, 49, 15, 137);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 9, 28, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 9, 30, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 10, 2, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (42, 10, 4, 37);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 10, 5, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (46, 10, 7, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 10, 9, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 10, 11, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (69, 10, 13, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (35, 10, 15, 30);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 10, 17, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (57, 10, 19, 48);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 10, 21, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 10, 23, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (71, 10, 25, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 10, 27, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (79, 10, 29, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 11, 1, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 11, 3, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (49, 11, 5, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 11, 6, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 11, 8, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 11, 10, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 11, 12, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (69, 11, 14, 34);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 11, 16, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (50, 11, 18, 44);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 11, 20, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (78, 11, 22, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (79, 11, 24, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (76, 11, 26, 19);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 11, 28, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 11, 30, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 12, 2, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 12, 4, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 12, 6, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 12, 8, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 12, 10, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 12, 12, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 12, 14, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 12, 16, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (86, 12, 18, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (55, 12, 20, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 12, 22, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (79, 12, 24, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 12, 26, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (88, 12, 28, 67);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 12, 30, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 13, 2, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 13, 4, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 13, 6, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 13, 8, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (61, 13, 10, 43);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (68, 13, 12, 6);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (65, 13, 14, 52);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 13, 16, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 13, 18, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (78, 13, 20, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 13, 22, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (88, 13, 24, 67);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (92, 13, 26, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (89, 13, 28, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (95, 13, 30, 72);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 14, 2, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 14, 3, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 14, 5, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (54, 14, 7, 45);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (60, 14, 9, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (66, 14, 11, 53);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (52, 14, 13, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (72, 14, 15, 55);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 14, 17, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (67, 14, 19, 54);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 14, 21, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 14, 23, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (81, 14, 25, 62);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 14, 27, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 14, 29, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 15, 1, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (75, 15, 3, 33);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (86, 15, 5, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (82, 15, 7, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 15, 9, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (63, 15, 11, 12);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 15, 13, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 15, 15, 69);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (87, 15, 17, 66);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (78, 15, 19, 59);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 15, 21, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (97, 15, 23, 74);
commit;
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (93, 15, 25, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (98, 15, 27, 75);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 15, 29, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 16, 1, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (96, 16, 3, 73);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 16, 5, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (70, 16, 7, 41);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (101, 16, 9, 77);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (83, 16, 11, 63);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 16, 13, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (103, 16, 15, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (104, 16, 17, 78);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (80, 16, 20, 61);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (106, 16, 22, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (94, 16, 24, 71);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (108, 16, 26, 79);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (110, 16, 28, 81);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (77, 17, 1, 58);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (91, 17, 3, 5);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (85, 17, 4, 130);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (86, 17, 7, 4);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (64, 17, 9, 2);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (74, 17, 11, 57);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (102, 17, 13, 68);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (99, 17, 15, 50);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (100, 17, 17, 76);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (84, 17, 19, 64);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (97, 17, 21, 74);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (103, 17, 23, 39);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (92, 17, 24, 70);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (93, 17, 26, 46);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (106, 17, 28, 60);
insert into LP3_MIEJSCA (M_U_ID, M_N_ID, M_LP, M_W_ID)
values (90, 18, 1, 69);
commit;
