    UPDATE pfsawh_item_sn_p_fact pf
    SET    ( 
--            item_force_id,   
            item_days,
            period_hrs,
            mc_hrs,
            fmc_hrs,
            pmc_hrs,
            pmcm_hrs,
            pmcs_hrs,
            nmc_hrs,
            nmcm_hrs,
            nmcm_user_hrs,
            nmcm_int_hrs,
            nmcm_dep_hrs,
            nmcs_hrs,
            nmcs_user_hrs,
            nmcs_int_hrs,
            nmcs_dep_hrs, 
            readiness_reported_qty 
            ) = ( 
            SELECT 
--                NVL(force_unit_id, 0),  
                SUM(item_days),
                SUM(period_hrs),
                SUM(mc_hrs),
                SUM(fmc_hrs),
                SUM(pmc_hrs),
                SUM(pmcm_hrs),
                SUM(pmcs_hrs),
                SUM(nmc_hrs),
                SUM(nmcm_hrs),
                SUM(nmcm_user_hrs),
                SUM(nmcm_int_hrs),
                SUM(nmcm_dep_hrs),
                SUM(nmcs_hrs),
                SUM(nmcs_user_hrs),
                SUM(nmcs_int_hrs),
                SUM(nmcs_dep_hrs), 
                SUM(readiness_reported_qty)
            FROM   pfsa_equip_avail pea 
            WHERE  pea.physical_item_sn_id = pf.physical_item_sn_id  
                AND pea.pba_id = pf.pba_id  
                AND pea.force_unit_id = pf.item_force_id 
                AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
--                AND pea.physical_item_sn_id IS NOT NULL  
--                AND pea.force_unit_id IS NOT NULL
--                AND pea.sys_ei_sn <> 'AGGREGATE'
            GROUP BY pea.physical_item_sn_id, pea.pba_id, 
                pea.ready_date, pea.force_unit_id
                ) 
    WHERE pf.physical_item_id = 141147;
    
            SELECT pea.physical_item_sn_id, 
                pea.ready_date, 
                fn_date_to_date_id(pea.ready_date) AS to_date_id, 
                pea.pba_id,   
                NVL(pea.force_unit_id, 0), 
                SUM(pea.item_days),
                SUM(pea.period_hrs),
                SUM(pea.mc_hrs),
                SUM(pea.fmc_hrs),
                SUM(pea.pmc_hrs),
                SUM(pea.pmcm_hrs),
                SUM(pea.pmcs_hrs),
                SUM(pea.nmc_hrs),
                SUM(pea.nmcm_hrs),
                SUM(pea.nmcm_user_hrs),
                SUM(pea.nmcm_int_hrs),
                SUM(pea.nmcm_dep_hrs),
                SUM(pea.nmcs_hrs),
                SUM(pea.nmcs_user_hrs),
                SUM(pea.nmcs_int_hrs),
                SUM(pea.nmcs_dep_hrs), 
                SUM(pea.readiness_reported_qty)
            FROM   pfsa_equip_avail pea, 
                pfsawh_item_sn_p_fact pf 
            WHERE  pf.physical_item_id = 141147 
                AND pea.physical_item_sn_id = pf.physical_item_sn_id  
                AND pea.pba_id = pf.pba_id  
                AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
                AND pea.physical_item_sn_id IS NOT NULL  
                AND pea.force_unit_id IS NOT NULL
            GROUP BY /*pea.physical_item_id,*/ pea.physical_item_sn_id, 
                pea.ready_date, pea.force_unit_id, pea.pba_id 
            ORDER BY pea.physical_item_sn_id, pea.force_unit_id, pea.ready_date; 
            
            
            SELECT pea.physical_item_sn_id, 
                pea.ready_date,   
                pea.force_unit_id, 
                COUNT(pea.physical_item_sn_id)
            FROM   pfsa_equip_avail pea, 
                pfsawh_item_sn_p_fact pf 
            WHERE  pf.physical_item_id = 141147 
                AND pea.physical_item_sn_id = pf.physical_item_sn_id  
                AND pea.pba_id = pf.pba_id  
                AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
                AND pea.physical_item_sn_id IS NOT NULL  
                AND pea.force_unit_id IS NOT NULL
            GROUP BY /*pea.physical_item_id,*/ pea.physical_item_sn_id, 
                pea.ready_date, pea.force_unit_id
            ORDER BY COUNT(pea.physical_item_sn_id) DESC, pea.physical_item_sn_id, pea.force_unit_id, pea.ready_date; 