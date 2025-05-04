-- Customer (Cust_no,name,,Street,city,state)
-- Order(Order_no,Cust_no,Order_date,Ship_date,Tocity,ToState,ToZip) Contain(Order_no,Stock_no,quantity,Discount)
-- Stock(Stock_no,price,tax)
-- Write a database trigger to update a stock table when a record is inserted in contains table.
-- 1.
-- Display all the Purchase orders of a specific Customer.
-- 2.
-- Get the Total Value of Purchase Orders.
-- 3.
-- List the Purchase Orders in descending order as per total.
-- 4.
-- Delete Purchase Order 1001
-- 5.
-- Create index on table order with column order_no
-- 6.
-- Create View on columns Order_no and Customer_no with order table

-- Create Customer Table
CREATE TABLE Customer (
    Cust_no INT PRIMARY KEY,
    name VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

-- Create Stock Table
CREATE TABLE Stock (
    Stock_no INT PRIMARY KEY,
    price DECIMAL(10, 2),
    tax DECIMAL(5, 2)
);

-- Create Order Table
CREATE TABLE `Order` (
    Order_no INT PRIMARY KEY,
    Cust_no INT,
    Order_date DATE,
    Ship_date DATE,
    ToCity VARCHAR(50),
    ToState VARCHAR(50),
    ToZip VARCHAR(10),
    FOREIGN KEY (Cust_no) REFERENCES Customer(Cust_no)
);

-- Create Contain Table (Relationship between Order and Stock)
CREATE TABLE Contain (
    Order_no INT,
    Stock_no INT,
    quantity INT,
    Discount DECIMAL(5,2),
    PRIMARY KEY (Order_no, Stock_no),
    FOREIGN KEY (Order_no) REFERENCES `Order`(Order_no),
    FOREIGN KEY (Stock_no) REFERENCES Stock(Stock_no)
);

-- Insert data into Customer table
INSERT INTO Customer (Cust_no, name, street, city, state) 
VALUES 
(1, 'John Doe', '123 Elm St', 'New York', 'NY'),
(2, 'Jane Smith', '456 Oak St', 'Los Angeles', 'CA');

-- Insert data into Stock table
INSERT INTO Stock (Stock_no, price, tax) 
VALUES 
(101, 20.50, 2.50),
(102, 45.00, 4.50),
(103, 15.75, 1.75);

-- Insert data into Order table
INSERT INTO `Order` (Order_no, Cust_no, Order_date, Ship_date, ToCity, ToState, ToZip)
VALUES 
(1001, 1, '2025-04-01', '2025-04-05', 'New York', 'NY', '10001'),
(1002, 2, '2025-04-03', '2025-04-07', 'Los Angeles', 'CA', '90001');

-- Insert data into Contain table
INSERT INTO Contain (Order_no, Stock_no, quantity, Discount)
VALUES 
(1001, 101, 3, 10),
(1001, 102, 2, 5),
(1002, 103, 5, 0);

-- Create Trigger to Update Stock Table when a Record is Inserted in Contain Table
DELIMITER //

CREATE TRIGGER update_stock_after_insert
AFTER INSERT ON Contain
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10, 2);
    DECLARE stock_price DECIMAL(10, 2);
    DECLARE discount DECIMAL(5,2);

    -- Get price from Stock table
    SELECT price INTO stock_price FROM Stock WHERE Stock_no = NEW.Stock_no;
    SELECT Discount INTO discount FROM Contain WHERE Order_no = NEW.Order_no AND Stock_no = NEW.Stock_no;

    -- Calculate total value for that stock (with discount)
    SET total = NEW.quantity * stock_price * (1 - discount / 100);

    -- Update Stock table based on total price
    UPDATE Stock
    SET price = price - total
    WHERE Stock_no = NEW.Stock_no;
END //

DELIMITER ;

-- SQL Queries:

-- 1. Display all the Purchase Orders of a specific Customer (e.g., Customer 1)
SELECT O.Order_no, O.Order_date, O.Ship_date, O.ToCity, O.ToState, O.ToZip
FROM `Order` O
JOIN Customer C ON O.Cust_no = C.Cust_no
WHERE C.Cust_no = 1;

-- 2. Get the Total Value of Purchase Orders
SELECT O.Order_no, SUM(C.quantity * S.price * (1 - C.Discount / 100)) AS Total_Value
FROM Contain C
JOIN `Order` O ON C.Order_no = O.Order_no
JOIN Stock S ON C.Stock_no = S.Stock_no
GROUP BY O.Order_no;

-- 3. List the Purchase Orders in Descending Order as per Total Value
SELECT O.Order_no, SUM(C.quantity * S.price * (1 - C.Discount / 100)) AS Total_Value
FROM Contain C
JOIN `Order` O ON C.Order_no = O.Order_no
JOIN Stock S ON C.Stock_no = S.Stock_no
GROUP BY O.Order_no
ORDER BY Total_Value DESC;

-- 4. Delete Purchase Order 1001
DELETE FROM Contain WHERE Order_no = 1001;
DELETE FROM `Order` WHERE Order_no = 1001;

-- 5. Create Index on Table `Order` with Column `Order_no`
CREATE INDEX idx_order_no ON `Order` (Order_no);

-- 6. Create a View on Columns `Order_no` and `Cust_no` from `Order` Table
CREATE VIEW Order_View AS
SELECT Order_no, Cust_no
FROM `Order`;

