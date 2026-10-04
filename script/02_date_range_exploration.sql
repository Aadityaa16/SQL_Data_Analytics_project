/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.
    
FORMULA : MIN/MAX (DIMENSION)

SQL Functions Used:
    - MIN(), MAX(), TIMESTAMPDIFF()
===============================================================================
*/

-- A)Find earliest and last order date from Sales.

WITH MAX_MIN_CTE AS (
SELECT 
NULLIF(order_date,'') AS order_date
FROM 
fact_sales
)
SELECT 
MIN(order_date) AS first_Date,
MAX(order_Date) AS Last_date
FROM
MAX_MIN_CTE;

-- B) How many years or month of sale are available
WITH MAX_MIN_CTE AS (
SELECT 
NULLIF(order_date,'') AS order_date
FROM 
fact_sales
)
SELECT 
MIN(order_date) AS first_Date,
MAX(order_Date) AS Last_date,
TIMESTAMPDIFF(YEAR,MIN(order_date),MAX(order_Date)) AS year,
TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_Date)) AS month
FROM
MAX_MIN_CTE;

-- C)Find the youngest and oldest customer
WITH MAX_MIN_CTE AS (
SELECT 
NULLIF(birthdate,'') AS birthdate
FROM 
dim_customers
)
SELECT
MIN(birthdate) AS Oldest_date,
TIMESTAMPDIFF(YEAR,MIN(birthdate),NOW()) AS Age,
MAX(birthdate) AS Youngest_date,
TIMESTAMPDIFF(YEAR,MAX(birthdate),NOW()) AS Age
FROM MAX_MIN_CTE;


