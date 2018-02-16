UPDATE cbmwh_item_sn_p_fact pf
SET    (   
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
        nmcs_dep_hrs
        ) = ( 
        SELECT   item_days,
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
            nmcs_dep_hrs
        FROM   pfsa_equip_avail pea 
        WHERE  pea.pfsa_item_id = 'LA20114U' 
            AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
            ) 
WHERE pf.physical_item_sn_id = 91646; 

COMMIT; 


SELECT physical_item_sn_id, 
    COUNT(physical_item_id) 
FROM   pfsa_usage_event 
WHERE  physical_item_id = 141223
GROUP BY physical_item_sn_id
ORDER BY COUNT(physical_item_sn_id) DESC; 

SELECT *
FROM   pfsa_usage_event 
WHERE  physical_item_sn_id = 91602
ORDER BY from_dt DESC; 

SELECT * 
FROM   pfsa_equip_avail 
WHERE  sys_ei_niin = '013285964' 
    AND pfsa_item_id = 'LA20114U'
ORDER BY from_dt DESC;

SELECT pfsa_item_id, 
    COUNT(pfsa_item_id) 
FROM   pfsa_equip_avail 
WHERE  sys_ei_niin = '013285964' 
GROUP BY pfsa_item_id 
ORDER BY COUNT(pfsa_item_id) DESC; 

SELECT * 
FROM   cbmwh_item_sn_p_fact 
WHERE  physical_item_sn_id = 91646
ORDER BY date_id DESC; 

