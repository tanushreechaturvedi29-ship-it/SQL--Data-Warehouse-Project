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

DROP DATABASE IF EXISTS DataWarehouse;
CREATE DATABASE DataWarehouse;
USE DataWarehouse;

-- Create layer schemas (in MySQL = separate databases)
CREATE DATABASE IF NOT EXISTS bronze;
USE bronze;
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);


CREATE TABLE broneze.crm_prd_info(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line  NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantitt INT,
    sls_price INT,
);

CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);

CREATE DATABASE IF NOT EXISTS silver;
CREATE DATABASE IF NOT EXISTS gold;

