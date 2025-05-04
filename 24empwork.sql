-- Consider the following relational schema. An employee can work in more than one department.
-- Emp(eid: integer, ename: string, salary: real)
-- Works(eid: integer, did: integer)
-- Dept(did: integer, dname: string, managerid: integer, floornum: integer)
-- Write the following Queries:
-- 1.
-- Print the names of all employees who work on the 10th floor and make less than Rs. 50,000.
-- 2.
-- Print the names of all managers who manage three or more departments on the same floor.
-- 3.
-- Write a procedure to Give every employee who works in the toy department a 10 percent raise.
-- 4.
-- Print the names and salaries of employees who work in both the toy department and the Music department.
-- 5.
-- Print the names of employees who earn a salary that is either less than Rs. 10,000 or more than Rs. 100,000.
-- 6.
-- Print all of the attributes for employees who work in some department that employee Abhishek also works in.
-- 7.
-- Write a Procedure to Print the names of all employees who work on the floor(s) where Amar Arora works.

-- Create the Emp Table
CREATE TABLE Emp (
    eid INTEGER PRIMARY KEY,
    ename VARCHAR(100),
    salary REAL
);

-- Create the Dept Table
CREATE TABLE Dept (
    did INTEGER PRIMARY KEY,
    dname VARCHAR(100),
    managerid INTEGER,
    floornum INTEGER,
    FOREIGN KEY (managerid) REFERENCES Emp(eid)
);

-- Create the Works Table
CREATE TABLE Works (
    eid INTEGER,
    did INTEGER,
    PRIMARY KEY (eid, did),
    FOREIGN KEY (eid) REFERENCES Emp(eid),
    FOREIGN KEY (did) REFERENCES Dept(did)
);

-- Sample Data Insertion into Emp table
INSERT INTO Emp (eid, ename, salary) VALUES
(1, 'Abhishek', 35000),
(2, 'Amar Arora', 55000),
(3, 'Ravi Kumar', 80000),
(4, 'John Doe', 15000),
(5, 'Alice Smith', 45000),
(6, 'Bob White', 60000);

-- Sample Data Insertion into Dept table
INSERT INTO Dept (did, dname, managerid, floornum) VALUES
(1, 'Toy', 2, 10),
(2, 'Music', 3, 10),
(3, 'HR', 4, 5),
(4, 'Sales', 5, 3),
(5, 'IT', 6, 10);

-- Sample Data Insertion into Works table
INSERT INTO Works (eid, did) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5);

-- 1. Query: Print the names of all employees who work on the 10th floor and make less than Rs. 50,000.
SELECT e.ename
FROM Emp e
JOIN Works w ON e.eid = w.eid
JOIN Dept d ON w.did = d.did
WHERE d.floornum = 10 AND e.salary < 50000;

-- 2. Query: Print the names of all managers who manage three or more departments on the same floor.
SELECT e.ename
FROM Emp e
JOIN Dept d ON e.eid = d.managerid
GROUP BY e.eid, e.ename, d.floornum
HAVING COUNT(d.did) >= 3;

-- 3. Procedure: Give every employee who works in the Toy department a 10 percent raise
DELIMITER $$

CREATE PROCEDURE RaiseToyDeptEmployees()
BEGIN
    UPDATE Emp e
    JOIN Works w ON e.eid = w.eid
    JOIN Dept d ON w.did = d.did
    SET e.salary = e.salary * 1.10
    WHERE d.dname = 'Toy';
END $$

DELIMITER ;

-- To execute the procedure:
-- CALL RaiseToyDeptEmployees();

-- 4. Query: Print the names and salaries of employees who work in both the Toy department and the Music department.
SELECT e.ename, e.salary
FROM Emp e
JOIN Works w1 ON e.eid = w1.eid
JOIN Dept d1 ON w1.did = d1.did
JOIN Works w2 ON e.eid = w2.eid
JOIN Dept d2 ON w2.did = d2.did
WHERE d1.dname = 'Toy' AND d2.dname = 'Music';

-- 5. Query: Print the names of employees who earn a salary that is either less than Rs. 10,000 or more than Rs. 100,000.
SELECT e.ename
FROM Emp e
WHERE e.salary < 10000 OR e.salary > 100000;

-- 6. Query: Print all of the attributes for employees who work in some department that employee Abhishek also works in.
SELECT e.*
FROM Emp e
WHERE EXISTS (
    SELECT 1
    FROM Works w
    JOIN Dept d ON w.did = d.did
    WHERE w.eid = 1  -- Abhishek's eid
    AND w.did = e.eid
);

-- 7. Procedure: Print the names of all employees who work on the floor(s) where Amar Arora works.
DELIMITER $$

CREATE PROCEDURE EmployeesOnAmarFloor()
BEGIN
    DECLARE amar_floor INT;
    
    -- Get the floor number where Amar Arora works
    SELECT d.floornum INTO amar_floor
    FROM Dept d
    JOIN Works w ON d.did = w.did
    WHERE w.eid = (SELECT eid FROM Emp WHERE ename = 'Amar Arora');
    
    -- Print the names of employees working on Amar's floor
    SELECT e.ename
    FROM Emp e
    JOIN Works w ON e.eid = w.eid
    JOIN Dept d ON w.did = d.did
    WHERE d.floornum = amar_floor;
END $$

DELIMITER ;

-- To execute the procedure:
-- CALL EmployeesOnAmarFloor();

-- Use CALL RaiseToyDeptEmployees(); to give a 10% raise to employees in the "Toy" department.

-- Use CALL EmployeesOnAmarFloor(); to list employees working on the same floor as "Amar Arora".