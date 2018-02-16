/*----- by period -----*/ 

SELECT pea.ready_date, 
    pea.sys_ei_niin, 
    pea.physical_item_id, 
    SUM(pea.readiness_reported_qty) AS rdy_qty_rptd
FROM   pfsa_equip_avail pea 
WHERE  pea.sys_ei_niin = 013285964 
    AND pea.ready_date > TO_DATE('01-SEP-06', 'DD-MON-YY') 
    AND delete_flag = 'N' 
GROUP BY pea.ready_date, pea.sys_ei_niin, pea.physical_item_id 
ORDER By pea.ready_date DESC; 


    SELECT 
    pba_id, 
    physical_item_id, 
fn_date_id_to_date(item_date_to_id) r_date
--         , ( ( tot_fmc_hrs / tot_period_hrs ) * 100 ) fmc_rate
--         , ( ( tot_nmcm_hrs / tot_period_hrs ) * 100 ) nmcm_rate
--         , ( ( tot_nmcs_hrs / tot_period_hrs ) * 100 ) nmcs_rate
         , tot_readiness_qty AS tot_rdy_qty
    FROM   ( SELECT  a.pba_id, a.physical_item_id, a.item_date_to_id
                   , SUM( Nvl( a.fmc_hrs, 0 )) tot_fmc_hrs
                   , SUM( Nvl( a.nmcm_hrs, 0 )) tot_nmcm_hrs
                   , SUM( Nvl( a.nmcs_hrs, 0 )) tot_nmcs_hrs
                   , SUM( Nvl( a.period_hrs, 0 )) tot_period_hrs
                   , SUM( Nvl( a.readiness_reported_qty, 0 )) tot_readiness_qty
            FROM     pfsawh_item_sn_p_fact a
                   , pfsawh_ready_date_dim b
                   , pfsa_fcs_sys_dates c
            WHERE    a.item_date_to_id = b.date_dim_id
AND physical_item_id = 141223             
            AND      ( b.ready_date
                           BETWEEN Add_months( c.equip_avail_period_date, -24 )
                               AND c.equip_avail_period_date
                     )
            AND      a.period_hrs > 0
            GROUP BY pba_id, physical_item_id, item_date_to_id
            ORDER BY pba_id, physical_item_id, item_date_to_id DESC );

 
/*----- by serial number -----*/ 

SELECT pea.ready_date, 
    pea.sys_ei_niin, 
    pea.physical_item_id, 
    pea.sys_ei_sn, 
    pea.physical_item_sn_id, 
--    pea.force_unit_id, 
    SUM(pea.readiness_reported_qty) AS rdy_qty_rptd
FROM   pfsa_equip_avail pea 
WHERE  pea.sys_ei_niin = 013285964 
    AND pea.ready_date = TO_DATE('15-SEP-08', 'DD-MON-YY')
GROUP BY pea.ready_date, pea.sys_ei_niin, pea.physical_item_id, 
    pea.sys_ei_sn, pea.physical_item_sn_id
--    , pea.force_unit_id  
ORDER BY pea.physical_item_sn_id, pea.physical_item_id; 


    SELECT 
    pba_id, 
    physical_item_id, 
    physical_item_sn_id, 
fn_date_id_to_date(item_date_to_id) r_date
--         , ( ( tot_fmc_hrs / tot_period_hrs ) * 100 ) fmc_rate
--         , ( ( tot_nmcm_hrs / tot_period_hrs ) * 100 ) nmcm_rate
--         , ( ( tot_nmcs_hrs / tot_period_hrs ) * 100 ) nmcs_rate
         , tot_readiness_qty AS tot_rdy_qty
    FROM   ( SELECT  a.pba_id, a.physical_item_id, a.physical_item_sn_id, a.item_date_to_id
                   , SUM( Nvl( a.fmc_hrs, 0 )) tot_fmc_hrs
                   , SUM( Nvl( a.nmcm_hrs, 0 )) tot_nmcm_hrs
                   , SUM( Nvl( a.nmcs_hrs, 0 )) tot_nmcs_hrs
                   , SUM( Nvl( a.period_hrs, 0 )) tot_period_hrs
                   , SUM( Nvl( a.readiness_reported_qty, 0 )) tot_readiness_qty
            FROM     pfsawh_item_sn_p_fact a
                   , pfsawh_ready_date_dim b
                   , pfsa_fcs_sys_dates c
            WHERE    a.item_date_to_id = b.date_dim_id
AND physical_item_id = 141223             
            AND      ( b.ready_date = TO_DATE('15-SEP-08', 'DD-MON-YY') 
--                           BETWEEN Add_months( c.equip_avail_period_date, -24 )
--                               AND c.equip_avail_period_date
                     )
            AND      a.period_hrs > 0
            GROUP BY pba_id, physical_item_id, item_date_to_id, physical_item_sn_id
            ORDER BY pba_id, physical_item_id, physical_item_sn_id/*, item_date_to_id DESC*/)
    ORDER BY pba_id, physical_item_sn_id;


 
/*----- for a specific record -----*/ 

SELECT pea.ready_date, 
    fn_date_id_to_date(pea.ready_date_id) AS ready_date_id, 
    pea.sys_ei_niin, 
    pea.physical_item_id, 
    pea.sys_ei_sn, 
    pea.physical_item_sn_id, 
    pea.force_unit_id, 
    fud.uic, 
    pea.readiness_reported_qty  
    , '|', pea.* 
FROM   pfsa_equip_avail pea 
LEFT OUTER JOIN pfsawh_force_unit_dim fud ON fud.force_unit_id = pea.force_unit_id 
    AND fud.status = 'C'
WHERE  pea.sys_ei_niin = 013285964 
    AND pea.sys_ei_sn = 'LA22005U' 
    AND pea.ready_date = TO_DATE('15-SEP-08', 'DD-MON-YY')
ORDER BY pea.ready_date DESC, pea.sys_ei_sn; 


SELECT fn_date_id_to_date(pf.date_id) AS r_date, 
    pf.date_id, 
    pf.physical_item_id, 
    pf.physical_item_sn_id, 
    pf.item_force_id, 
    fud.uic, 
    pf.force_command_unit_id,  
    pf.readiness_reported_qty  
    , '|', pf.* 
FROM   pfsawh_item_sn_p_fact pf 
LEFT OUTER JOIN pfsawh_force_unit_dim fud ON fud.force_unit_id = pf.item_force_id 
    AND fud.status = 'C'
WHERE  pf.physical_item_id = 141223
    AND pf.physical_item_sn_id = 76135
    AND pf.item_date_to_id = 31443
ORDER BY pf.date_id DESC;  


/*----- force -----*/ 

SELECT pea.ready_date, 
    fn_date_id_to_date(pea.ready_date_id) AS ready_date_id, 
    pea.sys_ei_niin, 
    pea.physical_item_id, 
    pea.sys_ei_sn, 
    pea.physical_item_sn_id, 
    pea.pfsa_org, 
    pea.force_unit_id, 
    pea.readiness_reported_qty  
    , '|', pea.* 
FROM   pfsa_equip_avail pea 
WHERE  pea.sys_ei_niin = 013285964 
    AND pea.force_unit_id < 1  
    AND pea.ready_date = TO_DATE('15-SEP-08', 'DD-MON-YY')
ORDER BY pea.ready_date DESC, pea.sys_ei_sn; 

SELECT fud.uic, 
    fud.force_command_unit_code
    , '|', fud.* 
FROM   pfsawh_force_unit_dim fud 
WHERE  fud.force_unit_id IN (300930, 300926)
    AND fud.status = 'C'; 


/*----- Create shell -----*/ 


    SELECT pea.physical_item_id, 
        pea.sys_ei_niin AS item_niin,  
        pea.physical_item_sn_id, 
        pea.sys_ei_sn AS item_serial_number, 
        pea.force_unit_id, 
        pea.ready_date  
        , '|', pea.*    
    FROM   pfsa_equip_avail pea   
    WHERE  pea.physical_item_id = 141223  
        AND pea.physical_item_sn_id = 76135 
    ORDER BY pea.ready_date;  

    SELECT pea.physical_item_id, 
        pea.sys_ei_niin AS item_niin,  
        pea.physical_item_sn_id, 
        pea.sys_ei_sn AS item_serial_number, 
        pea.force_unit_id,
        fud.force_command_unit_id,  
        pea.ready_date  
        , '|', pea.*    
    FROM   pfsa_equip_avail pea,    
        pfsawh_force_unit_dim fud   
    WHERE  pea.physical_item_id = 141223  
        AND pea.physical_item_sn_id = 76135 
        AND fud.status = 'C'  
        AND fud.force_unit_id = pea.force_unit_id 
    ORDER BY pea.ready_date;  

    SELECT 
    DISTINCT pf.pba_id, 
        pf.physical_item_id, 
        pf.physical_item_sn_id, 
        FN_DATE_ID_TO_DATE(pf.date_id) AS date_id,  
        pf.item_force_id  
--        , '|', pf.*  
    FROM   pfsawh_item_sn_p_fact pf 
    WHERE  pf.physical_item_id = 141223 
        AND pf.physical_item_sn_id = 76135
    ORDER BY date_id, pf.item_force_id; 

-- Unit cusor 

    SELECT   cisd.physical_item_id, cisd.item_niin, 
        cisd.physical_item_sn_id, cisd.item_serial_number, 
        cisd.wh_earliest_fact_rec_dt  
        , '|', cisd.*   
    FROM     pfsawh_item_sn_dim cisd     
--        , pfsawh_force_unit_dim fud 
    WHERE   cisd.physical_item_id = 141223  
        AND cisd.physical_item_sn_id = 76135  
        AND cisd.wh_flag = 'Y' 
        AND cisd.wh_earliest_fact_rec_dt IS NOT NULL
--        AND fud.status = 'C'  
--        AND fud.force_unit_id = cisd.item_force_id 
    ORDER BY cisd.physical_item_id, cisd.physical_item_sn_id;
