/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
    - TIMESTAMPDIFF : Calculate the month 
===============================================================================
*/


/* 1) Group the customers into three segment based on their spending behaviour:
     VIP:Customers with atleast 12 months of history and spending more than 5000.
     Regular:Customers with atleast 12 months of history and spending  5000 or less.
     New:Customers with lifespan less than  12 months of history.
AND also find total numbe rof customers for each group.
 */  
 
 
WITH CTE_1 AS(
SELECT
dm.product_key,
MAX(fc.order_date) AS "last_date",
MIN(fc.order_date) AS "First_date",
SUM(fc.sales_amount) AS "TOTAL_SPEND_AMOUNT",
TIMESTAMPDIFF(MONTH,MIN(fc.order_date),MAX(fc.order_date)) AS "no_of_month"
FROM fact_sales fc
LEFT JOIN dim_products dm
ON fc.product_key=dm.product_key
GROUP BY dm.product_key
HAVING First_date!=''
),CTE_2 AS(
SELECT
*,
CASE
WHEN no_of_month>=12 AND TOTAL_SPEND_AMOUNT>5000 THEN "VIP"
WHEN no_of_month>=12 AND TOTAL_SPEND_AMOUNT<=5000 THEN "REGULAR"
ELSE "NEW"
END AS "Customer_TYPE"
FROM
CTE_1
)
SELECT
Customer_TYPE,
COUNT(product_key) AS "TOTAL_CUSTOMERS"
FROM
CTE_2
GROUP BY Customer_TYPE;

