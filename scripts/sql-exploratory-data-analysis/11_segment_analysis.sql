/* Segment products into cost ranges and count how man products fall into each segment */
With product_segments As(
Select 
product_key,
product_name,
cost,
Case When cost < 100 Then 'Below 100'
	 When cost Between 100 And 500 Then '100-500'
	 When cost Between 500 And 1000 Then '500-100'
	 Else 'Above 1000'
End cost_range
From gold.dim_products)

Select
cost_range,
count(product_key) As total_products
From product_segments
Group By cost_range
Order By total_products Desc

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than $5,000.
	- Regular: Customers with at least 12 months of history but spending $5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the toal number of customers by each group */

With customer_spending As (
Select 
c.customer_key,
Sum(f.sales_amount) As total_spending,
Min(order_date) As first_order,
Max(order_date) As last_order,
DATEDIFF(month, Min(order_date), Max(order_date)) As lifespan
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.customer_key)

Select 
customer_key,
total_spending,
lifespan,
Case When lifespan >= 12 And total_spending >5000 Then 'VIP'
	 When lifespan >= 12 And total_spending <= 5000 Then 'Regular'
	 Else 'New'
End customer_segment
From customer_spending

-- 3rd step
With customer_spending As (
Select 
c.customer_key,
Sum(f.sales_amount) As total_spending,
Min(order_date) As first_order,
Max(order_date) As last_order,
DATEDIFF(month, Min(order_date), Max(order_date)) As lifespan
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.customer_key)

Select customer_segment,
Count(customer_key) As total_customers
From (

	Select 
	customer_key,
	Case When lifespan >= 12 And total_spending >5000 Then 'VIP'
		 When lifespan >= 12 And total_spending <= 5000 Then 'Regular'
		 Else 'New'
	End customer_segment
	From customer_spending) t
Group By customer_segment
Order By total_customers Desc