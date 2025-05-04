-- Employees (Employee_id,first_name , last_name , email, ph_no , hire_date, Job_id ,Salary, department_id )
-- Works(Employee_id,manager_id)
-- Departments (Department_id,dept_name , location_id)
-- Locations (Location_id , street, city, state , country)
-- Jobs (Job_id, job_title ,min_salary , max_salary)
-- Job_history(Employee_id , hire_date, leaving_date, salary, job_id, department_id)
-- 1] Display all the employees in descending order of their salary.
-- 2] Display employee_id, full name and salary of all employees who have joined in year 2006 according to their seniority.
-- 3] List name of all departments in location 20,30 and 50
-- 4] Display the full name of all employees whose first_name or last_name contains ‘a’.
-- 5] Write a procedure that accepts deptno value from a user, selects the maximum salary and minimum salary paid in the department, from the EMP table
-- 6] Keep track of old and new salary of employee.

-- Drop tables if they already exist (for testing)
DROP TABLE IF EXISTS Job_history;
DROP TABLE IF EXISTS Works;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Jobs;
DROP TABLE IF EXISTS Salary_Audit;

-- Create Locations Table
CREATE TABLE Locations (
    Location_id INT PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Create Departments Table
CREATE TABLE Departments (
    Department_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Locations(Location_id)
);

-- Create Jobs Table
CREATE TABLE Jobs (
    Job_id VARCHAR(10) PRIMARY KEY,
    job_title VARCHAR(100),
    min_salary INT,
    max_salary INT
);

-- Create Employees Table
CREATE TABLE Employees (
    Employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    ph_no VARCHAR(20),
    hire_date DATE,
    Job_id VARCHAR(10),
    Salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (Job_id) REFERENCES Jobs(Job_id),
    FOREIGN KEY (department_id) REFERENCES Departments(Department_id)
);

-- Create Works Table
CREATE TABLE Works (
    Employee_id INT,
    manager_id INT,
    PRIMARY KEY (Employee_id, manager_id),
    FOREIGN KEY (Employee_id) REFERENCES Employees(Employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employees(Employee_id)
);

-- Create Job_history Table
CREATE TABLE Job_history (
    Employee_id INT,
    hire_date DATE,
    leaving_date DATE,
    salary DECIMAL(10,2),
    job_id VARCHAR(10),
    department_id INT,
    FOREIGN KEY (Employee_id) REFERENCES Employees(Employee_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(Job_id),
    FOREIGN KEY (department_id) REFERENCES Departments(Department_id)
);

-- Salary_Audit table to track salary changes
CREATE TABLE Salary_Audit (
    Employee_id INT,
    Old_Salary DECIMAL(10,2),
    New_Salary DECIMAL(10,2),
    Changed_On TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO Locations VALUES
(10, 'Street A', 'CityX', 'StateX', 'CountryX'),
(20, 'Street B', 'CityY', 'StateY', 'CountryY'),
(30, 'Street C', 'CityZ', 'StateZ', 'CountryZ'),
(50, 'Street D', 'CityW', 'StateW', 'CountryW');

INSERT INTO Departments VALUES
(1, 'HR', 20),
(2, 'Finance', 30),
(3, 'IT', 50);

INSERT INTO Jobs VALUES
('J1', 'Manager', 5000, 15000),
('J2', 'Developer', 3000, 10000),
('J3', 'Clerk', 2000, 6000);

INSERT INTO Employees VALUES
(101, 'Alice', 'Smith', 'alice@example.com', '1234567890', '2006-01-10', 'J1', 12000, 1),
(102, 'Bob', 'Adams', 'bob@example.com', '2345678901', '2006-04-15', 'J2', 8000, 2),
(103, 'Carol', 'Brown', 'carol@example.com', '3456789012', '2007-05-20', 'J3', 4000, 3),
(104, 'David', 'Allen', 'david@example.com', '4567890123', '2006-12-01', 'J2', 9500, 1);

INSERT INTO Works VALUES
(101, 101),
(102, 101),
(103, 102),
(104, 101);

-- Queries

-- 1. Display all the employees in descending order of their salary.
SELECT * FROM Employees ORDER BY Salary DESC;

-- 2. Employee_id, full name, salary who joined in 2006 sorted by seniority (hire_date ascending)
SELECT Employee_id, CONCAT(first_name, ' ', last_name) AS full_name, Salary
FROM Employees
WHERE YEAR(hire_date) = 2006
ORDER BY hire_date;

-- 3. Names of departments in location 20, 30, and 50
SELECT dept_name
FROM Departments
WHERE location_id IN (20, 30, 50);

-- 4. Full names of employees whose first_name or last_name contains ‘a’
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM Employees
WHERE first_name LIKE '%a%' OR last_name LIKE '%a%';

-- 5. Procedure to get max/min salary in a given department
DELIMITER //

CREATE PROCEDURE GetSalaryRange(IN deptno INT)
BEGIN
    SELECT MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary
    FROM Employees
    WHERE department_id = deptno;
END;
//

DELIMITER ;

-- Example call:
-- CALL GetSalaryRange(1);

-- 6. Trigger to track old and new salary of employee
DELIMITER //

CREATE TRIGGER Salary_Update_Audit
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO Salary_Audit (Employee_id, Old_Salary, New_Salary)
        VALUES (OLD.Employee_id, OLD.Salary, NEW.Salary);
    END IF;
END;
//

DELIMITER ;

-- To test salary update and audit:
-- UPDATE Employees SET Salary = 8500 WHERE Employee_id = 102;
-- SELECT * FROM Salary_Audit;
CALL GetSalaryRange(dept_id);