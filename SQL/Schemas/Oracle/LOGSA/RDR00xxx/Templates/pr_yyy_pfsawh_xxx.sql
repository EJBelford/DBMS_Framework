/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_yyy_pfsawh_xxx
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_yyy_pfsawh_xxx.sql 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--      SP Parameters: 
--              Input: 
-- 
--             Output:   
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Testing Scripts 

/* 

BEGIN 

    pr_yyy_pfsawh_xxx ('GBelford'); 

END; 

*/ 

CREATE OR REPLACE PROCEDURE pr_yyy_pfsawh_xxx    
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

-- Exception handling variables (ps_) 

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'pr_yyy_pfsawh_xxx';  /*  */
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

    proc0.process_RecId      := 0; 
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
        
    proc1.process_RecId      := 000; 
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
        
    COMMIT;     
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := nvl(type_maintenance, 'TBD');

-- Housekeeping for the MAIN process 
  
    ps_location := 'PFSAWH 00';            -- For std_pfsawh_debug_tbl logging. 

    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_status      := 'BEGAN';
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_compl       := null;

-- get the run criteria from the pfsa_processes table for the last run of this 
-- MAIN process 
  
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
      
-- Call the MERGE PBA REF routine.  

    ps_location := 'PFSAWH 10';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'PFSA_SN_EI'; 
  
-- Get the run criteria from the PFSA_PROCESSES table for the last run of 
-- the SUB process 
  
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

-- Update the pfsa_processes table to indicate MAIN process has started.   

    ps_location := 'PFSAWH 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- Update the pfsa_processes table to indicate the sub-process has started.  

    ps_location := 'PFSAWH 30';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 

    ps_location := 'PFSAWH 40';            -- For std_pfsawh_debug_tbl logging.

    DELETE pfsa_sn_ei_tmp; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    ps_location := 'PFSAWH 44';            -- For std_pfsawh_debug_tbl logging.

    INSERT 
    INTO   pfsa_sn_ei_tmp 
        (
        sys_ei_niin,
        sys_ei_sn,
        sn_item_state,
        ready_state,
        sys_ei_state,
        possessor,
        sensored_item,
        owning_org,
        sys_ei_uid,
        physical_item_id,
        physical_item_sn_id,
        mimosa_item_sn_id,
        as_of_date,
        status, lst_updt, updt_by,
        active_flag, active_date, inactive_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by
        )
    SELECT
        sys_ei_niin,
        sys_ei_sn,
        sn_item_state,
        ready_state,
        sys_ei_state,
        possessor,
        sensored_item,
        owning_org,
        sys_ei_uid,
        physical_item_id,
        physical_item_sn_id,
        mimosa_item_sn_id,
        as_of_date,
        status, lst_updt, updt_by,
        active_flag, active_date, inactive_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by
    FROM   pfsa_sn_ei@pfsaw.lidb
    /*WHERE lst_updt > v_etl_copy_cutoff */ ; -- Add back in next release 
  
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    UPDATE pfsa_sn_ei_tmp sn 
    SET    physical_item_id    = fn_pfsawh_get_item_dim_id(sn.sys_ei_niin), 
           physical_item_sn_id = fn_pfsawh_get_item_sn_dim_id(sn.sys_ei_niin, sn.sys_ei_sn), 
           mimosa_item_sn_id   = LPAD(LTRIM(TO_CHAR(fn_pfsawh_get_item_sn_dim_id(sn.sys_ei_niin, sn.sys_ei_sn) , 'XXXXXXX')), 8, '0');
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    ps_location := 'PFSAWH 46';            -- For std_pfsawh_debug_tbl logging.

    MERGE  
    INTO   pfsa_sn_ei ppr 
    USING  (SELECT 
            sys_ei_niin,
            sys_ei_sn,
            sn_item_state,
            ready_state,
            sys_ei_state,
            possessor,
            sensored_item,
            owning_org,
            sys_ei_uid,
            physical_item_id,
            physical_item_sn_id,
            mimosa_item_sn_id,
            as_of_date,
            status, lst_updt, updt_by,
            active_flag, active_date, inactive_date,
            insert_by, insert_date,
            update_by, update_date,
            delete_flag, delete_date, delete_by,
            hidden_flag, hidden_date, hidden_by
            FROM   pfsa_sn_ei_tmp ) tmp 
    ON     (ppr.sys_ei_niin = tmp.sys_ei_niin
            AND ppr.sys_ei_sn = tmp.sys_ei_sn)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.sys_ei_niin           = tmp.sys_ei_niin,            
--            ppr.sys_ei_sn             = tmp.sys_ei_sn,            
            ppr.sn_item_state       = tmp.sn_item_state,
            ppr.ready_state         = tmp.ready_state,
            ppr.sys_ei_state        = tmp.sys_ei_state,
            ppr.possessor           = tmp.possessor,
            ppr.sensored_item       = tmp.sensored_item,
            ppr.owning_org          = tmp.owning_org,
            ppr.sys_ei_uid          = tmp.sys_ei_uid,
            ppr.physical_item_id    = tmp.physical_item_id,
            ppr.physical_item_sn_id = tmp.physical_item_sn_id,
            ppr.mimosa_item_sn_id   = tmp.mimosa_item_sn_id,
            ppr.as_of_date          = tmp.as_of_date,
            
            ppr.status = tmp.status, 
            ppr.updt_by = tmp.updt_by, 
            ppr.lst_updt = tmp.lst_updt,
            ppr.active_flag = tmp.active_flag, 
            ppr.active_date = tmp.active_date, 
            ppr.inactive_date = tmp.inactive_date,
            ppr.insert_by = tmp.insert_by, 
            ppr.insert_date = tmp.insert_date, 
            ppr.update_by = tmp.update_by, 
            ppr.update_date = tmp.update_date,
            ppr.delete_flag = tmp.delete_flag, 
            ppr.delete_date = tmp.delete_date, 
            ppr.hidden_flag = tmp.hidden_flag, 
            ppr.hidden_date = tmp.hidden_date
    WHEN NOT MATCHED THEN 
        INSERT (
                sys_ei_niin,
                sys_ei_sn,
                sn_item_state,
                ready_state,
                sys_ei_state,
                possessor,
                sensored_item,
                owning_org,
                sys_ei_uid,
                physical_item_id,
                physical_item_sn_id,
                mimosa_item_sn_id,
                as_of_date,
                status, lst_updt, updt_by,
                active_flag, active_date, inactive_date,
                insert_by, insert_date,
                update_by, update_date,
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by
                )
        VALUES (
                tmp.sys_ei_niin,
                tmp.sys_ei_sn,
                tmp.sn_item_state,
                tmp.ready_state,
                tmp.sys_ei_state,
                tmp.possessor,
                tmp.sensored_item,
                tmp.owning_org,
                tmp.sys_ei_uid,
                tmp.physical_item_id,
                tmp.physical_item_sn_id,
                tmp.mimosa_item_sn_id,
                tmp.as_of_date,
                tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.delete_by,
                tmp.hidden_flag, tmp.hidden_date, tmp.hidden_by
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;            

    ps_location := 'PFSAWH 48';            -- For std_pfsawh_debug_tbl logging.

    DELETE pfsa_sn_ei_tmp; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := 'PFSAWH 49';            -- For std_pfsawh_debug_tbl logging.

    l_now_is := sysdate; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
    ps_location := 'PFSAWH 50';            -- For std_pfsawh_debug_tbl logging.

-- update the pfsa_process table to indicate STATUS of MAINTAIN_PFSA_DATES 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    ps_location := 'PFSAWH 60';            -- For std_pfsawh_debug_tbl logging.

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

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 500; 
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
        
    ps_location := 'PFSAWH 70';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'PFSA_SUPPLY_ILAP'; 
  
-- Get the run criteria for the PFSA_SUPPLY_ILAP from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of PFSA_SUPPLY_ILAP.  

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
 
    DELETE pfsa_supply_ilap_tmp; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
--    SELECT * FROM pfsa_supply_ilap@pfsaw.lidb; 


    INSERT 
    INTO   pfsa_supply_ilap_tmp 
        (
        rec_id, docno, ric_stor, ipg, pniin, iss_niin,
        wh_period_date, wh_period_date_id, docno_uic, docno_force_unit_id,
        niin, pniin_item_id, physical_item_niin, physical_item_id,
        physical_item_sn, physical_item_sn_id, cwt, d_cust_iss,
        rcpt_docno, rcpt_dic, d_rcpt, rcpt_ric_fr, pseudo,
        sof, price, cat_sos, sc, scmc, ami,
        dlr, msc_spt, instl, corps, macom, d_upd,
        ssfcoc_flag, component, d_docno, d_sarss1, d_sarss2b,
        age_doc_s1, age_s1_s2b, fund, conus, qty,
        ext_price, prj, d_iss_month, iss_mon, dodaac,
        age_s1_iss, sfx, status, updt_by, lst_updt,
        grab_stamp, proc_stamp, active_flag, active_date,
        inactive_date, source_rec_id, insert_by, insert_date,
        lst_update_rec_id, update_by, update_date,
        delete_flag, delete_date, hidden_flag, hidden_date
        )
    SELECT 
        rec_id, docno, ric_stor, ipg, pniin, iss_niin,
        wh_period_date, wh_period_date_id, docno_uic, docno_force_unit_id,
        niin, pniin_item_id, physical_item_niin, physical_item_id,
        physical_item_sn, physical_item_sn_id, cwt, d_cust_iss,
        rcpt_docno, rcpt_dic, d_rcpt, rcpt_ric_fr, pseudo,
        sof, price, cat_sos, sc, scmc, ami,
        dlr, msc_spt, instl, corps, macom, d_upd,
        ssfcoc_flag, component, d_docno, d_sarss1, d_sarss2b,
        age_doc_s1, age_s1_s2b, fund, conus, qty,
        ext_price, prj, d_iss_month, iss_mon, dodaac,
        age_s1_iss, sfx, status, updt_by, lst_updt,
        grab_stamp, proc_stamp, active_flag, active_date,
        inactive_date, source_rec_id, insert_by, insert_date,
        lst_update_rec_id, update_by, update_date,
        delete_flag, delete_date, hidden_flag, hidden_date
    FROM   pfsa_supply_ilap@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff; 
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    MERGE  
    INTO   pfsa_supply_ilap psi 
    USING  (SELECT 
                rec_id, docno, ric_stor, ipg, pniin, iss_niin,
                wh_period_date, wh_period_date_id, docno_uic, 
                docno_force_unit_id, niin, pniin_item_id, 
                physical_item_niin, physical_item_id,
                physical_item_sn, physical_item_sn_id, cwt, d_cust_iss,
                rcpt_docno, rcpt_dic, d_rcpt, rcpt_ric_fr, pseudo,
                sof, price, cat_sos, sc, scmc, ami,
                dlr, msc_spt, instl, corps, macom, d_upd,
                ssfcoc_flag, component, d_docno, d_sarss1, d_sarss2b,
                age_doc_s1, age_s1_s2b, fund, conus, qty,
                ext_price, prj, d_iss_month, iss_mon, dodaac,
                age_s1_iss, sfx, status, updt_by, lst_updt,
                grab_stamp, proc_stamp, active_flag, active_date,
                inactive_date, source_rec_id, insert_by, insert_date,
                lst_update_rec_id, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
            FROM   pfsa_supply_ilap_tmp ) tmp 
    ON     (psi.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.rec_id              = tmp.rec_id,            
            psi.docno = tmp.docno,
            psi.ric_stor = tmp.ric_stor,
            psi.ipg = tmp.ipg,
            psi.pniin = tmp.pniin,
            psi.iss_niin= tmp.iss_niin,
            psi.wh_period_date = tmp.wh_period_date,
            psi.wh_period_date_id = tmp.wh_period_date_id,
            psi.docno_uic = tmp.docno_uic,
            psi.docno_force_unit_id = tmp.docno_force_unit_id,
            psi.niin = tmp.niin,
            psi.pniin_item_id = tmp.pniin_item_id,
            psi.physical_item_niin = tmp.physical_item_niin,
            psi.physical_item_id= tmp.physical_item_id,
            psi.physical_item_sn = tmp.physical_item_sn,
            psi.physical_item_sn_id = tmp.physical_item_sn_id,
            psi.cwt = tmp.cwt,
            psi.d_cust_iss= tmp.d_cust_iss,
            psi.rcpt_docno = tmp.rcpt_docno,
            psi.rcpt_dic = tmp.rcpt_dic,
            psi.d_rcpt = tmp.d_rcpt,
            psi.rcpt_ric_fr = tmp.rcpt_ric_fr,
            psi.pseudo= tmp.pseudo,
            psi.sof = tmp.sof,
            psi.price = tmp.price,
            psi.cat_sos = tmp.cat_sos,
            psi.sc = tmp.sc,
            psi.scmc = tmp.scmc,
            psi.ami= tmp.ami,
            psi.dlr = tmp.dlr,
            psi.msc_spt = tmp.msc_spt,
            psi.instl = tmp.instl,
            psi.corps = tmp.corps,
            psi.macom = tmp.macom,
            psi.d_upd= tmp.d_upd,
            psi.ssfcoc_flag = tmp.ssfcoc_flag,
            psi.component = tmp.component,
            psi.d_docno = tmp.d_docno,
            psi.d_sarss1 = tmp.d_sarss1,
            psi.d_sarss2b= tmp.d_sarss2b,
            psi.age_doc_s1 = tmp.age_doc_s1,
            psi.age_s1_s2b = tmp.age_s1_s2b,
            psi.fund = tmp.fund,
            psi.conus = tmp.conus,
            psi.qty= tmp.qty,
            psi.ext_price = tmp.ext_price,
            psi.prj = tmp.prj,
            psi.d_iss_month = tmp.d_iss_month,
            psi.iss_mon = tmp.iss_mon,
            psi.dodaac= tmp.dodaac,
            psi.age_s1_iss = tmp.age_s1_iss,
            psi.sfx = tmp.sfx,
            psi.status = tmp.status,
            psi.updt_by = tmp.updt_by,
            psi.lst_updt= tmp.lst_updt,
            psi.grab_stamp = tmp.grab_stamp,
            psi.proc_stamp = tmp.proc_stamp,
            psi.active_flag = tmp.active_flag,
            psi.active_date= tmp.active_date,
            psi.inactive_date = tmp.inactive_date,
            psi.source_rec_id = tmp.source_rec_id,
            psi.insert_by = tmp.insert_by,
            psi.insert_date= tmp.insert_date,
            psi.lst_update_rec_id = tmp.lst_update_rec_id,
            psi.update_by = tmp.update_by,
            psi.update_date= tmp.update_date,
            psi.delete_flag = tmp.delete_flag,
            psi.delete_date = tmp.delete_date,
            psi.hidden_flag = tmp.hidden_flag,
            psi.hidden_date = tmp.hidden_date
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id, docno, ric_stor, ipg, pniin, iss_niin,
                wh_period_date, wh_period_date_id, docno_uic, 
                docno_force_unit_id, niin, pniin_item_id, 
                physical_item_niin, physical_item_id,
                physical_item_sn, physical_item_sn_id, cwt, d_cust_iss,
                rcpt_docno, rcpt_dic, d_rcpt, rcpt_ric_fr, pseudo,
                sof, price, cat_sos, sc, scmc, ami,
                dlr, msc_spt, instl, corps, macom, d_upd,
                ssfcoc_flag, component, d_docno, d_sarss1, d_sarss2b,
                age_doc_s1, age_s1_s2b, fund, conus, qty,
                ext_price, prj, d_iss_month, iss_mon, dodaac,
                age_s1_iss, sfx, status, updt_by, lst_updt,
                grab_stamp, proc_stamp, active_flag, active_date,
                inactive_date, source_rec_id, insert_by, insert_date,
                lst_update_rec_id, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date 
                )
        VALUES (
                tmp.rec_id, tmp.docno, tmp.ric_stor, tmp.ipg, tmp.pniin, tmp.iss_niin,
                tmp.wh_period_date, tmp.wh_period_date_id, tmp.docno_uic, 
                tmp.docno_force_unit_id, tmp.niin, tmp.pniin_item_id, 
                tmp.physical_item_niin, tmp.physical_item_id,
                tmp.physical_item_sn, tmp.physical_item_sn_id, tmp.cwt, tmp.d_cust_iss,
                tmp.rcpt_docno, tmp.rcpt_dic, tmp.d_rcpt, tmp.rcpt_ric_fr, tmp.pseudo,
                tmp.sof, tmp.price, tmp.cat_sos, tmp.sc, tmp.scmc, tmp.ami,
                tmp.dlr, tmp.msc_spt, tmp.instl, tmp.corps, tmp.macom, tmp.d_upd,
                tmp.ssfcoc_flag, tmp.component, tmp.d_docno, tmp.d_sarss1, tmp.d_sarss2b,
                tmp.age_doc_s1, tmp.age_s1_s2b, tmp.fund, tmp.conus, tmp.qty,
                tmp.ext_price, tmp.prj, tmp.d_iss_month, tmp.iss_mon, tmp.dodaac,
                tmp.age_s1_iss, tmp.sfx, tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.grab_stamp, tmp.proc_stamp, tmp.active_flag, tmp.active_date,
                tmp.inactive_date, tmp.source_rec_id, tmp.insert_by, tmp.insert_date,
                tmp.lst_update_rec_id, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;            

    ps_location := 'PFSAWH 73';            -- For std_pfsawh_debug_tbl logging.

    DELETE pfsa_supply_ilap_tmp; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
--  Set the warehouse period 

    UPDATE pfsa_supply_ilap psi
    SET    (wh_period_date, wh_period_date_id) = 
           (
           SELECT ready_date, date_dim_id 
           FROM   pfsawh_ready_date_dim 
           WHERE  psi.d_cust_iss = oracle_date 
           ); 
           
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 

    COMMIT;        
    
--  Set the force_unit_id 

    UPDATE pfsa_supply_ilap psi 
    SET    docno_force_unit_id = 
        (
        SELECT 
        DISTINCT NVL(force_unit_id, 0) 
        FROM   pfsawh_force_unit_dim pfui
        WHERE  psi.docno_uic = pfui.uic 
        );   
                 
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 

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

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                               Populate fact                                */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 500; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 25;
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
        
    ps_location := 'PFSAWH 75';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE pfsawh_supply_ilap_p_fact; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT;

    INSERT 
    INTO pfsawh_supply_ilap_p_fact 
        (
--        docno,
--        ric_stor,
--        ipg,
        pniin,
        iss_niin,
        docno_uic,
        docno_force_unit_id,
        niin,
        pniin_item_id,
        physical_item_niin,
        physical_item_id,
        physical_item_sn,
        physical_item_sn_id,
--        d_cust_iss,           
        wh_period_date,
        wh_period_date_id,
        qty,
        dodaac,
        d_docno,
        d_sarss1,
--        cwt,  
        cwt_cnt, 
        cwt_min, 
        cwt_max, 
        cwt_sum, 
        cwt_avg, 
        cwt_mean, 
        cwt_50, 
        cwt_85 
--        rcpt_docno,
--        rcpt_dic,
--        d_rcpt,
--        rcpt_ric_fr,
--        pseudo,
--        sof,
--        price,
--        cat_sos,
--        sc,
--        scmc,
--        ami,
--        dlr,
--        msc_spt,
--        instl,
--        corps,
--        macom,
--        d_upd,
--        ssfcoc_flag,
--        component,
--        d_docno,
--        d_sarss1,
--        d_sarss2b,
--        age_doc_s1,
--        age_s1_s2b,
--        fund,
--        conus,
--        ext_price,
--        prj,
--        d_iss_month,
--        iss_mon,
--        age_s1_iss,
--        sfx 
        ) 
    SELECT 
--        bpsi.docno,
--        bpsi.ric_stor,
--        bpsi.ipg,
        bpsi.pniin,
        bpsi.iss_niin,
        NVL(bpsi.docno_uic, '000000'),
        bpsi.docno_force_unit_id,
        bpsi.niin,
        bpsi.pniin_item_id,
        bpsi.physical_item_niin,
        bpsi.physical_item_id,
        bpsi.physical_item_sn,
        bpsi.physical_item_sn_id,
--        bpsi.d_cust_iss,          
        bpsi.wh_period_date,
        bpsi.wh_period_date_id,
        SUM(bpsi.qty),
        bpsi.dodaac,
        bpsi.d_docno,
        bpsi.d_sarss1,
--        SUM(bpsi.cwt), 
        COUNT(bpsi.cwt), 
        MIN(bpsi.cwt), 
        MAX(bpsi.cwt), 
        SUM(bpsi.cwt), 
        TO_CHAR(ROUND(SUM(bpsi.cwt)/COUNT(bpsi.cwt), 1), '99999.9'), 
        TO_CHAR(-1, '99999.9'), 
        TO_CHAR(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY bpsi.cwt), '99999.9'), 
        TO_CHAR(PERCENTILE_CONT(0.85) WITHIN GROUP (ORDER BY cwt), '99999.9')  
--        bpsi.rcpt_docno,
--        bpsi.rcpt_dic,
--        bpsi.d_rcpt,
--        bpsi.rcpt_ric_fr,
--        bpsi.pseudo,
--        bpsi.sof,
--        bpsi.price,
--        bpsi.cat_sos,
--        bpsi.sc,
--        bpsi.scmc,
--        bpsi.ami,
--        bpsi.dlr,
--        bpsi.msc_spt,
--        bpsi.instl,
--        bpsi.corps,
--        bpsi.macom,
--        bpsi.d_upd,
--        bpsi.ssfcoc_flag,
--        bpsi.component,
--        bpsi.d_sarss2b,
--        bpsi.age_doc_s1,
--        age_s1_s2b,
--        bpsi.fund,
--        bpsi.conus,
--        bpsi.ext_price,
--        bpsi.prj,
--        bpsi.d_iss_month,
--        bpsi.iss_mon,
--        bpsi.age_s1_iss,
--        bpsi.sfx  
    FROM pfsa_supply_ilap bpsi
    GROUP BY bpsi.pniin,
        bpsi.iss_niin,
        bpsi.docno_uic,
        bpsi.docno_force_unit_id,
        bpsi.niin,
        bpsi.pniin_item_id,
        bpsi.physical_item_niin,
        bpsi.physical_item_id,
        bpsi.physical_item_sn,
        bpsi.physical_item_sn_id,
--        bpsi.d_cust_iss,           
        bpsi.wh_period_date,
        bpsi.wh_period_date_id,  
        bpsi.dodaac,
        bpsi.d_docno,
        bpsi.d_sarss1; 
        
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT;     
        
--    SELECT niin, fn_pfsawh_get_item_dim_id(niin) 
--    FROM   pfsawh_supply_ilap_p_fact; 

    UPDATE pfsawh_supply_ilap_p_fact 
    SET    pniin_item_id = fn_pfsawh_get_item_dim_id(niin) 
    WHERE  pniin_item_id = '0'; 

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
  
-- Update the status of the sub-process PFSA_SUPPLY_ILAP. 

    updt_pfsawh_processes
      (
      ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
      ps_this_process.who_ran, ls_current_process.last_run_status, 
      l_now_is, ls_current_process.last_run_compl
      ); 
          
    COMMIT;
  
/*----------------------------------------------------------------------------*/  

-- Update the pfsa_process table to indicate MAIN process has ended.  

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


