/*
======================================================================
Product Report
======================================================================
Purpose:
- This report consolidates key product metrics and behaviors

Highlights:
1. Gathers essential fields such as product names, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
	- total orders
	- total sales
	- total quanity sold
	- total products
	- lifespan (in months)
4. Calculates valuable KPIs:
	- recency (months since last order)
	- average order value (AOR)
	- average monthly revenue
========================================================================
*/
Create View gold.report_products As
With base_query As (

/*---------------------------------------------------------------------
1) Base Query: Retrives core columns from fact_sales and dim_products
-----------------------------------------------------------------------*/
Select 
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
From gold.fact_sales f
Left Join gold.dim_products p
On f.product_key = p.product_key
Where order_date Is Not Null -- only consider valid sales dates
)
, product_aggregation AS(

/*--------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
-------------------------------------------------------------------------*/
Select
product_key,
product_name,
category,
subcategory,
cost,
Datediff(month, Min(order_date), Max(order_date)) As lifespan,
Max(order_date) As last_sale_date,
Count(Distinct order_number) As total_orders,
Count(Distinct customer_key) As total_customers,
Sum(sales_amount) As total_sales,
Sum(quantity) As total_quantity,
Round(AVG(CAST(Sales_amount As Float) / Nullif(quantity, 0)),1) As avg_selling_price
From base_query
Group By
	product_key,
	product_name,
	category,
	subcategory,
	cost
)
/*-----------------------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
------------------------------------------------------------------------------------------*/
Select 
product_key,
product_name,
category,
subcategory,
cost,
last_sale_date,
Datediff(month, last_sale_date, Getdate()) As recency_in_months,
	Case When total_sales > 50000 Then 'High-Performer'
		 When total_sales >= 10000 Then 'Mid-Range'
		 Else 'Low-Performer'
	End As product_segment,
lifespan,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,

-- Compute average order revenue (AOR)
Case	
	When total_sales = 0 Then 0
	Else total_sales/total_orders
End As avg_order_revenue,

-- Compute average monthly spend
Case	
	When lifespan = 0 Then total_sales 
	Else total_sales/lifespan
End As avg_monthly_revenue

From product_aggregation
