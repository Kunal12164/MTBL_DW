/*
=========================================================
Stored Procedure: Load Bronze layer (Source -> Bronze)
=========================================================
Purpose:
  This stored procedure load data into the 'bronze' schema from external csv files.
  It truncates the bronze tables before loading the data & use Bulk insert to load files in bronze tables.

Parameter:
  This stored procedure doesnt accept any paramters or return any values.

Usage:
  Exec Bronze.load_Bronze
*/

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
