/*
========================================================================================
  DDL Script: Create Bronze Tables
========================================================================================
Purpose:
    This script creates tables in the 'bronze' schema,dropping already existing tables
    if they already exist. (FULL LOAD ALWAYS)
========================================================================================
*/

	if object_id('Bronze.crm_cust_info','U') is not null
		drop table Bronze.crm_cust_info;
	Go

	Create table Bronze.crm_cust_info(
		cst_id int,
		cst_key nvarchar(50),
		cst_firstname nvarchar(50),
		cst_lastname nvarchar(50),
		cst_marital_status nvarchar(50),
		cst_gndr nvarchar(50),
		cst_create_date date
	);


	if object_id('Bronze.crm_prd_info','U') is not null
		drop table Bronze.crm_prd_info;
	Go

	Create table Bronze.crm_prd_info(
		prd_id int,
		prd_key nvarchar(50),
		prd_nm nvarchar(50),
		prd_cost int,
		prd_line nvarchar(50),
		prd_start_dt datetime,
		prd_end_dt datetime
	);

	if object_id('Bronze.crm_sales_details','U') is not null
		drop table Bronze.crm_sales_details;
	Go

	Create table Bronze.crm_sales_details(
		sls_ord_num nvarchar(50),
		sls_prd_key nvarchar(50),
		sls_cust_id int,
		sls_order_dt int,
		sls_ship_dt int,
		sls_due_dt int,
		sls_sales int,
		sls_quantity int,
		sls_price int
	);

	if object_id('Bronze.erp_cust_az12','U') is not null
		drop table Bronze.erp_cust_az12;
	Go

	Create table Bronze.erp_cust_az12(
		CID nvarchar(50),
		BDATE date,
		GEN nvarchar(50)
	);

	if object_id('Bronze.erp_loc_a101','U') is not null
		drop table Bronze.erp_loc_a101;
	Go

	Create table Bronze.erp_loc_a101(
		CID nvarchar(50),
		CNTRY nvarchar(50)
	);

	if object_id('Bronze.erp_px_cat_g1v2 ','U') is not null
		drop table Bronze.erp_px_cat_g1v2;
	Go

	Create table Bronze.erp_px_cat_g1v2(
		ID nvarchar(50),
		CAT nvarchar(50),
		SUBCAT nvarchar(50),
		MAINTENANCE nvarchar(50)
	);

--=================
--	BULK INSERT
--=================

create or alter procedure Bronze.load_Bronze as

Begin
	declare @start_time datetime,@end_time datetime,@load_st datetime,@load_end datetime
	begin Try

		set @load_st =GETDATE();
		set @start_time =GETDATE();
		truncate table Bronze.crm_cust_info;
		Bulk insert Bronze.crm_cust_info
		from 'C:\Users\kunal\Downloads\dbc9660c89a3480fa5eb9bae464d6c07 (1)\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow=2,  --load from second row,first row is header
			FieldTerminator=',',
			Tablock
		)
		set @end_time =GETDATE();
		print '>> -------------------------------------------------------'
		Print '>> Load Duration of Bronze.crm_cust_info:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> -------------------------------------------------------'


		set @start_time =GETDATE();
		truncate table Bronze.crm_prd_info;
		Bulk insert Bronze.crm_prd_info
		from 'C:\Users\kunal\Downloads\dbc9660c89a3480fa5eb9bae464d6c07 (1)\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			firstrow=2,  --load from second row,first row is header
			FieldTerminator=',',
			Tablock
		)
		set @end_time =GETDATE();
		print '>> ------------------------------------------------------'
		Print '>> Load Duration of Bronze.crm_prd_info:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> ------------------------------------------------------'


		set @start_time =GETDATE();
		truncate table Bronze.crm_sales_details;
		Bulk insert Bronze.crm_sales_details
		from 'C:\Users\kunal\Downloads\dbc9660c89a3480fa5eb9bae464d6c07 (1)\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			firstrow=2,  --load from second row,first row is header
			FieldTerminator=',',
			Tablock
		)
		set @end_time =GETDATE();
		print '>> ------------------------------------------------------'
		Print '>> Load Duration of Bronze.crm_sales_details:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> ------------------------------------------------------'

		set @start_time =GETDATE();
		truncate table Bronze.erp_cust_az12;
		Bulk insert Bronze.erp_cust_az12
		from 'C:\Users\kunal\Downloads\dbc9660c89a3480fa5eb9bae464d6c07 (1)\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow=2,  --load from second row,first row is header
			FieldTerminator=',',
			Tablock
		)
		set @end_time =GETDATE();
		print '>> ------------------------------------------------------'
		Print '>> Load Duration of Bronze.erp_cust_az12:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> ------------------------------------------------------'


		set @start_time =GETDATE();
		truncate table Bronze.erp_loc_a101;
		Bulk insert Bronze.erp_loc_a101
		from 'C:\Users\kunal\Downloads\dbc9660c89a3480fa5eb9bae464d6c07 (1)\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow=2,  --load from second row,first row is header
			FieldTerminator=',',
			Tablock
		)
		set @end_time =GETDATE();
		print '>> ------------------------------------------------------'
		Print '>> Load Duration of Bronze.erp_loc_a101:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> ------------------------------------------------------'


		set @start_time =GETDATE();
		truncate table Bronze.erp_px_cat_g1v2;
		Bulk insert Bronze.erp_px_cat_g1v2
		from 'C:\Users\kunal\Downloads\dbc9660c89a3480fa5eb9bae464d6c07 (1)\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow=2,  --load from second row,first row is header
			FieldTerminator=',',
			Tablock
		);
		set @end_time =GETDATE();
		print '>> ------------------------------------------------------'
		Print '>> Load Duration of Bronze.erp_px_cat_g1v2:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> ------------------------------------------------------'
		set @load_end=GETDATE();
		print '>> ------------------------------------------------------'
		Print '>> Total Duration to Load Bronze Layer:' +cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print '>> ------------------------------------------------------'

	end try
	begin catch
		print '==================================================='
		print 'ERRROR OCCURED DURING LOADING BRONZE LAYER'
		print 'Error Message' + Error_Message();
		print 'Error Message' + cast(Error_Number() as nvarchar);
		print 'Error Message' + cast(Error_State() as nvarchar);
		print '==================================================='
	end catch
end;
