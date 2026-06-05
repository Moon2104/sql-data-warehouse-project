-- Calculate the total sales per month
-- and the running total sales over time
Select 
order_date,
total_sales,
-- Window function running_total_sale
Sum(total_sales) Over(Partition By order_date Order By order_date) As running_total_sales 
From
(
Select 
Datetrunc(Month,order_date) As order_date,
Sum(sales_amount) As total_sales
From gold.fact_sales
Where order_date Is Not Null
Group By Datetrunc(Month,order_date)
)t

-- Calculate the total sales per year
-- and the running total sales over time
Select 
order_date,
total_sales,
-- Window function running_total_sale
Sum(total_sales) Over(Order By order_date) As running_total_sales 
From
(
Select 
Datetrunc(YEAR,order_date) As order_date,
Sum(sales_amount) As total_sales
From gold.fact_sales
Where order_date Is Not Null
Group By Datetrunc(YEAR,order_date)
)t

-- Calculate the total sales per year
-- and the running total sales over time
-- and moving average price
Select 
order_date,
total_sales,
-- Window function running_total_sale
Sum(total_sales) Over(Order By order_date) As running_total_sales, 
AVG(avg_price) Over(Order By order_date) As moving_averge_price
From
(
Select 
Datetrunc(YEAR,order_date) As order_date,
Sum(sales_amount) As total_sales,
Avg(price) As avg_price
From gold.fact_sales
Where order_date Is Not Null
Group By Datetrunc(YEAR,order_date)
)t