CREATE DATABASE 5Sep_2026_SQL_Lib;

-- 2 ways used to comment in sql
-- or 
/* by this way. */

/* example: to retreive data */


CREATE TABLE customersb(
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    city VARCHAR(100),
    plan_type VARCHAR(50)
);

INSERT INTO customersb(customer_id,name,age,gender,city,plan_type)
VALUES(1,'Emma Davis',34,'Female','Leeds','Premium'),
	  (2,'John Taylor',45,'Male','London','Basic');
 -- 1)select statement from table  
SELECT * FROM customersb;

-- 2)select only particular coloumns from table

SELECT 
	name,
	city,
	age
FROM customersb;

-- 3)for filter where is used
/*

order of execution:(priority)
from->where->Groupby->having->select->orderby
*/

SELECT *
FROM customersb;

SELECT 
	name,
	age,
	gender
FROM customersb
WHERE city="LONDON";

-- 4)ORDERBY - to sort the data(by default if not specify then: AESC). AESC->smallest to largest
                                                                    -- DESC-> largest to smallest


SELECT *
FROM customersb
ORDER BY CITY DESC;

-- example to add multiple data for practical purpose

CREATE TABLE car_launchesss(year int, company_name varchar(15), product_name varchar(30));

INSERT INTO car_launchess VALUES(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),(2020,'Chevrolet','Blazer'),(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler');

SELECT * FROM car_launchess;
DROP TABLE IF EXIsTS car_launchess;

/* 5)GROUP BY- 1)used to group the rows that have same values.
			   2)used in conjuction with aggreate functions.  
            rule: all the coloumn statment u specify in select must be aggregated or present must in group by statement. 
*/

SELECT * FROM Customer;
SELECT 
	country,
	SUM(score) AS Total_Score
FROM Customer
GROUP BY country;


SELECT *
FROM customersb;

/* 6)having- used to filter the results after GROUPBy query based on aggreate functions.*/


-- 7)Distinct:  used to list unique values in table

INSERT INTO customersb(customer_id,name,age,gender,city,plan_type)
VALUES(3,'babu',24,'Female','Leeds','Premium');

SELECT DISTINCT city FROM customersb;

-- 8)TOP(LIMIT): restricts return the number of rows
     -- TOP is not used in mysql, instead use LIMIT

Select *  FROM customersb
ORDER BY age DESC
LIMIT 2;

/* Coding order:      Execution order(numbering)

5)SELECT DICTINCT
  col1,
  sum(col2)
1)FROM Table
2)WHERE col1=2
3)GROUP BY col1
4)HAVING sum(col2)>45
6)ORDER BY col1 AESC
7)LIMIT 2
*/

-- to list all the databases
show databases;


-- DDL:(Data definition lanuguage)

-- 1) Create table:

CREATE TABLE persons(
	id INT,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(20) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY(id)
);

-- 2)ALTER Table

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;
SELECT * FROM persons;

ALTER TABLE persons
DROP EMAIL;
SELECT * FROM persons;

-- 3)DROP TABLE

DROP TABLE persons;

-- DML(Data Manipulation language):

USE 5Sep_2026_SQL_Lib;

CREATE TABLE persons(
	id INT,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(20) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY(id)
);

-- 1)INSERT

INSERT INTO persons(id,person_name,birth_date,phone)
VALUES(1,"rohan",NULL, "3456800007"),(2,"rocky",NULL, "8976500007"),(3,"priyansh",NULL, "5216477807");

SELECT * FROM persons;

-- 2)UPDATE 

UPDATE persons
SET phone = '88xxxxxx65'
WHERE person_name= "rocky";

SELECT * FROM persons;

-- SELECT * FROM persons;
-- WHERE person_name = "rocky";

-- 3)DELETE:

DELETE from persons
WHERE person_name="rohan";
SELECT * from persons;


SELECT * from persons
WHERE person_name="rohan";

-- 4)TRUNCATE : DElete all the data from the table (faster than delete command)

TRUNCATE table persons;

/* OPERATORS */

CREATE TABLE Customer(
	name VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	score int 
);
SELECT * FROM Customer;
INSERT INTO Customer()
Values("maria","Germany",350),("john","USA",900),("George","UK",750),("Martin","Germany",500),("peter","USA",0);
SELECT * FROM Customer;

-- 1)WHERE OPERATOR :(Comparison operators) =,!=,<,<=,>,>=
SELECT * FROM Customer
WHERE score>500;
SELECT * FROM Customer
WHERE score!=500;
SELECT * FROM Customer
WHERE score<=500;

-- 2)Logical operators: AND,OR,NOT

SELECT * FROM Customer;
SELECT * FROM Customer
WHERE score>=350 AND score<=900;
SELECT * FROM Customer
WHERE score>=350 OR score<=900;
SELECT * FROM Customer
WHERE NOT score >=500

-- 3)Range operator: BETWEEN(upper ceiling and lower ceiling included)

SELECT * FROM Customer;
SELECT * FROM Customer
WHERE score BETWEEN 500 AND 900;

-- 4)MEMBERSHIP Operator: IN ,NOTIN
SELECT * FROM Customer;
SELECT * FROM Customer
WHERE country IN ("Germany","USA");
SELECT * FROM Customer
WHERE country NOT IN ("Germany","USA");

-- 5)SEARCH OEPRATOR LIKE OPERATOR:%, _(to search for text in the pattern)
SELECT * FROM Customer;

-- first letter starts with U
SELECT * FROM Customer
WHERE country LIKE "U%";
-- last letter ends with A
SELECT * FROM Customer
WHERE country LIKE "%A";
-- third character should be r
SELECT * FROM Customer
WHERE country LIKE "__r%";

/* JOINS:1)BASIC->No,inner,left, right,full
         2)ADVANCED->left anti, right anti, full anti, cross 
*/

CREATE TABLE restaurent(
Name VARCHAR(30) NOT NULL UNIQUE,
Rating int NOT NULL,
Type VARCHAR(25) NOT NULL
);

INSERT INTO restaurent()
Values("Madan",4,"North/Chinese"),("Haldiram",4,"North/Chinese"),("ASAP",3,"Chinese"),("Udupi",4,"South");
SELECT * FROM restaurent;

ALTER TABLE restaurent
ADD ID int NOT NULL;
SELECT * FROM restaurent;
UPDATE restaurent
SET ID=1
WHERE Name="ASAP";
UPDATE restaurent
SET ID=2
WHERE Name="Haldiram";
UPDATE restaurent
SET ID=3
WHERE Name="Madan";
UPDATE restaurent
SET ID=4
WHERE Name="Udupi";
SELECT * FROM restaurent;

CREATE TABLE orderd(
Dish VARCHAR(30) NOT NULL UNIQUE,
price int NOT NULL,
Name VARCHAR(25) NOT NULL,
ID int NOT NULL
);
INSERT INTO orderd()
Values("Chole Bhauture",150,"andrew",3),("Dosa",250,"Shilpa",1),("Momos",100,"young",2),("roti",20,"puneet",5);

Drop table restaurent;
Select * FROM orderd;
Select * FROM restaurent;

-- 1)No join: return all the data from table without combing them

Select * FROM orderd;
Select * FROM restaurent;

-- 2) Inner join:return all matching data from tables
          --    Note: Order does not depend in this(table name.matching coloum)->to specify if same name of coloum arises.

Select * FROM orderd;
Select * FROM restaurent;

SELECT * 
FROM orderd
INNER JOIN restaurent
ON orderd.ID=restaurent.ID;

SELECT 
	o.Dish,
	o.price,
	r.Type,
	r.Name,
    o.ID
FROM orderd as o
INNER JOIN restaurent as r
ON o.ID=r.ID;

-- BY using left join also
SELECT * FROM restaurent as r
LEFT JOIN orderd as o
ON r.ID=o.ID
WHERE o.ID IS NOT NULL;


-- 3) Left join:return all data from left able +matching from right also
Select * FROM orderd;
Select * FROM restaurent;

SELECT *
FROM restaurent as r
LEFT JOIN orderd as o
ON r.ID=o.ID;

-- 4)RIGHT JOIN::return all the  right data +matchng from left

-- 5)FULL JOIN:return all data from right and left(not supported on MYSQL)
Select * FROM orderd;
Select * FROM restaurent;

SELECT * 
FROM orderd as o
FULL JOIN restaurent as r
ON o.id=r.ID;

-- ADVANCED JOIN:

-- 1)LEFT ANTI JOIN:DISPLAY the left rows without matching with right table
Select * FROM orderd;
Select * FROM restaurent;

SELECT * FROM restaurent as r
LEFT JOIN orderd as o
ON r.ID=o.ID
WHERE o.ID IS NULL;

-- 2)RIGHT ANTI JOIN:DISPLAY the RIGHT rows without matching with left table

-- 3 FULL ANTI JOIN: DISPlay all rows except matching
SELECT * FROM restaurent as r
FULL JOIN orderd as o
ON r.ID=o.ID
WHERE o.ID IS NULL OR r.ID IS NULL;

-- 4)CROSS JOIN: display all posible combinatins where (id are not matching)

SELECT * FROM restaurent as r
CROSS JOIN orderd as o

/* RULES OF SET OPERATOR:1)ORDERBy must be used only once(in the end).
					     2)number of coloumn  should be same.
                         3)datatype of column should be matched.
                         4)same order of coloumn.
						 5)column name in result set to be determined by column names specify in first query
 
*/

 CREATE TABLE Account(
 emp_id INT NOT NULL,
 name VARCHAR(20) NOT NULL,
 working_status VARCHAR(20) NOT NULL
 );
 
 CREATE TABLE Sales(
 emp_id INT NOT NULL,
 name VARCHAR(20) NOT NULL,
 working_status VARCHAR(20) NOT NULL
 );
 
 INSERT INTO Account()
 Values(1,"Rocky","HYBRID"),(3,"Saksi","HOME"),(2,"Renu","WFH");
 INSERT INTO Sales()
 Values(3,"Saksi","HOME"),(5,"Arjun","WFH"),(6,"Sara","HYBRID");

SELECT * FROM Account;
SELECT * FROM Sales;

-- 1)UNION: combination of 2 or more select statement, removes duplicate rows from result set.

SELECT * FROM Account
UNION
SELECT * FROM Sales;

-- 2)UNION ALL:return all number of rows ,including dupicate rows also.

SELECT * FROM Account
UNION ALL
SELECT * FROM Sales;

-- 3)EXCEPT: return all rows that are must present in first query not in second query.
SELECT * FROM Account;
SELECT * FROM Sales;
SELECT 
	name,
	working_status
FROM Account
EXCEPT
SELECT
	name,
	working_status 
FROM Sales;

-- 4)INTERSECT: return only the matching rows present in the query.

SELECT * FROM Account
INTERSECT
SELECT * FROM Sales;

/* FUNCTIONS */

USE  5Sep_2026_SQL_Lib;

CREATE TABLE func_demo(
First_Name VARCHAR(20) NOT NULL,
Last_Name VARCHAR(20) NOT NULL,
Val int NOT nuLl
);

INSERT INTO func_demo()
Values("Pihu","Mittal",5.298),("dev","Mittal",3.528),("Rohan","Yadav",-34),("ishita","bhatia",9.898),("rocky","agnihotri",89);

ALTER TABLE func_demo
ADD round float NOT NULL;

SELECT * FROM func_demo;

UPDATE func_demo
SET round=5.298
WHERE First_Name = "Pihu";
UPDATE func_demo
SET round=3.528
WHERE First_Name = "dev";
UPDATE func_demo
SET round=9.898
WHERE First_Name = "ishita";

/* (Single row function) -> String,numeric,date&time,Null.*/

-- 1)CONCAT,UPPER,LOWER,TRIM,REPLACE

SELECT 
First_Name,
Last_Name,
CONCAT(First_Name,Last_Name) "FULL NAME",
CONCAT(First_Name,"-",Last_Name) "FULL NAME WITH SPECIAL CHARACTER"
FROM
func_demo;

UPDATE func_demo
SET Last_Name="  Mittal"
WHERE  First_Name="dev";

SELECT * FROM func_demo;
SELECT 
Last_Name,
UPPER(Last_Name),
LOWER(Last_Name)
FROM 
func_demo;

SELECT 
Last_Name,
TRIM(Last_Name),
LENGTH(TRIM(Last_Name)),
LENGTH(Last_Name)
FROM 
func_demo;

SELECT REPLACE("XYZ FGH XYZ", "X", "M");
SELECT
"123-456-789" NUMBER,
REPLACE( "123-456-789","-","") ORIGINAL

SELECT * FROM func_demo;
SELECT
Last_Name,
LEFT(Last_Name,3) AS "LEFT", 
RIGHT(Last_Name,3) AS "RIGHT",
SUBSTRING(Last_Name,3,LENGTH(Last_Name)) SUBSTRING3,
SUBSTRING(Last_Name,3,4) NOTDYNAMIC
FROM
func_demo;
SELECT SUBSTRING_INDEX("www.w3schools.com", ".", 3);

SELECT
round,
ROUND(round,2),
ROUND(round,1),
ROUND(round,0),
ABS(-25),
ABS(-25.23),
ABS(25)
FROM
func_demo;

/* DATETIME:1)DATE
2)YEAR
3)MONTH
4)DATEPART
5)DATENAME
6)DATETRUNC
7)EOMONTH
*/

USE 5sep_2026_SQL_Lib;

-- SELECT CURRENT_TIMESTAMP ;
SELECT NOW() ;              -- current date and time
SELECT CURDATE();           -- Returns '2026-09-10'
-- SELECT CURRENT_DATE ;       -- current date
SELECT CURTIME() ;          -- current time '20:12:09'

SELECT * FROM orderd;
ALTER TABLE orderd
ADD running_time DATETIME NOT NULL DEFAULT NOW();
UPDATE orderd
SET running_time="2026-07-29 12:34:45"
WHERE ID=1;
UPDATE orderd
SET running_time="2024-11-18 18:32:12"
WHERE ID=5;
UPDATE orderd
SET running_time="2024-11-18 03:45:34"
WHERE ID=3;

SELECT * FROM orderd
WHERE YEAR(running_time)="2026";

SELECT LAST_DAY(CURDATE());
SELECT DAYOFWEEK(CURDATE());  -- returns the weekday index. ie.thursday =6,
SELECT EXTRACT(quarter FROM CURDATE());
SELECT EXTRACT(DAY FROM CURDATE());
SELECT DAY(CURDATE());
SELECT DAYNAME(CURDATE());
SELECT YEAR(CURDATE());

-- FORMAT ->Format Date and TIME.
SELECT * FROM orderd;
SELECT 
running_time,
DATE_FORMAT(running_time,"%d %b")
FROM orderd;

/*exists only in SQl.IN MYSql format is used for number only.
SELECT FORMAT(NOW(),"dd");
SELECT FORMAT(NOW(),"ddd");
SELECT FORMAT(NOW(),"dddd");
SELECT FORMAT(NOW(),"MM");
SELECT FORMAT(NOW(),"MMM");
SELECT FORMAT(NOW(),"MMM");
SELECT FORMAT(NOW(),"yy");
SELECT FORMAT(NOW(),"yyyy");*/


-- TIME
SELECT DATE_FORMAT(NOW(),"%p"); -- PM
SELECT DATE_FORMAT(NOW(),"%T"); -- 15:49:36
SELECT DATE_FORMAT(NOW(),"%r"); -- 03:49:26 PM
-- HOUR
SELECT DATE_FORMAT(NOW(),"%H"); -- 15
SELECT DATE_FORMAT(NOW(),"%h");  -- 03
SELECT DATE_FORMAT(NOW(),"%s"); -- 49
-- DATE:
SELECT DATE_FORMAT(NOW(),"%d");   -- ll
SELECT DATE_FORMAT(NOW(),"%D");  -- 11th
-- DAYNAME:
SELECT DATE_FORMAT(NOW(),"%W");  -- Friday
-- MONTH
SELECT DATE_FORMAT(NOW(),"%M"); -- September
SELECT DATE_FORMAT(NOW(),"%m");  -- 09
-- abc(easy to learn)
SELECT DATE_FORMAT(NOW(),"%a");  -- Fri
SELECT DATE_FORMAT(NOW(),"%b");  -- Sep
SELECT DATE_FORMAT(NOW(),"%c");  -- 9

-- CONVERT()- used to convert one datatype to another.
SELECT 
running_time,
CONVERT(running_time,DATE)
FROM orderd;

-- CAST()-to convert the value from one dattype to another

SELECT CAST('2024-11-18 03:45:34' AS DATE);


-- TO Add number of days/month/year
SELECT DATE_ADD(NOW(),INTERVAL 1 HOUR);
-- TO give only number of days(A-B)
SELECT DATEDIFF("2017-06-25", "2017-06-15");
-- to give number of days/year/month(B-A)
SELECT TIMESTAMPDIFF(year,"2001-01-16",NOW());

-- check isdate function equivalent for my sql after completing case when statement.

/*NULL FUNCTIONS*/
-- 1)To convert NULL into value:
-- 1)COALESCE:retuns the first not-NULL value from list
SELECT COALESCE(NULL,"1999-08-02"); 
-- 2)IFNULL():replaces NULL value with specific value
SELECT IFNULL(NULL, 500);


-- 2)TO CONVERT VALUE TO NULL
-- NULLIF: compares 2 expression and return NULL if both values are equal otherwise first value is returned.
SELECT NULLIF(45,100);

/* TIP:DATA POLICY: Always convert empty string ('') and blank space( ) into NULL into table to optimize performance and sort the data thereby after it.*/

/* --   CASE STATEMENT  */

SELECT * FROM Customer;
-- sort by country where according to score <800
SELECT 
country,
CASE
	WHEN score<800 THEN 1
	else 0
END Form
FROM Customer;

SELECT 
country,
SUM(CASE
	WHEN score<800 THEN 1
	else 0
END) Form
FROM Customer
GROUP BY country;

/* WINDOW FUNCTION BASICAS*/

-- Syntax: aggreate function() OVER() (PARTITION BY ORDER BY FRAME)

CREATE TABLE product_details(
order_id INT NOT NULL UNIQUE,
shipping_date DATE NOT NULL,
order_status VARCHAR(20) NOT NULL,
sales INT NOT NULL,
product_id INT NOT NULL
);

INSERT INTO product_details()
VALUES(1,"2025-01-01","Delivered",10,101),(3,"2025-01-10","Delivered",20,101),(8,"2025-02-18","Shipped",90,101),(9,"2025-03-10","Shipped",20,101),(7,"2025-02-15","Delivered",30,102);
INSERT INTO product_details()
VALUES(10,"2025-03-15","Shipped",60,102),(2,"2025-01-05","Shipped",15,102),(5,"2025-02-01","Delivered",25,104),(6,"2025-02-05","Delivered",50,104);

SELECT * FROM product_details;

/* NOTE:1)GROUP FUNCTIONS USED TO PERFROM ONLY SIMPLE ANALYTICS operation.
        2)For complex use cases use PARTITION BY with OVER CLAUSE.
*/

-- OVER():used with window function to define rows and perform cumulative,ranking totals etc.alter
-- Syntax: WINDOW fUCNTION OVER(PARTITON BY ORDER BY FRAME);


-- 1)PARTION BY:it divides the rows basis on coloumn.
SELECT * FROM product_details;
Select
    order_id,
    shipping_date,
	product_id,
    sales,
    order_status,
	SUM(sales) OVER (PARTITION BY product_id) TOTAL_Sales,
    SUM(sales) OVER (PARTITION BY product_id,order_status) TOTAL_Sales_order_status
FROM product_details;

/* Rules:1)window functions can only be used with orderby and select statement.
         2) Nested window function is not allowed ie.sum(sum() order())order ....
         3)Executes window functions after where clause.(priority where first than window functions)
         4)windows functions can be used with group by in same query if same columns are used.*/
         
-- 2)order by:must during value or ranking functions.

-- 3)FRAME: defines subset of rows within each window .
-- syntax: ROWS BETWEEN PRECEDING(A) AND UNBOUNDED FOLLOWING(B)
/* 1) (A)->current row,n preceding((no. of), unbounded preceding
   2)(b)->current row,n following(no. of), unbounded following.
   
  note: 1) A should be always smaller than B.
        2)frame clause can only be used with orderby  clause.alte
        3)by default it take:ie. ROWS UNBOUNDED PRECEDING AND CURRENT ROW(if not specify)
*/

SELECT * FROM product_details;
Select
    order_id,
    shipping_date,
	product_id,
    sales,
    order_status,
	 SUM(sales) OVER (PARTITION BY product_id) TOTAL_Sales
FROM product_details;

SELECT
DATE(running_time),
price,
SUM(price) OVER (ORDER BY running_time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM orderd;

-- 2)AGGREGATE FUNCTIONS:COUNT(*),count(coloumn),AVG(),SUM(),MIN(),MAX()
SELECT 
* 
FROM(
	SELECT
	order_id,
	sales,
	AVG(sales) OVER() AVG_SALES
	FROM product_details
)t WHERE sales>AVG_SALES;

/* 1)count(*):return total number of rows including NULL
   2)count(coloumn)-return the total number of rows including not-NULL values.
   3)MIN,MAX(Column):SELECT MAX AND MIN value from coloumn.
   4)AVG(coloumn): SELECT AVG from coloumn.
*/

SELECT MAX(product_id) FROM product_details MAX;
SELECT MIN(product_id) FROM product_details MIN;
SELECT AVG(product_id) FROM product_details AVG;
SELECT SUM(product_id) FROM product_details SUM;

/* RANKING FUNCTIONS:1)Integer Based Ranking:Row_number(),RANK(),DENSE_RANK(),NTILE(n)
                     2)Perchentage Based Ranking:CUME_DIST(),Percent_rank()
                     
Note:1)order by is must,cannot use frame clause with it.
*/
SELECT * FROM product_details;

-- 1)ROW_NUMBER():give the number to each row,cannot handle ties, unique value,no gaps

SELECT 
*,
ROW_NUMBER() OVER(ORDER BY product_id DESC) "Row_number"
FROM product_details;

-- 2)RANK()-give the rank to each row,can handle ties,gaps are there,shared value.
SELECT * FROM product_details;
SELECT 
*,
RANK() OVER(ORDER BY product_id DESC) "RANK"
FROM product_details;

-- 3)DENSE_RANK-give the rank to each row,handle ties, shared value,no gaps
USE 5Sep_2026_SQL_Lib;
SELECT 
*,
ROW_NUMBER() OVER(ORDER BY product_id DESC) "Row_number",
ROW_NUMBER() OVER(PARTITION BY order_status ORDER BY product_id DESC) "Row_number_partition",
RANK() OVER(ORDER BY product_id DESC) "RANK",
 RANK() OVER(PARTITION BY order_status ORDER BY product_id DESC) "Rank_partition",
DENSE_RANK() OVER(ORDER BY product_id DESC) "DENSE_rank",
 DENSE_RANK() OVER(PARTITION BY order_status ORDER BY product_id DESC) "Dense_partition"
FROM
product_details;

-- 4)NTILE(n):divides the data into subsets based on specific number of buckets;
-- Formula-BUCKET:No. of ROW/bucket_size(n),,,ie if odd value then larger part will take max size like(2.5 so 3, 3.5 so 4max) alter

SELECT *,
NTILE(4) OVER(ORDER BY product_id DESC) Bucket_size_4,
NTILE(3) OVER(ORDER BY product_id DESC) Bucket_size_3,
NTILE(2) OVER(ORDER BY product_id DESC) Bucket_size_2
FROM 
product_details;

-- 5)CUME_DIST():calculate the distribution of data_set within window
-- formula: current row number/total number of rows(if same value then calculate row number of for last value)

SELECT 
*,
ROUND((Cum_dist * 100),2) "per" 
FROM
(
SELECT 
*,
CUME_DIST() OVER(ORDER BY product_id DESC) "Cum_dist"
FROM 
product_details
)t;


-- 6)PERCENT_RANK():calculates the relative distribution for each row.
-- formula- (current row -1)/(no. of rows) -1  (if rows same then take first row number)
SELECT
*,
ROW_NUMBER() OVER(PARTITION BY pe_rank ORDER BY pe_rank) "row_number"
FROM
(
SELECT 
*,
PERCENT_RANK() OVER(ORDER BY product_id DESC) "pe_rank"
FROM 
product_details
)t;

-- HOW TO CHECK primary key in table
SELECT
*,
ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY SALES DESC) Primary_key
FROM 
product_details;

/* WINDOW VALUE FUNCTIONS:1)LEAD(coloumn,how many rows(default:1),if previous coloumn empty then NULL or u can specify the number).
                          2)LAG()
                          3)FIRST_VALUE()
                          4)LAST_VALUE() ie.. frame clause is must
                          
*/
-- find month-month performace by perchentage chage in sales b/w previous and current month
-- 1)LAG(expression):returns the value from previous row.if not present then show NULL
-- 2)LEAD(expression):returns the value from the next row.if not present then show NULL

SELECT * FROM product_details;

SELECT
*,
Current_sales - previous_sales AS MOM_change,
ROUND(CAST((Current_sales - previous_sales) AS FLOAT) / previous_sales * 100 ,2) perc
FROM
(
SELECT
MONTH(shipping_date) MONTH,
SUM(sales) Current_sales,
LAG(SUM(sales)) OVER(ORDER BY month(shipping_date)) previous_sales
FROM 
product_details
GROUP BY MONTH(shipping_date)
)t;

-- 3)FIRST_VALUE(expression):return the first value from the row in given window.
-- find highest aqnd lowest for each product id.

-- 4)LAST_VALUE(expression):return the last value from the row in the given window.(frame clause is must)

SELECT 
* ,
FIRST_VALUE(sales) OVER(PARTITION BY product_id ORDER BY sales) lowest_value,
LAST_VALUE(sales) OVER(PARTITION BY product_id ORDER BY sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highest_value,
MIN(sales) OVER(PARTITION BY product_id ORDER BY sales) MIN_value,
MAX(sales) OVER(PARTITION BY product_id ORDER BY sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) MAX_value
FROM 
product_details;




































 






   
 


























