CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
    dwh_create_date datetime2 default getdate()
);
drop table silver.crm_prod_info;

create table silver.crm_prod_info(
prd_id int,
cat_id varchar(70),
prd_key varchar(70),
prd_nm varchar(70),
prd_cost float,
prd_line varchar(20),
prd_start_date date,
prd_end_date date,
dwh_create_date datetime2 default getdate());

drop table silver.crm_sls_ord

CREATE TABLE silver.crm_sls_ord (
    sls_ord_num   VARCHAR(60),
    sls_prd_key   VARCHAR(60),
    sls_cust_id   NVARCHAR(60),
    sls_order_dt  Date,
    sls_ship_dt   Date,
    sls_due_dt    Date,
    sls_sales     DECIMAL(12,2),
    sls_quantity  INT,
    sls_price     DECIMAL(12,2),
    dwh_create_date datetime2 default getdate()
);



create table silver.erp_cust(
CID varchar(80),
BDATE date,
GEN varchar(15),
dwh_create_date datetime2 default getdate()
);

create table silver.erp_loc(
CID nvarchar(60),
CNTRY nvarchar(50),
dwh_create_date datetime2 default getdate());

create table silver.erp_px_cat_g1v2(
ID nvarchar(60),
CAT nvarchar(50),
SUBCAT nvarchar(70),
MAINTENANCE nvarchar(40),
dwh_create_date datetime2 default getdate());

