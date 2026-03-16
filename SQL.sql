CREATE DATABASE olist_db;
use olist_db;

CREATE TABLE dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE dim_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE dim_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE fact_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    payment_value FLOAT,
    delivery_delay_days FLOAT,
    review_score FLOAT,
    churn_flag BOOLEAN,
    revenue_at_risk BOOLEAN
);

SHOW TABLES;

-- Total Revenue
SELECT SUM(payment_value) AS total_revenue
FROM fact_orders;

-- Revenue at risk
SELECT 
    SUM(payment_value) AS revenue_at_risk
FROM fact_orders
WHERE revenue_at_risk = 1;

-- Percentage revenue at risk
SELECT 
    SUM(CASE WHEN revenue_at_risk = 1 THEN payment_value ELSE 0 END) /
    SUM(payment_value) * 100 AS risk_percentage
FROM fact_orders;

-- Average Deivery delay
SELECT 
    AVG(delivery_delay_days) AS avg_delivery_delay
FROM fact_orders;

-- Customer churn rate
SELECT 
    AVG(churn_flag) * 100 AS churn_rate
FROM fact_orders;

-- top Risky Sellers
SELECT 
    seller_id,
    AVG(delivery_delay_days) AS avg_delay,
    AVG(review_score) AS avg_review,
    SUM(payment_value) AS revenue
FROM fact_orders
GROUP BY seller_id
ORDER BY avg_delay DESC
LIMIT 10;

-- Average review score
SELECT
    AVG(review_score) AS avg_review_score
FROM fact_orders;