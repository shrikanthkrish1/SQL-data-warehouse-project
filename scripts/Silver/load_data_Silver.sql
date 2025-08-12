CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;
    print '======================================='
    print '       Loading into Silver Layer       '
    print '======================================='

    print  '======================'
    print 'Transformations and loading the data into Silver layer'
    print '======================='

    print 'Starting CRM now'
    -- Load CRM Customer Info
    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_material_status,
        cst_gndr,
        cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE 
            WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM bronze.crm_cust_info;

    -- Load CRM Product Info
    INSERT INTO silver.crm_prod_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_date,
        prd_end_date,
        dwh_create_date
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
        SUBSTRING(prd_key, 7, LEN(prd_key)),
        prd_nm,
        ISNULL(prd_cost, 0),
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'other sales'
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        CAST(prd_start_date AS date),
        DATEADD(DAY, -1, LEAD(prd_start_date) OVER (
            PARTITION BY prd_key ORDER BY prd_start_date
        )),
        GETDATE()
    FROM bronze.crm_prod_info;

    -- Load CRM Sales Orders
    INSERT INTO silver.crm_sls_ord (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE 
            WHEN sls_order_dt = 0 OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END,
        CASE 
            WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END,
        CASE 
            WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END,
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 
                 OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price < 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END
    FROM bronze.crm_sls_ord;
    print '===============completed================='
    print'====================='
    print 'Starting with ERM'
    print '===================='

    -- Load ERP Customer
    INSERT INTO silver.erp_cust (
        cid,
        bdate,
        gen
    )
    SELECT
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
            ELSE cid
        END,
        CASE 
            WHEN bdate > GETDATE() THEN NULL
            ELSE bdate
        END,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END
    FROM bronze.erp_cust;

    -- Load ERP Location
    INSERT INTO silver.erp_loc (
        cid,
        cntry
    )
    SELECT 
        REPLACE(cid, '-', ''),
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END
    FROM bronze.erp_loc;

    -- Load ERP Category
    INSERT INTO silver.erp_px_cat_g1v2 (
        ID,
        CAT,
        SUBCAT,
        MAINTENANCE
    )
    SELECT 
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;
    print ' ERM completed'
    print ' Loading successfull'
END;
