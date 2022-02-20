-- -- arithmetic expressions in the SELECT clause in at least 1 queries;
-- 4 queries with the GROUP BY clause, 
-- 3 of which also contain the HAVING clause; 
-- 2 of the latter will also have a subquery in the HAVING clause; 
-- use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;


-- Select the animals that were treated at least twice in the clinic
SELECT A.AnimalID, A.AnimalName
FROM Animals A
GROUP BY A.AnimalID, A.AnimalName
HAVING 2 <= (SELECT COUNT(*)
             FROM ShelterClinic S
             WHERE S.AnimalID = A.AnimalID)

SELECT * FROM ShelterClinic


-- Select the people who donated more supplies in total than the maximum single donation (1supply = 1dollar, 1food etc)
-- and add 1000 more supplies that are needed by the end of the month to see what the database would look like next month
SELECT D.PersonID, SUM(D.DonationAmount)
FROM Donations D
GROUP BY D.PersonID
HAVING SUM(D.DonationAmount) > (SELECT MAX(DonationAmount)
								FROM Donations)


-- Select the people who donated less supplies in total than the average donations (1supply = 1dollar, 1food etc)
--  and add 1000 more supplies that are needed by the end of the month to see what the database would look like next month
SELECT D.PersonID, SUM(D.DonationAmount) + 1000
FROM Donations D
GROUP BY D.PersonID
HAVING SUM(D.DonationAmount) < (SELECT AVG(DonationAmount)
								FROM Donations)



-- Select the animals that were adopted between certain dates (an animal can have multiple entries in the adoption table, all those entries
-- need to be between the date)
SELECT A.AnimalID
FROM Adoptions A
GROUP BY A.AnimalID
HAVING (MAX(A.DateOfAdoption) < '2020-01-01' and MIN(A.DateOfAdoption) > '2017-01-01')
