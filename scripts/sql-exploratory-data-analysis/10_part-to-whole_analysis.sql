-- Which categories contribute the most to overall sales?
With category_sales As (
Select 
category,
Sum(sales_amount) As total_sales
From gold.fact_sales f
Left Join gold.dim_products p
On p.product_key = f.product_key
Group By category
)
Select
category,
total_sales,
Sum(total_sales) Over () As overall_sales,
Concat(Round((Cast(total_sales AS Float)/ Sum(total_sales) Over ()) *100,2),'%') As percentage_of_total
From category_sales
Order By total_sales Desc