CREATE OR REPLACE PROCEDURE PFSAWH.daily_incr_supply_ilap_load 
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: daily_incr_supply_ilap_load 
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 23 October 2008 
--
--          SP Source: daily_incr_supply_ilap_load.sql 
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- 
-- Identifies the latest additions and changes to the lidb.pfsa_supply_ilap 
-- table and pulls them into liwwwh.pfsa_supply_ilap.  
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
-- 23OCT08 - GB  -          -      - Created 
-- 13NOV08 - GB  -          -      - Adjusted the my_lst_updt to not use update
--                                   dates 01-Jan-2000 when calculating the 
--                                   last update date.  
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

BEGIN 

    daily_incr_supply_ilap_load ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'DAILY_INCR_SUPPLY_ILAP_LOAD';  /*  */
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

v_index_cnt             NUMBER; 

w_rec_id                pfsa_supply_ilap_tmp.rec_id%TYPE;
w_sof                   pfsa_supply_ilap_tmp.sof%TYPE;

CURSOR  updt_flag_cur IS
    SELECT rec_id, sof
    FROM   pfsa_supply_ilap_tmp;

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

    proc0.process_RecId      := 570; 
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

    ps_id_key := NVL(type_maintenance, 'daily_incr_supply_ilap_load');

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

    ls_current_process.pfsa_process := 'DAILY_INCR_SUPPLY_ILAP_LOAD'; 
  
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
      
    proc1.process_RecId      := 570; 
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
    
    select max(insert_date) into my_insert_dt from pfsa_supply_ilap;
    select max(update_date) into my_update_dt from pfsa_supply_ilap; 
    
-- 13NOV08 - GB  -          -      - Adjusted the my_lst_updt to not use update
--                                   dates 01-Jan-2000 when calculating the 
--                                   last update date.  

    if my_update_dt < TO_DATE('01-JAN-2000', 'DD-MON-YYYY') THEN
      my_lst_updt := my_insert_dt;  
    elsif my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;

-- Commented out for next performance test - GB - 13 Nov 08 --    
--    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
 
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_supply_ilap_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_supply_ilap_tmp'; 
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
       
    ps_location := 'PFSA 60';            -- For std_pfsawh_debug_tbl logging. 
    
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
    WHERE 
    --add in max lst_updt compare lmj 05nov08   
          insert_date > my_lst_updt
           or update_date > my_lst_updt; 

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
      
    proc1.process_RecId      := 570; 
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
        
    COMMIT; 
        
    ps_location := 'PFSA 70';            -- For std_pfsawh_debug_tbl logging. 
    
-- ITEM 


-- ITEM_SN  


-- FORCE 


-- LOCATION     


-- MIMOSA      


-- PBA_ID 

    UPDATE pfsa_maint_event_tmp me
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

--  Set the warehouse period 

    UPDATE pfsa_supply_ilap_tmp psi
    SET    (wh_period_date, wh_period_date_id) = 
           (
           SELECT ready_date, date_dim_id 
           FROM   pfsawh_ready_date_dim 
           WHERE  psi.d_cust_iss = oracle_date 
           )
    WHERE -- wh_period_date IS NULL OR 
        wh_period_date_id < 1; 
           
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 

/*--  Set the SOF flags 

    UPDATE pfsa_supply_ilap 
    SET    sof_dvd_flag = 1 
    WHERE  UPPER(sof) = 'DVD';

    UPDATE pfsa_supply_ilap 
    SET    sof_dvd_bo_flag = 1 
    WHERE  UPPER(sof) = 'DVD_BO'; 

    UPDATE pfsa_supply_ilap 
    SET    sof_lat_off_flag = 1 
    WHERE  UPPER(sof) = 'LAT_OFF'; 

    UPDATE pfsa_supply_ilap 
    SET    sof_lat_on_flag = 1 
    WHERE  UPPER(sof) = 'LAT_ON'; 

    UPDATE pfsa_supply_ilap 
    SET    sof_lp_flag = 1 
    WHERE  UPPER(sof) = 'LP'; 

    UPDATE pfsa_supply_ilap 
    SET    sof_maint_flag = 1 
    WHERE  UPPER(sof) = 'MAINT'; 

    UPDATE pfsa_supply_ilap 
    SET    sof_ref_off_flag = 1 
    WHERE  UPPER(sof) = 'REF_OFF'; 

    UPDATE pfsa_supply_ilap 
    SET    sof_ref_on_flag = 1 
    WHERE  UPPER(sof) = 'REF_ON';

    UPDATE pfsa_supply_ilap 
    SET    sof_ssa_flag = 1 
    WHERE  UPPER(sof) = 'SSA';

    UPDATE pfsa_supply_ilap 
    SET    sof_ti_flag = 1 
    WHERE  UPPER(sof) = 'TI';

    UPDATE pfsa_supply_ilap 
    SET    sof_unk_flag = 1 
    WHERE  UPPER(sof) = 'UNK';

    UPDATE pfsa_supply_ilap 
    SET    sof_whsl_flag = 1 
    WHERE  UPPER(sof) = 'WHSL';

    UPDATE pfsa_supply_ilap 
    SET    sof_whsl_bo_flag = 1 
    WHERE  UPPER(sof) = 'WHSL_BO';

    UPDATE pfsa_supply_ilap 
    SET    sof_whsl_ge_flag = 1 
    WHERE  UPPER(sof) = 'WHSL_GE';

    UPDATE pfsa_supply_ilap 
    SET    sof_whsl_ko_flag = 1 
    WHERE  UPPER(sof) = 'WHSL_KO';

    UPDATE pfsa_supply_ilap 
    SET    sof_whsl_ku_flag = 1 
    WHERE  UPPER(sof) = 'WHSL_KU';
*/

    ps_location := 'PFSA 80';            -- For std_pfsawh_debug_tbl logging. 
    
-- Replace update statements 

-- Delete the tmp index if it exists 

    SELECT COUNT(*) 
    INTO   v_index_cnt 
    FROM   all_indexes
    WHERE  owner = 'PFSAWH' 
        AND index_name = UPPER('pfsa_supply_ilap_tmp_pk_idx');
        
    ps_location := 'PFSA 81';            -- For std_pfsawh_debug_tbl logging. 
    
    IF v_index_cnt > 0 THEN

        EXECUTE IMMEDIATE --'ALTER TABLE pfsa_supply_ilap_tmp
            'DROP INDEX pfsa_supply_ilap_tmp_pk_idx'; 
            
--            DROP PRIMARY KEY CASCADE; 
       
    END IF;
    
    --    EXECUTE IMMEDIATE 'DROP index pfsa_supply_ilap_tmp_pk_idx';
    
    ps_location := 'PFSA 82';            -- For std_pfsawh_debug_tbl logging. 
    
    EXECUTE IMMEDIATE 
        'CREATE UNIQUE INDEX pfsa_supply_ilap_tmp_pk_idx ON ' || 
            'pfsa_supply_ilap_tmp(rec_id)';
   
    ps_location := 'PFSA 85';            -- For std_pfsawh_debug_tbl logging. 
    
    OPEN updt_flag_cur;
  
    LOOP

        FETCH updt_flag_cur INTO w_rec_id, w_sof;
        
        EXIT WHEN updt_flag_cur%NOTFOUND;
           
        CASE UPPER(w_sof)
            WHEN 'DVD'     THEN  UPDATE pfsa_supply_ilap_tmp SET sof_dvd_flag = 1     WHERE  rec_id = w_rec_id;
            WHEN 'DVD_BO'  THEN  UPDATE pfsa_supply_ilap_tmp SET sof_dvd_bo_flag = 1  WHERE  rec_id = w_rec_id; 
            WHEN 'LAT_OFF' THEN  UPDATE pfsa_supply_ilap_tmp SET sof_lat_off_flag = 1 WHERE  rec_id = w_rec_id; 
            WHEN 'LAT_ON'  THEN  UPDATE pfsa_supply_ilap_tmp SET sof_lat_on_flag = 1  WHERE  rec_id = w_rec_id; 
            WHEN 'LP'      THEN  UPDATE pfsa_supply_ilap_tmp SET sof_lp_flag = 1      WHERE  rec_id = w_rec_id; 
            WHEN 'MAINT'   THEN  UPDATE pfsa_supply_ilap_tmp SET sof_maint_flag = 1   WHERE  rec_id = w_rec_id; 
            WHEN 'REF_OFF' THEN  UPDATE pfsa_supply_ilap_tmp SET sof_ref_off_flag = 1 WHERE  rec_id = w_rec_id; 
            WHEN 'REF_ON'  THEN  UPDATE pfsa_supply_ilap_tmp SET sof_ref_on_flag = 1  WHERE  rec_id = w_rec_id; 
            WHEN 'SSA'     THEN  UPDATE pfsa_supply_ilap_tmp SET sof_ssa_flag = 1     WHERE  rec_id = w_rec_id; 
            WHEN 'TI'      THEN  UPDATE pfsa_supply_ilap_tmp SET sof_ti_flag = 1      WHERE  rec_id = w_rec_id; 
            WHEN 'UNK'     THEN  UPDATE pfsa_supply_ilap_tmp SET sof_unk_flag = 1     WHERE  rec_id = w_rec_id; 
            WHEN 'WHSL'    THEN  UPDATE pfsa_supply_ilap_tmp SET sof_whsl_flag = 1    WHERE  rec_id = w_rec_id; 
            WHEN 'WHSL_BO' THEN  UPDATE pfsa_supply_ilap_tmp SET sof_whsl_bo_flag = 1 WHERE  rec_id = w_rec_id; 
            WHEN 'WHSL_GE' THEN  UPDATE pfsa_supply_ilap_tmp SET sof_whsl_ge_flag = 1 WHERE  rec_id = w_rec_id; 
            WHEN 'WHSL_KO' THEN  UPDATE pfsa_supply_ilap_tmp SET sof_whsl_ko_flag = 1 WHERE  rec_id = w_rec_id; 
            WHEN 'WHSL_KU' THEN  UPDATE pfsa_supply_ilap_tmp SET sof_whsl_ku_flag = 1 WHERE  rec_id = w_rec_id;
            ELSE  w_rec_id := w_rec_id;
        END CASE; 
    
    END LOOP;

    CLOSE updt_flag_cur;

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
      
    proc1.process_RecId      := 570; 
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
        
    COMMIT; 
    
    ps_location := 'PFSA 90';            -- For std_pfsawh_debug_tbl logging. 
    
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
                delete_flag, delete_date, hidden_flag, hidden_date,
                SOF_DVD_FLAG, SOF_DVD_BO_FLAG,SOF_LAT_OFF_FLAG,
                SOF_LAT_ON_FLAG,SOF_LP_FLAG, SOF_MAINT_FLAG,
                SOF_REF_OFF_FLAG, SOF_REF_ON_FLAG,SOF_SSA_FLAG,
                SOF_TI_FLAG, SOF_UNK_FLAG,SOF_WHSL_BO_FLAG,
                SOF_WHSL_GE_FLAG, SOF_WHSL_KO_FLAG,SOF_WHSL_KU_FLAG,
                SOF_WHSL_FLAG, 
                delete_by, hidden_by, pba_id
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
            psi.update_date = SYSDATE,
            psi.delete_flag = tmp.delete_flag,
            psi.delete_date = tmp.delete_date,
            psi.hidden_flag = tmp.hidden_flag,
            psi.hidden_date = tmp.hidden_date,
            psi.SOF_DVD_FLAG  = tmp.SOF_DVD_FLAG, 
            psi.SOF_DVD_BO_FLAG = tmp.SOF_DVD_BO_FLAG,
            psi.SOF_LAT_OFF_FLAG = tmp.SOF_LAT_OFF_FLAG,
            psi.SOF_LAT_ON_FLAG = tmp.SOF_LAT_ON_FLAG,
            psi.SOF_LP_FLAG = tmp.SOF_LP_FLAG, 
            psi.SOF_MAINT_FLAG = tmp.SOF_MAINT_FLAG,
            psi.SOF_REF_OFF_FLAG = tmp.SOF_REF_OFF_FLAG, 
            psi.SOF_REF_ON_FLAG = tmp.SOF_REF_ON_FLAG,
            psi.SOF_SSA_FLAG = tmp.SOF_SSA_FLAG,
            psi.SOF_TI_FLAG = tmp.SOF_TI_FLAG, 
            psi.SOF_UNK_FLAG = tmp.SOF_UNK_FLAG,
            psi.SOF_WHSL_BO_FLAG = tmp.SOF_WHSL_BO_FLAG,
            psi.SOF_WHSL_GE_FLAG = tmp.SOF_WHSL_GE_FLAG, 
            psi.SOF_WHSL_KO_FLAG = tmp.SOF_WHSL_KO_FLAG,
            psi.SOF_WHSL_KU_FLAG = tmp.SOF_WHSL_KU_FLAG,
            psi.SOF_WHSL_FLAG = tmp.SOF_WHSL_FLAG, 
            psi.delete_by = tmp.delete_by, 
            psi.hidden_by = tmp.hidden_by, 
            psi.pba_id = tmp.pba_id   
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
                delete_flag, delete_date, hidden_flag, hidden_date,
                SOF_DVD_FLAG, SOF_DVD_BO_FLAG,SOF_LAT_OFF_FLAG,
                SOF_LAT_ON_FLAG,SOF_LP_FLAG, SOF_MAINT_FLAG,
                SOF_REF_OFF_FLAG, SOF_REF_ON_FLAG,SOF_SSA_FLAG,
                SOF_TI_FLAG, SOF_UNK_FLAG,SOF_WHSL_BO_FLAG,
                SOF_WHSL_GE_FLAG, SOF_WHSL_KO_FLAG,SOF_WHSL_KU_FLAG,
                SOF_WHSL_FLAG,
                delete_by, hidden_by, pba_id  
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
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date,
                tmp.SOF_DVD_FLAG,  tmp.SOF_DVD_BO_FLAG, tmp.SOF_LAT_OFF_FLAG,
                tmp.SOF_LAT_ON_FLAG, tmp.SOF_LP_FLAG,  tmp.SOF_MAINT_FLAG,
                tmp.SOF_REF_OFF_FLAG,  tmp.SOF_REF_ON_FLAG, tmp.SOF_SSA_FLAG,
                tmp.SOF_TI_FLAG,  tmp.SOF_UNK_FLAG, tmp.SOF_WHSL_BO_FLAG,
                tmp.SOF_WHSL_GE_FLAG,  tmp.SOF_WHSL_KO_FLAG, tmp.SOF_WHSL_KU_FLAG,
                tmp.SOF_WHSL_FLAG,
                tmp.delete_by, tmp.hidden_by, tmp.pba_id 
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
-- add after merge update/insert statement into pfsa_ilap_supply 

    EXECUTE IMMEDIATE 'DROP INDEX pfsa_supply_ilap_tmp_pk_idx';
   
    pr_upd_pfsa_fcs_sys_dates (ps_this_process.who_ran, 'MONTHLY_CWT_PERIOD_DATE'); 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   pfsa_supply_ilap_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'pfsa_supply_ilap_tmp';
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
        ps_procedure_name, ps_oerr, ps_location, ps_procedure_name, 
        ps_id_key, ps_msg, SYSDATE
        );
        
        COMMIT; 

END; -- end of procedure
/

