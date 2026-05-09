/*
===================================================================================================
DDL Script: Create Silver Tables
===================================================================================================
Purpose:
  This script creates tables in the 'silver' schema,dropping existing tables if they already exist.
====================================================================================================
*/

	if object_id('Silver.crm_cust_info','U') is not null
		drop table Silver.crm_cust_info;
	Go

	Create table Silver.crm_cust_info(
		cst_id int,
		cst_key nvarchar(50),
		cst_firstname nvarchar(50),
		cst_lastname nvarchar(50),
		cst_marital_status nvarchar(50),
		cst_gndr nvarchar(50),
		cst_create_date date,
		dwh_create_date datetime2 default getdate(),
		dwh_source_flag nvarchar(5) default 'CRM'
	);


	if object_id('Silver.crm_prd_info','U') is not null
		drop table Silver.crm_prd_info;
	Go

	Create table Silver.crm_prd_info(
		prd_id int,
		cat_id nvarchar(50),
		prd_key nvarchar(50),
		prd_nm nvarchar(50),
		prd_cost int,
		prd_line nvarchar(50),
		prd_start_dt date,
		prd_end_dt date,
		dwh_create_date datetime2 default getdate(),
		dwh_source_flag nvarchar(5) default 'CRM'
	);

	if object_id('Silver.crm_sales_details','U') is not null
		drop table Silver.crm_sales_details;
	Go

	Create table Silver.crm_sales_details(
		sls_ord_num nvarchar(50),
		sls_prd_key nvarchar(50),
		sls_cust_id int,
		sls_order_dt date,
		sls_ship_dt date,
		sls_due_dt date,
		sls_sales int,
		sls_quantity int,
		sls_price int,
		dwh_create_date datetime2 default getdate(),
		dwh_source_flag nvarchar(5) default 'CRM'
	);

	if object_id('Silver.erp_cust_az12','U') is not null
		drop table Silver.erp_cust_az12;
	Go

	Create table Silver.erp_cust_az12(
		CID nvarchar(50),
		BDATE date,
		GEN nvarchar(50),
		dwh_create_date datetime2 default getdate(),
		dwh_source_flag nvarchar(5) default 'ERP'
	);

	if object_id('Silver.erp_loc_a101','U') is not null
		drop table Silver.erp_loc_a101;
	Go

	Create table Silver.erp_loc_a101(
		CID nvarchar(50),
		CNTRY nvarchar(50),
		dwh_create_date datetime2 default getdate(),
		dwh_source_flag nvarchar(5) default 'ERP'
	);

	if object_id('Silver.erp_px_cat_g1v2 ','U') is not null
		drop table Silver.erp_px_cat_g1v2;
	Go

	Create table Silver.erp_px_cat_g1v2(
		ID nvarchar(50),
		CAT nvarchar(50),
		SUBCAT nvarchar(50),
		MAINTENANCE nvarchar(50),
		dwh_create_date datetime2 default getdate(),
		dwh_source_flag nvarchar(5) default 'ERP'
	);

