BEGIN

/*
    SELECT  pf.*, ' | ', ir.*  
    FROM    gb_pfsawh_item_sn_p_fact pf,  
        gb_pfsa_pba_items_ref ir  
    WHERE pf.pba_id = 1000000 
        AND pf.physical_item_sn_id > 0    
        AND pf.physical_item_id = ir.physical_item_id   
        AND pf.item_date_from_id BETWEEN ir.item_from_date_id AND ir.item_to_date_id  
        ; 
*/    

    DELETE  gb_pfsawh_item_sn_p_fact pf 
    WHERE   pf.pba_id <> 1000000; 
    
    COMMIT; 
        
    INSERT 
    INTO    gb_pfsawh_item_sn_p_fact 
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
    --    , status,
    --    updt_by,
    --    lst_updt,
    --    active_flag,
    --    active_date,
    --    inactive_date,
    --    insert_by,
    --    insert_date,
    --    update_by,
    --    update_date,
    --    delete_flag,
    --    delete_date,
    --    hidden_flag,
    --    hidden_date,
    --    notes
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
    --    , pf.status,
    --    pf.updt_by,
    --    pf.lst_updt,
    --    pf.active_flag,
    --    pf.active_date,
    --    pf.inactive_date,
    --    pf.insert_by,
    --    pf.insert_date,
    --    pf.update_by,
    --    pf.update_date,
    --    pf.delete_flag,
    --    pf.delete_date,
    --    pf.hidden_flag,
    --    pf.hidden_date,
    --    pf.notes 
    FROM    gb_pfsawh_item_sn_p_fact pf,  
        gb_pfsa_pba_items_ref ir  
    WHERE pf.pba_id = 1000000
        AND pf.physical_item_sn_id > 0    
        AND pf.physical_item_id = ir.physical_item_id   
        AND pf.item_date_from_id BETWEEN ir.item_from_date_id AND ir.item_to_date_id
    ;
    
    COMMIT; 
    
END; 

/* 

SELECT * 
FROM   vw_pfsawh_item_sn_p_fact 
WHERE  PBA_ID = 1000011; 
      
*/ 
    