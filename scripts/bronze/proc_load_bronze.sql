/*
=================================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=================================================================================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  -  Uses the 'BULK INSERT' command to load data from csv files to bronze tables.

Parameters:
  None.
This stored procedure doses not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;
===================================================================================================================
*/


*Create store procedure layer */
Create or Alter Procedure bronze.load_bronze As
Begin
/* Track ETL Duration, helps to identify bottleneks, optimize performance, monitor trends, detect issues */
	Declare @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime;

/* Try block and if it fails, it run the catch */
	Begin Try
		Set @batch_start_time = GETDATE();
		Print'======================================================';
		Print 'Loading Bronze Layer';
		Print'======================================================';

		Print'------------------------------------------------------';
		Print'Loading CRM Tables';
		Print'------------------------------------------------------';
		
		/* Calulate the start and end loading time */
		Set @start_time = Getdate();

		Print '>> Truncationg Table: bronze.crm_cust_info';
		/* to avoid duplicate load/data first empty and then load */
		Truncate Table bronze.crm_cust_info 

		Print '>> Inserting Data Into: bronze.crm_cust_info';
		/* Insert data in bronze.crm_cust_info in bulk insert */

		Bulk Insert bronze.crm_cust_info 
		From 'C:\Users\xavier\Documents\Mona. R. Azim Doc\Baraa\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'

		With (
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		Set @end_time = Getdate();
		Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		Print '>>-----------------------';

		/* Quality check "check that the data has not shifted and is in the correct column */
		Select * from bronze.crm_cust_info

		/* Count the row inside the table */
		Select count (*) from bronze.crm_cust_info 

		Set @start_time = Getdate();
		
		Print '>> Truncate Table: bronze.crm_prd_info';
		/* to avoid duplicate load/data first empty and then load */
		Truncate Table bronze.crm_prd_info 

		Print '>> Inserting Data Into: bronze.crm_prd_info';
		/* Insert data in bronze.crm_prd_info in bulk insert */

		Bulk Insert bronze.crm_prd_info 
		From 'C:\Users\xavier\Documents\Mona. R. Azim Doc\Baraa\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'

		With (
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		Set @end_time = Getdate();
		Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		Print '>>-----------------------';

		/* Quality check "check that the data has not shifted and is in the correct column */
		Select * from bronze.crm_prd_info

		/* Count the row inside the table */
		Select count (*) from bronze.crm_prd_info 

		Set @start_time = Getdate();
		
		Print '>> Truncate Table: bronze.crm_sales_details';

		/* to avoid duplicate load/data first empty and then load */
		Truncate Table bronze.crm_sales_details


		Print '>> Inserting Data Into: bronze.crm_sales_details';
		/* Insert data in bronze.crm_sales_details in bulk insert */

		Bulk Insert bronze.crm_sales_details
		From 'C:\Users\xavier\Documents\Mona. R. Azim Doc\Baraa\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'

		With (
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		Set @end_time = Getdate();
		Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		Print '>>-----------------------';

		/* Quality check "check that the data has not shifted and is in the correct column */
		Select * from bronze.crm_sales_details

		/* Count the row inside the table */
		Select count (*) from bronze.crm_sales_details


		Print'------------------------------------------------------';
		Print'Loading ERP Tables';
		Print'------------------------------------------------------';


		Set @start_time = Getdate();
		
		Print '>> Truncate Table: bronze.erp_cust_az12';

		/* to avoid duplicate load/data first empty and then load */
		Truncate Table bronze.erp_cust_az12

		Print '>> Inserting Data Into: bronze.erp_cust_az12';
		/* Insert data in bronze.erp_cust_az12 in bulk insert */

		Bulk Insert bronze.erp_cust_az12
		From 'C:\Users\xavier\Documents\Mona. R. Azim Doc\Baraa\SQL\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'

		With (
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		Set @end_time = Getdate();
		Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		Print '>>-----------------------';

		/* Quality check "check that the data has not shifted and is in the correct column */
		Select * from bronze.erp_cust_az12

		/* Count the row inside the table */
		Select count (*) from bronze.erp_cust_az12


		Set @start_time = Getdate();
		
		Print '>> Truncate Table: bronze.erp_loc_a101';
		/* to avoid duplicate load/data first empty and then load */
		Truncate Table bronze.erp_loc_a101

		Print '>> Inserting Data Into: bronze.erp_loc_a101';
		/* Insert data in bronze.erp_loc_a101 in bulk insert */

		Bulk Insert bronze.erp_loc_a101
		From 'C:\Users\xavier\Documents\Mona. R. Azim Doc\Baraa\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'

		With (
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		Set @end_time = Getdate();
		Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		Print '>>-----------------------';

		/* Quality check "check that the data has not shifted and is in the correct column */
		Select * from bronze.erp_loc_a101

		/* Count the row inside the table */
		Select count (*) from bronze.erp_loc_a101

		Set @start_time = Getdate();
		
		Print '>> Truncate Table: bronze.erp_px_cat_g1v2';
		/* to avoid duplicate load/data first empty and then load */
		Truncate Table bronze.erp_px_cat_g1v2

		Print '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		/* Insert data in bronze.erp_px_cat_g1v2 in bulk insert */

		Bulk Insert bronze.erp_px_cat_g1v2
		From 'C:\Users\xavier\Documents\Mona. R. Azim Doc\Baraa\SQL\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'

		With (
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		Set @end_time = Getdate();
		Print '>> Load Duration:' + Cast(Datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		Print '>>-----------------------';

		Set @batch_end_time = GETDATE();
		Print '==============================================================='
		Print 'Loading Bronze Layer is completed';
		Print ' - Total Load Duration:' + Cast(Datediff(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		
		
		/* Quality check "check that the data has not shifted and is in the correct column */
		Select * from bronze.erp_px_cat_g1v2

		/* Count the row inside the table */
		Select count (*) from bronze.erp_px_cat_g1v2

	End Try

	/* Catch block to handle the error. Catch only run if the SQL fail */
	Begin Catch
		Print '===================================================='
		Print 'ERROR OCCRED DURING LOADING BRONZE LAYER'
		Print 'Error Message' + Error_Message();
		Print 'Error Message' + Cast (Error_Number() AS NVARCHAR);
		Print 'Error Message' + Cast (Error_State() AS NVARCHAR);
		Print '===================================================='

	End Catch
End
