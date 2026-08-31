
--=================================================================
-- Check crm_cust_info
--=================================================================
--Overall view
SELECT *
FROM silver.crm_cust_info

-- Check for Duplicates in PK
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

--=================================================================
-- Check crm_prd_info
--=================================================================
-- Overview
SELECT 
    TOP(10)*
FROM silver.crm_prd_info

-- Check for NULLs or Duplicates in PK
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check unwanted spaces
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check nagative or null for cost
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check invalid date
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--=================================================================
-- Check crm_sales_details
--=================================================================
-- Overview
SELECT 
    TOP(10)*
FROM bronze.crm_sales_details;

-- Check invalid dates
SELECT 
    NULLIF(sls_order_dt, 0) AS sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
    OR LEN(sls_order_dt) != 8 
    OR sls_order_dt > 20500101 
    OR sls_order_dt < 19000101;

-- Check invalid date orderas
SELECT
    sls_order_dt,sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt>sls_ship_dt;

--Check sales = quantity*price  and invalid numbers
SELECT 
    sls_ord_num ,sls_sales, sls_price, sls_quantity
FROM bronze.crm_sales_details
WHERE sls_sales!=sls_price*sls_quantity
    OR sls_sales<=0 OR sls_price<=0 OR sls_quantity<=0
    OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL;

--=================================================================
-- Check erp_cust_az12
--=================================================================
--Overview
SELECT *
FROM bronze.erp_cust_az12;

--Check if duplicated or NULL PK 
SELECT 
    cid,COUNT(*)
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*)!=1 OR cid IS NULL;

--Check gender
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

-- Identify Out-of-Range Dates
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

--=================================================================
-- Check erp_loc_a101
--=================================================================
--Overall
SELECT [cid], [cntry]
FROM bronze.erp_loc_a101

--Check country
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101

--=================================================================
-- Check erp_px_cat_g1v2
--=================================================================
--Overview
SELECT TOP(10)*
FROM bronze.erp_px_cat_g1v2

-- Check maintenance
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2

-- Check cat
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2
