create view gold.dim_customers as
SELECT 
    row_number() over (order by cst_id) customer_key, 
    ci.cst_id as customer_id, 
    ci.cst_key as customer_number, 
    ci.cst_firstname as first_name, 
    ci.cst_lastname as last_name, 
    ci.cst_material_status as marital_status,
    la.cntry as country,
    case when ci.cst_gndr!='n/a' then ci.cst_gndr
         else coalesce(ca.gen,'n/a')
    end as gender, 
    ci.cst_create_date as create_date,
    ca.bdate as birthdate
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust AS ca 
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc AS la 
    ON ca.cid = la.cid;



CREATE VIEW gold.dim_products AS
SELECT
    pn.prd_id AS product_id,
    pn.cat_id AS category_id,
    pn.prd_key AS product_key,
    pn.prd_nm AS product_number,
    pn.prd_cost AS product_cost,
    pn.prd_line AS product_line,
    pn.prd_start_date AS start_date,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance
FROM silver.crm_prod_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_date IS NULL;




create gold.fact_sales as
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price
FROM silver.crm_sls_ord sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_key  -- change to product_number if that's correct
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
