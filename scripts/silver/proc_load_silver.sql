/*
=======================================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
=======================================================================================================
Sript Purpose:
	This stored procedure performs the ETL (Extract, Transform, Load) process to populate 
	the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
	- Truncates Silver tables.
	- Inserts transformed and cleansed data from Bronze inot Silver tables.

Parameters:
	None.
	This stored procedure doses not accept any parameteres or return any values.

Usage Example:
	Exec silver.load_silver;
========================================================================================================
*/


/*Create store procedure layer */
Create Or Alter Procedure silver.load_silver As
Begin
/* Track ETL Duration, helps to identify bottleneks, optimize performance, monitor trends, detect issues */
	Declare @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime;

	/* Try block and if it fails, it run the catch */
	Begin Try
		Set @batch_start_time = GETDATE();
		Print'======================================================';
		Print 'Loading Silver Layer';
		Print'======================================================';

		Print'------------------------------------------------------';
		Print'Loading CRM Tables';
		Print'------------------------------------------------------';
		
		
--Loading silver.crm_cust_info
/* Calulate the start and end loading time */
	Set @start_time = Getdate();

	Print 'Truncating Table: silver.crm_cust_info';

	/* to avoid duplicate load/data first empty and then load */
	Truncate Table silver.crm_cust_info;

	/* Insert data in silver.crm_cust_info in bulk insert */
	Print '>>Inserting Data Into: silver.crm_cust_info';

	Insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

	select
	cst_id,
	cst_key,
	Trim (cst_firstname) As cst_firstname,
	Trim (cst_lastname) As cst_lastname,
	Case When Upper(Trim (cst_marital_status)) = 'M' then 'Married'
		 When Upper (Trim (cst_marital_status)) = 'S' then 'Single'
		 Else 'n/a'
	End As cst_marital_status,

	Case When Upper(Trim (cst_gndr)) = 'F' then 'Female'
		 When Upper (Trim (cst_gndr)) = 'M' then 'Male'
		 Else 'n/a'
	End As cst_gndr,
	cst_create_date
	from (

	Select *,
	Row_Number() over (Partition by cst_id Order by cst_create_date DESC) as flag_last
	from bronze.crm_cust_info 
	Where cst_id Is Not Null
	)t where flag_last= 1;

	Set @end_time = Getdate();
	Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	Print '>>-----------------------';

	-- Loading silver.crm_prd_info'

	/* Calulate the start and end loading time */
	Set @start_time = Getdate();

	Print 'Truncating Table: silver.crm_prd_info';
	Truncate Table silver.crm_prd_info;
	Print '>>Inserting Data Into: silver.crm_prd_info';
	Insert Into silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt 
	)
	Select
	prd_id,
	REPLACE (SUBSTRING(prd_key,1,5), '-', '_') As cat_id, 
	Substring(prd_key, 7, Len(prd_key)) As prd_key,
	prd_nm,
	Isnull(prd_cost, 0) As prd_cost,
	Case Upper (Trim(prd_line))
		 When 'M' Then 'Mountain'
		 When 'R' Then 'Road'
		 When 'S' Then 'Other Sales'
		 When 'T' Then 'Touring'
		 Else 'n/a'
	End As prd_line,
	Cast (prd_start_dt As Date) As prd_start_dt,
	Cast(Lead(prd_start_dt) Over (Partition By prd_key Order By prd_start_dt)-1 As Date) As prd_end_dt 
	From bronze.crm_prd_info

	Set @end_time = Getdate();
	Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	Print '>>-----------------------';


	-- Loading silver.crm_sales_details
	/* Calulate the start and end loading time */
	Set @start_time = Getdate();

	Print 'Truncating Table: silver.crm_sales_details';
	Truncate Table silver.crm_sales_details;
	Print '>>Inserting Data Into: silver.crm_sales_details';

	Insert Into silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
	SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	Case When sls_order_dt = 0 Or len(sls_order_dt) !=8 Then Null
		Else Cast (Cast(sls_order_dt As varchar) As Date)
	End As sls_order_dt,

	Case When sls_ship_dt = 0 Or len(sls_ship_dt) !=8 Then Null
		Else Cast (Cast(sls_ship_dt As varchar) As Date)
	End As sls_ship_dt,

	Case When sls_due_dt = 0 Or len(sls_due_dt) !=8 Then Null
		Else Cast (Cast(sls_due_dt As varchar) As Date)
	End As sls_due_dt,

	Case When sls_sales Is Null Or sls_sales <=0 Or sls_sales != sls_quantity * ABS(sls_price)
			Then sls_quantity * ABS(sls_price)
		Else sls_sales
	End As sls_sales,

	sls_quantity,

	Case When sls_price Is Null Or sls_price <= 0
			Then sls_sales /Nullif (sls_quantity,0)
		Else sls_price
	End As sls_price
	FROM bronze.crm_sales_details

	Set @end_time = Getdate();
	Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	Print '>>-----------------------';

	Print'------------------------------------------------------';
	Print'Loading ERP Tables';
	Print'------------------------------------------------------';

	-- Loading silver.erp_cust_az12

	/* Calulate the start and end loading time */
	Set @start_time = Getdate();

	Print 'Truncating Table: silver.erp_cust_az12';
	Truncate Table silver.erp_cust_az12;
	Print '>>Inserting Data Into: silver.erp_cust_az12';

	Insert Into silver.erp_cust_az12 (
	cid,
	bdate,
	gen
	)

	SELECT 

	Case When cid like 'NAS%'then SUBSTRING (cid, 4,len(cid))
		Else cid
	End As cid,

	Case When bdate > GETDATE() Then Null
		Else bdate
	End As bdate,

	Case When Upper(Trim(gen)) In ('F', 'Female') Then 'Female'
		 When Upper(Trim(gen)) In ('M', 'Male') Then 'Male'
		Else 'n/a'
	End As gen
	FROM bronze.erp_cust_az12

	-- Loading silver.erp_loc_a104

	/* Calulate the start and end loading time */
	Set @start_time = Getdate();

	Print 'Truncating Table: silver.erp_loc_a101';
	Truncate Table silver.erp_loc_a101;
	Print '>>Inserting Data Into: silver.erp_loc_a101';

	Insert Into silver.erp_loc_a101(
	cid,
	cntry)

	Select 
	Replace(cid,'-', '')cid,
	Case When Trim(cntry) = 'DE' Then 'Germany'
		 When Trim(cntry) In ('US', 'USA') Then 'United States'
		 When Trim(cntry) = '' Or cntry Is Null Then 'n/a'
		 Else Trim(cntry)
	End As cntry
	From bronze.erp_loc_a101

	Set @end_time = Getdate();
	Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	Print '>>-----------------------';


	-- Loading silver.erp_px_cat_g1v2

	/* Calulate the start and end loading time */
	Set @start_time = Getdate();

	Print 'Truncating Table: silver.erp_px_cat_g1v2';
	Truncate Table silver.erp_px_cat_g1v2;
	Print '>>Inserting Data Into: silver.erp_px_cat_g1v2';

	Insert Into silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
	)
	Select
	id,
	cat,
	subcat,
	maintenance
	From bronze.erp_px_cat_g1v2

	Set @end_time = Getdate();
	Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	Print '>>-----------------------';

	Set @batch_end_time = GETDATE();
		Print '==============================================================='
		Print 'Loading Silver Layer is completed';
		Print ' - Total Load Duration:' + Cast(Datediff(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';

End Try

	/* Catch block to handle the error. Catch only run if the SQL fail */
	Begin Catch
		Print '===================================================='
		Print 'ERROR OCCRED DURING LOADING SILVER LAYER'
		Print 'Error Message' + Error_Message();
		Print 'Error Message' + Cast (Error_Number() AS NVARCHAR);
		Print 'Error Message' + Cast (Error_State() AS NVARCHAR);
		Print '===================================================='

	End Catch
End
