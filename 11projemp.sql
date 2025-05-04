-- A database consists of following tables.
-- PROJECT(PNO, PNAME, CHIEF)
-- EMPLOYEE(EMPNO, EMPNAME)
-- ASSIGNED(PNO,EMPNO)
-- A. Get count of employees working on project.
-- B. Get details of employee working on project pr002.
-- C. Get details of employee working on project DBMS.
-- D. Write a trigger to delete all corresponding records from assigned table if employee id deleted.
-- E. Write a trigger to keep back up of assign table records if project is deleted.
-- F. Get all employees assigned to a given project number

-- Drop existing tables if they exist (for development/testing purposes)
DROP TABLE IF EXISTS ASSIGNED;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS PROJECT;

-- Create the PROJECT Table
CREATE TABLE PROJECT (
    PNO VARCHAR(10) PRIMARY KEY,
    PNAME VARCHAR(255),
    CHIEF VARCHAR(255)
);

-- Create the EMPLOYEE Table
CREATE TABLE EMPLOYEE (
    EMPNO INT PRIMARY KEY,
    EMPNAME VARCHAR(255)
);

-- Create the ASSIGNED Table
CREATE TABLE ASSIGNED (
    PNO VARCHAR(10),
    EMPNO INT,
    PRIMARY KEY (PNO, EMPNO),
    FOREIGN KEY (PNO) REFERENCES PROJECT(PNO) ON DELETE CASCADE,
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO) ON DELETE CASCADE
);

-- Insert sample data into PROJECT Table
INSERT INTO PROJECT (PNO, PNAME, CHIEF) VALUES
('pr001', 'HRMS', 'John Doe'),
('pr002', 'DBMS', 'Jane Smith'),
('pr003', 'CRM', 'Alice Johnson');

-- Insert sample data into EMPLOYEE Table
INSERT INTO EMPLOYEE (EMPNO, EMPNAME) VALUES
(1001, 'Michael'),
(1002, 'Sarah'),
(1003, 'David'),
(1004, 'Emma');

-- Insert sample data into ASSIGNED Table
INSERT INTO ASSIGNED (PNO, EMPNO) VALUES
('pr001', 1001),
('pr002', 1002),
('pr003', 1003),
('pr002', 1004);

-- Queries

-- A. Get count of employees working on each project
SELECT PNO, COUNT(EMPNO) AS Employee_Count
FROM ASSIGNED
GROUP BY PNO;

-- B. Get details of employees working on project 'pr002'
SELECT e.EMPNO, e.EMPNAME
FROM EMPLOYEE e
JOIN ASSIGNED a ON e.EMPNO = a.EMPNO
WHERE a.PNO = 'pr002';

-- C. Get details of employees working on project 'DBMS'
SELECT e.EMPNO, e.EMPNAME
FROM EMPLOYEE e
JOIN ASSIGNED a ON e.EMPNO = a.EMPNO
JOIN PROJECT p ON a.PNO = p.PNO
WHERE p.PNAME = 'DBMS';

-- D. Write a trigger to delete all corresponding records from the ASSIGNED table if employee id is deleted
DELIMITER //
CREATE TRIGGER Delete_Assigned_Records
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DELETE FROM ASSIGNED WHERE EMPNO = OLD.EMPNO;
END //
DELIMITER ;

-- E. Write a trigger to keep a backup of ASSIGNED table records if a project is deleted
DELIMITER //
CREATE TRIGGER Backup_Assigned_Records
AFTER DELETE ON PROJECT
FOR EACH ROW
BEGIN
    INSERT INTO ASSIGNED_BACKUP (PNO, EMPNO) SELECT PNO, EMPNO FROM ASSIGNED WHERE PNO = OLD.PNO;
END //
DELIMITER ;

-- F. Get all employees assigned to a given project number
-- Replace 'pr002' with any project number to get the assigned employees for that project
SELECT e.EMPNO, e.EMPNAME
FROM EMPLOYEE e
JOIN ASSIGNED a ON e.EMPNO = a.EMPNO
WHERE a.PNO = 'pr002';
