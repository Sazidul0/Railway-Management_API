-- Users Table
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE,
    IsActive BIT DEFAULT 1
);

-- Insert values into Users table
INSERT INTO Users (Username, Password, FirstName, LastName, Email, PhoneNumber, IsActive) VALUES
('user1', 'password1', 'Md.', 'Rahman', 'user1@example.com', '01712XXXXXX', 1),
('user2', 'password2', 'Fatima', 'Akhtar', 'user2@example.com', '018X4XXXXXX', 1),
('user3', 'password3', 'Ahmed', 'Ali', 'user3@example.com', '01955XX4XXX', 1),
('user4', 'password4', 'Taslima', 'Begum', 'user4@example.com', '0174XXXXXXX', 1),
('user5', 'password5', 'Abdul', 'Haque', 'user5@example.com', '018XXX2XXXX', 1),
('user6', 'password6', 'Sumon', 'Islam', 'user6@example.com', '019XXXX1XXX', 1),
('user7', 'password7', 'Tahmina', 'Akter', 'user7@example.com', '0172XX9XXXX', 1),
('user8', 'password8', 'Rahim', 'Khan', 'user8@example.com', '018XXXXXXX3', 1),
('user9', 'password9', 'Ayesha', 'Binte', 'user9@example.com', '019XXXX44XX', 1),
('user10', 'password10', 'Sakib', 'Al', 'user10@example.com', '017XXX333XX', 1),
('user11', 'password11', 'Nusrat', 'Jahan', 'user11@example.com', '018333XXXXX', 1),
('user12', 'password12', 'Monir', 'Khan', 'user12@example.com', '019XX6666XX', 1),
('user13', 'password13', 'Arif', 'Islam', 'user13@example.com', '017XX0900XX', 1),
('user14', 'password14', 'Sabina', 'Akter', 'user14@example.com', '0180000X6XX', 1),
('user15', 'password15', 'Nasir', 'Uddin', 'user15@example.com', '01912345XXX', 1);







-- Wallets Table
DROP TABLE IF EXISTS Wallets;
CREATE TABLE Wallets (
    WalletID INTEGER PRIMARY KEY AUTOINCREMENT, 
    UserID INTEGER UNIQUE,
    Balance DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Insert values into Wallets table
INSERT INTO Wallets (UserID, Balance) VALUES
(1, 5000.00),
(2, 7500.00),
(3, 10000.00),
(4, 4000.00),
(5, 6000.00),
(6, 8500.00),
(7, 2500.00),
(8, 3000.00),
(9, 1500.00),
(10, 5000.00),
(11, 4500.00),
(12, 7500.00),
(13, 9000.00),
(14, 3500.00),
(15, 6500.00);





-- Stations Table
DROP TABLE IF EXISTS Stations;
CREATE TABLE Stations (
    StationID INTEGER PRIMARY KEY AUTOINCREMENT,
    StationName VARCHAR(100) UNIQUE NOT NULL
);

-- Insert values into Stations table
INSERT INTO Stations (StationName) VALUES
('Dhaka'),        --1
('Chittagong'),   --2
('Khulna'),       --3
('Rajshahi'),     --4
('Sylhet'),       --5
('Barisal'),      --6
('Rangpur'),      --7
('Comilla'),      --8
('Narayanganj'),  --9
('Jessore'),      --10
('Bogra'),        --11
('Cox''s Bazar'), --12
('Mymensingh'),   --13
('Tangail'),      --14
('Faridpur');     --15





-- Trains Table
DROP TABLE IF EXISTS Trains;
CREATE TABLE Trains (
    TrainID INTEGER PRIMARY KEY AUTOINCREMENT,
    TrainName VARCHAR(100) NOT NULL,
    OriginStationID INTEGER NOT NULL,
    DestinationStationID INTEGER NOT NULL,
    DepartureTime TIME NOT NULL,
    ArrivalTime TIME NOT NULL,
    Frequency VARCHAR(100), -- e.g., daily, weekly, etc.
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FarePerKilometer DECIMAL(10, 2) NOT NULL DEFAULT 2.0,
    CONSTRAINT fk_origin_station FOREIGN KEY (OriginStationID) REFERENCES Stations(StationID) ON DELETE CASCADE,
    CONSTRAINT fk_destination_station FOREIGN KEY (DestinationStationID) REFERENCES Stations(StationID) ON DELETE NO ACTION,
    CONSTRAINT chk_arrival_gt_departure CHECK (ArrivalTime > DepartureTime)
);

INSERT INTO Trains (TrainName, OriginStationID, DestinationStationID, DepartureTime, ArrivalTime, Frequency, StartDate, EndDate) VALUES
('Dhaka-Chittagong Express', 1, 2, '08:00:00', '13:00:00', 'Daily', '2024-05-01', '2024-12-31'),
('Dhaka-Rajshahi Express', 1, 4, '09:00:00', '16:00:00', 'Daily', '2024-05-01', '2024-12-31'),
('Dhaka-Khulna Local', 1, 3, '10:00:00', '16:00:00', 'Weekdays', '2024-05-01', '2024-12-31'),
('Dhaka-Sylhet Express', 1, 5, '11:00:00', '20:00:00', 'Weekends', '2024-05-01', '2024-12-31'),
('Chittagong-Rajshahi Local', 2, 4, '12:00:00', '18:00:00', 'Daily', '2024-05-01', '2024-12-31'),
('Chittagong-Sylhet Express', 2, 5, '13:00:00', '22:00:00', 'Daily', '2024-05-01', '2024-12-31'),
('Rajshahi-Khulna Express', 4, 3, '14:00:00', '20:00:00', 'Weekdays', '2024-05-01', '2024-12-31'),
('Rajshahi-Sylhet Local', 4, 5, '15:00:00', '22:00:00', 'Weekdays', '2024-05-01', '2024-12-31'),
('Khulna-Sylhet Express', 3, 5, '16:00:00', '23:00:00', 'Weekends', '2024-05-01', '2024-12-31'),
('Dhaka-Comilla Local', 1, 8, '17:00:00', '20:00:00', 'Daily', '2024-05-01', '2024-12-31'),
('Dhaka-Narayanganj Express', 1, 9, '18:00:00', '19:30:00', 'Daily', '2024-05-01', '2024-12-31'),
('Comilla-Narayanganj Express', 8, 9, '19:00:00', '21:00:00', 'Weekdays', '2024-05-01', '2024-12-31'),
('Jessore-Dhaka Local', 10, 1, '20:00:00', '23:00:00', 'Weekdays', '2024-05-01', '2024-12-31'),
('Rangpur-Dhaka Express', 11, 1, '21:00:00', '22:00:00', 'Weekends', '2024-05-01', '2024-12-31'),
('Cox''s Bazar-Dhaka Express', 12, 1, '22:00:00', '23:00:00', 'Daily', '2024-05-01', '2024-12-31');





-- TrainStops Table (Intermediate Table for Train Stops)
DROP TABLE IF EXISTS TrainStops;
CREATE TABLE TrainStops (
    TrainID INTEGER NOT NULL,
    StationID INTEGER NOT NULL,
    ArrivalTime TIME NOT NULL,
    DepartureTime TIME NOT NULL,
    Distance DECIMAL(10, 2) NOT NULL DEFAULT 0.0, -- Add Distance column
    ScheduleOrder INTEGER NOT NULL DEFAULT 0,
    IsStop INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (TrainID, StationID, ScheduleOrder),
    FOREIGN KEY (TrainID) REFERENCES Trains(TrainID) ON DELETE NO ACTION,
    FOREIGN KEY (StationID) REFERENCES Stations(StationID) ON DELETE CASCADE
    -- CONSTRAINT chk_arrival_gt_departure CHECK (ArrivalTime > DepartureTime) -- Optional constraint
);

-- Insert values into TrainStops table
INSERT INTO TrainStops (TrainID, StationID, ArrivalTime, DepartureTime, Distance) 
SELECT TrainID, StationID, '08:00:00', '08:15:00', 0.0 FROM Trains CROSS JOIN Stations;










-- Update TrainStops Table with Train Schedule
-- For each train, specify the schedule for each station
-- Set IsStop to 0 for stations where the train doesn't stop
-- Update the ScheduleOrder to indicate the order of stations

-- Dhaka-Chittagong Express (TrainID 1) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 9 THEN 2 -- Narayanganj
        WHEN StationID = 8 THEN 3 -- Comilla
        WHEN StationID = 2 THEN 4 -- Chittagong
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 9 THEN 1 -- Narayanganj
        WHEN StationID = 8 THEN 1 -- Comilla
        WHEN StationID = 2 THEN 1 -- Chittagong
        ELSE 0
    END
WHERE TrainID = 1;

-- Dhaka-Rajshahi Express (TrainID 2) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 14 THEN 2 -- Tangail
        WHEN StationID = 11 THEN 3 -- Bogura
        WHEN StationID = 4 THEN 4 -- Rajshahi
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID =14 THEN 1 -- Tangail
        WHEN StationID = 11 THEN 1 -- Bogura
        WHEN StationID = 4 THEN 1 -- Rajshahi
        ELSE 0
    END
WHERE TrainID = 2;

-- Dhaka-Khulna Local (TrainID 3) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
When StationID = 15 THEN 2 -- Faridpur
        WHEN StationID = 3 THEN 3 -- Khulna
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
When StationID = 15 THEN 1 -- Faridpur
        WHEN StationID = 3 THEN 1 -- Khulna
        ELSE 0
    END
WHERE TrainID = 3;


-- Dhaka-Sylhet Express (TrainID 4) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Chittagong
WHEN StationID = 13 THEN 2 -- Tangail
        WHEN StationID = 5 THEN 3 -- Rajshahi
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Chittagong
WHEN StationID = 13 THEN 1 -- Tangail
        WHEN StationID = 5 THEN 1 -- Rajshahi
        ELSE 0
    END
WHERE TrainID = 4;



-- Chittagong-Rajshahi Local (TrainID 5) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 2 THEN 1 -- Chittagong
WHEN StationID = 14 THEN 2 -- Tangail
        WHEN StationID = 4 THEN 3 -- Rajshahi
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 2 THEN 1 -- Chittagong
WHEN StationID = 14 THEN 1 -- Tangail
        WHEN StationID = 4 THEN 1 -- Rajshahi
        ELSE 0
    END
WHERE TrainID = 5;



-- Chittagong-Sylhet Express (TrainID 6) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 2 THEN 1 -- Chittagong
WHEN StationID = 13 THEN 2 -- Mymensingh
        WHEN StationID = 5 THEN 3 -- Sylhet
        ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 2 THEN 1 -- Chittagong
WHEN StationID = 13 THEN 1 -- Mymensingh
        WHEN StationID = 5 THEN 1 -- Sylhet
        ELSE 0
    END
WHERE TrainID = 6;

-- Rajshahi-Khulna Express (TrainID 7) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 4 THEN 1 -- Rajshahi
        WHEN StationID = 3 THEN 2 -- Khulna
        ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 4 THEN 1 -- Rajshahi
        WHEN StationID = 3 THEN 1 -- Khulna
        ELSE 0
    END
WHERE TrainID = 7;

-- Rajshahi-Sylhet Local (TrainID 8) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 4 THEN 1 -- Rajshahi
        WHEN StationID = 5 THEN 2 -- Sylhet
        ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 4 THEN 1 -- Rajshahi
        WHEN StationID = 5 THEN 1 -- Sylhet
        ELSE 0
    END
WHERE TrainID = 8;

-- Khulna-Sylhet Express (TrainID 9) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 3 THEN 1 -- Khulna
        WHEN StationID = 5 THEN 2 -- Sylhet
        ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 3 THEN 1 -- Khulna
        WHEN StationID = 5 THEN 1 -- Sylhet
        ELSE 0
    END
WHERE TrainID = 9;


-- Dhaka-Comilla Local (TrainID 10) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 8 THEN 2 -- Comilla
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 8 THEN 1 -- Comilla
        ELSE 0
    END
WHERE TrainID = 10;

-- Dhaka-Narayanganj Express (TrainID 11) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 9 THEN 2 -- Narayanganj
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 9 THEN 1 -- Narayanganj
        ELSE 0
    END
WHERE TrainID = 11;


-- Comilla-Narayanganj Express (TrainID 12) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 8 THEN 1 -- Comilla
        WHEN StationID = 9 THEN 2 -- Narayanganj
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 8 THEN 1 -- Comilla
        WHEN StationID = 9 THEN 1 -- Narayanganj
        ELSE 0
    END
WHERE TrainID = 12;


-- Jessore-Dhaka Local (TrainID 13) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 10 THEN 1 -- Jessore
WHEN StationID = 15 THEN 2 -- Faridpur
        WHEN StationID = 1 THEN 3 -- Dhaka
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 10 THEN 1 -- Jessore
WHEN StationID = 15 THEN 1 -- Faridpur
        WHEN StationID = 1 THEN 1 -- Dhaka
        ELSE 0
    END
WHERE TrainID = 13;



-- Rangpur-Dhaka Express (TrainID 14) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 7 THEN 1 -- Rangpur
WHEN StationID = 11 THEN 2 -- Bagura
        WHEN StationID = 1 THEN 3 -- Dhaka
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 7 THEN 1 -- Rangpur
WHEN StationID = 11 THEN 1 -- Bagura
        WHEN StationID = 1 THEN 1 -- Dhaka
        ELSE 0
    END
WHERE TrainID = 14;




-- Dhaka-Cox's Bazar Express (TrainID 1) Schedule
UPDATE TrainStops
SET ScheduleOrder =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 2 THEN 2 -- Chittagong
WHEN StationID = 12 THEN 3 -- Cox's Bazar
ELSE 0
    END,
    IsStop =
    CASE
        WHEN StationID = 1 THEN 1 -- Dhaka
        WHEN StationID = 2 THEN 1 -- Chittagong
WHEN StationID = 12 THEN 1 -- Cox's Bazar
        ELSE 0
    END
WHERE TrainID = 15;












UPDATE TrainStops
SET ArrivalTime = '10:00:00', DepartureTime = '10:15:00' WHERE TrainID = 1 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '13:00:00', DepartureTime = '13:15:00' WHERE TrainID = 1 AND StationID = 9;
UPDATE TrainStops
SET ArrivalTime = '14:00:00', DepartureTime = '14:15:00' WHERE TrainID = 1 AND StationID = 8;
UPDATE TrainStops
SET ArrivalTime = '15:00:00', DepartureTime = '15:15:00' WHERE TrainID = 1 AND StationID = 2;


UPDATE TrainStops
SET ArrivalTime = '12:00:00', DepartureTime = '12:15:00' WHERE TrainID = 2 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '15:00:00', DepartureTime = '15:15:00' WHERE TrainID = 2 AND StationID = 14;
UPDATE TrainStops
SET ArrivalTime = '17:00:00', DepartureTime = '17:15:00' WHERE TrainID = 2 AND StationID = 11;
UPDATE TrainStops
SET ArrivalTime = '21:00:00', DepartureTime = '21:15:00' WHERE TrainID = 2 AND StationID = 4;


UPDATE TrainStops
SET ArrivalTime = '06:00:00', DepartureTime = '06:15:00' WHERE TrainID = 3 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '11:00:00', DepartureTime = '11:15:00' WHERE TrainID = 3 AND StationID = 15;
UPDATE TrainStops
SET ArrivalTime = '14:00:00', DepartureTime = '14:15:00' WHERE TrainID = 3 AND StationID = 3;


UPDATE TrainStops
SET ArrivalTime = '23:00:00', DepartureTime = '23:15:00' WHERE TrainID = 4 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '03:00:00', DepartureTime = '03:15:00' WHERE TrainID = 4 AND StationID = 13;
UPDATE TrainStops
SET ArrivalTime = '08:00:00', DepartureTime = '08:15:00' WHERE TrainID = 4 AND StationID = 5;


UPDATE TrainStops
SET ArrivalTime = '23:00:00', DepartureTime = '23:15:00' WHERE TrainID = 5 AND StationID = 2;
UPDATE TrainStops
SET ArrivalTime = '07:00:00', DepartureTime = '07:15:00' WHERE TrainID = 5 AND StationID = 14;
UPDATE TrainStops
SET ArrivalTime = '16:00:00', DepartureTime = '16:15:00' WHERE TrainID = 5 AND StationID = 4;


UPDATE TrainStops
SET ArrivalTime = '09:00:00', DepartureTime = '09:15:00' WHERE TrainID = 6 AND StationID = 2;
UPDATE TrainStops
SET ArrivalTime = '16:00:00', DepartureTime = '16:15:00' WHERE TrainID = 6 AND StationID = 13;
UPDATE TrainStops
SET ArrivalTime = '20:00:00', DepartureTime = '20:15:00' WHERE TrainID = 6 AND StationID = 5;


UPDATE TrainStops
SET ArrivalTime = '15:00:00', DepartureTime = '15:15:00' WHERE TrainID = 7 AND StationID = 4;
UPDATE TrainStops
SET ArrivalTime = '23:00:00', DepartureTime = '23:15:00' WHERE TrainID = 7 AND StationID = 3;


UPDATE TrainStops
SET ArrivalTime = '16:00:00', DepartureTime = '16:15:00' WHERE TrainID = 8 AND StationID = 4;
UPDATE TrainStops
SET ArrivalTime = '00:00:00', DepartureTime = '00:15:00' WHERE TrainID = 8 AND StationID = 5;


UPDATE TrainStops
SET ArrivalTime = '14:00:00', DepartureTime = '14:15:00' WHERE TrainID = 9 AND StationID = 3;
UPDATE TrainStops
SET ArrivalTime = '01:00:00', DepartureTime = '01:15:00' WHERE TrainID = 9 AND StationID = 5;


UPDATE TrainStops
SET ArrivalTime = '14:00:00', DepartureTime = '14:15:00' WHERE TrainID = 10 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '16:30:00', DepartureTime = '17:15:00' WHERE TrainID = 10 AND StationID = 8;


UPDATE TrainStops
SET ArrivalTime = '15:00:00', DepartureTime = '15:15:00' WHERE TrainID = 11 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '16:30:00', DepartureTime = '16:15:00' WHERE TrainID = 11 AND StationID = 9;


UPDATE TrainStops
SET ArrivalTime = '07:25:00', DepartureTime = '07:40:00' WHERE TrainID = 12 AND StationID = 8;
UPDATE TrainStops
SET ArrivalTime = '08:40:00', DepartureTime = '08:55:00' WHERE TrainID = 12 AND StationID = 9;


UPDATE TrainStops
SET ArrivalTime = '19:00:00', DepartureTime = '19:15:00' WHERE TrainID = 13 AND StationID = 10;
UPDATE TrainStops
SET ArrivalTime = '21:00:00', DepartureTime = '21:15:00' WHERE TrainID =13 AND StationID = 15;
UPDATE TrainStops
SET ArrivalTime = '01:00:00', DepartureTime = '01:15:00' WHERE TrainID = 13 AND StationID = 1;

UPDATE TrainStops
SET ArrivalTime = '19:00:00', DepartureTime = '19:15:00' WHERE TrainID = 14 AND StationID = 7;
UPDATE TrainStops
SET ArrivalTime = '22:00:00', DepartureTime = '22:15:00' WHERE TrainID =14 AND StationID = 11;
UPDATE TrainStops
SET ArrivalTime = '03:00:00', DepartureTime = '03:15:00' WHERE TrainID = 14 AND StationID = 1;


UPDATE TrainStops
SET ArrivalTime = '08:00:00', DepartureTime = '08:15:00' WHERE TrainID = 15 AND StationID = 1;
UPDATE TrainStops
SET ArrivalTime = '13:00:00', DepartureTime = '13:15:00' WHERE TrainID = 15 AND StationID = 2;
UPDATE TrainStops
SET ArrivalTime = '17:00:00', DepartureTime = '17:15:00' WHERE TrainID = 15 AND StationID = 12;











-- Update TrainStops table with distance information

-- Dhaka-Chittagong Express (TrainID 1)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 9 THEN 80.0 -- Norshingdi
WHEN StationID = 8 THEN 160.0 -- Cumilla
        WHEN StationID = 2 THEN 243.0 -- Chittagong
ELSE 0
    END
WHERE TrainID = 1;

-- Dhaka-Rajshahi Express (TrainID 2)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 4 THEN 245.0 -- Rajshahi
WHEN StationID = 11 THEN 150.0 -- Bogura
WHEN StationID = 14 THEN 70.0 -- Tangail
ELSE 0
    END
WHERE TrainID = 2;

-- Dhaka-Khulna Local (TrainID 3)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 3 THEN 350.0 -- Khulna
ELSE 0
    END
WHERE TrainID = 3;

-- Dhaka-Sylhet Express (TrainID 4)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 5 THEN 380.0 -- Sylhet
WHEN StationID = 13 THEN 200.0 -- Mymensingh
ELSE 0
    END
WHERE TrainID = 4;


-- Chattogram-Rajshahi Express (TrainID 5)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 2 THEN 0.0 -- Chattogram
        WHEN StationID = 14 THEN 380.0 -- Tangail
WHEN StationID = 4 THEN 500.0 -- Rajshahi
ELSE 0
    END
WHERE TrainID = 5;


-- Chattogram-Sylhet Express (TrainID 6)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 2 THEN 0.0 --Chattogram
        WHEN StationID = 13 THEN 443.0 -- Mymensingh
WHEN StationID = 5 THEN 580.0 -- Sylhet
ELSE 0
    END
WHERE TrainID = 6;


-- Rajshahi-Khulna Express (TrainID 7)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 3 THEN 600.0 --Khulna
        WHEN StationID = 4 THEN 0.0 -- Rajshahi
ELSE 0
    END
WHERE TrainID = 7;


-- Rajshahi-Sylhet Express (TrainID 8)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 4 THEN 0.0 --Rajshahi
        WHEN StationID = 5 THEN 450.0 -- Sylhet
ELSE 0
    END
WHERE TrainID = 8;


-- Khulna-Sylhet Express (TrainID 9)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 3 THEN 0.0 --Khulna
        WHEN StationID = 5 THEN 500.0 -- Sylhet
ELSE 0
    END
WHERE TrainID = 9;


-- Dhaka-Cumilla Express (TrainID 10)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 8 THEN 170.0 -- Cumilla
ELSE 0
    END
WHERE TrainID = 10;


-- Dhaka-Narayanganj Express (TrainID 11)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 9 THEN 120.0 -- Narayanganj
ELSE 0
    END
WHERE TrainID = 11;


-- Dhaka-Narayanganj Express (TrainID 12)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 8 THEN 0.0 -- Cumilla
        WHEN StationID = 9 THEN 95.0 -- Narayanganj
ELSE 0
    END
WHERE TrainID = 12;



-- Jessore-Dhaka Express (TrainID 13)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 10 THEN 0.0 -- Jessore
        WHEN StationID = 15 THEN 150.0 -- Faridpur
WHEN StationID = 1 THEN 320.0 -- Dhaka
ELSE 0
    END
WHERE TrainID = 13;


-- Rangpur-Dhaka Express (TrainID 14)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 7 THEN 0.0 -- Rangpur
        WHEN StationID = 11 THEN 170.0 -- Bagura
WHEN StationID = 1 THEN 370.0 -- Dhaka
ELSE 0
    END
WHERE TrainID = 14;


-- Dhaka-Cox's Bazar Express (TrainID 15)
UPDATE TrainStops
SET Distance =
    CASE
        WHEN StationID = 1 THEN 0.0 -- Dhaka
        WHEN StationID = 2 THEN 243.0 -- Chattogram
WHEN StationID = 12 THEN 495.0 -- Cox's Bazar
ELSE 0
    END
WHERE TrainID = 15;


















-- Tickets Table
DROP TABLE IF EXISTS Tickets;
CREATE TABLE Tickets (
    TicketID INTEGER PRIMARY KEY AUTOINCREMENT,
    UserID INTEGER,
    TrainID INTEGER,
    BoardingStationID INTEGER,
    DisembarkingStationID INTEGER,
    SeatNumber INTEGER,
    Fare DECIMAL(10, 2),
    TravelDate DATE,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsReserved BIT DEFAULT 0,
    ReservationDate DATETIME,
    IsCancelled BIT DEFAULT 0,
    CancellationDate DATETIME,
    ReservationUserID INTEGER,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE NO ACTION,
    FOREIGN KEY (TrainID) REFERENCES Trains(TrainID) ON DELETE NO ACTION,
    FOREIGN KEY (BoardingStationID) REFERENCES Stations(StationID) ON DELETE NO ACTION,
    FOREIGN KEY (DisembarkingStationID) REFERENCES Stations(StationID) ON DELETE NO ACTION,
    FOREIGN KEY (ReservationUserID) REFERENCES Users(UserID) ON DELETE SET NULL
);

-- Insert values into Tickets table
INSERT INTO Tickets (UserID, TrainID, BoardingStationID, DisembarkingStationID, SeatNumber, Fare, TravelDate, IsReserved, ReservationDate, IsCancelled, CancellationDate, ReservationUserID)
VALUES
(1, 1, 1, 2, 1, 1500.00, '2024-05-05', 1, '2024-05-04 10:00:00', 0, NULL, 1),
(2, 2, 1, 4, 2, 2000.00, '2024-05-06', 1, '2024-05-04 11:00:00', 0, NULL, 2),
(3, 3, 1, 3, 3, 1200.00, '2024-05-07', 1, '2024-05-04 12:00:00', 0, NULL, 3),
(4, 4, 1, 5, 4, 1800.00, '2024-05-08', 1, '2024-05-04 13:00:00', 0, NULL, 4),
(5, 5, 2, 4, 5, 1600.00, '2024-05-05', 1, '2024-05-04 14:00:00', 0, NULL, 5),
(6, 6, 3, 5, 6, 1900.00, '2024-05-06', 1, '2024-05-04 15:00:00', 0, NULL, 6),
(7, 7, 4, 2, 7, 1700.00, '2024-05-07', 1, '2024-05-04 16:00:00', 0, NULL, 7),
(8, 8, 5, 3, 8, 1400.00, '2024-05-08', 1, '2024-05-04 17:00:00', 0, NULL, 8),
(9, 9, 1, 5, 9, 2200.00, '2024-05-05', 1, '2024-05-04 18:00:00', 0, NULL, 9),
(10, 10, 2, 1, 10, 1300.00, '2024-05-06', 1, '2024-05-04 19:00:00', 0, NULL, 10),
(11, 11, 3, 4, 11, 1800.00, '2024-05-07', 1, '2024-05-04 20:00:00', 0, NULL, 11),
(12, 12, 4, 3, 12, 2100.00, '2024-05-08', 1, '2024-05-04 21:00:00', 0, NULL, 12),
(13, 13, 5, 2, 13, 2000.00, '2024-05-05', 1, '2024-05-04 22:00:00', 0, NULL, 13),
(14, 14, 1, 3, 14, 1700.00, '2024-05-06', 1, '2024-05-04 23:00:00', 0, NULL, 14),
(15, 15, 2, 5, 15, 1500.00, '2024-05-07', 1, '2024-05-04 00:00:00', 0, NULL, 15);





-- Employees Table
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT,
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15) UNIQUE,
    IsActive BIT DEFAULT 1
);

-- Insert values into Employees table
INSERT INTO Employees (Username, Password, FirstName, LastName, Email, PhoneNumber, IsActive) VALUES
('admin1', 'password1', 'John', 'Doe', 'admin1@example.com', '017XXX33XXX', 1),
('admin2', 'password2', 'Jane', 'Smith', 'admin2@example.com', '018XX34XXXX', 1),
('admin3', 'password3', 'Emily', 'Johnson', 'admin3@example.com', '01922XXXXXX', 1),
('admin4', 'password4', 'Michael', 'Brown', 'admin4@example.com', '017XXXXXXXX', 1),
('admin5', 'password5', 'Sophia', 'Miller', 'admin5@example.com', '018XXXXXXXX', 1),
('admin6', 'password6', 'William', 'Wilson', 'admin6@example.com', '019XXXXXXXX', 1),
('admin7', 'password7', 'Olivia', 'Martinez', 'admin7@example.com', '017999XXXXX', 1),
('admin8', 'password8', 'James', 'Davis', 'admin8@example.com', '018XXXXX00X', 1),
('admin9', 'password9', 'Amelia', 'Garcia', 'admin9@example.com', '019XXXXXX11', 1),
('admin10', 'password10', 'Benjamin', 'Rodriguez', 'admin10@example.com', '01711XXXXXX', 1),
('admin11', 'password11', 'Emma', 'Lopez', 'admin11@example.com', '01833333XXX', 1),
('admin12', 'password12', 'Lucas', 'Lee', 'admin12@example.com', '019X45678XX', 1),
('admin13', 'password13', 'Ava', 'Perez', 'admin13@example.com', '017XXXX014X', 1),
('admin14', 'password14', 'Alexander', 'Gonzalez', 'admin14@example.com', '0168XXXXXXX', 1),
('admin15', 'password15', 'Mia', 'Hernandez', 'admin15@example.com', '019X00987XX', 1);





-- Create TrainCapacity table
DROP TABLE IF EXISTS TrainCapacity;
CREATE TABLE TrainCapacity (
    TrainID INTEGER PRIMARY KEY,
    Capacity INTEGER NOT NULL,
    ReservedSeats INTEGER DEFAULT 0, 
    FOREIGN KEY (TrainID) REFERENCES Trains(TrainID) ON DELETE CASCADE
);

-- Insert values into TrainCapacity table
INSERT INTO TrainCapacity (Capacity) VALUES
(200),  -- Assuming TrainID 1 has a capacity of 200 seats
(150),  -- Assuming TrainID 2 has a capacity of 150 seats
(180),  -- Assuming TrainID 3 has a capacity of 180 seats
(200),  -- Assuming TrainID 4 has a capacity of 200 seats
(150),  -- Assuming TrainID 5 has a capacity of 150 seats
(180),  -- Assuming TrainID 6 has a capacity of 180 seats
(200),  -- Assuming TrainID 7 has a capacity of 200 seats
(150),  -- Assuming TrainID 8 has a capacity of 150 seats
(180),  -- Assuming TrainID 9 has a capacity of 180 seats
(200),  -- Assuming TrainID 10 has a capacity of 200 seats
(150),  -- Assuming TrainID 11 has a capacity of 150 seats
(180),  -- Assuming TrainID 12 has a capacity of 180 seats
(200),  -- Assuming TrainID 13 has a capacity of 200 seats
(150),  -- Assuming TrainID 14 has a capacity of 150 seats
(180);  -- Assuming TrainID 15 has a capacity of 180 seats
