CREATE DATABASE AdoptionsDB
USE AdoptionsDB
GO

--------------- CREATE TABLES -------------------
-- Work on 3 tables of the form Ta(aid, a2, …), Tb(bid, b2, …), Tc(cid, aid, bid, …), where:
-- - aid, bid, cid, a2, b2 are integers;
-- - the primary keys are underlined;
-- - a2 is UNIQUE in Ta;
-- - aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively.

CREATE TABLE People -- Ta
(                                       
    PersonID INT PRIMARY KEY IDENTITY, -- aid
    PersonName VARCHAR(50),
    PhoneNumber INT UNIQUE, -- a2
    City VARCHAR(MAX)
)
CREATE TABLE Animals -- Tb
(                                             
    AnimalID INT PRIMARY KEY IDENTITY, -- bid
    AnimalName VARCHAR(50),
    Age INT -- b2
)
CREATE TABLE Adoptions -- Tc
(                                                     
    Person INT REFERENCES People (PersonID), -- aid
    Animal INT REFERENCES Animals (AnimalID), -- bid
    AdoptionID INT PRIMARY KEY IDENTITY  -- cid
)
GO

DROP TABLE People
DROP TABLE Animals
DROP TABLE Adoptions
go

------------------------- INSERT VALUES ------------------
INSERT INTO People
VALUES ('Agatha', 2527777, 'Bacau'),
	   ('Cristopher', 3333332, 'Sighisoara'),
	   ('Ion', 6673543, 'Zalau'),
	   ('Albert', 3742742, 'Bucuresti'),
	   ('Cristiana', 1234567, 'Brasov'),
	   ('Crina', 2533543, 'Vaslui'),
	   ('Roberta', 4422674, 'Bistrita'),
	   ('Bianca', 7553568, 'Iasi'),
	   ('Robert', 9997543, 'Timisoara'),
	   ('Diana', 4364553, 'Bacau')
SELECT * FROM People
DELETE People
GO

INSERT INTO Animals
VALUES ('Finnegan Fox', 1),
	   ('Pufi', 5),
	   ('Lili', 5),
	   ('Phinneas', 7),
	   ('Hardy', 8),
	   ('Bojangles', 2),
	   ('Grady', 4),
	   ('Nino', 8),
	   ('Riddle', 1),
	   ('Dazzle', 6)
SELECT * FROM Animals
DELETE Animals
GO

CREATE OR 
ALTER PROCEDURE GenerateNrOfPeople @nrOfPeople INT
AS
BEGIN
	DECLARE @i INT;
	DECLARE @phoneNr INT;
	SET @i = 0;
	SET @phoneNr = 5000000;
	while (@i < @nrOfPeople)
		BEGIN 
		INSERT INTO People VALUES ('Person Number ' + convert(varchar(10), @i), @phoneNr, 'City Number ' + convert(varchar(10), @i%10))
		set @i = @i+1;
		set @phoneNr = @phoneNr+1;
		END
END
GO

CREATE OR 
ALTER PROCEDURE GenerateNrOfAnimals @nrOfAnimals INT
AS
BEGIN
	DECLARE @i INT;
	SET @i = 0;
	while (@i < @nrOfAnimals)
		BEGIN 
		INSERT INTO Animals VALUES ('Animal Number ' + convert(varchar(10), @i), @i % 10);
		set @i = @i+1;
		END
END
GO

CREATE OR
ALTER PROCEDURE GenerateNrOfAdoptions @nrOfAdoptions INT
AS
BEGIN
    DECLARE @personID INT, @animalID INT, @added INT
    SELECT @added = 0
    WHILE @added < @nrOfAdoptions
        BEGIN
            SET @personID = (SELECT TOP 1 PersonID FROM People ORDER BY NEWID())
            SET @animalID = (SELECT TOP 1 AnimalID FROM Animals ORDER BY NEWID())

            IF EXISTS(SELECT * FROM ( SELECT * FROM Adoptions WHERE Person = @personID) as PeopleFromAdoptions
                      WHERE Animal = @animalID)
                BEGIN
                    CONTINUE
                END
            INSERT INTO Adoptions
            VALUES (@personID, @animalID)

            SET @added = @added + 1
        END
END

EXEC GenerateNrOfPeople 7000
EXEC GenerateNrOfAnimals 10000
EXEC GenerateNrOfAdoptions 4500

SELECT * FROM People
SELECT * FROM Animals
SELECT * FROM Adoptions

INSERT INTO Adoptions
VALUES (3, 1),
	   (4, 2),
	   (5, 3),
	   (6, 4),
	   (8, 5),
	   (10, 6),
	   (11, 10)


SELECT * FROM Adoptions
DELETE Adoptions
GO

--------------------------- A --------------------------
-- https://www.sqlshack.com/sql-server-index-structure-and-concepts/
-- a. Write queries on Ta such that their execution plans contain the following operators:
-- - clustered index scan;
-- - clustered index seek;
-- - nonclustered index scan;
-- - nonclustered index seek;
-- - key lookup.

-- Clustered index scan -> the primary key is the clustered index. In clustered index, index contains pointer to block but not direct data. 
SELECT *
FROM People
ORDER BY PersonID  -- cost > 0.45


-- Non clustered index scan -> remember: uniqueness – useful information for the query optimizer In non-clustered index, index contains the pointer to data. 
DROP INDEX IF EXISTS nonClusteredIndexPerson on People -- cost > 0.2
CREATE NONCLUSTERED INDEX nonClusteredIndexPerson ON People(PhoneNumber) -- cost < 0.2

SELECT PhoneNumber
FROM People


-- Clustered index seek 
SELECT *
FROM People
WHERE PersonID > 3500


-- Non clustered index seek
DROP INDEX IF EXISTS nonClusteredIndexPerson on People -- cost > 0.2
DROP INDEX IF EXISTS nonClusteredIndexPerson5005000 on People -- cost > 0.2
SELECT PhoneNumber
FROM People
WHERE PhoneNumber > 5000000
  AND PhoneNumber < 6000000


-- Key Lookup
SELECT PersonName
FROM People
WHERE PhoneNumber = 5003078


------------------------- B ------------------------
-- Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
-- Create a nonclustered index that can speed up the query. 
-- Examine the execution plan again.

-- no index: ~0.05 (operator cost) 92ms, 155ms, 121ms, without index;
--       for age: 44, 53, 47 => average = 48
-- non clustered index: ~0.007 (operator cost) 110ms, 168, 148ms
--		 for age: 35, 46, 50 => average = 43,6
DROP INDEX IF EXISTS nonClusteredIndexAnimal ON Animals
CREATE NONCLUSTERED INDEX nonClusteredIndexAnimal ON Animals (Age) INCLUDE (AnimalName, AnimalID)

set statistics time on -- see "sql server execution times"->"elapsed time" in messages
	SELECT Age
	FROM Animals
	WHERE Age = 6
set statistics time off
GO

-- for phone nr extra
DROP INDEX IF EXISTS nonClusteredIndexPerson on People
CREATE NONCLUSTERED INDEX nonClusteredIndexPerson ON People(PhoneNumber) -- cost < 0.2

-- no index(<): 60, 61, 69
-- with index(<): 65, 64, 66
set statistics time on
	SELECT PhoneNumber
	FROM People
	WHERE PhoneNumber = 5005000
set statistics time off

SELECT * FROM People


-------------------------- C ------------------------------
-- Create a view that joins at least 2 tables. 
-- Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

CREATE OR ALTER VIEW ViewC AS
SELECT TOP 1000 P.PersonName , Anim.AnimalName
FROM People P
		 INNER JOIN Adoptions A on P.PersonID = A.Person
		 INNER JOIN Animals Anim on Anim.AnimalID = A.Animal
WHERE P.PhoneNumber > 5000000 AND Anim.Age > 5
ORDER BY Anim.Age
GO

-- cardinality is high because we have unique values for phone numbers, but 
-- 103, 57, 46 -> sometimes it has 50-60 values, but sometimes 100+
-- 50, 55, 53
set statistics time on
	SELECT * FROM ViewC 
set statistics time off

DROP INDEX IF EXISTS nonClusteredIndexPerson on People
CREATE NONCLUSTERED INDEX nonClusteredIndexPerson ON People(PhoneNumber) INCLUDE (PersonName)
DROP INDEX IF EXISTS nonClusteredIndexAnimal ON Animals
CREATE NONCLUSTERED INDEX nonClusteredIndexAnimal ON Animals (Age) INCLUDE (AnimalName)