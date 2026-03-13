/*
============================================================================================================================
Create Database and Schemas
============================================================================================================================
Script Purpose:
  This script creates a new database named 'DataWarehouse' after checking if it already exists.
  if the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'sliver',
  and 'gold'.

Warning:
  Running this script will drop the entire 'DataWarehouse' database if it exists.
  All data in the database will be permanently deleted. Proceed with casution and 
  ensure you have proper backups before running this script.
*/

Use master;
Go

 -- Drop and recreate the 'DataWarehouse'database
  IF EXISTS ( SELECT 1 FROM sys.databases Where name = 'DataWarehouse')
  BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE USER WITH ROLLBACK IMMEDIATE:
    DROP DATABASE DataWarehouse;
END;

-- Create Database 'DataWarehouse' database
Create Database DataWarehouse;
GO
Use DataWarehouse;


-- Create Schemas
Create Schema bronze;
GO
  
Create Schema sliver;
Go
  
Create Schema gold;
Go
