/**Campionat**/

CREATE TABLE `campionat` (
  `ancampionat` int NOT NULL,
  `numarcurse` int DEFAULT NULL,
  `data_incepere` date DEFAULT NULL,
  `data_terminare` date DEFAULT NULL,
  PRIMARY KEY (`ancampionat`)
)

INSERT INTO `campionat`
 VALUES
 (2016,10,'2016-02-10','2016-09-22')
,(2017,18,'2017-03-18','2017-12-20')
,(2018,18,'2018-02-20','2018-11-18')
,(2019,20,'2019-02-20','2019-12-23')
,(2020,12,'2020-04-19','2020-12-24')
,(2021,23,'2021-05-22','2021-12-02');


/**Circuit**/

CREATE TABLE `circuit` (
  `idcircuit` int NOT NULL,
  `idlocatie` int DEFAULT NULL,
  `lungime` float DEFAULT NULL,
  `numardrs` int DEFAULT NULL,
  `fastestlap` float DEFAULT NULL,
  PRIMARY KEY (`idcircuit`),
  KEY `idlocatie_ddd_idx` (`idlocatie`),
  CONSTRAINT `idlocatie_ddd` FOREIGN KEY (`idlocatie`) REFERENCES `locatie` (`idlocatie`)
)
INSERT INTO `circuit` 
VALUES 
(1,1,5.12,2,83.12)
,(2,2,3.8,1,71.2)
,(3,3,4.9,2,75.88)
,(4,4,4.4,2,92.5)
,(5,5,6.2,3,98.44)
,(6,6,8.2,1,102.51);

/**Constructor**/

CREATE TABLE `constructor` (
  `idconstructor` int NOT NULL,
  `nume` varchar(45) DEFAULT NULL,
  `locatie` varchar(45) DEFAULT NULL,
  `buget` int DEFAULT NULL,
  `trofee` int DEFAULT NULL,
  PRIMARY KEY (`idconstructor`)
)

INSERT INTO `constructor` VALUES (1,'Mercedes','Germania',380,8)
,(2,'RedBull','Austria',250,4)
,(3,'ScuderiaFerrari','Italia',340,12)
,(4,'Mclaren','UK',180,3)
,(5,'Renault','Franta',170,2)
,(6,'AlfaRomeo','Italia',100,1);

/**Cursa**/

CREATE TABLE `cursa` (
  `idcircuit` int NOT NULL,
  `ancampionat` int NOT NULL,
  `temperaturacircuit` int DEFAULT NULL,
  `orastart` int DEFAULT NULL,
  `turrapid` float DEFAULT NULL,
  PRIMARY KEY (`idcircuit`,`ancampionat`),
  KEY `ancampionat_cs_idx` (`ancampionat`),
  CONSTRAINT `ancampionat_cs` FOREIGN KEY (`ancampionat`) REFERENCES `campionat` (`ancampionat`),
  CONSTRAINT `idcircuit_cs` FOREIGN KEY (`idcircuit`) REFERENCES `circuit` (`idcircuit`)
)

INSERT INTO `cursa` 
VALUES 
(1,2018,28,13,88)
,(1,2019,30,14,88)
,(2,2020,27,15,77)
,(3,2017,30,14,80),
(4,2021,29,14,91),
(5,2021,25,10,102);

/**CursaSofer**/

CREATE TABLE `cursa_sofer` (
  `idcircuit` int NOT NULL,
  `ancampionat` int NOT NULL,
  `idsofer` int NOT NULL,
  `calificare` int DEFAULT NULL,
  `tipcauciuc` varchar(1) DEFAULT NULL,
  `pozitiefinala` int DEFAULT NULL,
  PRIMARY KEY (`idcircuit`,`ancampionat`,`idsofer`),
  KEY `idsofer_tbl_idx` (`idsofer`),
  KEY `ancampionat_idx` (`ancampionat`),
  CONSTRAINT `ancampionat_tbl` FOREIGN KEY (`ancampionat`) REFERENCES `cursa` (`ancampionat`),
  CONSTRAINT `idcircuit_tbl` FOREIGN KEY (`idcircuit`) REFERENCES `cursa` (`idcircuit`),
  CONSTRAINT `idsofer_tbl` FOREIGN KEY (`idsofer`) REFERENCES `sofer` (`idsofer`)
)

INSERT INTO `cursa_sofer` 
VALUES 
(1,2019,1,1,'S',2),
(1,2019,2,3,'S',2),
(1,2019,3,4,'S',3),
(1,2019,4,2,'S',4),
(2,2020,2,1,'M',1),
(2,2020,3,5,'S',4),
(2,2020,5,4,'M',2),
(3,2017,1,3,'M',2),
(3,2017,2,2,'S',3),
(3,2017,4,1,'S',1),
(4,2021,1,3,'S',2),
(4,2021,6,2,'M',4);


/** INGINER**/


CREATE TABLE `inginer` (
  `idinginer` int NOT NULL,
  `nume` varchar(45) DEFAULT NULL,
  `prenume` varchar(45) DEFAULT NULL,
  `salariu` int DEFAULT NULL,
  `data_angajare` date DEFAULT NULL,
  `data_expirare` date DEFAULT NULL,
  `idconstructor` int DEFAULT NULL,
  PRIMARY KEY (`idinginer`),
  KEY `idconstructor_cs_idx` (`idconstructor`),
  CONSTRAINT `idconstructor_cs` FOREIGN KEY (`idconstructor`) REFERENCES `constructor` (`idconstructor`)
)

INSERT INTO `inginer` 
VALUES 
(1,'Constantin','Parhon',9000,'2012-05-31','2022-03-13',1),
(2,'Popa','Dorian',13500,'2020-02-20','2024-12-20',1),
(3,'Pedro','Gica',11400,'2003-08-21','2024-02-20',1),
(4,'Ninel','Razvan',8000,'2016-04-20','2023-04-21',2),
(5,'Constantin','Dobre',13500,'2008-03-20','2021-05-20',2),
(6,'Gica','Hagi',5304,'2015-04-12','2023-03-13',3),
(7,'Dorica','Dorel',8000,'2004-03-18','2023-04-18',3);


/**Locatie**/

CREATE TABLE `locatie` (
  `idlocatie` int NOT NULL,
  `tara` varchar(45) DEFAULT NULL,
  `localitate` varchar(45) DEFAULT NULL,
  `codpostal` int DEFAULT NULL,
  PRIMARY KEY (`idlocatie`)
)

INSERT INTO `locatie` 
VALUES
 (1,'Italia','Benevento',20030),
 (2,'Italia','Monza',21034),
 (3,'Germania','Munchen',80314),
 (4,'Ungaria','Budapesta',90302),
 (5,'USA','Kirkland',30101),
 (6,'Franta','Paris',80102);

/**MASINA**/


CREATE TABLE `masina` (
  `codsasiu` int NOT NULL,
  `idsofer` int DEFAULT NULL,
  `codmotor` int DEFAULT NULL,
  `coeficientdrag` decimal(1,0) DEFAULT NULL,
  `greutate` int DEFAULT NULL,
  PRIMARY KEY (`codsasiu`),
  KEY `idsofer_md_idx` (`idsofer`),
  CONSTRAINT `idsofer_md` FOREIGN KEY (`idsofer`) REFERENCES `sofer` (`idsofer`)
)

INSERT INTO `masina` 
VALUES 
(202,1,1,0,702),
(203,2,1,0,704),
(204,3,2,0,722),
(205,4,3,0,733),
(206,5,4,0,724),
(207,6,4,0,740);

/**MOTOR**/

CREATE TABLE `motor` (
  `codmotor` int NOT NULL,
  `greutate` int DEFAULT NULL,
  `caiputere` int DEFAULT NULL,
  `consum` float DEFAULT NULL,
  PRIMARY KEY (`codmotor`)
)

INSERT INTO `motor` 
VALUES
(1,220,820,22.5),
(2,224,833,22),
(3,208,772,22.3),
(4,221,880,25),
(5,230,802,19.8);

/**MOTOR_INGINER**/

CREATE TABLE `motor_inginer` (
  `codmotor` int NOT NULL,
  `idinginer` int NOT NULL,
  `observatii` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`codmotor`,`idinginer`),
  KEY `idinginer_cd_idx` (`idinginer`),
  CONSTRAINT `codmotor_cd` FOREIGN KEY (`codmotor`) REFERENCES `motor` (`codmotor`),
  CONSTRAINT `idinginer_cd` FOREIGN KEY (`idinginer`) REFERENCES `inginer` (`idinginer`)
)

INSERT INTO `motor_inginer`
 VALUES 
 (1,1,'Putere'),
 (1,2,'Consum'),
 (1,3,'Putere'),
 (1,4,'Consum'),
 (2,4,'Greutate'),
 (2,5,'Putere'),
 (3,4,'Consum'),
 (3,5,'Putere'),
 (4,6,'Greutate'),
 (4,7,'Putere');

/**SOFER**/


CREATE TABLE `sofer` (
  `idsofer` int NOT NULL,
  `idconstructor` int DEFAULT NULL,
  `salariu` int DEFAULT NULL,
  `nume` varchar(45) DEFAULT NULL,
  `prenume` varchar(45) DEFAULT NULL,
  `sponsor` varchar(45) DEFAULT NULL,
  `data_angajare` date DEFAULT NULL,
  `data_expirare` date DEFAULT NULL,
  `trofee` int DEFAULT NULL,
  PRIMARY KEY (`idsofer`),
  KEY `idconstructor_pd_idx` (`idconstructor`),
  CONSTRAINT `idconstructor_pd` FOREIGN KEY (`idconstructor`) REFERENCES `constructor` (`idconstructor`)
)

INSERT INTO `sofer`
 VALUES 
 (1,1,20,'Hamilton','Lewis','Merc','2015-03-20','2021-09-21',NULL)
 ,(2,1,7,'Bottas','Valtteri','Pepsi','2018-01-20','2022-12-20',NULL)
 ,(3,2,18,'Verstappen','Max','RedBull','2017-02-18','2021-11-30',NULL)
 ,(4,2,5,'Perez','Checo','RedBull','2020-02-12','2022-12-20',NULL)
 ,(5,3,3,'Leclerc','Charles','Scuderia','2018-01-10','2024-11-10',NULL)
 ,(6,3,2,'Sainz','Carlos','Fanta','2020-08-20','2022-08-20',NULL)
 ,(7,4,1,'Norris','Lando','Merc','2018-03-20','2024-03-12',NULL);


