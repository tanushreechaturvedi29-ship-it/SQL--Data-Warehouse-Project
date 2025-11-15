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
-- Drop old databases if they exist
DROP DATABASE IF EXISTS DataWarehouse;
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Recreate databases
CREATE DATABASE DataWarehouse;
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;


