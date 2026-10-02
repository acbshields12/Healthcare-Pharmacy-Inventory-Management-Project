create database pharmacy_inventory;
use pharmacy_inventory;

create table meds_data (
medication_id varchar(10),
medication_name varchar(50),
category varchar(50),
supplier varchar(50),
stock_quantity int,
reorder_level int,
unit_price decimal (10, 2),
expiry_date date,
purchase_date date,
inventory_value int,
stock_days varchar(50),
days_to_expire int,
expiry_status varchar(50)
);

create table sales_data (
sales_id varchar(10),
medication_id varchar(10),
quantity_sold int,
sale_date date
);

select *
from meds_data;

select *
from sales_data;

-- Total Revenue --
select sum(s.quantity_sold * m.unit_price) as total_revenue
from sales_data s
join meds_data m
on s.medication_id = m.medication_id;

-- Total Quantity Sold --
select sum(quantity_sold) as total_sold
from sales_data;

-- Inventory Value --
select sum(stock_quantity * unit_price) as inventory_value
from meds_data;

-- Remove Duplicates --
select medication_id,count(*)
from meds_data
group by medication_id
having count(*) >1;

-- Low Stock Medication --
select medication_name, stock_quantity, reorder_level
from meds_data
where stock_quantity < reorder_level;

select count(*) as low_stock_count
from meds_data
where stock_quantity < reorder_level;

-- Out of Stock --
select count(*)
from meds_data
where stock_quantity = 0;

-- Expiring Soon --
select count(*) as expiring_soon
from meds_data
where expiry_date <= curdate() + interval 30 day;


-- Expiring Soon --
select medication_name, expiry_date, days_to_expire
from meds_data
where days_to_expire <= 30;

-- Top Selling Medication --
select m.medication_name, sum(s.quantity_sold) as total_sold
from sales_data as s
join meds_data as m
on m.medication_id = s.medication_id
group by m.medication_name
order by total_sold desc;

-- Monthly Revenue --
select 
    DATE_FORMAT(s.sale_date, '%Y-%m') as 'month',
    m.medication_name,
    SUM(s.quantity_sold * m.unit_price) AS total_revenue
from sales_data s
join meds_data m
    on s.medication_id = m.medication_id
group by DATE_FORMAT(s.sale_date, '%Y-%m'), m.medication_name
order by DATE_FORMAT(s.sale_date, '%Y-%m');

-- Revenue per Medication --
select 
    m.medication_name,
    sum(s.quantity_sold) as total_quantity_sold,
    sum(s.quantity_sold * m.unit_price) as total_revenue
from sales_data s
join meds_data m
    on s.medication_id = m.medication_id
group by m.medication_name
order by total_revenue DESC;

-- Top 5 Medicines --
select m.medication_name, 
sum(s.quantity_sold * m.unit_price) as total_revenue
from sales_data as s
join meds_data as m
on m.medication_id = s.medication_id
group by m.medication_name
order by total_revenue desc
limit 5;

-- Medications with Above Average Sales --
SELECT medication_name, total_revenue
FROM (
    SELECT 
        m.medication_name,
        SUM(s.quantity_sold * m.unit_price) AS total_revenue
    FROM sales_data s
    JOIN meds_data m
        ON s.medication_id = m.medication_id
    GROUP BY m.medication_name
) AS revenue_table
WHERE total_revenue > (
    SELECT AVG(total_rev)
    FROM (
        SELECT SUM(s.quantity_sold * m.unit_price) AS total_rev
        FROM sales_data s
        JOIN meds_data m
            ON s.medication_id = m.medication_id
        GROUP BY m.medication_id
    ) AS avg_table
);

-- Medications with Below Avergae Sales --
SELECT m.medication_name, SUM(s.quantity_sold) AS total_sold
FROM sales_data s
JOIN meds_data m
    ON s.medication_id = m.medication_id
GROUP BY m.medication_name
HAVING total_sold < (
    SELECT AVG(total_qty)
    FROM (
        SELECT SUM(quantity_sold) AS total_qty
        FROM sales_data
        GROUP BY medication_id
    ) AS avg_sales
);

-- Medications Never Sold --
SELECT medication_name
FROM meds_data
WHERE medication_id NOT IN (
    SELECT DISTINCT medication_id
    FROM sales_data
);

-- Month with Highest Total Revenue --
SELECT month, total_revenue
FROM (
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') AS month,
        SUM(s.quantity_sold * m.unit_price) AS total_revenue
    FROM sales_data s
    JOIN meds_data m
        ON s.medication_id = m.medication_id
    GROUP BY month
) AS monthly
WHERE total_revenue = (
    SELECT MAX(total_rev)
    FROM (
        SELECT 
            SUM(s.quantity_sold * m.unit_price) AS total_rev
        FROM sales_data s
        JOIN meds_data m
            ON s.medication_id = m.medication_id
        GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m')
    ) AS max_table
);

-- Category with Highest Revenue --
SELECT category, total_revenue
FROM (
    SELECT 
        m.category,
        SUM(s.quantity_sold * m.unit_price) AS total_revenue
    FROM sales_data s
    JOIN meds_data m
        ON s.medication_id = m.medication_id
    GROUP BY m.category
) AS t
WHERE total_revenue = (
    SELECT MAX(cat_rev)
    FROM (
        SELECT 
            SUM(s.quantity_sold * m.unit_price) AS cat_rev
        FROM sales_data s
        JOIN meds_data m
            ON s.medication_id = m.medication_id
        GROUP BY m.category
    ) AS sub
);

-- Average Revenue per Med --
SELECT 
  SUM(s.quantity_sold * m.unit_price) / (SELECT COUNT(*) FROM meds_data) AS avg_revenue
FROM sales_data s
JOIN meds_data m ON s.medication_id = m.medication_id;
    

SELECT 
  SUM(s.quantity_sold * m.unit_price) AS total_revenue,
  COUNT(DISTINCT s.medication_id)     AS meds_with_sales,  -- likely ~109
  COUNT(DISTINCT m.medication_id)     AS total_meds,       -- should be 1000
  SUM(s.quantity_sold * m.unit_price) / COUNT(DISTINCT m.medication_id) AS avg_correct
FROM sales_data s
JOIN meds_data m ON s.medication_id = m.medication_id;