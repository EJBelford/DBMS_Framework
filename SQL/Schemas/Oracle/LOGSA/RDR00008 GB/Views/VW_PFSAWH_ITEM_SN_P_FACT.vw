CREATE OR REPLACE VIEW vw_pfsawh_item_sn_p_fact 
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/ 
--
--         NAME: vw_pfsawh_item_sn_p_fact 
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: VW_PFSAWH_ITEM_SN_P_FACT.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 28 January 2008 
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
-- 28JAN08 - GB  - RDR00008 -      - Created 
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
    pba.pba_description, 
    pba.pba_title, 
    ft.item_date_from_id, 
    dt0.oracle_date        AS from_date, 
    ft.item_date_to_id, 
    dt1.oracle_date        AS to_date, 
/*----- Item dim -----*/    
    itd.item_nomen_short, 
    CASE ft.physical_item_sn_id 
        WHEN -1 THEN 'MISSING S/N' 
        WHEN 0  THEN 'AGGREGATE' 
        ELSE snd.item_serial_number
    END AS item_serial_number, 
    itd.niin, 
    itd.lin, 
/*-----  -----*/     
    ft.item_usage, 
    ft.item_usage_type, 
    ft.notes                AS Loading_Notes, 
    ft.item_days , 
    ft.period_hrs , 
    ft.fmc_hrs , 
    ROUND(ft.fmc_hrs / ft.period_hrs, 2) AS fmc_pct, 
    ft.mc_hrs , 
    ft.pmc_hrs , 
    ft.nmc_hrs , 
    ft.nmcm_hrs , 
    ROUND(ft.nmcm_hrs / ft.period_hrs, 2) AS nmcm_pct, 
    ft.nmcm_user_hrs , 
    ft.nmcm_int_hrs , 
    ft.nmcm_dep_hrs , 
    ft.nmcs_hrs , 
    1 - ROUND(ft.fmc_hrs / ft.period_hrs, 2) -ROUND(ft.nmcm_hrs / ft.period_hrs, 2) AS nmcs_pct, 
    ft.nmcs_user_hrs , 
    ft.nmcs_int_hrs , 
    ft.nmcs_dep_hrs , 
    ft.pmcm_hrs , 
    ft.pmcm_user_hrs , 
    ft.pmcm_int_hrs , 
    ft.dep_hrs , 
    ft.pmcs_hrs , 
    ft.pmcs_user_hrs , 
    ft.pmcs_int_hrs , 
/*-----  -----*/  
    snd.item_registration_num ,
    snd.item_location , 
    (
    SELECT geo_cd_desc 
    FROM   pfsawh_location_dim 
    WHERE  snd.item_location = geo_cd 
    ) AS item_geo_cd_desc, 
    (
    SELECT force_unit_id 
    FROM   pfsawh_force_unit_dim 
    WHERE  uic = snd.item_uic 
        AND status = 'C'
    ) AS force_unit_id, 
    snd.item_uic ,
    snd.item_uic_location ,
    (
    SELECT geo_cd_desc 
    FROM   pfsawh_location_dim 
    WHERE  snd.item_uic_location = geo_cd 
    ) AS uic_geo_cd_desc, 
    snd.item_soc_flag , 
    snd.item_acq_date     
FROM   pfsawh_item_sn_p_fact ft 
LEFT OUTER JOIN date_dim dt0 ON ft.item_date_from_id = dt0.date_dim_id 
LEFT OUTER JOIN date_dim dt1 ON ft.item_date_to_id = dt1.date_dim_id 
LEFT OUTER JOIN pfsawh_item_dim itd ON ft.physical_item_id = itd.physical_item_id 
LEFT OUTER JOIN pfsawh_item_sn_dim snd ON ft.physical_item_sn_id = snd.physical_item_sn_id 
LEFT OUTER JOIN pfsa_pba_ref pba ON ft.pba_id = pba.pba_id  
ORDER BY ft.physical_item_id, ft.physical_item_sn_id, ft.item_date_from_id, ft.item_date_to_id; 

/*

SELECT * 
FROM   vw_pfsawh_item_sn_p_fact 
WHERE  pba_id = 1000000; 
    
SELECT * 
FROM   vw_pfsawh_item_sn_p_fact 
WHERE  pba_id = 1000006; 
    
SELECT * 
FROM   vw_pfsawh_item_sn_p_fact 
WHERE  pba_id = 1000007; 
    
*/

/*

SELECT * 
FROM   vw_pfsawh_item_sn_p_fact 
WHERE  to_date = '15-SEP-2007' 
    AND item_serial_number LIKE '%MISSING%'; 

SELECT p.* 
FROM   pfsawh_item_sn_p_fact p
ORDER BY p.physical_item_sn_id, p.physical_item_id, p.item_date_from_id; 

*/

/*

SELECT * 
FROM   gcssa_hr_asset@pfsawh.lidbdev 
WHERE  serial_num LIKE '2AGR%' 
    AND lst_updt > '01-JUL-2007'

*/
