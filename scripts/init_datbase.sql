/*
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
Create Databse and Schemas 
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it alredy exixts.
    If it exists, the database is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.

*/

-- Drop and recreate the 'DataWarehouse' database 

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END
GO

CREATE DATABASE DataWarehouse;
USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
