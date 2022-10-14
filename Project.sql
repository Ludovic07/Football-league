############################################################################
################      Script per progetto BDSI 2019/20     #################
############################################################################
#
# GRUPPO FORMATO DA:
#
# Matricola: 7020875     Cognome: Catone	       Nome: Ilaria    
# Matricola: 7009348     Cognome: Iervolino        Nome: Ludovico   
# Matricola: 7010856     Cognome: Canocchi	       Nome: Simone 
#
############################################################################
 
 /* Informazioni generali: 
 Creiamo un database "Campionato" dove è possibile creare giocatori, allenatori, squadre di appartenenza 
 e le varie partite giocate di cui possiamo avere un riepilogo dei goal che ci permettono di avere anche i 
 marcatori. 
 In relazione alle partite, abbiamo una classifica suddivisa per le serie delle squadre, piuttosto che degli anni 
 del campionato, comunque ottenuto con vari accorgimenti realizzati nelle successive implementazioni.
Le informazioni che abbiamo memorizzato riguardo ad "allenatore" e "giocatore" sono: NumTessera, 
Cognome, Nome, Città di nascita, Data di nascita, con le seguenti aggiunte per "giocatore": Ruolo, Squadra, 
Numero; a differenza di "allenatore" che presenta: Squadra allenata, NumSquadre (numero di squadre allenate).
La squadra, come di consueto, ha data di nascita, Citta di nascita, Stadio, colori sociali, sponsor e la serie
in cui gioca.*/


############################################################################
################   Creazione schema e vincoli database     #################
############################################################################
DROP DATABASE IF EXISTS Campionato;
create database if not exists Campionato;
use Campionato;

create table if not exists Presidente(
  Nome char(15),
  Cognome char(15),
  CodFiscale char(16) primary key
) ENGINE=INNODB;

create table if not exists Squadra (
    Nome char(15) UNIQUE PRIMARY KEY,
    DataCreazione date,
    Citta char(15) NOT NULL,
    Serie ENUM('A' , 'B', 'C', 'D'),
    Stadio char(20) NOT NULL,
    Sponsor char(20) NOT NULL,
    ColoriSociali char(20) NOT NULL,
	Presidente char(16) NOT NULL,
	foreign key (Presidente)
        references Presidente (CodFiscale)
)  ENGINE=INNODB;

create table if not exists Giocatore (
    NumTessera INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Cognome char(20) NOT NULL,
    Nome char(15) NOT NULL,
    CittaNascita char(15) NOT NULL,
    DataNascita date NOT NULL,
    Ruolo char(20) NOT NULL
)  ENGINE=INNODB;

create table if not exists Allenatore (
    NumTessera INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Cognome char(20) NOT NULL,
    Nome char(15) NOT NULL,
    CittaNascita char(15) NOT NULL,
    DataNascita date NOT NULL,
    NumSquadre int DEFAULT '0'
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS ContrattoGiocatore(
  NumTessera int primary key,
  NomeSquadra char(15),
  FOREIGN KEY (NumTessera) REFERENCES Giocatore(NumTessera),
  FOREIGN KEY (NomeSquadra) REFERENCES Squadra(Nome),        
  Numero int CHECK (Numero BETWEEN '1' AND '99'),
  stipendio decimal(8, 2)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS ContrattoAllenatore(
  NumTessera int primary key,
  NomeSquadra char(15),
  FOREIGN KEY (NumTessera) REFERENCES Allenatore(NumTessera),
  FOREIGN KEY (NomeSquadra) REFERENCES Squadra(Nome),        
  stipendio decimal(8, 2)
)ENGINE=INNODB;

create table if not exists Partita (
    IDPartita INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    NumGiornata int NOT NULL,
    SquadraCasa char(15) NOT NULL,
    foreign key (SquadraCasa)
        references Squadra (Nome),
    GoalSquadraCasa int NOT NULL DEFAULT '0',
    SquadraOspite char(15) NOT NULL,
    foreign key (SquadraOspite)
        references Squadra (Nome),
    GoalSquadraOspite int NOT NULL DEFAULT '0',
    data date
)  ENGINE=INNODB;

create table if not exists Goal (
    IDPartita int NOT NULL,
    Minuto int NOT NULL,
    Marcatore int,
	primary key(IDPartita),
    foreign key (IDPartita) references Partita (IDPartita),
    foreign key (Marcatore) references Giocatore (NumTessera)
)  ENGINE=INNODB;

create table if not exists Classifica (
  IDClassifica INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Nome char(15) NOT NULL,
  Vittorie TINYINT DEFAULT '0',
  Pareggi TINYINT DEFAULT '0',
  Sconfitte TINYINT DEFAULT '0',
  Punti TINYINT NOT NULL
) ENGINE= INNODB; 
ALTER TABLE Classifica ADD FOREIGN KEY (Nome) REFERENCES Squadra (Nome) ON DELETE CASCADE ON UPDATE CASCADE;

############################################################################
################  Creazione istanza: popolamento database  #################
############################################################################
load data local infile 'C:/Users/simonecanocchi/Desktop/Presidente.csv'
into table Presidente
fields terminated by ','
ignore 2 lines
(Nome, Cognome, CodFiscale);

load data local infile 'C:/Users/simonecanocchi/Desktop/Squadra.csv'
into table Squadra
fields terminated by ','
ignore 2 lines
(Nome, DataCreazione, Citta, Serie, Stadio, Sponsor, ColoriSociali, Presidente);

load data local infile 'C:/Users/simonecanocchi/Desktop/Giocatore.csv'
into table Giocatore
fields terminated by ','
ignore 2 lines
(NumTessera, Cognome, Nome, CittaNascita, DataNascita, Ruolo);

load data local infile 'C:/Users/simonecanocchi/Desktop/Allenatore.csv'
into table Allenatore
fields terminated by ','
ignore 2 lines
(NumTessera, Cognome, Nome, CittaNascita, DataNascita, NumSquadre);

load data local infile 'C:/Users/simonecanocchi/Desktop/Partita.csv'
into table Partita
fields terminated by ','
ignore 2 lines
(IDPartita, NumGiornata, SquadraCasa, GoalSquadraCasa, SquadraOspite, GoalSquadraOspite, data);

load data local infile 'C:/Users/simonecanocchi/Desktop/Goal.csv'
into table Goal
fields terminated by ','
ignore 2 lines
(IDPartita, Minuto, Marcatore);

load data local infile 'C:/Users/simonecanocchi/Desktop/ContrattoGiocatore.csv'
into table ContrattoGiocatore
fields terminated by ','
ignore 2 lines
(NumTessera, NomeSquadra, Stipendio, Numero);

load data local infile 'C:/Users/simonecanocchi/Desktop/ContrattoAllenatore.csv'
into table ContrattoAllenatore
fields terminated by ','
ignore 2 lines
(NumTessera, NomeSquadra, Stipendio);

INSERT INTO Partita
SET IDPartita='18',NumGiornata='22', SquadraCasa='Fiorentina', GoalSquadraCasa='1', SquadraOspite='Torino', GoalSquadraOspite='0', data='2019/03/22';

INSERT INTO Goal
SET IDPartita='18', Minuto='12',Marcatore='1';

INSERT INTO Presidente(Nome, Cognome, CodFiscale)
VALUES ('Mario', 'Maresca', 'PLXCYR55L21A866Q');

INSERT INTO Squadra(Nome, DataCreazione, Citta, Serie, Stadio, Sponsor, ColoriSociali, Presidente)
VALUES ('Antella', '1999/06/27', 'Antella', 'D', 'Pulicciano', 'MBA', 'Bianco Azzurro', 'PLXCYR55L21A866Q');

#############################################################################
################  Ulteriori vincoli tramite viste e/o trigger ################
#############################################################################
DELIMITER $$
CREATE TRIGGER ControlloMinuto
  BEFORE INSERT ON Goal
  FOR EACH ROW
BEGIN
  IF NEW.Minuto < 1 THEN
    SET NEW.Minuto = 1;
  ELSEIF NEW.Minuto > 95 THEN
    SET NEW.Minuto = 95;
  END IF;
END $$
DELIMITER ;

create view Cannonieri(Nome,Cognome,NumTessera,Squadra,NumGoal) as
select Nome, Cognome, Giocatore.NumTessera, ContrattoGiocatore.NomeSquadra, count(*)
from Giocatore join ContrattoGiocatore on (Giocatore.NumTessera=ContrattoGiocatore.NumTessera) join Goal on Giocatore.NumTessera=Goal.Marcatore
group by NomeSquadra, Marcatore;

create view Vittorie(Squadra) as
select SquadraCasa as squadra
from Partita
where GoalSquadraCasa>GoalSquadraOspite
union all
select SquadraOspite as squadra
from Partita
where GoalSquadraCasa<GoalSquadraOspite;
############################################################################
################ 				 Interrogazioni   		   #################
############################################################################

# Possibilmente di vario tipo:  selezioni, proiezioni, join, con raggruppamento, 
# annidate, con funzioni per il controllo del flusso.
SELECT * FROM Goal;

DELETE FROM Squadra
WHERE Nome LIKE 'Antella';

SELECT Nome,Cognome
FROM Giocatore JOIN ContrattoGiocatore ON Giocatore.NumTessera=ContrattoGiocatore.NumTessera
WHERE NomeSquadra LIKE 'Lazio';

SELECT Nome as NomeSquadra
FROM Squadra, Partita
WHERE Serie = 'A' AND
 SquadraOspite = Nome AND
 goalSquadraOspite >= 2; 

SELECT G.Nome, G.Cognome
FROM Giocatore G, ContrattoGiocatore GC, Squadra S, Allenatore A,  ContrattoAllenatore CA
WHERE G.NumTessera = GC.NumTessera AND
 S.Serie = 'A' AND
 S.Nome = CA.NomeSquadra AND
 A.NumSquadre = 11;

SELECT sum(GoalSquadraCasa) as GoalFattiInCasadallaFiorentina
FROM Partita
WHERE SquadraCasa = 'Fiorentina';  

SELECT P.NumGiornata, P.SquadraCasa, P.GoalSquadraCasa, P.SquadraOspite, P.GoalSquadraOspite, MAX(G.Minuto) as MinutoUltimoGoal
FROM  Partita P, Goal G 
WHERE P.IDPartita = G.IDPartita;

SELECT P.NumGiornata, P.SquadraCasa, P.GoalSquadraCasa, P.SquadraOspite, P.GoalSquadraOspite, G.Minuto as PrimoGoal
FROM  Partita P INNER JOIN Goal G ON P.IDPartita = G.IDPartita
ORDER BY Minuto ASC;

SELECT Partita. SquadraCasa, Partita.GoalSquadraCasa, Partita.SquadraOspite, Partita.GoalSquadraOspite, Giocatore.Cognome, Giocatore.Nome
FROM Partita JOIN Goal ON (Partita.IDPartita = Goal.IDPartita) 
JOIN Giocatore ON (Giocatore.NumTessera = Goal.Marcatore);

SELECT A.Cognome as Allenatore, CA.NomeSquadra AS Squadra
FROM Allenatore A INNER JOIN ContrattoAllenatore CA 
ON A.NumTessera=CA.NumTessera;

SELECT count(*) AS TotaleVittorie
FROM Partita
JOIN Squadra AS S1 ON SquadraCasa = s1.Nome
JOIN Squadra AS S2 ON SquadraOspite = s2.Nome
WHERE (SquadraCasa = 'Fiorentina' AND s2.Citta = 'Roma'
AND GoalSquadraCasa > GoalSquadraOspite)
OR (SquadraOspite = 'Fiorentina' AND s1.Citta = 'Roma'
AND GoalSquadraOspite > GoalSquadraCasa);

SELECT Giocatore.NumTessera, Nome, Cognome
FROM Giocatore JOIN ContrattoGiocatore ON Giocatore.NumTessera=ContrattoGiocatore.NumTessera JOIN Partita ON (SquadraCasa = NomeSquadra
AND GoalSquadraOspite >=ALL (SELECT GoalSquadraCasa FROM Partita)
AND GoalSquadraOspite >=ALL (SELECT GoalSquadraOspite FROM Partita))
OR
(SquadraOspite = NomeSquadra
AND GoalSquadraCasa >=ALL (SELECT GoalSquadraCasa FROM Partita)
AND GoalSquadraCasa >=ALL (SELECT GoalSquadraOspite FROM Partita))
WHERE ruolo = 'Portiere';

SELECT NumGiornata, AVG(GoalSquadraCasa)
FROM Partita JOIN Squadra ON SquadraOspite = Nome
WHERE Citta <> 'Torino'
GROUP BY NumGiornata
HAVING MAX(GoalSquadraCasa) < 5;

SELECT Cognome, Nome, NumTessera
FROM Cannonieri AS C
WHERE NumGoal >=ALL (SELECT NumGoal
	FROM Cannonieri
	WHERE Squadra = C.Squadra)
ORDER BY Cognome DESC
LIMIT 10;

SELECT Squadra
FROM Vittorie
GROUP BY Squadra;

SELECT DISTINCT Ruolo
FROM Giocatore
WHERE Ruolo NOT IN(SELECT Ruolo
FROM Giocatore JOIN ContrattoGiocatore ON Giocatore.NumTessera=ContrattoGiocatore.NumTessera JOIN Squadra ON ContrattoGiocatore.NomeSquadra = Squadra.Nome
WHERE Citta = 'Roma');

SELECT Nome, Cognome, NomeSquadra
FROM Giocatore JOIN ContrattoGiocatore AS CG1 ON Giocatore.NumTessera=CG1.NumTessera  
WHERE DataNascita >=ALL(SELECT DataNascita
FROM Giocatore JOIN ContrattoGiocatore ON Giocatore.NumTessera=ContrattoGiocatore.NumTessera
WHERE NomeSquadra = CG1.NomeSquadra);
 

SELECT SquadraCasa, SquadraOspite, CASE
WHEN GoalSquadraCasa>3 or GoalSquadraOspite>3 THEN 'Partita emozionante'
WHEN 1<=GoalSquadraCasa<=3 or 1<=GoalSquadraOspite<=3 THEN 'Partita classica'
ELSE 'Partita noiosa'
END AS Valutazione
FROM Partita;

SELECT AVG(Minuto) AS MediaGoalMinuto
FROM Goal; 

SELECT Squadra, SUM(Punti) AS punteggio
FROM (
   SELECT SquadraCasa AS squadra, IF(GoalSquadraCasa > GoalSquadraOspite, 3, IF(GoalSquadraCasa = GoalSquadraOspite, 1, 0)) AS punti, IF(GoalSquadraCasa > GoalSquadraOspite, 1, 0), IF(GoalSquadraCasa = GoalSquadraOspite, 1, 0), IF(GoalSquadraCasa < GoalSquadraOspite, 1, 0)
   FROM Partita INNER JOIN Squadra ON Partita.SquadraCasa=Squadra.Nome
   WHERE Serie='A'
   UNION ALL
   SELECT SquadraOspite AS squadra, IF(GoalSquadraCasa < GoalSquadraOspite, 3, IF(GoalSquadraCasa = GoalSquadraOspite, 1, 0)) AS punti, IF(GoalSquadraCasa < GoalSquadraOspite, 1, 0), IF(GoalSquadraCasa = GoalSquadraOspite, 1, 0), IF(GoalSquadraCasa > GoalSquadraOspite, 1, 0)
   FROM Partita INNER JOIN Squadra ON Partita.SquadraOspite=Squadra.Nome
   WHERE Serie='A'
) AS tab_punti_storico
GROUP BY tab_punti_storico.Squadra
ORDER BY punteggio DESC;
############################################################################
################          Procedure e funzioni             #################
############################################################################
DELIMITER $$
CREATE PROCEDURE SetupClassifica()
BEGIN
  
  DECLARE lastTeam BOOLEAN DEFAULT FALSE;
  DECLARE _teamName char(15);

  DECLARE teamCursor CURSOR FOR
    SELECT Squadra.Nome
    FROM   Squadra;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lastTeam = TRUE;
 
  OPEN teamCursor;
  teamLoop: LOOP

    FETCH teamCursor INTO _teamName;
    IF (lastTeam) THEN
      LEAVE teamLoop;
    END IF;
  
    INSERT INTO Classifica(Nome, vittorie, Pareggi, Sconfitte, Punti) VALUES
      (_teamName, 0, 0, 0, 0);
  END LOOP teamLoop;
  CLOSE teamCursor;
END $$

CREATE PROCEDURE StampaClassifica()
BEGIN
  SELECT   Squadra.Nome, Classifica.Vittorie AS V, Classifica.Pareggi AS P, Classifica.Sconfitte AS S, Classifica.Punti AS TP
  FROM     Classifica INNER JOIN Squadra ON Classifica.Nome = Squadra.Nome
  WHERE    Serie= 'B'
  ORDER BY Classifica.Punti DESC, Classifica.Vittorie DESC, Classifica.Pareggi DESC;
END $$

CREATE PROCEDURE StampaGiornata(IN Giornata INT)
BEGIN
  SELECT   NumGiornata, SquadraCasa, GoalSquadraCasa, SquadraOspite, GoalSquadraOspite
  FROM     Partita
  WHERE    Partita.NumGiornata = Giornata
  ORDER BY NumGiornata ASC;
END $$

CREATE PROCEDURE SetClassifica(IN _day TINYINT UNSIGNED)
BEGIN
  -- Dichiara le variabili utilizzate.
  DECLARE lastMatch BOOLEAN DEFAULT FALSE;
  DECLARE _matchId INTEGER UNSIGNED;
   DECLARE _team1Id, _team2Id CHAR(15);
  DECLARE _goals1, _goals2 TINYINT UNSIGNED;
  -- Dichiara i cursori e gli handler utilizzati.
  DECLARE matchCursor CURSOR FOR
    SELECT IDPartita, SquadraCasa, SquadraOspite,GoalSquadraCasa, GoalSquadraOspite
    FROM   Partita
    WHERE  NumGiornata = _day;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lastMatch = TRUE;
  -- Per ogni partita...
  OPEN matchCursor;
  matchLoop: LOOP
    -- ...prova a recuperare la chiave primaria della partita e delle squadre in
    -- casa e fuori casa, uscendo dal loop se era l'ultimo record;
    FETCH matchCursor INTO _matchId, _team1Id, _team2Id, _goals1, _goals2;
    IF (lastMatch) THEN
      LEAVE matchLoop;
    END IF;

    IF (_goals1 > _goals2) THEN
      UPDATE Classifica
      SET    Vittorie = Vittorie + 1,
             Punti = Punti + 3
      WHERE  Classifica.Nome = _team1Id;
      UPDATE Classifica
      SET    Sconfitte = Sconfitte + 1
      WHERE  Classifica.Nome = _team2Id;
    ELSEIF (_goals1 = _goals2) THEN
      UPDATE Classifica
      SET    Pareggi = Pareggi + 1,
             Punti = Punti + 1
      WHERE  Classifica.Nome = _team1Id;
      UPDATE Classifica
      SET    Pareggi = Pareggi + 1,
             Punti = Punti + 1
      WHERE  Classifica.Nome = _team2Id;
    ELSE
      UPDATE Classifica
      SET    Sconfitte = Sconfitte + 1
      WHERE  Classifica.Nome = _team1Id;
      UPDATE Classifica
      SET    Vittorie = Vittorie + 1,
             Punti = Punti + 3
      WHERE  Classifica.Nome = _team2Id;
    END IF;
  END LOOP matchLoop;
  CLOSE matchCursor;
END $$

CREATE PROCEDURE Gioca()
BEGIN
	CALL SetupClassifica();
	CALL StampaClassifica();
	CALL StampaGiornata(31);
	CALL SetClassifica(31);
	CALL StampaClassifica();
END $$
DELIMITER ;

CALL Gioca();
