-- Book = { Book_No ,Book_Name, Author_name , Cost, Category}
-- Member = { M_Id , M_Name ,Mship_type, Fees_paid,Max_Books_Allowed, Penalty_Amount }
-- Issue ={Lib_Issue_Id , Book_No , M_Id, Issue_Date, Return_date}
-- •
-- List top 5 books which are issued by Annual members
-- •
-- List the names of members who has issued the books whose cost is more than 300 rupees and whose author is “Scott Urman”
-- •
-- Write a query to display number of booked in each category of books issued by all member types.
-- •
-- Write a trigger make book_name and author name in uppercase
-- •
-- Write a trigger prompt a message if max_books_Allowed value is greater than 3.

-- Drop tables if they already exist
DROP TABLE IF EXISTS Issue;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Book;

-- Create Book Table
CREATE TABLE Book (
    Book_No INT PRIMARY KEY,
    Book_Name VARCHAR(255),
    Author_name VARCHAR(255),
    Cost DECIMAL(10, 2),
    Category VARCHAR(100)
);

-- Create Member Table
CREATE TABLE Member (
    M_Id INT PRIMARY KEY,
    M_Name VARCHAR(255),
    Mship_type VARCHAR(50),
    Fees_paid DECIMAL(10, 2),
    Max_Books_Allowed INT,
    Penalty_Amount DECIMAL(10, 2)
);

-- Create Issue Table
CREATE TABLE Issue (
    Lib_Issue_Id INT PRIMARY KEY,
    Book_No INT,
    M_Id INT,
    Issue_Date DATE,
    Return_date DATE,
    FOREIGN KEY (Book_No) REFERENCES Book(Book_No),
    FOREIGN KEY (M_Id) REFERENCES Member(M_Id)
);

-- Insert Sample Data into Book Table
INSERT INTO Book (Book_No, Book_Name, Author_name, Cost, Category) VALUES
(1, 'Book A', 'Scott Urman', 350, 'Fiction'),
(2, 'Book B', 'John Doe', 150, 'Science'),
(3, 'Book C', 'Scott Urman', 500, 'Fiction'),
(4, 'Book D', 'Jane Smith', 100, 'Biography'),
(5, 'Book E', 'Scott Urman', 600, 'History');

-- Insert Sample Data into Member Table
INSERT INTO Member (M_Id, M_Name, Mship_type, Fees_paid, Max_Books_Allowed, Penalty_Amount) VALUES
(1, 'Alice', 'Annual', 1200, 5, 50),
(2, 'Bob', 'Monthly', 100, 2, 20),
(3, 'Charlie', 'Annual', 1200, 3, 30),
(4, 'Diana', 'Annual', 1200, 6, 40),
(5, 'Ethan', 'Monthly', 150, 2, 10);

-- Insert Sample Data into Issue Table
INSERT INTO Issue (Lib_Issue_Id, Book_No, M_Id, Issue_Date, Return_date) VALUES
(1, 1, 1, '2025-05-01', '2025-05-10'),
(2, 2, 2, '2025-05-02', '2025-05-12'),
(3, 3, 3, '2025-05-03', '2025-05-13'),
(4, 4, 4, '2025-05-04', '2025-05-14'),
(5, 5, 1, '2025-05-05', '2025-05-15');

-- Queries

-- 1) List top 5 books which are issued by Annual members
SELECT b.Book_Name, COUNT(i.Lib_Issue_Id) AS Issue_Count
FROM Book b
JOIN Issue i ON b.Book_No = i.Book_No
JOIN Member m ON i.M_Id = m.M_Id
WHERE m.Mship_type = 'Annual'
GROUP BY b.Book_Name
ORDER BY Issue_Count DESC
LIMIT 5;

-- 2) List the names of members who have issued books whose cost is more than 300 rupees and whose author is "Scott Urman"
SELECT DISTINCT m.M_Name
FROM Member m
JOIN Issue i ON m.M_Id = i.M_Id
JOIN Book b ON i.Book_No = b.Book_No
WHERE b.Cost > 300 AND b.Author_name = 'Scott Urman';

-- 3) Write a query to display number of books in each category issued by all member types
SELECT b.Category, m.Mship_type, COUNT(i.Lib_Issue_Id) AS Books_Issued
FROM Book b
JOIN Issue i ON b.Book_No = i.Book_No
JOIN Member m ON i.M_Id = m.M_Id
GROUP BY b.Category, m.Mship_type;

-- Triggers

-- 4) Trigger to make book_name and author name in uppercase
DELIMITER //

CREATE TRIGGER uppercase_book_details
BEFORE INSERT ON Book
FOR EACH ROW
BEGIN
    SET NEW.Book_Name = UPPER(NEW.Book_Name);
    SET NEW.Author_name = UPPER(NEW.Author_name);
END //

DELIMITER ;

-- 5) Trigger to prompt a message if max_books_allowed value is greater than 3
DELIMITER //

CREATE TRIGGER check_max_books
BEFORE INSERT ON Member
FOR EACH ROW
BEGIN
    IF NEW.Max_Books_Allowed > 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Warning: Max Books Allowed for this member type should not exceed 3.';
    END IF;
END //

DELIMITER ;

