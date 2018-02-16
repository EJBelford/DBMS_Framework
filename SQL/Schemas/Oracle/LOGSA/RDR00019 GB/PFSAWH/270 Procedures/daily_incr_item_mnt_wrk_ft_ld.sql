CREATE OR REPLACE PROCEDURE daily_incr_item_mnt_wrk_ft_ld 
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

/*----- Test script -----*/

/*

BEGIN 

    daily_incr_item_mnt_wrk_ft_ld ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'DAILY_INCR_ITEM_MNT_WRK_FT_LD';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'no message defined'; /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- standard variables

ps_status                        VARCHAR2(10)  := 'STARTED';

ps_main_status                   VARCHAR2(10)  := null;

l_ps_start                       DATE          := sysdate;
l_now_is                         DATE          := sysdate;

l_call_error                     VARCHAR2(20)  := null;
ls_start                         DATE          := null;

proc0_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 pfsawh_process_log%ROWTYPE; 
proc1                 pfsawh_process_log%ROWTYPE; 

ps_last_process       pfsawh_processes%ROWTYPE;
ps_this_process       pfsawh_processes%ROWTYPE;
ls_current_process    pfsawh_processes%ROWTYPE; 

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days          pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                    NUMBER        := 0; 

v_etl_copy_cutoff          DATE; 
v_t_fact_cutoff            DATE; 
v_t_fact_cutoff_id         NUMBER; 
v_p_fact_cutoff            DATE; 
v_p_fact_cutoff_id         NUMBER; 
myrowcount                 NUMBER;
mytablename                VARCHAR2(64);

-- added date control lmj 05nov08

my_lst_updt                DATE := null;
my_insert_dt               DATE := null;
my_update_dt               DATE := null;

CURSOR item_sn_cur IS
    SELECT pea.physical_item_id, 
        it.niin, 
        it.item_nomen_standard, 
        pea.physical_item_sn_id, 
        pea.sys_ei_sn, 
        COUNT(pea.rec_id) 
    FROM   pfsa_maint_event pea 
    LEFT OUTER JOIN pfsawh_item_dim it ON it.physical_item_id = pea.physical_item_id 
    WHERE (pea.insert_date > my_lst_updt OR pea.update_date > my_lst_updt) 
        AND pea.physical_item_sn_id IS NOT NULL 
        AND pea.physical_item_sn_id > 0 
--        AND pea.sys_ei_niin = '014360005'
    GROUP BY pea.physical_item_id, 
        it.niin, 
        it.item_nomen_standard, 
        pea.sys_ei_sn, 
        pea.physical_item_sn_id  
    ORDER BY pea.physical_item_id; 

item_sn_rec    item_sn_cur%ROWTYPE;

BEGIN 

-- Get the process control values from PFSAWH_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
    v_t_fact_cutoff_days   := fn_pfsawh_get_prcss_cntrl_val('v_t_fact_cutoff_days'); 
    v_p_fact_cutoff_months := fn_pfsawh_get_prcss_cntrl_val('v_p_fact_cutoff_months');  

-- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    v_etl_copy_cutoff    := SYSDATE - v_etl_copy_cutoff_days; 
    v_t_fact_cutoff      := SYSDATE - v_t_fact_cutoff_days; 
    v_t_fact_cutoff_id   := fn_date_to_date_id(v_t_fact_cutoff); 
    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  (-1 * v_p_fact_cutoff_months)); 
    v_p_fact_cutoff_id   := fn_date_to_date_id(v_p_fact_cutoff); 

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_etl_copy_cutoff_days: ' || v_etl_copy_cutoff_days || ', ' || 
           'v_etl_copy_cutoff'        || v_etl_copy_cutoff
           );
    END IF;  

    proc0.process_RecId      := 584; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
  
    pr_pfsawh_insupd_processlog 
        (
        proc0.process_RecId, proc0.process_Key, 
        proc0.module_Num, proc0.step_Num,  
        proc0.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc0.user_Login_Id, NULL, proc0_recId
        );  
        
    COMMIT;     
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := NVL(type_maintenance, 'daily_incr_item_mnt_wrk_ft_ld');

-- Housekeeping for the process 
  
    ps_location := 'PFSAWH 00';            -- For std_pfsawh_debug_tbl logging. 

    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_status      := 'BEGAN';
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_compl       := null;

-- get the run criteria from the pfsa_processes table for the last run of this 
-- main process 
  
    get_pfsawh_process_info ( 
        ps_procedure_name, ps_procedure_name, ps_last_process.last_run, 
        ps_last_process.who_ran, ps_last_process.last_run_status, 
        ps_last_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- Update the PFSA_PROCESSES table to indicate MAIN process began.  

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );
      
    COMMIT;

-- Call the MERGE PBA REF routine.  

    ps_location := 'PFSAWH 10';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'DAILY_INCR_ITEM_MNT_WRK_FT_LD'; 
  
-- Get the run criteria from the PFSA_PROCESSES table for the last run of 
-- the MAINTAIN_PFSA_DATES process 
  
    get_pfsawh_process_info
        (
        ps_procedure_name, ls_current_process.pfsa_process, 
        ls_current_process.last_run, ls_current_process.who_ran, 
        ls_current_process.last_run_status, 
        ls_current_process.last_run_status_time, 
        ls_current_process.last_run_compl
        );

    ls_start                             := sysdate;
    ls_current_process.last_run          := ls_start;
    ls_current_process.last_run_status   := 'BEGAN';
    ls_current_process.who_ran           := ps_id_key;
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_status      := ps_location;

-- Update the pfsa_processes table to indicate MAIN process location.  

    ps_location := 'PFSAWH 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

-- Update the pfsa_processes table to indicate the sub-process 
-- MERGE PBA REF has started.  

    ps_location := 'PFSAWH 30';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 584; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        );
        
    ps_location := 'PFSAWH 40';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'DAILY_INCR_ITEM_MNT_WRK_FT_LD'; 
  
-- Get the run criteria for the PFSA_EQUIP_AVAIL from pfsa_process table 

    get_pfsawh_process_info
        (
        ps_procedure_name, ls_current_process.pfsa_process, 
        ls_current_process.last_run, ls_current_process.who_ran, 
        ls_current_process.last_run_status, 
        ls_current_process.last_run_status_time, 
        ls_current_process.last_run_compl
        );
  
    ls_start                           := SYSDATE;
    ls_current_process.last_run        := ls_start;
    l_call_error                       := NULL;
    ls_current_process.last_run_status := 'BEGAN';
    ls_current_process.who_ran         := ps_id_key;
 
-- Update the pfsa_process table to indicate STATUS of PFSA_EQUIP_AVAIL. 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
    ps_status := ps_location;
  
-- Update main process to indicate where its at 

    updt_pfsawh_processes
        (ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_status, l_now_is, 
        ps_this_process.last_run_compl
        ); 
      
    COMMIT;  
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    ps_location := 'PFSAWH 50';            -- For std_pfsawh_debug_tbl logging. 

    my_lst_updt := null;
    my_insert_dt := null;
    my_update_dt := null;
    
    SELECT MAX(insert_date) INTO my_insert_dt FROM pfsawh_maint_itm_wrk_fact;
    SELECT MAX(update_date) INTO my_update_dt FROM pfsawh_maint_itm_wrk_fact; 
    
    SELECT MAX(insert_date) INTO my_insert_dt FROM pfsa_maint_event;
    SELECT MAX(update_date) INTO my_update_dt FROM pfsa_maint_event; 
    
    if my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
 
    ps_location := 'PFSAWH 60';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   pfsawh_maint_itm_wrk_fact mwf 
    USING  
        (SELECT  
            NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_begin, 'DD-MON-YYYY')), 
                NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_est, 'DD-MON-YYYY')), 
                    0)) AS tsk_begin_date_id, 
            NVL(fn_time_to_time_id(tk.tsk_begin),       
                NVL(fn_time_to_time_id(ev.dt_maint_ev_est), 
                    10001)) AS tsk_begin_time_id, 
            NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_end, 'DD-MON-YYYY')), 
                NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_cmpl, 'DD-MON-YYYY')), 
                    0)) AS tsk_end_date_id, 
            NVL(fn_time_to_time_id(tk.tsk_end),       
                NVL(fn_time_to_time_id(ev.dt_maint_ev_cmpl), 
                    96400)) AS tsk_end_time_id, 
            ev.physical_item_id,  
            ev.physical_item_sn_id, 
            ev.mimosa_item_sn_id,
            ev.force_unit_id,
            ev.pba_id,
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
        WHERE  tk.pba_id (+)        = ev.pba_id
            AND tk.maint_ev_id (+)   = ev.maint_ev_id
            AND wk.pba_id (+)        = tk.pba_id 
            AND wk.maint_ev_id (+)   = tk.maint_ev_id 
            AND wk.maint_task_id (+) = tk.maint_task_id 
            AND ev.delete_flag = 'N' 
            AND (my_lst_updt < ev.insert_date OR my_lst_updt < ev.update_date)
        )metw 
    ON(    metw.pba_id           = mwf.pba_id
       AND metw.maint_ev_id_a    = mwf.maint_ev_id_a
       AND metw.maint_ev_id_b    = mwf.maint_ev_id_b
       AND metw.maint_task_id    = mwf.maint_task_id
       AND metw.maint_work_id    = mwf.maint_work_id
      )
    WHEN MATCHED THEN
    UPDATE SET 
        mwf.tsk_begin_date_id         = metw.tsk_begin_date_id, 
        mwf.tsk_begin_time_id         = metw.tsk_begin_time_id, 
        mwf.tsk_end_date_id           = metw.tsk_end_date_id, 
        mwf.tsk_end_time_id           = metw.tsk_end_time_id, 
        mwf.physical_item_sn_id       = metw.physical_item_sn_id, 
        mwf.mimosa_item_sn_id         = metw.mimosa_item_sn_id, 
        mwf.force_unit_id             = metw.force_unit_id, 
        mwf.maint_org                 = metw.maint_org, 
        mwf.maint_uic                 = metw.maint_uic, 
        mwf.maint_lvl_cd              = metw.maint_lvl_cd, 
        mwf.elapsed_tsk_wk_tm         = metw.elapsed_tsk_wk_tm, 
        mwf.inspect_tsk               = metw.inspect_tsk, 
        mwf.essential_tsk             = metw.essential, 
        mwf.maint_work_mh             = metw.maint_work_mh, 
        mwf.wrk_mil_civ_kon           = metw.mil_civ_kon, 
        mwf.wrk_mos                   = metw.mos, 
        mwf.wrk_spec_person           = metw.spec_person, 
        mwf.wrk_repair                = metw.repair, 
        mwf.wrk_mos_sent              = metw.mos_sent,
        mwf.cust_org                  = metw.cust_org,
        mwf.cust_uic                  = metw.cust_uic,
        mwf.evnt_begin_date_id        = metw.evnt_begin_date_id,
        mwf.evnt_cmpl_date_id         = metw.evnt_cmpl_date_id,
        mwf.fault_malfunction_descr   = metw.fault_malfunction_descr,
        mwf.won                       = metw.won, 
        mwf.etl_processed_by          = ps_procedure_name                           
    WHEN NOT MATCHED THEN 
    INSERT 
        (
        tsk_begin_date_id,             tsk_begin_time_id, 
        tsk_end_date_id,               tsk_end_time_id, 
        physical_item_id,              physical_item_sn_id, 
        mimosa_item_sn_id,             force_unit_id, 
        pba_id, 
        maint_ev_id_a,                 maint_ev_id_b, 
        maint_task_id,                 maint_work_id, 
        maint_org,                     maint_uic, 
        maint_lvl_cd, 
        elapsed_tsk_wk_tm,             inspect_tsk, 
        essential_tsk,                 maint_work_mh, 
        wrk_mil_civ_kon,               wrk_mos, 
        wrk_spec_person,               wrk_repair, 
        wrk_mos_sent,
        cust_org,                      cust_uic,
        evnt_begin_date_id,            evnt_cmpl_date_id,
        fault_malfunction_descr,       won, 
        etl_processed_by                           
        )
        VALUES 
        (
        metw.tsk_begin_date_id,        metw.tsk_begin_time_id, 
        metw.tsk_end_date_id,          metw.tsk_end_time_id, 
        metw.physical_item_id,         metw.physical_item_sn_id, 
        metw.mimosa_item_sn_id,        metw.force_unit_id, 
        metw.pba_id, 
        metw.maint_ev_id_a,            metw.maint_ev_id_b, 
        metw.maint_task_id,            metw.maint_work_id, 
        metw.maint_org,                metw.maint_uic, 
        metw.maint_lvl_cd, 
        metw.elapsed_tsk_wk_tm,        metw.inspect_tsk, 
        metw.essential,                metw.maint_work_mh, 
        metw.mil_civ_kon,              metw.mos, 
        metw.spec_person,              metw.repair, 
        metw.mos_sent,
        metw.cust_org,                 metw.cust_uic,
        metw.evnt_begin_date_id,       metw.evnt_cmpl_date_id,
        metw.fault_malfunction_descr,  metw.won, 
        ps_procedure_name                           
        );  
    
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    UPDATE  pfsawh_maint_itm_wrk_fact f
    SET     tsk_days_to_cmplt = f.evnt_cmpl_date_id - f.evnt_begin_date_id 
    WHERE   (my_lst_updt < insert_date OR my_lst_updt < update_date);  

-- Set warehouse ids    

    ps_location := 'PFSAWH 70';            -- For std_pfsawh_debug_tbl logging. 
    
-- FORCE 

    UPDATE pfsawh_maint_itm_wrk_fact f
    SET    force_unit_id = 
            NVL((
            SELECT force_unit_id  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = f.cust_uic 
                AND status = 'C'
            ), 0)
    WHERE  (f.force_unit_id IS NULL    OR f.force_unit_id < 1) 
        AND (my_lst_updt < insert_date OR my_lst_updt < update_date); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- MIMOSA      

    UPDATE pfsawh_maint_itm_wrk_fact 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (my_lst_updt < insert_date OR my_lst_updt < update_date); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- PBA_ID 

    UPDATE pfsawh_maint_itm_wrk_fact f
    SET    pba_id = NVL((
                    SELECT itm.pba_id
                    FROM   pfsa_pba_items_ref itm, 
                           pfsa_pba_ref pba 
                    WHERE  pba.pba_key1 = 'USA' 
                        AND pba.pba_id = itm.pba_id  
                        AND itm.item_identifier_type_id = 13 
                        AND itm.physical_item_id = f.physical_item_id 
                    ), 1000000) 
    WHERE (f.pba_id = 1000000          OR f.pba_id IS NULL)
        AND (my_lst_updt < insert_date OR my_lst_updt < update_date); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
    
-- date_cmplt_readiness_prd_id 

    UPDATE  pfsawh_maint_itm_wrk_fact f
    SET     date_cmplt_readiness_prd_id = 
                (
                SELECT fn_date_to_date_id(b.READY_DATE) 
                FROM    pfsawh_ready_date_dim   b
                WHERE   b.date_dim_id = f.evnt_cmpl_date_id  
                )
    WHERE   f.date_cmplt_readiness_prd_id IS NULL  
        AND (my_lst_updt < insert_date OR my_lst_updt < update_date); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- Calculate the days to complete the task - 

    UPDATE  pfsawh_maint_itm_wrk_fact a
    SET     tsk_days_to_cmplt = a.evnt_cmpl_date_id - a.evnt_begin_date_id 
    WHERE   (my_lst_updt < insert_date OR my_lst_updt < update_date);  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_recid, proc1.process_key, 
        proc1.module_num, proc1.step_num,  
        proc1.process_start_date, proc1.process_end_date, 
        proc1.process_status_code, proc1.sql_error_code, 
        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
        proc1.rec_updated_int, proc1.rec_deleted_int, 
        proc1.user_login_id, proc1.message, proc1_recid
        );

    COMMIT; 
    
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_recid, proc1.process_key, 
        proc1.module_num, proc1.step_num,  
        proc1.process_start_date, proc1.process_end_date, 
        proc1.process_status_code, proc1.sql_error_code, 
        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
        proc1.rec_updated_int, proc1.rec_deleted_int, 
        proc1.user_login_id, proc1.message, proc1_recid
        );

   COMMIT; 

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 584; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 20;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        );
 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    ps_location := 'PFSAWH 80';            -- For std_pfsawh_debug_tbl logging. 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_recid, proc1.process_key, 
        proc1.module_num, proc1.step_num,  
        proc1.process_start_date, proc1.process_end_date, 
        proc1.process_status_code, proc1.sql_error_code, 
        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
        proc1.rec_updated_int, proc1.rec_deleted_int, 
        proc1.user_login_id, proc1.message, proc1_recid
        );

    COMMIT;

 
    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process PFSA_EQUIP_AVAIL. 

    updt_pfsawh_processes
      (
      ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
      ps_this_process.who_ran, ls_current_process.last_run_status, 
      l_now_is, ls_current_process.last_run_compl
      ); 
          
    COMMIT;
  
/*----------------------------------------------------------------------------*/  

-- Update the pfsa_process table to indicate main process has ended.  

-- Housekeeping for the end of the MAIN process 

    ps_this_process.last_run_status_time := SYSDATE; 
    ps_this_process.last_run_compl       := ps_this_process.last_run_status_time; 
  
    IF ps_main_status IS NULL THEN
        ps_main_status := 'COMPLETE';
    ELSE
        ps_main_status := 'CMPLERROR';
    END IF;
      
    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_main_status,  
        ps_this_process.last_run_status_time, ps_this_process.last_run_compl
        );

    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_recid, proc1.process_key, 
        proc1.module_num, proc1.step_num,  
        proc1.process_start_date, proc1.process_end_date, 
        proc1.process_status_code, proc1.sql_error_code, 
        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
        proc1.rec_updated_int, proc1.rec_deleted_int, 
        proc1.user_login_id, proc1.message, proc1_recid
        );

    COMMIT;

    proc0.process_end_date := sysdate;
    proc0.sql_error_code := sqlcode;
    proc0.process_status_code := NVL(proc0.sql_error_code, sqlcode);
    proc0.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc0.process_recid, proc0.process_key, 
        proc0.module_num, proc0.step_num,  
        proc0.process_start_date, proc0.process_end_date, 
        proc0.process_status_code, proc0.sql_error_code, 
        proc0.rec_read_int, proc0.rec_valid_int, proc0.rec_load_int, 
        proc0.rec_inserted_int, proc0.rec_merged_int, proc0.rec_selected_int, 
        proc0.rec_updated_int, proc0.rec_deleted_int, 
        proc0.user_login_id, proc0.message, proc0_recid
        );

    COMMIT;

EXCEPTION 
    WHEN OTHERS THEN
        ps_oerr := sqlcode; 
        ps_msg  := sqlerrm; 
        
        INSERT 
        INTO std_pfsawh_debug_tbl 
        (
        ps_procedure,      ps_oerr, ps_location, called_by, 
        ps_id_key, ps_msg, msg_dt
        )
        VALUES 
        (
        ps_procedure_name, ps_oerr, ps_location, NULL, 
        ps_id_key, ps_msg, SYSDATE
        );
        
        COMMIT; 

END; -- end of procedure
/
