-- Design the MySQL Database with following entities,
-- Customer(Cust id : integer, cust_name: string)
-- Item(item_id: integer,item_name: string, price: integer)
-- Sale(bill_no: integer, bill_data: date, cust_id: integer, item_id: integer, qty_sold: integer)
-- For the above schema, perform the following—
-- a)
-- Create the tables with the appropriate integrity constraints.
-- b)
-- Insert around 10 records in each of the tables
-- c)
-- List all the bills for the current date with the customer names and item numbers
-- d)
-- List the total Bill details with the quantity sold, price of the item and the final amount.
-- e)
-- List the details of the customer who have bought a product which has a price>200.
-- f)
-- List the item details and count which are sold as of today.
-- g)
-- Write a procedure to Give a list of products bought by a customer having cust_id as 5

-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS Sale;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Customer;

-- 1. Create Tables with Appropriate Integrity Constraints

CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(100)
);

CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    price INT CHECK (price >= 0)  -- Ensure price cannot be negative
);

CREATE TABLE Sale (
    bill_no INT PRIMARY KEY,
    bill_date DATE,
    cust_id INT,
    item_id INT,
    qty_sold INT CHECK (qty_sold >= 0),  -- Ensure qty_sold cannot be negative
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- 2. Insert Sample Data into Tables

INSERT INTO Customer (cust_id, cust_name) VALUES
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

INSERT INTO Item (item_id, item_name, price) VALUES
(101, 'Laptop', 1500),
(102, 'Smartphone', 600),
(103, 'Headphones', 120),
(104, 'Mouse', 25),
(105, 'Keyboard', 40),
(106, 'Monitor', 300),
(107, 'Speakers', 80),
(108, 'USB Cable', 10),
(109, 'Charger', 20),
(110, 'Webcam', 90);

INSERT INTO Sale (bill_no, bill_date, cust_id, item_id, qty_sold) VALUES
(1001, '2025-05-04', 1, 101, 1),
(1002, '2025-05-04', 2, 102, 2),
(1003, '2025-05-04', 3, 103, 3),
(1004, '2025-05-04', 4, 104, 5),
(1005, '2025-05-03', 5, 105, 4),
(1006, '2025-05-02', 6, 106, 1),
(1007, '2025-05-01', 7, 107, 2),
(1008, '2025-05-05', 8, 108, 6),
(1009, '2025-05-06', 9, 109, 1),
(1010, '2025-05-07', 10, 110, 3);

-- 3. Queries

-- c) List all the bills for the current date with customer names and item numbers
SELECT s.bill_no, s.bill_date, c.cust_name, i.item_id
FROM Sale s
JOIN Customer c ON s.cust_id = c.cust_id
JOIN Item i ON s.item_id = i.item_id
WHERE s.bill_date = CURDATE();

-- d) List the total bill details with quantity sold, price of the item, and final amount
SELECT s.bill_no, i.item_name, s.qty_sold, i.price, (s.qty_sold * i.price) AS final_amount
FROM Sale s
JOIN Item i ON s.item_id = i.item_id;

-- e) List the details of the customer who has bought a product with a price > 200
SELECT DISTINCT c.*
FROM Customer c
JOIN Sale s ON c.cust_id = s.cust_id
JOIN Item i ON s.item_id = i.item_id
WHERE i.price > 200;

-- f) List the item details and count which are sold as of today
SELECT i.item_name, SUM(s.qty_sold) AS total_sold
FROM Sale s
JOIN Item i ON s.item_id = i.item_id
WHERE s.bill_date = CURDATE()
GROUP BY i.item_name;

-- 4. Stored Procedure: List products bought by a customer having cust_id = 5
DELIMITER //

CREATE PROCEDURE ListProductsBoughtByCustomer(cust_id_param INT)
BEGIN
    SELECT i.item_name, s.qty_sold, i.price, (s.qty_sold * i.price) AS total_amount
    FROM Sale s
    JOIN Item i ON s.item_id = i.item_id
    WHERE s.cust_id = cust_id_param;
END //

DELIMITER ;

-- To run the procedure for cust_id = 5
CALL ListProductsBoughtByCustomer(5);
