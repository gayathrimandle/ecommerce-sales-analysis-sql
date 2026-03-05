# 📊 E-Commerce Sales Analysis (MySQL)

## 📌 Project Overview

This project analyzes an E-Commerce dataset using MySQL to evaluate revenue performance, customer behavior, and product-level insights.

The objective was to apply SQL concepts such as joins, aggregations, subqueries, window functions, and customer segmentation to solve real-world business questions.

---

## 🏗 Database Schema

The project is built using four relational tables:

- **customers**
- **orders**
- **products**
- **order_items**

Foreign key relationships were implemented to maintain data integrity.

---

## 💰 Revenue Analysis

- Calculated total revenue
- Measured total orders & average order value
- Analyzed monthly revenue trends
- Computed cumulative revenue using window functions

---

## 👥 Customer Analysis

- Identified top 10 customers by spending
- Calculated Customer Lifetime Value (CLV)
- Ranked customers using `RANK()` window function
- Measured repeat customer rate
- Performed revenue concentration analysis
- Conducted Pareto analysis (Top 20% revenue contribution)
- Segmented customers into High, Medium, and Low value groups

---

## 🔁 Retention & Engagement Analysis

- Identified customer acquisition month (first purchase logic)
- Calculated monthly active customers
- Segmented new vs returning customers
- Measured month-over-month retained customers
- Calculated retention rate percentage
- Analyzed customer lifetime (in months)
- Evaluated purchase frequency using window functions (`LAG`, `DATEDIFF`)

---

## 📈 Sales Performance Analysis

- Analyzed product-level revenue performance
- Identified top 10 and lowest performing products
- Evaluated category revenue contribution
- Analyzed geographic sales performance by city
- Ranked products by revenue using SQL window functions

---

## 🛍 Product & Category Analysis

- Calculated revenue by category
- Measured revenue contribution percentage
- Compared quantity sold vs revenue generated
- Evaluated pricing differences across categories

---

## 🧠 Key SQL Concepts Used

- `JOIN`
- `GROUP BY`
- `HAVING`
- Subqueries
- Window Functions (`RANK()`, `SUM() OVER`)
- `CASE` statements
- Aggregate functions

---

## 🎯 Conclusion

This project demonstrates the ability to:

- Design relational database structures
- Perform structured business analysis using SQL
- Extract actionable insights from transactional data

---

**Author:** Gayathri Mandle  
Aspiring Data Analyst
