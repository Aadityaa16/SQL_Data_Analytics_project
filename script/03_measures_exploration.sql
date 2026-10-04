/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.
    
Formula : Aggregate of MEASURE 

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- 1) find the total sales

SELECT 
SUM(sales_amount) AS TOTAL_SALES
FROM 
fact_sales;

-- 2) how  many items are sold

SELECT 
SUM(quantity) AS TOTAL_ITEMS
FROM 
fact_sales;

-- 3)find the average price 

SELECT 
AVG(price) AS AVG_PRICE
FROM 
fact_sales;

-- 4) Find the total number of orders

SELECT 
COUNT(DISTINCT order_number) AS "TOTAL_ORDER"
FROM 
fact_sales;

-- 5)Find the total number of products

SELECT 
COUNT(DISTINCT product_key) AS "TOTAL_PRODUCT"
FROM 
dim_products;

-- 6)find the total number of customers

SELECT 
COUNT(DISTINCT customer_key) AS "TOTAL_PRODUCT"
FROM 
dim_customers;

-- 7)find the total number of customers that has placed an order

SELECT 
COUNT(DISTINCT customer_key) AS "TOTAL_CUST_PLA_ORD"
FROM fact_sales;

-- ============= Generate a Report that shows all key metrics of the buisness =============== 

SELECT 
"TOTAL SALES"  AS Measure_name, SUM(sales_amount) AS Measure_value FROM  fact_sales
UNION ALL
SELECT 
"TOTAL ITEMS",SUM(quantity) FROM fact_sales
UNION ALL
SELECT 
"AVG PRICE",AVG(price) FROM  fact_sales
UNION ALL
SELECT 
"TOTAL ORDER",COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL
SELECT 
"TOTAL PRODUCT",COUNT(DISTINCT product_key)  FROM dim_products
UNION ALL
SELECT 
"TOTAL CUSTOMERS",COUNT(DISTINCT customer_key) FROM dim_customers
UNION ALL
SELECT 
"TOTAL_CUSTOMER_PLACED_ORDER",COUNT(DISTINCT customer_key) FROM fact_sales;

