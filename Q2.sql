DROP DATABASE NONOfuel;

# 1
CREATE DATABASE NONOfuel;
USE NONOfuel;

CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    driver_name varchar(25)
);

CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY,
    vehicleOwner_id INT
);

CREATE TABLE DriveIn (
    driver_id INT,
    vehicle_id INT,
    FOREIGN KEY (driver_id) REFERENCES Drivers (driver_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id),
    PRIMARY KEY (driver_id, vehicle_id)
);

CREATE TABLE FuelingStations (
    company VARCHAR(50),
    F_Name VARCHAR(50), 
    F_city VARCHAR(20),
    F_strret VARCHAR(20),
    F_num INT,
    PRIMARY KEY (F_city, F_strret, F_num)
);

CREATE TABLE Fueling (
    year_date INT,
    month_date INT,
    day_date INT,
    mixed_fuel BOOL,
    F_city VARCHAR(20),
    F_strret VARCHAR(20),
    F_num INT,
    vehicle_id INT,
    FOREIGN KEY (F_city, F_strret, F_num) REFERENCES FuelingStations(F_city, F_strret, F_num),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id),
    PRIMARY KEY (year_date, month_date, day_date, vehicle_id) 
); 

# 2
INSERT INTO Drivers (driver_id, driver_name) VALUES 
(1, "yosi"), 
(2, "lior"), 
(3, "ariel"), 
(4, "dina"), 
(5, "moti");

INSERT INTO Vehicles (vehicle_id, vehicleOwner_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5); 

INSERT INTO DriveIn (driver_id, vehicle_id) VALUES 
(1, 1), 
(2, 3), 
(3, 2), 
(4, 4), 
(5, 5); 

INSERT INTO FuelingStations (company, F_Name, F_city, F_strret, F_num) VALUES 
('Sonol', 'Station A', 'Haifa', 'Rabnitzky', 8),
('Paz', 'Station B', 'Tel Aviv', 'Dizengoff', 100),
('Delek', 'Station C', 'Haifa', 'Herzl', 1),
('Sonol', 'Station D', 'Jerusalem', 'Jaffa', 50),
('Paz', 'Station E', 'Tel Aviv', 'Herzl', 10);

INSERT INTO Fueling (year_date, month_date, day_date, mixed_fuel, F_city, F_strret, F_num, vehicle_id) VALUES 
(2024, 6, 1, TRUE, 'Haifa', 'Rabnitzky', 8, 1),
(2024, 6, 2, FALSE, 'Tel Aviv', 'Dizengoff', 100, 2),
(2024, 6, 3, TRUE, 'Haifa', 'Herzl', 1, 3),
(2024, 6, 4, FALSE, 'Jerusalem', 'Jaffa', 50, 4),
(2024, 6, 5, TRUE, 'Tel Aviv', 'Herzl', 10, 3);


#3.1
SELECT COUNT(vehicle_id) as number_of_cars_with_nono_fuel
FROM Fueling
WHERE mixed_fuel = TRUE;

# 3.2
ALTER TABLE Vehicles
ADD V_city VARCHAR(50);

SET SQL_SAFE_UPDATES = 0;


UPDATE Vehicles SET V_city = 'Tel Aviv' WHERE vehicleOwner_id = 1;
UPDATE Vehicles SET V_city = 'Jerusalem' WHERE vehicleOwner_id = 2;
UPDATE Vehicles SET V_city = 'Jerusalem' WHERE vehicleOwner_id = 3;
UPDATE Vehicles SET V_city = 'Tel Aviv' WHERE vehicleOwner_id = 4;
UPDATE Vehicles SET V_city = 'Haifa' WHERE vehicleOwner_id = 5;



SELECT V_city, 
       COUNT(DISTINCT vehicleOwner_id) AS num_owners, 
       (COUNT(DISTINCT vehicleOwner_id) * 100.0 / (SELECT COUNT(DISTINCT vehicleOwner_id) FROM Vehicles)) AS owner_percentage
FROM Vehicles
GROUP BY V_city
ORDER BY owner_percentage DESC LIMIT 1;

#3.3
 
SELECT V.V_city, 
       (COUNT(DISTINCT F.vehicle_id) * 100.0 / T.total_vehicles) AS affected_percentage
FROM Fueling F
JOIN Vehicles V ON F.vehicle_id = V.vehicle_id
JOIN (
    SELECT V_city, COUNT(vehicle_id) AS total_vehicles
    FROM Vehicles
    GROUP BY V_city)
T ON V.V_city = T.V_city
WHERE F.mixed_fuel = TRUE
GROUP BY V.V_city, T.total_vehicles
ORDER BY affected_percentage DESC
LIMIT 1;

#3.4
SELECT 
    company, 
    F_city, 
    COUNT(*) AS StationCount FROM FuelingStations
    GROUP BY 
    company, 
    F_city
ORDER BY 
    company, 
    F_city;
    
#3.5    
SELECT  Drivers.driver_name, (Fueling.vehicle_id) as damaged_vehicle_id
 FROM Fueling
join DriveIn
on Fueling.vehicle_id = DriveIn.vehicle_id
join Drivers
on DriveIn.driver_id = Drivers.driver_id 
WHERE mixed_fuel=True
group BY 
Fueling.vehicle_id;

#3.6
CREATE VIEW view_name AS
SELECT  Drivers.driver_name, Fueling.vehicle_id, vehicles.V_city
 FROM Fueling
join DriveIn
on Fueling.vehicle_id = DriveIn.vehicle_id
join Drivers
on DriveIn.driver_id = Drivers.driver_id 
join vehicles
on vehicles.vehicleOwner_id = Drivers.driver_id
WHERE mixed_fuel=True
group BY 
vehicle_id ORDER BY vehicle_id DESC;


#3.7
CREATE USER 'liorel'@'benZion' IDENTIFIED BY 'password123';
GRANT SELECT ON NONOfuel.view_name TO 'liorel'@'benZion';






