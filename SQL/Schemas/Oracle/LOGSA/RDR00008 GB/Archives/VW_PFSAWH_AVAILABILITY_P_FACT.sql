CREATE OR REPLACE VIEW vw_pfsawh_availability_p_fact 
--
AS 
--
SELECT dt0.oracle_date     AS Oracle_Date, 
    dt1.oracle_date        AS To_Date, 
    item.end_item_nomen    AS EI_Nomen, 
    CASE p.avail_item_sn_ei_id 
        WHEN -1 THEN 'MISSING S/N' 
        WHEN 0  THEN 'AGGREGATE' 
        ELSE sn.item_serial_number
    END AS item_serial_number, 
    item.niin, 
    item.lin, 
    p.notes                AS Loading_Notes, 
    p.item_days , 
    p.period_hrs , 
    p.fmc_hrs , 
    p.mc_hrs , 
    p.pmc_hrs , 
    p.nmc_hrs , 
    p.nmcm_hrs , 
    p.nmcm_user_hrs , 
    p.nmcm_int_hrs , 
    p.nmcm_dep_hrs , 
    p.nmcs_hrs , 
    p.nmcs_user_hrs , 
    p.nmcs_int_hrs , 
    p.nmcs_dep_hrs , 
    p.pmcm_hrs , 
    p.pmcm_user_hrs , 
    p.pmcm_int_hrs , 
    p.dep_hrs , 
    p.pmcs_hrs , 
    p.pmcs_user_hrs , 
    p.pmcs_int_hrs , 
    sn.item_registration_num ,
    sn.item_location ,
    sn.item_uic ,
    sn.item_uic_location ,
    sn.item_soc_flag , 
    sn.item_acq_date     
FROM   gb_pfsawh_availability_p_fact p 
LEFT OUTER JOIN gb_pfsawh_date_dim dt0 ON p.date_id = dt0.date_id 
LEFT OUTER JOIN gb_pfsawh_date_dim dt1 ON p.avail_date_to = dt1.date_id 
LEFT OUTER JOIN gb_pfsawh_item_dim item ON p.avail_item_sys_ei_id = item.item_id 
LEFT OUTER JOIN gb_pfsawh_item_sn_dim sn ON p.avail_item_sn_ei_id = sn.item_sn_id 
ORDER BY item.niin, sn.item_serial_number, dt1.oracle_date;  

SELECT * 
FROM   vw_pfsawh_availability_p_fact 
WHERE  to_date = '15-SEP-2007' 
    AND item_serial_number LIKE '%AGR%';

SELECT p.* 
FROM   gb_pfsawh_availability_p_fact p
ORDER BY p.avail_item_sn_ei_id, p.avail_item_sys_ei_id, p.avail_date_from;

/*

SELECT * 
FROM   gcssa_hr_asset@pfsawh.lidbdev 
WHERE  serial_num LIKE '2AGR%' 
    AND lst_updt > '01-JUL-2007'

*/
