-- Design the MySQL Database Schema for student-Lab scenario
-- Student (stud_no: integer, stud_name: string, class: string)
-- Class (class: string,descrip: string)
-- Lab (machi_no: integer, Lab_no: integer, description: String)
-- Allotment (Stud_no: Integer, mach_no: integer, dayof week: string)
-- For the above schema, perform the following—
-- a)
-- List all the machine allotments with the student names, lab and machine numbers
-- b)
-- List the total number of lab allotments day wise
-- c)
-- Give a count of how many machines have been allocated to the ‘CSIT’ class
-- d)
-- Give a machine allotment etails of the stud_no 5 with his personal and class details
-- e)
-- Count for how many machines have been allocated in Lab_no 1 for the day of the week as “Monday”
-- f)
-- Create a view which lists the machine allotment details for “Thursday”.

-- Drop tables if they already exist
DROP TABLE IF EXISTS Allotment;
DROP TABLE IF EXISTS Lab;
DROP TABLE IF EXISTS Class;
DROP TABLE IF EXISTS Student;

-- Create the Student Table
CREATE TABLE Student (
    stud_no INT PRIMARY KEY,
    stud_name VARCHAR(255),
    class VARCHAR(50)
);

-- Create the Class Table
CREATE TABLE Class (
    class VARCHAR(50) PRIMARY KEY,
    descrip VARCHAR(255)
);

-- Create the Lab Table
CREATE TABLE Lab (
    machi_no INT PRIMARY KEY,
    Lab_no INT,
    description VARCHAR(255)
);

-- Create the Allotment Table
CREATE TABLE Allotment (
    stud_no INT,
    mach_no INT,
    dayof_week VARCHAR(20),
    PRIMARY KEY (stud_no, mach_no),
    FOREIGN KEY (stud_no) REFERENCES Student(stud_no),
    FOREIGN KEY (mach_no) REFERENCES Lab(machi_no)
);

-- Insert Sample Data into Student Table
INSERT INTO Student (stud_no, stud_name, class) VALUES
(1, 'Alice', 'CSIT'),
(2, 'Bob', 'CSIT'),
(3, 'Charlie', 'EE'),
(4, 'Diana', 'CSIT'),
(5, 'Ethan', 'EE');

-- Insert Sample Data into Class Table
INSERT INTO Class (class, descrip) VALUES
('CSIT', 'Computer Science and Information Technology'),
('EE', 'Electrical Engineering');

-- Insert Sample Data into Lab Table
INSERT INTO Lab (machi_no, Lab_no, description) VALUES
(1, 101, 'Computer Lab 1'),
(2, 101, 'Computer Lab 2'),
(3, 102, 'Physics Lab 1'),
(4, 102, 'Physics Lab 2');

-- Insert Sample Data into Allotment Table
INSERT INTO Allotment (stud_no, mach_no, dayof_week) VALUES
(1, 1, 'Monday'),
(2, 2, 'Tuesday'),
(3, 3, 'Wednesday'),
(4, 4, 'Thursday'),
(5, 1, 'Monday'),
(1, 2, 'Wednesday'),
(2, 3, 'Thursday');

-- Queries

-- a) List all the machine allotments with the student names, lab and machine numbers
SELECT s.stud_name, l.Lab_no, l.machi_no, a.dayof_week
FROM Allotment a
JOIN Student s ON a.stud_no = s.stud_no
JOIN Lab l ON a.mach_no = l.machi_no;

-- b) List the total number of lab allotments day wise
SELECT dayof_week, COUNT(*) AS total_allotments
FROM Allotment
GROUP BY dayof_week;

-- c) Give a count of how many machines have been allocated to the ‘CSIT’ class
SELECT COUNT(DISTINCT a.mach_no) AS total_machines_allocated
FROM Allotment a
JOIN Student s ON a.stud_no = s.stud_no
WHERE s.class = 'CSIT';

-- d) Give the machine allotment details of the stud_no 5 with his personal and class details
SELECT s.stud_no, s.stud_name, s.class, l.Lab_no, l.machi_no, a.dayof_week
FROM Allotment a
JOIN Student s ON a.stud_no = s.stud_no
JOIN Lab l ON a.mach_no = l.machi_no
WHERE s.stud_no = 5;

-- e) Count how many machines have been allocated in Lab_no 1 for the day of the week as “Monday”
SELECT COUNT(DISTINCT a.mach_no) AS machines_allocated
FROM Allotment a
JOIN Lab l ON a.mach_no = l.machi_no
WHERE l.Lab_no = 101 AND a.dayof_week = 'Monday';

-- f) Create a view which lists the machine allotment details for “Thursday”
CREATE VIEW Thursday_Allotments AS
SELECT s.stud_name, l.Lab_no, l.machi_no, a.dayof_week
FROM Allotment a
JOIN Student s ON a.stud_no = s.stud_no
JOIN Lab l ON a.mach_no = l.machi_no
WHERE a.dayof_week = 'Thursday';

-- To view the records for Thursday:
SELECT * FROM Thursday_Allotments;

