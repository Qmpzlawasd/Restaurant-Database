CREATE TABLE email (
    cod_email NUMBER(4),
    adresa VARCHAR2(50) unique ,
    dataExpirare DATE,
    CONSTRAINT primar_cod_email PRIMARY KEY (cod_email)
);
CREATE TABLE mancare (
    cod_mancare NUMBER(4),
    denumireMancare VARCHAR2(100) not null unique,
    pret NUMBER(4, 0) not null,
    calorii NUMBER(4, 0) default 1 not null,
    CONSTRAINT asd_cod_mancare PRIMARY KEY (cod_mancare)
);

CREATE TABLE locatie (
    cod_locatie NUMBER(4),
    tara VARCHAR2(57) default 'Romania' not null,
    oras VARCHAR2(50)  not null,
    CONSTRAINT prismar PRIMARY KEY (cod_locatie)
);
CREATE TABLE ingredient (
    cod_ingredient NUMBER(4),
    denumireIngredient VARCHAR2(50) not null unique,
    esteAlergen NUMBER(1, 0) default 1 not null CHECK (
        esteAlergen = 1
        or esteAlergen = 0
    ),
    zileDePastrare NUMBER(4) not null,
    pret NUMBER(4, 0) not null,
    CONSTRAINT primar_cod_ingredient PRIMARY KEY (cod_ingredient)
);

CREATE TABLE client (
    cod_client NUMBER(4),
    nume VARCHAR2(50) not null,
    prenume VARCHAR2(50) not null,
    nrTelefon VARCHAR2(15) not null unique,
    dataRezervare DATE not null,
    CONSTRAINT primar_cod_client PRIMARY KEY (cod_client)
);

CREATE TABLE restaurant (
    cod_restaurant NUMBER(4),
    cod_locatie NUMBER(4),
    dataDeschidere DATE default '23-nov-1970' ,
    stele NUMBER(1, 0) default 0 not null,
    specificul VARCHAR2(50),
    constraint sas foreign key(cod_locatie) references locatie(cod_locatie),
    CONSTRAINT asdasdasdad PRIMARY KEY (cod_restaurant)
);
CREATE TABLE review (
    cod_review NUMBER(4),
    cod_client NUMBER(4),
    cod_restaurant NUMBER(4), 
    textReview VARCHAR2(280) default '...',
    rating NUMBER(1, 0) default 4,
    constraint saccxcs foreign key(cod_client) references client(cod_client),
    constraint sxcxas foreign key(cod_restaurant) references restaurant(cod_restaurant),
    CONSTRAINT primar_cod_xccreview PRIMARY KEY (cod_review, cod_client, cod_restaurant)
);

CREATE TABLE angajat (
    cod_angajat NUMBER(4),
    cod_restaurant NUMBER(4),
    nume VARCHAR2(50) not null,
    prenume VARCHAR2(50) not null,
    nrTelefon VARCHAR2(15)  unique,
    dataAngajarii DATE default sysdate ,
    titluSlujba VARCHAR2(50) default 'spalator de vase' ,
    salariu NUMBER(5, 0) not null,
    constraint saasds foreign key(cod_restaurant) references restaurant(cod_restaurant),
    CONSTRAINT primar_cod_angajat PRIMARY KEY (cod_angajat)
);

CREATE TABLE furnizor (
    cod_furnizor NUMBER(4),
    cod_locatie NUMBER(4),
    nume VARCHAR2(50) not null,
    vechime NUMBER(3, 0),
    constraint sasasdad foreign key(cod_locatie) references locatie(cod_locatie),
    CONSTRAINT primar_cod_furnizor PRIMARY KEY (cod_furnizor)
);

CREATE TABLE inventar (
    cod_furnizor NUMBER(4),
    cod_restaurant NUMBER(4),
    cod_ingredient NUMBER(4),
    cantitate NUMBER(3, 0
    ) default 1,
    constraint sasc foreign key(cod_restaurant) references restaurant(cod_restaurant),
    constraint sasads foreign key(cod_furnizor) references furnizor(cod_furnizor),
    constraint sasv foreign key(cod_ingredient) references ingredient(cod_ingredient),
    CONSTRAINT pdsarimar_cod_restaurant PRIMARY KEY (cod_restaurant, cod_furnizor,cod_ingredient)
    );

CREATE TABLE detine (
    cod_email NUMBER(4),
    cod_angajat NUMBER(4),
    constraint sasasd foreign key(cod_email) references email(cod_email),
    constraint sasas foreign key(cod_angajat) references angajat(cod_angajat),
    CONSTRAINT primar_cod_emacil PRIMARY KEY (cod_email, cod_angajat)
);

CREATE TABLE comanda (
    cod_comanda NUMBER(4) ,
    cod_client NUMBER(4) ,
    cod_restaurant NUMBER(4) ,
    pretTotal NUMBER(6, 0) not null,
    modDePlata CHAR(4) default 'cash' CHECK(
        modDePlata = 'card'
        or modDePlata = 'cash'
    ),
    masa NUMBER(2, 0) not null ,
    constraint ssd foreign key(cod_client) references client(cod_client),
    constraint sdasdas foreign key(cod_restaurant) references restaurant(cod_restaurant),
    CONSTRAINT primsaryyyyy PRIMARY KEY (
        cod_comanda
    )
);


CREATE TABLE meniu (
    cod_comanda number(4),
    cod_mancare number(4),
    cod_ingredient number(4),
    constraint sxasasds foreign key(cod_mancare) references mancare(cod_mancare),
    constraint sasasdsx foreign key(cod_comanda) references comanda(cod_comanda),
    constraint sasxxs foreign key(cod_ingredient) references ingredient(cod_ingredient),
    CONSTRAINT primaryyllly PRIMARY KEY (
        cod_comanda,
        cod_mancare,
        cod_ingredient
        
    )
);

CREATE SEQUENCE angajat_seq START WITH 200 INCREMENT BY 1 NOCACHE NOCYCLE;

insert into email values (200,'bucatarie@asd.asd',to_date('04-apr-2022','dd-mon-yyyy'));
insert into email values (203,'chelner@sd.sa','6-nov-2022');
insert into email values (202,'cladirea1.asd@asd.asd','5-feb-2022');
insert into email values (201,'cladirea2@asd.das','25-jul-2022');
insert into email values (204,'marian@asd.asd','12-jan-2021');
insert into mancare values (208,'paste boloneze',12,98);
insert into mancare values (207,'pizza locala',33,31);
insert into mancare values (206,'ciorba taraneasca',42,383);
insert into mancare values (205,'carnati afumati',123,33);
insert into mancare values (204,'placinta cu carne',11,31);
insert into locatie values (203,'Australia','Perth');
insert into locatie values (204,'Azerbaijan','Baku');
insert into locatie values (205,'USA','Connecticut');
insert into locatie values (206,'Ukraine','Корабельний');
insert into locatie values (207,'France','Lyon');
insert into locatie values (208,'Germany','Ruhr');
insert into locatie values (209,'Romania','Pitesti');
insert into ingredient values (208,'ou',1,   50,12);
insert into ingredient values (209,'susan',1,345,1);
insert into ingredient values (200,'ulei',0 ,60,7);
insert into ingredient values (203,'faina',0,89,4);
insert into ingredient (cod_ingredient,denumireIngredient,zileDePastrare,pret)  values (201,'lapte',12,4);
insert into client values (201,'Herc','Bryning','776-367-2442','19-jan-2021');
insert into client values (203,'Jacintha','Adamek','868-423-3711','22-nov-2012');
insert into client values (204,'Hartwell','Armour','941-123-2780','06-dec-2011');
insert into client values (205,'Jenn','Dyet','259-991-2898','08-may-2021');
insert into client values (207,'Aeriel','Basketter','652-705-0239','01-apr-2021');
insert into restaurant  values (205,203,'31-Mar-2022',5,'oceanic');
insert into restaurant  values (206,204  ,'12-Jan-2022',3,'oriental');
insert into restaurant  values (207,  205,'28-Dec-2021',6,'autohton');
insert into restaurant  values (201,  206,'06-May-2022',3,'european');
insert into restaurant  values (208,  208,'16-nov-2022',3,'romanesc');
insert into restaurant  values (209,  null,null,0,'...');
insert into review  values (201  , 201 , 208 ,'nu a fost ok ',2);
insert into review  values (202  , 204 , 201 ,'mi-a placaut',3);
insert into review  values (203  , 205 , 205 ,'pizza foarete buna ',7);
insert into review  values (204  ,205 , 208  ,'foarte amabiloi angajatii',8);
insert into review (cod_review,cod_client,cod_restaurant) values (208,203,206);
 insert into angajat  values (angajat_seq.nextval, 207, 'Efren','Sharp','499-206-2897','22-Jan-2022','Bucatar',2232)       ;   
 insert into angajat  values (angajat_seq.nextval, 205, 'Walsh','Pizzey',null,'28-Nov-2021','Chelner',2444);
 insert into angajat  values (angajat_seq.nextval, 205, 'Reinaldo','Caplis','957-910-3849','31-Dec-2021','Manager',2999);
 insert into angajat  values (angajat_seq.nextval, 206, 'Rivalee','Highton','225-188-1634','21-Nov-2021','Manager',3999);
 insert into angajat  values (angajat_seq.nextval, 207, 'Peria','Whales','949-774-1449','19-Sep-2021','Manager',3123);
 insert into angajat  values (angajat_seq.nextval, 201, 'Bren','Calderhead','562-914-4607','18-Mar-2022','Manager',4231);
 insert into angajat  values (angajat_seq.nextval, 208, 'Cale','Densumbe','267-113-4781','21-Dec-2021','Manager',4544);
 insert into angajat  values (angajat_seq.nextval, 208, 'Christabel','Capin','319-958-2969','19-Oct-2021','Bucatar',2132);
 insert into angajat  values (angajat_seq.nextval, 201, 'Dmitri','Bagehot','864-465-1871','25-Aug-2021','Bucatar',2323);
 insert into angajat  values (angajat_seq.nextval, 201, 'Courtnay','Salvati','849-938-5270','02-Jan-2022','Chelner',4441);
 insert into angajat  values (angajat_seq.nextval, 205, 'Leese','Blaylock','536-845-2387','10-Jan-2022','Bucatar',3123);
 insert into angajat values(angajat_seq.nextval,null,'Tava','Tava','442-211-6705', null,null,0);
 insert into angajat values(angajat_seq.nextval,null,'Adela','Adela','987-217-6705', null,null,0);
 insert into angajat values(angajat_seq.nextval,null,'Ancuta','Andrei','789-611-6705', null,null,0);
 insert into furnizor  values (321,204,'Al Salam Farm',3);
 insert into furnizor  values (323,204,'Cow Obsession',null);
 insert into furnizor  values (311,205,'Farmington.', 4 );
 insert into furnizor  values (301,206,'Exotic Bonsai',55 );
 insert into furnizor  values (300,207,'Beef Bounty',  12);
 insert into inventar  values (321,205,208,34);
 insert into inventar  values (323,205,209,134);
 insert into inventar  values (321,206,209,12);
 insert into inventar  values (321,207,209,112);
 insert into inventar  values (323,206,200,12);
 insert into inventar  values (300,207,200,13);
 insert into inventar  values (300,201,200,91);
 insert into inventar  values (311,201,209,23);
 insert into inventar  values (311,207,209,13);
 insert into inventar  values (321,201,203,34);
 insert into inventar  values (301,201,208,34);
 insert into inventar  values (301,208,203,13);
 insert into inventar  values (300,208,201,11);
 
 insert into detine  values ( 200, 200);
 insert into detine  values ( 202, 208);
 insert into detine  values ( 202, 205);
 insert into detine  values ( 201, 208);
 insert into detine  values (200, 208   );
 insert into detine  values (200, 201   );
 insert into detine  values (200, 205   );
 insert into detine  values (203, 208   );
 insert into detine  values (204, 208   );
 insert into detine  values ( 203, 201);
 insert into detine  values (201, 202 );
 insert into detine  values (201, 203 );
 insert into detine  values ( 201, 204);
 insert into detine  values (   201, 205);
 insert into detine  values ( 201, 206  );
 insert into detine  values ( 200, 207  );
 insert into detine  values ( 200, 209  );
 insert into detine  values ( 203, 210 );


 insert into comanda values ( 600,207,206  ,56,'card',1   );
 insert into comanda values ( 601,203,206  ,66,'card'  ,3 );
 insert into comanda values ( 602,201, 208 ,28,'card'  ,4);
 insert into comanda values ( 603,203, 201 ,101  ,'card',7);
 insert into comanda values ( 604,204,  201,201 ,'cash'  ,5 );
 insert into comanda values ( 605,205,  205,25  ,'cash'  ,15);
 insert into comanda values ( 606,207,  201,71  ,'cash'  ,5);
 insert into comanda values ( 607,205,  205,95  ,'cash'  ,9);

insert into meniu values ( 600,208,208);
insert into meniu values ( 600,207,209);

insert into meniu values ( 601,207,208);
insert into meniu values ( 601,204,209);

insert into meniu values ( 602,206,200);
insert into meniu values ( 602,205,201);

insert into meniu values ( 603,205,203);
insert into meniu values ( 603,205,200);

insert into meniu values ( 604,204,201);
insert into meniu values ( 604,204,203);

insert into meniu values ( 605,208,208);
insert into meniu values ( 605,208,203);
insert into meniu values ( 605,207,208);
insert into meniu values ( 605,207,209);

insert into meniu values ( 606,206,201);
insert into meniu values ( 607,206,201);
