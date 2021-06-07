
/* CERINTA 11*/

/*1. Join cu 4 tabele, folosind where si functie cu data. Acesta selecteaza idcircuit, sofer, pozitiefinala si data incepere pentru soferii
 care au terminat pe primul loc intr-o cursa care a avut loc intr-un campionat care a inceput cu cel putin un an mai devreme decat data curenta.*/

select c.idcircuit,p.idsofer,p.pozitiefinala,d.data_incepere
from cursa c join campionat d on(c.ancampionat = d.ancampionat) 
 join circuit e on (c.idcircuit = e.idcircuit)
 join cursa_sofer p on (p.idcircuit = c.idcircuit)
 where pozitiefinala = 1 and datediff(current_date(),data_incepere)>365;
 
/*2. Selecteaza numarul de campionate care au avut loc intr-un an folosind functia group by, ordonata folosind functia order by, descendent, in fucntie de numarul de circuite, in care anul campionatului e mai mic decat 2018
Am folosit functia ifnull, sql nu are NVL, se numeste ifnull*/

select ifnull(count(idcircuit), 'Nu are') as NumarCircuite, ifnull(c.ancampionat, 'Nu are') as AnCampionat
from cursa c right outer join campionat d on (c.ancampionat = d.ancampionat)
group by c.ancampionat
having count(idcircuit)<=1
order by count(idcircuit) DESC;

/*3. Face o reuniune dintre inginerii care au numele "gica" si cei care au mai mult de 2800 de zile de la data angajarii, folosind clauzele with si union*/
WITH inginer AS (SELECT * FROM inginer where salariu > 9900)
SELECT * FROM inginer WHERE month(data_angajare) = 8
UNION ALL
SELECT * FROM inginer WHERE nume = 'Gica'
UNION ALL
select * from inginer where prenume = 'Dorel';

/*4. Cerere sincronizata unde selectam numele, prenume, salariul, idconstructor si trofeele acestuia , pentru soferii care nu au participat la nicio cursa */

select s.nume, s.prenume, s.salariu,
case when s.idconstructor =  1 then  'Mercedes'
	 when s.idconstructor =2 then  'Red bull'
	 when s.idconstructor =3 then 'Ferari'
	 when s.idconstructor = 4 then 'Mclaren'
		else 'Necunoscut'
        end as numeConstructor,
 b.trofee from sofer s join constructor b on (s.idconstructor = b.idconstructor)
where not exists(select idsofer from cursa_sofer where idsofer = s.idsofer );

/* 5.Aceeasi cerere de mai sus, numai ca nesincronizata.*/
select s.nume, s.prenume, s.salariu, s.idconstructor, b.trofee from sofer s join constructor b on (s.idconstructor = b.idconstructor)
where s.idsofer not in(select idsofer from cursa_sofer where idsofer is not null );

/* CERINTA 12*/
/* 1. Update care ii atribuie numarul de trofee unui sofer, doar daca acesta a luat locul 1 la o cursa*/

UPDATE sofer
set trofee = (select count(pozitiefinala) from cursa_sofer c where pozitiefinala= 1 and c.idsofer = sofer.idsofer);
rollback;
select * from sofer;

/* 2.*/
/*Facem un tabel nou, iar aceasta instructiune le atribuie tuturor inginerilor cu salariu mai mic decat 10000, salariul mediu)*/

CREATE TABLE inginer_fake1 AS SELECT * FROM inginer;

update inginer
set salariu = (select avg(salariu) from inginer_fake1)
where inginer.salariu < 10000;
rollback;
select * from inginer;

/* 3. */
/*Sterge liniile masinilor al caror sofer este sponzorizat de firma "merc"*/

delete from masina
where idsofer = any(select idsofer from sofer where sponsor = "Merc");

rollback;
select * from masina;

/*CERINTA 13 -----MYSQL NU FOLOSESTE SEQUENCES, ASA CA O SA MA FOLOSESC DE FUNCTIA AUTO-INCREMENT*/

/*Aceasta creaza un tabel numit manager, unde cheia primara, id-ul, se incrementeaza cu 1 la fiecare insert*/


CREATE TABLE manager (
     id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
     nume CHAR(30) NOT NULL,
     salariu int  
);

insert into manager(nume, salariu) values ('Mesia', 3000);

rollback;

/*CERINTA 14 */

/*Creaza o vizualizare cu toti inginerii care lucreaza pentru constructorul cu numarul 1*/

create or replace view Vizualizare
as 
select i.idinginer,i.nume,i.prenume,i.salariu,i.data_angajare,i.data_expirare, i.idconstructor, e.nume as 'NumeConstructor', e.buget
from inginer i join constructor e on (i.idconstructor = e.idconstructor)
where i.idconstructor = 1;

/* Urmatorul insert este permis deoarece se modifica doar tabelul cu cheia primara, adica inginer*/

insert into Vizualizare (idinginer, nume, prenume, salariu, data_angajare, data_expirare, idconstructor) values (8, 'Pipsick', 'Daniel', 8000, '2018-04-20', '2021-05-21', 1);

/* Urmatorul insert nu este permis deoarece se incearca modificare ambelor tabele, si constructor si inginer*/


insert into Vizualizare (idinginer, nume, prenume, salariu, data_angajare, data_expirare, idconstructor, NumeConstructor) values (8, 'Pipsick', 'Daniel', 8000, '2018-04-20', '2021-05-21', 1, 'Renault');

rollback;
select * from Vizualizare;

/* CERINTA 15 */

create index full_name
on inginer (nume, prenume);

show index from inginer;

select nume, prenume, salariu
from inginer
where nume = 'Constantin';

explain select nume, prenume, salariu
from inginer
where nume = 'Constantin';


/* CERINTA 16 */

/* Sa se arate respectivele selecturi, pentru toate circuitele posibile, chiar daca nu s-a efectuat o cursa pe acestea*/

select c.idcircuit,p.idsofer,p.pozitiefinala, p.calificare,p.tipcauciuc,e.numardrs, d.numarcurse, e.idlocatie,e.lungime,d.data_incepere
from cursa c left outer join campionat d on(c.ancampionat = d.ancampionat) 
join circuit e on (c.idcircuit = e.idcircuit)
 left outer join cursa_sofer p on (p.idcircuit = c.idcircuit);
 
 /*DIVISION*/
 
/*1. Sa se afiseze inginerii care au lucrat la toate motoarele care au mai putin de 820 de cai putere, cu count*/

 select idinginer 
from motor_inginer
where codmotor in(
	Select codmotor from motor
    where caiputere<820
)
group by idinginer
having count(idinginer) = (select count(*) from motor where caiputere<820)
;
 
 /* 2.Acelasi select de mai sus, cu not exists*/
 
 
 select distinct idinginer
from motor_inginer m
where not exists(
	select * 
    from motor s 
    where caiputere<820 and not exists ( 
				select 'x'
                from motor_inginer m2
                where  s.codmotor = m2.codmotor and  m.idinginer = m2.idinginer
                ) 
    );
    
    