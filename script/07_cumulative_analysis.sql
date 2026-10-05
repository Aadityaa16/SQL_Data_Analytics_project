/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.
    
FORMULA:Aggregation of Measure by date/year

SQL Functions Used:
    - Window Functions: SUM() OVER()
    - Date Functions: DATE_FORMAT()
===============================================================================
*/



--  Calculate the total sales per date and the running total of sales over time

SELECT
Date,
TOTAL_SUM,
SUM(TOTAL_SUM) OVER(ORDER BY Date) AS "Cumulative_SUM",
SUM(TOTAL_SUM) OVER(PARTITION BY YEAR(Date) ORDER BY Date) AS "Cumulative_SUM_YEAR"
FROM
(
SELECT
DATE_FORMAT(order_date,"%Y-%m-%d") AS "Date",
SUM(sales_amount) AS TOTAL_SUM
FROM
fact_sales
WHERE order_date!=''
GROUP BY DATE_FORMAT(order_date,"%Y-%m-%d")
ORDER BY Date
)t;

