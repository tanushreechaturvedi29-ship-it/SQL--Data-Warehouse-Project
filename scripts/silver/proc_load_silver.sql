/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

DELIMITER $$

CREATE PROCEDURE silver_load_silver()
BEGIN
    -- Variables for tracking time
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;

    SET batch_start_time = NOW();

    -- =======================================
    -- CRM CUSTOMER INFO
    -- =======================================
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname,
        cst_marital_status, cst_gndr, cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) AS t
    WHERE rn = 1;

    -- =======================================
    -- CRM PRODUCT INFO
    -- =======================================
    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm, prd_cost,
        prd_line, prd_start_dt, prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
        SUBSTRING(prd_key, 7),
        prd_nm,
        IFNULL(prd_cost, 0),
        CASE 
            WHEN UPPER(prd_line) = 'M' THEN 'Mountain'
            WHEN UPPER(prd_line) = 'R' THEN 'Road'
            WHEN UPPER(prd_line) = 'S' THEN 'Other Sales'
            WHEN UPPER(prd_line) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        DATE(prd_start_dt),
        DATE(
            LEAD(prd_start_dt) OVER (PARTITION BY SUBSTRING(prd_key,7) ORDER BY prd_start_dt)
        ) - INTERVAL 1 DAY
    FROM bronze.crm_prd_info;

    -- =======================================
    -- CRM SALES DETAILS 
    -- =======================================
    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id,
        sls_order_dt, sls_ship_dt, sls_due_dt,
        sls_sales, sls_quantity, sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        -- Dates
        IF(LENGTH(sls_order_dt)=8, STR_TO_DATE(sls_order_dt, '%Y%m%d'), NULL),
        IF(LENGTH(sls_ship_dt)=8, STR_TO_DATE(sls_ship_dt, '%Y%m%d'), NULL),
        IF(LENGTH(sls_due_dt)=8, STR_TO_DATE(sls_due_dt, '%Y%m%d'), NULL),

        -- Sales
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 
            THEN COALESCE(sls_quantitt, 0) * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,

        -- Quantity (Corrected)
        COALESCE(sls_quantitt, 0) AS sls_quantity,

        -- Price
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 THEN (
                CASE WHEN COALESCE(sls_quantitt,0) = 0 THEN NULL
                     ELSE sls_sales / NULLIF(sls_quantitt,0)
                END
            )
            ELSE sls_price
        END AS sls_price

    FROM bronze.crm_sales_details;

    -- =======================================
    -- ERP CUSTOMER TABLE
    -- =======================================
    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT
        IF(cid LIKE 'NAS%', SUBSTRING(cid,4), cid),
        IF(bdate > NOW(), NULL, bdate),
        CASE
            WHEN UPPER(gen) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(gen) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END
    FROM bronze.erp_cust_az12;

    -- =======================================
    -- ERP LOCATION TABLE
    -- =======================================
    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT
        REPLACE(cid, '-', ''),
        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN cntry IS NULL OR cntry = '' THEN 'n/a'
            ELSE TRIM(cntry)
        END
    FROM bronze.erp_loc_a101;

    -- =======================================
    -- ERP CATEGORY TABLE
    -- =======================================
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance
    FROM bronze.erp_px_cat_g1v2;

    SET batch_end_time = NOW();
END $$

DELIMITER ;

