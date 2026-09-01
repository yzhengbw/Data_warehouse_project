/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
--------------------------------------
--Customer-Dim
--------------------------------------
IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer;
GO

CREATE VIEW gold.dim_customer AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.[cst_id] AS customer_id, 
	ci.[cst_key] AS customer_number, 
	ci.[cst_firstname] AS firstname, 
	ci.[cst_lastname] AS lastname, 
	ci.[cst_marital_status] AS marital_status,  
	cb.[bdate] AS birthdate,
	COALESCE(
		NULLIF(TRIM(ci.[cst_gndr]), 'n/a'),
		NULLIF(TRIM(cb.[gen]), 'n/a'),
		'n/a'
	) AS gender,-- Prioritze CRM gender 
	cc.[cntry] AS country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
	ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cc
	ON ci.cst_id = cc.cid;
GO

--------------------------------------
--Product-Dim
--------------------------------------
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;
GO
CREATE VIEW gold.dim_product AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pri.[prd_start_dt]) AS product_key,
	pri.[prd_id] AS product_id, 
	pri.[prd_key] AS product_number, 
	pri.[prd_nm] AS product_name, 
	pri.[prd_cost] AS product_cost, 
	pri.[prd_line] AS product_line, 
	pri.[prd_start_dt] AS start_date, 
	pri.[cat_id] AS category_id,
	prc.[cat]AS category, 
	prc.[subcat] AS sub_category, 
	prc.[maintenance] AS maintenance
FROM [silver].[crm_prd_info] AS pri
LEFT JOIN silver.erp_px_cat_g1v2 AS prc
	ON pri.cat_id=prc.id
WHERE prd_end_dt IS NULL -- Only want current data
GO

--------------------------------------
--Sales-Fact
--------------------------------------
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW	gold.fact_sales AS
SELECT 
	sa.[sls_ord_num] AS order_number, 
	pr.product_key,
	cu.customer_key, 
	sa.[sls_order_dt] AS order_date, 
	sa.[sls_ship_dt] AS ship_date, 
	sa.[sls_due_dt] AS due_date, 
	sa.[sls_sales] AS sales, 
	sa.[sls_quantity] AS quantity, 
	sa.[sls_price] AS price
FROM silver.crm_sales_details AS sa
LEFT JOIN gold.dim_product AS pr
	ON sa.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer AS cu
	ON sa.sls_cust_id = cu.customer_id