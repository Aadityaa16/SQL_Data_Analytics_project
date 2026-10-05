/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

FORMULA:Compare the Measure by target value like year by year or current month or previous month

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/


/* Analyse the yearly performance of products by comparing each product
 sales  to both its average sales performance and the previous year's sales. */
     
WITH CTE_1 AS(     
SELECT 
YEAR(ff.order_date) AS "YEAR",
dm.product_name AS Product_name,
SUM(ff.sales_amount) AS "TOTAL_SALES"
FROM fact_sales ff
LEFT JOIN dim_products dm
ON ff.product_key=dm.product_key
WHERE YEAR(ff.order_date) IS NOT NULL
GROUP BY YEAR(ff.order_date),dm.product_name
)
SELECT 
	YEAR,
	Product_name,
	TOTAL_SALES,
	AVG(TOTAL_SALES) OVER(PARTITION BY product_name) AS AVG_SALES,
	TOTAL_SALES - AVG(TOTAL_SALES) OVER(PARTITION BY product_name) AS "Avg_Diff_Sales",
CASE 
	WHEN TOTAL_SALES - AVG(TOTAL_SALES) OVER(PARTITION BY product_name)>0 THEN "GOOD"
	WHEN TOTAL_SALES - AVG(TOTAL_SALES) OVER(PARTITION BY product_name)<0 THEN "POOR"
	ELSE "AVG"
END AS AVG_RESULT,
	LAG(TOTAL_SALES) OVER(PARTITION BY Product_name ORDER BY YEAR) AS "Previous_Sales",
	TOTAL_SALES - LAG(TOTAL_SALES) OVER(PARTITION BY Product_name ORDER BY YEAR) AS "Current_diff_sales",
CASE
	WHEN TOTAL_SALES - LAG(TOTAL_SALES) OVER(PARTITION BY Product_name ORDER BY YEAR) >0 THEN "PROFIT"
	WHEN TOTAL_SALES - LAG(TOTAL_SALES) OVER(PARTITION BY Product_name ORDER BY YEAR) <0 THEN "LOSS"
	ELSE "NO-CHANGE"
END AS SALES_RESULT
FROM
CTE_1;
