-- Create Order Management System with at least 3 entities using MySQL and Implement Following Statements

-- CREATING TABLES

CREATE TABLE customers (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    c_name VARCHAR(20),
    city VARCHAR(40),
    mobile VARCHAR(15)
);

CREATE TABLE products (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(20),
    price DECIMAL(10,2),
    category ENUM('men','women','kids')
);

CREATE TABLE orders (
    o_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id INT,
    prod_id INT,
    order_date DATE,
    FOREIGN KEY (cust_id) REFERENCES customers(c_id),
    FOREIGN KEY (prod_id) REFERENCES products(p_id)
);


-- INSERT DATA
INSERT INTO customers (c_name, city, mobile) VALUES
('Alice', 'New York', '1234567890'),
('Bob', 'Los Angeles', '2345678901'),
('Charlie', 'Chicago', '3456789012'),
('Diana', 'Houston', '4567890123'),
('Ethan', 'Phoenix', '5678901234');

INSERT INTO products (p_name, price, category) VALUES
('Shoes', 1200.00, 'men'),
('Dress', 1500.00, 'women'),
('Toy', 500.00, 'kids'),
('Shirt', 800.00, 'men'),
('Skirt', 900.00, 'women');

INSERT INTO orders (cust_id, prod_id, order_date) VALUES
(1, 1, '2025-04-01'),
(2, 2, '2025-04-02'),
(3, 3, '2025-04-03'),
(1, 4, '2025-04-04'),
(4, 5, '2025-04-05');

-- QUERIES

-- 1. Display the name of customers who have maximum orders.
SELECT c.c_name
FROM customers c
JOIN orders o ON c.c_id = o.cust_id
GROUP BY c.c_id
ORDER BY COUNT(o.o_id) DESC
LIMIT 1;

-- Display the Mob No of customers who have highest Buying Total.
SELECT c.mobile
FROM customers c
JOIN orders o ON c.c_id = o.cust_id
JOIN products p ON o.prod_id = p.p_id
GROUP BY c.c_id
ORDER BY SUM(p.price) DESC
LIMIT 1;

-- Display how many customers are there in customer collection.
SELECT COUNT(*) AS total_customers FROM customers;

-- Using collection of customer, and $exists, tell me how many customers belongs from pune city.

SELECT COUNT(*) AS pune_customers
FROM customers
WHERE city = 'Pune';


-- Find the customer who purchased shoes and cloth product.

SELECT DISTINCT c.c_name
FROM customers c
WHERE c.c_id IN (
    SELECT o.cust_id
    FROM orders o
    JOIN products p ON o.prod_id = p.p_id
    WHERE p.p_name = 'Shoes'
)
AND c.c_id IN (
    SELECT o.cust_id
    FROM orders o
    JOIN products p ON o.prod_id = p.p_id
    WHERE p.p_name = 'Cloth'
);

-- Find the top 10 buyers.

SELECT c.c_name, SUM(p.price) AS total_spent
FROM customers c
JOIN orders o ON c.c_id = o.cust_id
JOIN products p ON o.prod_id = p.p_id
GROUP BY c.c_id
ORDER BY total_spent DESC
LIMIT 10;


-- Display all the orders where total amount is >1000.

SELECT o.o_id, c.c_name, p.p_name, p.price
FROM orders o
JOIN customers c ON o.cust_id = c.c_id
JOIN products p ON o.prod_id = p.p_id
WHERE p.price > 1000;


-- Display all the customers with corresponding buying price.

SELECT c.c_name, SUM(p.price) AS total_spent
FROM customers c
JOIN orders o ON c.c_id = o.cust_id
JOIN products p ON o.prod_id = p.p_id
GROUP BY c.c_id;


-- Write a PROCEDURE which will return the Total Price per Customer.

DELIMITER //

CREATE PROCEDURE GetCustomerTotalSpend()
BEGIN
    SELECT c.c_id, c.c_name, SUM(p.price) AS total_spent
    FROM customers c
    JOIN orders o ON c.c_id = o.cust_id
    JOIN products p ON o.prod_id = p.p_id
    GROUP BY c.c_id;
END //

DELIMITER ;

-- Call the procedure:
CALL GetCustomerTotalSpend();
