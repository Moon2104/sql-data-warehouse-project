Select 
order_date,
Sum(sales_amount) as total_sales
From gold.fact_sales
Where order_date Is Not Null
Group By order_date
Order by order_date

-- -- Aggregate data by year
Select 
Year(order_date),
Sum(sales_amount) as total_sales
From gold.fact_sales
Where order_date Is Not Null
Group By Year(order_date)
Order by Year(order_date)

-- Add dimension like total customers use distinct for not duplicate the customers
Select 
Year(order_date),
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers
From gold.fact_sales
Where order_date Is Not Null
Group By Year(order_date)
Order by Year(order_date)

-- Add measure quanity
Select 
Year(order_date),
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers,
Sum(quanity) as total_quanity
From gold.fact_sales
Where order_date Is Not Null
Group By Year(order_date)
Order by Year(order_date)

-- Aggregate data by month
Select 
Month(order_date),
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers,
Sum(quanity) as total_quanity
From gold.fact_sales
Where order_date Is Not Null
Group By Month(order_date)
Order by Month(order_date)

-- Aggregate data by month and year
Select 
Year(order_date) as order_year,
Month(order_date) as order_month,
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers,
Sum(quanity) as total_quanity
From gold.fact_sales
Where order_date Is Not Null
Group By Year(order_date), Month(order_date)
Order By Year(order_date), Month(order_date)

-- Datetrunc Function to farmat the date
Select 
DateTrunc(Month,order_date) as order_date,
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers,
Sum(quanity) as total_quanity
From gold.fact_sales
Where order_date Is Not Null
Group By DateTrunc(Month,order_date)
Order By DateTrunc(Month,order_date)

-- Datetrunc Function to farmat the granularity of year
Select 
DateTrunc(YEAR,order_date) as order_date,
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers,
Sum(quanity) as total_quanity
From gold.fact_sales
Where order_date Is Not Null
Group By DateTrunc(YEAR,order_date)
Order By DateTrunc(YEAR,order_date)

-- Disyplay date in specific Format 
Select 
Format(order_date, 'yyyy-MMM') as order_date,
Sum(sales_amount) as total_sales,
Count(Distinct customer_key) as total_customers,
Sum(quanity) as total_quanity
From gold.fact_sales
Where order_date Is Not Null
Group By Format(order_date, 'yyyy-MMM')
Order By Format(order_date, 'yyyy-MMM')