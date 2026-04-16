/*
-- ======================================================================================
-- Quilty Checks
-- ======================================================================================
Script Purpose:
	This script performs various quiality checks for data consistency accuracy,
	and standardization across the 'silver' schemas. It includes checks for:
	- Null or duplicate primary keys.
	- Unwanted spaces in string fields.
	- Data statndardization and consistency.
	- Invalid data ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading Silver Layer.
	- Investigate and resolve and discrepancies found during the checks.
==========================================================================================
*/

-- ============================================================
-- Checking 'silver.crm_cust_info'
-- ============================================================
-- Check For Nulls or Duplicate in Primary Key
-- Expectation: No Result

Select  cst_id,
Count(*)
From silver.crm_cust_info
Group By cst_id
Having Count  (*) >1 or cst_id Is Null

-- Check for unwanted Spaces
-- Expectation: No Results
select cst_key
from silver.crm_cust_info
where cst_key!= TRIM (cst_key)

-- Data Standardization & Consistency
Select Distinct cst_gndr
From silver.crm_cust_info

-- Data Standardization & Consistency
Select Distinct 
	cst_marital_status
From silver.crm_cust_info

-- ============================================================
-- Checking 'silver.crm_prd_info'
-- ============================================================
-- Check For Nulls or Dupliates in Primary Key
--Expection : No Result
Select 
prd_id,
Count(*)
From silver.crm_prd_info
Group by prd_id
Having Count(*) > 1 or prd_id Is Null

-- Check for unwanted Spaces
-- Expectation: No Results
Select prd_nm
From silver.crm_prd_info
Where prd_nm != Trim(prd_nm)

-- Check for Null or Negative Numbers
-- Expectation: No Results
select prd_cost
From silver.crm_prd_info
Where prd_cost <0 or prd_cost Is Null

--Data Standardization & Consistency
Select Distinct Prd_line
From silver.crm_prd_info

-- Check for Invalid Date Orders
Select *
From silver.crm_prd_info
Where prd_end_dt < prd_start_dt

-- ============================================================
-- Checking 'silver.crm_sales_details'
-- ============================================================
-- Check for Invalid date sls_due_dt
Select
nullif(sls_due_dt, 0) sls_due_dt
From silver.crm_sales_details
Where sls_due_dt <= 0 
	OR len(sls_due_dt) !=8
	OR sls_due_dt > 20200101
	OR sls_due_dt <19000101

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
Select
*
From silver.crm_sales_details
Where sls_order_dt > sls_ship_dt 
	OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >>Sales = Quantity * Price
-- >> Values must not be Null, Zero, Or Negative.

Select Distinct 
sls_sales,
sls_quantity,
sls_price
From silver.crm_sales_details
Where sls_sales != sls_quantity * sls_price
	Or sls_sales Is Null 
	Or sls_quantity Is Null 
	Or sls_price Is Null
	Or sls_sales <= 0 
	Or sls_quantity <= 0 
	Or sls_price <= 0
Order By sls_sales, sls_quantity, sls_price
Select * From silver.crm_sales_details

-- ============================================================
-- Checking 'silver.erp_cust_az12'
-- ============================================================
-- Identify Out-Of-Range dates
-- Expection: Birthdates between 1924-01-01 and Today
Select distinct
bdate
From silver.erp_cust_az12
-- check for very old customers/future date
Where bdate < '1924-01-01' 
	Or bdate > GETDATE()

-- Data Standarization and Consistency
Select Distinct
gen
From silver.erp_cust_az12

-- ============================================================
-- Checking 'silver.erp_loc_a101'
-- ============================================================

--Data Standardization & Consistency
Select Distinct 
cntry 
From silver.erp_loc_a101
Order by cntry

-- ============================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ============================================================

-- Check unwanted spaces
-- Expectation: No Results

Select *
From silver.erp_px_cat_g1v2
Where cat != Trim(cat)
	Or subcat!= Trim(subcat) 
	Or maintenance!= Trim(maintenance)

--Data Standardization & Consistency
Select Distinct 
	maintenance
From sliver.erp_px_cat_g1v2
