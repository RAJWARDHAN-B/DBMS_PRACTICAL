-- Design the MySQL Database Schema for a Employee-pay scenario
-- Employee(emp_id : integer,emp_name: string)
-- Department(dept_id: integer,dept_name:string)
-- Paydetails(emp_id : integer,dept_id: integer, basic: integer, deductions: integer,
-- additions: integer, DOJ: date)
-- Payroll(emp_id : integer, pay_date: date)
-- For the above schema, perform the following—
-- a)
-- List the employee details department wise
-- b)
-- List all the employee names who joined after particular date
-- c)
-- List the details of employees whose basic salary is between 10,000 and 20,000
-- d)
-- Give a count of how many employees are working in each department
-- e)
-- Give a names of the employees whose netsalary>10,000
-- f)
-- Write a procedure to List the pay details for all employee.

-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS Payroll;
DROP TABLE IF EXISTS Paydetails;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Employee;

-- 1. Create Tables with Appropriate Integrity Constraints

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100)
);

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE Paydetails (
    emp_id INT,
    dept_id INT,
    basic INT CHECK (basic >= 0),  -- Ensure basic salary is non-negative
    deductions INT CHECK (deductions >= 0),
    additions INT CHECK (additions >= 0),
    DOJ DATE,
    PRIMARY KEY (emp_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Payroll (
    emp_id INT,
    pay_date DATE,
    PRIMARY KEY (emp_id, pay_date),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

-- 2. Insert Sample Data into Tables

INSERT INTO Employee (emp_id, emp_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana'),
(5, 'Ethan'),
(6, 'Frank'),
(7, 'Grace'),
(8, 'Hannah'),
(9, 'Ivy'),
(10, 'Jack');

INSERT INTO Department (dept_id, dept_name) VALUES
(101, 'HR'),
(102, 'IT'),
(103, 'Finance'),
(104, 'Marketing'),
(105, 'Sales');

INSERT INTO Paydetails (emp_id, dept_id, basic, deductions, additions, DOJ) VALUES
(1, 101, 15000, 1000, 500, '2020-01-15'),
(2, 102, 25000, 2000, 1000, '2021-06-10'),
(3, 103, 12000, 800, 400, '2019-08-20'),
(4, 104, 18000, 1500, 700, '2021-03-25'),
(5, 105, 22000, 2000, 1500, '2018-11-05'),
(6, 102, 30000, 2500, 2000, '2017-05-17'),
(7, 101, 10000, 500, 300, '2022-08-12'),
(8, 105, 15000, 1000, 600, '2020-02-01'),
(9, 104, 22000, 1500, 1000, '2016-12-12'),
(10, 103, 18000, 1200, 800, '2019-09-30');

INSERT INTO Payroll (emp_id, pay_date) VALUES
(1, '2025-05-01'),
(2, '2025-05-01'),
(3, '2025-05-01'),
(4, '2025-05-01'),
(5, '2025-05-01'),
(6, '2025-05-01'),
(7, '2025-05-01'),
(8, '2025-05-01'),
(9, '2025-05-01'),
(10, '2025-05-01');

-- 3. Queries

-- a) List the employee details department wise
SELECT e.emp_name, d.dept_name, p.basic, p.deductions, p.additions, p.DOJ
FROM Employee e
JOIN Paydetails p ON e.emp_id = p.emp_id
JOIN Department d ON p.dept_id = d.dept_id
ORDER BY d.dept_name;

-- b) List all the employee names who joined after a particular date (e.g., '2020-01-01')
SELECT e.emp_name
FROM Employee e
JOIN Paydetails p ON e.emp_id = p.emp_id
WHERE p.DOJ > '2020-01-01';

-- c) List the details of employees whose basic salary is between 10,000 and 20,000
SELECT e.emp_name, p.basic, p.deductions, p.additions
FROM Employee e
JOIN Paydetails p ON e.emp_id = p.emp_id
WHERE p.basic BETWEEN 10000 AND 20000;

-- d) Give a count of how many employees are working in each department
SELECT d.dept_name, COUNT(e.emp_id) AS num_employees
FROM Department d
JOIN Paydetails p ON d.dept_id = p.dept_id
JOIN Employee e ON p.emp_id = e.emp_id
GROUP BY d.dept_name;

-- e) Give the names of the employees whose net salary > 10,000
-- Net salary = basic + additions - deductions
SELECT e.emp_name, (p.basic + p.additions - p.deductions) AS net_salary
FROM Employee e
JOIN Paydetails p ON e.emp_id = p.emp_id
HAVING net_salary > 10000;

-- f) Write a procedure to list the pay details for all employees
DELIMITER //

CREATE PROCEDURE ListPayDetails()
BEGIN
    SELECT e.emp_name, d.dept_name, p.basic, p.deductions, p.additions, (p.basic + p.additions - p.deductions) AS net_salary
    FROM Employee e
    JOIN Paydetails p ON e.emp_id = p.emp_id
    JOIN Department d ON p.dept_id = d.dept_id;
END //

DELIMITER ;

-- To execute the procedure:
-- CALL ListPayDetails();
