-- Create database
CREATE DATABASE EniolaSql_Project;

-- Use database
USE EniolaSql_Project;

-- Creating table
CREATE TABLE orders(
order_number VARCHAR(25),
sales_date VARCHAR(25),
sales_channel VARCHAR(25),
currency CHAR(3),
salesteam_index INT,
store_index INT,
product_index INT,
order_qty INT,
unit_price Decimal(5,2), 
unit_cost Decimal(5,2)
);

UPDATE orders
SET sales_date = STR_TO_DATE(sales_date, '%M/%D/%Y');

CREATE TABLE salesteam(
salesteam_id INT,
sales_team VARCHAR(45),
salesteam_region VARCHAR(25)
);

CREATE TABLE products(
product_id INT,
product_name VARCHAR(25),
product_category VARCHAR(25)
);

CREATE TABLE store(
store_id INT,
store_name VARCHAR(25),
state_code CHAR(2),
state VARCHAR(25)
);

-- ALTER TABLE
ALTER TABLE orders
ADD COLUMN sales_price DECIMAL(6,2),
ADD COLUMN cost_price DECIMAL(6,2),
ADD COLUMN profit DECIMAL(6,2);

SELECT
order_qty,
unit_price,
unit_cost,
(order_qty * unit_price) AS sales_price,
(order_qty * unit_price) - (order_qty * unit_cost) AS profit,
(order_qty * unit_cost) AS cost_price
FROM orders;

UPDATE orders
SET sales_price = order_qty * unit_price,
cost_price = order_qty * unit_cost,
profit = (order_qty * unit_price) - (order_qty * unit_cost);

-- JOINING THE TABLES
CREATE TABLE joint_table AS
SELECT 
orders.order_number,
orders.sales_date,
orders.sales_channel,
orders.currency,
salesteam.sales_team,
salesteam.salesteam_region,
store.state,
store.store_name,
products.product_name,
products.product_category,
orders.order_qty,
orders.unit_price,
orders.unit_cost,
orders.sales_price,
orders.cost_price,
orders.profit
FROM orders
LEFT JOIN products ON orders.product_index = products.product_id
LEFT JOIN salesteam ON orders.salesteam_index = salesteam.salesteam_id
LEFT JOIN store ON orders.store_index = store.store_id;

select *
from joint_table;

-- 1.
SELECT sum(sales_price) AS "Total_sales_revenue"
FROM joint_table;

-- 2.
SELECT product_name, order_number, order_qty
FROM joint_table
WHERE sales_channel IN ("distributor",  "in-store");

-- 3.
SELECT *
FROM joint_table
WHERE sales_team = "nicholas cunningham";

-- 4.
SELECT *
FROM joint_table
WHERE order_qty > (SELECT avg(order_qty) FROM joint_table);

-- 5.
SELECT product_name, sum(order_qty) as order_qtys
FROM joint_table
GROUP BY product_name
ORDER BY order_qtys DESC
LIMIT 10;

-- 6.
SELECT count(order_number)
FROM joint_table
WHERE state = "alabama";

-- 7.
SELECT *
FROM joint_table
WHERE order_number = "SO471";

-- 8.
SELECT salesteam_region, round(avg(profit), 2) as avg_profit
FROM joint_table
GROUP BY salesteam_region
ORDER BY avg(profit) DESC;

-- 9. 
SELECT *
FROM joint_table
WHERE sales_price > (SELECT avg(sales_price) FROM joint_table);

-- 10. 
SELECT product_category, count(order_number) as no_orders
FROM joint_table
GROUP BY product_category
HAVING no_orders >= 2000
ORDER BY no_orders DESC;

-- 11. 
SELECT product_name,sum(order_qty) as total_qty_ordered, round(avg(unit_price), 2) as avg_price
FROM joint_table
GROUP BY product_name
ORDER BY avg_price DESC
LIMIT 5;

SELECT product_name,sum(order_qty) as total_qty_ordered, round(avg(unit_price), 2) as avg_price
FROM joint_table
GROUP BY product_name
ORDER BY avg_price ASC 
LIMIT 5;






																							

