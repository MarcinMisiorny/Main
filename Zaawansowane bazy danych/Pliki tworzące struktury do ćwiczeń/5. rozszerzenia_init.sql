--
-- user_analit/user_analit@lab10g
--

drop table produkcja cascade constraints;
drop table produkty cascade constraints;
drop view prod_prod;

create table PRODUKTY
( produkt_id number(2) primary key,
  nazwa varchar2(15) not null,
  kategoria varchar2(15) not null);

create table PRODUKCJA
( ilosc_prod number(4) not null,
  ilosc_sprzed number (4) not null,
  produkt_id number(2) not null,
  miesiac number(2) not null,
  rok number(4) not null,
  constraint prod_fk foreign key (produkt_id) references produkty(produkt_id));

insert into produkty values (1, 'krzes³o A', 'meble kuchenne');
insert into produkty values (2, 'fotel A', 'meble salonowe');
insert into produkty values (3, 'stó³ dêbowy', 'meble kuchenne');
insert into produkty values (4, 'stó³ jesion', 'meble salonowe');
insert into produkty values (5, 'krzes³o plastik', 'meble ogrodowe');
insert into produkty values (6, 'stó³ plastik', 'meble ogrodowe');

insert into produkcja values (50, 40, 1, 1, 2000);
insert into produkcja values (55, 51, 1, 2, 2000);
insert into produkcja values (30, 15, 2, 1, 2000);
insert into produkcja values (20, 15, 2, 2, 2000);
insert into produkcja values (10,  8, 3, 1, 2000);
insert into produkcja values (10, 10, 3, 2, 2000);
insert into produkcja values (15,  9, 4, 1, 2000);
insert into produkcja values (15, 11, 4, 2, 2000);
insert into produkcja values (70, 69, 5, 1, 2000);
insert into produkcja values (80, 76, 5, 2, 2000);
insert into produkcja values (55, 35, 6, 1, 2000);
insert into produkcja values (60, 25, 6, 2, 2000);

insert into produkcja values (65, 45, 1, 1, 2001);
insert into produkcja values (65, 55, 1, 2, 2001);
insert into produkcja values (35, 35, 2, 1, 2001);
insert into produkcja values (30, 25, 2, 2, 2001);
insert into produkcja values (15, 14, 3, 1, 2001);
insert into produkcja values (15, 10, 3, 2, 2001);

insert into produkcja values (60, 49, 1, 3, 2000);

commit;

create or replace view prod_prod
as 
select nazwa, kategoria, ilosc_prod, ilosc_sprzed, miesiac, rok
from produkcja pa, produkty pr
where pa.produkt_id=pr.produkt_id;
