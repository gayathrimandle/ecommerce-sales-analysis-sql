/* =====================================================
   Project: Customer Retention & Growth Analysis
   Tool: MySQL
   Author: Gayathri Mandle
   Description: Retention, Lifetime & Engagement Metrics
===================================================== */

USE ecommerce_project;

/* ================================
   1. First Purchase (Acquisition)
================================ */

SELECT 
    customer_id,
    MIN(order_date) AS first_purchase_date,
    DATE_FORMAT(MIN(order_date), '%Y-%m') AS acquisition_month
FROM orders
GROUP BY customer_id;


/* ================================
   2. Monthly Active Customers
================================ */

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders
GROUP BY month
ORDER BY month;


/* ================================
   3. New vs Returning Customers
================================ */

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,

    COUNT(DISTINCT CASE 
        WHEN DATE_FORMAT(o.order_date, '%Y-%m') = fp.acquisition_month 
        THEN o.customer_id 
    END) AS new_customers,

    COUNT(DISTINCT CASE 
        WHEN DATE_FORMAT(o.order_date, '%Y-%m') <> fp.acquisition_month 
        THEN o.customer_id 
    END) AS returning_customers

FROM orders o

JOIN (
    SELECT 
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m') AS acquisition_month
    FROM orders
    GROUP BY customer_id
) fp
ON o.customer_id = fp.customer_id

GROUP BY month
ORDER BY month;


/* ================================
   4. Retained Customers (MoM)
================================ */

SELECT
    mc1.month AS current_month,
    COUNT(DISTINCT mc1.customer_id) AS retained_customers
FROM (
    SELECT DISTINCT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        customer_id
    FROM orders
) mc1
JOIN (
    SELECT DISTINCT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        customer_id
    FROM orders
) mc2
ON mc1.customer_id = mc2.customer_id
AND mc2.month = DATE_FORMAT(
    DATE_SUB(STR_TO_DATE(CONCAT(mc1.month, '-01'), '%Y-%m-%d'), INTERVAL 1 MONTH),
    '%Y-%m'
)
GROUP BY mc1.month
ORDER BY mc1.month;


/* ================================
   5. Retention Rate %
================================ */

SELECT
    current_month,
    current_month_customers,
    retained_customers,
    ROUND(retained_customers / current_month_customers * 100, 2) AS retention_rate_percent
FROM (
    SELECT
        mc1.month AS current_month,
        COUNT(DISTINCT mc1.customer_id) AS current_month_customers,
        COUNT(DISTINCT mc2.customer_id) AS retained_customers
    FROM (
        SELECT DISTINCT
            DATE_FORMAT(order_date, '%Y-%m') AS month,
            customer_id
        FROM orders
    ) mc1
    LEFT JOIN (
        SELECT DISTINCT
            DATE_FORMAT(order_date, '%Y-%m') AS month,
            customer_id
        FROM orders
    ) mc2
    ON mc1.customer_id = mc2.customer_id
    AND mc2.month = DATE_FORMAT(
        DATE_SUB(STR_TO_DATE(CONCAT(mc1.month, '-01'), '%Y-%m-%d'), INTERVAL 1 MONTH),
        '%Y-%m'
    )
    GROUP BY mc1.month
) retention_data
ORDER BY current_month;


/* ================================
   6. Customer Lifetime (Months)
================================ */

SELECT 
    customer_id,
    MIN(order_date) AS first_purchase,
    MAX(order_date) AS last_purchase,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifetime_months
FROM orders
GROUP BY customer_id
ORDER BY lifetime_months DESC;


/* ================================
   7. Purchase Frequency (Days Between Orders)
================================ */

SELECT 
    customer_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
    DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
FROM orders
ORDER BY customer_id, order_date;