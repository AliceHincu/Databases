--2 queries with the EXISTS operator and a subquery in the WHERE clause;
USE HowlOfADog
GO

-- Show animals that are healthy and directly adopted from shelter
SELECT AnimalID, A.AnimalName
FROM Animals A
WHERE EXISTS(SELECT A.AnimalID FROM Adoptions Ad WHERE (Ad.AnimalID = A.AnimalID AND A.Condition='healthy'))

-- Show animals that were at the clinic but are still sick
SELECT A.AnimalID, A.AnimalName
FROM Animals A
WHERE EXISTS(SELECT * FROM ShelterClinic S WHERE S.AnimalID = A.AnimalID)