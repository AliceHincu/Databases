--- CREATION OF DATABASE ---
create database SpaceTravelGuide
use SpaceTravelGuide
go

--- CREATION OF TABLES ---
-- Your task is to implement a set of stored procedures for running tests and storing their results. Your tests must include at least 3 tables:
---- a table with a single-column primary key and no foreign keys;
---- a table with a single-column primary key and at least one foreign key;
---- a table with a multicolumn primary key,


create table Planets( ---- a table with a single-column primary key and no foreign keys;
	Id int PRIMARY KEY identity(1,1),
	PlanetName varchar(max),
	PopulationNumber int,
	Currency varchar(max)
)

create table Cities( ---- a table with a single-column primary key and at least one foreign key;
	Id int PRIMARY KEY identity(1,1),
	CityName varchar(max),
	PlanetId int,
	PopulationNumber int,
	CONSTRAINT FK_PlanetId FOREIGN KEY(PlanetId) REFERENCES Planets(Id) 

)

create table Creatures( ---- a table with a multicolumn primary key (only one name per city. idea for view: how many creatures named X are in a planet)
	
	CreatureName varchar(255),
	CityId int,
	Age int, 
	CONSTRAINT PK_CreatureId PRIMARY KEY (CreatureName,	Id),
	CONSTRAINT FK_CityId FOREIGN KEY(Id) REFERENCES Cities(Id)
)


drop table Creatures
drop table Cities
drop table Planets
go

--- CREATION OF VIEWS ---
--and 3 views:
--- a view with a SELECT statement operating on one table;
--- a view with a SELECT statement operating on at least 2 tables;
--- a view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables.

-- SELECT THE NAME AND POPULATION OF THE PLANETS WITH A POPULATION SMALLER THAN 10000
CREATE OR ALTER VIEW  ViewPlanets10000 --- a view with a SELECT statement operating on one table;
AS
	select PlanetName, PopulationNumber
	from Planets
	where PopulationNumber < 10000
GO

SELECT * FROM ViewPlanets10000
GO

-- SELECT THE CITY AND THE PLANET OF A CREATURE
CREATE OR ALTER VIEW  ViewCreatureOrigin --- a view with a SELECT statement operating on at least 2 tables;
AS
	select Cr.CreatureName, C.CityName, P.PlanetName as Planet
	from Planets P, Cities C, Creatures Cr
	where Cr.Id = C.Id and C.PlanetId = P.Id
GO

SELECT * FROM ViewCreatureOrigin
SELECT * FROM Creatures
GO

-- COUNT THE CITIES OF PLANETS THAT HAVE AT LEAST 1 CITY
CREATE OR ALTER VIEW ViewPlanetCity -- a view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables.
AS
	select P.PlanetName, count(*) as nrCities
	from Planets P, Cities C
	where C.PlanetId = P.Id
	group by P.PlanetName
GO

SELECT * FROM ViewPlanetCity
SELECT * FROM Cities


--------------- HELPER FUNCTIONS -----------------
-- get the column data type
CREATE OR ALTER FUNCTION ColumnDataType (@tableName varchar(max), @columnName varchar(max))
RETURNS VARCHAR(max) AS
BEGIN
	RETURN (
		SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS 
		where table_name = @tableName and column_name = @columnName)
END
GO

-- check if it's a primary key
CREATE OR ALTER FUNCTION IsPrimaryKey (@tableName varchar(max), @columnName varchar(max))
RETURNS VARCHAR(max) AS
BEGIN
	DECLARE @isPrimaryKey int;
	SET @isPrimaryKey = (SELECT count(*) from 
							INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
							INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col
						 WHERE 
							Col.Constraint_Name = Tab.Constraint_Name 
						 AND Col.Table_Name = Tab.Table_Name
						 AND Constraint_Type = 'PRIMARY KEY'
						 AND Tab.Table_name = @tableName 
						 AND Col.column_name = @columnName 
						 )
	IF @isPrimaryKey = 0 RETURN 'NO'
	RETURN 'YES';
END
GO

-- check if it's a foreign key
CREATE OR ALTER FUNCTION IsForeignKey (@tableName varchar(max), @columnName varchar(max))
RETURNS VARCHAR(max) AS
BEGIN
	DECLARE @isForeignKey int;
	SET @isForeignKey = (SELECT count(*) from 
							INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
							INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col
						 WHERE 
							Col.Constraint_Name = Tab.Constraint_Name 
						 AND Col.Table_Name = Tab.Table_Name
						 AND Constraint_Type = 'FOREIGN KEY'
						 AND Tab.Table_name = @tableName 
						 AND Col.column_name = @columnName 
						 )
	IF @isForeignKey = 0 RETURN 'NO'
	RETURN 'YES';
END
GO

-- get the table that it's referencing
CREATE OR ALTER FUNCTION ColumnReferenceTable (@tableName varchar(max), @columnName varchar(max))
RETURNS VARCHAR(max) AS
BEGIN

	DECLARE @referenceTableName varchar(max);
	DECLARE @constraintName varchar(max) = (SELECT CONSTRAINT_NAME 
											FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE CU
											WHERE CU.TABLE_NAME = @tableName AND COLUMN_NAME = @columnName
											INTERSECT
											SELECT CONSTRAINT_NAME
											FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab
											WHERE Tab.TABLE_NAME = @tableName AND CONSTRAINT_TYPE = 'FOREIGN KEY')
	SET @referenceTableName = 
		(	
			SELECT OBJECT_NAME(referenced_object_id)
			FROM sys.foreign_keys
			WHERE name = @constraintName
		);
	RETURN @referenceTableName
END
GO


-- "Function" for creating a completely random number >= 0 and <1
-- The problem is that you cannot call a non-deterministic function from inside a user-defined function.
-- I got around this limitation by creating a view, call that function inside the view and use that view inside your function, something like this......
CREATE VIEW getRandomValue AS
SELECT RAND() AS Value
go

-- Function for returning a number in interval [left, right]
CREATE FUNCTION randomInteger(@left INT, @right INT)
RETURNS INT AS
BEGIN
	DECLARE @randomValue INT;
	SET @randomValue = @left + FLOOR((SELECT Value FROM getRandomValue) * (@right + 1 - @left));
	RETURN @randomValue;
END
GO

-- Function to generate random String
CREATE FUNCTION randomString(@newid uniqueidentifier)
RETURNS VARCHAR(max) AS
BEGIN
	DECLARE @randomString varchar(max);
	SELECT @randomString = left(@newid, dbo.randomInteger(5, 35))
	RETURN @randomString;
END
GO
DROP FUNCTION randomString
GO

--------------------- INSERT INTO TABLES ---------------------
CREATE OR ALTER PROCEDURE InsertIntoTable(@tableName varchar(50), @numberOfInsertions int) 
AS
BEGIN
	--- validations ---
	IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @tableName))
	BEGIN
			RAISERROR('The table does not exist in the database', 10, 1) --text, severity, state
			RETURN
	END
	IF (@numberOfInsertions <= 0)
	BEGIN
			RAISERROR('The number of insertions is a negative number or zero', 10, 1)
			RETURN
	END

	-- insert @numberOfInsertions rows into the table
	DECLARE @contor INT = 0
	WHILE(@contor < @numberOfInsertions)
	BEGIN
		-- start with every column
		DECLARE columnCursor CURSOR FOR 
		SELECT COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS  where table_name = @tableName

		DECLARE @columnName varchar(max);
		DECLARE @isPrimaryKey varchar(max); 
		DECLARE @isForeignKey varchar(max); 
		DECLARE @columnDataType varchar(max); 
		DECLARE @columnReferenceTable varchar(max); 
		DECLARE @columnList varchar(max) = ''; -- for insert command, is the list of columns from the table
		DECLARE @valueList varchar(max) = ''; -- for insert command, is the list of values for each column
		DECLARE @randomId INT; -- get random ID from the reference table
		declare @sql nvarchar(max); -- execute a string

		OPEN columnCursor; 
		-- Perform the first fetch.  
		FETCH FROM columnCursor into @columnName;
	
		-- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
				-- This is executed as long as the previous fetch succeeds.  
				SET @columnDataType = dbo.ColumnDataType(@tableName, @columnName)
				SET @isPrimaryKey = dbo.isPrimaryKey(@tableName, @columnName)
				SET @isForeignKey = dbo.isForeignKey(@tableName, @columnName)
				if @isForeignKey = 'YES'
					BEGIN
					SET @columnReferenceTable = dbo.ColumnReferenceTable(@tableName, @columnName)
					END

				----- Start generating values
				-- if the data type is int and it's a primary key => identity so i don;t care
				-- if the data type is int and it's a normal column => generate random values
				-- if the data type is varchar => generate random strings
				-- if the column is foreign key => choose randomly from the foreign table. if the foreign table is empty->throw error.
				if NOT (@columnDataType = 'int' AND @isPrimaryKey = 'YES' AND @isForeignKey = 'NO')
					set @columnList = @columnList + @columnName + ', ';
				if @columnDataType = 'int' AND @isPrimaryKey = 'NO' AND @isForeignKey = 'NO'
					BEGIN
					SET @valueList = @valueList + convert(varchar(max), dbo.randomInteger(1, 100000)) + ', ';
					END

				if @columnDataType = 'varchar' AND @isForeignKey = 'NO'
					BEGIN
					SET @valueList = @valueList + '''' + dbo.randomString(NEWID()) + ''', '; -- so we can have '<string>'
					END
				if @isForeignKey = 'YES'
					BEGIN
					set @sql = 'SET @randomId = (SELECT TOP 1 Id FROM ' + @columnReferenceTable + ' ORDER BY NEWID())'
					exec sp_executesql @sql, N'@randomId INT OUTPUT', @randomId = @randomId OUTPUT
					SET @valueList = @valueList + convert(varchar(max), @randomId) + ', ';
					END
				FETCH FROM columnCursor into @columnName;
		END  

		set @columnList = (SELECT LEFT(@columnList,DATALENGTH(@columnList)-2)) -- get rid of ", "
		set @valueList = (SELECT LEFT(@valueList,DATALENGTH(@valueList)-2))
		
		-- insert the values into the table
		EXEC('INSERT ' + @tableName + '(' + @columnList + ') VALUES (' + @valueList + ')')

		-- go to default values for the next insertion
		Set @columnList = '';
		Set @valueList = '';
		CLOSE columnCursor
		DEALLOCATE columnCursor
		SET @contor = @contor + 1
	END
END



DELETE FROM Planets
Select * from Planets
exec InsertIntoTable @tableName = 'Cities', @numberOfInsertions = 3
SELECT * FROM Cities
SELECT * FROM Planets
exec InsertIntoTable @tableName = 'Creatures', @numberOfInsertions = 3
exec InsertIntoTable @tableName = 'Planets', @numberOfInsertions = 4
exec InsertIntoTable @tableName = 'test123', @numberOfInsertions = 10
exec InsertIntoTable @tableName = 'Cities', @numberOfInsertions = 0
exec InsertIntoTable @tableName = 'csdvsddv', @numberOfInsertions = 10

