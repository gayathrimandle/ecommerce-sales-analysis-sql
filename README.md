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
