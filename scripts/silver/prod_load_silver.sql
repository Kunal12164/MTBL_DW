/*
===============================================================================================================
Stored Procedure: Load Silver layer (Bronze -> Silver)
===============================================================================================================
Purpose:
  This stored procedure load data into the 'silver' schema from bronze.
  It truncates the silver tables before loading the data from bronze tables.

Parameter:
  This stored procedure doesnt accept any paramters or return any values.

Usage:
  Exec Silver.load_Silver
================================================================================================================
*/

create or alter procedure silver.load_silver as
BEGIN
	Declare @start datetime,@end datetime,@load_start datetime,@load_end datetime

	Begin Try
	Set @load_start =getdate();
	print '========================================='
	print			'Loading Silver Layer'
	print '=========================================='


	print '========================================='
	print			'Loading CRM Tables'
	print '=========================================='

	Set @start =getdate();
	print '>> Truncating Table: Silver.crm_cust_info'
	Truncate table Silver.crm_cust_info
	print '>> Inserting data Into: Silver.crm_cust_info'
	insert into Silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
	)
	select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case when upper(trim(cst_marital_status)) = 'M' then 'Male'
		 when upper(trim(cst_marital_status)) = 'F' then 'Female'
		 Else 'n/a' 
	End as cst_marital_status,
	case when upper(trim(cst_gndr)) = 'M' then 'Male'
		 when upper(trim(cst_gndr)) = 'F' then 'Female'
		 Else 'n/a' 
	End as cst_gndr,
	cst_create_date

	from (
	select *,ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) latest_created_flag from Bronze.crm_cust_info
	) t where latest_created_flag=1
	Set @end =getdate();
	print '>> Load Duration: '+ cast(datediff(second,@start,@end) as nvarchar) + 'Seconds'
	print '>> --------------';


	Set @start =getdate();
	print '>> Truncating Table: Silver.crm_prd_info'
	Truncate table Silver.crm_prd_info
	print '>> Inserting data Into: Silver.crm_prd_info'
	insert into [Silver].[crm_prd_info](
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
	)
	SELECT 
		  [prd_id],
		  replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
		  SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
		  [prd_nm],
		  isnull([prd_cost],0) as prd_cost,
		  case upper(trim(prd_line))
			   when 'M' then 'Mountain'
			   when 'R' then 'Road'
			   when 'S' then 'Other Sales'
			   when 'T' then 'Touring'
			   Else 'n/a' end as prd_line,
		  cast([prd_start_dt] as date) as prd_start_dt,
		  cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as [prd_end_dt]
	  FROM [MTBL].[Bronze].[crm_prd_info];
	Set @end =getdate();
	print '>> Load Duration: '+ cast(datediff(second,@start,@end) as nvarchar) + 'Seconds'
	print '>> --------------';


	Set @start =getdate();
	print '>> Truncating Table: Silver.crm_sales_details'
	Truncate table Silver.crm_sales_details
	print '>> Inserting data Into: Silver.crm_sales_details'
	insert into Silver.crm_sales_details(
  			sls_ord_num,
			sls_prd_key ,
			sls_cust_id ,
			sls_order_dt,
			sls_ship_dt ,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
	  )
	  select 
		  [sls_ord_num],
		  [sls_prd_key],
		  [sls_cust_id],
		  case when sls_order_dt =0 or len(sls_order_dt) !=8 then Null
		  Else cast(cast(sls_order_dt as varchar) as date)
		  end as sls_order_dt,
		  case when sls_ship_dt =0 or len(sls_ship_dt) !=8 then Null
		  Else cast(cast(sls_ship_dt as varchar) as date)
		  end as sls_ship_dt,
		  case when sls_due_dt =0 or len(sls_due_dt) !=8 then Null
		  Else cast(cast(sls_due_dt as varchar) as date)
		  end as [sls_due_dt],   
		  case when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity*abs(sls_price) then sls_quantity*abs(sls_price)
		  else sls_sales end as sls_sales,
		  [sls_quantity],
		  case when [sls_price] is null or [sls_price]<=0  then sls_sales/nullif(sls_quantity,0)
		  else [sls_price] end as sls_price
	  from Bronze.crm_sales_details;
	Set @end =getdate();
	print '>> Load Duration: '+ cast(datediff(second,@start,@end) as nvarchar) + 'Seconds'
	print '>> --------------';


	Set @start =getdate();
	print '>> Truncating Table: Silver.erp_cust_az12'
	Truncate table Silver.erp_cust_az12
	print '>> Inserting data Into: Silver.erp_cust_az12'
	insert into Silver.erp_cust_az12(
			CID,
			BDATE,
			GEN
	)
	select 
	case when CID like 'NAS%' then substring(CID,4,len(CID)) else CID end as CID,
	case when BDATE>getdate() then Null else BDATE end as BDATE,
	case when upper(trim(GEN)) in ('F','FEMALE') then 'Female'
	when upper(trim(GEN)) in ('M','MALE') then 'Male'
	else 'n/a' end as GEN
	from Bronze.erp_cust_az12
	Set @end =getdate();
	print '>> Load Duration: '+ cast(datediff(second,@start,@end) as nvarchar) + 'Seconds'
	print '>> --------------';


	Set @start =getdate();
	print '>> Truncating Table: Silver.erp_loc_a101'
	Truncate table Silver.erp_loc_a101
	print '>> Inserting data Into: Silver.erp_loc_a101'
	insert into Silver.erp_loc_a101(
	CID,
	CNTRY
	)
	select  
	replace(CID,'-','') as CID,
	case when trim(CNTRY) ='DE' then 'Germany'
	when trim(CNTRY) in ('US','USA') then 'United States'
	when trim(CNTRY) ='' or CNTRY is null then 'n/a'
	else trim(CNTRY) end as CNTRY
	from Bronze.erp_loc_a101;
	Set @end =getdate();
	print '>> Load Duration: '+ cast(datediff(second,@start,@end) as nvarchar) + 'Seconds'
	print '>> --------------';


	Set @start =getdate();
	print '>> Truncating Table: Silver.erp_px_cat_g1v2'
	Truncate table Silver.erp_px_cat_g1v2
	print '>> Inserting data Into: Silver.erp_px_cat_g1v2'
	insert into Silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
	)
	select 
	id,
	cat,
	subcat,
	maintenance
	from Bronze.erp_px_cat_g1v2;
	Set @end =getdate();
	print '>> Load Duration: '+ cast(datediff(second,@start,@end) as nvarchar) + 'Seconds'
	print '>> --------------';

	Set @load_end =getdate();
	print '>> Load Duration of Silver Layer: '+ cast(datediff(second,@load_start,@load_end) as nvarchar) + 'Seconds'
	print '>> --------------';
	END TRY
	BEGIN CATCH
	print '==============================================='
	print 'Error Occured During Loading Silver Layer'
	print 'Error Message'+Error_message();
	print 'Error Message'+cast(Error_Number() as nvarchar);
	print 'Error Message'+cast(Error_State() as nvarchar); 
	print '================================================'
	END CATCH
END
