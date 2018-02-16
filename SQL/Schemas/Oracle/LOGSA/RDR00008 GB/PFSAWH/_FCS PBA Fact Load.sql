SELECT pf.*
FROM   pfsawh_item_sn_p_fact pf; 

SELECT ir.* 
FROM   pfsa_pba_items_ref ir
WHERE  item_identifier_type_id = 14
ORDER BY ir.pba_id, item_identifier_type_id, item_type_value; 

SELECT ir.pba_id, 
    pf.*, 
    ir.* 
FROM   pfsawh_item_sn_p_fact pf, 
       pfsa_pba_items_ref ir
WHERE pf.physical_item_sn_id = ir.physical_item_sn_id
ORDER BY ir.pba_id, item_identifier_type_id, item_type_value; 

INSERT 
INTO   pfsawh_item_sn_t_fact 
    (
    date_id, 
    physical_item_id, 
    physical_item_sn_id,
    mimosa_item_sn_id,
    item_date_from_id, 
    item_date_to_id, 
    tran_mc_hrs,
    tran_fmc_hrs,
    tran_pmc_hrs,
    tran_nmc_hrs,
    pba_id
    )
SELECT
    pt.date_id, 
    pt.physical_item_id, 
    pt.physical_item_sn_id, 
    pt.mimosa_item_sn_id, 
    pt.item_date_from_id, 
    pt.item_date_from_id + ROUND(NVL(pt.tran_fmc_hrs, 0) / 24, 0), 
    NVL(pt.tran_fmc_hrs, 0),   
    NVL(pt.tran_fmc_hrs, 0),   
    0 , 
    0 ,
    ir.pba_id 
FROM   pfsawh_item_sn_t_fact pt, 
       pfsa_pba_items_ref ir
WHERE pt.pba_id = 1000000
    AND pt.physical_item_sn_id > 0    
    AND pt.physical_item_sn_id = ir.physical_item_sn_id; 

COMMIT;


INSERT 
INTO    pfsawh_item_sn_p_fact 
    (
    pba_id, 
--     
    period_type,
    date_id,
    physical_item_id,
    physical_item_sn_id,
    mimosa_item_sn_id,
    item_date_from_id,
    item_time_from_id,
    item_date_to_id,
    item_time_to_id,
    item_force_id,
    item_location_id,
    item_usage,
    item_usage_type,
    item_days,
    period_hrs,
    mc_hrs,
    fmc_hrs,
    pmc_hrs,
    pmcm_hrs,
    pmcm_user_hrs,
    pmcm_int_hrs,
    pmcs_hrs,
    pmcs_user_hrs,
    pmcs_int_hrs,
    nmc_hrs,
    nmcm_hrs,
    nmcm_user_hrs,
    nmcm_int_hrs,
    nmcs_hrs,
    nmcs_user_hrs,
    nmcs_int_hrs,
    dep_hrs,
    nmcm_dep_hrs,
    nmcs_dep_hrs,
    operational_readiness_rate,
    operating_cost_per_hour,
    cost_parts,
    cost_manpower,
    deferred_maint_items,
    operat_hrs_since_last_overhaul,
    maint_hrs_since_last_overhaul,
    time_since_last_overhaul
    ) 
SELECT 
    ir.pba_id, 
--    
    pf.period_type,
    pf.date_id,
    pf.physical_item_id,
    pf.physical_item_sn_id,
    pf.mimosa_item_sn_id,
    pf.item_date_from_id,
    pf.item_time_from_id,
    pf.item_date_to_id,
    pf.item_time_to_id,
    pf.item_force_id,
    pf.item_location_id,
    pf.item_usage,
    pf.item_usage_type,
    pf.item_days,
    pf.period_hrs,
    pf.mc_hrs,
    pf.fmc_hrs,
    pf.pmc_hrs,
    pf.pmcm_hrs,
    pf.pmcm_user_hrs,
    pf.pmcm_int_hrs,
    pf.pmcs_hrs,
    pf.pmcs_user_hrs,
    pf.pmcs_int_hrs,
    pf.nmc_hrs,
    pf.nmcm_hrs,
    pf.nmcm_user_hrs,
    pf.nmcm_int_hrs,
    pf.nmcs_hrs,
    pf.nmcs_user_hrs,
    pf.nmcs_int_hrs,
    pf.dep_hrs,
    pf.nmcm_dep_hrs,
    pf.nmcs_dep_hrs,
    pf.operational_readiness_rate,
    pf.operating_cost_per_hour,
    pf.cost_parts,
    pf.cost_manpower,
    pf.deferred_maint_items,
    pf.operat_hrs_since_last_overhaul,
    pf.maint_hrs_since_last_overhaul,
    pf.time_since_last_overhaul
FROM    pfsawh_item_sn_p_fact pf,  
    pfsa_pba_items_ref ir  
WHERE pf.pba_id = 1000000
    AND pf.physical_item_sn_id > 0    
    AND pf.physical_item_sn_id = ir.physical_item_sn_id;   

COMMIT;

SELECT pt.* 
FROM   vw_pfsawh_item_sn_t_fact pt,  
    pfsa_pba_items_ref ir 
WHERE  pt.pba_id = 1000000
    AND pt.physical_item_sn_id > 0    
    AND pt.pba_id = ir.pba_id;     
--    AND pt.physical_item_sn_id = ir.physical_item_sn_id;   

SELECT * 
FROM   vw_pfsawh_item_sn_t_fact 
WHERE  pba_id = 1000006; 

SELECT * 
FROM   vw_pfsawh_item_sn_t_fact 
WHERE  pba_id = 1000007; 


SELECT pf.* 
FROM   vw_pfsawh_item_sn_p_fact pf
WHERE  pf.pba_id = 1000000
    AND pf.physical_item_sn_id > 0
ORDER BY pf.physical_item_id, pf.physical_item_sn_id, item_date_from_id;   

SELECT pf.pba_id, pf.* 
FROM   vw_pfsawh_item_sn_p_fact pf
WHERE  pf.pba_id = 1000006
ORDER BY pf.physical_item_id, pf.physical_item_sn_id, item_date_from_id; 

SELECT pf.pba_id, pf.* 
FROM   vw_pfsawh_item_sn_p_fact pf 
WHERE  pf.pba_id = 1000007
ORDER BY pf.physical_item_id, pf.physical_item_sn_id, item_date_from_id; 

/*

UPDATE pfsawh_item_sn_dim 
SET    item_force_id = (
             SELECT pir.force_unit_id 
             FROM   pfsa_pba_items_ref pir 
             WHERE  pir.item_identifier_type_id = 14 
                 AND pfsawh_item_sn_dim.physical_item_sn_id = pir.PHYSICAL_ITEM_SN_ID
                 AND pir.pba_id = 1000006 
             ); 
             
UPDATE pfsawh_item_sn_dim 
SET    item_uic = (
             SELECT fu.uic 
             FROM   pfsawh_force_unit_dim fu 
             WHERE  fu.force_unit_id = pfsawh_item_sn_dim.item_force_id
                 AND fu.status = 'C' 
             ) 
WHERE item_force_id IS NOT NULL; 
             
SELECT * 
FROM   pfsawh_item_sn_dim
WHERE item_force_id IS NOT NULL;  

-- ROLLBACK;    

COMMIT;         

*/