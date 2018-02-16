CREATE OR REPLACE PROCEDURE etl_pfsa_usage_event_niin    
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

    etl_pfsa_usage_event_niin (141223, 'GBelford'); 
    
    COMMIT; 

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_PFSA_USAGE_EVENT_NIIN';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'No message defined'; /*  */
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

v_debug                    NUMBER 
    := 0;   -- Controls debug options (0 -Off)

cv_physical_item_id        pfsawh_item_dim.physical_item_id%TYPE; 
cv_physical_item_sn_id     pfsawh_item_sn_dim.physical_item_sn_id%TYPE; 
cv_mimosa_item_sn_id       pfsawh_item_sn_dim.mimosa_item_sn_id%TYPE; 
cv_force_unit_id           pfsawh_force_unit_dim.force_unit_id%TYPE; 

v_niin                     pfsawh_item_dim.niin%TYPE; 
v_item_nomen_standard      pfsawh_item_dim.item_nomen_standard%TYPE; 

cv_select_cnt              NUMBER; 

v_etl_copy_cutoff          DATE; 
v_t_fact_cutoff            DATE; 
v_t_fact_cutoff_id         NUMBER; 
v_p_fact_cutoff            DATE; 
v_p_fact_cutoff_id         NUMBER; 

-- add  by lmj 10/10/08 variables to manaage truncation and index control --

myrowcount                 NUMBER;
mytablename                VARCHAR2(32);

BEGIN 

-- Get the process control values from pfsawh_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
    v_t_fact_cutoff_days   := fn_pfsawh_get_prcss_cntrl_val('v_t_fact_cutoff_days'); 
    v_p_fact_cutoff_months := fn_pfsawh_get_prcss_cntrl_val('v_p_fact_cutoff_months');  

-- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    v_etl_copy_cutoff    := SYSDATE - v_etl_copy_cutoff_days; 
    v_t_fact_cutoff      := SYSDATE - v_t_fact_cutoff_days; 
    v_t_fact_cutoff_id   := fn_date_to_date_id(v_t_fact_cutoff); 
    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  (-1 * v_p_fact_cutoff_months)); 
    v_p_fact_cutoff_id   := fn_date_to_date_id(v_p_fact_cutoff); 
    
    cv_physical_item_id := v_physical_item_id;

    SELECT  niin,   item_nomen_standard 
    INTO    v_niin, v_item_nomen_standard  
    FROM    pfsawh_item_dim    
    WHERE   physical_item_id = v_physical_item_id;

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_etl_copy_cutoff_days: ' || v_etl_copy_cutoff_days || ', ' || 
           'v_etl_copy_cutoff'        || v_etl_copy_cutoff
           );
    END IF;  

    proc0.process_RecId      := 220; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    proc0.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
  
    pr_pfsawh_insupd_processlog 
        (
        proc0.process_RecId, proc0.process_Key, 
        proc0.module_Num, proc0.step_Num,  
        proc0.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc0.user_Login_Id, proc0.message, proc0_recId
        );  
        
--    proc1.process_RecId      := 220; 
--    proc1.process_Key        := NULL;
--    proc1.module_Num         := 10;
--    proc1.process_Start_Date := SYSDATE;
--    proc1.user_Login_Id      := USER; 
--    proc1.message            := v_physical_item_id || '-' || 
--                                v_niin || '-' || 
--                                v_item_nomen_standard;
  
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
      
    COMMIT;

/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
    proc1.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
      
    proc1.process_RecId      := 220; 
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
        proc1.user_Login_Id, proc1.message, proc1_recId
        ); 
        
    COMMIT;     
        
    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_USAGE_EVENT'; 
  
-- Get the run criteria for the PFSA_USAGE_EVENT from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of PFSA_USAGE_EVENT 

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

/*
    added by lmj 10/10/08 for truncation of tables rather than delete for 
    increase in performance with each transaction set wrapped with delete
    calls as designed should reduce overhead cost and cycles.

    DELETE pfsa_usage_event_tmp; 

    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;
*/
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_usage_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_usage_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
--    COMMIT; 

    INSERT 
    INTO   pfsa_usage_event_tmp
        (
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag, physical_item_id, 
        physical_item_sn_id, frz_input_date, 
        frz_input_date_id, active_flag, active_date, inactive_date, 
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by--, pba_id 
        )
    SELECT 
        ue.sys_ei_niin, ue.pfsa_item_id, ue.record_type, ue.usage_mb, ue.from_dt, 
        ue.usage, ue.type_usage, ue.to_dt, ue.usage_date, ue.ready_date, 
        ue.day_date, ue.month_date, ue.pfsa_org, ue.uic, ue.sys_ei_sn, 
        ue.item_days, ue.data_src, ue.genind, ue.lst_updt, ue.updt_by, 
        ue.status, ue.reading, ue.reported_usage, ue.actual_mb, ue.actual_reading, 
        ue.actual_usage, ue.actual_data_rec_flag, ue.physical_item_id, 
        ue.physical_item_sn_id, ue.frz_input_date, 
        ue.frz_input_date_id, ue.active_flag, ue.active_date, ue.inactive_date, 
        ue.insert_by, 
        ue.insert_date, ue.update_by, ue.update_date, ue.delete_flag, ue.delete_date, 
        ue.hidden_flag, ue.hidden_date, ue.delete_by, ue.hidden_by--, it.pba_id
    FROM   pfsa_usage_event@pfsaw.lidb ue 
    WHERE ue.sys_ei_niin = v_niin; -- '013285964' '014321526' --
 
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
--  Set warehouse ids  

-- ITEM 

    UPDATE pfsa_usage_event_tmp pue
    SET    physical_item_id = 
            (
            SELECT physical_item_id 
            FROM   pfsawh_item_dim 
            WHERE  niin = pue.sys_ei_niin 
                AND status = 'C'
            )
    WHERE  (pue.physical_item_id IS NULL 
        OR pue.physical_item_id < 1) 
        AND pue.sys_ei_niin = v_niin; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
-- ITEM_SN     

    UPDATE pfsa_usage_event_tmp pue
    SET    physical_item_sn_id = 
            (
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
                AND status = 'C'
            )
    WHERE  (pue.physical_item_sn_id IS NULL 
        OR pue.physical_item_sn_id < 1) 
        AND pue.sys_ei_niin = v_niin; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
-- FORCE 

    UPDATE pfsa_usage_event_tmp pue
    SET    force_unit_id = 
            NVL((
            SELECT force_unit_id  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = pue.uic 
                AND status = 'C'
            ), -1)
    WHERE  (pue.force_unit_id IS NULL 
        OR pue.force_unit_id < 1) 
        AND pue.sys_ei_niin = v_niin; -- '014321526'  --

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- MIMOSA      

    UPDATE pfsa_usage_event_tmp 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000')
        AND sys_ei_niin = v_niin; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- PBA_ID 

    UPDATE pfsa_usage_event_tmp pue
    SET    pba_id = (
                    SELECT NVL(itm.pba_id, 1000000)
                    FROM   pfsa_pba_items_ref itm, 
                           pfsa_pba_ref pba 
                    WHERE  pba.pba_key1 = 'USA' 
                        AND pba.pba_id = itm.pba_id  
                        AND itm.item_identifier_type_id = 13 
                        AND itm.physical_item_id = pue.physical_item_id 
                    )
    WHERE (pue.pba_id = 1000000 
        OR pue.pba_id IS NULL)
        AND pue.physical_item_id = v_physical_item_id; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- FRZ_INPUT_DATE_ID    

    UPDATE pfsa_usage_event_tmp pue 
    SET    frz_input_date_id = fn_date_to_date_id(pue.frz_input_date) 
    WHERE  frz_input_date_id IS NULL 
        AND pue.sys_ei_niin = v_niin; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
 
    ps_location := 'PFSA 20';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE   
    INTO pfsa_usage_event a 
    USING ( 
        SELECT
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt,
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date,
        month_date,
        pfsa_org,
        uic,
        sys_ei_sn,
        item_days,
        data_src,
        genind,
        lst_updt,
        updt_by,
        status,
        reading,
        reported_usage,
        actual_mb,
        actual_reading,
        actual_usage, actual_data_rec_flag, physical_item_id,
        physical_item_sn_id, mimosa_item_sn_id, frz_input_date,
        frz_input_date_id, active_flag, active_date, inactive_date,
        insert_by,
        insert_date, update_by, update_date, delete_flag, delete_date,
        hidden_flag, hidden_date, delete_by, hidden_by, pba_id  
        FROM pfsa_usage_event_tmp) b
    ON (b.sys_ei_niin = v_niin -- v_niin  '014321526'  --
        AND a.sys_ei_niin = b.sys_ei_niin 
        AND a.pfsa_item_id = b.pfsa_item_id 
        AND a.record_type = b.record_type 
        AND a.usage_mb = b.usage_mb 
        AND a.from_dt = b.from_dt 
        )
    WHEN NOT MATCHED THEN 
    INSERT 
        (
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag, physical_item_id, 
        physical_item_sn_id, mimosa_item_sn_id, frz_input_date, 
        frz_input_date_id, active_flag, active_date, inactive_date, 
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by, pba_id
        )
    VALUES 
        (
        b.sys_ei_niin, b.pfsa_item_id, b.record_type, b.usage_mb, b.from_dt, 
        b.usage, b.type_usage, b.to_dt, b.usage_date, b.ready_date, 
        b.day_date, b.month_date, b.pfsa_org, b.uic, b.sys_ei_sn, 
        b.item_days, b.data_src, b.genind, b.lst_updt, b.updt_by, 
        b.status, b.reading, b.reported_usage, b.actual_mb, b.actual_reading, 
        b.actual_usage, b.actual_data_rec_flag, b.physical_item_id, 
        b.physical_item_sn_id, b.mimosa_item_sn_id, b.frz_input_date, 
        b.frz_input_date_id, b.active_flag, b.active_date, b.inactive_date, 
        b.insert_by, 
        b.insert_date, b.update_by, b.update_date, b.delete_flag, b.delete_date, 
        b.hidden_flag, b.hidden_date, b.delete_by, b.hidden_by, b.pba_id
        )
    WHEN MATCHED THEN
    UPDATE SET 
        a.usage = b.usage,
        a.type_usage = b.type_usage,
        a.to_dt = b.to_dt,
        a.usage_date = b.usage_date,
        a.ready_date = b.ready_date,
        a.day_date = b.day_date,
        a.month_date = b.month_date,
        a.pfsa_org = b.pfsa_org,
        a.uic = b.uic,
        a.sys_ei_sn = b.sys_ei_sn,
        a.item_days = b.item_days,
        a.data_src = b.data_src,
        a.genind = b.genind,
        a.lst_updt = b.lst_updt,
        a.updt_by = b.updt_by,
        a.status = b.status,
        a.reading = b.reading,
        a.reported_usage = b.reported_usage,
        a.actual_mb = b.actual_mb,
        a.actual_reading = b.actual_reading,
        a.actual_usage = b.actual_usage,
        a.actual_data_rec_flag = b.actual_data_rec_flag,
        a.physical_item_id = b.physical_item_id,
        a.physical_item_sn_id = b.physical_item_sn_id,
        a.mimosa_item_sn_id = b.mimosa_item_sn_id, 
        a.frz_input_date = b.frz_input_date,
        a.frz_input_date_id = b.frz_input_date_id,
        a.active_flag = b.active_flag,
        a.active_date = b.active_date,
        a.inactive_date = b.inactive_date,
        a.insert_by = b.insert_by,
        a.insert_date = b.insert_date,
        a.update_by = b.update_by,
        a.update_date = b.update_date,
        a.delete_flag = b.delete_flag,
        a.delete_date = b.delete_date,
        a.hidden_flag = b.hidden_flag,
        a.hidden_date = b.hidden_date,
        a.delete_by = b.delete_by,
        a.hidden_by = b.hidden_by,   
        a.pba_id = b.pba_id;

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

--    COMMIT;
    
-- Set warehouse ids    

-- ITEM 

--    UPDATE pfsa_usage_event pue
--    SET    physical_item_id = 
--            (
--            SELECT NVL(physical_item_id, 0) 
--            FROM   pfsawh_item_dim 
--            WHERE  niin = pue.sys_ei_niin
--            )
--    WHERE  (pue.physical_item_id IS NULL
--        OR pue.physical_item_id < 1)
--        AND pue.sys_ei_niin = v_niin; 

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
-- ITEM_SN     

--    UPDATE pfsa_usage_event pue
--    SET    physical_item_sn_id = 
--            (
--            SELECT NVL(physical_item_sn_id, 0) 
--            FROM   pfsawh_item_sn_dim 
--            WHERE  item_niin = pue.sys_ei_niin 
--                AND item_serial_number = pue.sys_ei_sn 
--            )
--    WHERE  (pue.physical_item_sn_id IS NULL
--        OR pue.physical_item_sn_id < 1)
--        AND pue.sys_ei_niin = v_niin; 

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
--    UPDATE pfsa_usage_event 
--    SET    physical_item_sn_id = 0
--    WHERE  physical_item_sn_id IS NULL
--        AND sys_ei_niin = v_niin;

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
-- FORCE 

--    UPDATE pfsa_usage_event pue
--    SET    force_unit_id = 
--            (
--            SELECT NVL(force_unit_id, -1)  
--            FROM   pfsawh_force_unit_dim 
--            WHERE  uic = pue.uic 
--                AND status = 'C'
--            )
--    WHERE  (pue.force_unit_id IS NULL 
--        OR pue.force_unit_id < 1)
--        AND pue.sys_ei_niin = v_niin; 

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- LOCATION     

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- MIMOSA      

--    UPDATE pfsa_usage_event 
--    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
--    WHERE  physical_item_sn_id >= 0 
--        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000')
--        AND sys_ei_niin = v_niin; 
--        
--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- PBA_ID 

--    UPDATE pfsa_usage_event_tmp pue
--    SET    pba_id = (
--                    SELECT NVL(itm.pba_id, 1000000)
--                    FROM   pfsa_pba_items_ref itm, 
--                           pfsa_pba_ref pba 
--                    WHERE  pba.pba_key1 = 'USA' 
--                        AND pba.pba_id = itm.pba_id  
--                        AND itm.item_identifier_type_id = 13 
--                        AND itm.physical_item_id = pue.physical_item_id 
--                    )
--    WHERE (pue.pba_id = 1000000 
--        OR pue.pba_id IS NULL)
--        AND pue.physical_item_id = v_physical_item_id; 
--        
--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

--    UPDATE pfsa_usage_event 
--    SET    pba_id = 1000000 
--    WHERE  pba_id IS NULL
--        AND sys_ei_niin = v_niin;
--    
--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- FROM_DT_ID 

    UPDATE pfsa_usage_event pue
    SET    from_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  ref.oracle_date = pue.from_dt 
                    )
    WHERE pue.from_dt_id IS NULL
        AND pue.sys_ei_niin = v_niin; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- TO_DT_ID 

    UPDATE pfsa_usage_event pue
    SET    to_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  TO_CHAR(to_dt, 'DD-MON-YYYY') = ref.oracle_date 
                    )
    WHERE pue.to_dt_id IS NULL
        AND pue.sys_ei_niin = v_niin; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
-- Set MONTH_SEG_DATE_ID 

    UPDATE pfsa_usage_event 
    SET    month_seg_date_id = 
               fn_date_to_date_id (
               CASE WHEN TO_CHAR(fn_date_id_to_date(from_dt_id), 'DD') < 16 THEN
                   TO_DATE('01' || TO_CHAR(fn_date_id_to_date(from_dt_id), 'MON-YYYY'), 'DD-MON-YYYY') 
               ELSE 
                   TO_DATE('16' || TO_CHAR(fn_date_id_to_date(from_dt_id), 'MON-YYYY'), 'DD-MON-YYYY') 
               END )
    WHERE month_seg_date_id IS NULL
        AND sys_ei_niin = v_niin;
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- CRC_VALUE 

--    UPDATE  pfsa_usage_event 
--    SET     crc_value = fn_get_pfsawh_crc ( from_dt_id || 
--            physical_item_id || physical_item_sn_id || pba_id ||
--            usage || usage_mb );

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

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

    ps_location := 'PFSA 30';            -- For std_pfsawh_debug_tbl logging. 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_usage_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_usage_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    COMMIT; 
    
-- Analyze the table and re-build the indexes 

    IF run_reindex('pfsa_usage_event') THEN 

        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_usage_event               DELETE STATISTICS'; 
        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsa_usage_event               COMPUTE STATISTICS'; 
        
        EXECUTE IMMEDIATE 'ALTER INDEX   pk_pfsa_usage_event            REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_usage_event_itm       REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_usage_event_insert_dt REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_usage_event_lst_updt  REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsa_usage_event_update_dt REBUILD';
        
    END IF; 

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                               Populate facts                               */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
    proc1.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
      
    proc1.process_RecId      := 220; 
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
        
/*----- pfsawh_item_sn_t_fact -----*/     

    ps_location := 'PFSA 40';            -- For std_pfsawh_debug_tbl logging. 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    ps_location := 'PFSA 60';            -- For std_pfsawh_debug_tbl logging. 
    
--    UPDATE pfsawh_item_sn_t_fact 
--    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
--    WHERE  physical_item_sn_id >= 0 
--        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;    
    
/*----- pfsawh_item_sn_p_fact -----*/     

    ps_location := 'PFSA 70';            -- For std_pfsawh_debug_tbl logging. 
    
-- Reset the facts to NULL.     
    
--    UPDATE pfsawh_item_sn_p_fact 
--    SET    item_usage_type_0 = NULL, 
--           item_usage_0      = NULL 
--    WHERE  physical_item_id  = v_physical_item_id    -- 141146 v_physical_item_id  --
--        ; 
    
--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT;  
    
-- Insert the new facts within the cutoff window.  

-- M - Miles 

--    UPDATE  pfsawh_item_sn_p_fact pf
--    SET (
--        item_usage_type_0, 
--        item_usage_0
--        ) = (
--            SELECT 
--                tf.usage_mb, 
--                SUM(tf.usage) 
--            FROM   pfsa_usage_event tf 
--            WHERE  tf.physical_item_id = pf.physical_item_id 
--                AND tf.physical_item_sn_id = pf.physical_item_sn_id
--                AND tf.month_seg_date_id = pf.item_date_to_id 
--                AND tf.pba_id = pf.pba_id 
--                AND tf.force_unit_id = pf.item_force_id 
--                AND tf.usage_mb = ('M')  
--                AND tf.hidden_flag = 'N' 
--            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
--                tf.usage_mb, tf.pba_id, tf.force_unit_id 
--            ) 
--    WHERE pf.physical_item_id = v_physical_item_id -- 141146 v_physical_item_id -- 
--        AND item_usage_0 IS NULL;  

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, 
                month_seg_date_id, usage_mb,   
                SUM(usage) as usage
             FROM   pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('M')
                 AND delete_flag = 'N'   
             GROUP BY physical_item_id, usage_mb, pba_id, 
                 physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_0 = tf.usage_mb, 
              pf.item_usage_0      = tf.usage;    

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;
    
-- H - Hours 

--    UPDATE  pfsawh_item_sn_p_fact pf
--    SET (
--        item_usage_type_1, 
--        item_usage_1 
--        ) = (
--            SELECT 
--                tf.usage_mb, 
--                SUM(tf.usage)
--            FROM   pfsa_usage_event tf 
--            WHERE  tf.physical_item_id = pf.physical_item_id 
--                AND tf.physical_item_sn_id = pf.physical_item_sn_id
--                AND tf.month_seg_date_id = pf.date_id 
--                AND tf.pba_id = pf.pba_id 
--                AND tf.force_unit_id = pf.item_force_id 
--                AND tf.usage_mb = ('H')  
--                AND tf.hidden_flag = 'N' 
--            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
--                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
--            ) 
--    WHERE pf.physical_item_id = v_physical_item_id -- 141146 v_physical_item_id -- 
--        AND item_usage_1 IS NULL;  

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, 
                month_seg_date_id, usage_mb,   
                SUM(usage) as usage
             FROM   pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('H')
                 AND delete_flag = 'N'   
             GROUP BY physical_item_id, usage_mb, pba_id, 
                 physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_1 = tf.usage_mb, 
              pf.item_usage_1      = tf.usage; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;
    
-- F - Flight hours     

--    UPDATE  pfsawh_item_sn_p_fact pf
--    SET (
--        item_usage_type_0, 
--        item_usage_0 
--        ) = (
--            SELECT 
--                tf.usage_mb, 
--                SUM(tf.usage)
--            FROM   pfsa_usage_event tf 
--            WHERE  tf.physical_item_id = pf.physical_item_id 
--                AND tf.physical_item_sn_id = pf.physical_item_sn_id
--                AND tf.month_seg_date_id = pf.date_id 
--                AND tf.pba_id = pf.pba_id 
--                AND tf.force_unit_id = pf.item_force_id 
--                AND tf.usage_mb = ('F')  
--                AND tf.delete_flag = 'N' 
--            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
--                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
--            ) 
--    WHERE pf.physical_item_id = v_physical_item_id -- 141146 v_physical_item_id -- 
--        AND item_usage_0 IS NULL;  

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, 
                month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('F')
                 AND delete_flag = 'N'   
             GROUP BY physical_item_id, usage_mb, pba_id, 
                 physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_0 = tf.usage_mb, 
              pf.item_usage_0      = tf.usage; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;
    
-- L - Landings     

--    UPDATE  pfsawh_item_sn_p_fact pf
--    SET (
--        item_usage_type_1, 
--        item_usage_1 
--        ) = (
--            SELECT 
--                tf.usage_mb, 
--                SUM(tf.usage)
--            FROM   pfsa_usage_event tf 
--            WHERE  tf.physical_item_id = pf.physical_item_id 
--                AND tf.physical_item_sn_id = pf.physical_item_sn_id
--                AND tf.month_seg_date_id = pf.date_id 
--                AND tf.pba_id = pf.pba_id 
--                AND tf.force_unit_id = pf.item_force_id 
--                AND tf.usage_mb = ('L')  
--                AND tf.delete_flag = 'N' 
--            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
--                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
--            ) 
--    WHERE pf.physical_item_id = v_physical_item_id -- 141146 v_physical_item_id -- 
--        AND item_usage_1 IS NULL;  

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, 
                month_seg_date_id, usage_mb, 
                SUM(usage) as usage
             FROM   pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('L') 
                 AND delete_flag = 'N'   
             GROUP BY physical_item_id, usage_mb, pba_id, 
                 physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_1 = tf.usage_mb, 
              pf.item_usage_1      = tf.usage; 
 
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
    
-- LA - Landing auto-ratation --    

--    UPDATE  pfsawh_item_sn_p_fact pf
--    SET (
--        item_usage_type_2, 
--        item_usage_2 
--        ) = (
--            SELECT 
--                tf.usage_mb, 
--                SUM(tf.usage)
--            FROM   pfsa_usage_event tf 
--            WHERE  tf.physical_item_id = pf.physical_item_id 
--                AND tf.physical_item_sn_id = pf.physical_item_sn_id
--                AND tf.month_seg_date_id = pf.date_id 
--                AND tf.pba_id = pf.pba_id 
--                AND tf.force_unit_id = pf.item_force_id 
--                AND tf.usage_mb = ('LA')  
--                AND tf.delete_flag = 'N' 
--            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
--                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
--            ) 
--    WHERE pf.physical_item_id = v_physical_item_id -- 141146 v_physical_item_id -- 
--        AND item_usage_2 IS NULL;  
        
    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, 
                month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('LA') 
                 AND delete_flag = 'N'  
             GROUP BY physical_item_id, usage_mb, pba_id, 
                 physical_item_sn_id, month_seg_date_id   
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_2 = tf.usage_mb, 
              pf.item_usage_2      = tf.usage; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;   

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
  
-- Update the status of the sub-process PPFSA_USAGE_EVENT. 

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
    proc0.message := proc0.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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

