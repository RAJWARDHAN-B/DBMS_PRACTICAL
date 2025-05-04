-- Consider the following Relations.
-- Branch (B_No, B_name, B_city, asset),
-- Customer (C_No,C_Name, C_city street)
-- Loan (Loan_no, B_name, amount),
-- Borrower (C_No, Loan_No),
-- Write SQL query for the following:
-- 1) Find the names and address of customers who have a loan.
-- 2) Find loan data, ordered by decreasing amounts, then increasing loan numbers.
-- 3) Find the pairs of names of different customers who live at the same address but have loan at different
-- branches.
-- 4)Write a procedure that calculate total loan amount for a particular branch
-- 5) Write a trigger which keeps track of updated amount of loan .

-- Drop tables if they exist
DROP TABLE IF EXISTS Borrower;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Branch;

-- Create the Branch table
CREATE TABLE Branch (
    B_No INT PRIMARY KEY,
    B_name VARCHAR(50),
    B_city VARCHAR(50),
    asset DECIMAL(15, 2)
);

-- Create the Customer table
CREATE TABLE Customer (
    C_No INT PRIMARY KEY,
    C_Name VARCHAR(50),
    C_city VARCHAR(50),
    street VARCHAR(100)
);

-- Create the Loan table
CREATE TABLE Loan (
    Loan_no INT PRIMARY KEY,
    B_name VARCHAR(50),
    amount DECIMAL(15, 2),
    FOREIGN KEY (B_name) REFERENCES Branch(B_name)
);

-- Create the Borrower table (relationship between customer and loan)
CREATE TABLE Borrower (
    C_No INT,
    Loan_No INT,
    PRIMARY KEY (C_No, Loan_No),
    FOREIGN KEY (C_No) REFERENCES Customer(C_No),
    FOREIGN KEY (Loan_No) REFERENCES Loan(Loan_no)
);

-- Insert sample data into Branch
INSERT INTO Branch VALUES
(1, 'Branch1', 'New York', 1000000.00),
(2, 'Branch2', 'Los Angeles', 1500000.00),
(3, 'Branch3', 'Chicago', 500000.00);

-- Insert sample data into Customer
INSERT INTO Customer VALUES
(1, 'Alice', 'New York', '1st Ave'),
(2, 'Bob', 'Los Angeles', 'Broadway St'),
(3, 'Charlie', 'New York', '1st Ave'),
(4, 'David', 'Chicago', 'Lakeview Blvd'),
(5, 'Eve', 'New York', '5th Ave');

-- Insert sample data into Loan
INSERT INTO Loan VALUES
(1001, 'Branch1', 50000.00),
(1002, 'Branch2', 20000.00),
(1003, 'Branch1', 30000.00),
(1004, 'Branch3', 10000.00);

-- Insert sample data into Borrower
INSERT INTO Borrower VALUES
(1, 1001),
(2, 1002),
(3, 1003),
(4, 1004),
(5, 1001);

-- 1. Find the names and addresses of customers who have a loan.
SELECT C.C_Name, C.street, C.C_city
FROM Customer C
JOIN Borrower B ON C.C_No = B.C_No;

-- 2. Find loan data, ordered by decreasing amounts, then increasing loan numbers.
SELECT * FROM Loan
ORDER BY amount DESC, Loan_no ASC;

-- 3. Find the pairs of names of different customers who live at the same address but have loans at different branches.
SELECT C1.C_Name AS Customer1, C2.C_Name AS Customer2
FROM Customer C1, Customer C2
JOIN Borrower B1 ON C1.C_No = B1.C_No
JOIN Borrower B2 ON C2.C_No = B2.C_No
JOIN Loan L1 ON B1.Loan_No = L1.Loan_no
JOIN Loan L2 ON B2.Loan_No = L2.Loan_no
WHERE C1.street = C2.street
AND C1.C_No != C2.C_No
AND L1.B_name != L2.B_name;

-- 4. Write a procedure that calculates the total loan amount for a particular branch.
DELIMITER //

CREATE PROCEDURE GetTotalLoanAmountForBranch(IN branch_name VARCHAR(50))
BEGIN
    SELECT SUM(amount) AS Total_Loan_Amount
    FROM Loan
    WHERE B_name = branch_name;
END //

DELIMITER ;

-- Example of calling the procedure for 'Branch1'
CALL GetTotalLoanAmountForBranch('Branch1');

-- 5. Write a trigger which keeps track of updated amount of loan.
DELIMITER //

CREATE TRIGGER LoanAmountUpdateTrigger
AFTER UPDATE ON Loan
FOR EACH ROW
BEGIN
    IF OLD.amount <> NEW.amount THEN
        INSERT INTO Loan_Update_Track (Loan_no, Old_Amount, New_Amount, Update_Time)
        VALUES (OLD.Loan_no, OLD.amount, NEW.amount, NOW());
    END IF;
END //

DELIMITER ;

-- Create a table to track loan amount updates
CREATE TABLE Loan_Update_Track (
    Loan_no INT,
    Old_Amount DECIMAL(15, 2),
    New_Amount DECIMAL(15, 2),
    Update_Time DATETIME,
    PRIMARY KEY (Loan_no, Update_Time)
);

