-- Select the people in charge with animals' morale (both employees and volunteers)

SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN (
	SELECT E.EmployeeID
	FROM Employees E
	WHERE E.Job = 'animal caretaker'
	   OR E.Job = 'animal trainer'
	UNION
	SELECT V.VolunteerID
	FROM Volunteers V
	WHERE V.Description LIKE '%animals%'
)


-- Select the top 3 animals from fosters and adopters that have the smallest weight
-- ORDER BY and TOP in at this query
SELECT TOP 3 *
FROM Animals A
WHERE A.AnimalID IN (
         SELECT A.AnimalID
         FROM Adoptions A
         UNION
         SELECT F.AnimalID
         FROM Fosters F
     )
ORDER BY A.WeightKg



SELECT A.AnimalID, A.WeightKg
FROM Animals A
WHERE A.AnimalID IN (SELECT A.AnimalID FROM Adoptions A) 
   OR A.AnimalID IN (SELECT F.AnimalID FROM Fosters F)
   