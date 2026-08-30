BULK INSERT bronze.crm_cust_info
FROM "E:\zy_work\Data_warhouse_proj\Project\datasets\source_crm\cust_info.csv"
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);