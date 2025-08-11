use Datawarehouse;

CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

create table bronze.crm_prod_info(
prd_id int,
prd_key varchar(70),
prd_nm varchar(70),
prd_cost float,
prd_line varchar(20),
prd_start_date datetime,
prd_end_date datetime);

drop table bronze.crm_sls_ord;

CREATE TABLE bronze.crm_sls_ord (
    sls_ord_num   VARCHAR(60),
    sls_prd_key   VARCHAR(60),
    sls_cust_id   NVARCHAR(60),
    sls_order_dt  INT,
    sls_ship_dt   INT,
    sls_due_dt    INT,
    sls_sales     DECIMAL(12,2),
    sls_quantity  INT,
    sls_price     DECIMAL(12,2)
);



create table bronze.erp_cust(
CID varchar(80),
BDATE date,
GEN varchar(15)
);

create table bronze.erp_loc(
CID nvarchar(60),
CNTRY nvarchar(50));

create table bronze.erp_px_cat_g1v2(
ID nvarchar(60),
CAT nvarchar(50),
SUBCAT nvarchar(70),
MAINTENANCE nvarchar(40));

