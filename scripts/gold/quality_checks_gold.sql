/* 
=========================================================================
Quality Checks
=========================================================================
Script purpose:
	This script performs quality checks to validate the integrity, consistency,
	and accuracy of the Gold Layer. These checks ensure:
	- Uniqueness of surrogate keys in dimention tables.
	- Referential integrity between fact and dimension tables.
	- Validation of relationships in the data model for analytical purposes.
Usage Notes:
	- Run these checks after data loading Silver Layer.
	- Investigate and resolve any discrepeancies found durnign the checks.
===========================================================================
*/

-- =========================================================================
-- Checking 'gold.dim_customers'
-- =========================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expection: No Results

Select 
	customer_key,
	Count(*) As duplicate_count
From gold.dim_customers
Group By customer_key
Having Count(*) > 1;

-- ===========================================================
-- Checking 'gold.product_key'
-- ===========================================================
-- Check for Uniqueness of Product Key in gold.dim.products
-- Expectation: No Results
Select
	product_key,
	Count(*) As duplicate_count
From gold.dim_products
Group By product_key
Having Count(*) >1;

-- ===========================================================
-- Checking 'gold.fact_sales
-- ===========================================================
-- Check the data model connectivity between fact and dimension
Select *
From gold.fact_sales f
Left Join gold.dim_customers c
On	c.customer_key = f.customer_key
Left Join gold.dim_products p
On	p.product_key = f.product_key
Where p.product_key Is Null Or c.customer_number Is Null
