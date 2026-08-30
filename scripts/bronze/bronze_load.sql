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

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '==========================';
		PRINT 'Loading Bronze Layer'
		PRINT '==========================';

		PRINT '--------------------------';
		PRINT 'Loading CRM Tables'
		PRINT '--------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate and Insert into: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info
		BULK INSERT bronze.crm_cust_info
		FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_crm\cust_info.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time )AS NVARCHAR)+' seconds';

		SET @start_time = GETDATE();
		PRINT '>> Truncate and Insert into: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info
		BULK INSERT bronze.crm_prd_info
		FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_crm\prd_info.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time )AS NVARCHAR)+' seconds';

		SET @start_time = GETDATE();
		PRINT '>> Truncate and Insert into: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details
		BULK INSERT bronze.crm_sales_details
		FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_crm\sales_details.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time )AS NVARCHAR)+' seconds';

		PRINT '--------------------------';
		PRINT 'Loading ERP Tables'
		PRINT '--------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate and Insert into: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12
		BULK INSERT bronze.erp_cust_az12
		FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_erp\cust_az12.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time )AS NVARCHAR)+' seconds';

		SET @start_time = GETDATE();
		PRINT '>> Truncate and Insert into: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101
		BULK INSERT bronze.erp_loc_a101
		FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_erp\loc_a101.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time )AS NVARCHAR)+' seconds';

		SET @start_time = GETDATE();
		PRINT '>> Truncate and Insert into: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_erp\px_cat_g1v2.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time )AS NVARCHAR)+' seconds';

	END TRY
	BEGIN CATCH
	PRINT '======================='
	PRINT 'ERROR OCCURED DURING BRONZE LAYER LOADING'
	PRINT 'ERROR MESSAGE: '+ERROR_MESSAGE();
	PRINT 'ERROR MESSAGE: '+CAST(ERROR_NUMBER()AS NVARCHAR);
	PRINT '======================='
	END CATCH
END