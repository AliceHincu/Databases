USE SpaceTravelGuide
GO

----------------- ADDING AND LINKING --------------------
-- Tests – holds data about different test configurations; TestID INT, Name nvarchar(50);
CREATE OR ALTER PROCEDURE AddTest @name VARCHAR(50)
AS
BEGIN
    IF EXISTS(SELECT * FROM Tests T WHERE Name = @name)
        BEGIN
            PRINT 'Test already exists'
            RETURN
        END
    INSERT INTO Tests(Name) VALUES (@name)
END
GO

-- Tables – holds data about tables that might take part in a test; TableID INT, Name nvarchar(50);
CREATE OR ALTER PROCEDURE AddTable @tableName VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = @tableName)
		BEGIN
			PRINT 'Table' + @tableName + ' does not exist'
            RETURN
        END
    IF EXISTS(SELECT * FROM Tables T WHERE T.Name = @tableName)
        BEGIN
            PRINT 'Table ' + @tableName + ' already added to test'
            RETURN
        END
    INSERT INTO Tables(Name) VALUES (@tableName)
END
GO

-- Views – holds data about a set of views from the database, used to assess the performance of certain SQL queries; ViewID INT, Name nvarchar(50);
CREATE OR ALTER PROCEDURE AddView @viewName VARCHAR(50) 
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = @viewName)
    BEGIN
        PRINT 'View ' + @viewName + ' does not exist'
        RETURN
    end
    IF EXISTS(SELECT * FROM Views WHERE Name = @viewName)
    BEGIN
        PRINT 'View ' + @viewName + ' already added'
        RETURN
    end
    INSERT INTO Views(Name) VALUES (@viewName)
end
GO

-- TestTables - link table between Tests and Tables (which tables take part in which tests); TestID int, TableID int, NoOfRows int, Position int 
CREATE OR ALTER PROCEDURE LinkTablesAndTests @tableName VARCHAR(50), @testName VARCHAR(50), @noRows INT, @position INT
AS
    BEGIN
        IF @position < 0
        BEGIN
            PRINT 'Position must be >0'
            RETURN
        END
        IF @noRows < 0
        BEGIN
            PRINT 'Number of rows must be >0'
            RETURN
        END

        DECLARE @testID INT, @tableID INT
        SET @testID = (SELECT T.TestID FROM Tests T WHERE T.Name = @testName)
        SET @tableID = (SELECT T.TableID FROM Tables T WHERE T.Name = @tableName)
        INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (@testID, @tableID, @noRows, @position)
    END
GO

-- TestViews – link table between Tests and Views (which views take part in which tests); TestID int, ViewID int
CREATE OR ALTER PROCEDURE LinkViewsAndTests @viewName VARCHAR(50), @testName VARCHAR(50)
AS
    BEGIN
        DECLARE @testID INT, @viewID INT
        SET @testID = (SELECT TestID FROM Tests WHERE Name = @testName)
        SET @viewID = (SELECT ViewID FROM Views WHERE Name = @viewName)
        INSERT INTO TestViews(testid, viewid) VALUES (@testID, @viewID)
    end
GO








------------------ RUN TEST PROCEDURE -----------------------
-- ***TestRuns*** – contains data about different test runs; each test run involves:
-- - *deleting* the data from the test’s tables – in the order specified by the *Position* field (table *TestTables*);
-- - *inserting* data into the test’s tables – reverse deletion order; the number of records to insert is stored in the *NoOfRows* field (table *TestTables*);
-- - *evaluating* the test’s views;

-- ***TestRunTables*** – contains performance data for INSERT operations for every table in the test;
-- ***TestRunViews*** – contains performance data for every view in the test.
CREATE OR ALTER PROCEDURE RunTest @name VARCHAR(50) AS
BEGIN
    DECLARE @testId INT, @testRunID INT
    SET @testId = (SELECT T.TestID FROM Tests T WHERE T.Name = @name) -- my test ID
	
	INSERT INTO TestRuns(Description) VALUES (@name) -- to have an id
    SET @testRunID = CONVERT(INT, (SELECT last_value FROM sys.identity_columns WHERE name = 'TestRunID'))
	-- columns: TestRunID int, Dscription nvarchar(2000), StartAt(datetime), ndAt(datetime)

	-- SCROLL: Specifies that all fetch options (FIRST, LAST, PRIOR, NEXT, RELATIVE, ABSOLUTE) are available.
	-- get the tables for this test
	DECLARE TablesCursor CURSOR SCROLL FOR
		SELECT T.TableID, T.Name, TT.NoOfRows 
		FROM TestTables TT 
		INNER JOIN Tables T on T.TableID = TT.TableID
		WHERE TT.TestID = @testId
		ORDER BY TT.Position

	-- get the views for this test
	DECLARE ViewsCursor CURSOR FOR
		SELECT V.ViewID, V.Name 
		FROM Views V 
		INNER JOIN TestViews TV on V.ViewID = TV.ViewID
		WHERE TV.TestID = 3

	DECLARE @allTestsStartTime DATETIME2, @allTestsEndTime DATETIME2,
            @currentTestStartTime DATETIME2, @currentTestEndTime DATETIME2
	
	SET @allTestsStartTime = SYSDATETIME();

	-------- start with tables
	DECLARE @tableName VARCHAR(50), @noRows INT, @tableID INT

	-- delete from tables
	DECLARE @deleteCommand nvarchar(200)

	OPEN TablesCursor
	FETCH FIRST FROM TablesCursor INTO @tableID, @tableName, @noRows

    WHILE @@FETCH_STATUS = 0
		begin
        SET @deleteCommand = 'delete from '+ @tableName   
        EXEC (@deleteCommand) -- de ce nu merge fara paranteze?
        FETCH NEXT FROM TablesCursor INTO @tableID, @tableName, @noRows
		end
    CLOSE TablesCursor

    -- DEALLOCATE TablesCursor
	-- populate tables
	OPEN TablesCursor
	FETCH LAST FROM TablesCursor INTO @tableID, @tableName, @noRows

	DECLARE @command VARCHAR(MAX)
	WHILE @@FETCH_STATUS = 0
		begin
        SET @currentTestStartTime = SYSDATETIME();
        SET @command = 'InsertIntoTable ' + char(39) + @tableName + char(39) + ', ' + CONVERT(VARCHAR(10), @noRows)
        print @command
		EXEC(@command)
		print @command
        SET @currentTestEndTime = SYSDATETIME();
		print @testRunID
		print @tableID
		print @currentTestStartTime
		print @currentTestEndTime
        INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@testRunID, @tableID, @currentTestStartTime, @currentTestEndTime)
        FETCH PRIOR FROM TablesCursor INTO @tableID, @tableName, @noRows
		end
	CLOSE TablesCursor
	DEALLOCATE TablesCursor

	-------- start with views
	DECLARE @viewName VARCHAR(50), @viewID INT	
	OPEN ViewsCursor
    FETCH FROM ViewsCursor INTO @viewID, @viewName
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @currentTestStartTime = SYSDATETIME()
            DECLARE @statement VARCHAR(256)
            SET @statement = 'SELECT * FROM ' + @viewName
            EXEC (@statement)
            SET @currentTestEndTime = SYSDATETIME()
            INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunID, @viewID, @currentTestStartTime, @currentTestEndTime)
            FETCH NEXT FROM ViewsCursor INTO @viewID, @viewName
        end
	CLOSE ViewsCursor
    DEALLOCATE ViewsCursor

	SET @allTestsEndTime = SYSDATETIME();
    
    UPDATE TestRuns
		SET StartAt = @allTestsStartTime, EndAt = @allTestsEndTime
		WHERE TestRunID = @testRunID
END
	/*
    DECLARE @tableName VARCHAR(50), @noRows INT, @tableID INT,
        @allTestsStartTime DATETIME2, @allTestsEndTime DATETIME2,
        @currentTestStartTime DATETIME2, @currentTestEndTime DATETIME2,
        @testRunID INT, @command VARCHAR(256),
        @viewName VARCHAR(50), @viewID INT


    OPEN ViewsCursor
    FETCH FROM ViewsCursor INTO @viewID, @viewName
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @currentTestStartTime = SYSDATETIME()
            DECLARE @statement VARCHAR(256)
            SET @statement = 'SELECT * FROM ' + @viewName
            PRINT @statement
            EXEC (@statement)
            SET @currentTestEndTime = SYSDATETIME()
            INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunID, @viewID, @currentTestStartTime, @currentTestEndTime)
            FETCH NEXT FROM ViewsCursor INTO @viewID, @viewName
        end
    SET @allTestsEndTime = SYSDATETIME();
    CLOSE ViewsCursor
    DEALLOCATE ViewsCursor
    UPDATE TestRuns
	SET StartAt = @allTestsStartTime, EndAt = @allTestsEndTime
	WHERE TestRunID = @testRunID
	*/
go

----------------- EXEC STUFF ---------------------
SELECT * FROM Cities
SELECT * FROM Creatures
SELECT * FROM Planets
SELECT * FROM Tables
--DELETE TestRunTables
--DELETE TestTables
EXEC AddTable @tableName='Planets'
EXEC AddTable @tableName='Cities'
EXEC AddTable @tableName='Creatures'
EXEC AddView @viewName='ViewCreatureOrigin'
EXEC AddView @viewName='ViewPlanetCity'
EXEC AddView @viewName='ViewPlanets10000'
EXEC AddTest @name='Test1'
EXEC AddTest @name='Test2'
EXEC AddTest @name='Test3'

EXEC LinkTablesAndTests @tableName='Creatures', @testName='Test1', @noRows=2530, @position=1
EXEC LinkTablesAndTests @tableName='Cities', @testName='Test1', @noRows=3000, @position=2
EXEC LinkTablesAndTests @tableName='Planets', @testName='Test1', @noRows=2000, @position=3

EXEC LinkTablesAndTests @tableName='Creatures', @testName='Test2', @noRows=25, @position=1
EXEC LinkTablesAndTests @tableName='Cities', @testName='Test2', @noRows=30, @position=2
EXEC LinkTablesAndTests @tableName='Planets', @testName='Test2', @noRows=20, @position=3


EXEC LinkViewsAndTests @viewName='ViewCreatureOrigin', @testName='Test3'
EXEC LinkViewsAndTests @viewName='ViewPlanetCity', @testName='Test3'
EXEC LinkViewsAndTests @viewName='ViewPlanets10000', @testName='Test3'
EXEC LinkTablesAndTests @tableName='Creatures', @testName='Test3', @noRows=45, @position=1
EXEC LinkTablesAndTests @tableName='Cities', @testName='Test3', @noRows=50, @position=2
EXEC LinkTablesAndTests @tableName='Planets', @testName='Test3', @noRows=10, @position=3

SELECT * FROM Views
SELECT * FROM TestViews

SELECT * FROM TestTables
SELECT * FROM TestRunTables
SELECT * FROM TestRuns
SELECT * FROM TestRunViews


EXEC RunTest 'Test3'








---------------------------------------------------
SELECT * FROM Planets
SELECT * FROM Cities
SELECT * FROM Creatures