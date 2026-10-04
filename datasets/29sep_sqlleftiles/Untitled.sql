USE 5Sep_2026_SQL_Lib;

/* SUBQUERIES: 
INFORMATION_SCHEMA: special type of information schema contain in-bUILT Views to access meta information about data.
*/
SELECT * FROM INFORMATION_SCHEMA.COLOUMN;

/* SUBQUERIES:1)FROM(),SELECT(),JOIN(),WHERE */
-- 1) can use result only once
-- 2)bottom to top approach

-- CTE(COMMON TABLE EXPRESSION): temporary result set(virtual table) that can be used multiple times within your query.
-- 1)cannot use ORDERBY IN CTE.(CAN USED WITH WINDOW FUNCTIONS).
-- 2)TOP TO BOTTOM APPROACH.

-- 2)NON-RECURSIVE:(error check it)
WITH CTE_1 AS(
SELECT 
1 AS num
UNION 
SELECT 
num+1 
FROM CTE_1
WHERE num<20)

SELECT * FROM CTE_1;


/* VIEWS:
1)SQL SERVER->2)DATABASE->3)SCHEMA->4)TABLE and VIEWS.
2)views: virtual table based on result of query without storing data in database.*/

/* CTA's: (CREATE TABLE AS SELECT): create a table and  populate it with data with select in query.
1)faster than views.
2)once CTA's is done then table is created but if data is updated on original table then will not get latest data.
*/

/*TEM TABLES: used to store data temporarily in database and deletes once session ends.
2)2)once TEM TABLES ARE MADE using select query's then table is created but if data is updated on original table then will not get latest data.
*/

CREATE DATABASE datasset_test_20sep;

USE datasset_test_20sep;
SELECT * FROM users;

-- stored procedures: precompiled code that stores a script in database  and can be reused and use to call it from user and display the results.

CALL user_procedure("FEMALE");

DROP PROCEDURE IF EXISTS PROCEDURE_1;
DELIMITER //

CREATE PROCEDURE PROCEDURE_1(
    OUT inp_out_spa INT,
    OUT inp_out_emp INT
)
BEGIN

		DECLARE val_space INT DEFAULT 0;
		DECLARE val_empty INT DEFAULT 0;

		IF EXISTS (SELECT 1 FROM users WHERE gender = ' ') THEN
			SELECT COUNT(*)
			INTO val_space
			FROM users
			WHERE gender = ' ';
		END IF;

		IF EXISTS (SELECT 1 FROM users WHERE gender = '') THEN
			SELECT COUNT(*)
			INTO val_empty
			FROM users
			WHERE gender = '';
		END IF;

		SET inp_out_spa = val_space;
		SET inp_out_emp = val_empty;

END//

DELIMITER ;

CALL PROCEDURE_1(@inp_out_spa, @inp_out_emp);

SELECT @inp_out_spa, @inp_out_emp;

SELECT * FROM users;

-- TRIGGERS: special stored procedures that runs automatically in response to special events on table or view.


SELECT * FROM orders;

DESC orders;

CREATE TABLE after_insert_log_order(
orderID INT NOT NULL,
OrderDate DATE NOT NULL,
CustomerID INT NOT NULL
);

DELIMITER //
CREATE TRIGGER aft_trg 
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.OrderID!=NEW.OrderID THEN
		 INSERT INTO after_insert_log_order(orderID,OrderDate,CustomerID)
			VALUES(NEW.OrderID,CURDATE(),OLD.CustomerID);
	END IF;
END //

DELIMITER ;
SELECT * FROM merchant;
UPDATE orders
SET OrderID=10668
WHERE CustomerID=81;

/* =================INDEX=====
1) Structure -clustered , Nonclustered
2)storage-RowStore, ColumnStore
3)Function-Unique,filter
*/
/*
-- 1)CLustered index: store data in data pages at leaf note  in hierarchical B-tree.(root ,intermediate, leaf node)
-- B-tree: it store key value(pointer) to data page .
-- 2)NONCLUSTERED index(SECONDARY):store data randomly in data page

bydefault- NONCLUSTERED,ROWSTORE
ROWSTORE: sorting on basis of rows
COLUMNSTORE: divide on basis of clus/non-clus then segment on each coloumn type , compress it then LOB(large object page in form of dictioanry)
*/

-- NOTE:u cannot use where(FILTER WITH COULMNSTORE and CLustered type).
-- SYNTAX: CREATE [UNIQUE] [CLUSTERED/NONCLUSTERED] [ROWSTORE/COLUMNSTORE] INDEX index_name ON table_name(column type);
-- bydefault- NONCLUSTERED,ROWSTORE

SELECT * FROM product_details;




SELECT * FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA="datasset_test_20sep";

SELECT * FROM sys.schema_unused_indexes;

USE NEW_24sep;

SELECT 
ev.song,
artist_name,
COUNT(*) AS popularity_rank
FROM events ev
JOIN songs ss
ON ev.song=ss.title
GROUP BY ev.song,artist_name;

-- NEW TEST
CREATE DATABASE 26_sep_test;
USE 26_sep_test;

SELECT * FROM customers;
SELECT * FROM energy_consumption;
SELECT * FROM energy_production;
SELECT * FROM production_plants;
SELECT * FROM sustainability_initiatives;

-- monthly emission
WITH plant_emissions AS(
    SELECT
    pp.plant_id,
    pp.plant_name,
    ep.carbon_emission_kg
    FROM
    production_plants pp
    JOIN energy_production ep
    ON pp.plant_id=ep.production_plant_id
)
SELECT
plant_id AS production_plant_id,
plant_name,
ROUND(AVG(carbon_emission_kg),2) AS avg_emissions,
ROUND(SUM(carbon_emission_kg),2) AS total_emissions
FROM plant_emissions
GROUP BY plant_id,plant_name
ORDER BY plant_id;

-- energy consumption
WITH monthly_consumption AS(
    SELECT
    ec.customer_id,
    c.name,
    DATE_FORMAT(ec.date,"%Y-%m") AS month,
    SUM(ec.amount_kwh) AS monthly_consumption
    FROM
    energy_consumption ec
    JOIN customers c
    ON ec.customer_id=c.customer_id
    GROUP BY
    ec.customer_id,
    c.name,
    DATE_FORMAT(ec.date,"%Y-%m")
)
SELECT
customer_id,
name,
ROUND(SUM(monthly_consumption),2) AS total_consumption,
ROUND(AVG(monthly_consumption),2) AS avg_monthly_consumption
FROM
monthly_consumption
GROUP BY
customer_id,name
ORDER BY customer_id;

-- analyzing energy consumption
WITH CTE_1 AS(
    SELECT 
    customer_id,
    date,
    SUM(amount_kwh) AS total_daily_consumption
    FROM energy_consumption
    WHERE date >="2023-01-01" AND date < "2024-01-01"
    GROUP BY
    customer_id,date
),
ranked_consumption AS (
    SELECT
     customer_id,
    date,
    total_daily_consumption,
    FIRST_VALUE(total_daily_consumption) OVER(PARTITION BY customer_id ORDER BY date) AS first_consumption,
    FIRST_VALUE(total_daily_consumption) OVER(PARTITION BY customer_id ORDER BY date DESC) AS last_consumption,
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY date) AS rn
    FROM 
    CTE_1
)
-- SELECT * FROM ranked_consumption;
SELECT
customer_id,
ROUND(first_consumption,2) AS first_consumption,
ROUND(last_consumption,2) AS last_consumption
FROM
ranked_consumption
WHERE rn=1
ORDER BY customer_id;


-- monthly changes
WITH CTE_1 AS
(
    SELECT
    production_plant_id,
    DATE_FORMAT(date,"%Y-%m") AS month,
    SUM(Amount_kwh) AS current_month_production
    FROM
    energy_production
    GROUP BY
    production_plant_id,
     DATE_FORMAT(date,"%Y-%m")
)
SELECT
production_plant_id,
CONCAT(month) AS month,
current_month_production AS  current_month_production,
LAG(current_month_production) OVER(PARTITION BY production_plant_id ORDER BY month) AS previous_month_production,
LEAD(current_month_production) OVER(PARTITION BY production_plant_id ORDER BY month) AS next_month_production
FROM CTE_1
ORDER BY
production_plant_id,
month;

-- monthly energy change
WITH CTE_1 AS
(
    SELECT
    production_plant_id,
    DATE_FORMAT(date,"%Y-%m") AS month,
    SUM(Amount_kwh) AS current_month_production
    FROM
    energy_production
    GROUP BY
    production_plant_id,
     DATE_FORMAT(date,"%Y-%m")
)
SELECT
production_plant_id,
CONCAT(month,"-01") AS month,
current_month_production AS  current_month_production,
LAG(current_month_production) OVER(PARTITION BY production_plant_id ORDER BY month) AS previous_month_production,
LEAD(current_month_production) OVER(PARTITION BY production_plant_id ORDER BY month) AS next_month_production
FROM CTE_1
ORDER BY
production_plant_id,
month;

-- consumption trend
SELECT
production_id,
production_plant_id,
date,
energy_type,
amount_kwh,
SUM(amount_kwh) OVER(PARTITION BY energy_type) total_energy_by_type
FROM
energy_production;

-- ranking production amounts
SELECT * FROM energy_production;
SELECT 
production_id,
production_plant_id,
date AS date,
energy_type,
amount_kwh,
RANK() OVER(PARTITION BY energy_type ORDER BY amount_kwh DESC) rank_within_type
FROM
energy_production;


-- cumulative comsumption
SELECT * FROM energy_consumption;
SELECT 
consumption_id,
customer_id,
date,
energy_type,
amount_kwh,
SUM(amount_kwh) OVER(PARTITION BY customer_id ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS cumulative_consumption
FROM 
energy_consumption
ORDER BY customer_id;


-- highest production
WITH CTE_1 AS(
    SELECT
    production_plant_id,
    energy_type,
    date,
    amount_kwh,
    ROW_NUMBER() OVER(PARTITION BY energy_type ORDER BY amount_kwh DESC ) AS Ranking
    FROM
    energy_production
)
SELECT
    production_plant_id,
    energy_type,
    date,
    amount_kwh
    FROM CTE_1
    WHERE Ranking <=3
    ORDER BY
    energy_type,Ranking;
    
-- average montly prouction
WITH CTE_1 AS
(
    SELECT
    production_plant_id,
    DATE_FORMAT(date,"%Y-%m") AS month,
    AVG(Amount_kwh) AS current_month_production
    FROM
    energy_production
    GROUP BY
    production_plant_id,
     DATE_FORMAT(date,"%Y-%m")
),CTE_2 AS(
    SELECT
    production_plant_id,
    month,
    current_month_production AS avg_monthly_production,
    RANK() OVER(PARTITION BY month ORDER BY current_month_production DESC)  AS ranking
    FROM
    CTE_1
)
SELECT
    production_plant_id,
    month,
    avg_monthly_production,
    ranking
    FROM
    CTE_2;
    
-- high-performing inititatives
SELECT
initiative_name,
start_date,
end_date,
energy_savings_kwh,
RANK() OVER(ORDER BY energy_savings_kwh DESC) "initiative_rank"
FROM 
sustainability_initiatives;

-- carbon emission plant
SELECT 
pp.plant_name,
pp.location,
SUM(ep.carbon_emission_kg)/SUM(ep.amount_kwh) AS avg_carbon_emission_per_kwh
FROM production_plants pp
JOIN energy_production ep
ON pp.plant_id=ep.production_plant_id
GROUP BY
pp.plant_id,
pp.plant_name,
pp.location
ORDER BY avg_carbon_emission_per_kwh DESC
LIMIT 5;

-- top-performing inititative
SELECT
initiative_name,
start_date,
end_date,
energy_savings_kwh
FROM 
sustainability_initiatives
ORDER BY energy_savings_kwh DESC
LIMIT 3;

-- energy savings
WITH CTE_1 AS(
    SELECT
    initiative_id,
     initiative_name,
     energy_savings_kwh,
     TIMESTAMPDIFF(MONTH,start_date,end_date) AS total_months
     FROM
     sustainability_initiatives
)
SELECT
    initiative_id,
     initiative_name,
     energy_savings_kwh AS total_savings,
     ROUND(energy_savings_kwh/NULLIF(total_months,0),2) AS avg_monthly_savings
     FROM CTE_1
     ORDER BY initiative_id;
     

--  ===========SQL PROJECT =======
CREATE DATABASE  SQL_project;



