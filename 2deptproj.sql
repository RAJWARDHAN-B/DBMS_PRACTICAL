-- Design the MySQL Database with following entities,
-- dept (dept-no, dname, LOC)
-- emp (emp-no, ename, designation,sal)
-- project (proj-no, proj-name, status)
-- dept and emp are related as 1 to many.
-- project and emp are related as 1 to many.
-- Write relational or sq1 expressions for the following :

-- DROP existing tables if needed (optional for development)
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS dept;

-- CREATE TABLES

CREATE TABLE dept (
    dept_no INT AUTO_INCREMENT PRIMARY KEY,
    dname VARCHAR(50),
    loc VARCHAR(50)
);

CREATE TABLE emp (
    emp_no INT AUTO_INCREMENT PRIMARY KEY,
    ename VARCHAR(50),
    designation VARCHAR(30),
    sal DECIMAL(10,2),
    dept_no INT,
    FOREIGN KEY (dept_no) REFERENCES dept(dept_no)
);

CREATE TABLE project (
    proj_no INT AUTO_INCREMENT PRIMARY KEY,
    proj_name VARCHAR(100),
    status VARCHAR(30),
    emp_no INT,
    FOREIGN KEY (emp_no) REFERENCES emp(emp_no)
);

-- INSERT DATA INTO dept
INSERT INTO dept (dname, loc) VALUES
('INVENTORY', 'PUNE'),
('MARKETING', 'DELHI'),
('SALES', 'MUMBAI');

-- INSERT DATA INTO emp
INSERT INTO emp (ename, designation, sal, dept_no) VALUES
('Alice', 'CLERK', 20000, 1),       -- INVENTORY
('Bob', 'MANAGER', 50000, 2),       -- MARKETING
('Charlie', 'EXECUTIVE', 30000, 2), -- MARKETING
('Diana', 'CLERK', 18000, 1),       -- INVENTORY
('Ethan', 'MANAGER', 55000, 3);     -- SALES

-- INSERT DATA INTO project
INSERT INTO project (proj_name, status, emp_no) VALUES
('Inventory Reorg', 'COMPLETE', 1),
('Blood Bank', 'INCOMPLETE', 2),
('Blood Bank', 'INCOMPLETE', 3),
('Sales Expansion', 'COMPLETE', 5),
('Warehouse Upgrade', 'INCOMPLETE', 4);

-- i) List all employees of ‘INVENTORY’ department of ‘PUNE’ location.
SELECT e.ename
FROM emp e
JOIN dept d ON e.dept_no = d.dept_no
WHERE d.dname = 'INVENTORY' AND d.loc = 'PUNE';

-- ii) Names of employees working on ‘Blood Bank’ project.
SELECT e.ename
FROM emp e
JOIN project p ON e.emp_no = p.emp_no
WHERE p.proj_name = 'Blood Bank';

-- iii) Name of managers from ‘MARKETING’ department.
SELECT e.ename
FROM emp e
JOIN dept d ON e.dept_no = d.dept_no
WHERE e.designation = 'MANAGER' AND d.dname = 'MARKETING';

-- iv) Employees working under status ‘INCOMPLETE’ projects.
SELECT DISTINCT e.ename
FROM emp e
JOIN project p ON e.emp_no = p.emp_no
WHERE p.status = 'INCOMPLETE';

-- v) Procedure to update salaries
DELIMITER //

CREATE PROCEDURE UpdateEmpSalaries()
BEGIN
    -- 20% increase for CLERK in dept 10 (adjusted to correct dept number if needed)
    UPDATE emp
    SET sal = sal * 1.20
    WHERE designation = 'CLERK' AND dept_no = 1;

    -- 5% increase for MANAGER in dept 20 (adjusted to correct dept number if needed)
    UPDATE emp
    SET sal = sal * 1.05
    WHERE designation = 'MANAGER' AND dept_no = 2;
END //

DELIMITER ;

-- Call the procedure
CALL UpdateEmpSalaries();

-- View updated salaries
SELECT emp_no, ename, designation, sal FROM emp;



