SELECT * FROM users;
SELECT * FROM countries;
SELECT * FROM sessions_data;

/*SELECT 
sd.action_type,
COUNT( sd.action_type)
FROM users uu
JOIN sessions_data sd
ON uu.id=sd.user_id
GROUP BY sd.action_type;
*/
-- HAVING sd.user_id='aorw0bjocs'
-- ORDER BY COUNT(DISTINCT sd.device_type) DESC;

/*SELECT 
COUNT(id)
FROM 
users
WHERE first_device_type="iPhone";
*/

/*
SELECT 
country_destination,
COUNT(country_destination)
FROM 
users
GROUP BY country_destination;
*/

-- 3 table join
/*
SELECT 
uu.signup_method,
COUNT(id)
FROM users uu
JOIN sessions_data sd
ON uu.id=sd.user_id
JOIN countries cc
ON cc.country_destination=uu.country_destination
 WHERE uu.gender='FEMALE'
GROUP BY uu.signup_method;
*/


/*SELECT 
sd.user_id AS "user_id",
COUNT(DISTINCT sd.action)
FROM users uu
JOIN sessions_data sd
ON uu.id=sd.user_id
WHERE sd.secs_elapsed > 10000
GROUP BY sd.user_id 
ORDER BY user_id DESC
LIMIT 5;
*/
-- GROUP BY sd.action_type;

SELECT
    user_id,
    COUNT(*) AS session_count
FROM sessions_data
WHERE user_id IN (
    SELECT DISTINCT user_id
    FROM sessions_data
    WHERE secs_elapsed > 10000
)
GROUP BY user_id
ORDER BY session_count DESC
LIMIT 5;

SELECT DISTINCT user_id
    FROM sessions_data
    WHERE secs_elapsed > 10000;
 
SELECT * FROM users;
SELECT * FROM countries;
SELECT * FROM sessions_data;
SELECT 
uu.gender AS "gender",
uu.signup_method AS "signup_method",
COUNT(*)
FROM users uu
JOIN sessions_data sd
ON uu.id=sd.user_id
JOIN countries cc
ON cc.country_destination=uu.country_destination
WHERE uu.date_first_booking IS NOT NULL AND uu.country_destination!="NDF"
GROUP BY uu.gender,uu.signup_method;


SELECT
    COALESCE(gender, 'NULL') AS gender,
    signup_method,
    COUNT(*) AS booking_count
FROM users
WHERE date_first_booking IS NOT NULL
  AND date_first_booking <> ''
  AND country_destination IS NOT NULL
  AND country_destination <> ''
  AND country_destination <> 'NDF'
GROUP BY gender, signup_method;


SELECT * FROM users;

SELECT
    country_destination,
    ROUND(AVG(age), 2) AS average_age
FROM users
WHERE date_first_booking IS NOT NULL
  AND date_first_booking <> ''
  AND age IS NOT NULL
  AND country_destination IS NOT NULL
  AND country_destination <> 'NDF'
GROUP BY country_destination
ORDER BY average_age ASC;

SELECT count(*) 
FROM users
WHERE age>100;

SELECT
    u.id AS id,
    COUNT(s.user_id) AS session_count
FROM users u
JOIN sessions_data s ON u.id = s.user_id
WHERE u.country_destination = 'US'
GROUP BY u.id
HAVING COUNT(id) < 5
ORDER BY session_count DESC;
    
SELECT
    s.action,
    s.device_type,
    COUNT(*) AS action_count
FROM users u
JOIN sessions_data s ON u.id = s.user_id
WHERE u.country_destination != 'NDF'
GROUP BY s.action, s.device_type
ORDER BY action_count DESC
LIMIT 5;

-- check average time spent(error)
SELECT
    s.action_type,
    s.device_type,
    AVG(s.secs_elapsed) AS avg_time_spent
FROM users u
JOIN sessions_data s ON u.id = s.user_id
WHERE u.country_destination != 'NDF'
  AND s.secs_elapsed IS NOT NULL
GROUP BY s.action_type, s.device_type
ORDER BY avg_time_spent DESC;

ALTER TABLE sessions_data
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Step 2: Find the top 10 action pairs by total time spent
WITH windows_actions AS (
    SELECT
        s.id,
        s.user_id,
        s.action,
        s.secs_elapsed
    FROM users u
    JOIN sessions_data s ON u.id = s.user_id
    WHERE u.country_destination != 'NDF'
      AND s.device_type = 'Windows Desktop'
),
action_pairs AS (
    SELECT
        user_id,
        action AS action_1,
        LEAD(action) OVER (PARTITION BY user_id ORDER BY id) AS action_2,
        secs_elapsed AS time_1,
        LEAD(secs_elapsed) OVER (PARTITION BY user_id ORDER BY id) AS time_2
    FROM windows_actions
)
SELECT
    action_1,
    action_2,
    COUNT(*) AS pair_frequency,
    SUM(COALESCE(time_1, 0) + COALESCE(time_2, 0)) AS total_time_spent
FROM action_pairs
WHERE action_2 IS NOT NULL
GROUP BY action_1, action_2
ORDER BY total_time_spent DESC
LIMIT 10;


SELECT
    first_affiliate_tracked,
    COUNT(*) AS total_users,
    SUM(country_destination <> 'NDF') AS total_bookings,
    ROUND(
        SUM(country_destination <> 'NDF') / COUNT(*) * 100,
        4
    ) AS conversion_rate
FROM users
GROUP BY first_affiliate_tracked
ORDER BY first_affiliate_tracked;

SELECT
    s.action_type,
    s.device_type,
    AVG(s.secs_elapsed) AS avg_time_spent
FROM sessions_data s
JOIN users u
    ON s.user_id = u.id
WHERE u.country_destination <> 'NDF'
  AND s.secs_elapsed IS NOT NULL
GROUP BY
    s.action_type,
    s.device_type
ORDER BY
    avg_time_spent DESC;

-- new data
WITH CTE_1 AS(
    SELECT 
    STR_TO_DATE(date,"%Y-%m-%d %H:%i:%s") AS "new_date_type",  --  '2018-01-01 21:35:10'
    amount,
    card
    FROM 
    transaction
),CTE_2 AS (
	SELECT 
	card,
    DATEDIFF("2018-12-31",MAX(new_date_type)) AS Recency,
    COUNT(card) AS "Frequency",
	ROUND(SUM(amount),2) AS "Monetary"
	FROM CTE_1
	GROUP BY card
)
SELECT * FROM CTE_2;
SELECT * FROM transaction;

-- new data
SELECT * FROM user_rfm;
-- average :40(monetary)
-- average:184(recndcy)

SELECT 
CASE
 WHEN Recency<184 AND Monetary>40 THEN "Active High Spenders"
 WHEN Recency>184 AND Monetary>40 THEN "Inactive High Spenders"
 WHEN Recency<184 AND Monetary<40 THEN "Active Low Spenders"
 ELSE "Inactive Low Spenders"
END "Customer_Segment",
COUNT(*) AS "Segment_Count"
FROM
user_rfm
GROUP BY Customer_Segment;

-- new table

WITH CTE_1 AS(
SELECT 
CAST(date as DATE) AS "upd_Dat"
FROM 
transaction
),CTE_2 AS(
SELECT 
EXTRACT(QUARTER FROM upd_Dat) AS "qua",
upd_Dat
FROM 
CTE_1
)
SELECT 
CONCAT(DATE_FORMAT(upd_Dat,"%Y"),"0",RIGHT(qua,1)) AS YearQuarter,
COUNT(*) AS "Transaction_Count"
FROM 
CTE_2
GROUP BY YearQuarter;

-- new data

SELECT 
OrderID AS orderID,
OrderDate AS orderdate,
CASE
WHEN CAST(DATE_FORMAT(OrderDate,"%c") AS SIGNED) IN(1,2,3) THEN DATE_FORMAT(DATE_ADD(OrderDate,INTERVAL (4-MONTH(OrderDate)) MONTH),'%Y-%m-01')
WHEN CAST(DATE_FORMAT(OrderDate,"%c") AS SIGNED) IN(4,5,6) THEN DATE_FORMAT(DATE_ADD(OrderDate,INTERVAL (7-MONTH(OrderDate)) MONTH),'%Y-%m-01')
WHEN CAST(DATE_FORMAT(OrderDate,"%c") AS SIGNED) IN(7,8,9) THEN DATE_FORMAT(DATE_ADD(OrderDate,INTERVAL (10-MONTH(OrderDate)) MONTH),'%Y-%m-01')
WHEN CAST(DATE_FORMAT(OrderDate,"%c") AS SIGNED) IN(10,11,12) THEN DATE_FORMAT(DATE_ADD(OrderDate,INTERVAL +1 YEAR),'%Y-01-01')
END AS next_quarter_start
FROM
orders;

WITH CTE_1 AS(
SELECT 
OrderID,
EmployeeID,
DATEDIFF("1997-02-28",DATE_FORMAT(OrderDate,"%Y-%m-%d"))  as "daydi"
FROM orders
)
SELECT 
OrderID AS orderID,
EmployeeID AS employeeid,
daydi AS days_since_order
FROM 
CTE_1
WHERE daydi<=30;

USE datasset_test_20sep;
SELECT * FROM categories;

-- SQL TEST-1 questions-practise:
SELECT * FROM users;
SELECT * FROM countries;
SELECT * FROM sessions_data;

-- SELECT DISTINCT affiliate_channel FROM users;
WITH CTE_1 AS(
SELECT 
affiliate_channel,
COUNT(*) AS total_users,
SUM(CASE
    WHEN country_destination !='NDF' THEN 1
    ELSE 0
    END) AS bookings
FROM
users
GROUP BY affiliate_channel
)
SELECT 
affiliate_channel,
total_users,
bookings,
ROUND(bookings/total_users * 100,4) AS conversion_rate
FROM
CTE_1
ORDER BY conversion_rate DESC;


WITH booked_users AS (
    SELECT id
    FROM users
    WHERE country_destination <> 'NDF'
),
action_pairs AS (
    SELECT
        s1.action AS action_1,
        s2.action AS action_2,
        COUNT(*) AS frequency,
        SUM(s1.secs_elapsed + s2.secs_elapsed) AS total_time_spent
    FROM sessions_data s1
    JOIN sessions_data s2
        ON s1.user_id = s2.user_id
       AND s1.device_type = s2.device_type
       AND s1.action <= s2.action
    JOIN booked_users u
        ON s1.user_id = u.id
    WHERE s1.device_type = 'Windows Desktop'
      AND s2.device_type = 'Windows Desktop'
      AND s1.secs_elapsed IS NOT NULL
      AND s2.secs_elapsed IS NOT NULL
    GROUP BY s1.action, s2.action
)
SELECT
    action_1,
    action_2,
    frequency,
    total_time_spent
FROM action_pairs
ORDER BY total_time_spent DESC
LIMIT 10;

--
SELECT * FROM Countries;
SELECT * FROM Currencies;
SELECT * FROM Merchants;
SELECT * FROM Transactions;
SELECT * FROM Users;


-- ----(monthnly transactions)
SELECT
m.merchant_id,
m.business_name,
YEAR(t.transaction_date) AS transaction_year,
MONTH(t.transaction_date) AS transaction_month,
ROUND(SUM(t.transaction_amount),2) AS total_transaction_amount,
CASE
WHEN SUM(t.transaction_amount) > 50000
THEN "Exceeded $50,000"
ELSE "Did Not Exceed $50,000"
END AS performance_status
FROM Transactions t
JOIN Merchants m
ON t.recipient_id = m.merchant_id
WHERE t.transaction_date >="2023-11-01"
AND t.transaction_date < "2024-05-02"
GROUP BY
m.merchant_id,
m.business_name,
YEAR(t.transaction_date),
MONTH(t.transaction_date)
ORDER BY
merchant_id ,transaction_year,transaction_month;

-- (Customer engagement)
SELECT
u.user_id,
u.email
FROM Users u
JOIN Transactions t
ON u.user_id=t.sender_id
WHERE t.transaction_date >='2023-05-01'
AND t.transaction_date< "2024-05-01"
GROUP BY
u.user_id,
u.email
HAVING COUNT(DISTINCT YEAR( t.transaction_date) * 100 + MONTH(t.transaction_date)) >=6
ORDER BY
u.user_id;

-- GROUP WISE
SELECT
YEAR(t.transaction_date) AS transaction_year,
MONTH(t.transaction_date) AS transaction_month,
CASE
WHEN 
t.transaction_amount > 10000
THEN "High Value"
ELSE "Regular"
END AS value_category,
CASE
WHEN sender.country_id = recipient.country_id
THEN "Domestic"
ELSE "International"
END AS location_category,

ROUND(SUM(t.transaction_amount),2) AS total_amount,
ROUND(AVG(t.transaction_amount),2) AS average_amount
FROM transactions t

JOIN Users sender
ON t.sender_id = sender.user_id
JOIN Users recipient
ON t.recipient_id = recipient.user_id

WHERE t.transaction_date >= "2023-01-01" AND t.transaction_date < "2024-01-01"
GROUP BY
YEAR(t.transaction_date),
MONTH(t.transaction_date),
CASE
WHEN t.transaction_amount > 10000
THEN "High Value"
ELSE "Regular"
END,
CASE
WHEN sender.country_id = recipient.country_id
THEN "Domestic"
ELSE "International"
END
ORDER BY
transaction_year,transaction_month,value_category,location_category;

-- transaction_behaviour
SELECT
u.user_id,
u.email,
ROUND(AVG(t.transaction_amount),2) AS avg_amount
FROM Users u
JOIN Transactions t
ON u.user_id=t.sender_id
WHERE t.transaction_date >="2023-11-01"
AND t.transaction_date < "2024-05-01"
GROUP BY
u.user_id,
u.email
HAVING AVG(t.transaction_amount) > 5000
ORDER BY
u.user_id;

-- loyal customers
SELECT 
u.user_id,
u.email,
u.name,
ROUND(SUM(t.transaction_amount),2) AS total_amount
FROM Users u
JOIN Transactions t
ON u.user_id=t.sender_id
WHERE t.transaction_date >= "2023-05-22"
AND t.transaction_date < "2024-05-22"
GROUP BY
u.user_id,
u.name,
u.email
ORDER BY total_amount DESC
LIMIT 1;

-- AVerage amount
SELECT * FROM Countries;
SELECT * FROM Currencies;
SELECT * FROM Merchants;
SELECT * FROM Transactions;
SELECT * FROM Users;
SELECT 
*
FROM 
Transactions t
JOIN Users b 
ON t.sender_id=b.user_id
JOIN Merchants k
ON t.recipient_id=k.merchant_id;



SELECT
    CASE
        WHEN t.transaction_amount > 10000
             AND sender.country_id <> recipient.country_id
            THEN 'High Value International'

        WHEN t.transaction_amount > 10000
             AND sender.country_id = recipient.country_id
            THEN 'High Value Domestic'

        WHEN t.transaction_amount <= 10000
             AND sender.country_id <> recipient.country_id
            THEN 'Regular International'

        ELSE 'Regular Domestic'
    END AS transaction_category,
    COUNT(*) AS transaction_count
FROM Transactions t
JOIN Users sender
    ON t.sender_id = sender.user_id
JOIN Merchants recipient
    ON t.recipient_id = recipient.merchant_id
WHERE t.transaction_date >= '2023-01-01'
  AND t.transaction_date < '2024-01-01'
GROUP BY transaction_category;

CREATE DATABASE NEW_24sep;


USE NEW_24sep;


SELECT * FROM Countries;
SELECT * FROM Currencies;
SELECT * FROM Merchants;
SELECT * FROM Transactions;
SELECT * FROM Users;
SELECT 
*
FROM 
Transactions t
JOIN Users b 
ON t.sender_id=b.user_id
JOIN Merchants k
ON t.recipient_id=k.merchant_id;



--  

SELECT
    CASE
        WHEN t.transaction_amount > 10000
             AND sender.country_id != recipient.country_id
            THEN 'High Value International'

        WHEN t.transaction_amount > 10000
             AND sender.country_id = recipient.country_id
            THEN 'High Value Domestic'

        WHEN t.transaction_amount <= 10000
             AND sender.country_id != recipient.country_id
            THEN 'Regular International'

        ELSE 'Regular Domestic'
    END AS transaction_category,
    COUNT(*) AS transaction_count
FROM Transactions t
JOIN Users sender
    ON t.sender_id = sender.user_id
JOIN Merchants recipient
    ON t.recipient_id = recipient.merchant_id
WHERE t.transaction_date >= '2023-01-01'
  AND t.transaction_date < '2024-01-01'
GROUP BY transaction_category;



SELECT 
CASE
WHEN t.transaction_amount > 10000 AND sender.country_id != recipient.country_id 
THEN "High Value International"
WHEN t.transaction_amount > 10000 AND sender.country_id = recipient.country_id 
THEN "High Value Domestic"
WHEN t.transaction_amount <= 10000 AND sender.country_id != recipient.country_id 
THEN "Regular International"
ELSE "Regular Domestic"
END AS transaction_category,
COUNT(*) AS transaction_count
FROM 
Transactions t
JOIN Users sender
ON t.sender_id=sender.user_id
JOIN Merchants recipient
ON t.recipient_id=recipient.merchant_id
WHERE t.transaction_date >="2023-01-01" AND t.transaction_date < "2024-01-01"
GROUP BY transaction_category;

-- monthly transactions

SELECT
YEAR(transaction_date) AS transaction_year,
MONTH(transaction_date) AS transaction_month,
SUM(transaction_amount) AS total_amount
FROM transactions
WHERE transaction_date >="2023-01-01" AND transaction_date <  "2024-01-01"
GROUP BY
YEAR(transaction_date),
MONTH(transaction_date)
ORDER BY
transaction_year,transaction_month;

-- nature of transaction:

SELECT
    CASE
        WHEN sender.country_id <> recipient.country_id
            THEN 'International'
        ELSE 'Domestic'
    END AS transaction_type,
    COUNT(*) AS transaction_count
FROM Transactions t
JOIN Users sender
    ON t.sender_id = sender.user_id
JOIN Merchants recipient
    ON t.recipient_id = recipient.merchant_id
WHERE t.transaction_date >= '2024-01-01'
  AND t.transaction_date < '2024-04-01'
GROUP BY transaction_type;

SELECT * FROM Users;
SELECT * FROM Transactions;
SELECT * FROM Merchants;



SELECT
    CASE
        WHEN u.country_id <> m.country_id
            THEN 'International'
        ELSE 'Domestic'
    END AS transaction_type,
    COUNT(*) AS transaction_count
FROM Transactions t
JOIN Users u
    ON t.sender_id = u.user_id
JOIN Merchants m
    ON t.recipient_id = m.merchant_id
WHERE t.transaction_date >= '2024-01-01'
  AND t.transaction_date < '2024-04-01'
GROUP BY
    transaction_type;
    
-- transaction classification
SELECT  
CASE
WHEN transaction_amount>10000 THEN "High Value"
ELSE "Regular"
END AS transaction_category,
SUM(transaction_amount) AS total_amount
FROM transactions
WHERE YEAR(transaction_date)="2023"
GROUP BY transaction_category;

-- conversion trends
WITH currency_summary AS (
SELECT
currency_code,
SUM(transaction_amount) as total_converted,
COUNT(*) AS transaction_count
FROM
Transactions 
WHERE transaction_date >="2023-05-22" AND transaction_date < "2024-05-22"
GROUP BY currency_code
),
ranked_currency AS
(
SELECT
currency_code,
total_converted,
transaction_count,
ROW_NUMBER() OVER(ORDER BY transaction_count DESC) AS currency_rank 
FROM currency_summary
)
SELECT
currency_code,
total_converted
FROM
ranked_currency 
WHERE currency_rank<=3
ORDER BY total_converted DESC;

-- Merchant performance
SELECT
m.merchant_id,
m.business_name,
SUM(t.transaction_amount) AS total_received,
AVG(t.transaction_amount) AS average_transaction
FROM
Transactions t
JOIN Merchants m
ON t.recipient_id = m.merchant_id
WHERE t.transaction_date >="2023-11-01" AND t.transaction_date < "2024-05-01"
GROUP BY
m.merchant_id,
m.business_name
ORDER BY
total_received DESC
LIMIT 10;

-- Transaction amount
SELECT
    c.country_name AS country,
    ROUND(SUM(t.transaction_amount), 2) AS total_sent
FROM Transactions t
JOIN Users u
    ON t.sender_id = u.user_id
JOIN Countries c
    ON u.country_id = c.country_id
WHERE t.transaction_date >= '2023-10-01'
  AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_sent DESC
LIMIT 5;

SELECT
    c.country_name AS country,
    ROUND(SUM(t.transaction_amount), 2) AS total_received
FROM Transactions t
JOIN Merchants m
    ON t.recipient_id = m.merchant_id
JOIN Countries c
    ON m.country_id = c.country_id
WHERE t.transaction_date >= '2023-10-01'
  AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_received DESC
LIMIT 5;


SELECT
    c.country_name,
    ROUND(SUM(t.transaction_amount), 2) AS total_received
FROM Transactions t
JOIN Merchants m
    ON t.recipient_id = m.merchant_id
JOIN Countries c
    ON m.country_id = c.country_id
WHERE t.transaction_date >= '2023-10-01'
  AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_received DESC
LIMIT 3;

-- High value transactions
SELECT 
transaction_id,
sender_id,
recipient_id,
transaction_amount,
currency_code 
FROM Transactions
WHERE transaction_amount >10000 AND YEAR(transaction_date)="2023";

-- average amount
WITH merchant_totals AS (
    SELECT
    m.merchant_id,
    m.business_name,
    SUM(t.transaction_amount) AS total_received,
    AVG(t.transaction_amount) AS average_transaction_amount
    FROM Transactions t 
    JOIN Merchants m
    ON t.recipient_id = m.merchant_id
    WHERE  t.transaction_date >="2023-11-01" AND t.transaction_date < "2024-05-01"
    GROUP BY
    m.merchant_id,
    m.business_name
)
SELECT
merchant_id,
business_name,
ROUND(total_received,2) AS total_received,
CASE
WHEN total_received > 50000 THEN "Excellent"
WHEN total_received > 20000 THEN "Good"
WHEN total_received > 10000 THEN "Average"
ELSE "Below Average"
END AS performance_score,
ROUND(average_transaction_amount,2) AS average_transaction
FROM merchant_totals
ORDER BY total_received DESC;

-- conversion trends
WITH currency_summary AS (
SELECT
currency_code,
SUM(transaction_amount) as total_converted,
COUNT(*) AS transaction_count
FROM
Transactions 
WHERE transaction_date >="2023-05-22" AND transaction_date < "2024-05-22"
GROUP BY currency_code
),ranked_currency AS(
SELECT
currency_code,
total_converted,
transaction_count,
ROW_NUMBER() OVER(ORDER BY transaction_count DESC) AS currency_rank 
FROM
currency_summary
)
SELECT * FROM ranked_currency;
/*SELECT
currency_code,
total_converted
FROM
ranked_currency 
WHERE currency_rank<=3
ORDER BY total_converted DESC;*/