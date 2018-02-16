/*----- Test script -----*/

/*

BEGIN 

    daily_incr_xxx_load ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

CREATE OR REPLACE PROCEDURE daily_incr_xxx_load 
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'daily_incr_xxx_load';  /*  */
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

v_debug                 NUMBER        := 0; 

v_etl_copy_cutoff       DATE; 
v_t_fact_cutoff         DATE; 
v_t_fact_cutoff_id      NUMBER; 
v_p_fact_cutoff         DATE; 
v_p_fact_cutoff_id      NUMBER; 
myrowcount              number;
mytablename             varchar2(64);
-- added date control lmj 05nov08

my_lst_updt             DATE := null;
my_insert_dt            DATE := null;
my_update_dt            DATE := null;

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

    proc0.process_RecId      := ###; 
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

    ps_id_key := NVL(type_maintenance, 'daily_incr_xxx_load');

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

-- Call the MERGE PBA REF routine.  

    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'PFSA_SN_EI'; 
  
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

    ps_location := 'PFSA 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

-- Update the pfsa_processes table to indicate the sub-process 
-- MERGE PBA REF has started.  

    ps_location := 'PFSA 30';            -- For std_pfsawh_debug_tbl logging.

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
      
    proc1.process_RecId      := ###; 
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
        
    ps_location := 'PFSA 40';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_EQUIP_AVAIL'; 
  
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
 
    ps_location := 'PFSA 50';            -- For std_pfsawh_debug_tbl logging. 

    my_lst_updt := null;
    my_insert_dt := null;
    my_update_dt := null;
    
    select max(insert_date) into my_insert_dt from pfsa_equip_avail_xxx;
    select max(update_date) into my_update_dt from pfsa_equip_avail_xxx; 
    
    if my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
 
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_equip_avail_xxx;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_equip_avail_xxx';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
       
    ps_location := 'PFSA 60';            -- For std_pfsawh_debug_tbl logging. 
    
    INSERT 
    INTO   pfsa_equip_avail_xxx 
        (
        sys_ei_niin,      pfsa_item_id,
        record_type,      from_dt,             to_dt,
        ready_date,       day_date,            month_date,
        pfsa_org,         sys_ei_sn,           item_days,
        period_hrs,
        nmcm_hrs,       nmcs_hrs,
        nmc_hrs,        fmc_hrs,           pmc_hrs,        mc_hrs,
        nmcm_user_hrs,  nmcm_int_hrs,      nmcm_dep_hrs,
        nmcs_user_hrs,  nmcs_int_hrs,      nmcs_dep_hrs,
        pmcm_hrs,       pmcs_hrs,
        source_id,
        pmcs_user_hrs,  pmcs_int_hrs,      pmcm_user_hrs,  pmcm_int_hrs,
        dep_hrs,
        heir_id,        priority,          uic,
        grab_stamp,     proc_stamp,
        sys_ei_uid,
        status,         lst_updt,          updt_by,
        insert_by,      insert_date,
        update_by,      update_date,
        delete_flag,    delete_date,       delete_by,
        hidden_flag,    hidden_date,       hidden_by
        )
    SELECT sys_ei_niin,      pfsa_item_id,
        record_type,      from_dt,             to_dt,
        ready_date,       day_date,            month_date,
        pfsa_org,         sys_ei_sn,           item_days,
        period_hrs,
        nmcm_hrs,       nmcs_hrs,
        nmc_hrs,        fmc_hrs,           pmc_hrs,        mc_hrs,
        nmcm_user_hrs,  nmcm_int_hrs,      nmcm_dep_hrs,
        nmcs_user_hrs,  nmcs_int_hrs,      nmcs_dep_hrs,
        pmcm_hrs,       pmcs_hrs,
        source_id,
        pmcs_user_hrs,  pmcs_int_hrs,      pmcm_user_hrs,  pmcm_int_hrs,
        dep_hrs,
        heir_id,        priority,          uic,
        grab_stamp,     proc_stamp,
        sys_ei_uid,
        status,         lst_updt,          updt_by,
        insert_by,      insert_date,
        update_by,      update_date,
        delete_flag,    delete_date,       delete_by,
        hidden_flag,    hidden_date,       hidden_by
    FROM   pfsa_equip_avail@pfsaw.lidb
    WHERE 
    --add in max lst_updt compare lmj 05nov08   
            insert_date > my_lst_updt
           or update_date > my_lst_updt ; 

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
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

-- Set warehouse ids    

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := ###; 
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
        
    ps_location := 'PFSA 70';            -- For std_pfsawh_debug_tbl logging. 
    
-- ITEM 

    UPDATE pfsa_usage_event_xxx pue
    SET    physical_item_id = 
            (
            SELECT NVL(physical_item_id, 0)  
            FROM   pfsawh_item_dim 
            WHERE  niin = pue.sys_ei_niin
--                AND status = 'C'
            )  
    WHERE pue.physical_item_id IS NULL
        OR pue.physical_item_id < 1; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- ITEM_SN  

    UPDATE pfsa_usage_event_xxx pue
    SET    physical_item_sn_id = 
            (
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
            )
    WHERE  pue.physical_item_sn_id IS NULL
        OR pue.physical_item_sn_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;

-- FORCE 

    UPDATE pfsa_usage_event_xxx pue
    SET    force_unit_id = 
            (
            SELECT NVL(force_unit_id, -1)  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = pue.uic 
                AND status = 'C'
            )
    WHERE  force_unit_id IS NULL 
        OR force_unit_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- LOCATION     

-- MIMOSA      

    UPDATE pfsa_equip_avail_xxx 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    ps_location := 'PFSA 80';            -- For std_pfsawh_debug_tbl logging. 
    
-- PBA_ID 

    UPDATE pfsa_maint_event_xxx me
    SET    pba_id = (
                    SELECT NVL(itm.pba_id, 1000000)
                    FROM   pfsa_pba_items_ref itm, 
                           pfsa_pba_ref pba 
                    WHERE  pba.pba_key1 = 'USA' 
                        AND pba.pba_id = itm.pba_id  
                        AND itm.item_identifier_type_id = 13 
                        AND itm.physical_item_id = me.physical_item_id 
                    )
    WHERE me.pba_id = 1000000 
        OR me.pba_id IS NULL; 

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

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := ###; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 30;
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
    ps_location := 'PFSA 90';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   pfsa_equip_avail_ pea 
    USING  (SELECT 
--                rec_id,           source_rec_id,       pba_id, 
--                physical_item_id, physical_item_sn_id,
--                force_unit_id,    mimosa_item_sn_id,
                sys_ei_niin,      pfsa_item_id,
                record_type,      from_dt,             to_dt,
                ready_date,       day_date,            month_date,
                pfsa_org,         sys_ei_sn,           item_days,
                period_hrs,
                nmcm_hrs,       nmcs_hrs,
                nmc_hrs,        fmc_hrs,           pmc_hrs,        mc_hrs,
                nmcm_user_hrs,  nmcm_int_hrs,      nmcm_dep_hrs,
                nmcs_user_hrs,  nmcs_int_hrs,      nmcs_dep_hrs,
                pmcm_hrs,       pmcs_hrs,
                source_id,
                pmcs_user_hrs,  pmcs_int_hrs,      pmcm_user_hrs,  pmcm_int_hrs,
                dep_hrs,
                heir_id,        priority,          uic,
                grab_stamp,     proc_stamp,
                sys_ei_uid,
                status,         lst_updt,          updt_by,
--                frz_input_date, frz_input_date_id, rec_frz_flag,   frz_date,
                insert_by,      insert_date,
                update_by,      update_date,
                delete_flag,    delete_date,       delete_by,
                hidden_flag,    hidden_date,       hidden_by
            FROM   pfsa_equip_avail_xxx ) tmp 
    ON     (pea.sys_ei_niin      = tmp.sys_ei_niin
            AND pea.pfsa_item_id = tmp.pfsa_item_id 
            AND pea.record_type  = tmp.record_type
            AND pea.from_dt      = tmp.from_dt)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            pea.rec_id              = tmp.rec_id,            
--            pea.source_rec_id       = tmp.source_rec_id,        
--            pea.pba_id              = tmp.pba_id,  
--            pea.physical_item_id    = tmp.physical_item_id,  
--            pea.physical_item_sn_id = tmp.physical_item_sn_id, 
--            pea.force_unit_id       = tmp.force_unit_id,     
--            pea.mimosa_item_sn_id   = tmp.mimosa_item_sn_id, 
--            pea.sys_ei_niin         = tmp.sys_ei_niin,       
--            pea.pfsa_item_id        = tmp.pfsa_item_id, 
--            pea.record_type         = tmp.record_type,       
--            pea.from_dt             = tmp.from_dt,              
            pea.to_dt               = tmp.to_dt, 
            pea.ready_date          = tmp.ready_date,        
            pea.day_date            = tmp.day_date,             
            pea.month_date          = tmp.month_date, 
            pea.pfsa_org            = tmp.pfsa_org,          
            pea.sys_ei_sn           = tmp.sys_ei_sn,            
            pea.item_days           = tmp.item_days, 
            pea.period_hrs          = tmp.period_hrs, 
            pea.nmcm_hrs            = tmp.nmcm_hrs,        
            pea.nmcs_hrs            = tmp.nmcs_hrs, 
            pea.nmc_hrs             = tmp.nmc_hrs,         
            pea.fmc_hrs             = tmp.fmc_hrs,            
            pea.pmc_hrs             = tmp.pmc_hrs,         
            pea.mc_hrs              = tmp.mc_hrs, 
            pea.nmcm_user_hrs       = tmp.nmcm_user_hrs,   
            pea.nmcm_int_hrs        = tmp.nmcm_int_hrs,       
            pea.nmcm_dep_hrs        = tmp.nmcm_dep_hrs, 
            pea.nmcs_user_hrs       = tmp.nmcs_user_hrs,   
            pea.nmcs_int_hrs        = tmp.nmcs_int_hrs,       
            pea.nmcs_dep_hrs        = tmp.nmcs_dep_hrs, 
            pea.pmcm_hrs            = tmp.pmcm_hrs,        
            pea.pmcs_hrs            = tmp.pmcs_hrs, 
            pea.source_id           = tmp.source_id, 
            pea.pmcs_user_hrs       = tmp.pmcs_user_hrs,   
            pea.pmcs_int_hrs        = tmp.pmcs_int_hrs,       
            pea.pmcm_user_hrs       = tmp.pmcm_user_hrs,   
            pea.pmcm_int_hrs        = tmp.pmcm_int_hrs, 
            pea.dep_hrs             = tmp.dep_hrs, 
            pea.heir_id             = tmp.heir_id,         
            pea.priority            = tmp.priority,           
            pea.uic                 = tmp.uic, 
            pea.grab_stamp          = tmp.grab_stamp,      
            pea.proc_stamp          = tmp.proc_stamp, 
            pea.sys_ei_uid          = tmp.sys_ei_uid, 
            pea.status              = tmp.status,          
            pea.lst_updt            = tmp.lst_updt,           
            pea.updt_by             = tmp.updt_by, 
--            pea.frz_input_date      = tmp.frz_input_date,  
--            pea.frz_input_date_id   = tmp.frz_input_date_id,  
--            pea.rec_frz_flag        = tmp.rec_frz_flag,   
--            pea.frz_date            = tmp.frz_date, 
            pea.insert_by           = tmp.insert_by,       
            pea.insert_date         = tmp.insert_date, 
            pea.update_by           = tmp.update_by,       
            pea.update_date         = tmp.update_date, 
            pea.delete_flag         = tmp.delete_flag,     
            pea.delete_date         = tmp.delete_date,        
            pea.delete_by           = tmp.delete_by, 
            pea.hidden_flag         = tmp.hidden_flag,     
            pea.hidden_date         = tmp.hidden_date,        
            pea.hidden_by           = tmp.hidden_by              
    WHEN NOT MATCHED THEN 
        INSERT (
--                pea.rec_id,           pea.source_rec_id,       pea.pba_id, 
--                pea.physical_item_id, pea.physical_item_sn_id,
--                pea.force_unit_id,    pea.mimosa_item_sn_id,
                pea.sys_ei_niin,      pea.pfsa_item_id,
                pea.record_type,      pea.from_dt,             pea.to_dt,
                pea.ready_date,       pea.day_date,            pea.month_date,
                pea.pfsa_org,         pea.sys_ei_sn,           pea.item_days,
                pea.period_hrs,
                pea.nmcm_hrs,       pea.nmcs_hrs,
                pea.nmc_hrs,        pea.fmc_hrs,           
                pea.pmc_hrs,        pea.mc_hrs,
                pea.nmcm_user_hrs,  pea.nmcm_int_hrs,      pea.nmcm_dep_hrs,
                pea.nmcs_user_hrs,  pea.nmcs_int_hrs,      pea.nmcs_dep_hrs,
                pea.pmcm_hrs,       pea.pmcs_hrs,
                pea.source_id,
                pea.pmcs_user_hrs,  pea.pmcs_int_hrs,      
                pea.pmcm_user_hrs,  pea.pmcm_int_hrs,
                pea.dep_hrs,
                pea.heir_id,        pea.priority,          pea.uic,
                pea.grab_stamp,     pea.proc_stamp,
                pea.sys_ei_uid,
                pea.status,         pea.lst_updt,          pea.updt_by,
--                pea.frz_input_date, pea.frz_input_date_id, pea.rec_frz_flag,   pea.frz_date,
                pea.insert_by,      pea.insert_date,
                pea.update_by,      pea.update_date,
                pea.delete_flag,    pea.delete_date,       pea.delete_by,
                pea.hidden_flag,    pea.hidden_date,       pea.hidden_by)
        VALUES (
--                tmp.rec_id,           tmp.source_rec_id,       tmp.pba_id, 
--                tmp.physical_item_id, tmp.physical_item_sn_id,
--                tmp.force_unit_id,    tmp.mimosa_item_sn_id,
                tmp.sys_ei_niin,      tmp.pfsa_item_id,
                tmp.record_type,      tmp.from_dt,             tmp.to_dt,
                tmp.ready_date,       tmp.day_date,            tmp.month_date,
                tmp.pfsa_org,         tmp.sys_ei_sn,           tmp.item_days,
                tmp.period_hrs,
                tmp.nmcm_hrs,       tmp.nmcs_hrs,
                tmp.nmc_hrs,        tmp.fmc_hrs,           
                tmp.pmc_hrs,        tmp.mc_hrs,
                tmp.nmcm_user_hrs,  tmp.nmcm_int_hrs,      tmp.nmcm_dep_hrs,
                tmp.nmcs_user_hrs,  tmp.nmcs_int_hrs,      tmp.nmcs_dep_hrs,
                tmp.pmcm_hrs,       tmp.pmcs_hrs,
                tmp.source_id,
                tmp.pmcs_user_hrs,  tmp.pmcs_int_hrs,      
                tmp.pmcm_user_hrs,  tmp.pmcm_int_hrs,
                tmp.dep_hrs,
                tmp.heir_id,        tmp.priority,          tmp.uic,
                tmp.grab_stamp,     tmp.proc_stamp,
                tmp.sys_ei_uid,
                tmp.status,         tmp.lst_updt,          tmp.updt_by,
--                tmp.frz_input_date, tmp.frz_input_date_id, tmp.rec_frz_flag,   tmp.frz_date,
                tmp.insert_by,      tmp.insert_date,
                tmp.update_by,      tmp.update_date,
                tmp.delete_flag,    tmp.delete_date,       tmp.delete_by,
                tmp.hidden_flag,    tmp.hidden_date,       tmp.hidden_by);

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    pr_upd_pfsa_fcs_sys_dates (ps_this_process.who_ran, 'EQUIP_AVAIL_PERIOD_DATE'); 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_equip_avail_xxx;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_equip_avail_xxx';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
        
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
