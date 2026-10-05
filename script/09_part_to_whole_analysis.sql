/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

FORMULA:(measure /total_measure) *100 BY Dimension


SQL Functions Used:
    - SUM(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
    - String Functions: CONCAT() for adding string.
===============================================================================
*/


-- 1)Which category perform the most sales

WITH CTE_1 AS (
SELECT
	dm.category AS category,
	SUM(fc.sales_amount) AS "SUM"
	FROM
fact_sales fc
LEFT JOIN dim_products dm
ON fc.product_key=dm.product_key
GROUP BY dm.category
),CTE_2 AS(
SELECT
	*,
	SUM(SUM) OVER() AS "TOTAL_SUM",
	SUM/SUM(SUM) OVER() AS "VALUE"
FROM CTE_1
)
SELECT 
	*,
	CONCAT(ROUND(VALUE*100,2),"%") AS "perchentage"
	FROM
CTE_2;

