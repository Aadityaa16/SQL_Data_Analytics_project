/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

===============================================================================
*/


--     =======================================================SQL PROJECT ================================

--  Create a New Database named:"EDA_Data_analysis"
CREATE DATABASE EDA_Data_analysis;
USE EDA_Data_analysis;


-- Retrieve a list of all tables in the database for sales/revenue of product.
SELECT * FROM fact_sales;

-- Retrieve a list of all tables in the database for product details and cost.
SELECT * FROM dim_products;

-- -- Retrieve a list of all tables in the database for customer details.
SELECT * FROM dim_customers;
