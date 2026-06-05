/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
-- Explore countries our customers come from
Select distinct country
From gold.dim_customers

-- Retrieve a list of unique categories, subcategories, and products
-- Explore All categories "The Major Divisions"
Select distinct category, subcategory,product_name
From gold.dim_products
Order By 1,2,3