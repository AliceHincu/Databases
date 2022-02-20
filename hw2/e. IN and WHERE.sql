--2 queries with the IN operator 
-- and a subquery in the WHERE clause; in at least one case, the subquery should include a subquery in its own WHERE clause;

-- Select the doctors that performed complicated surgeries (meaning cost >=1000)
SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN (
    SELECT E.EmployeeID
    FROM Employees E
    WHERE E.EmployeeID IN (
        SELECT S.DoctorID
        FROM ShelterClinic S
        WHERE S.TreatmentCost >= 1000
    )
)

-- select people who donated money
SELECT P.PersonID, P.FirstName, P.LastName
FROM People P
WHERE P.PersonID IN (
    SELECT D.PersonID
    FROM Donations D
	WHERE D.DonationType = 'money'
)