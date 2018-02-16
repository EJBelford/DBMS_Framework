SELECT  f.maint_action_cnt, f.total_down_time, '|', f.* 
FROM    pfsawh_item_sn_p_fact f 
WHERE   f.physical_item_id = 141146 
--    AND f.pba_id IN (1000006, 1000016, 1000022) 
--    AND f.maint_action_cnt IS NOT NULL 
ORDER BY f.maint_action_cnt DESC NULLS LAST, f.total_down_time; 

SELECT  a.date_cmplt_readiness_prd_id, 
        a.tsk_days_to_cmplt, 
        '|', a.*     
FROM    pfsawh_maint_itm_wrk_fact a
WHERE   a.physical_item_id = 141223 
    AND a.pba_id IN (1000006, 1000016)
; 

SELECT  
DISTINCT a.physical_item_sn_id, 
        a.maint_ev_id_a, 
        a.maint_ev_id_b, 
        a.date_cmplt_readiness_prd_id, 
        a.tsk_days_to_cmplt, 
        a.evnt_cmpl_date_id - a.evnt_begin_date_id    
FROM    pfsawh_maint_itm_wrk_fact a
WHERE   a.physical_item_id = 141223 
    AND a.pba_id IN (1000006, 1000016)
; 

SELECT  a.date_cmplt_readiness_prd_id, 
        a.physical_item_sn_id, 
        COUNT(a.physical_item_sn_id), 
        SUM(a.evnt_cmpl_date_id - a.evnt_begin_date_id)  
FROM    pfsawh_maint_itm_wrk_fact a
WHERE   a.physical_item_id = 141223 
    AND a.pba_id IN (1000006, 1000016)
GROUP BY a.physical_item_sn_id, 
        a.maint_ev_id_a, 
        a.maint_ev_id_b,
        a.date_cmplt_readiness_prd_id
ORDER BY a.physical_item_sn_id, 
        a.date_cmplt_readiness_prd_id; 

SELECT  a.EVNT_CMPL_DATE_ID,
        b.READY_DATE, 
        fn_date_to_date_id(b.READY_DATE) 
FROM    pfsawh_maint_itm_wrk_fact a, 
        pfsawh_ready_date_dim   b
WHERE   a.physical_item_id = 141223 
    AND a.pba_id IN (1000006, 1000016)  
    AND a.EVNT_CMPL_DATE_ID = b.DATE_DIM_ID
; 

/*---------------------------------------------------------------------------*/ 

UPDATE  pfsawh_maint_itm_wrk_fact a
SET     date_cmplt_readiness_prd_id = 
            (
            SELECT fn_date_to_date_id(b.READY_DATE) 
            FROM    pfsawh_ready_date_dim   b
            WHERE   a.EVNT_CMPL_DATE_ID = b.DATE_DIM_ID
            )
WHERE   a.physical_item_id = 141147 
    AND a.pba_id IN (1000006, 1000016, 1000022);
    
COMMIT; 

SELECT  a.date_cmplt_readiness_prd_id 
    , '|', a.* 
FROM    pfsawh_maint_itm_wrk_fact a
WHERE   a.physical_item_id = 141146; 

------

UPDATE  pfsawh_maint_itm_wrk_fact a
SET     tsk_days_to_cmplt = a.evnt_cmpl_date_id - a.evnt_begin_date_id 
WHERE   a.physical_item_id = 141147 
    AND a.pba_id IN (1000006, 1000016, 1000022);
    
COMMIT; 

SELECT  a.date_cmplt_readiness_prd_id, tsk_days_to_cmplt, 
    a.evnt_cmpl_date_id, a.evnt_begin_date_id
    , '|', a.* 
FROM    pfsawh_maint_itm_wrk_fact a
WHERE   a.physical_item_id = 141146; 

-----

UPDATE  pfsawh_item_sn_p_fact p
SET     (maint_action_cnt, total_down_time) = 
            (
            SELECT  COUNT(a.physical_item_sn_id), 
                    SUM(a.tsk_days_to_cmplt)  
            FROM    pfsawh_maint_itm_wrk_fact a
            WHERE   a.date_cmplt_readiness_prd_id = item_date_to_id --p.date_id 
                AND a.physical_item_sn_id = p.physical_item_sn_id 
            GROUP BY a.physical_item_sn_id, 
                  --  a.maint_ev_id_a, 
                  --  a.maint_ev_id_b,
                    a.date_cmplt_readiness_prd_id 
            ) 
WHERE   p.physical_item_id = 141147 
    AND p.pba_id IN (1000006, 1000016, 1000022);
        
COMMIT; 

SELECT  p.maint_action_cnt, p.total_down_time 
    , '|', p.* 
FROM    pfsawh_item_sn_p_fact p
WHERE   p.physical_item_id = 141146 
    AND p.pba_id IN (1000006, 1000016, 1000022);
      
    
SELECT  p.date_id, '|', a.date_cmplt_readiness_prd_id, tsk_days_to_cmplt, 
    a.evnt_cmpl_date_id, a.evnt_begin_date_id
    , '||', a.* 
FROM    pfsawh_maint_itm_wrk_fact a, 
        pfsawh_item_sn_p_fact p
WHERE   a.physical_item_id = 141147
        AND a.physical_item_id = p.physical_item_id
        AND a.date_cmplt_readiness_prd_id = p.date_id; 

SELECT  p.* 
FROM    pfsawh_item_sn_p_fact p
WHERE   p.physical_item_id = 141147 
    AND date_id > 31398
ORDER BY p.physical_item_sn_id, p.date_id;