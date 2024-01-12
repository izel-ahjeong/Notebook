-- Combining tables

SELECT *
FROM orders
JOIN subscriptions
  ON orders.subscription_id = subscriptions.subscription_id;



SELECT *
FROM orders
JOIN subscriptions
  ON orders.subscription_id = subscriptions.subscription_id
WHERE subscriptions.description = 'Fashion Magazine';


-- Inner Joins

SELECT COUNT(id)
FROM newspaper;

SELECT COUNT(id)
FROM online;

SELECT COUNT(*)
FROM newspaper
JOIN online
  ON newspaper.id = online.id;


-- Left Joins

SELECT *
FROM newspaper
LEFT JOIN online
  ON newspaper.id = online.id;

SELECT *
FROM newspaper
LEFT JOIN online
  ON newspaper.id = online.id
WHERE online.id IS NULL;


-- Primary Key

SELECT *
FROM classes
JOIN students
  ON classes.id = students.class_id;


-- Cross Join

SELECT COUNT(*)
FROM newspaper
WHERE start_month <= 3 AND end_month >= 3;

SELECT *
FROM newspaper
CROSS JOIN months;

SELECT *
FROM newspaper
CROSS JOIN months
WHERE start_month <= month 
 AND end_month >= month;

SELECT month, COUNT(*)
FROM newspaper
CROSS JOIN months
WHERE start_month <= month
 AND end_month >= month
GROUP BY month;


-- Union

SELECT *
FROM newspaper
UNION 
SELECT *
FROM online;


-- With
-- 한 테이블이 계산된 후 combine 되어야 할 때 사용

WITH previous_query AS (
   SELECT customer_id,
      COUNT(subscription_id) AS 'subscriptions'
   FROM orders
   GROUP BY customer_id
)
SELECT customers.customer_name, 
   previous_query.subscriptions
FROM previous_query
JOIN customers
  ON previous_query.customer_id = customers.customer_id;