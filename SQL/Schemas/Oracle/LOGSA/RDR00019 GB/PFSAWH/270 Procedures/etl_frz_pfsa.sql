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

/* 

BEGIN 

    etl_frz_pfsa ('GBelford'); 
    
    COMMIT; 

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_frz_pfsa    
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_FRZ_PFSA';  /*  */
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

-- add  by lmj 10/10/08 variables to manaage truncation and index control --

myrowcount                 NUMBER;
mytablename                VARCHAR2(32);

BEGIN 

-- Get the process control values from PFSAWH_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
    v_t_fact_cutoff_days   := fn_pfsawh_get_prcss_cntrl_val('v_t_fact_cutoff_days'); 
    v_p_fact_cutoff_months := fn_pfsawh_get_prcss_cntrl_val('v_p_fact_cutoff_months');  

-- Limit the data pull from LIDB.PFSAW to x number of days. 
-- This need to be table direct in the future.   

    v_etl_copy_cutoff    := SYSDATE - v_etl_copy_cutoff_days; 
    v_t_fact_cutoff      := SYSDATE - v_t_fact_cutoff_days; 
--    v_etl_copy_cutoff    := SYSDATE - 250; 
--    v_t_fact_cutoff      := SYSDATE - 100; 
    v_t_fact_cutoff_id   := fn_date_to_date_id(v_t_fact_cutoff); 
    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  (-1 * v_p_fact_cutoff_months)); 
--    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  -42); 
    v_p_fact_cutoff_id   := fn_date_to_date_id(v_p_fact_cutoff); 

    proc0.process_RecId      := 700; 
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
        
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
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

---- Call the MERGE PBA REF routine.  

    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging.

--    ls_current_process.pfsa_process := 'PFSA_SN_EI'; 
--  
---- Get the run criteria from the PFSA_PROCESSES table for the last run of 
---- the MAINTAIN_PFSA_DATES process 
--  
--    get_pfsawh_process_info
--        (
--        ps_procedure_name, ls_current_process.pfsa_process, 
--        ls_current_process.last_run, ls_current_process.who_ran, 
--        ls_current_process.last_run_status, 
--        ls_current_process.last_run_status_time, 
--        ls_current_process.last_run_compl
--        );

--    ls_start                             := sysdate;
--    ls_current_process.last_run          := ls_start;
--    ls_current_process.last_run_status   := 'BEGAN';
--    ls_current_process.who_ran           := ps_id_key;
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_status      := ps_location;

---- Update the pfsa_processes table to indicate MAIN process location.  

    ps_location := 'PFSA 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

---- Update the pfsa_processes table to indicate the sub-process 
---- MERGE PBA REF has started.  

    ps_location := 'PFSA 30';            -- For std_pfsawh_debug_tbl logging.

--    updt_pfsawh_processes
--        (
--        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
--        ps_this_process.who_ran, ls_current_process.last_run_status, 
--        l_now_is, ls_current_process.last_run_compl
--        );

--    COMMIT;
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 


/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
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
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_SUPPLY_ILAP'; 
  
-- Get the run criteria for the FRZ_PFSA_SUPPLY_ILAP from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZ_PFSA_SUPPLY_ILAP.  

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
    FROM   frz_pfsa_supply_ilap_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_supply_ilap_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   frz_pfsa_supply_ilap_tmp 
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
        grab_stamp, proc_stamp, 
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date, 
        source_rec_id, insert_by, insert_date,
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
        grab_stamp, proc_stamp, 
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        source_rec_id, insert_by, insert_date,
        lst_update_rec_id, update_by, update_date,
        delete_flag, delete_date, hidden_flag, hidden_date
    FROM   frz_pfsa_supply_ilap@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff 
        AND delete_flag = 'N'; 
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    MERGE  
    INTO   frz_pfsa_supply_ilap psi 
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
                grab_stamp, proc_stamp, 
                active_flag, active_date, inactive_date, 
                frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
                source_rec_id, insert_by, insert_date,
                lst_update_rec_id, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
            FROM   frz_pfsa_supply_ilap_tmp ) tmp 
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
            psi.active_date = tmp.active_date, 
            psi.inactive_date = tmp.inactive_date, 
            psi.frz_input_date = tmp.frz_input_date, 
            psi.frz_input_date_id = tmp.frz_input_date_id, 
            psi.rec_frz_flag = tmp.rec_frz_flag, 
            psi.frz_date = tmp.frz_date,
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
                grab_stamp, proc_stamp, 
                active_flag, active_date, inactive_date, 
                frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
                source_rec_id, insert_by, insert_date,
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
                tmp.grab_stamp, tmp.proc_stamp, 
                tmp.active_flag, tmp.active_date, tmp.inactive_date, 
                tmp.frz_input_date, tmp.frz_input_date_id, tmp.rec_frz_flag, tmp.frz_date,
                tmp.source_rec_id, tmp.insert_by, tmp.insert_date,
                tmp.lst_update_rec_id, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

--  Set the warehouse period 

    UPDATE frz_pfsa_supply_ilap psi
    SET    (wh_period_date, wh_period_date_id) = 
           (
           SELECT ready_date, date_dim_id 
           FROM   pfsawh_ready_date_dim 
           WHERE  psi.d_cust_iss = oracle_date 
           ); 
           
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--  Set the force_unit_id 

    UPDATE frz_pfsa_supply_ilap psi 
    SET    docno_force_unit_id = 
        (
        SELECT 
        DISTINCT NVL(force_unit_id, 0) 
        FROM   pfsawh_force_unit_dim pfui
        WHERE  psi.docno_uic = pfui.uic 
        );   
                 
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_supply_ilap_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_supply_ilap_tmp';
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
      
    proc1.process_RecId      := 700; 
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
        
    ps_location := 'PFSA 75';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE  pfsawh_supply_ilap_p_fact  
    WHERE   insert_date < v_t_fact_cutoff
        AND etl_processed_by = ps_procedure_name;
        
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT;

    INSERT 
    INTO pfsawh_supply_ilap_p_fact 
        (
--        docno,
--        ric_stor,
--        ipg,
        pba_id, 
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
        cwt_85,  
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
--        sfx, 
          etl_processed_by 
        ) 
    SELECT 
--        bpsi.docno,
--        bpsi.ric_stor,
--        bpsi.ipg, 
        bpsi.pba_id, 
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
        TO_CHAR(PERCENTILE_CONT(0.85) WITHIN GROUP (ORDER BY cwt), '99999.9'),   
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
--        bpsi.sfx, 
          ps_procedure_name  
    FROM frz_pfsa_supply_ilap bpsi
    GROUP BY bpsi.pba_id, 
        bpsi.pniin,
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

    UPDATE  pfsawh_supply_ilap_p_fact 
    SET     pniin_item_id = fn_pfsawh_get_item_dim_id(niin) 
    WHERE   pniin_item_id = '0'
        AND etl_processed_by = ps_procedure_name; 

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

    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process FRZ_PFSA_SUPPLY_ILAP. 

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
      
    proc1.process_RecId      := 700; 
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
        
    ps_location := 'PFSA 80';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_USAGE_EVENT'; 
  
-- Get the run criteria for the FRZ_PFSA_USAGE_EVENT from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZ_PFSA_USAGE_EVENT 

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
    FROM   frz_pfsa_usage_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_usage_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   frz_pfsa_usage_event_tmp
        (
        rec_id, source_rec_id, pba_id, 
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag, physical_item_id, 
        physical_item_sn_id, frz_input_date, 
        frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by
        )
    SELECT 
        rec_id, source_rec_id, pba_id, 
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag, physical_item_id, 
        physical_item_sn_id, frz_input_date, 
        frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by
    FROM   frz_pfsa_usage_event@pfsaw.lidb
    WHERE  delete_flag = 'N' 
        AND from_dt > v_etl_copy_cutoff;
 
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    MERGE   
    INTO frz_pfsa_usage_event a 
    USING ( 
        SELECT
        rec_id, source_rec_id, pba_id, 
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
        frz_input_date_id, rec_frz_flag, frz_date,
        insert_by,
        insert_date, update_by, update_date, delete_flag, delete_date,
        hidden_flag, hidden_date, delete_by, hidden_by  
        FROM frz_pfsa_usage_event_tmp) b
    ON (a.sys_ei_niin = b.sys_ei_niin 
        and a.pfsa_item_id = b.pfsa_item_id 
        and a.record_type = b.record_type 
        and a.usage_mb = b.usage_mb 
        and a.from_dt = b.from_dt
        and a.pba_id = b.pba_id
        )
    WHEN NOT MATCHED THEN 
    INSERT 
        (
        rec_id, source_rec_id, pba_id, 
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag, physical_item_id, 
        physical_item_sn_id, frz_input_date, 
        frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by
        )
    VALUES 
        (
        b.rec_id, b.source_rec_id, b.pba_id, 
        b.sys_ei_niin, b.pfsa_item_id, b.record_type, b.usage_mb, b.from_dt, 
        b.usage, b.type_usage, b.to_dt, b.usage_date, b.ready_date, 
        b.day_date, b.month_date, b.pfsa_org, b.uic, b.sys_ei_sn, 
        b.item_days, b.data_src, b.genind, b.lst_updt, b.updt_by, 
        b.status, b.reading, b.reported_usage, b.actual_mb, b.actual_reading, 
        b.actual_usage, b.actual_data_rec_flag, b.physical_item_id, 
        b.physical_item_sn_id, b.frz_input_date, 
        b.frz_input_date_id, b.rec_frz_flag, b.frz_date, 
        b.insert_by, 
        b.insert_date, b.update_by, b.update_date, b.delete_flag, b.delete_date, 
        b.hidden_flag, b.hidden_date, b.delete_by, b.hidden_by
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
        a.rec_frz_flag = b.rec_frz_flag, 
        a.frz_date = b.frz_date,
        a.insert_by = b.insert_by,
        a.insert_date = b.insert_date,
        a.update_by = b.update_by,
        a.update_date = b.update_date,
        a.delete_flag = b.delete_flag,
        a.delete_date = b.delete_date,
        a.hidden_flag = b.hidden_flag,
        a.hidden_date = b.hidden_date,
        a.delete_by = b.delete_by,
        a.hidden_by = b.hidden_by;

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
-- Set warehouse ids    

    ps_location := 'PFSA 84';            -- For std_pfsawh_debug_tbl logging. 
    
-- ITEM 

    UPDATE frz_pfsa_usage_event pue
    SET    physical_item_id = 
            (
            SELECT NVL(physical_item_id, 0)  
            FROM   pfsawh_item_dim 
            WHERE  niin = pue.sys_ei_niin
--                AND status = 'C'
            )  
    WHERE  pue.physical_item_id IS NULL
        OR pue.physical_item_id < 1; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- ITEM_SN  

    UPDATE frz_pfsa_usage_event pue
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

-- FORCE 

    UPDATE frz_pfsa_usage_event pue
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

-- LOCATION     

-- MIMOSA      

    UPDATE frz_pfsa_usage_event 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- FROM_DT_ID 

    UPDATE frz_pfsa_usage_event pue
    SET    from_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  ref.oracle_date = pue.from_dt 
                    )
    WHERE pue.from_dt_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- TO_DT_ID 

    UPDATE frz_pfsa_usage_event pue
    SET    to_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  TO_CHAR(to_dt, 'DD-MON-YYYY') = ref.oracle_date 
                    )
    WHERE pue.to_dt_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- Set MONTH_SEG_DATE_ID 

    UPDATE frz_pfsa_usage_event 
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

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_usage_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_usage_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
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
        
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 35;
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
        
    ps_location := 'PFSA 85';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE  pfsawh_item_sn_t_fact  
    WHERE   etl_processed_by = ps_procedure_name
        AND insert_date < v_t_fact_cutoff; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

-- Merge in the new facts within the cutoff window.  
    
    MERGE 
    INTO   pfsawh_item_sn_t_fact f 
    USING (
        SELECT frz_pfsa_usage_event.pba_id, 
            sys_ei_niin,
            pfsa_item_id,
            from_dt,
            to_dt,
            frz_pfsa_usage_event.force_unit_id, 
            usage,         
            usage_mb    
        FROM frz_pfsa_usage_event  
        WHERE from_dt >= v_t_fact_cutoff 
            ) pue 
        ON (f.date_id = fn_date_to_date_id(pue.from_dt) AND
            f.physical_item_id = fn_pfsawh_get_item_dim_id(pue.sys_ei_niin) AND
            f.physical_item_sn_id = fn_pfsawh_get_item_sn_dim_id(pue.sys_ei_niin, pfsa_item_id) AND 
            f.pba_id = pue.pba_id   
            AND f.etl_processed_by = ps_procedure_name     
            )
        WHEN MATCHED THEN
            UPDATE SET 
                item_usage_0      = pue.usage, 
                item_usage_type_0 = pue.usage_mb,  
                item_force_id     = pue.force_unit_id  
--                , etl_processed_by  = ps_procedure_name   
        WHEN NOT MATCHED THEN 
            INSERT (
                date_id,
                physical_item_id,
                physical_item_sn_id,
                item_date_from_id,
                item_time_from_id,
                item_date_to_id,
                item_time_to_id,
                mimosa_item_sn_id, 
                item_force_id, 
                pba_id,
                item_usage_0,
                item_usage_type_0,
                item_usage_1,
                item_usage_type_1,
                item_usage_2,
                item_usage_type_2, 
                notes 
                , etl_processed_by 
                )
            VALUES (
                fn_date_to_date_id(pue.from_dt),
                fn_pfsawh_get_item_dim_id(pue.sys_ei_niin),
                fn_pfsawh_get_item_sn_dim_id(pue.sys_ei_niin, pfsa_item_id),
                fn_date_to_date_id(pue.from_dt),
                fn_time_to_time_id(pue.from_dt),
                fn_date_to_date_id(pue.to_dt),
                fn_time_to_time_id(pue.to_dt),
                LPAD(LTRIM(TO_CHAR(fn_pfsawh_get_item_sn_dim_id(pue.sys_ei_niin, pfsa_item_id), 'XXXXXXX')), 8, '0'), 
                pue.force_unit_id, 
                pue.pba_id,
                pue.usage,
                pue.usage_mb,
                -1,
                '-1',
                -1,  
                '-1',
                ''  
                , ps_procedure_name 
                );

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;    

/*----- pfsawh_item_sn_p_fact -----*/     

    ps_location := 'PFSA 86';            -- For std_pfsawh_debug_tbl logging. 
    
-- Delete the fact that are beyond the cutoff.     
    
    DELETE pfsawh_item_sn_p_fact
    WHERE  insert_date < v_p_fact_cutoff
        AND etl_processed_by = ps_procedure_name; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

-- Insert the new facts within the cutoff window.  
    
    INSERT 
    INTO   pfsawh_item_sn_p_fact 
        (
        date_id, 
        physical_item_id, 
        physical_item_sn_id, 
        item_date_from_id, 
        item_date_to_id, 
        mimosa_item_sn_id, 
        item_force_id, 
        pba_id, 
        item_usage_type_0, 
        item_usage_0, 
        notes,
        etl_processed_by
        )
    SELECT tf.date_id, 
        tf.physical_item_id, 
        tf.physical_item_sn_id, 
        tf.item_date_from_id, 
        tf.item_date_to_id, 
        tf.mimosa_item_sn_id, 
        tf.item_force_id, 
        tf.pba_id, 
        tf.item_usage_type_0, 
        SUM(tf.item_usage_0), 
        '', 
        ps_procedure_name 
    FROM   pfsawh_item_sn_t_fact tf 
    WHERE  NOT EXISTS (
                     SELECT pf.rec_id 
                     FROM   pfsawh_item_sn_p_fact pf 
                     WHERE TO_CHAR(fn_date_id_to_date(tf.date_id), 'mon-yyyy') = TO_CHAR(fn_date_id_to_date(pf.date_id), 'mon-yyyy')
                        AND tf.physical_item_id = pf.physical_item_id 
                        AND tf.physical_item_sn_id = pf.physical_item_sn_id 
                        AND tf.pba_id = pf.pba_id 
                     )  
        AND tf.physical_item_id > 0 
        AND tf.physical_item_sn_id > 0 
        AND etl_processed_by = ps_procedure_name  
    GROUP BY tf.date_id, tf.physical_item_id, tf.physical_item_sn_id, 
        tf.item_usage_type_0, item_date_from_id, item_date_to_id,
        ps_procedure_name, tf.mimosa_item_sn_id, tf.item_force_id, 
        tf.pba_id; 
        
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT;     

-- Update the existing facts within the cutoff window.  
    
    ps_location := 'PFSA 87';            -- For std_pfsawh_debug_tbl logging. 
      
-- M - Miles 

    UPDATE pfsawh_item_sn_p_fact pf  
    SET     ( 
            item_usage_type_0, 
            item_usage_0 
            ) = (
                SELECT 
                --   tf.date_id, tf.physical_item_id, tf.physical_item_sn_id,
                   tf.item_usage_type_0, 
                   tf.item_usage_0 
                FROM pfsawh_item_sn_t_fact tf
                WHERE fn_date_id_to_date(tf.date_id) = fn_date_id_to_date(pf.date_id) 
                    AND tf.physical_item_id = pf.physical_item_id 
                    AND tf.physical_item_sn_id = pf.physical_item_sn_id
                    AND tf.pba_id = pf.pba_id 
                    AND tf.item_usage_type_0 = 'M'   
                )
    WHERE pba_id IN (1000006, 1000007);

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- H - Hours 

    UPDATE  pfsawh_item_sn_p_fact pf
    SET (
        item_usage_type_0, 
        item_usage_0 
        ) = (
            SELECT 
                tf.usage_mb, 
                SUM(tf.usage)
            FROM   frz_pfsa_usage_event tf 
            WHERE  tf.physical_item_id = pf.physical_item_id 
                AND tf.physical_item_sn_id = pf.physical_item_sn_id
                AND tf.month_seg_date_id = pf.date_id 
                AND tf.pba_id = pf.pba_id 
                AND tf.usage_mb = ('H')   
            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
            )
    WHERE pba_id IN (1000006, 1000007);  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;
    
-- F - Flight hours     

    UPDATE  pfsawh_item_sn_p_fact pf
    SET (
        item_usage_type_0, 
        item_usage_0 
        ) = (
            SELECT 
                tf.usage_mb, 
                SUM(tf.usage)
            FROM   frz_pfsa_usage_event tf 
            WHERE  tf.physical_item_id = pf.physical_item_id 
                AND tf.physical_item_sn_id = pf.physical_item_sn_id
                AND tf.month_seg_date_id = pf.date_id 
                AND tf.pba_id = pf.pba_id 
                AND tf.usage_mb = ('F')   
            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
            )
    WHERE pba_id IN (1000006, 1000007);  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;
    
-- L - Landings     

    UPDATE  pfsawh_item_sn_p_fact pf
    SET (
        item_usage_type_1, 
        item_usage_1 
        ) = (
            SELECT 
                tf.usage_mb, 
                SUM(tf.usage)
            FROM   frz_pfsa_usage_event tf 
            WHERE  tf.physical_item_id = pf.physical_item_id 
                AND tf.physical_item_sn_id = pf.physical_item_sn_id
                AND tf.month_seg_date_id = pf.date_id 
                AND tf.pba_id = pf.pba_id 
                AND tf.usage_mb = ('L')   
            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
            )
    WHERE pba_id IN (1000006, 1000007);  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
    
-- LA - Landing auto-ratation --    

    UPDATE  pfsawh_item_sn_p_fact pf
    SET (
        item_usage_type_2, 
        item_usage_2 
        ) = (
            SELECT 
                tf.usage_mb, 
                SUM(tf.usage)
            FROM   frz_pfsa_usage_event tf 
            WHERE  tf.physical_item_id = pf.physical_item_id 
                AND tf.physical_item_sn_id = pf.physical_item_sn_id
                AND tf.month_seg_date_id = pf.date_id 
                AND tf.pba_id = pf.pba_id 
                AND tf.usage_mb = ('LA')   
            GROUP BY tf.month_seg_date_id, tf.physical_item_sn_id, 
                tf.usage_mb, tf.pba_id --, tf.force_unit_id 
            )
    WHERE pba_id IN (1000006, 1000007);  

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
  
-- Update the status of the sub-process PPFSA_USAGE_EVENT. 

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
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 40;
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
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_EQUIP_AVAIL'; 
  
-- Get the run criteria for the FRZ_PFSA_EQUIP_AVAIL from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZ_PFSA_EQUIP_AVAIL. 

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
    FROM   frz_pfsa_equip_avail_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_equip_avail_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    ps_location := 'PFSA 94';            -- For std_pfsawh_debug_tbl logging. 
    
    INSERT 
    INTO   frz_pfsa_equip_avail_tmp 
        (
        rec_id,           source_rec_id,       pba_id, 
        physical_item_id, physical_item_sn_id,
        force_unit_id,    mimosa_item_sn_id,
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
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by,      insert_date,
        update_by,      update_date,
        delete_flag,    delete_date,       delete_by,
        hidden_flag,    hidden_date,       hidden_by
        )
    SELECT rec_id,        rec_id,       pba_id, 
        physical_item_id, physical_item_sn_id,
        force_unit_id,    mimosa_item_sn_id,
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
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by,      insert_date,
        update_by,      update_date,
        delete_flag,    delete_date,       delete_by,
        hidden_flag,    hidden_date,       hidden_by
    FROM   frz_pfsa_equip_avail@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff 
        AND delete_flag = 'N';

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 
    
    IF proc1.rec_inserted_int = 0 THEN
        INSERT 
        INTO   frz_pfsa_equip_avail_tmp 
            (
            rec_id,           source_rec_id,       pba_id, 
            physical_item_id, physical_item_sn_id,
            force_unit_id,    mimosa_item_sn_id,
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
        --    frz_input_date, frz_input_date_id, rec_frz_flag, frz_date, 
            insert_by,      insert_date,
            update_by,      update_date,
            delete_flag,    delete_date,       delete_by,
            hidden_flag,    hidden_date,       hidden_by
            )
        SELECT frz.rec_id,        frz.rec_id,       it.pba_id, 
            frz.physical_item_id, frz.physical_item_sn_id,
            frz.force_unit_id,    frz.mimosa_item_sn_id,
            frz.sys_ei_niin,      frz.pfsa_item_id,
            frz.record_type,      frz.from_dt,             frz.to_dt,
            frz.ready_date,       frz.day_date,            frz.month_date,
            frz.pfsa_org,         frz.sys_ei_sn,           frz.item_days,
            frz.period_hrs,
            frz.nmcm_hrs,       frz.nmcs_hrs,
            frz.nmc_hrs,        frz.fmc_hrs,           frz.pmc_hrs,        frz.mc_hrs,
            frz.nmcm_user_hrs,  frz.nmcm_int_hrs,      frz.nmcm_dep_hrs,
            frz.nmcs_user_hrs,  frz.nmcs_int_hrs,      frz.nmcs_dep_hrs,
            frz.pmcm_hrs,       frz.pmcs_hrs,
            frz.source_id,
            frz.pmcs_user_hrs,  frz.pmcs_int_hrs,      frz.pmcm_user_hrs,  frz.pmcm_int_hrs,
            frz.dep_hrs,
            frz.heir_id,        frz.priority,          frz.uic,
            frz.grab_stamp,     frz.proc_stamp,
            frz.sys_ei_uid,
            frz.status,         frz.lst_updt,          frz.updt_by,
        --    frz.frz_input_date, frz.frz_input_date_id, frz.rec_frz_flag, frz.frz_date, 
            frz.insert_by,      frz.insert_date,
            frz.update_by,      frz.update_date,
            frz.delete_flag,    frz.delete_date,       frz.delete_by,
            frz.hidden_flag,    frz.hidden_date,       frz.hidden_by
        FROM   pfsa_pba_items_ref it, 
               pfsa_equip_avail frz
        WHERE  it.pba_id = 1000006
            AND it.item_identifier_type_id = 14 
            AND it.item_type_value = frz.sys_ei_sn 
        ORDER BY it.item_type_value; 
        
        proc1.rec_load_int := NVL(proc1.rec_load_int, 0) + SQL%ROWCOUNT;

        COMMIT;    
    END IF;
 
    ps_location := 'PFSA 96';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   frz_pfsa_equip_avail pea 
    USING  (SELECT 
                rec_id,           source_rec_id,       pba_id, 
                physical_item_id, physical_item_sn_id,
                force_unit_id,    mimosa_item_sn_id,
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
                frz_input_date, frz_input_date_id, rec_frz_flag,   frz_date,
                insert_by,      insert_date,
                update_by,      update_date,
                delete_flag,    delete_date,       delete_by,
                hidden_flag,    hidden_date,       hidden_by
            FROM   frz_pfsa_equip_avail_tmp ) tmp 
--    ON     (pea.sys_ei_niin      = tmp.sys_ei_niin
--            AND pea.pfsa_item_id = tmp.pfsa_item_id 
--            AND pea.record_type  = tmp.record_type
--            AND pea.from_dt      = tmp.from_dt
--            AND pea.pba_id       = tmp.pba_id
--            )  
    ON     (pea.source_rec_id      = tmp.source_rec_id
           )  
    WHEN MATCHED THEN 
        UPDATE SET   
            pea.rec_id              = tmp.rec_id,            
--            pea.source_rec_id       = tmp.source_rec_id,        
--            pea.pba_id              = tmp.pba_id,  
            pea.physical_item_id    = tmp.physical_item_id,  
            pea.physical_item_sn_id = tmp.physical_item_sn_id, 
            pea.force_unit_id       = tmp.force_unit_id,     
            pea.mimosa_item_sn_id   = tmp.mimosa_item_sn_id, 
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
            pea.frz_input_date      = tmp.frz_input_date,  
            pea.frz_input_date_id   = tmp.frz_input_date_id,  
            pea.rec_frz_flag        = tmp.rec_frz_flag,   
            pea.frz_date            = tmp.frz_date, 
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
                pea.rec_id,           pea.source_rec_id,       pea.pba_id, 
                pea.physical_item_id, pea.physical_item_sn_id,
                pea.force_unit_id,    pea.mimosa_item_sn_id,
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
                pea.frz_input_date, pea.frz_input_date_id, pea.rec_frz_flag,   pea.frz_date,
                pea.insert_by,      pea.insert_date,
                pea.update_by,      pea.update_date,
                pea.delete_flag,    pea.delete_date,       pea.delete_by,
                pea.hidden_flag,    pea.hidden_date,       pea.hidden_by)
        VALUES (
                tmp.rec_id,           tmp.source_rec_id,       tmp.pba_id, 
                tmp.physical_item_id, tmp.physical_item_sn_id,
                tmp.force_unit_id,    tmp.mimosa_item_sn_id,
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
                tmp.frz_input_date, tmp.frz_input_date_id, tmp.rec_frz_flag,   tmp.frz_date,
                tmp.insert_by,      tmp.insert_date,
                tmp.update_by,      tmp.update_date,
                tmp.delete_flag,    tmp.delete_date,       tmp.delete_by,
                tmp.hidden_flag,    tmp.hidden_date,       tmp.hidden_by);

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
-- Set warehouse ids    

    ps_location := 'PFSA 98';            -- For std_pfsawh_debug_tbl logging. 
    
-- ITEM 

    UPDATE frz_pfsa_equip_avail pue
    SET    physical_item_id = 
            NVL((
            SELECT NVL(physical_item_id, 0)  
            FROM   pfsawh_item_dim 
            WHERE  niin = pue.sys_ei_niin
--                AND status = 'C'
            ), -1)  
    WHERE  pue.physical_item_id IS NULL
        OR pue.physical_item_id < 1; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- ITEM_SN  

    UPDATE frz_pfsa_equip_avail pue
    SET    physical_item_sn_id = 
            NVL((
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
                AND status = 'C'
            ), -1)  
    WHERE  pue.physical_item_sn_id IS NULL
        OR pue.physical_item_sn_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- FORCE 

    UPDATE frz_pfsa_equip_avail pue
    SET    force_unit_id = 
            NVL((
            SELECT force_unit_id  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = pue.uic 
                AND status = 'C'
            ), -1)
    WHERE  force_unit_id IS NULL 
        OR force_unit_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- LOCATION     

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- MIMOSA      

    UPDATE frz_pfsa_equip_avail 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- Ready Date      

    UPDATE frz_pfsa_equip_avail pue
    SET    ready_date_id = fn_date_to_date_id(pue.ready_date) 
    WHERE  ready_date_id IS NULL; 

    ps_location := 'PFSA 99';            -- For std_pfsawh_debug_tbl logging. 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_equip_avail_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_equip_avail_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    ps_location := 'PFSA 94';            -- For std_pfsawh_debug_tbl logging. 
    
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
  
-- Update the status of the sub-process FRZ_PFSA_EQUIP_AVAIL. 

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
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 50;
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
        
    ps_location := 'PFSA 100';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_MAINT_EVENT'; 
  
-- Get the run criteria for the FRZ_PFSA_MAINT_EVENT from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZPFSA_MAINT_EVENT. 

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
    FROM   frz_pfsa_maint_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    ps_location := 'PFSA 102';            -- For std_pfsawh_debug_tbl logging. 
    
    INSERT 
    INTO   frz_pfsa_maint_event_tmp 
        (
        rec_id, source_rec_id, pba_id, 
        maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
        maint_item, maint_item_niin, maint_item_sn, num_maint_item,
        sys_ei_niin, sys_ei_sn,
        num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
        dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
        phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
        source_id, status, lst_updt, updt_by,
        heir_id, priority, cust_org, cust_uic,
        fault_malfunction_descr, won, 
--        last_wo_status, last_wo_status_date,
        active_flag, active_date, inactive_date, 
        insert_by, insert_date,
        update_by, update_date, delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by, 
        frz_input_date, frz_input_date_id, 
        ridb_on_time_flag, report_date
--        , maint_event_id_part1, maint_event_id_part2 
        )
    SELECT rec_id, rec_id, pba_id, 
        maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
        maint_item, maint_item_niin, maint_item_sn, num_maint_item,
        sys_ei_niin, sys_ei_sn,
        num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
        dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
        phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
        source_id, status, lst_updt, updt_by,
        heir_id, priority, cust_org, cust_uic,
        fault_malfunction_descr, won, 
--        last_wo_status, last_wo_status_date,
        active_flag, active_date, inactive_date, 
        insert_by, insert_date,
        update_by, update_date, delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by, 
        frz_input_date, frz_input_date_id, 
        ridb_on_time_flag, report_date
--        , maint_event_id_part1, maint_event_id_part2  
    FROM   frz_pfsa_maint_event@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff 
        AND delete_flag = 'N'; 

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
--    COMMIT; 
    
    IF proc1.rec_inserted_int = 0 THEN
        INSERT 
        INTO   frz_pfsa_maint_event_tmp 
            (
            rec_id, source_rec_id, pba_id, 
            maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
            maint_item, maint_item_niin, maint_item_sn, num_maint_item,
            sys_ei_niin, sys_ei_sn,
            num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
            dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
            phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
            source_id, status, lst_updt, updt_by,
            heir_id, priority, cust_org, cust_uic,
            fault_malfunction_descr, won, 
        --        last_wo_status, last_wo_status_date,
            active_flag, active_date, inactive_date, 
            insert_by, insert_date,
            update_by, update_date, delete_flag, delete_date, delete_by,
            hidden_flag, hidden_date, hidden_by, 
            frz_input_date, frz_input_date_id, 
            ridb_on_time_flag, report_date
        --        , maint_event_id_part1, maint_event_id_part2 
            )
        SELECT 0, 0, /*frz.rec_id, frz.rec_id,*/ it.pba_id, 
            frz.maint_ev_id, frz.maint_org, frz.maint_uic, frz.maint_lvl_cd,
            frz.maint_item, frz.maint_item_niin, frz.maint_item_sn, frz.num_maint_item,
            frz.sys_ei_niin, frz.sys_ei_sn,
            frz.num_mi_nrts, frz.num_mi_rprd, frz.num_mi_cndmd, frz.num_mi_neof,
            frz.dt_maint_ev_est, frz.dt_maint_ev_cmpl, frz.sys_ei_nmcm, 
            frz.phase_ev, frz.sof_ev, frz.asam_ev, frz.mwo_ev, frz.elapsed_me_wk_tm,
            frz.source_id, frz.status, frz.lst_updt, frz.updt_by,
            frz.heir_id, frz.priority, frz.cust_org, frz.cust_uic,
            frz.fault_malfunction_descr, frz.won, 
        --        frz.last_wo_status, frz.last_wo_status_date,
            frz.active_flag, frz.active_date, frz.inactive_date, 
            frz.insert_by, frz.insert_date,
            frz.update_by, frz.update_date, frz.delete_flag, frz.delete_date, frz.delete_by,
            frz.hidden_flag, frz.hidden_date, frz.hidden_by, 
            frz.frz_input_date, frz.frz_input_date_id, 
            frz.ridb_on_time_flag, frz.report_date
        --        , frz.maint_event_id_part1, frz.maint_event_id_part2  
        FROM   pfsa_maint_event frz, 
               pfsa_pba_items_ref it  
        WHERE  it.pba_id = 1000006
            AND it.item_identifier_type_id = 14 
            AND it.item_type_value = frz.maint_item_sn
        ORDER BY it.item_type_value; 
        
        proc1.rec_load_int := NVL(proc1.rec_load_int, 0) + SQL%ROWCOUNT;

        COMMIT;    
    END IF;
 
    ps_location := 'PFSA 104';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   frz_pfsa_maint_event psi 
    USING  (SELECT 
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
                maint_item, maint_item_niin, maint_item_sn, num_maint_item,
                sys_ei_niin, sys_ei_sn,
                num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
                dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
                phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
                source_id, status, lst_updt, updt_by,
                heir_id, priority, cust_org, cust_uic,
                fault_malfunction_descr, won, 
--                last_wo_status, last_wo_status_date,
                active_flag, active_date, inactive_date, 
                insert_by, insert_date,
                update_by, update_date, delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id, 
                ridb_on_time_flag, report_date
--                , maint_event_id_part1, maint_event_id_part2
            FROM   frz_pfsa_maint_event_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
            AND psi.pba_id = tmp.pba_id
            )  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id              = tmp.maint_ev_id,    
            psi.rec_id = tmp.rec_id, 
            psi.source_rec_id = tmp.source_rec_id, 
--            psi.pba_id = tmp.pba_id,         
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
--            psi.last_wo_status = tmp.last_wo_status, 
--            psi.last_wo_status_date = tmp.last_wo_status_date,
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
            psi.report_date = tmp.report_date --, 
--            psi.maint_event_id_part1 = tmp.maint_event_id_part1, 
--            psi.maint_event_id_part2 = tmp.maint_event_id_part2
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_org, maint_uic, maint_lvl_cd,
                maint_item, maint_item_niin, maint_item_sn, num_maint_item,
                sys_ei_niin, sys_ei_sn,
                num_mi_nrts, num_mi_rprd, num_mi_cndmd, num_mi_neof,
                dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm, 
                phase_ev, sof_ev, asam_ev, mwo_ev, elapsed_me_wk_tm,
                source_id, status, lst_updt, updt_by,
                heir_id, priority, cust_org, cust_uic,
                fault_malfunction_descr, won, 
--                last_wo_status, last_wo_status_date,
                active_flag, active_date, inactive_date, 
                insert_by, insert_date,
                update_by, update_date, delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id, 
                ridb_on_time_flag, report_date
--                , maint_event_id_part1, maint_event_id_part2 
                )
        VALUES (
                tmp.rec_id, tmp.source_rec_id, tmp.pba_id, 
                tmp.maint_ev_id, tmp.maint_org, tmp.maint_uic, tmp.maint_lvl_cd,
                tmp.maint_item, tmp.maint_item_niin, tmp.maint_item_sn, tmp.num_maint_item,
                tmp.sys_ei_niin, tmp.sys_ei_sn,
                tmp.num_mi_nrts, tmp.num_mi_rprd, tmp.num_mi_cndmd, tmp.num_mi_neof,
                tmp.dt_maint_ev_est, tmp.dt_maint_ev_cmpl, tmp.sys_ei_nmcm, 
                tmp.phase_ev, tmp.sof_ev, tmp.asam_ev, tmp.mwo_ev, tmp.elapsed_me_wk_tm,
                tmp.source_id, tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.heir_id, tmp.priority, tmp.cust_org, tmp.cust_uic,
                tmp.fault_malfunction_descr, tmp.won, 
--                tmp.last_wo_status, tmp.last_wo_status_date,
                tmp.active_flag, tmp.active_date, tmp.inactive_date, 
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, tmp.delete_flag, tmp.delete_date, tmp.delete_by,
                tmp.hidden_flag, tmp.hidden_date, tmp.hidden_by, 
                tmp.frz_input_date, tmp.frz_input_date_id, 
                tmp.ridb_on_time_flag, tmp.report_date
--                , tmp.maint_event_id_part1, tmp.maint_event_id_part2
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
--    COMMIT; 

-- Set warehouse ids    

    ps_location := 'PFSA 106';            -- For std_pfsawh_debug_tbl logging. 
    
-- ITEM 

    UPDATE frz_pfsa_maint_event pue
    SET    physical_item_id = 
            NVL((
            SELECT NVL(physical_item_id, 0)  
            FROM   pfsawh_item_dim 
            WHERE  niin = pue.sys_ei_niin
--                AND status = 'C'
            ), -1)  
    WHERE  pue.physical_item_id IS NULL
        OR pue.physical_item_id < 1; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- ITEM_SN  

    UPDATE frz_pfsa_maint_event pue
    SET    physical_item_sn_id = 
            NVL((
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
                AND status = 'C' 
            ), -1)  
    WHERE  pue.physical_item_sn_id IS NULL
        OR pue.physical_item_sn_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT;

-- FORCE 

    UPDATE frz_pfsa_maint_event pue
    SET    force_unit_id = 
            NVL((
            SELECT NVL(force_unit_id, -1)  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = pue.cust_uic 
                AND status = 'C'
            ), -1) 
    WHERE  force_unit_id IS NULL 
        OR force_unit_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- LOCATION     

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

-- MIMOSA      

    UPDATE frz_pfsa_maint_event  
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

    ps_location := 'PFSA 108';            -- For std_pfsawh_debug_tbl logging.

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_maint_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
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
  
-- Update the status of the sub-process FRZ_PFSA_MAINT_EVENT. 

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
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 60;
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
        
    ps_location := 'PFSA 110';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_MAINT_ITEMS'; 
  
-- Get the run criteria for the FRZ_PFSA_MAINT_ITEMS from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZ_PFSA_MAINT_ITEMS. 

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
    FROM   frz_pfsa_maint_items_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_items_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   frz_pfsa_maint_items_tmp 
        (
        rec_id, source_rec_id, pba_id, 
        maint_ev_id, maint_task_id, maint_item_id,
        cage_cd, part_num, niin, part_sn,
        num_items, cntld_exchng, removed, failure,
        lst_updt, updt_by, heir_id, priority,
        doc_no, doc_no_expand, part_uid,
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, insert_date, update_by, update_date,
        delete_flag, delete_date, delete_by, 
        hidden_flag, hidden_date, hidden_by 
        )
    SELECT rec_id, rec_id, pba_id, 
        maint_ev_id, maint_task_id, maint_item_id,
        cage_cd, part_num, niin, part_sn,
        num_items, cntld_exchng, removed, failure,
        lst_updt, updt_by, heir_id, priority, 
        doc_no, doc_no_expand, part_uid,
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, insert_date, update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by 
    FROM   frz_pfsa_maint_items@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff 
        AND delete_flag = 'N';  

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
--    COMMIT; 
    
    IF proc1.rec_inserted_int = 0 THEN
        INSERT 
        INTO   frz_pfsa_maint_items_tmp 
            (
            rec_id, source_rec_id, pba_id, 
            maint_ev_id, maint_task_id, maint_item_id,
            cage_cd, part_num, niin, part_sn,
            num_items, cntld_exchng, removed, failure,
            lst_updt, updt_by, heir_id, priority,
            doc_no, doc_no_expand, part_uid--,
        --    frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        --    insert_by, insert_date, update_by, update_date,
        --    delete_flag, delete_date, delete_by, 
        --    hidden_flag, hidden_date, hidden_by 
            )
        SELECT 0,0, /*itm.rec_id, itm.rec_id,*/ it.pba_id, 
            itm.maint_ev_id, itm.maint_task_id, itm.maint_item_id,
            itm.cage_cd, itm.part_num, itm.niin, itm.part_sn,
            itm.num_items, itm.cntld_exchng, itm.removed, itm.failure,
            itm.lst_updt, itm.updt_by, itm.heir_id, itm.priority, 
            itm.doc_no, itm.doc_no_expand, itm.part_uid--,
        --    itm.frz_input_date, itm.frz_input_date_id, itm.rec_frz_flag, itm.frz_date,
        --    itm.insert_by, itm.insert_date, itm.update_by, itm.update_date,
        --    itm.delete_flag, itm.delete_date- itm.delete_by,
        --    itm.hidden_flag, itm.hidden_date, itm.hidden_by 
        FROM   pfsa_maint_items itm,  
               pfsa_maint_event frz,
               pfsa_pba_items_ref it  
        WHERE  it.pba_id = 1000006
            AND it.item_identifier_type_id = 14 
            AND it.item_type_value = frz.maint_item_sn 
            AND frz.maint_ev_id = itm.maint_ev_id
        ORDER BY it.item_type_value; 

        proc1.rec_load_int := NVL(proc1.rec_load_int, 0) + SQL%ROWCOUNT;

        COMMIT;    
    END IF;
 
    MERGE  
    INTO   frz_pfsa_maint_items psi 
    USING  (SELECT 
                rec_id, source_rec_id, pba_id, 
                maint_ev_id,
                maint_task_id,
                maint_item_id,
                cage_cd,
                part_num,
                niin,
                part_sn,
                num_items,
                cntld_exchng,
                removed,
                failure,
                lst_updt,
                updt_by,
                heir_id,
                priority,
                doc_no,
                doc_no_expand,
                part_uid,
                insert_by, insert_date,
                update_by, update_date, 
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id
            FROM   frz_pfsa_maint_items_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
           AND psi.maint_task_id = tmp.maint_task_id
           AND psi.maint_item_id = tmp.maint_item_id
           AND psi.pba_id = tmp.pba_id
           )  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id = tmp.maint_ev_id,            
--            psi.maint_task_id = tmp.maint_task_id,
--            psi.maint_item_id = tmp.maint_item_id,
            psi.rec_id = tmp.rec_id, 
            psi.source_rec_id = tmp.source_rec_id, 
--            psi.pba_id = tmp.pba_id,                 
            psi.cage_cd = tmp.cage_cd,
            psi.part_num = tmp.part_num,
            psi.niin = tmp.niin,
            psi.part_sn = tmp.part_sn,
            psi.num_items = tmp.num_items,
            psi.cntld_exchng = tmp.cntld_exchng,
            psi.removed = tmp.removed,
            psi.failure = tmp.failure,
            psi.lst_updt = tmp.lst_updt,
            psi.updt_by = tmp.updt_by,
            psi.heir_id = tmp.heir_id,
            psi.priority = tmp.priority,
            psi.doc_no = tmp.doc_no,
            psi.doc_no_expand = tmp.doc_no_expand,
            psi.part_uid = tmp.part_uid,
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
            psi.frz_input_date_id = tmp.frz_input_date_id
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_task_id, maint_item_id,
                cage_cd, part_num, niin, part_sn,
                num_items, cntld_exchng, removed, failure,
                lst_updt, updt_by, heir_id, priority,
                doc_no, doc_no_expand, part_uid,
                insert_by, insert_date,
                update_by, update_date, 
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id
                )
        VALUES (
                tmp.rec_id, tmp.source_rec_id, tmp.pba_id, 
                tmp.maint_ev_id, tmp.maint_task_id, tmp.maint_item_id,
                tmp.cage_cd, tmp.part_num, tmp.niin, tmp.part_sn,
                tmp.num_items, tmp.cntld_exchng, tmp.removed, tmp.failure,
                tmp.lst_updt, tmp.updt_by, tmp.heir_id, tmp.priority,
                tmp.doc_no, tmp.doc_no_expand, tmp.part_uid,
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, 
                tmp.delete_flag, tmp.delete_date, tmp.delete_by,
                tmp.hidden_flag, tmp.hidden_date, tmp.hidden_by, 
                tmp.frz_input_date, tmp.frz_input_date_id
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_maint_items_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_items_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
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
  
-- Update the status of the sub-process FRZ_PFSA_MAINT_ITEMS. 

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
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 70;
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
        
    ps_location := 'PFSA 120';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_MAINT_TASK'; 
  
-- Get the run criteria for the FRZ_PFSA_MAINT_TASK from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZPFSA_MAINT_TASK  

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
    FROM   frz_pfsa_maint_task_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_task_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO   frz_pfsa_maint_task_tmp 
        (
        rec_id, source_rec_id, pba_id, 
        maint_ev_id, maint_task_id,
        elapsed_tsk_wk_tm, elapsed_part_wt_tm,
        tsk_begin, tsk_end, inspect_tsk, tsk_was_def,
        sched_unsched, essential,
        status, lst_updt,
        updt_by, heir_id, priority,
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by
        )
    SELECT 
        rec_id, rec_id, pba_id, 
        maint_ev_id, maint_task_id,
        elapsed_tsk_wk_tm, elapsed_part_wt_tm,
        tsk_begin, tsk_end, inspect_tsk, tsk_was_def,
        sched_unsched, essential,
        status, lst_updt,
        updt_by, heir_id, priority,
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by
    FROM   frz_pfsa_maint_task@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff 
        AND delete_flag = 'N';  

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    MERGE  
    INTO   frz_pfsa_maint_task psi 
    USING  (SELECT 
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_task_id,
                elapsed_tsk_wk_tm, elapsed_part_wt_tm,
                tsk_begin, tsk_end, inspect_tsk, tsk_was_def,
                sched_unsched, essential,
                status, lst_updt, updt_by,
                heir_id, priority,
                insert_by, insert_date,
                update_by, update_date, 
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id
            FROM   frz_pfsa_maint_task_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
           AND psi.maint_task_id = tmp.maint_task_id
           AND psi.pba_id = tmp.pba_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id              = tmp.maint_ev_id,            
--            psi.maint_task_id              = tmp.maint_task_id,            
            psi.rec_id = tmp.rec_id, 
            psi.source_rec_id = tmp.source_rec_id, 
--            psi.pba_id = tmp.pba_id, 
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
            psi.priority = tmp.priority,
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
            psi.frz_input_date_id = tmp.frz_input_date_id
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_task_id,
                elapsed_tsk_wk_tm, elapsed_part_wt_tm,
                tsk_begin, tsk_end, inspect_tsk, tsk_was_def,
                sched_unsched, essential,
                status, lst_updt, updt_by,
                heir_id, priority,
                insert_by, insert_date,
                update_by, update_date, 
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id
                )
        VALUES (
                tmp.rec_id, tmp.source_rec_id, tmp.pba_id, 
                tmp.maint_ev_id, tmp.maint_task_id,
                tmp.elapsed_tsk_wk_tm, tmp.elapsed_part_wt_tm,
                tmp.tsk_begin, tmp.tsk_end, tmp.inspect_tsk, tmp.tsk_was_def,
                tmp.sched_unsched, tmp.essential,
                tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.heir_id, tmp.priority,
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, 
                tmp.delete_flag, tmp.delete_date, tmp.delete_by,
                tmp.hidden_flag, tmp.hidden_date, tmp.hidden_by, 
                tmp.frz_input_date, tmp.frz_input_date_id
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_maint_task_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_task_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
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
  
-- Update the status of the sub-process FRZ_PFSA_MAINT_TASK. 

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
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 80;
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
        
    ps_location := 'PFSA 130';            -- For std_pfsawh_debug_tbl logging. 
    
    ls_current_process.pfsa_process := 'FRZ_PFSA_MAINT_WORK'; 
  
-- Get the run criteria for the FRZ_PFSA_MAINT_WORK from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of FRZ_PFSA_MAINT_WORK. 

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
    FROM   frz_pfsa_maint_work_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_work_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    ps_location := 'PFSA 134';            -- For std_pfsawh_debug_tbl logging. 
    
    INSERT 
    INTO   frz_pfsa_maint_work_tmp 
        (
        rec_id, source_rec_id, pba_id, 
        maint_ev_id, maint_task_id, maint_work_id,
        maint_work_mh, mil_civ_kon, mos, spec_person, repair,
        status, lst_updt, updt_by,
        mos_sent, heir_id, priority,
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by 
        )
    SELECT 
        rec_id, rec_id, pba_id, 
        maint_ev_id, maint_task_id, maint_work_id,
        maint_work_mh, mil_civ_kon, mos, spec_person, repair,
        status, lst_updt, updt_by,
        mos_sent, heir_id, priority,
        frz_input_date, frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date, delete_by,
        hidden_flag, hidden_date, hidden_by
    FROM   frz_pfsa_maint_work@pfsaw.lidb
    WHERE lst_updt > v_etl_copy_cutoff 
        AND delete_flag = 'N';  

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    ps_location := 'PFSA 136';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   frz_pfsa_maint_work psi 
    USING  (SELECT 
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_task_id, maint_work_id,
                maint_work_mh, mil_civ_kon, mos, spec_person,
                repair, status, lst_updt, updt_by,
                mos_sent, heir_id, priority,
                insert_by, insert_date,
                update_by, update_date, 
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id
            FROM   frz_pfsa_maint_work_tmp ) tmp 
    ON     (psi.maint_ev_id = tmp.maint_ev_id
           AND psi.maint_task_id = tmp.maint_task_id
           AND psi.maint_work_id = tmp.maint_work_id 
           AND psi.pba_id = tmp.pba_id
           )  
    WHEN MATCHED THEN 
        UPDATE SET   
--            psi.maint_ev_id             = tmp.maint_ev_id,            
--            psi.maint_task_id              = tmp.maint_task_id,            
--            psi.maint_work_id              = tmp.maint_work_id,    
            psi.rec_id = tmp.rec_id, 
            psi.source_rec_id = tmp.source_rec_id, 
--            psi.pba_id = tmp.pba_id, 
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
            psi.priority = tmp.priority,
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
            psi.frz_input_date_id = tmp.frz_input_date_id
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id, source_rec_id, pba_id, 
                maint_ev_id, maint_task_id, maint_work_id,
                maint_work_mh, mil_civ_kon, mos, spec_person,
                repair, status, lst_updt, updt_by,
                mos_sent, heir_id, priority,
                insert_by, insert_date,
                update_by, update_date, 
                delete_flag, delete_date, delete_by,
                hidden_flag, hidden_date, hidden_by, 
                frz_input_date, frz_input_date_id
                )
        VALUES (
                tmp.rec_id, tmp.source_rec_id, tmp.pba_id, 
                tmp.maint_ev_id, tmp.maint_task_id, tmp.maint_work_id,
                tmp.maint_work_mh, tmp.mil_civ_kon, tmp.mos, tmp.spec_person,
                tmp.repair, tmp.status, tmp.lst_updt, tmp.updt_by,
                tmp.mos_sent, tmp.heir_id, tmp.priority,
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, 
                tmp.delete_flag, tmp.delete_date, tmp.delete_by,
                tmp.hidden_flag, tmp.hidden_date, tmp.hidden_by, 
                tmp.frz_input_date, tmp.frz_input_date_id
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_maint_work_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_work_tmp';
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
    
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.rec_load_int := NULL;
      
    proc1.process_RecId      := 700; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 85;
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
        
    ps_location := 'PFSA 138';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE pfsawh_maint_itm_wrk_fact
    WHERE  etl_processed_by = ps_procedure_name;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 

    INSERT 
    INTO   pfsawh_maint_itm_wrk_fact 
        (
        maint_ev_id_a, 
        maint_ev_id_b, 
        maint_task_id, 
        maint_work_id, 
        pba_id, 
        etl_processed_by, 
        tsk_begin_date_id, 
        tsk_begin_time_id, 
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item_id, 
        physical_item_sn_id, 
--        mimosa_item_sn_id, 
--        force_unit_id, 
--        pba_id, 
        maint_org, 
        maint_uic, 
        maint_lvl_cd, 
        elapsed_tsk_wk_tm, 
        inspect_tsk, 
        essential_tsk, 
        maint_work_mh, 
        wrk_mil_civ_kon, 
        wrk_mos, 
        wrk_spec_person, 
        wrk_repair, 
        wrk_mos_sent,    
        cust_org,
        cust_uic,
        evnt_begin_date_id,
        evnt_cmpl_date_id,
        fault_malfunction_descr,
        won                           
        )
    SELECT 
        NVL(SUBSTR(ev.maint_ev_id, 1, INSTR(ev.maint_ev_id, '|')-1), '0') AS maint_ev_id_a, 
        NVL(SUBSTR(ev.maint_ev_id, INSTR(ev.maint_ev_id, '|')+1, LENGTH(ev.maint_ev_id)), '0') AS maint_ev_id_b, 
        NVL(tk.maint_task_id, 0), 
        NVL(wk.maint_work_id, 0),  
        ev.pba_id, 
        ps_procedure_name, 
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
        fn_pfsawh_get_item_dim_id(NVL(ev.sys_ei_niin, '000000000')) AS item_sys_ei_id,  
        fn_pfsawh_get_item_sn_dim_id(NVL(ev.sys_ei_niin, '000000000'), NVL(ev.sys_ei_sn, 0)) AS item_sn_ei_id, 
        ev.maint_org, 
        ev.maint_uic, 
        ev.maint_lvl_cd, 
        NVL(tk.elapsed_tsk_wk_tm, 0), 
        NVL(tk.inspect_tsk, 'U'), 
        NVL(tk.essential, 'U'), 
        NVL(wk.maint_work_mh, ''), 
        NVL(wk.mil_civ_kon, 'U'), 
        NVL(wk.mos, 'UNK'), 
        NVL(wk.spec_person, 'UNKNOWN'), 
        NVL(wk.repair, 'U'), 
        NVL(wk.mos_sent, 'UNK'),     
        cust_org,
        cust_uic,
        fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_est, 'DD-MON-YYYY')),
        fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_cmpl, 'DD-MON-YYYY')),
        fault_malfunction_descr,
        won     
--           , '|', 
--           wk.*, tk.*, ev.* 
    FROM   frz_pfsa_maint_event ev, 
           frz_pfsa_maint_task tk,
           frz_pfsa_maint_work wk 
    WHERE  tk.maint_ev_id (+) = ev.maint_ev_id
        AND wk.maint_ev_id (+) = tk.maint_ev_id 
        AND wk.maint_task_id (+) = tk.maint_task_id 
        AND ev.pba_id = tk.pba_id 
        AND ev.pba_id = wk.pba_id 
--        AND ev.sys_ei_niin = '013285964' 
--        AND rownum < 100 
    ORDER BY ev.maint_ev_id, tk.maint_task_id, wk.maint_work_id;  
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
-- Set warehouse ids    

    ps_location := 'PFSA 140';            -- For std_pfsawh_debug_tbl logging. 
    
-- FORCE 

    UPDATE pfsawh_maint_itm_wrk_fact f
    SET    force_unit_id = 
            (
            SELECT NVL(force_unit_id, -1)  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = f.cust_uic 
                AND status = 'C'
            )
    WHERE  (f.force_unit_id IS NULL 
        OR f.force_unit_id < 1)
        AND etl_processed_by = ps_procedure_name; 

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

-- date_cmplt_readiness_prd_id

    UPDATE  pfsawh_maint_itm_wrk_fact f
    SET     date_cmplt_readiness_prd_id = 
                (
                SELECT fn_date_to_date_id(b.READY_DATE) 
                FROM    pfsawh_ready_date_dim   b
                WHERE   b.date_dim_id = f.evnt_cmpl_date_id  
                )
    WHERE   f.date_cmplt_readiness_prd_id IS NULL  
        AND etl_processed_by = ps_procedure_name; -- 'ETL_FRZ_PFSA' -

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

-- pfsawh_item_sn_p_fact - maint_action_cnt & total_down_time -

    UPDATE  pfsawh_item_sn_p_fact p
    SET     (maint_action_cnt, total_down_time) = 
                (
                SELECT  COUNT(a.physical_item_sn_id), 
                        SUM(a.tsk_days_to_cmplt)  
                FROM    pfsawh_maint_itm_wrk_fact a
                WHERE   a.date_cmplt_readiness_prd_id = p.date_id 
                    AND a.physical_item_sn_id = p.physical_item_sn_id 
                GROUP BY a.physical_item_sn_id, 
                      --  a.maint_ev_id_a, 
                      --  a.maint_ev_id_b,
                        a.date_cmplt_readiness_prd_id 
                ) 
    WHERE   etl_processed_by = 'ETL_FRZ_PFSA'; -- 'ETL_FRZ_PFSA' ps_procedure_name - 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    UPDATE  pfsawh_maint_itm_wrk_fact a
    SET     date_cmplt_readiness_prd_id = 
                (
                SELECT fn_date_to_date_id(b.READY_DATE) 
                FROM    pfsawh_ready_date_dim   b
                WHERE   a.EVNT_CMPL_DATE_ID = b.DATE_DIM_ID
                )
    WHERE   etl_processed_by = ps_procedure_name; -- 'ETL_FRZ_PFSA' - 
     
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    UPDATE  pfsawh_maint_itm_wrk_fact a
    SET     tsk_days_to_cmplt = a.evnt_cmpl_date_id - a.evnt_begin_date_id 
    WHERE   etl_processed_by = ps_procedure_name; -- 'ETL_FRZ_PFSA' - 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

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
    WHERE   etl_processed_by = ps_procedure_name; -- 'ETL_FRZ_PFSA' - 

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

    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process FRZ_PFSA_MAINT_WORK. 

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


