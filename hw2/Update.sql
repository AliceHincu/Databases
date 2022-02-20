--- use at least once: IN.
use HowlOfADog
GO

-- update the treatment cost where the description is vomiting and the doctor id is that
UPDATE ShelterClinic
SET TreatmentCost = 50
WHERE CONVERT(VARCHAR, TreatmentDescription) = 'vomiting' AND DoctorID = '7561110036197'

SELECT *
FROM ShelterClinic


-- make the animal be adopted if animal id is 13 and it doesn't have an adopter
UPDATE Fosters
SET AdopterID = '7950327195255',
	DateOfAdoption = '2021-08-19'
WHERE AnimalID = 13 AND AdopterID IS NULL

SELECT *
FROM Fosters


-- UPDATE THE TEXT TO THAT if a volunteer is a donator
UPDATE Volunteers
SET Description = CONVERT(text, 'donations and playing with animals')
WHERE VolunteerID IN (SELECT D.PersonID
					  FROM Donations D)

SELECT *
FROM Volunteers