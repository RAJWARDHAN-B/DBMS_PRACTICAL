-- Create following tables in mysql
-- Emp(eno, ename, sal, contact_no, addr, dno)
-- project(pno, pname)
-- dept(dno, dname, loc)
-- assigned_to(eno, pno)
-- Write the SQL queries:
-- 14.
-- Gather details of employees working on project 353 and 354.
-- 15.
-- Obtains the details of employees working on the database project.
-- 16.
-- Find the employee nos of employees who work on at least one project that employee 107 works on.
-- 17.
-- Find the employee no of employees who work on all of the projects that employee 107 works on.
-- 18.
-- Find the project with minimum no of employees.
-- 19.
-- Create view to store pno, pname and no of employees working on the project.
-- 20.
-- Write a procedure to display details of the employees working on particular project. Use cursor.

-- DROP existing tables for safe re-run
DROP TABLE IF EXISTS assigned_to;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS dept;

-- CREATE dept table
CREATE TABLE dept (
    dno INT PRIMARY KEY,
    dname VARCHAR(100),
    loc VARCHAR(100)
);

-- CREATE emp table
CREATE TABLE emp (
    eno INT PRIMARY KEY,
    ename VARCHAR(100),
    sal DECIMAL(10,2),
    contact_no VARCHAR(15),
    addr VARCHAR(255),
    dno INT,
    FOREIGN KEY (dno) REFERENCES dept(dno)
);

-- CREATE project table
CREATE TABLE project (
    pno INT PRIMARY KEY,
    pname VARCHAR(100)
);

-- CREATE assigned_to table
CREATE TABLE assigned_to (
    eno INT,
    pno INT,
    PRIMARY KEY (eno, pno),
    FOREIGN KEY (eno) REFERENCES emp(eno),
    FOREIGN KEY (pno) REFERENCES project(pno)
);

-- INSERT dept data
INSERT INTO dept VALUES
(1, 'IT', 'Pune'),
(2, 'HR', 'Delhi');

-- INSERT emp data
INSERT INTO emp VALUES
(101, 'Alice', 50000, '9876543210', 'Pune', 1),
(102, 'Bob', 60000, '9876543211', 'Delhi', 2),
(103, 'Charlie', 55000, '9876543212', 'Pune', 1),
(104, 'David', 58000, '9876543213', 'Delhi', 2),
(107, 'Eve', 61000, '9876543214', 'Chennai', 1);

-- INSERT project data
INSERT INTO project VALUES
(353, 'AI Project'),
(354, 'Web Project'),
(355, 'Database Project'),
(356, 'Cloud Project');

-- INSERT assigned_to data
INSERT INTO assigned_to VALUES
(101, 353),
(102, 354),
(103, 355),
(107, 353),
(107, 355),
(104, 353),
(104, 354),
(103, 356);

-- 14. Employees working on project 353 and 354
SELECT e.*
FROM emp e
JOIN assigned_to a ON e.eno = a.eno
WHERE a.pno IN (353, 354);

-- 15. Employees working on 'Database Project'
SELECT e.*
FROM emp e
JOIN assigned_to a ON e.eno = a.eno
JOIN project p ON a.pno = p.pno
WHERE p.pname = 'Database Project';

-- 16. Employees working on at least one project that emp 107 works on
SELECT DISTINCT a2.eno
FROM assigned_to a1
JOIN assigned_to a2 ON a1.pno = a2.pno
WHERE a1.eno = 107 AND a2.eno != 107;

-- 17. Employees who work on all projects that emp 107 works on
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

-- 18. Project with minimum number of employees
SELECT p.pno, p.pname, COUNT(a.eno) AS emp_count
FROM project p
LEFT JOIN assigned_to a ON p.pno = a.pno
GROUP BY p.pno
ORDER BY emp_count ASC
LIMIT 1;

-- 19. Create view: project_summary
CREATE OR REPLACE VIEW project_summary AS
SELECT p.pno, p.pname, COUNT(a.eno) AS emp_count
FROM project p
LEFT JOIN assigned_to a ON p.pno = a.pno
GROUP BY p.pno, p.pname;

-- 20. Stored Procedure using cursor
DELIMITER //

CREATE PROCEDURE ShowEmployeesOnProject(IN proj_no INT)
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

    read_loop: LOOP
        FETCH emp_cursor INTO v_eno, v_ename, v_sal, v_contact, v_addr;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT v_eno AS Emp_No, v_ename AS Name, v_sal AS Salary, v_contact AS Contact, v_addr AS Address;
    END LOOP;

    CLOSE emp_cursor;
END;
//

DELIMITER ;

-- Example call to test the procedure
-- CALL ShowEmployeesOnProject(353);
