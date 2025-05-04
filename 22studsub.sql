-- Consider following database:
-- Student (Roll_no, Name, Address)
-- Subject (Sub_code, Sub_name)
-- Marks (Roll_no, Sub_code, marks)
-- Write following queries in SQL:
-- i) Find average marks of each student, along with the name of student.
-- ii) Find how many students have failed in the subject “DBMS”.
-- iii) Find the students who get marks greater than 75 and and also find student who get less than 40.
-- iv) Find the student whose addresses are ‘PUNE’
-- v) Write a Trigger that check the rollno must be start with ‘TE’.

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Marks;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS Student;

-- Create the Student table
CREATE TABLE Student (
    Roll_no VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100)
);

-- Create the Subject table
CREATE TABLE Subject (
    Sub_code VARCHAR(10) PRIMARY KEY,
    Sub_name VARCHAR(50)
);

-- Create the Marks table
CREATE TABLE Marks (
    Roll_no VARCHAR(10),
    Sub_code VARCHAR(10),
    marks INT,
    PRIMARY KEY (Roll_no, Sub_code),
    FOREIGN KEY (Roll_no) REFERENCES Student(Roll_no),
    FOREIGN KEY (Sub_code) REFERENCES Subject(Sub_code)
);

-- Insert sample data into the Student table
INSERT INTO Student VALUES 
('TE101', 'Alice', 'PUNE'),
('TE102', 'Bob', 'MUMBAI'),
('TE103', 'Charlie', 'DELHI'),
('TE104', 'David', 'PUNE'),
('TE105', 'Eva', 'MUMBAI');

-- Insert sample data into the Subject table
INSERT INTO Subject VALUES 
('S101', 'DBMS'),
('S102', 'OOPS'),
('S103', 'DSA'),
('S104', 'Maths');

-- Insert sample data into the Marks table
INSERT INTO Marks VALUES 
('TE101', 'S101', 80),
('TE101', 'S102', 75),
('TE101', 'S103', 60),
('TE102', 'S101', 45),
('TE102', 'S102', 50),
('TE102', 'S103', 35),
('TE103', 'S101', 90),
('TE103', 'S102', 95),
('TE103', 'S103', 85),
('TE104', 'S101', 30),
('TE104', 'S102', 40),
('TE104', 'S103', 20),
('TE105', 'S101', 70),
('TE105', 'S102', 65),
('TE105', 'S103', 60);

-- i) Find average marks of each student, along with the name of student.
SELECT S.Name, AVG(M.marks) AS Average_Marks
FROM Student S
JOIN Marks M ON S.Roll_no = M.Roll_no
GROUP BY S.Roll_no;

-- ii) Find how many students have failed in the subject “DBMS”.
SELECT COUNT(DISTINCT M.Roll_no) AS Students_Failed
FROM Marks M
JOIN Subject S ON M.Sub_code = S.Sub_code
WHERE S.Sub_name = 'DBMS' AND M.marks < 40;

-- iii) Find the students who get marks greater than 75 and also find students who get less than 40.
-- Students with marks greater than 75
SELECT DISTINCT M.Roll_no, S.Name, M.marks
FROM Marks M
JOIN Student S ON M.Roll_no = S.Roll_no
WHERE M.marks > 75;

-- Students with marks less than 40
SELECT DISTINCT M.Roll_no, S.Name, M.marks
FROM Marks M
JOIN Student S ON M.Roll_no = S.Roll_no
WHERE M.marks < 40;

-- iv) Find the student whose addresses are ‘PUNE’
SELECT Name, Address
FROM Student
WHERE Address = 'PUNE';

-- v) Write a Trigger that checks if the rollno must start with ‘TE’.
DELIMITER //

CREATE TRIGGER CheckRollNo
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    IF NEW.Roll_no NOT LIKE 'TE%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Roll number must start with "TE".';
    END IF;
END //

DELIMITER ;
