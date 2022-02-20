create database HowlOfADog;
use HowlOfADog;

drop table Adoptions;
drop table Donations;
drop table Fosters;
drop table Volunteers;
drop table Blacklist;

drop table ShelterClinic;
drop table Cages;

drop table Employees;

drop table Animals;
drop table People;





CREATE TABLE Animals
(
	AnimalID int NOT NULL IDENTITY(1,1),  -- The MS SQL Server uses the IDENTITY keyword to perform an auto-increment feature.
	AnimalName varchar(255) NOT NULL,
	Age int,
	DateOfBirth date,
	AnimalType varchar(255), -- dog/cat/fox
	AnimalBreed varchar(255),
	Size varchar(255), -- small/medium/big
	WeightKg int,  -- weight in kg
	Condition varchar(255), -- healthy/sick
	DateOfArrival date NOT NULL,
	CONSTRAINT PK_Animal PRIMARY KEY(AnimalID)  -- To allow naming of a PRIMARY KEY constraint, and for defining a PRIMARY KEY constraint on multiple columns
);


CREATE TABLE People
(
	PersonID varchar(13) NOT NULL, -- cnp
	FirstName varchar(255),
	LastName varchar(255),
	Age int,
	Country varchar(255),
	City varchar(255),
	StreetAdress varchar(255),
	PhoneNumber varchar(255),
	Email varchar(255),
	CONSTRAINT PK_Person PRIMARY KEY(PersonID)
);

CREATE TABLE Employees
(
	EmployeeID varchar(13) NOT NULL,
	Job varchar(255),
	Salary int,
	CONSTRAINT PK_Employee PRIMARY KEY(EmployeeID),
	CONSTRAINT FK_Employee FOREIGN KEY(EmployeeID) REFERENCES People(PersonID) 
);

CREATE TABLE ShelterClinic
(
	AnimalID int NOT NULL,
	DoctorID varchar(13) NOT NULL,
	TreatmentType varchar(255) NOT NULL, -- (vaccinations / prescriptions / procedures / other)
	TreatmentDate date,
	TreatmentCost int,
	TreatmentDescription text,
	CONSTRAINT PK_Treatment PRIMARY KEY(AnimalID, DoctorID, TreatmentDate),
	CONSTRAINT FK_AnimalClinic FOREIGN KEY(AnimalID) REFERENCES Animals(AnimalID),
	CONSTRAINT FK_Doctor FOREIGN KEY(DoctorID) REFERENCES Employees(EmployeeID),
);

CREATE TABLE Cages
(
	-- EntryID 
	CageID int NOT NULL,
	AnimalID int NOT NULL,
	CONSTRAINT PK_Cage PRIMARY KEY(CageID, AnimalID),
	CONSTRAINT FK_AnimalCage FOREIGN KEY(AnimalID) REFERENCES Animals(AnimalID)
);


CREATE TABLE Adoptions
(
	AnimalID int NOT NULL,
	PersonID varchar(13) NOT NULL,
	DateOfAdoption date NOT NULL,
	CONSTRAINT PK_Adoption PRIMARY KEY(AnimalID, PersonID),
	CONSTRAINT FK_AdoptedAnimal FOREIGN KEY(AnimalID) REFERENCES Animals(AnimalID),
	CONSTRAINT FK_Adopter FOREIGN KEY(PersonID) REFERENCES People(PersonID)
);

CREATE TABLE Donations
(
	PersonID varchar(13) NOT NULL,
	DonationType varchar(255), -- cash/supplies
	DonationAmount int,  -- ex: 2000dolari/5jucarii
	DonationDate date NOT NULL,
	CONSTRAINT PK_Donation PRIMARY KEY(PersonID, DonationType, DonationDate),
	CONSTRAINT FK_Donor FOREIGN KEY(PersonID) REFERENCES People(PersonID)
);

CREATE TABLE Fosters
(
	FosterID varchar(13) NOT NULL,
	AnimalID int NOT NULL,
	AdopterID varchar(13),
	DateOfArrival date NOT NULL,
	DateOfAdoption date,
	CONSTRAINT PK_Fostering PRIMARY KEY(FosterID, AnimalID),
	CONSTRAINT FK_FosterPerson FOREIGN KEY(FosterID) REFERENCES People(PersonID),
	CONSTRAINT FK_FosterAnimal FOREIGN KEY(AnimalID) REFERENCES Animals(AnimalID),
	CONSTRAINT FK_FosterAdopter FOREIGN KEY(AdopterID) REFERENCES People(PersonID),
);

CREATE TABLE Volunteers
(
	VolunteerID varchar(13) NOT NULL,
	Description text,
	CONSTRAINT PK_Volunteer PRIMARY KEY(VolunteerID),
	CONSTRAINT FK_Volunteer FOREIGN KEY(VolunteerID) REFERENCES People(PersonID),
);

CREATE TABLE Blacklist
(
	PersonID varchar(13) NOT NULL,
	Reason text,
	BlacklistDate date NOT NULL,
	CONSTRAINT PK_BlacklistedPerson PRIMARY KEY(PersonID),
	CONSTRAINT FK_BlacklistedPerson FOREIGN KEY(PersonID) REFERENCES People(PersonID),
);