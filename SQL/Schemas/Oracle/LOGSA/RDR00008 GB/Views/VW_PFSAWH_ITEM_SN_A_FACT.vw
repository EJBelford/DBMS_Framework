CREATE OR REPLACE VIEW vw_pfsawh_item_sn_a_fact 
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/ 
--
--         NAME: vw_pfsawh_item_sn_a_fact 
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: VW_PFSAWH_ITEM_SN_A_FACT.vw 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 28 March 2008  
--
--  ASSUMPTIONS: 
--
--  LIMITATIONS: 
--
--        NOTES:  
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 28MAR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
AS 
--
SELECT  
    TO_CHAR(sysdate, 'YYYY-MM-DD') AS view_extract_date, 
    TO_CHAR(sysdate, 'HH24:MI:SS') AS view_extract_time, 
/*----- key identifiers -----*/ 
    ft.physical_item_id,  
    ft.physical_item_sn_id, 
    ft.mimosa_item_sn_id, 
    ft.pba_id, 
    ft.year_type, 
    ft.rec_year, 
/*----- Item dim -----*/    
    itd.niin,   
    itd.lin,   
    itd.army_type_designator,   
    itd.item_nomen_short,
--    itd.item_nomen_standard,
--    itd.item_nomen_long,
--    itd.lin_active_date,
--    itd.lin_inactive_date,
--    itd.lin_inactive_statement,
--    itd.unit_price,          itd.unit_indicator,
--    itd.fsc,     
--    itd.nsn,    
--    itd.eic_code,            itd.eic_model,    
--    itd.ecc_code,            itd.ecc_desc,     
--    itd.mat_cat_cd_1_code,   itd.mat_cat_cd_1_desc,
--    itd.mat_cat_cd_2_code,   itd.mat_cat_cd_2_desc,
--    itd.mat_cat_cd_3_code,   itd.mat_cat_cd_3_desc,    
--    itd.mat_cat_cd_4_code,   itd.mat_cat_cd_4_desc,    
--    itd.mat_cat_cd_4_5_code, itd.mat_cat_cd_4_5_desc,    
--    itd.cage_code,           itd.cage_desc,       
--    itd.chap,                itd.mscr, 
--    itd.uid1_desc,           itd.uid2_desc,   
--    itd.type_class_cd,       itd.type_class_cd_desc,    
--    itd.sb_700_20_publication_date,                   
--    itd.ricc_item_code,                          
--    itd.aba,
--    itd.sos,
--    itd.ciic, 
--    itd.cbm_sensor_fl,     
--    itd.aircraft,
--    itd.supply_class,        itd.supply_class_desc,
--    itd.cl_of_supply_cd,     itd.cl_of_supply_cd_desc,
--    itd.subclass_of_supply_cd_desc,
/*----- Item SN dim -----*/     
    isd.ITEM_SERIAL_NUMBER, 
    isd.ITEM_REGISTRATION_NUM, 
    isd.ITEM_LOCATION, 
    isd.ITEM_UIC, 
    isd.ITEM_UIC_LOCATION, 
/*-----  -----*/        
    ft.year_fmc_hrs + ft.year_pmc_hrs + ft.year_nmc_hrs AS year_hrs,  
    ft.year_mc_hrs, 
    ft.year_fmc_hrs, 
    ft.year_pmc_hrs, 
    ft.year_nmc_hrs, 
    ft.year_pmcm_hrs, 
    ft.year_pmcs_hrs, 
    ft.year_nmcm_hrs, 
    ft.year_nmcs_hrs, 
    ft.year_dep_hrs,    
    year_operat_readiness_rate, 
    year_operat_cost_per_hour, 
    year_cost_parts, 
    year_cost_manpower, 
    year_deferred_maint_items, 
    year_operat_hrs_since_lst_ovhl, 
    year_maint_hrs_since_lst_ovhl, 
    year_time_since_lst_ovhl 
--    , ' | ', ft.* , ' | ', itd.* , ' | ', isd.* 
FROM   pfsawh_item_sn_a_fact ft   
LEFT OUTER JOIN pfsawh_item_dim itd ON ft.physical_item_id = itd.physical_item_id 
LEFT OUTER JOIN pfsawh_item_sn_dim isd ON ft.physical_item_sn_id = isd.physical_item_sn_id 
WHERE  ft.physical_item_sn_id > 0 
ORDER BY ft.physical_item_id, ft.physical_item_sn_id, ft.year_type, ft.rec_year; 


/*----- Table Meta-Data -----*/ 

COMMENT ON COLUMN vw_pfsawh_item_sn_a_fact.physical_item_id  
IS 'PHYSICAL_ITEM_ID - LIW/PFSAWH identitier for the item/part as represented in the PFSAWH_ITEM_DIM';
        

/*----- Check to see if the table comment is present -----*/

SELECT   table_name, comments 
FROM     user_tab_comments 
WHERE    table_name = UPPER('vw_pfsawh_item_sn_a_fact'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('vw_pfsawh_item_sn_a_fact') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('vw_pfsawh_item_sn_a_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%defer%')
ORDER BY a.col_name; 
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 


/*------------------------*/ 
/*----- Test Scripts -----*/ 
/*------------------------*/ 
/* 

SELECT *  
FROM   vw_pfsawh_item_sn_a_fact; 

*/

