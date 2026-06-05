/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */

-- Analyze the yearly performance of products
With yearly_product_sales As(	-- create CTE for camparing sales and aveage sales
Select 
Year(f.order_date) AS order_year,
p.product_name,
Sum(f.sales_amount) As current_sales
From gold.fact_sales f
Left Join gold.dim_products p
On f.product_key = p.product_key
Where f.order_date Is Not Null
Group By Year(f.order_date),p.product_name
)
Select 
order_year,
product_name,
current_sales,
AVG(current_sales) Over (Partition By Product_name) avg_sales,
current_sales - AVG(current_sales) Over (Partition By Product_name) diff_avg,
-- Flag indicator whether sales is above or below agv
Case When current_sales - AVG(current_sales) Over (Partition By Product_name) > 0 Then 'Above Avg'
	 When current_sales - AVG(current_sales) Over (Partition By Product_name) <0 Then 'Below Avg'
	 Else 'Avg'
End avg_change,
-- Year-over-year Analysis
Lag(current_sales) Over (Partition By Product_name Order By order_year) py_sales, -- window functon to find pervious year sales
current_sales - Lag(current_sales) Over (Partition By Product_name Order By order_year) diff_py, --difference between previous year sales
Case When current_sales - Lag(current_sales) Over (Partition By Product_name Order By order_year) > 0 Then 'Increase'
	 When current_sales - Lag(current_sales) Over (Partition By Product_name Order By order_year) <0 Then 'Decrease'
	 Else 'No change'
End py_change
From yearly_product_sales
Order By product_name, order_year