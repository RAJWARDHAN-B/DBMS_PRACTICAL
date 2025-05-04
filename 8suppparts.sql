-- Consider the relational database
-- Supplier (sid, sname, address)
-- Parts (pid, pname, color)
-- Catalog (sid, pid, cost)
-- Write SQL queries for the following:
-- i) Find names of suppliers who supply some red parts.
-- ii) Find names of all parts whose cost is more than Rs. 25
-- iii) Find name of all parts whose color is green.
-- iv) Find name of supplier and parts with its color and cost.
-- v) Write a trigger which will keep backup of updating part cost
-- vi) trigger to prevent insertion of parts with negative cost

-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS Catalog;
DROP TABLE IF EXISTS Parts;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS PartCostBackup;

-- Create the Supplier Table
CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(100),
    address VARCHAR(255)
);

-- Create the Parts Table
CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(100),
    color VARCHAR(50)
);

-- Create the Catalog Table
CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10, 2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

-- Insert data into Supplier table
INSERT INTO Supplier (sid, sname, address) VALUES
(1, 'Supplier A', 'Address A'),
(2, 'Supplier B', 'Address B'),
(3, 'Supplier C', 'Address C');

-- Insert data into Parts table
INSERT INTO Parts (pid, pname, color) VALUES
(101, 'Part 1', 'Red'),
(102, 'Part 2', 'Green'),
(103, 'Part 3', 'Blue'),
(104, 'Part 4', 'Red'),
(105, 'Part 5', 'Green');

-- Insert data into Catalog table
INSERT INTO Catalog (sid, pid, cost) VALUES
(1, 101, 30.00),
(1, 102, 15.00),
(2, 103, 50.00),
(2, 104, 20.00),
(3, 105, 25.00);

-- Queries

-- i) Find names of suppliers who supply some red parts
SELECT DISTINCT s.sname
FROM Supplier s
JOIN Catalog c ON s.sid = c.sid
JOIN Parts p ON c.pid = p.pid
WHERE p.color = 'Red';

-- ii) Find names of all parts whose cost is more than Rs. 25
SELECT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
WHERE c.cost > 25;

-- iii) Find names of all parts whose color is green
SELECT p.pname
FROM Parts p
WHERE p.color = 'Green';

-- iv) Find names of suppliers and parts with their color and cost
SELECT s.sname, p.pname, p.color, c.cost
FROM Supplier s
JOIN Catalog c ON s.sid = c.sid
JOIN Parts p ON c.pid = p.pid;

-- Triggers

-- v) Create a backup table to store cost updates
CREATE TABLE PartCostBackup (
    pid INT,
    old_cost DECIMAL(10, 2),
    new_cost DECIMAL(10, 2),
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log cost changes
DELIMITER //

CREATE TRIGGER backup_cost_update
AFTER UPDATE ON Catalog
FOR EACH ROW
BEGIN
    -- Inserting the old and new cost into the backup table
    INSERT INTO PartCostBackup (pid, old_cost, new_cost)
    VALUES (OLD.pid, OLD.cost, NEW.cost);
END //

DELIMITER ;

-- vi) Trigger to prevent insertion of parts with negative cost
DELIMITER //

CREATE TRIGGER prevent_negative_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert parts with negative cost';
    END IF;
END //

DELIMITER ;

