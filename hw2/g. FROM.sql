--2 queries with a subquery in the FROM clause;

-- Select top 25% employees by salary except vets
SELECT TOP 25 PERCENT *
FROM (
         SELECT *
         FROM Employees E
         WHERE E.Job != 'vet'

     ) as E
ORDER BY E.Salary DESC


-- We define tenacity of a planet by computing age + size + orbitalTime / 3
-- Show people under 50 in ascending order after 10 years
-- arithmetic expressions in the SELECT clause in this query;
SELECT P.FirstName, P.LastName, P.Age+10 as AgeAfter10
FROM (
         SELECT P.FirstName, P.LastName, DATEDIFF(year, P.DateOfBirth, GETDATE()) AS Age FROM People P
     ) as P
WHERE P.Age<50 
ORDER BY P.Age ASC