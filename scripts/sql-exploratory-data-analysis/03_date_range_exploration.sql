/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
-- Find the date of the first and last order
Select 
Min(order_date) first_order_date,
Max(order_date) As last_order_date,
DATEDIFF(year,min(order_date), Max(order_date)) As order_range_year,
DATEDIFF(month,min(order_date), Max(order_date)) As order_range_month
From gold.fact_sales

-- Find how many years, months of sales are available
Select 
DATEDIFF(year,min(order_date), Max(order_date)) As order_range_year,
DATEDIFF(month,min(order_date), Max(order_date)) As order_range_month
From gold.fact_sales

-- Find the youngest and oldest customer based on birthdate
-- Find the youngest and oldest customer
Select
Min(birthdate) As oldest_birthday,
DATEDIFF(year, Min(birthdate), Getdate()) As oldest_age,
Max(birthdate) As youngest_birthday,
DATEDIFF(year,Max(birthdate), Getdate()) As youngest_age
From gold.dim_customers

-- Find the age of oldest and youngest customer
Select 
DATEDIFF(year, Min(birthdate), Getdate()) As oldest_age,
DATEDIFF(year,Max(birthdate), Getdate()) As youngest_age
From gold.dim_customers