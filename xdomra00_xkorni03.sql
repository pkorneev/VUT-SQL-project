drop table osoba CASCADE CONSTRAINTS;
drop table zamestnanec CASCADE CONSTRAINTS;
drop table rezervace_stolku CASCADE CONSTRAINTS;
drop table rezervace_salonku CASCADE CONSTRAINTS;
drop table sprava_rezervace_salonku CASCADE CONSTRAINTS;
drop table objednavka_jidla CASCADE CONSTRAINTS;
drop table napln_objednavky_jidla CASCADE CONSTRAINTS;
drop table chody CASCADE CONSTRAINTS;
drop table napln_objednavky_potravin CASCADE CONSTRAINTS;
drop table potraviny CASCADE CONSTRAINTS;
drop table objednavka_potravin CASCADE CONSTRAINTS;
drop table napln_chodu CASCADE CONSTRAINTS;
drop table jidelni_listek CASCADE CONSTRAINTS;
drop table napln_menu CASCADE CONSTRAINTS;

set serveroutput on

create table osoba
(
    rodne_cislo         VARCHAR2(255) NOT NULL PRIMARY KEY,
    jmeno               VARCHAR2(255) NOT NULL,
    prijmeni            VARCHAR2(255) NOT NULL,
    telefonni_cislo     VARCHAR2(13),
    email               VARCHAR2(255),
    typ                 VARCHAR2(255),

    constraint chk_rc check(regexp_like(rodne_cislo, '^[0-9]{2,6}/[0-9]{4}$')),
    constraint chk_tc check(regexp_like(telefonni_cislo, '^\+420\d{9}$|^\d{9}$|^\d{3}[ -]\d{3}[ -]\d{3}$')),
    constraint chk_em check(regexp_like(email, '^\w+(\.\w*)*@\w+(\.\w+)+$')),
    constraint chk_ty check(typ in ('zamestnanec', 'zakaznik'))
);


create table zamestnanec
(
    rodne_cislo     VARCHAR2(255) NOT NULL REFERENCES osoba(rodne_cislo),
    pozice          VARCHAR2(255) NOT NULL,

    PRIMARY KEY(rodne_cislo, pozice),
    constraint chk_poz check(pozice in ('sef', 'manazer', 'cisnik', 'other'))
);


create table rezervace_stolku
(
    rezst_id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rc_zakaznika    VARCHAR2(255) NOT NULL REFERENCES osoba(rodne_cislo),
    datum_od        TIMESTAMP NOT NULL,
    datum_do        TIMESTAMP NOT NULL,
    status          VARCHAR2(255) NOT NULL,
    poznamka        VARCHAR2(255),
    cislo_stolku    INT NOT NULL,

    constraint chk_status_stol check(status in ('platna', 'neplatna', 'vyprsela'))
);


create table rezervace_salonku
(
    rezsal_id              INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rc_zakaznika    VARCHAR2(255) NOT NULL REFERENCES osoba(rodne_cislo),
    datum_od        TIMESTAMP  NOT NULL,
    datum_do        TIMESTAMP NOT NULL,
    status          VARCHAR2(255) NOT NULL,
    poznamka        VARCHAR2(255),
    nazev_salonku   VARCHAR2(255) NOT NULL,
    cena_rezervace  INT NOT NULL,


    constraint chk_status_sal check(status in ('platna', 'neplatna', 'vyprsela'))
);


create table sprava_rezervace_salonku
(
    rc_spravce      VARCHAR2(255) NOT NULL REFERENCES osoba(rodne_cislo),
    id_rezervace    INT NOT NULL REFERENCES rezervace_salonku(rezsal_id),

    PRIMARY KEY(rc_spravce, id_rezervace)
);


create table objednavka_jidla
(
    obj_id              INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rc_zakaznika    VARCHAR2(255) NOT NULL REFERENCES osoba(rodne_cislo),
    status          VARCHAR2(255) NOT NULL,
    datum           TIMESTAMP NOT NULL,
    cena            INT NOT NULL,

    constraint chk_status_obj check(status in ('zaplaceno', 'nezaplaceno'))
);

create table chody
(
    nazev       VARCHAR2(255) NOT NULL PRIMARY KEY,
    recept      VARCHAR2(255),
    cena        INT NOT NULL

);

create table napln_objednavky_jidla
(
    id_objednavky   INT NOT NULL REFERENCES objednavka_jidla(obj_id),
    nazev_chodu     VARCHAR2(255) NOT NULL REFERENCES chody(nazev),

    PRIMARY KEY(id_objednavky, nazev_chodu)

);


create table objednavka_potravin
(
    objpot_id                 INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rc_zodpovedneho    VARCHAR2(255) NOT NULL REFERENCES osoba(rodne_cislo),
    cena               INT NOT NULL

);


create table potraviny
(
    nazev  VARCHAR2(255) NOT NULL PRIMARY KEY
);


create table napln_objednavky_potravin
(
    id_objednavky       INT NOT NULL REFERENCES objednavka_potravin(objpot_id) PRIMARY KEY,
    mnozstvi            INT NOT NULL,
    nazev_potravin      VARCHAR2(255) NOT NULL REFERENCES  potraviny(nazev)

);


create table napln_chodu
(
    nazev_chodu         VARCHAR2(255) NOT NULL REFERENCES chody(nazev),
    nazev_potravin      VARCHAR2(255) NOT NULL REFERENCES potraviny(nazev),
    mnozstvi            INT,

    PRIMARY KEY(nazev_chodu, nazev_potravin)
);



create table jidelni_listek
(
     nazev  VARCHAR2(255) NOT NULL PRIMARY KEY
);


create table napln_menu
(
    nazev_menu     VARCHAR2(255) NOT NULL REFERENCES jidelni_listek(nazev),
    nazev_chodu    VARCHAR2(255) NOT NULL REFERENCES chody(nazev),

    PRIMARY KEY(nazev_menu, nazev_chodu)
);



--zamestnanci
INSERT INTO osoba VALUES('986312/4915', 'V?t?zslav', 'Novotn?', '', 'john.doe@example.com', 'zamestnanec');
INSERT INTO osoba VALUES('010923/2740', 'Karol?na', 'Mare?ov?', '555-987-654', 'jane.smith@example.com', 'zamestnanec');
INSERT INTO osoba VALUES('027402/8162', 'Radek', '?imek', '555-987-654', 'jane.smith@example.com', 'zamestnanec');
INSERT INTO osoba VALUES('974127/6041', 'Eli?ka', 'Havelkov?', '555-222-333', 'jessica.murphy@example.com', 'zamestnanec');


INSERT INTO osoba VALUES('974112/6041', 'Tom', 'Shelby', '555-222-999', 'jessica.james@example.com', 'zamestnanec');
INSERT INTO osoba VALUES('974101/6041', 'Tom', 'Jerey', '555-222-123', 'jessica.adams@example.com', 'zamestnanec');
INSERT INTO osoba VALUES('974456/6041', 'Mike', 'Wazovski', '555-222-223', 'jessica.jess@example.com', 'zamestnanec');
INSERT INTO osoba VALUES('974443/6041', 'Martina', 'Kavalcova', '555-222-345', 'jessica.kaval@example.com', 'zamestnanec');

--zakaznici
INSERT INTO osoba VALUES('880611/1638', 'Michal', '?ern?', '555-444-333', 'brian.baker@example.com', 'zakaznik');
INSERT INTO osoba VALUES('045829/6843', 'Tereza', 'Svobodov?', '', 'philip.johnson@example.com', 'zakaznik');
INSERT INTO osoba VALUES('788320/0411', 'Marek', 'Posp??il', '555-999-444', '', 'zakaznik');


INSERT INTO zamestnanec VALUES('986312/4915', 'sef');
INSERT INTO zamestnanec VALUES('010923/2740', 'manazer');
INSERT INTO zamestnanec VALUES('027402/8162', 'cisnik');
INSERT INTO zamestnanec VALUES('974127/6041', 'cisnik');

--'platna', 'neplatna', 'vyprsela'
INSERT INTO rezervace_stolku(rc_zakaznika, datum_od, datum_do, status, poznamka, cislo_stolku)
    VALUES('880611/1638', TO_TIMESTAMP('21.03.2023 10:19:23', 'DD-MM-YYYY HH24:MI:SS'),
           TO_TIMESTAMP('21.03.2023 13:19:23', 'DD-MM-YYYY HH24:MI:SS'), 'platna', 'kouri', 5);
INSERT INTO rezervace_stolku(rc_zakaznika, datum_od, datum_do, status, poznamka, cislo_stolku)
    VALUES('045829/6843', TO_TIMESTAMP('21.03.2020 12:19:23','DD-MM-YYYY HH24:MI:SS'),
           TO_TIMESTAMP('21.03.2020 15:19:23','DD-MM-YYYY HH24:MI:SS'), 'vyprsela', 'ma alergii na mleko', 25);







INSERT INTO rezervace_salonku(rc_zakaznika, datum_od, datum_do, status, poznamka, nazev_salonku, cena_rezervace)
    VALUES('788320/0411', TO_TIMESTAMP('25.03.2023 10:19:23','DD-MM-YYYY HH24:MI:SS'),
           TO_TIMESTAMP('25.03.2023 22:19:23','DD-MM-YYYY HH24:MI:SS'), 'platna', 'narozeniny', 'clown room', 15000);


INSERT INTO sprava_rezervace_salonku VALUES('010923/2740', 1);


INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
    VALUES('880611/1638', 'nezaplaceno', TO_TIMESTAMP('21.03.2023 10:19:23', 'DD-MM-YYYY HH24:MI:SS'), 1100);
INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
    VALUES('045829/6843', 'zaplaceno', TO_TIMESTAMP('21.03.2023 11:19:23', 'DD-MM-YYYY HH24:MI:SS'), 200);
INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
    VALUES('045829/6843', 'zaplaceno', TO_TIMESTAMP('22.03.2023 11:19:23', 'DD-MM-YYYY HH24:MI:SS'), 600);
INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
    VALUES('045829/6843', 'zaplaceno', TO_TIMESTAMP('23.03.2023 11:19:23', 'DD-MM-YYYY HH24:MI:SS'), 300);
INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
    VALUES('045829/6843', 'zaplaceno', TO_TIMESTAMP('24.03.2023 11:19:23', 'DD-MM-YYYY HH24:MI:SS'), 1200);
INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
    VALUES('045829/6843', 'zaplaceno', TO_TIMESTAMP('25.03.2023 11:19:23', 'DD-MM-YYYY HH24:MI:SS'), 700);


INSERT INTO chody VALUES('smazeny kureci rizek s brambory', '', 500);
INSERT INTO chody VALUES('bramborovy salat', '', 350);
INSERT INTO chody VALUES('bramborova kase', '', 150);
INSERT INTO chody VALUES('cockova polevka', '', 200);
INSERT INTO chody VALUES('ryze s knedliky', '', 200);
INSERT INTO chody VALUES('rib eye steak', '', 1200);
INSERT INTO chody VALUES('New York steak', '', 1000);
INSERT INTO chody VALUES('T-bone steak', '', 1800);


INSERT INTO napln_objednavky_jidla VALUES(1, 'smazeny kureci rizek s brambory');
INSERT INTO napln_objednavky_jidla VALUES(1, 'cockova polevka');
INSERT INTO napln_objednavky_jidla VALUES(2, 'ryze s knedliky');


INSERT INTO potraviny VALUES('ryze');
INSERT INTO potraviny VALUES('brambory');
INSERT INTO potraviny VALUES('kureci maso');
INSERT INTO potraviny VALUES('cocky');
INSERT INTO potraviny VALUES('vejce');
INSERT INTO potraviny VALUES('mouka');


INSERT INTO napln_chodu VALUES('smazeny kureci rizek s brambory', 'kureci maso', 1);
INSERT INTO napln_chodu VALUES('smazeny kureci rizek s brambory', 'brambory', 2);
INSERT INTO napln_chodu VALUES('bramborovy salat', 'brambory', 1);
INSERT INTO napln_chodu VALUES('bramborova kase', 'brambory', 3);
INSERT INTO napln_chodu VALUES('cockova polevka', 'cocky', '');
INSERT INTO napln_chodu VALUES('ryze s knedliky', 'ryze', '');
INSERT INTO napln_chodu VALUES('ryze s knedliky', 'vejce', 3);
INSERT INTO napln_chodu VALUES('ryze s knedliky', 'mouka', '');


INSERT INTO objednavka_potravin(rc_zodpovedneho, cena) VALUES('986312/4915', 20000);


INSERT INTO napln_objednavky_potravin VALUES(1, 10, 'vejce');


INSERT INTO jidelni_listek VALUES('letni');
INSERT INTO jidelni_listek VALUES('zimni');
INSERT INTO jidelni_listek VALUES('detske');
INSERT INTO jidelni_listek VALUES('veganske');


INSERT INTO napln_menu VALUES('letni', 'bramborovy salat');
INSERT INTO napln_menu VALUES('letni', 'bramborova kase');
INSERT INTO napln_menu VALUES('detske', 'bramborovy salat');
INSERT INTO napln_menu VALUES('detske', 'bramborova kase');
INSERT INTO napln_menu VALUES('letni', 'smazeny kureci rizek s brambory');
INSERT INTO napln_menu VALUES('letni', 'cockova polevka');
INSERT INTO napln_menu VALUES('letni', 'ryze s knedliky');
INSERT INTO napln_menu VALUES('zimni', 'ryze s knedliky');
INSERT INTO napln_menu VALUES('zimni', 'smazeny kureci rizek s brambory');
INSERT INTO napln_menu VALUES('veganske', 'cockova polevka');



----------------PRIKAZY SELECT--------------
--ktere chody obsahuji brambory
SELECT nazev
FROM chody C, napln_chodu N
WHERE C.nazev = N.nazev_chodu
    AND N.nazev_potravin = 'brambory';

--jaky je e-mail sefa restaurace
SELECT email
FROM osoba O, zamestnanec Z
WHERE O.rodne_cislo = Z.rodne_cislo
    AND Z.pozice = 'sef';

-- vsechny chody, obsahujici brambory a nazev jidelniho listku,
-- do ktereho se patri
SELECT J.nazev, M.nazev_chodu
FROM jidelni_listek J
INNER JOIN napln_menu M
ON J.nazev = M.nazev_menu
INNER JOIN napln_chodu C
ON M.nazev_chodu = C.nazev_chodu
    AND C.nazev_potravin = 'brambory';


--chody, ktere nepatri do zadneho jidelniho listku
SELECT C.nazev
FROM chody C
WHERE NOT EXISTS(
    SELECT *
        FROM napln_menu N
        WHERE C.nazev = N.nazev_chodu
    );

--kolik chodu obsahuje kazdy jidelni listek sestupne
SELECT NAZEV_MENU, COUNT(*)
FROM NAPLN_MENU
GROUP BY NAZEV_MENU
ORDER BY COUNT(*) DESC;

--cena nejdrazsiho chodu z kazdeho jidelniho listku
SELECT M.nazev_menu, MAX(C.cena)
FROM chody C
INNER JOIN napln_menu M ON M.NAZEV_CHODU = C.nazev
GROUP BY M.NAZEV_MENU;

--vsechny chody drazsi nez 200kc z detskeho jidelniho listku
SELECT C.nazev
FROM chody C
WHERE C.nazev IN(
    SELECT N.NAZEV_CHODU
        FROM napln_menu N
        WHERE N.NAZEV_MENU = 'detske'
            AND C.CENA > 200
    );

-------------------- POSLEDNI CAST ------------------------


--procedury

--vezme vsechny radky, kde je typ sloupce "zamestnanec"
--a vrati "jmeno" a "prijmeni" sloupce pro kazdy radek pomoci DBMS_output
CREATE OR REPLACE PROCEDURE vyber_zamestnanci
    IS
    CURSOR zamestnanci IS
    SELECT * FROM osoba WHERE typ = 'zamestnanec';
    v_osoba osoba%ROWTYPE;
    BEGIN
    OPEN zamestnanci;
        FETCH zamestnanci INTO v_osoba;
        WHILE zamestnanci%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE(v_osoba.jmeno || ' ' || v_osoba.prijmeni);
            FETCH zamestnanci INTO v_osoba;
        END LOOP;
    CLOSE zamestnanci;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Nastala   chyba: ' || SQLERRM);
END;
/
CALL vyber_zamestnanci();

--procedura spocitta cenu vsech chodu
-- cursor all_chody vezme sloupec cena pak bude iterovat po radcich
-- a pocitat cenu chodu abychom ziskali celkovou cenu vsech chodu
CREATE OR REPLACE PROCEDURE spocitej_cenu AS
  celkova_cena chody.cena%type := 0;
  CURSOR all_chody IS SELECT cena FROM chody;
BEGIN

    FOR chod IN all_chody LOOP
        celkova_cena := celkova_cena + chod.cena;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Celkova cena vsech jidel: ' || celkova_cena);
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Nepodarilo se spocitat celkovou cenu: ' || SQLERRM);
END;
/
CALL spocitej_cenu();


--pristupova prava
GRANT ALL ON osoba TO XKORNI03;
GRANT ALL ON zamestnanec TO XKORNI03;
GRANT ALL ON rezervace_stolku TO XKORNI03;
GRANT ALL ON rezervace_salonku TO XKORNI03;
GRANT ALL ON sprava_rezervace_salonku TO XKORNI03;
GRANT ALL ON objednavka_jidla TO XKORNI03;
GRANT ALL ON napln_objednavky_jidla TO XKORNI03;
GRANT ALL ON chody TO XKORNI03;
GRANT ALL ON napln_objednavky_potravin TO XKORNI03;
GRANT ALL ON potraviny TO XKORNI03;
GRANT ALL ON objednavka_potravin TO XKORNI03;
GRANT ALL ON napln_chodu TO XKORNI03;
GRANT ALL ON jidelni_listek TO XKORNI03;
GRANT ALL ON napln_menu TO XKORNI03;
GRANT ALL ON prefered_reservations TO XKORNI03;
GRANT EXECUTE ON vyber_zamestnanci   TO XKORNI03;
GRANT EXECUTE ON spocitej_cenu  TO XKORNI03;


--SELECT WITH CASE
--tento select dotaz prida sloupec "velikost  objednavky"
--velikost objednavky muze byt 3 ruzne druhy
--Velka ( >1000Kc)
--stredni ( >500 < 1000)
--mala (>500)

WITH objednavka AS (
    SELECT
        obj_id, rc_zakaznika, status, datum, cena,
    CASE
        WHEN cena >= 1000 THEN 'velka'
        WHEN cena >= 500 THEN 'stredni'
        ELSE 'mala'
    END AS velikost_objednavky
    FROM objednavka_jidla
)
SELECT obj_id, rc_zakaznika, status, datum, cena, velikost_objednavky
FROM objednavka;




--trigger which limits hours when the menu could be changed
create or replace trigger hours_limit_trigger
before delete or insert or update on jidelni_listek
declare
    opened_from constant number := 7;
    opened_till constant number := 22;
begin
    dbms_output.put_line('Time is ' || to_char(sysdate, 'HH24'));
    if to_char(sysdate, 'HH24') > opened_from and to_char(sysdate, 'HH24') < opened_till then
         RAISE_APPLICATION_ERROR(-20000, 'Menu pdates are only allowed beyond business hours');
    end if;
end;
/

--hours_limit_trigger demonstration
INSERT INTO jidelni_listek VALUES('nejake nove menu');
--hours_limit_trigger demonstration end

--discount trigger: when the total "zaplaceno" orders price is more than 1000 crowns, then
--every next order price is discounted by 10% (but only if order status is "nezaplaceno")
create or replace trigger discount_trigger
for insert
on objednavka_jidla
compound trigger
type customer_type is record (
    rc_zakaznika objednavka_jidla.rc_zakaznika%type,
    status       objednavka_jidla.status%type,
    datum        objednavka_jidla.datum%type,
    obj_id       objednavka_jidla.obj_id%type
);

type customers_table is table of customer_type index by pls_integer;

order_tab customers_table;

after each row is
begin
    order_tab(order_tab.count + 1).rc_zakaznika := :new.rc_zakaznika;
    order_tab(order_tab.count).status := :new.status;
    order_tab(order_tab.count).datum := :new.datum;
    order_tab(order_tab.count).obj_id := :new.obj_id;
end after each row;


after statement is
    orders_sum objednavka_jidla.cena%type;
    today date := to_date(to_char(sysdate, 'DD-MM-YYYY'), 'DD-MM-YYYY');
    tommorow date :=  to_date(to_char(sysdate+1, 'DD-MM-YYYY'), 'DD-MM-YYYY');
begin
        for idx in 1 .. order_tab.count
        loop
            select sum(cena) into orders_sum
            from objednavka_jidla
            where
            status = 'zaplaceno' and rc_zakaznika = order_tab(idx).rc_zakaznika and
            to_date(to_char(datum, 'DD-MM-YYYY'), 'DD-MM-YYYY') between
            today and tommorow;

            dbms_output.put_line('sum is ' || orders_sum);
            dbms_output.put_line('id is ' || order_tab(idx).obj_id);
            dbms_output.put_line('status is ' || order_tab(idx).status);

            if   order_tab(idx).status = 'nezaplaceno' and orders_sum >= 1000 and
                 to_date(to_char(order_tab(idx).datum, 'DD-MM-YYYY'), 'DD-MM-YYYY') between
                 today and tommorow
            then
                dbms_output.put_line('making discount');
                update objednavka_jidla
                set cena = cena*0.9
                where obj_id = order_tab(idx).obj_id;
            end if;
        end loop;
end after statement;
end;
/


--discount trigger demonstration

--order for >= 1000
declare
    last_obj_id objednavka_jidla.obj_id%type;
begin
    INSERT INTO osoba VALUES('783320/0444', 'Novy', 'Klient', '555-555-555', '', 'zakaznik');

    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('783320/0444', 'zaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
        dbms_output.put_line('last ' || last_obj_id);
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');

    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('783320/0444', 'zaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');

    --here we get discount 10% (500*0.9 -> 450)
    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('783320/0444', 'nezaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');

    --and once again
    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('783320/0444', 'nezaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');
    --hours_limit_trigger demonstration end
end;
/
--discount trigger demonstration end


--materialized view
--all the customers who has a table rezervation for today and have totaly payed for
--their orders more than 1000
drop materialized view prefered_reservations;

create materialized view prefered_reservations as
select distinct o.rodne_cislo, o.jmeno, o.prijmeni, rs.rezst_id, rs.datum_od, rs.datum_do
from osoba o
join xdomra00.rezervace_stolku rs on o.rodne_cislo = rs.rc_zakaznika
join xdomra00.objednavka_jidla oj on  o.rodne_cislo = oj.rc_zakaznika
where to_date(to_char(rs.datum_od, 'DD-MM-YYYY'), 'DD-MM-YYYY') = to_date(sysdate, 'DD-MM-YYYY')
and o.typ = 'zakaznik'
and o.rodne_cislo in (
select obj1.rc_zakaznika from xdomra00.objednavka_jidla obj1
where obj1.status = 'zaplaceno'
group by obj1.rc_zakaznika
having sum(obj1.cena) >= 1000);


alter materialized view prefered_reservations add constraint prpk primary key
(rodne_cislo, rezst_id);

--materialized view demonstration
declare
    last_obj_id objednavka_jidla.obj_id%type;
begin
    INSERT INTO osoba VALUES('222222/2222', 'Nov?j??', 'Klientiku', '', '', 'zakaznik');

    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('222222/2222', 'zaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
        dbms_output.put_line('last ' || last_obj_id);
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');

    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('222222/2222', 'zaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');

    INSERT INTO objednavka_jidla(rc_zakaznika, status, datum, cena)
        VALUES('222222/2222', 'zaplaceno', TO_TIMESTAMP(to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), 500)
        RETURNING obj_id INTO last_obj_id;
    INSERT INTO napln_objednavky_jidla VALUES(last_obj_id, 'cockova polevka');


    INSERT INTO rezervace_stolku(rc_zakaznika, datum_od, datum_do, status, poznamka, cislo_stolku)
    VALUES('222222/2222', TO_TIMESTAMP(sysdate, 'DD-MM-YYYY HH24:MI:SS'),
           TO_TIMESTAMP(sysdate+1, 'DD-MM-YYYY HH24:MI:SS'), 'platna', 'kouri', 777);
end;
/

begin
DBMS_MVIEW.REFRESH('prefered_reservations');
end;
/
select * from prefered_reservations;
--materialized view demonstration end



--EXPLAIN PLAN + INDEX
--query selects all the dishes and their amount which are a part of (paid) order which (in sum) cost more than 1000
drop index status_idx;
create index status_idx
on chody (cena);
explain plan for
select nazev_chodu, sum(oj.cena), count(nazev)
from objednavka_jidla oj
join napln_objednavky_jidla noj on oj.obj_id = noj.id_objednavky
join chody cho on noj.nazev_chodu = cho.nazev
where oj.status = 'zaplaceno' and cho.cena >= 500
group by nazev_chodu
having sum(oj.cena) > 1000;

select * from table(dbms_xplan.display);




