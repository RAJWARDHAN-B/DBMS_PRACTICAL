-- Design the MySQL Database Schema for Student Library scenario
-- Student(Stud_no : integer,Stud_name: string)
-- Membership(Mem_no: integer,Stud_no: integer)
-- Book(book_no: integer, book_name:string, author: string)
-- Iss_rec(iss_no:integer, iss_date: date, Mem_no: integer, book_no: integer)
-- For the above schema, perform the following—
-- a)
-- Create the tables with the appropriate integrity constraints
-- b)
-- Insert around 10 records in each of the tables
-- c)
-- List all the student names with their membership numbers
-- d)
-- List all the issues for the current date with student and Book names
-- e)
-- List the details of students who borrowed book whose author is CJDATE
-- f)
-- Create a view which lists out the iss_no, iss _date, stud_name, book name

-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS Iss_rec;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Student;

-- 1. Create Tables with Appropriate Integrity Constraints

CREATE TABLE Student (
    Stud_no INT PRIMARY KEY,
    Stud_name VARCHAR(100)
);

CREATE TABLE Membership (
    Mem_no INT PRIMARY KEY,
    Stud_no INT,
    FOREIGN KEY (Stud_no) REFERENCES Student(Stud_no)
);

CREATE TABLE Book (
    book_no INT PRIMARY KEY,
    book_name VARCHAR(100),
    author VARCHAR(100)
);

CREATE TABLE Iss_rec (
    iss_no INT PRIMARY KEY,
    iss_date DATE,
    Mem_no INT,
    book_no INT,
    FOREIGN KEY (Mem_no) REFERENCES Membership(Mem_no),
    FOREIGN KEY (book_no) REFERENCES Book(book_no)
);

-- 2. Insert Sample Data into Tables

INSERT INTO Student (Stud_no, Stud_name) VALUES
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

INSERT INTO Membership (Mem_no, Stud_no) VALUES
(101, 1),
(102, 2),
(103, 3),
(104, 4),
(105, 5),
(106, 6),
(107, 7),
(108, 8),
(109, 9),
(110, 10);

INSERT INTO Book (book_no, book_name, author) VALUES
(201, 'Introduction to MySQL', 'John Smith'),
(202, 'Advanced SQL', 'CJDATE'),
(203, 'Database Concepts', 'Sarah Lee'),
(204, 'Web Development Basics', 'James Brown'),
(205, 'Computer Networks', 'Alice Green'),
(206, 'Data Structures', 'CJDATE'),
(207, 'Machine Learning', 'Robert Fox'),
(208, 'Java Programming', 'Mary White'),
(209, 'Python for Beginners', 'CJDATE'),
(210, 'Operating Systems', 'Paul Black');

INSERT INTO Iss_rec (iss_no, iss_date, Mem_no, book_no) VALUES
(301, '2025-05-04', 101, 201),
(302, '2025-05-04', 102, 202),
(303, '2025-05-03', 103, 203),
(304, '2025-05-04', 104, 204),
(305, '2025-05-04', 105, 205),
(306, '2025-05-04', 106, 206),
(307, '2025-05-03', 107, 207),
(308, '2025-05-04', 108, 208),
(309, '2025-05-04', 109, 209),
(310, '2025-05-02', 110, 210);

-- 3. Queries

-- c) List all the student names with their membership numbers
SELECT s.Stud_name, m.Mem_no
FROM Student s
JOIN Membership m ON s.Stud_no = m.Stud_no;

-- d) List all the issues for the current date with student and book names
SELECT i.iss_no, i.iss_date, s.Stud_name, b.book_name
FROM Iss_rec i
JOIN Student s ON i.Mem_no = s.Stud_no
JOIN Book b ON i.book_no = b.book_no
WHERE i.iss_date = CURDATE();

-- e) List the details of students who borrowed books whose author is 'CJDATE'
SELECT DISTINCT s.Stud_name, b.book_name, b.author
FROM Iss_rec i
JOIN Student s ON i.Mem_no = s.Stud_no
JOIN Book b ON i.book_no = b.book_no
WHERE b.author = 'CJDATE';

-- f) Create a view which lists out the iss_no, iss_date, stud_name, book_name
CREATE OR REPLACE VIEW IssuedBooks AS
SELECT i.iss_no, i.iss_date, s.Stud_name, b.book_name
FROM Iss_rec i
JOIN Student s ON i.Mem_no = s.Stud_no
JOIN Book b ON i.book_no = b.book_no;

-- To query the view:
SELECT * FROM IssuedBooks;

