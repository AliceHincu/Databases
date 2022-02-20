use HowlOfADog

-- show animals that were at the clinic and are now adopted
-- query that joins at least two many-to-many relationships
-- has INNER JOIN
-- has DISTINCT
-- ANIMALS, ADOPTIONS, PEOPLE  (n:m)
-- ANIMALS, SHELTER CLINIC, EMPLOYEES, (n:m) 
SELECT DISTINCT(A.AnimalID), A.AnimalName, A.Condition
FROM Animals A
	INNER JOIN ShelterClinic S ON S.AnimalID = A.AnimalID
	INNER JOIN Adoptions Ad ON Ad.AnimalID = A.AnimalID

-- to have something in the table:
INSERT INTO Adoptions(AnimalID, PersonID, DateOfAdoption)
VALUES	(9, '7730612269831', '2018-09-10')
DELETE FROM Adoptions WHERE AnimalID = 9



-- make a ranking with top 3 volunteers and their contribuitons (including donations), 
-- LEFT JOIN
-- ORDER BY
-- TOP

SELECT TOP 3 V.VolunteerID, P.FirstName, P.LastName, count (*) as Contributions
FROM Volunteers V
	LEFT OUTER JOIN Donations D on D.PersonID = V.VolunteerID
	LEFT OUTER JOIN People P on P.PersonID = V.VolunteerID
GROUP BY VolunteerID, P.FirstName, P.LastName
ORDER BY Contributions DESC


-- Employees that treat animals at the shelter clinic
-- uses RIGHT JOIN
-- uses DISTINCT
SELECT DISTINCT(E.EmployeeID), E.Job, E.Salary
FROM Employees E
	RIGHT JOIN ShelterClinic S ON E.EmployeeID = S.DoctorID

SELECT DISTINCT(P.PersonID), P.FirstName, P.LastName, E.Job, E.Salary
FROM People P
	RIGHT JOIN ShelterClinic S ON P.PersonID = S.DoctorID
	LEFT JOIN Employees E on E.EmployeeID = P.PersonID




-- Number of people who help the shelter by volunteering, jobs, fostering
-- this query joins at least 3 tables
-- this query uses DISTINCT
-- this query uses full join

SELECT COUNT(DISTINCT (P.PersonID)) FROM People P
	FULL JOIN Volunteers V on V.VolunteerID = P.PersonID
	FULL JOIN Employees E on E.EmployeeID = P.PersonID
	FULL JOIN Fosters F on F.FosterID = P.PersonID

/*
SELECT P.PersonID, P.FirstName, P.LastName FROM People P
FULL JOIN Volunteers V on V.VolunteerID = P.PersonID
FULL JOIN Employees E on E.EmployeeID = P.PersonID
FULL JOIN Fosters F on F.FosterID = P.PersonID
*/