/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE bronze;

DROP PROCEDURE IF EXISTS load_bronze;

DELIMITER $$

CREATE PROCEDURE load_bronze()
BEGIN
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;

    SET batch_start_time = NOW();

    -- Logging
    SELECT '================================================' AS Msg;
    SELECT 'Loading Bronze Layer' AS Msg;
    SELECT '================================================' AS Msg;


    -- CRM Tables
    SELECT '------------------------------------------------' AS Msg;
    SELECT 'Loading CRM Tables' AS Msg;
    SELECT '------------------------------------------------' AS Msg;

    SELECT '>> Truncating Table: bronze.crm_cust_info' AS Msg;
    SELECT COUNT(*) FROM bronze.crm_cust_info;
    TRUNCATE TABLE bronze.crm_cust_info;

    SELECT '>> Truncating Table: bronze.crm_prd_info' AS Msg;
    SELECT COUNT(*) FROM bronze.crm_prd_info;
    TRUNCATE TABLE bronze.crm_prd_info;

    SELECT '>> Truncating Table: bronze.crm_sales_details' AS Msg;
    SELECT COUNT(*) FROM bronze.crm_sales_details;
    TRUNCATE TABLE bronze.crm_sales_details;


    -- ERP Tables
    SELECT '------------------------------------------------' AS Msg;
    SELECT 'Loading ERP Tables' AS Msg;
    SELECT '------------------------------------------------' AS Msg;

    SELECT '>> Truncating Table: bronze.erp_loc_a101' AS Msg;
    SELECT COUNT(*) FROM bronze.erp_loc_a101;
    TRUNCATE TABLE bronze.erp_loc_a101;

    SELECT '>> Truncating Table: bronze.erp_cust_az12' AS Msg;
    SELECT COUNT(*) FROM bronze.erp_cust_az12;
    TRUNCATE TABLE bronze.erp_cust_az12;

    SELECT '>> Truncating Table: bronze.erp_px_cat_g1v2' AS Msg;
    SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;


    SET batch_end_time = NOW();

    SELECT '==========================================' AS Msg;
    SELECT 'Loading Bronze Layer is Completed' AS Msg;
    SELECT CONCAT(' - Total Duration: ',
                  TIMESTAMPDIFF(SECOND, batch_start_time, batch_end_time),
                  ' seconds') AS Msg;
    SELECT '==========================================' AS Msg;

END $$

DELIMITER ;
