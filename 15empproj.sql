-- Create following tables in mysql
-- Emp(eno, ename, sal, contact_no, addr, dno)
-- project(pno, pname)
-- dept(dno, dname, loc)
-- assigned_to(eno, pno)
-- Write the SQL queries:
-- 8.
-- Gather details of employees working on project 353 and 354.
-- 9.
-- Obtains the details of employees working on the database project.
-- 10.
-- Find the employee nos of employees who work on at least one project that employee 107 works on.
-- 11.
-- Find the employee no of employees who work on all of the projects that employee 107 works on.
-- 12.
-- Find the project with minimum no of employees.
-- 13.
-- Create view to store pno, pname and no of employees working on the project.
-- Write a procedure to display details of the employees working on particular project. Use cursor.

-- Drop if exists (for re-run safety)
DROP TABLE IF EXISTS assigned_to;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS dept;

-- Create dept table
CREATE TABLE dept (
    dno INT PRIMARY KEY,
    dname VARCHAR(100),
    loc VARCHAR(100)
);

-- Create emp table
CREATE TABLE emp (
    eno INT PRIMARY KEY,
    ename VARCHAR(100),
    sal DECIMAL(10,2),
    contact_no VARCHAR(15),
    addr VARCHAR(255),
    dno INT,
    FOREIGN KEY (dno) REFERENCES dept(dno)
);

-- Create project table
CREATE TABLE project (
    pno INT PRIMARY KEY,
    pname VARCHAR(100)
);

-- Create assigned_to table
CREATE TABLE assigned_to (
    eno INT,
    pno INT,
    PRIMARY KEY (eno, pno),
    FOREIGN KEY (eno) REFERENCES emp(eno),
    FOREIGN KEY (pno) REFERENCES project(pno)
);

-- Sample data for dept
INSERT INTO dept VALUES
(1, 'IT', 'Pune'),
(2, 'HR', 'Delhi');

-- Sample data for emp
INSERT INTO emp VALUES
(101, 'Alice', 50000, '1234567890', 'Pune', 1),
(102, 'Bob', 60000, '2345678901', 'Delhi', 2),
(103, 'Charlie', 55000, '3456789012', 'Pune', 1),
(104, 'David', 58000, '4567890123', 'Delhi', 2),
(107, 'Eve', 61000, '5678901234', 'Chennai', 1);

-- Sample data for project
INSERT INTO project VALUES
(353, 'AI Project'),
(354, 'Web Project'),
(355, 'Database Project'),
(356, 'Cloud Project');

-- Sample data for assigned_to
INSERT INTO assigned_to VALUES
(101, 353),
(102, 354),
(103, 355),
(107, 353),
(107, 355),
(104, 353),
(104, 354),
(103, 356);

-- 8. Employees working on project 353 and 354
SELECT DISTINCT e.*
FROM emp e
JOIN assigned_to a ON e.eno = a.eno
WHERE a.pno IN (353, 354);

-- 9. Employees working on the 'Database Project'
SELECT e.*
FROM emp e
JOIN assigned_to a ON e.eno = a.eno
JOIN project p ON a.pno = p.pno
WHERE p.pname = 'Database Project';

-- 10. Employee nos working on at least one project that employee 107 works on
SELECT DISTINCT a2.eno
FROM assigned_to a1
JOIN assigned_to a2 ON a1.pno = a2.pno
WHERE a1.eno = 107 AND a2.eno != 107;

-- 11. Employee nos working on all of the projects employee 107 works on
SELECT e.eno
FROM emp e
WHERE NOT EXISTS (
    SELECT pno
    FROM assigned_to
    WHERE eno = 107
    AND pno NOT IN (
        SELECT pno FROM assigned_to WHERE eno = e.eno
    )
)
AND e.eno != 107;

-- 12. Project with minimum number of employees
SELECT p.pno, p.pname, COUNT(a.eno) AS emp_count
FROM project p
LEFT JOIN assigned_to a ON p.pno = a.pno
GROUP BY p.pno, p.pname
ORDER BY emp_count ASC
LIMIT 1;

-- 13. View: pno, pname, number of employees per project
CREATE OR REPLACE VIEW project_summary AS
SELECT p.pno, p.pname, COUNT(a.eno) AS emp_count
FROM project p
LEFT JOIN assigned_to a ON p.pno = a.pno
GROUP BY p.pno, p.pname;

-- Stored Procedure: Show employee details for a given project using cursor
DELIMITER //

CREATE PROCEDURE ShowEmpByProject(IN proj_no INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_eno INT;
    DECLARE v_ename VARCHAR(100);
    DECLARE v_sal DECIMAL(10,2);
    DECLARE v_contact VARCHAR(15);
    DECLARE v_addr VARCHAR(255);

    DECLARE emp_cursor CURSOR FOR
        SELECT e.eno, e.ename, e.sal, e.contact_no, e.addr
        FROM emp e
        JOIN assigned_to a ON e.eno = a.eno
        WHERE a.pno = proj_no;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN emp_cursor;

    emp_loop: LOOP
        FETCH emp_cursor INTO v_eno, v_ename, v_sal, v_contact, v_addr;
        IF done THEN
            LEAVE emp_loop;
        END IF;
        SELECT v_eno AS Eno, v_ename AS Name, v_sal AS Salary, v_contact AS Contact, v_addr AS Address;
    END LOOP;

    CLOSE emp_cursor;
END;
//

DELIMITER ;

-- To call the procedure:
-- CALL ShowEmpByProject(353);
