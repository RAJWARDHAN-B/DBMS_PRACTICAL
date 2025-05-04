-- Bank Database:
-- A bank database keeps record of the details of customers, accounts, loans and transactions such as deposits or withdraws. Customer record should include customer id, customer name, address, age, contact number, email id etc., accounts details involves account number, account type(fixed account, savings account, monthly account etc), date of creation of the account, balance. Transaction detail keeps information about amount deposited or withdrawn to/from a particular account and the date of transaction. The database should also store record of loans which include loan amount, loan date and the account number to which the loan is granted.
-- Make appropriate tables for the above database and try to find out the following queries: (Apply appropriate triggers whenever required)
-- a)
-- List the details of account holders who have a ‘savings’ account.
-- b)
-- List the Name and address of account holders with loan amount more than 50,000.
-- c)
-- Change the name of the customer to ‘ABC’ whose account number is ’TU001’
-- d)
-- List the account number with total deposit more than 80,000.
-- e)
-- List the number of fixed deposit accounts in the bank.
-- f)
-- Display the detailed transactions on 28th Aug, 2008.
-- h)
-- Display the total amount deposited and withdrawn on 29th Aug, 2008.
-- i)
-- List the details of customers who have a loan.
-- j)
-- Write a procedure to display Savings and Loan information of all customers.

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

-- Create Customers Table
CREATE TABLE customers (
    cust_id VARCHAR(10) PRIMARY KEY,
    cust_name VARCHAR(100),
    address VARCHAR(255),
    age INT,
    contact_no VARCHAR(15),
    email VARCHAR(100)
);

-- Create Accounts Table
CREATE TABLE accounts (
    acc_no VARCHAR(10) PRIMARY KEY,
    cust_id VARCHAR(10),
    acc_type ENUM('savings', 'fixed', 'monthly'),
    creation_date DATE,
    balance DECIMAL(12,2),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);

-- Create Transactions Table
CREATE TABLE transactions (
    trans_id INT AUTO_INCREMENT PRIMARY KEY,
    acc_no VARCHAR(10),
    trans_type ENUM('deposit', 'withdraw'),
    amount DECIMAL(12,2),
    trans_date DATE,
    FOREIGN KEY (acc_no) REFERENCES accounts(acc_no)
);

-- Create Loans Table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    acc_no VARCHAR(10),
    loan_amount DECIMAL(12,2),
    loan_date DATE,
    FOREIGN KEY (acc_no) REFERENCES accounts(acc_no)
);

-- Sample Data: Customers
INSERT INTO customers VALUES
('C001', 'Alice', 'Pune', 30, '9876543210', 'alice@example.com'),
('C002', 'Bob', 'Mumbai', 45, '9876543211', 'bob@example.com'),
('C003', 'Charlie', 'Delhi', 35, '9876543212', 'charlie@example.com');

-- Sample Data: Accounts
INSERT INTO accounts VALUES
('TU001', 'C001', 'savings', '2023-01-15', 90000.00),
('TU002', 'C002', 'fixed', '2022-03-10', 120000.00),
('TU003', 'C003', 'monthly', '2023-06-01', 50000.00);

-- Sample Data: Transactions
INSERT INTO transactions (acc_no, trans_type, amount, trans_date) VALUES
('TU001', 'deposit', 50000.00, '2008-08-28'),
('TU001', 'withdraw', 10000.00, '2008-08-28'),
('TU002', 'deposit', 90000.00, '2008-08-29'),
('TU003', 'withdraw', 3000.00, '2008-08-29');

-- Sample Data: Loans
INSERT INTO loans (acc_no, loan_amount, loan_date) VALUES
('TU001', 60000.00, '2023-09-01'),
('TU002', 40000.00, '2023-10-10');


-- QUERIES

-- a) List details of account holders who have a ‘savings’ account
SELECT c.*
FROM customers c
JOIN accounts a ON c.cust_id = a.cust_id
WHERE a.acc_type = 'savings';

-- b) List name and address of account holders with loan amount > 50000
SELECT c.cust_name, c.address
FROM customers c
JOIN accounts a ON c.cust_id = a.cust_id
JOIN loans l ON a.acc_no = l.acc_no
WHERE l.loan_amount > 50000;

-- c) Change the name of the customer to ‘ABC’ whose account number is ’TU001’
UPDATE customers
SET cust_name = 'ABC'
WHERE cust_id = (SELECT cust_id FROM accounts WHERE acc_no = 'TU001');

-- d) List the account number with total deposit more than 80000
SELECT acc_no, SUM(amount) AS total_deposit
FROM transactions
WHERE trans_type = 'deposit'
GROUP BY acc_no
HAVING SUM(amount) > 80000;

-- e) List the number of fixed deposit accounts in the bank
SELECT COUNT(*) AS fixed_accounts
FROM accounts
WHERE acc_type = 'fixed';

-- f) Display the detailed transactions on 28th Aug, 2008
SELECT *
FROM transactions
WHERE trans_date = '2008-08-28';

-- h) Display total amount deposited and withdrawn on 29th Aug, 2008
SELECT 
    SUM(CASE WHEN trans_type = 'deposit' THEN amount ELSE 0 END) AS total_deposited,
    SUM(CASE WHEN trans_type = 'withdraw' THEN amount ELSE 0 END) AS total_withdrawn
FROM transactions
WHERE trans_date = '2008-08-29';

-- i) List the details of customers who have a loan
SELECT DISTINCT c.*
FROM customers c
JOIN accounts a ON c.cust_id = a.cust_id
JOIN loans l ON a.acc_no = l.acc_no;


-- j) Stored Procedure – Show Savings and Loan Info

DELIMITER //

CREATE PROCEDURE ShowSavingsAndLoans()
BEGIN
    SELECT 
        c.cust_id, c.cust_name, a.acc_no, a.acc_type, a.balance,
        l.loan_amount, l.loan_date
    FROM customers c
    JOIN accounts a ON c.cust_id = a.cust_id
    LEFT JOIN loans l ON a.acc_no = l.acc_no
    WHERE a.acc_type = 'savings' OR l.loan_id IS NOT NULL;
END;
//

DELIMITER ;

-- To call:
-- CALL ShowSavingsAndLoans();


-- Example Trigger (Optional)
-- Make customer names UPPERCASE on insert:

DELIMITER //

CREATE TRIGGER before_customer_insert
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    SET NEW.cust_name = UPPER(NEW.cust_name);
END;
//

DELIMITER ;
