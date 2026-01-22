CREATE DATABASE msme_dashboard;
USE msme_dashboard;

CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    stock_available INT,
    reorder_level INT,
    unit_cost INT
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    department VARCHAR(50),
    salary INT,
    joining_date DATE,
    attendance_days INT
);

CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    quantity INT,
    revenue INT,
    payment_mode VARCHAR(20)
);

CREATE TABLE upi_transactions (
    transaction_id INT PRIMARY KEY,
    order_id INT,
    transaction_date DATE,
    amount INT,
    status VARCHAR(20)
);

CREATE TABLE expenses (
    expense_id INT PRIMARY KEY,
    expense_date DATE,
    category VARCHAR(50),
    amount INT
);

SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM expenses;
SELECT COUNT(*) FROM inventory;

SELECT * FROM sales WHERE revenue IS NULL;

DELETE FROM sales WHERE revenue <= 0;

SET SQL_SAFE_UPDATES = 0;

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(revenue) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;

SELECT category, SUM(amount) AS total_expense
FROM expenses
GROUP BY category;

SELECT 
    s.product_id,
    i.product_name,
    SUM(s.quantity) AS total_sold,
    i.stock_available
FROM sales s
JOIN inventory i ON s.product_id = i.product_id
GROUP BY s.product_id, i.product_name, i.stock_available
ORDER BY total_sold DESC;

SELECT *
FROM inventory
WHERE stock_available < reorder_level;

SELECT COUNT(*) AS failed_payments
FROM upi_transactions
WHERE status = 'Failed';

SELECT 
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department;

CREATE VIEW monthly_revenue AS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(revenue) AS revenue
FROM sales
GROUP BY month;

CREATE VIEW expense_summary AS
SELECT category, SUM(amount) AS total_expense
FROM expenses
GROUP BY category;

CREATE VIEW inventory_status AS
SELECT 
    product_id,
    product_name,
    category,
    stock_available,
    reorder_level,
    CASE 
        WHEN stock_available < reorder_level THEN 'Reorder Required'
        ELSE 'Sufficient'
    END AS stock_status
FROM inventory;
