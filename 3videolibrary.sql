-- Design the MySQL Database Schema for Video Library scenario
-- Customer (cust_no: integer,cust_name: string)
-- Membership (Mem_no: integer, cust_no: integer)
-- Cassette (cass_no:integer, cass_name:string, Language: String)
-- Iss_rec (iss_no: integer, iss_date: date, mem_no: integer, cass_no: integer)
-- For the above schema, perform the following:-
-- a)
-- List all the customer names with their membership numbers
-- b)
-- List all the issues for the current date with the customer names and cassette names
-- c)
-- List the details of the customer who has borrowed the cassette whose title is “ The Legend”
-- d)
-- Give a count of how many cassettes have been borrowed by each customer
-- e)
-- Write a trigger to delete a Customer record

-- Drop tables if they already exist (for development use)
DROP TABLE IF EXISTS iss_rec;
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS cassette;
DROP TABLE IF EXISTS customer;

-- 1. Create Tables

CREATE TABLE customer (
    cust_no INT AUTO_INCREMENT PRIMARY KEY,
    cust_name VARCHAR(100)
);

CREATE TABLE membership (
    mem_no INT AUTO_INCREMENT PRIMARY KEY,
    cust_no INT,
    FOREIGN KEY (cust_no) REFERENCES customer(cust_no)
);

CREATE TABLE cassette (
    cass_no INT AUTO_INCREMENT PRIMARY KEY,
    cass_name VARCHAR(100),
    language VARCHAR(50)
);

CREATE TABLE iss_rec (
    iss_no INT AUTO_INCREMENT PRIMARY KEY,
    iss_date DATE,
    mem_no INT,
    cass_no INT,
    FOREIGN KEY (mem_no) REFERENCES membership(mem_no),
    FOREIGN KEY (cass_no) REFERENCES cassette(cass_no)
);

-- 2. Sample Data

INSERT INTO customer (cust_name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO membership (cust_no) VALUES
(1), (2), (3);

INSERT INTO cassette (cass_name, language) VALUES
('The Legend', 'English'),
('Avengers', 'English'),
('Dangal', 'Hindi');

-- Assume today is '2025-05-04'
INSERT INTO iss_rec (iss_date, mem_no, cass_no) VALUES
('2025-05-04', 1, 1),
('2025-05-04', 2, 2),
('2025-05-03', 3, 3);

-- a) List all customer names with their membership numbers
SELECT c.cust_name, m.mem_no
FROM customer c
JOIN membership m ON c.cust_no = m.cust_no;

-- b) List all issues for the current date with customer and cassette names
SELECT c.cust_name, cas.cass_name, i.iss_date
FROM iss_rec i
JOIN membership m ON i.mem_no = m.mem_no
JOIN customer c ON m.cust_no = c.cust_no
JOIN cassette cas ON i.cass_no = cas.cass_no
WHERE i.iss_date = CURDATE();

-- c) Customer who borrowed cassette titled “The Legend”
SELECT c.*
FROM customer c
JOIN membership m ON c.cust_no = m.cust_no
JOIN iss_rec i ON m.mem_no = i.mem_no
JOIN cassette cas ON i.cass_no = cas.cass_no
WHERE cas.cass_name = 'The Legend';

-- d) Count of cassettes borrowed by each customer
SELECT c.cust_name, COUNT(*) AS total_borrowed
FROM customer c
JOIN membership m ON c.cust_no = m.cust_no
JOIN iss_rec i ON m.mem_no = i.mem_no
GROUP BY c.cust_no;

-- e) Trigger to log deletion of a customer

-- First, create log table
CREATE TABLE customer_deletion_log (
    cust_no INT,
    cust_name VARCHAR(100),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger
DELIMITER //

CREATE TRIGGER log_customer_deletion
BEFORE DELETE ON customer
FOR EACH ROW
BEGIN
    INSERT INTO customer_deletion_log (cust_no, cust_name)
    VALUES (OLD.cust_no, OLD.cust_name);
END //

DELIMITER ;

-- To test trigger:
-- DELETE FROM customer WHERE cust_no = 3;
-- SELECT * FROM customer_deletion_log;
