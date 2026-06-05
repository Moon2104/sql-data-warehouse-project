/*
======================================================================
Customer Report
======================================================================
Purpose:
- This report consolidates key costomer metrics and behaviors

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
	- total orders
	- total sales
	- total quanity purchased
	- total products
	- lifespan (in months)
4. Calculates valuable KPIs:
	- recency (months since last order)
	- average order value
	- average monthly spend
========================================================================
*/
Create View gold.report_customers As
With base_query As (

/*---------------------------------------------------------------------
1) Base Query: Retrives core columns from tables
-----------------------------------------------------------------------*/
Select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
Concat(c.first_name, ' ', c.last_name) as customer_name,
Datediff(Year, c.birthdate, Getdate ()) age
from gold.fact_sales f
Left Join gold.dim_customers c
On c.customer_key = f.customer_key
Where order_date Is Not Null
)
,customer_aggregation As (
Select 
customer_key,
customer_number,
customer_name,
age,
Count(Distinct order_number) As total_orders,
Sum(sales_amount) As total_sales,
Sum(quantity) As total_quantity,
Count(Distinct product_key) As total_order,
Max(order_date) As last_order_date,
DATEDIFF(month, Min(order_date), Max(order_date)) As lifespan
From base_query
Group By
	customer_key,
	customer_number,
	customer_name,
	age
)
Select
customer_key,
customer_number,
customer_name,
age,
Case	
	When age <20 Then 'Under 20'
	When age between 20 and 29 Then '20-29'
	When age between 30 and 39 Then '30-39'
	When age between 40 and 49 Then '40-49'
	Else '50 and above'
End As age_group,
Case 
	 When lifespan >= 12 And total_sales >5000 Then 'VIP'
	 When lifespan >= 12 And total_sales <= 5000 Then 'Regular'
	 Else 'New'
End customer_segment,
last_order_date,
Datediff(month, last_order_date, Getdate()) As recency,
total_orders,
total_sales,
total_quantity,
total_order,
lifespan,
-- Compute average order value (AVO)
Case	
	When total_sales = 0 Then 0
	Else total_sales/total_orders
End As avg_order_value,
-- Compute average monthly spend
Case	
	When lifespan = 0 Then total_sales 
	Else total_sales/lifespan
End As avg_monthly_spend
From customer_aggregation