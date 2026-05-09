/*
==============================================================================
DDl Script: Create Gold Views
==============================================================================
Purpose:
  This scripts creates view for gold layer in the warehouse.

Usage:
  These views can be used for analytics and reporting.
==============================================================================
*/

IF OBJECT_ID('gold.dim_customers','V') is not null
	drop view gold.dim_customers
GO
create view gold.dim_customers as
select 
	row_number() over (order by cst_id)     as customer_key,
	ci.[cst_id]								as customer_id,
	ci.[cst_key]							as customer_number,
	ci.[cst_firstname]						as first_name,
	ci.[cst_lastname]						as last_name,
	la.cntry								as country,
	ci.[cst_marital_status]					as marital_status,
	case when ci.[cst_gndr]<>ca.gen then ci.[cst_gndr]
    when ca.gen != 'n/a' then ci.[cst_gndr]    --CRM is the Master for gender Info
    else coalesce(ca.gen,'n/a') end			as gender,
	ci.[cst_create_date]					as create_date,
	ca.bdate								as birthdate	
from Silver.crm_cust_info ci
left join Silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 la
on ci.cst_key = la.cid


IF OBJECT_ID('gold.dim_products','V') is not null
	drop view gold.dim_products
GO
create view gold.dim_products as
select 
row_number() over (order by pn.prd_start_dt,pn.[prd_key] ) as product_key,
pn.[prd_id] as product_id,
pn.[prd_key] as product_number,
pn.[prd_nm] as product_name,
pn.[cat_id] as category_id,
pc.cat as category,
pc.subcat as sub_category,
pc.maintenance,
pn.[prd_cost] as cost,
pn.[prd_line] as product_line,
pn.[prd_start_dt] as start_date,
pn.[prd_end_dt] as end_date
from Silver.crm_prd_info pn
left join Silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where prd_end_dt is null  --filter out all historical data


IF OBJECT_ID('gold.fact_sales','V') is not null
	drop view gold.fact_sales
GO
create view gold.fact_sales as
select 
[sls_ord_num] as order_number,
pr.product_key,
cu.customer_key,
[sls_order_dt] as order_date,
[sls_ship_dt] as shipping_date,
[sls_due_dt] as due_date,
[sls_sales] as sales_amount,
[sls_quantity] as quantity,
[sls_price] as price
from Silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id
