USE HowlOfADog

-- small: 1-3
-- medium: 4-6
-- big: 7-10  
INSERT INTO Animals(AnimalName, DateOfBirth, AnimalType, AnimalBreed, Size, WeightKg, Condition, DateOfArrival)
VALUES ('Finnegan Fox', '2017-05-17', 'fox', 'corsac fox', 'small', 3, 'healthy', '2020-04-18'),
	   ('Pufi', '2015-06-19', 'dog', 'stray', 'medium', 6, 'sick', '2015-06-19'),  -- sick
	   ('Lili', '2011-06-02', 'cat', 'stray', 'small', 1, 'sick', '2013-03-29'),   --sick
	   ('Phinneas', '2020-09-22', 'dog', 'labrador', 'big', 10, 'healthy', '2021-03-07'),
	   ('Hardy', '2014-08-12', 'dog', 'Shiba Inu' ,'small', 3, 'healhy', '2021-01-01'),
	   ('Bojangles', '2019-08-10', 'dog', 'stray' ,'big', 7, 'healhy', '2019-08-10'),
	   ('Grady', '2020-05-06' , 'cat', 'stray', 'small', 2, 'sick', '2020-05-06'),  --sick
	   ('Nino', '2020-05-06' , 'cat', 'stray', 'small', 1, 'sick', '2020-05-06'),  --sick
	   ('Riddle', '2018-04-23' , 'fox', 'swift fox', 'small', 3, 'healthy', '2019-08-13'),
	   ('Dazzle', '2017-05-20', 'fox', 'swift fox', 'small', 2, 'sick' , '2017-06-30'),  --sick
	   ('Maggie', '2015-11-19', 'dog', 'irish terrier', 'big', 8, 'healthy', '2016-03-22'),
	   ('Sigma', '2021-02-20', 'dog', 'stray', 'medium', 5, 'healthy', '2021-03-05'),
	   ('Peanut', '2014-05-20', 'dog', 'stray', 'medium', 4, 'sick', '2015-06-18'),  --sick
	   ('Penny', '2020-09-22', 'cat', 'stray', 'small', 1, 'healthy', '2021-09-22'),
	   ('Tux', '2016-03-18', 'cat', 'stray', 'small', 1, 'healthy', '2019-11-03'),
	   ('Congo', '2016-01-09', 'fox', 'tibetan sand fox', 'medium', 4, 'healthy', '2016-12-19'),
	   ('Aspen', '2019-12-23', 'fox', 'tibetan sand fox', 'medium', 4, 'sick', '2020-02-11'),  --sick
	   ('Cookie', '2020-05-23', 'cat', 'bengal cat', 'small', 3, 'healthy', '2021-04-03'),
	   ('Frankenstein', '2010-10-10', 'cat', 'stray', 'medium', 4, 'healthy', '2011-10-09'),
	   ('Kona', '2014-06-15', 'fox', 'corsac fox', 'medium', 5, 'healthy', '2015-07-16'),
	   ('Clover', '2015-07-16', 'cat', 'stray', 'medium', 4, 'healthy', '2016-08-13'),
	   ('Lola', '2018-12-04', 'dog', 'stray', 'medium', 9, 'healthy', '2018-12-04'),
	   ('Lala', '2018-12-04', 'dog', 'stray', 'medium', 9, 'sick', '2018-12-04'),  --sick
	   ('Lulu', '2018-12-04', 'dog', 'stray', 'medium', 9, 'healthy', '2018-12-04')
		
DELETE FROM Animals
SELECT *
FROM Animals

-- genereaza cnp : https://isj.educv.ro/cnp/
-- genereaza persoane: https://www.fakenamegenerator.com/gen-random-us-us.php
-- 30    15 USA, 4 Italia, 2familii in Paris, 1familie+2oameni random in Berlin, 3Finland,  cnp la sf
-- schelet: minim 20-30 de persoane: ai fosteri, pt blacklist, voluntari, pt adoptions, pt donatii, employees.

INSERT INTO People(PersonID, FirstName, LastName, Country, City, StreetAdress, PhoneNumber, Email, DateOfBirth)
VALUES ('8620127017386', 'Maria', 'Banner', 'USA', 'New York', '13th Street', '320-234-4262', 'MariaCBanner@armyspy.com', '1962-01-27'),  --Employee
	   ('7561110036197', 'Robert', 'Peck', 'USA' , 'Orlando', '3058 Stoneybrook Road', '595-28-9999', 'RobertJPeck@armyspy.com', '1956-11-10'),  --Employee
	   ('8800508409959', 'Yessenia', 'Jackson', 'USA' , 'Oklahoma City', '4589 Ottis Street', '443-50-5839', 'YesseniaEJackson@rhyta.com', '1980-05-08'),  --Employee
	   ('7490306405939', 'Grant', 'Rivera', 'USA', 'Portland', '3271 Hope Street', '540-19-3642', 'GrantDRivera@dayrep.com', '1949-03-06'),  --Employee
	   ('8541110406594', 'Aline', 'Witt', 'USA', 'Milwaukee', '2187 Highland Drive', '920-657-8832', 'AlineJWitt@jourrapide.com', '1954-11-10'),  --Employee
	   ('8140418407293', 'Juliette', 'Alvarado', 'USA', 'Hood River', '364 Sycamore Road', '541-386-6065', 'JulietteKAlvarado@dayrep.com', '1914-04-18'),  --Employee
	   ('7750417427003', 'Christopher', 'Hunter', 'USA', 'Gainesville', '4977 Rhapsody Street', '352-313-3101', 'ChristopherNHunter@dayrep.com', '1975-04-17'),  --Employee
	   ('7740205429983', 'Kenny', 'Gonzalez', 'USA', 'Philadelphia', '4747 Glen Falls Road', '215-866-5226', 'KennyKGonzalez@dayrep.com', '1974-02-05'),  --Employee
	   ('8580919525220', 'Roberta', 'Prather', 'USA', 'Los Angeles', '3312 Brannon Street', '213-307-3887', 'RobertaCPrather@armyspy.com', '1958-09-19'),  --Employee
	   ('7800711525856', 'John', 'Potts', 'USA', 'Everett', '3702 Ryder Avenue', '425-327-2983', 'JohnBPotts@jourrapide.com', '1980-07-11'),  -- Employee
	   ('7671112526328', 'George', 'Porterfield', 'USA', 'Heflin', '2577 Beeghley Street', '256-201-6124', 'GeorgeAPorterfield@dayrep.com', '1967-11-12'),  -- Volunteer
	   ('7400226128293', 'Hollis', 'Hopkins', 'USA', 'Worthington', '3444 Palmer Road', '614-673-0378', 'HollisNHopkins@jourrapide.com', '1945-06-19'),  -- Volunteer
	   ('7830410129514', 'Christopher', 'Sullivan', 'USA', 'Bay City', '2686 Ripple Street', '989-709-5536', 'ChristopherMSullivan@jourrapide.com', '1983-04-10'),  -- Volunteer
	   ('7400226129578', 'Joseph', 'Piazza', 'USA', 'Eagleville', '387 Quincy Street', '267-393-7460', 'JosephLPiazza@rhyta.com', '1940-02-26'),  -- Volunteer
	   ('7550102109794', 'Owen', 'Nathaniel', 'USA', 'Gainesville', '3103 Bagwell Avenue', '352-658-1748', 'OwenBNathaniel@armyspy.com', '1955-01-02'),  -- Volunteer
	   ('8571101105005', 'Adalgisa', 'Siciliano', 'Italy', 'Napoli', '71030-Casalvecchio Di Puglia FG', '0390 2857446', 'AdalgisaSiciliano@jourrapide.com', '1957-11-01'),
	   ('7770217106555', 'Leonardo', 'Zito', 'Italy', 'Napoli', '34078-Sagrado GO', '0354 1540363', 'LeonardoZito@jourrapide.com', '1977-02-17'),  -- foster adopter
	   ('7710619107072', 'Gaspare', 'Piazza', 'Italy', 'Napoli', '89025-Bosco RC', '0349 1779751', 'GasparePiazza@rhyta.com', '1971-06-19'),  -- donations, Volunteer
	   ('8880821107634', 'Claudia', 'Fanucci', 'Italy', 'Napoli', '32036-Sedico BL', '0353 2191997', 'ClaudiaFanucci@jourrapide.com', '1988-08-21'),  -- donations
	   ('7730612269831', 'Verrill', 'Lamontagne', 'France', 'Paris', '15, rue Jean Vilar', '05.47.86.21.07', 'VerrillLamontagne@dayrep.com', '1973-06-12'),  --adopter, foster adopter
	   ('8730425107617', 'Brigitte', 'Lamontagne', 'France', 'Paris', '15, rue Jean Vilar', '01.40.67.37.88', 'BrigitteLamontagne@dayrep.com', '1973-04-25'), --adopter
	   ('8000515105719', 'Olympia', 'Racicot', 'France', 'Paris', '27, Place Charles de Gaulle', '03.51.19.26.35', 'OlympiaRacicot@dayrep.com', '2000-05-15'),
	   ('7990912198661', 'Sennet', 'Racicot', 'France', 'Paris', '27, Place Charles de Gaulle', '01.39.98.67.71', 'SennetRacicot@armyspy.com', '1999-09-12'),
	   ('8940308266909', 'Birgit', 'Adler', 'Germany', 'Berlin', 'Sömmeringstr. 90', '07271 11 20 47', 'BirgitAdler@rhyta.com', '1994-03-08'),  -- adopter
	   ('7800118197518', 'Erik', 'Adler', 'Germany', 'Berlin', 'Sömmeringstr. 90', '07271 57 70 82', 'ErikFuerst@rhyta.com', '1980-01-18'),  -- adopter
	   ('7500811196572', 'Jens', 'Lowe', 'Germany', 'Berlin', 'Spresstrasse 1', '0461 21 61 68', 'JensLowe@rhyta.com', '1950-08-11'), -- foster adopetr
	   ('8851213267194', 'Martina', 'Eiffel', 'Germany', 'Berlin', 'Kastanienallee 62', '04885 55 75 32', 'MartinaEiffel@jourrapide.com', '1985-12-13'),  -- donations
	   ('7950327195255', 'Sakari', 'Käyhkö', 'Finland', 'Helsinki', 'Hakulintie 77', '050 363 8631', 'SakariKayhko@armyspy.com', '1995-03-27'),  -- foster
	   ('8020110265942', 'Pia', 'Monto', 'Finland', 'Helsinki', 'Puruntie 96', '046 083 4788', 'PiaMonto@teleworm.us', '2002-01-10'),  -- foster
	   ('7040715198929', 'Emppu', 'Haapoja', 'Finland', 'Helsinki', 'Rengaskuja 62', '050 295 3389', 'EmppuHaapoja@teleworm.us', '2004-07-15')  -- blacklist
	   

DELETE FROM People
SELECT *
FROM People



INSERT INTO Donations(PersonID, DonationType, DonationAmount, DonationDate)
VALUES  ('8851213267194', 'toys', 5, '2020-05-07'),
		('7710619107072', 'money', 5000, '2021-05-06'),
		('7710619107072', 'food', 20, '2021-05-06'),
		('7710619107072', 'toys', 30, '2021-05-06'),
		('8880821107634', 'money', 3000, '2020-05-06'),
		('7710619107072', 'money', 10000, '2021-05-07')

DELETE FROM Donations
SELECT *
FROM Donations



INSERT INTO Blacklist(PersonID, Reason, BlacklistDate)
VALUES ('7040715198929', 'returned dog after Christmas', '2020-12-28')

DELETE FROM Blacklist
SELECT *
FROM Blacklist



INSERT INTO Volunteers(VolunteerID, Description)
VALUES ('7671112526328', 'emotional support for animals in need'),
	   ('7400226128293', 'helps with cleaning'),
	   ('7830410129514', 'promotes on social media the shelter'),
	   ('7400226129578', 'plays with animals'),
	   ('7550102109794', 'takes animals on walks'),
	   ('7710619107072', 'playing with animals')

DELETE FROM Volunteers
SELECT *
FROM Volunteers


INSERT INTO Employees(EmployeeID, Job, Salary)
VALUES ('8620127017386', 'vet', 102333),
	   ('7561110036197', 'vet', 102333),
	   ('8800508409959', 'animal caretaker', 29142),
	   ('7490306405939', 'animal caretaker', 30000),
	   ('8541110406594', 'animal caretaker', 35000),
	   ('8140418407293', 'manager of volunteer services', 34240),
	   ('7750417427003', 'veterinary receptionist', 40544),
	   ('7740205429983', 'adoption manager', 84849),
	   ('8580919525220', 'shelter manager', 67806),
	   ('7800711525856', 'animal trainer', 41378)

DELETE FROM Employees
SELECT *
FROM Employees


-- (vaccinations / prescriptions / procedures / other)
INSERT INTO ShelterClinic(AnimalID, DoctorID, TreatmentType, TreatmentDate, TreatmentCost, TreatmentDescription)
VALUES  (8, '8620127017386', 'procedure', '2020-04-18', 2000, 'no complications'),  -- same date as arrival
		(9, '8620127017386' , 'procedure', '2018-05-06', 1000, 'removed first tumour'),
		(9, '8620127017386' , 'procedure', '2019-05-06', 1000, 'removed second tumour'),
		(11, '7561110036197', 'vaccination', '2021-04-07', 25, 'no complications'),
		(10, '7561110036197', 'pills', '2014-03-30', 20, 'vomiting'),
		(10, '7561110036197', 'pills', '2016-03-30', 20, 'no complications'),
		(10, '8620127017386', 'pills', '2014-03-30', 20, 'vomiting')

--- doesn't work
INSERT INTO ShelterClinic(AnimalID, DoctorID, TreatmentType, TreatmentDate, TreatmentCost, TreatmentDescription)
VALUES  (8, '1111111111111', 'procedure', '2020-04-18', 2000, 'no complications')

DELETE FROM ShelterClinic
SELECT *
FROM ShelterClinic


-- i will delete the cage entries of the adopted animals at the delete query
INSERT INTO Cages(CageID, AnimalID)
VALUES (11, 8),
	   (11, 27),
	   (12, 16),
	   (12, 17),
	   (13, 23),
	   (13, 24),
	   (21, 9),
	   (22, 11),
	   (23, 12),
	   (24, 13),
	   (24, 18),
	   (25, 19),
	   (26, 20),
	   (27, 29),
	   (27, 30),
	   (27, 31),
	   (31, 10),
	   (32, 14),
	   (32, 15),
	   (33, 21),
	   (34, 22),
	   (35, 25),
	   (35, 26),
	   (36, 28)

DELETE FROM Cages
SELECT *
FROM Cages

INSERT INTO Adoptions(AnimalID, PersonID, DateOfAdoption)
VALUES	(28, '7730612269831', '2018-09-10'),
		(28, '8730425107617', '2018-09-10'),
		(29, '8940308266909', '2020-08-08'),
		(30, '8940308266909', '2020-08-08'),
		(31, '8940308266909', '2020-08-08'),
		(29, '7800118197518', '2020-08-08'),
		(30, '7800118197518', '2020-08-08'),
		(31, '7800118197518', '2020-08-08')

DELETE FROM Adoptions
SELECT *
FROM Adoptions


INSERT INTO Fosters(FosterID, AnimalID, AdopterID, DateOfArrival, DateOfAdoption)
VALUES ('7950327195255', 8, '7770217106555', '2020-07-13', '2021-01-01'),
	   ('8020110265942', 9, '7500811196572', '2019-12-04', '2020-11-04'),
	   ('7950327195255', 11,'8851213267194', '2021-03-07', '2021-04-08'),  -- same arrival date as entering shelter
	   ('7950327195255', 12, '7730612269831', '2021-03-07', '2021-04-09'),
	   ('8020110265942', 10, NULL, '2016-04-12', NULL),
	   ('8020110265942', 14, NULL, '2016-04-12', NULL),
	   ('7950327195255', 13, NULL, '2021-03-07', NULL)   -- failed foster => adopted


DELETE FROM Fosters
SELECT *
FROM Fosters



