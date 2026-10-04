/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

Formula : RANK Dimension BY Aggregrate of Measure

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), LIMIT
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


-- 1) Which 5 products generate highest revenue 

SELECT
product_name, 
SUM(sales_amount) AS "High_Rev"
FROM
fact_sales fc
LEFT JOIN dim_products dm
ON fc.product_key=dm.product_key
GROUP BY product_name
ORDER BY High_Rev DESC
LIMIT 5;


-- 2)what are the 5 worst-performing products in terms of sale

SELECT
product_name, 
SUM(sales_amount) AS "WORST_PRD_FOR_SALE"
FROM
fact_sales fc
LEFT JOIN dim_products dm
ON fc.product_key=dm.product_key
GROUP BY product_name
ORDER BY WORST_PRD_FOR_SALE
LIMIT 5;

-- 3) Find the Top 10 customers who have generated the highest revenue

SELECT
*
FROM
(
SELECT
dc.customer_key,
dc.first_name,
dc.last_name, 
SUM(sales_amount) AS "High_Rev",
ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) Ranking
FROM
fact_sales fc
LEFT JOIN dim_customers dc
ON fc.customer_key=dc.customer_key
GROUP BY dc.customer_key,dc.first_name,dc.last_name
ORDER BY High_Rev DESC
)t
WHERE ranking<=10;


-- 4) find the 3 customers with fewer order placed

SELECT
dc.customer_key,
dc.first_name,
dc.last_name, 
COUNT(DISTINCT (order_number)) AS "No_of_orders"
FROM
fact_sales fc
LEFT JOIN dim_customers dc
ON fc.customer_key=dc.customer_key
GROUP BY dc.customer_key,dc.first_name,dc.last_name
ORDER BY No_of_orders
LIMIT 3;




