-- Design the MySQL Database with following entities,
-- •
-- SAILORS (SID: INTEGER, SNAME:STRING, RATING:INTEGER(Must be in between 1 to 10), AGE:REAL)
-- •
-- BOATS (BID: INTEGER, BNAME: STRING, COLOR: STRING)
-- •
-- RESERVES (SID: INTEGER, BID: INTEGER, DAY: DATE)
-- Make appropriate tables and add required data for the above database. Frame and execute the SQL queries for the following:
-- 1.
-- Find the names of sailors who have reserved boat number 123.
-- 2.
-- Find names of the sailors who have reserved at least one boat.
-- 3.
-- Find average age of Expert sailors.
-- 4.
-- Write the following queries on Expert Sailor View.
-- 4.1
-- Find the Sailors with age > 25 and rating equal to 10.
-- 4.2
-- Find the total number of Sailors in Expert Sailor view.
-- 4.3
-- Find the number of Sailors at each rating level ( 8, 9, 10).
-- 5.
-- Write appropriate procedure to update rating of sailors by 2 if rating is less than 5, by 1 if rating is >5 and doesn’t change the rating if it is equal to 10.

-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS RESERVES;
DROP TABLE IF EXISTS BOATS;
DROP TABLE IF EXISTS SAILORS;

-- 1. Create Tables

CREATE TABLE SAILORS (
    SID INT PRIMARY KEY,
    SNAME VARCHAR(100),
    RATING INT CHECK (RATING BETWEEN 1 AND 10),
    AGE REAL
);

CREATE TABLE BOATS (
    BID INT PRIMARY KEY,
    BNAME VARCHAR(100),
    COLOR VARCHAR(50)
);

CREATE TABLE RESERVES (
    SID INT,
    BID INT,
    DAY DATE,
    FOREIGN KEY (SID) REFERENCES SAILORS(SID),
    FOREIGN KEY (BID) REFERENCES BOATS(BID)
);

-- 2. Insert Sample Data

INSERT INTO SAILORS (SID, SNAME, RATING, AGE) VALUES
(1, 'Alice', 9, 25.5),
(2, 'Bob', 4, 22.3),
(3, 'Charlie', 10, 27.1),
(4, 'Diana', 6, 24.0),
(5, 'Ethan', 10, 30.5);

INSERT INTO BOATS (BID, BNAME, COLOR) VALUES
(101, 'Red Dragon', 'Red'),
(123, 'Sea Queen', 'Blue'),
(145, 'Ocean Pearl', 'White');

INSERT INTO RESERVES (SID, BID, DAY) VALUES
(1, 123, '2025-05-04'),
(3, 123, '2025-05-03'),
(4, 101, '2025-05-01'),
(5, 145, '2025-05-02');

-- 3. Queries

-- 1. Names of sailors who have reserved boat number 123
SELECT S.SNAME
FROM SAILORS S
JOIN RESERVES R ON S.SID = R.SID
WHERE R.BID = 123;

-- 2. Sailors who have reserved at least one boat
SELECT DISTINCT S.SNAME
FROM SAILORS S
JOIN RESERVES R ON S.SID = R.SID;

-- 3. Average age of expert sailors (rating = 10)
SELECT AVG(AGE) AS avg_expert_age
FROM SAILORS
WHERE RATING = 10;

-- 4. Create View for Expert Sailors
CREATE OR REPLACE VIEW ExpertSailors AS
SELECT * FROM SAILORS
WHERE RATING = 10;

-- 4.1 Sailors with age > 25 and rating = 10
SELECT * FROM ExpertSailors
WHERE AGE > 25;

-- 4.2 Total number of sailors in Expert Sailor view
SELECT COUNT(*) AS total_expert_sailors
FROM ExpertSailors;

-- 4.3 Number of expert sailors at rating levels 8, 9, 10
SELECT RATING, COUNT(*) AS sailor_count
FROM SAILORS
WHERE RATING IN (8, 9, 10)
GROUP BY RATING;

-- 5. Stored Procedure to update ratings

DELIMITER //

CREATE PROCEDURE UpdateSailorRatings()
BEGIN
    -- If rating < 5, increase by 2
    UPDATE SAILORS
    SET RATING = RATING + 2
    WHERE RATING < 5;

    -- If rating > 5 and < 10, increase by 1
    UPDATE SAILORS
    SET RATING = RATING + 1
    WHERE RATING > 5 AND RATING < 10;

    -- Do nothing for rating = 10
END //

DELIMITER ;

-- To run the procedure
CALL UpdateSailorRatings();

-- Check updated ratings
SELECT * FROM SAILORS;
