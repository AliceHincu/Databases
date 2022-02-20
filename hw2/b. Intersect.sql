USE HowlOfADog

-- Show Animals that are stray dogs, stray/pedigree cats, but not foxes, that were at the clinic and their condition.
-- conditions with AND, NOT, and parentheses in the WHERE clause in this query;
SELECT A.AnimalID, A.AnimalName, A.AnimalBreed, A.Condition 
FROM Animals A
WHERE A.AnimalID IN(
	SELECT A.AnimalID
	FROM Animals A
	WHERE A.AnimalBreed NOT IN ('labrador', 'Shiba Inu', 'irish terrier')
	  AND A.AnimalBreed NOT LIKE('%fox')
	INTERSECT
	SELECT S.AnimalID
	FROM ShelterClinic S
	)

-- INCA UN QUERY CU AND

 Select AnimalID from Animals where AnimalBreed = 'stray' and AnimalID  in (select AnimalID from Animals where Animals.Condition = 'healthy')
-- Show the name and cnp of people that are volunteers but also donated
SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN (
	SELECT V.VolunteerID
	FROM Volunteers V
	INTERSECT
	SELECT D.PersonID
	FROM Donations D
	)

SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN (
	SELECT V.VolunteerID
	FROM Volunteers V
	WHERE VolunteerID IN(
		SELECT D.PersonID
		FROM Donations D
		)
		)


SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN ( SELECT V.VolunteerID FROM Volunteers V )
 AND P.PersonID IN (SELECT D.PersonID FROM Donations D)