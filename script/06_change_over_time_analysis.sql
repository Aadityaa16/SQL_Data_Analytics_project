/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

-- FORMULA:Aggregation of Measure by date/year

SQL Functions Used:
    - Date Functions: DATE_FORMAT(),EXTRACT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- 1) Analyse sales performance over time

SELECT
order_date AS order_date,
SUM(sales_amount) AS TOTAL_SUM,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS
FROM
fact_sales
WHERE order_date!=''
GROUP BY order_date
ORDER BY order_date;

-- 2) Analyse sales performance over YEAR

SELECT
YEAR(order_date) AS YEAR,
SUM(sales_amount) AS TOTAL_SUM,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS
FROM
fact_sales
WHERE order_date!=''
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- 3)  Analyse sales performance over YEAR AND MONTH


SELECT
YEAR(order_date) AS YEAR,
MONTH(order_date) AS MONTH,
SUM(sales_amount) AS TOTAL_SUM,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS
FROM
fact_sales
WHERE order_date!=''
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date);

-- 4)  Analyse sales performance over YEAR AND MONTH USING DATE_FORMAT

SELECT
DATE_FORMAT(order_date,"%Y-%m") AS "YYYY-MM",
SUM(sales_amount) AS TOTAL_SUM,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS
FROM
fact_sales
WHERE order_date!=''
GROUP BY DATE_FORMAT(order_date,"%Y-%m")
ORDER BY DATE_FORMAT(order_date,"%Y-%m");

-- 5) Analyse sales performance over Year and Quarter

SELECT
YEAR(order_date) AS YEAR,
EXTRACT(QUARTER FROM order_date) AS QUARTER,
SUM(sales_amount) AS TOTAL_SUM,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS
FROM
fact_sales
WHERE order_date!=''
GROUP BY YEAR(order_date),EXTRACT(QUARTER FROM order_date)
ORDER BY YEAR(order_date),EXTRACT(QUARTER FROM order_date);


