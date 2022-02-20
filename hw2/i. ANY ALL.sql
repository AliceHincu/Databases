-- 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator); 
-- rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.


-- Show people that are at most 30 years old
SELECT P.FirstName, P.LastName, P.DateOfBirth FROM People P
WHERE P.PersonID = ANY(
    SELECT Pe.PersonID FROM People Pe
    WHERE DATEDIFF(year, Pe.DateOfBirth, GETDATE()) <= 30
    )

SELECT P.FirstName, P.LastName, P.DateOfBirth FROM People P
WHERE P.PersonID IN(
    SELECT Pe.PersonID FROM People Pe
    WHERE DATEDIFF(year, Pe.DateOfBirth, GETDATE()) <= 30
    )


-- Show animals that have weight greater than all small animals
SELECT A.AnimalID, A.AnimalName, A.WeightKg from Animals A
WHERE A.WeightKg > ALL(
    SELECT An.WeightKg FROM Animals An
	WHERE An.Size = 'small'
    )

SELECT A.AnimalID, A.AnimalName, A.WeightKg from Animals A
WHERE A.WeightKg > (
    SELECT MAX(An.WeightKg) FROM Animals An
    WHERE An.Size = 'small'
    )

-- SELECT people that are from USA or Italy
SELECT P.PersonID, P.LastName, P.Country, P.City
FROM People P
WHERE P.PersonID = ANY (
    SELECT Pe.PersonID
    FROM People PE
        WHERE PE.Country = 'USA'
           OR PE.Country = 'Italy')

SELECT P.PersonID, P.LastName, P.Country, P.City
FROM People P
WHERE P.Country IN('USA', 'Italy')



-- Show the older animal
SELECT A.AnimalID, A.AnimalName, A.AnimalBreed, A.DateOfBirth from Animals A
WHERE DATEDIFF(year, A.DateOfBirth, GETDATE()) >= ALL(
    SELECT DATEDIFF(year, An.DateOfBirth, GETDATE()) FROM Animals An
    )

SELECT A.AnimalID, A.AnimalName, A.AnimalBreed, A.DateOfBirth from Animals A
WHERE DATEDIFF(year, A.DateOfBirth, GETDATE()) >= (
    SELECT MAX(DATEDIFF(year, An.DateOfBirth, GETDATE())) FROM Animals An
   
    )
