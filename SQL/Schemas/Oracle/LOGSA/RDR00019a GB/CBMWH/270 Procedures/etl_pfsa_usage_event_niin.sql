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

    etl_pfsa_usage_event_niin (141146, 'GBelford'); 
    
    COMMIT; 

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_pfsa_usage_event_niin    
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS

-- Exception handling variables (ps_)

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'etl_pfsa_usage_event_niin';  /*  */
ps_location                      std_cbmwh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_cbmwh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_cbmwh_debug_tbl.ps_msg%TYPE 
    := 'no message defined'; /*  */
ps_id_key                        std_cbmwh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- standard variables

ps_status                        VARCHAR2(10)  := 'STARTED';

ps_main_status                   VARCHAR2(10)  := null;

l_ps_start                       DATE          := sysdate;
l_now_is                         DATE          := sysdate;

l_call_error                     VARCHAR2(20)  := null;
ls_start                         DATE          := null;

proc0_recId                          cbmwh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                          cbmwh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 cbmwh_process_log%ROWTYPE; 
proc1                 cbmwh_process_log%ROWTYPE; 

ps_last_process       cbmwh_processes%ROWTYPE;
ps_this_process       cbmwh_processes%ROWTYPE;
ls_current_process    cbmwh_processes%ROWTYPE; 

v_etl_copy_cutoff_days        cbmwh_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days          cbmwh_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months        cbmwh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                 NUMBER        := 1; 

v_etl_copy_cutoff       DATE; 
v_t_fact_cutoff         DATE; 
v_t_fact_cutoff_id      NUMBER; 
v_p_fact_cutoff         DATE; 
v_p_fact_cutoff_id      NUMBER; 

v_niin                  VARCHAR2(9); 

BEGIN 

-- Get the process control values from cbmwh_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_cbmwh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
    v_t_fact_cutoff_days   := fn_cbmwh_get_prcss_cntrl_val('v_t_fact_cutoff_days'); 
    v_p_fact_cutoff_months := fn_cbmwh_get_prcss_cntrl_val('v_p_fact_cutoff_months');  

-- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    v_etl_copy_cutoff    := SYSDATE - v_etl_copy_cutoff_days; 
    v_t_fact_cutoff      := SYSDATE - v_t_fact_cutoff_days; 
    v_t_fact_cutoff_id   := fn_date_to_date_id(v_t_fact_cutoff); 
    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  (-1 * v_p_fact_cutoff_months)); 
    v_p_fact_cutoff_id   := fn_date_to_date_id(v_p_fact_cutoff); 
    
    SELECT niin 
    INTO   v_niin 
    FROM   cbmwh_item_dim 
    WHERE  physical_item_id = v_physical_item_id; 

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
  
    pr_cbmwh_insupd_processlog 
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
        
    proc1.process_RecId      := 220; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    pr_cbmwh_insupd_processlog 
        (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        ); 
        
    COMMIT;     
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := nvl(type_maintenance, 'GENERIC PFSA ETL');

-- Housekeeping for the process 
  
    ps_location := 'PFSA 00';            -- For std_cbmwh_debug_tbl logging. 

    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_status      := 'BEGAN';
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_compl       := null;

-- get the run criteria from the pfsa_processes table for the last run of this 
-- main process 
  
    get_cbmwh_process_info ( 
        ps_procedure_name, ps_procedure_name, ps_last_process.last_run, 
        ps_last_process.who_ran, ps_last_process.last_run_status, 
        ps_last_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- Update the PFSA_PROCESSES table to indicate MAIN process began.  

    updt_cbmwh_processes (
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
      
    proc1.process_RecId      := 220; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 30;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    pr_cbmwh_insupd_processlog 
        (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        ); 
        
    COMMIT;     
        
    ps_location := 'PFSA 80';            -- For std_cbmwh_debug_tbl logging. 
    
    ls_current_process.cbmwh_process := 'PFSA_USAGE_EVENT'; 
  
-- Get the run criteria for the PFSA_USAGE_EVENT from pfsa_process table 

    get_cbmwh_process_info
        (
        ps_procedure_name, ls_current_process.cbmwh_process, 
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

    updt_cbmwh_processes
        (
        ps_procedure_name, ls_current_process.cbmwh_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
    ps_status := ps_location;
  
-- Update main process to indicate where its at 

    updt_cbmwh_processes
        (ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_status, l_now_is, 
        ps_this_process.last_run_compl
        ); 
      
    COMMIT;  
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 

    DELETE pfsa_usage_event_tmp; 

    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT;

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
    WHERE ue.sys_ei_niin = v_niin; -- '013285964' --
 
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
--  Set warehouse ids  

-- ITEM 

    UPDATE pfsa_usage_event_tmp pue
    SET    physical_item_id = 
            (
            SELECT physical_item_id 
            FROM   cbmwh_item_dim 
            WHERE  niin = pue.sys_ei_niin
            )
    WHERE  pue.physical_item_id IS NULL; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- ITEM_SN     

    UPDATE pfsa_usage_event_tmp pue
    SET    physical_item_sn_id = 
            (
            SELECT physical_item_sn_id 
            FROM   cbmwh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
            )
    WHERE  physical_item_sn_id IS NULL; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- FRZ_INPUT_DATE_ID    

    UPDATE pfsa_usage_event_tmp ue 
    SET    frz_input_date_id = fn_date_to_date_id(ue.frz_input_date) 
    WHERE  frz_input_date_id IS NULL; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
 
    ps_location := 'PFSA 82';            -- For std_cbmwh_debug_tbl logging. 
    
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
        physical_item_sn_id, frz_input_date,
        frz_input_date_id, active_flag, active_date, inactive_date,
        insert_by,
        insert_date, update_by, update_date, delete_flag, delete_date,
        hidden_flag, hidden_date, delete_by, hidden_by, pba_id  
        FROM pfsa_usage_event_tmp) b
    ON (a.sys_ei_niin = b.sys_ei_niin 
        and a.pfsa_item_id = b.pfsa_item_id 
        and a.record_type = b.record_type 
        and a.usage_mb = b.usage_mb 
        and a.from_dt = b.from_dt 
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
        physical_item_sn_id, frz_input_date, 
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
        b.physical_item_sn_id, b.frz_input_date, 
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

    COMMIT;
    
-- Set warehouse ids    

-- ITEM 

    UPDATE pfsa_usage_event pue
    SET    physical_item_id = 
            (
            SELECT NVL(physical_item_id, 0) 
            FROM   cbmwh_item_dim 
            WHERE  niin = pue.sys_ei_niin
            )
    WHERE  physical_item_id IS NULL
        OR physical_item_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- ITEM_SN     

    UPDATE pfsa_usage_event pue
    SET    physical_item_sn_id = 
            (
            SELECT NVL(physical_item_sn_id, 0) 
            FROM   cbmwh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
            )
    WHERE  physical_item_sn_id IS NULL
        OR physical_item_sn_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    UPDATE pfsa_usage_event pue
    SET    physical_item_sn_id = 0
    WHERE  physical_item_sn_id IS NULL;

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- FORCE 

    UPDATE pfsa_usage_event pue
    SET    force_unit_id = 
            (
            SELECT NVL(force_unit_id, -1)  
            FROM   cbmwh_force_unit_dim 
            WHERE  uic = pue.uic 
                AND status = 'C'
            )
    WHERE  force_unit_id IS NULL 
        OR force_unit_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- LOCATION     

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- MIMOSA      

    UPDATE pfsa_usage_event 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- PBA_ID 

    UPDATE pfsa_usage_event sn
    SET    pba_id = (
                    SELECT NVL(ref.pba_id, 1000000)
                    FROM   pfsawh.pfsa_pba_items_ref ref
                    WHERE  ref.item_identifier_type_id = 13 
                        AND ref.pba_id > 1000007 
                        AND sn.physical_item_id = ref.physical_item_id 
                    )
    WHERE sn.pba_id = 1000000 
        OR sn.pba_id IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    UPDATE pfsa_usage_event 
    SET    pba_id = 1000000 
    WHERE  pba_id IS NULL;
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- FROM_DT_ID 

    UPDATE pfsa_usage_event sn
    SET    from_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  sn.from_dt = ref.oracle_date 
                    )
    WHERE sn.from_dt_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- TO_DT_ID 

    UPDATE pfsa_usage_event sn
    SET    to_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  TO_CHAR(to_dt, 'DD-MON-YYYY') = ref.oracle_date 
                    )
    WHERE sn.to_dt_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- Set MONTH_SEG_DATE_ID 

    UPDATE pfsa_usage_event 
    SET    month_seg_date_id = 
               fn_date_to_date_id (
               CASE WHEN TO_CHAR(fn_date_id_to_date(from_dt_id), 'DD') < 16 THEN
                   TO_DATE('01' || TO_CHAR(fn_date_id_to_date(from_dt_id), 'MON-YYYY'), 'DD-MON-YYYY') 
               ELSE 
                   TO_DATE('16' || TO_CHAR(fn_date_id_to_date(from_dt_id), 'MON-YYYY'), 'DD-MON-YYYY') 
               END )
    WHERE month_seg_date_id IS NULL;
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- CRC_VALUE 

--    UPDATE  pfsa_usage_event 
--    SET     crc_value = fn_get_cbmwh_crc ( from_dt_id || 
--            physical_item_id || physical_item_sn_id || pba_id ||
--            usage || usage_mb );

--    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_cbmwh_insupd_processlog 
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

    ps_location := 'PFSA 84';            -- For std_cbmwh_debug_tbl logging. 
    
--    pr_upd_pfsa_fsc_sys_dates (ps_this_process.who_ran, 'USAGE_PERIOD_DATE'); 
    
    COMMIT; 

    DELETE pfsa_usage_event_tmp; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
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
      
    proc1.process_RecId      := 220; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 35;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    pr_cbmwh_insupd_processlog 
        (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        );
        
/*----- cbmwh_item_sn_t_fact -----*/     

    ps_location := 'PFSA 85';            -- For std_cbmwh_debug_tbl logging. 
    
-- Reset the facts to NULL.     
    
--    UPDATE cbmwh_item_sn_t_fact
--    SET    tem_usage_type_0 = NULL, 
--           item_usage_0     = NULL 
--    WHERE  physical_item_id = v_physical_item_id 
--        AND etl_processed_by = ps_procedure_name; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- Merge in the new facts within the cutoff window.  
    
    ps_location := 'PFSA 86';            -- For std_cbmwh_debug_tbl logging. 
    
--    MERGE 
--    INTO   cbmwh_item_sn_t_fact f 
--    USING (
--        SELECT sys_ei_niin,
--            pfsa_item_id,
--            from_dt,
--            to_dt,
--            NVL(force_unit_id, 0) AS force_unit_id, 
--            usage,         
--            usage_mb,
--            from_dt_id, 
--            NVL(from_dt_tm_id, 10001) AS from_dt_tm_id, 
--            to_dt_id, 
--            NVL(to_dt_tm_id, 96400) AS to_dt_tm_id, 
--            physical_item_id, 
--            physical_item_sn_id,
--            mimosa_item_sn_id,
--            pba_id  
--        FROM pfsa_usage_event 
--        WHERE from_dt >= v_t_fact_cutoff 
--          ) pue 
--        ON (f.date_id = pue.from_dt_id AND
--            f.physical_item_id = pue.physical_item_id AND
--            f.physical_item_sn_id = pue.physical_item_sn_id   
--            AND f.pba_id = pue.pba_id
--            )
--        WHEN MATCHED THEN
--            UPDATE SET 
--                item_usage_0      = pue.usage, 
--                item_usage_type_0 = pue.usage_mb,  
--                item_force_id     = pue.force_unit_id, 
--                etl_processed_by  = ps_procedure_name   
--        WHEN NOT MATCHED THEN 
--            INSERT (
--                date_id,
--                pba_id, 
--                physical_item_id,      physical_item_sn_id,
--                item_date_from_id,     item_time_from_id,
--                item_date_to_id,       item_time_to_id,
--                mimosa_item_sn_id, 
--                item_force_id, 
--                item_usage_0,          item_usage_type_0,
--                item_usage_1,          item_usage_type_1,
--                item_usage_2,          item_usage_type_2, 
--                notes,
--                etl_processed_by 
--                )
--            VALUES (
--                pue.from_dt_id,
--                pue.pba_id, 
--                pue.physical_item_id,  pue.physical_item_sn_id,
--                pue.from_dt_id,        NVL(pue.from_dt_tm_id, 10001),
--                pue.to_dt_id,          NVL(pue.to_dt_tm_id, 96400),
--                pue.mimosa_item_sn_id, 
--                pue.force_unit_id, 
--                pue.usage,             pue.usage_mb,
--                -1,                    '-1',
--                -1,                    '-1',
--                '', 
--                ps_procedure_name 
--                );

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT;    
    
    ps_location := 'PFSA 87';            -- For std_cbmwh_debug_tbl logging. 
    
--    UPDATE cbmwh_item_sn_t_fact 
--    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
--    WHERE  physical_item_sn_id >= 0 
--        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;    
    
/*----- cbmwh_item_sn_p_fact -----*/     

    ps_location := 'PFSA 88';            -- For std_cbmwh_debug_tbl logging. 
    
-- Reset the facts to NULL.     
    
    UPDATE cbmwh_item_sn_p_fact 
    SET    item_usage_type_0 = NULL, 
           item_usage_0      = NULL 
    WHERE  physical_item_id  = v_physical_item_id 
--        AND etl_processed_by = ps_procedure_name
        ; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;  
    
-- Insert the new facts within the cutoff window.  

--    INSERT 
--    INTO   cbmwh_item_sn_p_fact 
--        (
--        date_id, 
--        physical_item_id, 
--        physical_item_sn_id, 
--        item_date_from_id, 
--        item_date_to_id, 
--        mimosa_item_sn_id, 
--        item_force_id, 
--        item_usage_type_0, 
--        item_usage_0, 
--        notes,
--        etl_processed_by, 
--        pba_id
--        )
--    SELECT tf.date_id, 
--        tf.physical_item_id, 
--        tf.physical_item_sn_id, 
--        tf.item_date_from_id, 
--        tf.item_date_to_id, 
--        tf.mimosa_item_sn_id, 
--        tf.item_force_id, 
--        tf.item_usage_type_0, 
--        SUM(tf.item_usage_0), 
--        '', 
--        ps_procedure_name,
--        tf.pba_id 
--    FROM   cbmwh_item_sn_t_fact tf 
--    WHERE  NOT EXISTS (
--                     SELECT pf.rec_id 
--                     FROM   cbmwh_item_sn_p_fact pf 
--                     WHERE TO_CHAR(fn_date_id_to_date(tf.date_id), 'mon-yyyy') = TO_CHAR(fn_date_id_to_date(pf.date_id), 'mon-yyyy')
--                        AND tf.physical_item_id = pf.physical_item_id 
--                        AND tf.physical_item_sn_id = pf.physical_item_sn_id 
--                        AND tf.pba_id = pf.pba_id 
--                     )  
--        AND tf.physical_item_id > 0 
--        AND tf.physical_item_sn_id > 0 
--        AND etl_processed_by = ps_procedure_name  
--    GROUP BY tf.date_id, tf.physical_item_id, tf.physical_item_sn_id, 
--        tf.item_usage_type_0, item_date_from_id, item_date_to_id,
--        tf.item_force_id, ps_procedure_name, tf.mimosa_item_sn_id, 
--        tf.pba_id; 
        
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT;     

    UPDATE  cbmwh_item_sn_p_fact pf
    SET (
        item_usage_type_0, 
        item_usage_0 
        ) = (
            SELECT 
                tf.usage_mb, 
                SUM(tf.usage)
            FROM   pfsa_usage_event tf 
            WHERE  tf.month_seg_date_id = pf.date_id
                AND tf.physical_item_sn_id = pf.physical_item_sn_id 
--                AND tf.force_unit_id = pf.item_force_id
                AND tf.pba_id = pf.pba_id 
                AND tf.usage_mb = 'M'   
            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
            ) 
    WHERE pf.physical_item_id = v_physical_item_id --   141146
--        AND etl_processed_by = ps_procedure_name
        ;  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;     

/*

            SELECT tf.pba_id, tf.physical_item_sn_id, tf.force_unit_id, 
                tf.month_seg_date_id, 
                tf.usage_mb, 
                SUM(tf.usage)
            FROM   pfsa_usage_event tf, 
                cbmwh_item_sn_p_fact pf  
            WHERE  TO_CHAR(fn_date_id_to_date(tf.from_dt_id), 'mon-yyyy') = TO_CHAR(fn_date_id_to_date(pf.date_id), 'mon-yyyy')
                AND tf.physical_item_id = 141146 
                AND tf.physical_item_sn_id = pf.physical_item_sn_id  
                AND tf.pba_id = 1000016  
                AND tf.usage_mb= 'M'   
            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, tf.force_unit_id, 
                tf.usage_mb, tf.pba_id 
            ORDER BY tf.pba_id, tf.physical_item_sn_id, tf.force_unit_id, 
                tf.month_seg_date_id, 
                tf.usage_mb  

*/

-- Update the existing facts within the cutoff window.  
    
    ps_location := 'PFSA 89';            -- For std_cbmwh_debug_tbl logging. 
/*    
    UPDATE cbmwh_item_sn_p_fact pf  
    SET     ( 
            item_usage_type_0, 
            item_usage_0 
            ) = (
                SELECT 
                --   tf.date_id, tf.physical_item_id, tf.physical_item_sn_id,
                   tf.item_usage_type_0, 
                   tf.item_usage_0 
                FROM cbmwh_item_sn_t_fact tf
                WHERE fn_date_id_to_date(tf.date_id) = fn_date_id_to_date(pf.date_id) 
                    AND tf.physical_item_id = pf.physical_item_id 
                    AND tf.physical_item_sn_id = pf.physical_item_sn_id
                    AND tf.pba_id = pf.pba_id 
                    AND tf.item_usage_type_0 = 'M'   
                )
    WHERE pf.etl_processed_by = ps_procedure_name;
*/
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;   

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_cbmwh_insupd_processlog 
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

    updt_cbmwh_processes
      (
      ps_procedure_name, ls_current_process.cbmwh_process, ls_start, 
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
      
    updt_cbmwh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_main_status,  
        ps_this_process.last_run_status_time, ps_this_process.last_run_compl
        );

    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_cbmwh_insupd_processlog 
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
    
    pr_cbmwh_insupd_processlog 
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
        INTO std_cbmwh_debug_tbl 
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

/*

SELECT  * 
FROM    cbmwh_item_sn_p_fact 
WHERE   physical_item_id = 141146 
    AND item_usage_0 IS NOT NULL; 

UPDATE  cbmwh_item_sn_p_fact 
SET     pba_id = 1000016 
WHERE   physical_item_id = 141223; 

COMMIT; 
*/