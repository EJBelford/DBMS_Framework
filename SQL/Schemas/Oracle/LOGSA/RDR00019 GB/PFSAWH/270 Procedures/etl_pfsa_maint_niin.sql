CREATE OR REPLACE PROCEDURE etl_pfsa_maint_niin     
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS

/*
    This is the main controlling procedure for maintaining the logical 
    construct of the PFSA world.

    It is not a data loading procedure, and should be called prior to the 
    actual running of any data loads.  The value type_maintenance is a place 
    holder for segregation of future implementation issues as well as
    to accomodate special procedures which may need to be handled separately

    Created 18 Jan 04 by Dave Hendricks
             
    Production Date 25 Sep 2004 
             
    Modification Date 24 Apr 2007 added the grab_new_geo_data procedure call 
    and corrected the calls to org data
*/ 

/*----- Test script ----- 

BEGIN 

    etl_pfsa_maint_niin (307138, 'GBelford'); 
    
    COMMIT; 

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_PFSA_MAINT_NIIN';  /*  */
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

v_debug                    NUMBER        := 1; 

cv_physical_item_id        NUMBER; 

v_niin                     VARCHAR2(9); 

v_etl_copy_cutoff          DATE; 
v_t_fact_cutoff            DATE; 
v_t_fact_cutoff_id         NUMBER; 
v_p_fact_cutoff            DATE; 
v_p_fact_cutoff_id         NUMBER; 

-- add  by lmj 10/10/08 variables to manaage truncation and index control --

myrowcount              NUMBER;
mytablename             VARCHAR2(32);

BEGIN 

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_physical_item_id: ' || v_physical_item_id || ', ' || 
           'type_maintenance:   ' || type_maintenance
           );
    END IF;  
    
    cv_physical_item_id := v_physical_item_id;

    SELECT niin 
    INTO   v_niin 
    FROM   pfsawh_item_dim 
    WHERE  physical_item_id = v_physical_item_id; 

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
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_etl_copy_cutoff_days: ' || v_etl_copy_cutoff_days || ', ' || 
           'v_etl_copy_cutoff'        || v_etl_copy_cutoff
           );
    END IF;  

    proc0.process_RecId      := 240; 
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
        
--    proc1.process_RecId      := 240; 
--    proc1.process_Key        := NULL;
--    proc1.module_Num         := 10;
--    proc1.process_Start_Date := SYSDATE;
--    proc1.user_Login_Id      := USER; 
  
--    pr_pfsawh_insupd_processlog 
--        (
--        proc1.process_RecId, proc1.process_Key, 
--        proc1.module_Num, proc1.step_Num,  
--        proc1.process_Start_Date, NULL, 
--        NULL, NULL, 
--        NULL, NULL, NULL, 
--        NULL, NULL, NULL, NULL, NULL, 
--        proc1.user_Login_Id, NULL, proc1_recId
--        ); 
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := nvl(type_maintenance, 'GENERIC PFSA ETL');

-- Housekeeping for the process 
  
    ps_location := 'PFSA 00';            -- For std_pfsawh_debug_tbl logging. 

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
      
/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 240; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || ' - ' || 
                                v_niin; 
  
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
        
    ps_location := 'PFSA 100';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_MAINT_EVENT'; 
  
-- Get the run criteria for the PFSA_MAINT_EVENT from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of PFSA_MAINT_EVENT. 

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
 
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   pfsa_maint_event_tmp 
        (
        maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
        maint_item, maint_item_niin, maint_item_sn, num_maint_item,
        sys_ei_niin, sys_ei_sn,
        num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
        dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
        phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
        source_id, status, lst_updt, updt_by,
        heir_id, priority, cust_org, cust_uic,
        fault_malfunction_descr, won, last_wo_status, last_wo_status_date,
        active_flag, active_date, inactive_date, insert_by, insert_date,
        update_by, update_date, delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by, 
        frz_input_date, frz_input_date_id, ridb_on_time_flag,
        report_date, maint_event_id_part1, maint_event_id_part2 
        )
    SELECT maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
        maint_item, maint_item_niin, maint_item_sn, num_maint_item,
        sys_ei_niin, sys_ei_sn,
        num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
        dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
        phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
        source_id, status, lst_updt, updt_by,
        heir_id, priority, cust_org, cust_uic,
        fault_malfunction_descr, won, last_wo_status, last_wo_status_date,
        active_flag, active_date, inactive_date, insert_by, insert_date,
        update_by, update_date, delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by, 
        frz_input_date, frz_input_date_id, ridb_on_time_flag,
        report_date, maint_event_id_part1, maint_event_id_part2  
    FROM   pfsa_maint_event@pfsaw.lidb
    WHERE sys_ei_niin = v_niin; -- v_niin, '015231316' '013285964' '014321526' --  

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    ps_location := 'PFSA 104';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   pfsa_maint_event psi 
    USING  (SELECT 
                maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
                maint_item, maint_item_niin, maint_item_sn, num_maint_item,
                sys_ei_niin, sys_ei_sn,
                num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
                dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
                phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
                source_id, status, lst_updt, updt_by,
                heir_id, priority, cust_org, cust_uic,
                fault_malfunction_descr, won, last_wo_status, last_wo_status_date,
                active_flag, active_date, inactive_date, insert_by, insert_date,
                update_by, update_date, delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id, ridb_on_time_flag,
                report_date, maint_event_id_part1, maint_event_id_part2
            FROM   pfsa_maint_event_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
            AND tmp.sys_ei_niin = v_niin ) -- v_niin  '014321526'  --
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id              = tmp.maint_ev_id,            
            psi.maint_org = tmp.maint_org, 
            psi.maint_uic = tmp.maint_uic, 
            psi.maint_lvl_cd = tmp.maint_lvl_cd,
            psi.maint_item = tmp.maint_item, 
            psi.maint_item_niin = tmp.maint_item_niin, 
            psi.maint_item_sn = tmp.maint_item_sn, 
            psi.num_maint_item = tmp.num_maint_item,
            psi.sys_ei_niin = tmp.sys_ei_niin, 
            psi.sys_ei_sn = tmp.sys_ei_sn,
            psi.num_mi_nrts = tmp.num_mi_nrts, 
            psi.num_mi_rprd = tmp.num_mi_rprd, 
            psi.num_mi_cndmd = tmp.num_mi_cndmd, 
            psi.num_mi_neof = tmp.num_mi_neof,
            psi.dt_maint_ev_est = tmp.dt_maint_ev_est, 
            psi.dt_maint_ev_cmpl = tmp.dt_maint_ev_cmpl, 
            psi.sys_ei_nmcm = tmp.sys_ei_nmcm, 
            psi.phase_ev = tmp.phase_ev, 
            psi.sof_ev = tmp.sof_ev, 
            psi.asam_ev = tmp.asam_ev, 
            psi.mwo_ev = tmp.mwo_ev, 
            psi.elapsed_me_wk_tm = tmp.elapsed_me_wk_tm,
            psi.source_id = tmp.source_id, 
            psi.status = tmp.status, 
            psi.lst_updt = tmp.lst_updt, 
            psi.updt_by = tmp.updt_by,
            psi.heir_id = tmp.heir_id, 
            psi.priority = tmp.priority, 
            psi.cust_org = tmp.cust_org, 
            psi.cust_uic = tmp.cust_uic,
            psi.fault_malfunction_descr = tmp.fault_malfunction_descr, 
            psi.won = tmp.won, 
            psi.last_wo_status = tmp.last_wo_status, 
            psi.last_wo_status_date = tmp.last_wo_status_date,
            psi.active_flag = tmp.active_flag, 
            psi.active_date = tmp.active_date, 
            psi.inactive_date = tmp.inactive_date, 
            psi.insert_by = tmp.insert_by, 
            psi.insert_date = tmp.insert_date,
            psi.update_by = tmp.update_by, 
            psi.update_date = tmp.update_date, 
            psi.delete_flag = tmp.delete_flag, 
            psi.delete_date = tmp.delete_date, 
            psi.delete_by = tmp.delete_by,
            psi.hidden_flag = tmp.hidden_flag, 
            psi.hidden_date = tmp.hidden_date, 
            psi.hidden_by = tmp.hidden_by, 
            psi.frz_input_date = tmp.frz_input_date, 
            psi.frz_input_date_id = tmp.frz_input_date_id, 
            psi.ridb_on_time_flag = tmp.ridb_on_time_flag,
            psi.report_date = tmp.report_date, 
            psi.maint_event_id_part1 = tmp.maint_event_id_part1, 
            psi.maint_event_id_part2 = tmp.maint_event_id_part2
    WHEN NOT MATCHED THEN 
        INSERT (
                maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
                maint_item, maint_item_niin, maint_item_sn, num_maint_item,
                sys_ei_niin, sys_ei_sn,
                num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
                dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
                phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
                source_id, status, lst_updt, updt_by,
                heir_id, priority, cust_org, cust_uic,
                fault_malfunction_descr, won, last_wo_status, last_wo_status_date,
                active_flag, active_date, inactive_date, insert_by, insert_date,
                update_by, update_date, delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id, ridb_on_time_flag,
                report_date, maint_event_id_part1, maint_event_id_part2
                )
        VALUES (
                tmp.maint_ev_id, tmp.maint_org, tmp.maint_uic, tmp.maint_lvl_cd,
                tmp.maint_item, tmp.maint_item_niin, tmp.maint_item_sn, tmp.num_maint_item,
                tmp.sys_ei_niin, tmp.sys_ei_sn,
                tmp.num_mi_nrts, tmp.num_mi_rprd, tmp.num_mi_cndmd, tmp.num_mi_neof,
                tmp.dt_maint_ev_est, tmp.dt_maint_ev_cmpl, tmp.sys_ei_nmcm, 
                tmp.phase_ev, tmp.sof_ev, tmp.asam_ev, tmp.mwo_ev, tmp.elapsed_me_wk_tm,
                tmp.source_id, tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.heir_id, tmp.priority, tmp.cust_org, tmp.cust_uic,
                tmp.fault_malfunction_descr, tmp.won, tmp.last_wo_status, tmp.last_wo_status_date,
                tmp.active_flag, tmp.active_date, tmp.inactive_date, tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, tmp.delete_flag, tmp.delete_date, tmp.delete_by,
                tmp.hidden_flag, tmp.hidden_date, tmp.hidden_by, 
                tmp.frz_input_date, tmp.frz_input_date_id, tmp.ridb_on_time_flag,
                tmp.report_date, tmp.maint_event_id_part1, tmp.maint_event_id_part2
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
-- Set warehouse ids    

    ps_location := 'PFSA 105';            -- For std_pfsawh_debug_tbl logging.

-- ITEM 

    UPDATE pfsa_maint_event pme
    SET    physical_item_id = 
            NVL((
            SELECT physical_item_id 
            FROM   pfsawh_item_dim 
            WHERE  niin = pme.sys_ei_niin 
            ), 0)
    WHERE  (pme.physical_item_id IS NULL
        OR pme.physical_item_id < 1) 
        AND pme.sys_ei_niin = v_niin; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- ITEM_SN  

    UPDATE pfsa_maint_event pme
    SET    physical_item_sn_id = 
            NVL((
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  item_niin = pme.sys_ei_niin 
                AND item_serial_number = pme.sys_ei_sn 
            ), 0)
    WHERE  (pme.physical_item_sn_id IS NULL
        OR pme.physical_item_sn_id < 1) 
        AND pme.sys_ei_niin = v_niin; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- PBA_ID 

    UPDATE pfsa_maint_event pme
    SET    pba_id = NVL((
                    SELECT itm.pba_id
                    FROM   pfsa_pba_items_ref itm, 
                           pfsa_pba_ref pba 
                    WHERE  pba.pba_key1 = 'USA' 
                        AND pba.pba_id = itm.pba_id  
                        AND itm.item_identifier_type_id = 13 
                        AND itm.physical_item_id = pme.physical_item_id 
                    ), 1000000)
    WHERE (pme.pba_id = 1000000 
        OR pme.pba_id IS NULL)
        AND pme.physical_item_id = v_physical_item_id; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    pr_upd_pfsa_fcs_sys_dates (ps_this_process.who_ran, 'MAINT_EVENT_PERIOD_DATE'); 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    COMMIT; 
    
-- Analyze the table and re-build the indexes 

    IF run_reindex('pfsa_maint_event') THEN 

        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_event               DELETE STATISTICS'; 
        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_event               COMPUTE STATISTICS'; 
        
        EXECUTE IMMEDIATE 'ALTER INDEX   pk_pfsa_maint_event            REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_event_insert_dt REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_event_lst_updt  REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_event_update_dt REBUILD';
        
    END IF; 

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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

    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process PFSA_MAINT_EVENT. 

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
      
    proc1.process_RecId      := 240; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 20;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || ' - ' || 
                                v_niin; 
  
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
        
    ps_location := 'PFSA 110';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_MAINT_ITEMS'; 
  
-- Get the run criteria for the PFSA_MAINT_ITEMS from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of PFSA_MAINT_ITEMS. 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

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
 
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_items_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_items_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
--    INSERT 
--    INTO   pfsa_maint_items_tmp 
--        (
--        maint_ev_id,
--        maint_task_id,
--        maint_item_id,
--        cage_cd,
--        part_num,
--        niin,
--        part_sn,
--        num_items,
--        cntld_exchng,
--        removed,
--        failure,
--        lst_updt,
--        updt_by,
--        heir_id,
--        priority,
--        doc_no,
--        doc_no_expand,
--        part_uid  
--        )
--    SELECT maint_ev_id,
--        maint_task_id,
--        maint_item_id,
--        cage_cd,
--        part_num,
--        niin,
--        part_sn,
--        num_items,
--        cntld_exchng,
--        removed,
--        failure,
--        lst_updt,
--        updt_by,
--        heir_id,
--        priority,
--        doc_no,
--        doc_no_expand,
--        part_uid 
--    FROM   pfsa_maint_items@pfsaw.lidb
--    WHERE lst_updt > v_etl_copy_cutoff;  

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
--    MERGE  
--    INTO   pfsa_maint_items psi 
--    USING  (SELECT 
--                maint_ev_id,
--                maint_task_id,
--                maint_item_id,
--                cage_cd,
--                part_num,
--                niin,
--                part_sn,
--                num_items,
--                cntld_exchng,
--                removed,
--                failure,
--                lst_updt,
--                updt_by,
--                heir_id,
--                priority,
--                doc_no,
--                doc_no_expand,
--                part_uid
--            FROM   pfsa_maint_items_tmp ) tmp 
--    ON     (psi.maint_ev_id = tmp.maint_ev_id
--           AND psi.maint_task_id = tmp.maint_task_id
--           AND psi.maint_item_id = tmp.maint_item_id)  
--    WHEN MATCHED THEN 
--        UPDATE SET   
----            psi.maint_ev_id = tmp.maint_ev_id,            
----            psi.maint_task_id = tmp.maint_task_id,
----            psi.maint_item_id = tmp.maint_item_id,
--            psi.cage_cd = tmp.cage_cd,
--            psi.part_num = tmp.part_num,
--            psi.niin = tmp.niin,
--            psi.part_sn = tmp.part_sn,
--            psi.num_items = tmp.num_items,
--            psi.cntld_exchng = tmp.cntld_exchng,
--            psi.removed = tmp.removed,
--            psi.failure = tmp.failure,
--            psi.lst_updt = tmp.lst_updt,
--            psi.updt_by = tmp.updt_by,
--            psi.heir_id = tmp.heir_id,
--            psi.priority = tmp.priority,
--            psi.doc_no = tmp.doc_no,
--            psi.doc_no_expand = tmp.doc_no_expand,
--            psi.part_uid = tmp.part_uid
--    WHEN NOT MATCHED THEN 
--        INSERT (
--                maint_ev_id, maint_task_id, maint_item_id,
--                cage_cd, part_num, niin, part_sn,
--                num_items, cntld_exchng, removed, failure,
--                lst_updt, updt_by, heir_id, priority,
--                doc_no, doc_no_expand, part_uid
--                )
--        VALUES (
--                tmp.maint_ev_id, tmp.maint_task_id, tmp.maint_item_id,
--                tmp.cage_cd, tmp.part_num, tmp.niin, tmp.part_sn,
--                tmp.num_items, tmp.cntld_exchng, tmp.removed, tmp.failure,
--                tmp.lst_updt, tmp.updt_by, tmp.heir_id, tmp.priority,
--                tmp.doc_no, tmp.doc_no_expand, tmp.part_uid
--               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    ps_location := 'PFSA 115';            -- For std_pfsawh_debug_tbl logging.

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_items_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_items_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    COMMIT; 
    
-- Analyze the table and re-build the indexes 

    IF run_reindex('pfsa_maint_items') THEN 

        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_items               DELETE STATISTICS'; 
        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_items               COMPUTE STATISTICS'; 
        
        EXECUTE IMMEDIATE 'ALTER INDEX   pk_pfsa_maint_items            REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_items_insert_dt REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_items_lst_updt  REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_items_update_dt REBUILD';
        
    END IF; 

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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

    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process PFSA_MAINT_ITEMS. 

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
      
    proc1.process_RecId      := 240; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 30;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || ' - ' || 
                                v_niin; 
  
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
        
    ps_location := 'PFSA 120';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_MAINT_TASK'; 
  
-- Get the run criteria for the PFSA_MAINT_TASK from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of PFSA_MAINT_TASK  

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

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
 
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_task_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_task_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   pfsa_maint_task_tmp 
        (
        maint_ev_id,
        maint_task_id,
        elapsed_tsk_wk_tm,
        elapsed_part_wt_tm,
        tsk_begin,
        tsk_end,
        inspect_tsk,
        tsk_was_def,
        sched_unsched,
        essential,
        status,
        lst_updt,
        updt_by,
        heir_id,
        priority
        )
    SELECT 
        pmt.maint_ev_id,
        pmt.maint_task_id,
        pmt.elapsed_tsk_wk_tm,
        pmt.elapsed_part_wt_tm,
        pmt.tsk_begin,
        pmt.tsk_end,
        pmt.inspect_tsk,
        pmt.tsk_was_def,
        pmt.sched_unsched,
        pmt.essential,
        pmt.status,
        pmt.lst_updt,
        pmt.updt_by,
        pmt.heir_id,
        pmt.priority
    FROM   pfsa_maint_task@pfsaw.lidb pmt, 
           pfsa_maint_event@pfsaw.lidb pme
    WHERE pme.sys_ei_niin = v_niin  -- v_niin '013285964' -- 
        AND pmt.maint_ev_id = pme.maint_ev_id;
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    MERGE  
    INTO   pfsa_maint_task psi 
    USING  (SELECT 
                maint_ev_id, maint_task_id,
                elapsed_tsk_wk_tm, elapsed_part_wt_tm,
                tsk_begin, tsk_end, inspect_tsk, tsk_was_def,
                sched_unsched, essential,
                status, lst_updt, updt_by,
                heir_id, priority
            FROM   pfsa_maint_task_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
           AND psi.maint_task_id = tmp.maint_task_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id              = tmp.maint_ev_id,            
--            psi.maint_task_id              = tmp.maint_task_id,            
            psi.elapsed_tsk_wk_tm = tmp.elapsed_tsk_wk_tm,
            psi.elapsed_part_wt_tm = tmp.elapsed_part_wt_tm,
            psi.tsk_begin = tmp.tsk_begin,
            psi.tsk_end = tmp.tsk_end,
            psi.inspect_tsk = tmp.inspect_tsk,
            psi.tsk_was_def = tmp.tsk_was_def,
            psi.sched_unsched = tmp.sched_unsched,
            psi.essential = tmp.essential,
            psi.status = tmp.status,
            psi.lst_updt = tmp.lst_updt,
            psi.updt_by = tmp.updt_by,
            psi.heir_id = tmp.heir_id,
            psi.priority = tmp.priority
    WHEN NOT MATCHED THEN 
        INSERT (
                maint_ev_id, maint_task_id,
                elapsed_tsk_wk_tm, elapsed_part_wt_tm,
                tsk_begin, tsk_end, inspect_tsk, tsk_was_def,
                sched_unsched, essential,
                status, lst_updt, updt_by,
                heir_id, priority
                )
        VALUES (
                tmp.maint_ev_id, tmp.maint_task_id,
                tmp.elapsed_tsk_wk_tm, tmp.elapsed_part_wt_tm,
                tmp.tsk_begin, tmp.tsk_end, tmp.inspect_tsk, tmp.tsk_was_def,
                tmp.sched_unsched, tmp.essential,
                tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.heir_id, tmp.priority
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    ps_location := 'PFSA 125';            -- For std_pfsawh_debug_tbl logging.

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_task_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_task_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    COMMIT; 
    
-- Analyze the table and re-build the indexes 

    IF run_reindex('pfsa_maint_task') THEN 

        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_task                DELETE STATISTICS'; 
        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_task                COMPUTE STATISTICS'; 
        
        EXECUTE IMMEDIATE 'ALTER INDEX   pk_pfsa_maint_task             REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_task_insert_dt  REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_task_lst_updt   REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_task_update_dt  REBUILD';
        
    END IF; 

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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

    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process PFSA_MAINT_TASK. 

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
      
    proc1.process_RecId      := 240; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 40;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || ' - ' || 
                                v_niin; 
  
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
        
    ps_location := 'PFSA 130';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_MAINT_WORK'; 
  
-- Get the run criteria for the PFSA_MAINT_WORK from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of PFSA_MAINT_WORK. 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

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
 
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_work_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_work_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   pfsa_maint_work_tmp 
        (
        maint_ev_id,
        maint_task_id,
        maint_work_id,
        maint_work_mh,
        mil_civ_kon,
        mos,
        spec_person,
        repair,
        status,
        lst_updt,
        updt_by,
        mos_sent,
        heir_id,
        priority
        )
    SELECT 
        pmw.maint_ev_id,
        pmw.maint_task_id,
        pmw.maint_work_id,
        pmw.maint_work_mh,
        pmw.mil_civ_kon,
        pmw.mos,
        pmw.spec_person,
        pmw.repair,
        pmw.status,
        pmw.lst_updt,
        pmw.updt_by,
        pmw.mos_sent,
        pmw.heir_id,
        pmw.priority
    FROM   pfsa_maint_work@pfsaw.lidb pmw, 
           pfsa_maint_task@pfsaw.lidb pmt, 
           pfsa_maint_event@pfsaw.lidb pme
    WHERE pme.sys_ei_niin = v_niin  -- v_niin '013285964' -- 
        AND pmt.maint_ev_id = pme.maint_ev_id 
        AND pmw.maint_ev_id = pmt.maint_ev_id 
        AND pmw.maint_task_id = pmt.maint_task_id;

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    MERGE  
    INTO   pfsa_maint_work psi 
    USING  (SELECT 
            maint_ev_id, maint_task_id, maint_work_id,
            maint_work_mh, mil_civ_kon, mos, spec_person,
            repair, status, lst_updt, updt_by,
            mos_sent, heir_id, priority
            FROM   pfsa_maint_work_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
           AND psi.maint_task_id = tmp.maint_task_id
           AND psi.maint_work_id = tmp.maint_work_id )  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id             = tmp.maint_ev_id,            
--            psi.maint_task_id              = tmp.maint_task_id,            
--            psi.maint_work_id              = tmp.maint_work_id,            
            psi.maint_work_mh = tmp.maint_work_mh,
            psi.mil_civ_kon = tmp.mil_civ_kon,
            psi.mos = tmp.mos,
            psi.spec_person = tmp.spec_person,
            psi.repair = tmp.repair,
            psi.status = tmp.status,
            psi.lst_updt = tmp.lst_updt,
            psi.updt_by = tmp.updt_by,
            psi.mos_sent = tmp.mos_sent,
            psi.heir_id = tmp.heir_id,
            psi.priority = tmp.priority
    WHEN NOT MATCHED THEN 
        INSERT (
                maint_ev_id, maint_task_id, maint_work_id,
                maint_work_mh, mil_civ_kon, mos, spec_person,
                repair, status, lst_updt, updt_by,
                mos_sent, heir_id, priority
                )
        VALUES (
                tmp.maint_ev_id, tmp.maint_task_id, tmp.maint_work_id,
                tmp.maint_work_mh, tmp.mil_civ_kon, tmp.mos, tmp.spec_person,
                tmp.repair, tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.mos_sent, tmp.heir_id, tmp.priority
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    ps_location := 'PFSA 133';            -- For std_pfsawh_debug_tbl logging.

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_maint_work_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_maint_work_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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

-- Analyze the table and re-build the indexes 

    IF run_reindex('pfsa_maint_work') THEN 

        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_work                DELETE STATISTICS'; 
        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_maint_work                COMPUTE STATISTICS'; 
        
        EXECUTE IMMEDIATE 'ALTER INDEX   pk_pfsa_maint_work             REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_work_insert_dt  REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_work_lst_updt   REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_maint_work_update_dt  REBUILD';
        
    END IF; 

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                    Populate pfsawh_maint_itm_wrk_fact                      */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 240; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 50;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || ' - ' || 
                                v_niin; 
  
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
        
    ps_location := 'PFSA 135';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE pfsawh_maint_itm_wrk_fact
    WHERE  physical_item_id = v_physical_item_id;  -- 141223 -- 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 
    
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
            cv_physical_item_id AS physical_item_id,  
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
        WHERE  ev.physical_item_id   = cv_physical_item_id  
            AND tk.pba_id (+)        = ev.pba_id
            AND tk.maint_ev_id (+)   = ev.maint_ev_id
            AND wk.pba_id (+)        = tk.pba_id 
            AND wk.maint_ev_id (+)   = tk.maint_ev_id 
            AND wk.maint_task_id (+) = tk.maint_task_id 
            AND ev.delete_flag = 'N' 
        )metw 
    ON(    metw.physical_item_id = cv_physical_item_id
       AND metw.pba_id           = mwf.pba_id
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
    WHERE   f.physical_item_id = v_physical_item_id;  

-- Set warehouse ids    

    ps_location := 'PFSA 140';            -- For std_pfsawh_debug_tbl logging. 
    
-- FORCE 

    UPDATE pfsawh_maint_itm_wrk_fact f
    SET    force_unit_id = 
            NVL((
            SELECT force_unit_id  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = f.cust_uic 
                AND status = 'C'
            ), 0)
    WHERE  (f.force_unit_id IS NULL 
        OR f.force_unit_id < 1) 
        AND f.physical_item_id = v_physical_item_id; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- MIMOSA      

    UPDATE pfsawh_maint_itm_wrk_fact 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000')
        AND etl_processed_by = ps_procedure_name; 
        
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
    WHERE (f.pba_id = 1000000 
        OR f.pba_id IS NULL)
        AND f.physical_item_id = v_physical_item_id; 
        
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
        AND f.physical_item_id = v_physical_item_id; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- Calculate the days to complete the task - 

    UPDATE  pfsawh_maint_itm_wrk_fact a
    SET     tsk_days_to_cmplt = a.evnt_cmpl_date_id - a.evnt_begin_date_id 
    WHERE   a.physical_item_id = v_physical_item_id;  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- pfsawh_item_sn_p_fact - maint_action_cnt & total_down_time -

    MERGE
    INTO  pfsawh_item_sn_p_fact p 
    USING ( 
          SELECT  pba_id, 
              physical_item_id, 
              physical_item_sn_id, 
              force_unit_id, 
              date_cmplt_readiness_prd_id, 
              COUNT(physical_item_sn_id) AS maint_action_cnt,  
              SUM(tsk_days_to_cmplt) AS total_down_time  
          FROM    pfsawh_maint_itm_wrk_fact 
          WHERE   physical_item_id = v_physical_item_id
              AND date_cmplt_readiness_prd_id IS NOT NULL 
          GROUP BY pba_id, physical_item_id, physical_item_sn_id, 
              force_unit_id, date_cmplt_readiness_prd_id
          ORDER BY physical_item_sn_id, 
              force_unit_id, date_cmplt_readiness_prd_id 
          ) wf
    ON    ( p.item_date_to_id = wf.date_cmplt_readiness_prd_id  
            AND p.physical_item_sn_id = wf.physical_item_sn_id 
            AND p.item_force_id = wf.force_unit_id    
            AND p.physical_item_id = v_physical_item_id )  
    WHEN MATCHED THEN 
        UPDATE SET     
            maint_action_cnt = wf.maint_action_cnt, 
            total_down_time  = wf.total_down_time 
    WHEN NOT MATCHED THEN 
        INSERT (
            date_id, 
            pba_id, 
            physical_item_id, 
            physical_item_sn_id, 
            item_force_id, 
            item_date_from_id, 
            item_date_to_id, 
            maint_action_cnt, 
            total_down_time 
            )
        VALUES ( 
            wf.date_cmplt_readiness_prd_id, 
            wf.pba_id, 
            wf.physical_item_id, 
            wf.physical_item_sn_id, 
            wf.force_unit_id, 
            wf.date_cmplt_readiness_prd_id - 14, 
            wf.date_cmplt_readiness_prd_id, 
            wf.maint_action_cnt, 
            wf.total_down_time
            ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                    Populate pfsawh_maint_itm_prt_fact                      */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 
/*
    INSERT 
    INTO   pfsawh_maint_itm_prt_fact 
        (
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item__id, 
        physical_item_sn_id, 
        item_comp_id, 
        item_part_id, 
        part_num, 
        part_sn, 
        part_num_used, 
        part_cntld_exchng_flag, 
        part_removed_flag, 
        part_cage_cd, 
        tsk_elapsed_part_wt_tm, 
        tsk_was_def_flag, 
        tsk_sched_flag 
        )
    SELECT CASE 
               WHEN tk.tsk_end <> NULL THEN fn_pfsawh_get_date_dim_id(tk.tsk_end)   
               WHEN ev.dt_maint_ev_cmpl <> NULL THEN fn_pfsawh_get_date_dim_id(ev.dt_maint_ev_cmpl) 
               ELSE 10000 
           END CASE, 
           NVL(tk.tsk_end, NVL(ev.dt_maint_ev_cmpl, '01-JAN-1950')) AS tsk_end_time_id, 
           fn_pfsawh_get_item_dim_id(NVL(ev.sys_ei_niin, '000000000')) AS physical_item_id,  
           NVL(ev.sys_ei_sn, 'UNKNOWN') AS physical_item_sn_id, 
           fn_pfsawh_get_item_dim_id(NVL(ev.maint_item_niin, '000000000')) AS item_comp_id,  
           fn_pfsawh_get_item_dim_id(NVL(it.niin, '000000000')) AS item_part_id, 
           NVL(it.part_num, 'UNKNOWN') AS part_num, 
           NVL(it.part_sn, 'UNKNOWN') AS part_sn, 
           NVL(it.num_items, 1) AS part_num_used,  
           NVL(it.cntld_exchng, 'U') AS part_cntld_exchng_flag, 
           NVL(it.removed, 'U') AS part_removed_flag, 
           NVL(it.cage_cd, '-1') AS part_cage_cd, 
           NVL(tk.elapsed_part_wt_tm, 0), 
           NVL(tk.tsk_was_def, 'U'), 
           NVL(tk.sched_unsched, '?')    
--           , '|', 
--           it.*, 
--           tk.*, 
--           ev.* 
    FROM   pfsa_maint_event@pfsaw.lidbdev ev, 
           pfsa_maint_task@pfsaw.lidbdev tk,
           pfsa_maint_items@pfsaw.lidbdev it 
    WHERE  ev.maint_ev_id = tk.maint_ev_id
        AND ev.maint_ev_id = it.maint_ev_id 
        AND tk.maint_task_id = it.maint_task_id
    ORDER BY ev.sys_ei_niin, ev.sys_ei_sn, tk.tsk_end DESC, ev.maint_item_niin;        
*/
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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
  
-- Update the status of the sub-process PFSA_MAINT_WORK. 

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

--    proc1.process_end_date := sysdate;
--    proc1.sql_error_code := sqlcode;
--    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
--    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
--    
--    pr_pfsawh_insupd_processlog 
--        (
--        proc1.process_recid, proc1.process_key, 
--        proc1.module_num, proc1.step_num,  
--        proc1.process_start_date, proc1.process_end_date, 
--        proc1.process_status_code, proc1.sql_error_code, 
--        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
--        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
--        proc1.rec_updated_int, proc1.rec_deleted_int, 
--        proc1.user_login_id, proc1.message, proc1_recid
--        );

--    COMMIT;

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

END; -- end of ETL_PFSA_MAINT_NIIN procedure
/


