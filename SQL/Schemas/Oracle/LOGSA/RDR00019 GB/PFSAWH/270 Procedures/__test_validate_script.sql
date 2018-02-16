SELECT pea.pba_id, 
    pea.sys_ei_niin, pea.pfsa_item_id, pea.physical_item_id AS item_id,  
    pea.sys_ei_sn, pea.physical_item_sn_id AS item_sn_id, 
    pea.from_dt, pea.to_dt,
    pea.fmc_hrs, pea.pmc_hrs, pea.nmc_hrs, 
    '|', pea.* 
FROM   pfsa_equip_avail pea
WHERE  pea.sys_ei_niin = '013285964'
    AND pea.from_dt > TO_DATE('01-JUN-2008', 'DD-MON-YYYY')
    AND pea.sys_ei_sn <> 'AGGREGATE' 
ORDER BY pea.sys_ei_sn, pea.from_dt; 

SELECT pea.pba_id, 
    pea.sys_ei_niin, pea.pfsa_item_id, pea.physical_item_id AS item_id,  
    pea.sys_ei_sn, pea.physical_item_sn_id AS item_sn_id, 
    pea.from_dt, pea.to_dt,
    pea.fmc_hrs, pea.pmc_hrs, pea.nmc_hrs, 
    '|', pea.* 
FROM   pfsa_equip_avail pea
WHERE  pea.sys_ei_niin = '013285964'
    AND pea.from_dt > TO_DATE('01-JUN-2008', 'DD-MON-YYYY')
    AND pea.sys_ei_sn = 'LA19030U' --  'LA19030U' 'LA26275U'
ORDER BY pea.sys_ei_sn, pea.from_dt; 

SELECT pue.pba_id, pue.uic AS uic___, 
    pue.sys_ei_niin, pue.pfsa_item_id, pue.physical_item_id AS item_id,  
    pue.sys_ei_sn, pue.physical_item_sn_id AS item_sn_id, 
    pue.from_dt, pue.to_dt, FN_DATE_ID_TO_DATE(pue.month_seg_date_id) AS mn_dt,   
    pue.usage_mb, ROUND(pue.usage, 5) as usage,  
    '|', pue.* 
FROM   pfsa_usage_event pue
WHERE  pue.sys_ei_niin = '013285964'
    AND pue.from_dt > TO_DATE('01-JUN-2008', 'DD-MON-YYYY')
    AND pue.sys_ei_sn = 'LA19030U' --  'LA19030U'  'LA26275U'
    AND pue.hidden_flag = 'N' 
ORDER BY pue.sys_ei_sn, pue.from_dt;

SELECT * 
FROM   pfsawh_force_unit_dim
WHERE  uic = 'WAGPAA' 
    AND status = 'C';

SELECT pf.pba_id, pf.item_force_id AS force_id, fud.uic, 
    pf.physical_item_id AS item_id, pf.physical_item_sn_id AS item_sn_id, 
    FN_DATE_ID_TO_DATE(pf.item_date_to_id) AS to_date, 
    pf.item_usage_type_0 AS use_typ, ROUND(pf.item_usage_0, 5) AS usage, pf.item_days AS days, 
    pf.fmc_hrs, pf.pmc_hrs, pf.nmc_hrs, 
    pf.maint_action_cnt AS mnt_act_cnt,  
    '|', pf.* 
FROM pfsawh_item_sn_p_fact pf 
LEFT OUTER JOIN pfsawh_force_unit_dim fud 
    ON fud.force_unit_id = pf.item_force_id 
        AND fud.status = 'C' 
WHERE  pf.physical_item_sn_id = 141146 -- 97524 102811 
    AND pf.item_date_from_id BETWEEN 31305 AND 31366    
ORDER BY pf.pba_id, fud.uic, pf.item_date_to_id;

SELECT pf.etl_processed_by, pf.rec_id, pf.date_id, 
     pf.item_date_from_id, pf.item_date_to_id, 
     pf.physical_item_id, pf.physical_item_sn_id,  
     pf.item_force_id, 
    '|', pf.* 
FROM pfsawh_item_sn_p_fact pf 
LEFT OUTER JOIN pfsawh_force_unit_dim fud 
    ON fud.force_unit_id = pf.item_force_id 
        AND fud.status = 'C' 
WHERE  pf.physical_item_sn_id = 102811 -- 97524 102811 
    AND pf.item_date_from_id BETWEEN 31365 AND 31519 
ORDER BY  pf.etl_processed_by, pf.date_id, 
     pf.item_date_from_id, pf.item_date_to_id, 
     pf.physical_item_id, pf.physical_item_sn_id;

/*---------------------------------------------------------------------------*/ 
/*-----                  pfsawh_maint_itm_wrk_fact                      -----*/ 
/*---------------------------------------------------------------------------*/ 

SELECT pf.physical_item_id,  
    pf.physical_item_sn_id, 
    pf.force_unit_id, 
    pf.dt_maint_ev_cmpl  
    , '|', pf.* 
FROM   pfsa_maint_event pf  
WHERE  pf.physical_item_id = 141146 
    AND pf.dt_maint_ev_cmpl BETWEEN TO_DATE('01-MAY-2007', 'DD-MON-YYYY') AND 
         TO_DATE('01-JUN-2007', 'DD-MON-YYYY') 
    AND pf.hidden_flag = 'N' 
ORDER BY pf.maint_item_sn, pf.dt_maint_ev_cmpl; 

SELECT  
    NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_begin, 'DD-MON-YYYY')), 
        NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_est, 'DD-MON-YYYY')), 
            0)) AS tsk_begin_date_id, 
--    NVL(fn_time_to_time_id(tk.tsk_begin),       
--        NVL(fn_time_to_time_id(ev.dt_maint_ev_est), 
--            10001)) AS tsk_begin_time_id, 
    NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_end, 'DD-MON-YYYY')), 
        NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_cmpl, 'DD-MON-YYYY')), 
            0)) AS tsk_end_date_id, 
--    NVL(fn_time_to_time_id(tk.tsk_end),       
--        NVL(fn_time_to_time_id(ev.dt_maint_ev_cmpl), 
--            96400)) AS tsk_end_time_id, 
    ev.physical_item_id,  
    ev.physical_item_sn_id, 
    ev.force_unit_id,
    ev.pba_id,
    ev.mimosa_item_sn_id,
    NVL(SUBSTR(ev.maint_ev_id, 1, INSTR(ev.maint_ev_id, '|')-1), '0') AS maint_ev_id_a, 
    NVL(SUBSTR(ev.maint_ev_id, INSTR(ev.maint_ev_id, '|')+1, LENGTH(ev.maint_ev_id)), '0') AS maint_ev_id_b, 
    NVL(tk.maint_task_id, 0) AS maint_task_id, 
    NVL(wk.maint_work_id, 0) AS maint_work_id,
    ev.maint_org, 
    ev.maint_uic, 
    ev.maint_lvl_cd, 
    NVL(tk.elapsed_tsk_wk_tm, 0) AS elapsed_tsk_wk_tm, 
    NVL(tk.inspect_tsk, 'U') AS inspect_tsk, 
    NVL(tk.essential, 'U') AS essential, 
    NVL(wk.maint_work_mh, '') AS maint_work_mh, 
    NVL(wk.mil_civ_kon, 'U') AS mil_civ_kon, 
    NVL(wk.mos, 'UNK') AS mos, 
    NVL(wk.spec_person, 'UNKNOWN') AS spec_person, 
    NVL(wk.repair, 'U') AS repair, 
    NVL(wk.mos_sent, 'UNK') AS mos_sent,
    cust_org,
    cust_uic,
    fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_est, 'DD-MON-YYYY')) AS evnt_begin_date_id,
    fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_cmpl, 'DD-MON-YYYY')) as evnt_cmpl_date_id,
    fault_malfunction_descr,
    won    
FROM   pfsa_maint_event ev, 
       pfsa_maint_task tk,
       pfsa_maint_work wk 
WHERE  ev.physical_item_id   = 141146 
    AND ev.physical_item_sn_id = 113771
    AND tk.pba_id (+)        = ev.pba_id
    AND tk.maint_ev_id (+)   = ev.maint_ev_id
    AND wk.pba_id (+)        = tk.pba_id 
    AND wk.maint_ev_id (+)   = tk.maint_ev_id 
    AND wk.maint_task_id (+) = tk.maint_task_id 
    AND ev.delete_flag = 'N'
ORDER BY ev.physical_item_sn_id, 
    ev.force_unit_id;
            
SELECT date_cmplt_readiness_prd_id, 
      FN_DATE_ID_TO_DATE(pf.tsk_end_date_id) AS end_date, 
      pf.tsk_days_to_cmplt, 
      pf.force_unit_id, 
      pf.physical_item_sn_id, 
      pf.maint_ev_id_a  
    , '|', pf.* 
FROM   pfsawh_maint_itm_wrk_fact pf  
WHERE  pf.physical_item_id = 141146
    AND pf.physical_item_sn_id = 113771
--    AND pf.tsk_end_date_id BETWEEN 30939 and 30970 
ORDER BY pf.tsk_end_date_id DESC, pf.tsk_days_to_cmplt DESC NULLS LAST; 

SELECT pf.physical_item_sn_id, 
    pf.item_force_id, 
    fud.uic, 
    FN_DATE_ID_TO_DATE(pf.item_date_from_id) AS from_date, 
    pf.maint_action_cnt, 
    pf.total_down_time  
    , '|', pf.* 
FROM   pfsawh_item_sn_p_fact pf  
    LEFT OUTER JOIN pfsawh_force_unit_dim fud ON fud.force_unit_id = pf.item_force_id 
        AND fud.status = 'C' 
WHERE  pf.physical_item_id = 141146 
    AND pf.physical_item_sn_id = 113771
--    AND pf.item_date_from_id BETWEEN 31458 and 31489 
ORDER BY pf.total_down_time DESC NULLS LAST, pf.item_date_from_id; 


