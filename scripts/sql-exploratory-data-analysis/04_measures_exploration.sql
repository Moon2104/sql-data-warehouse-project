/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
Select Sum(sales_amount) As total_amount From gold.fact_sales

-- Find how many items are sold
Select Count(quanity) As total_quanity From gold.fact_sales

-- Find the average selling price
Select Avg(price) As Avg_price From gold.fact_sales

-- Find the Total number of orders
Select Count(order_number) As total_order From gold.fact_sales
Select Count(distinct order_number) As total_order From gold.fact_sales

-- Find the total number of produccts
Select Count(product_key) As total_product From gold.dim_products
Select Count(distinct product_key) As total_product From gold.dim_products

-- Find the total number os customers
Select Count(customer_number) As total_customer From gold.dim_customers

-- Find the total number of customers that has placed an order
Select 
Count(distinct customer_key) As total_customer
From gold.fact_sales

-- Generate a Report that shows all key metrics of the business
Select 'Total Sales' as measure_name, Sum(sales_amount) As measure_value From gold.fact_sales
Union All
Select 'Total Quanity' as measure_name, Sum(quanity) As measure_value From gold.fact_sales
Union All 
Select 'Average Price', AVG(price) From gold.fact_sales
Union All
Select 'Total Nr. Orders', Count(distinct order_number) from gold.fact_sales
Union All
Select 'Total Nr. Products', Count(product_name) From gold.dim_products
Union All
Select 'Total Nr.Customers', Count (customer_key) From gold.dim_customers