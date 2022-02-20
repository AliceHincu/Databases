use HowlOfADog
GO

DELETE
FROM Cages
WHERE AnimalID BETWEEN 29 AND 31  

DELETE
FROM Cages
WHERE AnimalID >= 8 AND AnimalID <= 14

SELECT *
FROM Cages


DELETE
FROM Volunteers
WHERE Description LIKE '%social media%'

SELECT *
FROM Volunteers