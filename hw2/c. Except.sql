USE HowlOfADog

-- Show all people that are registered in the database as female that are not managers, receptionists or doners 
-- (remained ppl who work directly with animals and that are women  -> for animals afraid of men)
-- used DISTINCT in this query
-- used condition with AND and parentheses in the WHERE clause in this query;
SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID LIKE ('8%')
    EXCEPT
SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN (
    SELECT E.EmployeeID
    FROM Employees E
    WHERE E.Job != 'veterinary receptionist'
	  AND E.Job NOT LIKE ('%manager%')
	UNION
	SELECT DISTINCT D.PersonID
	FROM Donations D
)

-- Show the salary all employees that make over 40000 dollars/year except the vets increased by 20% for a possible raise
-- arithmetic expressions in this query;
SELECT E.EmployeeID, E.Job, E.Salary+E.Salary*20/100 as RAISE
FROM Employees E
WHERE E.Salary >= 40000
EXCEPT
SELECT E.EmployeeID, E.Job, E.Salary+E.Salary*20/100 as RAISE
FROM Employees E
WHERE E.Job = 'vet'