use HowlOfADog
go

---------------------A------------------------
-- modify the type of a column

CREATE PROCEDURE SetDonationAmountFloat
AS
    ALTER TABLE Donations
    ALTER COLUMN DonationAmount FLOAT
GO

CREATE PROCEDURE SetDonationAmountBackInt
AS
    ALTER TABLE Donations
    ALTER COLUMN DonationAmount INT
GO

EXEC SetDonationAmountFloat
SELECT * FROM Donations
EXEC SetDonationAmountBackInt
GO


---------------------B------------------------
-- add / remove a column

CREATE PROCEDURE AddBonusMoneyOnEmployees
AS
    ALTER TABLE Employees
    ADD BonusMoney INT
GO

CREATE PROCEDURE RemoveBonusMoneyOnEmployees
AS
    ALTER TABLE Employees
    DROP COLUMN BonusMoney
GO

EXEC AddBonusMoneyOnEmployees
SELECT * FROM Employees
EXEC RemoveBonusMoneyOnEmployees
GO


---------------------C------------------------
-- add / remove a DEFAULT constraint

CREATE PROCEDURE AddDefaultSalary
AS
    ALTER TABLE Employees
    ADD CONSTRAINT DefaultSalaryConstraint DEFAULT (25000) FOR Salary
GO

CREATE PROCEDURE RemoveDefaultSalary
AS
    ALTER TABLE Employees
    DROP CONSTRAINT DefaultSalaryConstraint
GO

EXEC AddDefaultSalary
INSERT INTO Employees(EmployeeID, Job) VALUES ('7500811196572', 'vet') -- check constraint
DELETE FROM Employees WHERE EmployeeID = '7500811196572'
SELECT * FROM Employees
EXEC RemoveDefaultSalary
GO


---------------------G------------------------
-- create / drop a table
-- mai intai G pentru ca imi trebuie pt D, E, F. creeaza tabelul, dupa fa la cele 3puncte, dupa sterge tabelul.

CREATE PROCEDURE CreateAnimalVisits
AS
    CREATE TABLE AnimalVisits
    (
        PersonCNP	varchar(13) NOT NULL,
		AnimalID    int NOT NULL,
        HappinessLevel INT,
		DateOfVisit date NOT NULL,
		CONSTRAINT IdPrimaryKey PRIMARY KEY(PersonCNP)
    )
GO

CREATE PROCEDURE DropAnimalVisits
AS
    DROP TABLE AnimalVisits
GO

EXEC CreateAnimalVisits
EXEC DropAnimalVisits
GO


---------------------D------------------------
-- add / remove a primary key

CREATE PROCEDURE AddPrimaryKeyAnimalVisits
AS
    ALTER TABLE AnimalVisits DROP CONSTRAINT IdPrimaryKey
    ALTER TABLE AnimalVisits ADD CONSTRAINT IdNewPrimaryKey PRIMARY KEY (PersonCNP, AnimalID, DateOfVisit)
GO

CREATE PROCEDURE RemovePrimaryKeyAnimalVisits
AS
    ALTER TABLE AnimalVisits DROP CONSTRAINT IdNewPrimaryKey
    ALTER TABLE AnimalVisits ADD CONSTRAINT IdPrimaryKey PRIMARY KEY (PersonCNP)
GO


EXEC AddPrimaryKeyAnimalVisits
EXEC RemovePrimaryKeyAnimalVisits
GO


---------------------E------------------------
-- add / remove a candidate key;
-- A super key is a group of single or multiple keys which identifies rows in a table.
-- Candidate Key is a super key with no repeated attributes.

CREATE PROCEDURE AddAnimalIDCandidateKeyAnimalVisits
AS
    ALTER TABLE AnimalVisits ADD CONSTRAINT AnimalIDCandidateKey UNIQUE (AnimalID)
GO

CREATE PROCEDURE RemoveAnimalIDCandidateKeyAnimalVisits
AS
    ALTER TABLE AnimalVisits DROP CONSTRAINT AnimalIDCandidateKey
GO


EXEC AddAnimalIDCandidateKeyAnimalVisits
EXEC RemoveAnimalIDCandidateKeyAnimalVisits
GO


---------------------F------------------------
-- add / remove a foreign key

CREATE PROCEDURE AddForeignKeys
AS
    ALTER TABLE AnimalVisits
    ADD CONSTRAINT PersonCNPForeignKey FOREIGN KEY (PersonCNP) REFERENCES People(PersonID)
	ALTER TABLE AnimalVisits
    ADD CONSTRAINT AnimalIDForeignKey FOREIGN KEY (AnimalID) REFERENCES Animals(AnimalID)
GO

CREATE PROCEDURE RemoveForeignKeys
AS
    ALTER TABLE AnimalVisits DROP CONSTRAINT PersonCNPForeignKey
	ALTER TABLE AnimalVisits DROP CONSTRAINT AnimalIDForeignKey
GO

EXEC AddForeignKeys
EXEC RemoveForeignKeys
Go

-- don't forget to go back to G to drop the table!!


----------------------------------------------
-- Create a new table that holds the current version of the database schema. 
-- Simplifying assumption: the version is an integer number.
-- Write a stored procedure that receives as a parameter a version number and brings the database to that version.


CREATE TABLE VersionHistory
(
    VERSION INT
)
INSERT INTO VersionHistory VALUES (0) -- first version

CREATE TABLE ProcedureTable
(
    UndoProcedure VARCHAR(100),
    RedoProcedure VARCHAR(100),
    Version       INT PRIMARY KEY
)
GO


-- DROP PROCEDURE GoToVersion
CREATE PROCEDURE GoToVersion (@InputVersion INT) 
AS
DECLARE @currentVersion INT;
    SET @currentVersion = (SELECT TOP 1 VERSION FROM VersionHistory);  
DECLARE @currentStatement CHAR(100);
DECLARE @procedure NVARCHAR(100); -- Procedure sp_executesql expects parameter '@statement' of type 'ntext/nchar/nvarchar'
DECLARE @var2 INT
DECLARE @maximumVersion INT;
	SET @maximumVersion = (SELECT TOP 1 VERSION FROM ProcedureTable ORDER BY Version DESC)

if @InputVersion = @currentVersion
	BEGIN
		print 'You already are at this version! Current version: ' + convert(varchar(10), @currentVersion)
		return
	END
if @InputVersion < 0
	BEGIN
		print 'Incorect input version! Less than the minimum version: 0' 
		return
	END
if @InputVersion > @maximumVersion
	BEGIN
		print 'Incorect input version! More than the maximum version: ' + convert(varchar(10), @maximumVersion)
		return
	END

print 'From current version = ' + convert(varchar(10), @currentVersion) + ' to wanted version = ' + convert(varchar(10), @InputVersion)	

WHILE @currentVersion != @InputVersion
BEGIN
	if @currentVersion > @InputVersion  -- atunci trebuie sa fac undo	
	BEGIN
		DECLARE UndoCursor CURSOR FOR SELECT UndoProcedure FROM ProcedureTable
		OPEN UndoCursor  

		
		------ FETCH ABSOLUTE @currentVersion FROM UndoCursor INTO @currentStatement
		-- error: The fetch type Absolute cannot be used with dynamic cursors.??
		-- Dynamic cursors detect all changes made to the rows in the result set

		-- get the last row
		SELECT @var2 = 0
		WHILE @var2 != @currentVersion
		BEGIN
			FETCH FROM UndoCursor INTO @currentStatement
			SELECT @var2 = @var2 + 1
		END

		BEGIN ---executa
			SET @procedure = 'exec ' + @currentStatement
			print 'The procedure was:' + @procedure + 'to reach version: ' + convert(varchar(10), @currentVersion-1)
			EXEC sp_executesql @procedure
			UPDATE VersionHistory
			SET VERSION = VERSION - 1
			SET @currentVersion = @currentVersion - 1;
		END
		CLOSE UndoCursor
		DEALLOCATE UndoCursor
	END

    else  -- trebuie sa fac redo
    BEGIN
        DECLARE RedoCursor CURSOR FOR SELECT PT.RedoProcedure FROM ProcedureTable PT
        OPEN RedoCursor
		SELECT @var2 = -1
		WHILE @var2 != @currentVersion
		BEGIN
			FETCH FROM RedoCursor INTO @currentStatement
			SELECT @var2 = @var2 + 1
		END

		
		BEGIN
			SELECT @procedure = 'exec ' + @currentStatement
			print 'The procedure was: ' + @procedure + 'to reach version: ' + convert(varchar(10), @currentVersion+1) 
			EXEC sp_executesql @procedure
			UPDATE VersionHistory
			SET VERSION = VERSION + 1
			SET @currentVersion = @currentVersion + 1;
		END
        CLOSE RedoCursor
        DEALLOCATE RedoCursor
    END
END
GO


INSERT INTO ProcedureTable(UndoProcedure, RedoProcedure, Version)
VALUES
	   ('DropAnimalVisits', 'CreateAnimalVisits', 1),
       ('RemoveBonusMoneyOnEmployees', 'AddBonusMoneyOnEmployees', 2),
       ('SetDonationAmountBackInt', 'SetDonationAmountFloat', 3),
       ('RemoveDefaultSalary', 'AddDefaultSalary', 4),
       ('RemoveAnimalIDCandidateKeyAnimalVisits', 'AddAnimalIDCandidateKeyAnimalVisits', 5),
       ('RemoveForeignKeys', 'AddForeignKeys', 6),
       ('RemovePrimaryKeyAnimalVisits', 'AddPrimaryKeyAnimalVisits', 7)
SELECT * FROM ProcedureTable
SELECT * FROM VersionHistory
-- UPDATE VersionHistory SET VERSION = 0
EXECUTE GoToVersion @InputVersion = 10
Go