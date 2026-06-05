-- Which 5 products genrate the highest revenue?
Select Top 5
p.product_name,
Sum(f.sales_amount) total_revenue
From gold.fact_sales f
Left Join gold.dim_products p
On p.product_key = f.product_key
Group By p.product_name
Order By total_revenue Desc
-- What are the 5 worst-performing products in terms of sales?
Select Top 5
p.product_name,
Sum(f.sales_amount) total_revenue
From gold.fact_sales f
Left Join gold.dim_products p
On p.product_key = f.product_key
Group By p.product_name
Order By total_revenue

-- Which 5 sub-category genrate the highest revenue?
Select Top 5
p.subcategory,
Sum(f.sales_amount) total_revenue
From gold.fact_sales f
Left Join gold.dim_products p
On p.product_key = f.product_key
Group By p.subcategory
Order By total_revenue Desc

-- What are the 5 worst-performing sub-category in terms of sales?
Select Top 5
p.subcategory,
Sum(f.sales_amount) total_revenue
From gold.fact_sales f
Left Join gold.dim_products p
On p.product_key = f.product_key
Group By p.subcategory
Order By total_revenue

-- Which 5 products genrate the highest revenue using window function?
Select *
From (
Select
p.product_name,
Sum(f.sales_amount) total_revenue,
Row_Number() Over (Order By Sum(f.sales_amount) Desc) As rank_products
From gold.fact_sales f
Left Join gold.dim_products p
On p.product_key = f.product_key
Group By p.product_name) t
Where rank_products <= 5

-- Find the top 10 customers who have genrate the highest revenue?
Select Top 10
c.customer_key,
c.first_name,
c.last_name,
Sum(f.sales_amount) total_revenue
From gold.fact_sales f
Left Join gold.dim_customers c
On c.customer_key = f.customer_key
Group By c.customer_key,
c.first_name,
c.last_name
Order By total_revenue Desc

-- Find the 3 customers with the fewest orders placed
Select Top 3
c.customer_key,
c.first_name,
c.last_name,
Count(Distinct order_number) total_orders
From gold.fact_sales f
Left Join gold.dim_customers c
On c.customer_key = f.customer_key
Group By c.customer_key,
c.first_name,
c.last_name
Order By total_orders