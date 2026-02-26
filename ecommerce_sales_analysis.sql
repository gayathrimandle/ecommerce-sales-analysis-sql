/* =====================================================
   Project: E-Commerce Sales Analysis
   Tool: MySQL
   Author: Gayathri Mandle
   Description: Revenue, Customer & Product Analysis
===================================================== */

CREATE DATABASE ecommerce_project;
USE ecommerce_project;

/* ================================
   TABLE CREATION
================================ */

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

/* ================================
   REVENUE ANALYSIS
================================ */

-- Total Revenue
SELECT ROUND(SUM(total_amount),2) AS total_revenue
FROM orders;

-- Total Orders & Average Order Value
SELECT 
    COUNT(*) AS total_orders,
    ROUND(AVG(total_amount),2) AS avg_order_value
FROM orders;

-- Monthly Revenue Trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(total_amount),2) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;

/* ================================
   CUSTOMER ANALYSIS
================================ */

-- Top 10 Customers by Spending
SELECT 
    c.customer_id,
    c.name,
    ROUND(SUM(o.total_amount),2) AS total_spent
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- Revenue Contribution from Top 10 Customers
SELECT 
    ROUND(
        SUM(total_spent) / 
        (SELECT SUM(total_amount) FROM orders) * 100, 2
    ) AS top10_revenue_percent
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 10
) AS top_customers;

-- Customer Ranking (Window Function)
SELECT 
    c.customer_id,
    c.name,
    ROUND(SUM(o.total_amount),2) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Customer Lifetime Value (CLV)
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount),2) AS lifetime_value
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC
LIMIT 10;

-- Repeat Customer Percentage
SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END) 
        / COUNT(DISTINCT customer_id) * 100, 2
    ) AS repeat_customer_percent
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) AS customer_orders;

/* ================================
   PRODUCT & CATEGORY ANALYSIS
================================ */

-- Revenue by Category
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * oi.price),2) AS category_revenue
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Revenue Contribution %
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * oi.price),2) AS category_revenue,
    ROUND(
        SUM(oi.quantity * oi.price) /
        (SELECT SUM(quantity * price) FROM order_items) * 100, 2
    ) AS revenue_percent
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue_percent DESC;

-- Units Sold by Category
SELECT 
    p.category,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_units_sold DESC;

-- Average Price by Category
SELECT 
    p.category,
    ROUND(AVG(oi.price),2) AS avg_price
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_price DESC;

/* ================================
   ADVANCED ANALYSIS
================================ */

-- Running Revenue (Window Function)
SELECT 
    month,
    monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS monthly_revenue
    FROM orders
    GROUP BY month
) AS monthly_data;

-- Customer Segmentation
SELECT 
    customer_id,
    lifetime_value,
    CASE 
        WHEN lifetime_value >= 100000 THEN 'High Value'
        WHEN lifetime_value BETWEEN 60000 AND 99999 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS lifetime_value
    FROM orders
    GROUP BY customer_id
) AS customer_data
ORDER BY lifetime_value DESC;

-- Pareto Analysis (Top 20% Customers)
SELECT 
    ROUND(
        SUM(total_spent) /
        (SELECT SUM(total_amount) FROM orders) * 100,
        2
    ) AS top20_percent_revenue
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 20
) AS top_20;