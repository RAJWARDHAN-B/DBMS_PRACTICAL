-- Consider the relational database
-- Employee (person-name, street, city)
-- works (person-name, company-name, salary)
-- Company (company-name, city)
-- Manages (person-name, manager-name)
-- Consider the above relational database.
-- Write SQL queries for the following:
-- 1.
-- Find the names, street address, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000 per annum.
-- 2.
-- Find the names of all employees in this database who live in the same city as the company for which they work.
-- 3.
-- Find the names of all employees who live in the same city and on the same street as do their managers.
-- 4.
-- Write a Trigger on update of employee company_name

-- Drop tables if they already exist
DROP TABLE IF EXISTS Manages;
DROP TABLE IF EXISTS Works;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS Employee;

-- Create Employee table
CREATE TABLE Employee (
    person_name VARCHAR(100) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(100)
);

-- Create Company table
CREATE TABLE Company (
    company_name VARCHAR(100) PRIMARY KEY,
    city VARCHAR(100)
);

-- Create Works table
CREATE TABLE Works (
    person_name VARCHAR(100),
    company_name VARCHAR(100),
    salary DECIMAL(10,2),
    PRIMARY KEY (person_name, company_name),
    FOREIGN KEY (person_name) REFERENCES Employee(person_name),
    FOREIGN KEY (company_name) REFERENCES Company(company_name)
);

-- Create Manages table
CREATE TABLE Manages (
    person_name VARCHAR(100),
    manager_name VARCHAR(100),
    PRIMARY KEY (person_name),
    FOREIGN KEY (person_name) REFERENCES Employee(person_name),
    FOREIGN KEY (manager_name) REFERENCES Employee(person_name)
);

-- Insert sample data into Company
INSERT INTO Company VALUES
('First Bank Corporation', 'New York'),
('TechSoft', 'San Francisco'),
('DesignHub', 'Chicago');

-- Insert sample data into Employee
INSERT INTO Employee VALUES
('Alice', 'Main St', 'New York'),
('Bob', 'Market St', 'San Francisco'),
('Charlie', 'Lakeview', 'Chicago'),
('David', 'Main St', 'New York'),
('Eve', 'Lakeview', 'Chicago');

-- Insert sample data into Works
INSERT INTO Works VALUES
('Alice', 'First Bank Corporation', 12000),
('Bob', 'TechSoft', 9000),
('Charlie', 'DesignHub', 11000),
('David', 'First Bank Corporation', 8000),
('Eve', 'DesignHub', 9500);

-- Insert sample data into Manages
INSERT INTO Manages VALUES
('Bob', 'Charlie'),
('Alice', 'David'),
('Eve', 'Charlie');

-- 1. Employees working for First Bank Corporation earning > $10,000
SELECT E.person_name, E.street, E.city
FROM Employee E
JOIN Works W ON E.person_name = W.person_name
WHERE W.company_name = 'First Bank Corporation' AND W.salary > 10000;

-- 2. Employees living in the same city as their company
SELECT E.person_name
FROM Employee E
JOIN Works W ON E.person_name = W.person_name
JOIN Company C ON W.company_name = C.company_name
WHERE E.city = C.city;

-- 3. Employees who live in same city and street as their manager
SELECT E.person_name
FROM Employee E
JOIN Manages M ON E.person_name = M.person_name
JOIN Employee MGR ON M.manager_name = MGR.person_name
WHERE E.city = MGR.city AND E.street = MGR.street;

-- 4. Trigger to track update of company name in Works table
DELIMITER //

CREATE TRIGGER log_company_change
BEFORE UPDATE ON Works
FOR EACH ROW
BEGIN
    IF NEW.company_name <> OLD.company_name THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company name update is not allowed directly.';
    END IF;
END;
//

DELIMITER ;
