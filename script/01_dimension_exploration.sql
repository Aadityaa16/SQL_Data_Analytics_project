/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
===============================================================================
*/

-- A)Retrieve a list of unique countries from which customers originate

SELECT DISTINCT country  FROM dim_customers;

-- B)Retrieve a list of unique categories, subcategories, and products

SELECT DISTINCT 
		category, 
		subcategory, 
		product_name 
		FROM 
dim_products;

