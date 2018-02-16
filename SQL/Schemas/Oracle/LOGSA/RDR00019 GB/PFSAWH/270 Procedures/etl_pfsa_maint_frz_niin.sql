CREATE OR REPLACE PROCEDURE etl_pfsa_maint_frz_niin     
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS
/************ TEAM ITSS********************************************************


       NAME:    etl_pfsa_maint_frz_niin 

    PURPOSE:    To get the freeze maintenance data for the passed 
                PHYSICAL_ITEM _ID from the PSFA tables on lidb, resolve the 
                normal identifiers to the warehouse dimension ids then load the 
                facts in the PFSAWH_ITEM_SN_P_FACT and FSAWH_MAINT_ITM_WRK_FACT 
                tables.


 PARAMETERS:   See procedure definition

      INPUT:   See procedure definition

     OUTPUT:   See procedure definition

ASSUMPTIONS:  That the fact records for the PHYSICL_ITEM_ID and time period 
              exist in the PFSAWH_ITEM_SN_P_FACT and may exist in the 
              PFSAWH_MAINT_ITM_WRK_FACT. 

LIMITATIONS:  Expects valid PHYSICAL_ITEM_ID 

      NOTES:

  
  Date     ECP #                 Author           Description
---------  ---------------       ---------------  ----------------------------------
24 Nov 08  EECP03680-CPTSK09335  j-ann            Procedure Created
03 Dec 08                        G. Belford       Removed the date limit on the 
                                                    select since this is a NIIN 
                                                    reload. 




************* TEAM ITSS *******************************************************/

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_PFSA_MAINT_FRZ_NIIN';  /*  */
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

l_ps_start                       DATE          := sysdate;

proc0_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 pfsawh_process_log%ROWTYPE; 
proc1                 pfsawh_process_log%ROWTYPE; 

ps_last_process       pfsawh_processes%ROWTYPE;
ps_this_process       pfsawh_processes%ROWTYPE;

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                    NUMBER        := 0; 

cv_physical_item_id        NUMBER; 

v_niin                     pfsawh_item_dim.niin%TYPE; 
v_item_nomen_standard      pfsawh_item_dim.item_nomen_standard%TYPE; 

v_etl_copy_cutoff          DATE; 

-- add  by lmj 10/10/08 variables to manaage truncation and index control --

myrowcount              NUMBER;
mytablename             VARCHAR2(32);

my_lst_updt             DATE := null;
my_insert_dt            DATE := null;
my_update_dt            DATE := null;

BEGIN 
    ps_location := 'PFSA 00';            -- For std_pfsawh_debug_tbl logging. 

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_physical_item_id: ' || v_physical_item_id || ', ' || 
           'type_maintenance:   ' || type_maintenance
           );
    END IF;  
    
    ps_id_key := nvl(type_maintenance, ps_procedure_name);

    cv_physical_item_id := v_physical_item_id;

    SELECT  niin,   item_nomen_standard 
    INTO    v_niin, v_item_nomen_standard  
    FROM    pfsawh_item_dim    
    WHERE   physical_item_id = v_physical_item_id;

    -- Get the process control values from PFSAWH_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');


    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_etl_copy_cutoff_days: ' || v_etl_copy_cutoff_days || ', ' || 
           'v_etl_copy_cutoff'        || v_etl_copy_cutoff
           );
    END IF;  

        proc0.process_RecId      := 740; 
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
           proc0.user_Login_Id, NULL, proc0_recId
           );  
                
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  


    -- Housekeeping for the process 
    -- get the run criteria from the pfsa_processes table for the last run of this 
    -- main process 
      get_pfsawh_process_info ( 
        ps_procedure_name, ps_procedure_name, ps_last_process.last_run, 
        ps_last_process.who_ran, ps_last_process.last_run_status, 
        ps_last_process.last_run_status_time, ps_last_process.last_run_compl
        );
 

    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_compl       := ps_last_process.last_run_compl;


    -- Update the PFSA_PROCESSES table to indicate MAIN process began.  

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, 'BEGAN', 
        SYSDATE, ps_this_process.last_run_compl
        );
      

/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 740; 
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
        
     
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
    ps_location := 'PFSA 100';            -- For std_pfsawh_debug_tbl logging. 
     
    -- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    select max(insert_date) into my_insert_dt from frz_pfsa_maint_event;
    select max(update_date) into my_update_dt from frz_pfsa_maint_event;
    
    if (my_insert_dt is null) or (my_update_dt is null) then
       my_lst_updt := add_months (sysdate, -30);
    elsif my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
    
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
    
--  Commented out columns are not supposed to be in the Freeze tables
--      or have been replaced by another column.    
    INSERT 
    INTO   frz_pfsa_maint_event_tmp 
        (
         rec_id, source_rec_id, pba_id,
         physical_item_id, physical_item_sn_id, force_unit_id,
         mimosa_item_sn_id, maint_ev_id, maint_org,
         maint_uic, maint_lvl_cd, maint_item,
         maint_item_niin, maint_item_sn, num_maint_item,
         sys_ei_niin, sys_ei_sn, num_mi_nrts,
         num_mi_rprd, num_mi_cndmd, num_mi_neof,
         dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm,
         phase_ev, sof_ev, asam_ev,
         mwo_ev, elapsed_me_wk_tm, source_id,
         heir_id, priority, cust_org,
         cust_uic, 
--         maint_event_id_part1, maint_event_id_part2,
         fault_malfunction_descr, won, 
--         last_wo_status,
--         last_wo_status_date, 
         ridb_on_time_flag, report_date,
         status, lst_updt, updt_by,
         frz_input_date, frz_input_date_id, rec_frz_flag,
         frz_date, active_flag, active_date,
         inactive_date, insert_by, insert_date,
         update_by, update_date, delete_flag,
         delete_date, delete_by, hidden_flag,
         hidden_date, hidden_by
        )
    SELECT
         rec_id, source_rec_id, pba_id,
         cv_physical_item_id, 
         fn_pfsawh_get_item_sn_dim_id(v_niin, 
                                      NVL(sys_ei_sn, 0)) AS physical_item_sn_id,
         force_unit_id,
         mimosa_item_sn_id, maint_ev_id, maint_org,
         maint_uic, maint_lvl_cd, maint_item,
         maint_item_niin, maint_item_sn, num_maint_item,
         sys_ei_niin, sys_ei_sn, num_mi_nrts,
         num_mi_rprd, num_mi_cndmd, num_mi_neof,
         dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm,
         phase_ev, sof_ev, asam_ev,
         mwo_ev, elapsed_me_wk_tm, source_id,
         heir_id, priority, cust_org,
         cust_uic, 
--         maint_event_id_part1, maint_event_id_part2,
         fault_malfunction_descr, won, 
--         last_wo_status,
--         last_wo_status_date, 
         ridb_on_time_flag, report_date,
         status, lst_updt, updt_by,
         frz_input_date, frz_input_date_id, rec_frz_flag,
         frz_date, active_flag, active_date,
         inactive_date, insert_by, insert_date,
         update_by, update_date, delete_flag,
         delete_date, delete_by, hidden_flag,
         hidden_date, hidden_by
    FROM   frz_pfsa_maint_event@pfsaw.lidb
    WHERE sys_ei_niin  = v_niin  
-- 03Dec08 - G. Belford - Removed the date limit on the select since this 
--                          is a NIIN reload. 
--       AND (insert_date > my_lst_updt or update_date > my_lst_updt) 
       AND delete_flag = 'N'
       AND hidden_flag = 'N';

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    -- Set warehouse ids    
    -- FORCE 

    UPDATE frz_pfsa_maint_event_tmp f
    SET    force_unit_id = 
            (
            SELECT NVL(force_unit_id, -1)  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = f.cust_uic 
                AND status = 'C'
            )
    WHERE  f.physical_item_id = cv_physical_item_id
        AND (   f.force_unit_id IS NULL 
             OR f.force_unit_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- MIMOSA      

    UPDATE frz_pfsa_maint_event_tmp 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE   physical_item_id = cv_physical_item_id 
        AND physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;  
      
    ps_location := 'PFSA 104';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   frz_pfsa_maint_event pme
    USING  (SELECT 
               rec_id, source_rec_id, pba_id,
               physical_item_id, physical_item_sn_id, force_unit_id,
               mimosa_item_sn_id, maint_ev_id, maint_org,
               maint_uic, maint_lvl_cd, maint_item,
               maint_item_niin, maint_item_sn, num_maint_item,
               sys_ei_niin, sys_ei_sn, num_mi_nrts,
               num_mi_rprd, num_mi_cndmd, num_mi_neof,
               dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm,
               phase_ev, sof_ev, asam_ev,
               mwo_ev, elapsed_me_wk_tm, source_id,
               heir_id, priority, cust_org,
               cust_uic, 
--               maint_event_id_part1, maint_event_id_part2,
               fault_malfunction_descr, won, 
--               last_wo_status,
--               last_wo_status_date, 
               ridb_on_time_flag, report_date,
               status, lst_updt, updt_by,
               frz_input_date, frz_input_date_id, rec_frz_flag,
               frz_date, active_flag, active_date,
               inactive_date, insert_by, insert_date,
               update_by, update_date, delete_flag,
               delete_date, delete_by, hidden_flag,
               hidden_date, hidden_by
            FROM   frz_pfsa_maint_event_tmp ) tmp 
    ON     (    tmp.physical_item_id = cv_physical_item_id
            AND tmp.rec_id = pme.rec_id) 
    WHEN MATCHED THEN 
        UPDATE SET   
            pme.source_rec_id = tmp.source_rec_id, 
            pme.pba_id = tmp.pba_id,
            pme.physical_item_sn_id = tmp.physical_item_sn_id, 
            pme.force_unit_id = tmp.force_unit_id,
            pme.mimosa_item_sn_id = tmp.mimosa_item_sn_id,
            pme.maint_ev_id              = tmp.maint_ev_id,            
            pme.maint_org = tmp.maint_org, 
            pme.maint_uic = tmp.maint_uic, 
            pme.maint_lvl_cd = tmp.maint_lvl_cd,
            pme.maint_item = tmp.maint_item, 
            pme.maint_item_niin = tmp.maint_item_niin, 
            pme.maint_item_sn = tmp.maint_item_sn, 
            pme.num_maint_item = tmp.num_maint_item,
            pme.sys_ei_niin = tmp.sys_ei_niin, 
            pme.sys_ei_sn = tmp.sys_ei_sn,
            pme.num_mi_nrts = tmp.num_mi_nrts, 
            pme.num_mi_rprd = tmp.num_mi_rprd, 
            pme.num_mi_cndmd = tmp.num_mi_cndmd, 
            pme.num_mi_neof = tmp.num_mi_neof,
            pme.dt_maint_ev_est = tmp.dt_maint_ev_est, 
            pme.dt_maint_ev_cmpl = tmp.dt_maint_ev_cmpl, 
            pme.sys_ei_nmcm = tmp.sys_ei_nmcm, 
            pme.phase_ev = tmp.phase_ev, 
            pme.sof_ev = tmp.sof_ev, 
            pme.asam_ev = tmp.asam_ev, 
            pme.mwo_ev = tmp.mwo_ev, 
            pme.elapsed_me_wk_tm = tmp.elapsed_me_wk_tm,
            pme.source_id = tmp.source_id, 
            pme.heir_id = tmp.heir_id, 
            pme.priority = tmp.priority, 
            pme.cust_org = tmp.cust_org, 
            pme.cust_uic = tmp.cust_uic,
            pme.fault_malfunction_descr = tmp.fault_malfunction_descr, 
            pme.won = tmp.won, 
            pme.ridb_on_time_flag = tmp.ridb_on_time_flag,
            pme.report_date = tmp.report_date, 
            pme.status = tmp.status, 
            pme.lst_updt = tmp.lst_updt, 
            pme.updt_by = tmp.updt_by,
            pme.frz_input_date = tmp.frz_input_date, 
            pme.frz_input_date_id = tmp.frz_input_date_id,
            pme.rec_frz_flag = tmp.rec_frz_flag,
            pme.frz_date =  tmp.frz_date, 
            pme.active_flag = tmp.active_flag, 
            pme.active_date = tmp.active_date, 
            pme.inactive_date = tmp.inactive_date, 
            pme.insert_by = tmp.insert_by, 
            pme.insert_date = tmp.insert_date,
            pme.update_by = tmp.update_by, 
            pme.update_date = tmp.update_date, 
            pme.delete_flag = tmp.delete_flag, 
            pme.delete_date = tmp.delete_date, 
            pme.delete_by = tmp.delete_by,
            pme.hidden_flag = tmp.hidden_flag, 
            pme.hidden_date = tmp.hidden_date, 
            pme.hidden_by = tmp.hidden_by 
--            pme.last_wo_status = tmp.last_wo_status, 
--            pme.last_wo_status_date = tmp.last_wo_status_date,
--            pme.maint_event_id_part1 = tmp.maint_event_id_part1, 
--            pme.maint_event_id_part2 = tmp.maint_event_id_part2
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id, source_rec_id, pba_id,
                physical_item_id, physical_item_sn_id, force_unit_id,
                mimosa_item_sn_id, maint_ev_id, maint_org,
                maint_uic, maint_lvl_cd, maint_item,
                maint_item_niin, maint_item_sn, num_maint_item,
                sys_ei_niin, sys_ei_sn, num_mi_nrts,
                num_mi_rprd, num_mi_cndmd, num_mi_neof,
                dt_maint_ev_est, dt_maint_ev_cmpl, sys_ei_nmcm,
                phase_ev, sof_ev, asam_ev,
                mwo_ev, elapsed_me_wk_tm, source_id,
                heir_id, priority, cust_org,
                cust_uic, 
--                maint_event_id_part1, maint_event_id_part2,
                fault_malfunction_descr, won, 
--                last_wo_status,
--                last_wo_status_date, 
                ridb_on_time_flag, report_date,
                status, lst_updt, updt_by,
                frz_input_date, frz_input_date_id, rec_frz_flag,
                frz_date, active_flag, active_date,
                inactive_date, insert_by, insert_date,
                update_by, update_date, delete_flag,
                delete_date, delete_by, hidden_flag,
                hidden_date, hidden_by
               )
        VALUES (
               tmp.rec_id, tmp.source_rec_id, tmp.pba_id,
               tmp.physical_item_id, tmp.physical_item_sn_id, tmp.force_unit_id,
               tmp.mimosa_item_sn_id, tmp.maint_ev_id, tmp.maint_org,
               tmp.maint_uic, tmp.maint_lvl_cd, tmp.maint_item,
               tmp.maint_item_niin, tmp.maint_item_sn, tmp.num_maint_item,
               tmp.sys_ei_niin, tmp.sys_ei_sn, tmp.num_mi_nrts,
               tmp.num_mi_rprd, tmp.num_mi_cndmd, tmp.num_mi_neof,
               tmp.dt_maint_ev_est, tmp.dt_maint_ev_cmpl, tmp.sys_ei_nmcm,
               tmp.phase_ev, tmp.sof_ev, tmp.asam_ev,
               tmp.mwo_ev, tmp.elapsed_me_wk_tm, tmp.source_id,
               tmp.heir_id, tmp.priority, tmp.cust_org,
               tmp.cust_uic, tmp.
--               tmp.maint_event_id_part1, tmp.maint_event_id_part2,
               tmp.fault_malfunction_descr, tmp.won, tmp.
--               tmp.last_wo_status,
--               tmp.last_wo_status_date, tmp.
               tmp.ridb_on_time_flag, tmp.report_date,
               tmp.status, tmp.lst_updt, tmp.updt_by,
               tmp.frz_input_date, tmp.frz_input_date_id, tmp.rec_frz_flag,
               tmp.frz_date, tmp.active_flag, tmp.active_date,
               tmp.inactive_date, tmp.insert_by, tmp.insert_date,
               tmp.update_by, tmp.update_date, tmp.delete_flag,
               tmp.delete_date, tmp.delete_by, tmp.hidden_flag,
               tmp.hidden_date, tmp.hidden_by
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    ps_location := 'PFSA 105';            -- For std_pfsawh_debug_tbl logging.

--#@$#@#$    pr_upd_pfsa_fcs_sys_dates (ps_this_process.who_ran, 'MAINT_EVENT_PERIOD_DATE'); 
    
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
            
/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 740; 
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

  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
    ps_location := 'PFSA 110';            -- For std_pfsawh_debug_tbl logging. 
         
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_maint_items_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_items_tmp';
       truncate_a_table (mytablename);
    END IF;
    
--    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
--    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
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

--    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
--    COMMIT; 
    
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

--    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
--    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_maint_items_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_maint_items_tmp';
       truncate_a_table (mytablename);
    END IF;
    
--    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
--    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/

        -- replace proc1 processing if the previous work in re-opened.
 
 /*----------------------------------------------------------------------------*/ 
/*----- Start of actual work   for FRZ_PFSA_MAINT_TASK                   -----*/  
/*----------------------------------------------------------------------------*/ 
    ps_location := 'PFSA 115';            -- For std_pfsawh_debug_tbl logging.
    
    -- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    select max(insert_date) into my_insert_dt from frz_pfsa_maint_task;
    select max(update_date) into my_update_dt from frz_pfsa_maint_task;
    
    if (my_insert_dt is null) or (my_update_dt is null) then
       my_lst_updt := add_months (sysdate, -30);
    elsif my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
       
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
        rec_id, source_rec_id,
        pba_id, physical_item_id,
        physical_item_sn_id,
        force_unit_id,
        mimosa_item_sn_id,
        maint_ev_id, maint_task_id,
        elapsed_tsk_wk_tm,
        elapsed_part_wt_tm, tsk_begin,
        tsk_end, inspect_tsk,
        tsk_was_def, sched_unsched,
        essential, heir_id,
        priority, status,
        lst_updt, updt_by,
        frz_input_date,
        frz_input_date_id,
        rec_frz_flag, frz_date,
        insert_by, insert_date,
        update_by, update_date,
        delete_flag, delete_date,
        delete_by, hidden_flag,
        hidden_date, hidden_by
        )
    SELECT 
        pmt.rec_id, pmt.source_rec_id,
        pmt.pba_id, cv_physical_item_id,
        fn_pfsawh_get_item_sn_dim_id(v_niin, 
                                      NVL(pme.sys_ei_sn, 0)) AS physical_item_sn_id,
        pmt.force_unit_id,
        pmt.mimosa_item_sn_id,
        pmt.maint_ev_id, pmt.maint_task_id,
        pmt.elapsed_tsk_wk_tm,
        pmt.elapsed_part_wt_tm, pmt.tsk_begin,
        pmt.tsk_end, pmt.inspect_tsk,
        pmt.tsk_was_def, pmt.sched_unsched,
        pmt.essential, pmt.heir_id,
        pmt.priority, pmt.status,
        pmt.lst_updt, pmt.updt_by,
        pmt.frz_input_date,
        pmt.frz_input_date_id,
        pmt.rec_frz_flag, pmt.frz_date,
        pmt.insert_by, pmt.insert_date,
        pmt.update_by, pmt.update_date,
        pmt.delete_flag, pmt.delete_date,
        pmt.delete_by, pmt.hidden_flag,
        pmt.hidden_date, pmt.hidden_by
    FROM   frz_pfsa_maint_task@pfsaw.lidb pmt, 
           frz_pfsa_maint_event@pfsaw.lidb pme
    WHERE pme.sys_ei_niin  = v_niin 
       AND pme.pba_id      = pmt.pba_id
       AND pme.maint_ev_id = pmt.maint_ev_id
-- 03Dec08 - G. Belford - Removed the date limit on the select since this 
--                          is a NIIN reload. 
--       AND (pme.insert_date > my_lst_updt or pme.update_date > my_lst_updt) 
       AND pmt.delete_flag = 'N'
       AND pmt.hidden_flag = 'N';
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;
    
    COMMIT;
    
    -- Set warehouse ids    
    -- FORCE 

    UPDATE frz_pfsa_maint_task_tmp f
    SET    force_unit_id = 
            (
            SELECT distinct NVL(force_unit_id, -1)  
            FROM   frz_pfsa_maint_event 
            WHERE  physical_item_id = cv_physical_item_id
               AND maint_ev_id = f.MAINT_EV_ID
            )
    WHERE  f.physical_item_id = cv_physical_item_id
        AND (   f.force_unit_id IS NULL 
             OR f.force_unit_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- MIMOSA      

    UPDATE frz_pfsa_maint_task_tmp 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE   physical_item_id = cv_physical_item_id 
        AND physical_item_sn_id >= 0 
        AND (   mimosa_item_sn_id IS NULL 
             OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;  
     
    MERGE  
    INTO   frz_pfsa_maint_task pmt 
    USING  (SELECT 
               rec_id, source_rec_id,
               pba_id, physical_item_id,
               physical_item_sn_id,
               force_unit_id,
               mimosa_item_sn_id,
               maint_ev_id, maint_task_id,
               elapsed_tsk_wk_tm,
               elapsed_part_wt_tm, tsk_begin,
               tsk_end, inspect_tsk,
               tsk_was_def, sched_unsched,
               essential, heir_id,
               priority, status,
               lst_updt, updt_by,
               frz_input_date,
               frz_input_date_id,
               rec_frz_flag, frz_date,
               insert_by, insert_date,
               update_by, update_date,
               delete_flag, delete_date,
               delete_by, hidden_flag,
               hidden_date, hidden_by
            FROM   frz_pfsa_maint_task_tmp ) tmp 
    ON     (   tmp.physical_item_id = cv_physical_item_id
           AND tmp.rec_id    = pmt.rec_id 
           )  
    WHEN MATCHED THEN 
        UPDATE SET   
            pmt.source_rec_id = tmp.source_rec_id, 
            pmt.pba_id = tmp.pba_id,
            pmt.physical_item_sn_id = tmp.physical_item_sn_id, 
            pmt.force_unit_id = tmp.force_unit_id,
            pmt.mimosa_item_sn_id = tmp.mimosa_item_sn_id,
            pmt.maint_ev_id              = tmp.maint_ev_id,            
            pmt.maint_task_id              = tmp.maint_task_id,            
            pmt.elapsed_tsk_wk_tm = tmp.elapsed_tsk_wk_tm,
            pmt.elapsed_part_wt_tm = tmp.elapsed_part_wt_tm,
            pmt.tsk_begin = tmp.tsk_begin,
            pmt.tsk_end = tmp.tsk_end,
            pmt.inspect_tsk = tmp.inspect_tsk,
            pmt.tsk_was_def = tmp.tsk_was_def,
            pmt.sched_unsched = tmp.sched_unsched,
            pmt.essential = tmp.essential,
            pmt.heir_id = tmp.heir_id,
            pmt.priority = tmp.priority,
            pmt.status = tmp.status,
            pmt.lst_updt = tmp.lst_updt,
            pmt.updt_by = tmp.updt_by,
            pmt.frz_input_date = tmp.frz_input_date, 
            pmt.frz_input_date_id = tmp.frz_input_date_id,
            pmt.rec_frz_flag = tmp.rec_frz_flag,
            pmt.frz_date =  tmp.frz_date, 
            pmt.insert_by = tmp.insert_by, 
            pmt.insert_date = tmp.insert_date,
            pmt.update_by = tmp.update_by, 
            pmt.update_date = tmp.update_date, 
            pmt.delete_flag = tmp.delete_flag, 
            pmt.delete_date = tmp.delete_date, 
            pmt.delete_by = tmp.delete_by,
            pmt.hidden_flag = tmp.hidden_flag, 
            pmt.hidden_date = tmp.hidden_date, 
            pmt.hidden_by = tmp.hidden_by 
    WHEN NOT MATCHED THEN 
        INSERT (
               rec_id, source_rec_id,
               pba_id, physical_item_id,
               physical_item_sn_id,
               force_unit_id,
               mimosa_item_sn_id,
               maint_ev_id, maint_task_id,
               elapsed_tsk_wk_tm,
               elapsed_part_wt_tm, tsk_begin,
               tsk_end, inspect_tsk,
               tsk_was_def, sched_unsched,
               essential, heir_id,
               priority, status,
               lst_updt, updt_by,
               frz_input_date,
               frz_input_date_id,
               rec_frz_flag, frz_date,
               insert_by, insert_date,
               update_by, update_date,
               delete_flag, delete_date,
               delete_by, hidden_flag,
               hidden_date, hidden_by
                )
        VALUES (
                tmp.rec_id, tmp.source_rec_id, 
                tmp.pba_id, tmp.physical_item_id, 
                tmp.physical_item_sn_id, 
                tmp.force_unit_id,
                tmp.mimosa_item_sn_id,
                tmp.maint_ev_id, tmp.maint_task_id,
                tmp.elapsed_tsk_wk_tm, 
                tmp.elapsed_part_wt_tm, tmp.tsk_begin, 
                tmp.tsk_end, tmp.inspect_tsk, 
                tmp.tsk_was_def, tmp.sched_unsched, 
                tmp.essential, tmp.heir_id, 
                tmp.priority, tmp.status,  
                tmp.lst_updt, tmp.updt_by,
                tmp.frz_input_date, 
                tmp.frz_input_date_id, 
                tmp.rec_frz_flag, tmp.frz_date, 
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, 
                tmp.delete_flag, tmp.delete_date, 
                tmp.delete_by, tmp.hidden_flag,
                tmp.hidden_date, tmp.hidden_by
               ); 

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;
    
    COMMIT; 

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

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 740; 
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
       
    COMMIT;  
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work      for FRZ_PFSA_MAINT_WORK                -----*/  
/*----------------------------------------------------------------------------*/ 
    ps_location := 'PFSA 130';            -- For std_pfsawh_debug_tbl logging. 
 
    -- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    select max(insert_date) into my_insert_dt from frz_pfsa_maint_work;
    select max(update_date) into my_update_dt from frz_pfsa_maint_work;
    
    if (my_insert_dt is null) or (my_update_dt is null) then
       my_lst_updt := add_months (sysdate, -30);
    elsif my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
    
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
    
    INSERT 
    INTO   frz_pfsa_maint_work_tmp 
        (
         rec_id, source_rec_id,
         pba_id, physical_item_id,
         physical_item_sn_id,
         force_unit_id,
         mimosa_item_sn_id,
         maint_ev_id, maint_task_id,
         maint_work_id, maint_work_mh,
         mil_civ_kon, mos,
         spec_person, repair,
         mos_sent, heir_id,
         priority, status,
         lst_updt, updt_by,
         frz_input_date,
         frz_input_date_id,
         rec_frz_flag, frz_date,
         insert_by, insert_date,
         update_by, update_date,
         delete_flag, delete_date,
         delete_by, hidden_flag,
         hidden_date, hidden_by        
        )
    SELECT 
         pmw.rec_id, pmw.source_rec_id,
         pmw.pba_id, cv_physical_item_id,
         fn_pfsawh_get_item_sn_dim_id(v_niin, 
                                      NVL(pme.sys_ei_sn, 0)) AS physical_item_sn_id,
         pmw.force_unit_id,
         pmw.mimosa_item_sn_id,
         pmw.maint_ev_id, pmw.maint_task_id,
         maint_work_id, maint_work_mh,
         mil_civ_kon, mos,
         spec_person, repair,
         mos_sent, pmw.heir_id,
         pmw.priority, pmw.status,
         pmw.lst_updt, pmw.updt_by,
         pmw.frz_input_date,
         pmw.frz_input_date_id,
         pmw.rec_frz_flag, pmw.frz_date,
         pmw.insert_by, pmw.insert_date,
         pmw.update_by, pmw.update_date,
         pmw.delete_flag, pmw.delete_date,
         pmw.delete_by, pmw.hidden_flag,
         pmw.hidden_date, pmw.hidden_by                 
    FROM   frz_pfsa_maint_work@pfsaw.lidb pmw, 
           frz_pfsa_maint_task@pfsaw.lidb pmt, 
           frz_pfsa_maint_event@pfsaw.lidb pme
    WHERE pme.sys_ei_niin     = v_niin
        AND pme.pba_id        = pmt.pba_id
        AND pme.maint_ev_id   = pmt.maint_ev_id 
        AND pmt.pba_id        = pmw.pba_id
        AND pmt.maint_ev_id   = pmw.maint_ev_id  
        AND pmt.maint_task_id = pmw.maint_task_id
-- 03Dec08 - G. Belford - Removed the date limit on the select since this 
--                          is a NIIN reload. 
--        AND (pmw.insert_date > my_lst_updt or pmw.update_date > my_lst_updt) 
        AND pmw.delete_flag   = 'N'
        AND pmw.hidden_flag   = 'N';

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    -- Set warehouse ids    
    -- FORCE 

    UPDATE frz_pfsa_maint_work_tmp f
    SET    force_unit_id = 
            (
            SELECT distinct NVL(force_unit_id, -1)  
            FROM   frz_pfsa_maint_event 
            WHERE  physical_item_id = cv_physical_item_id
               AND maint_ev_id = f.MAINT_EV_ID
            )
    WHERE  f.physical_item_id = cv_physical_item_id
        AND (   f.force_unit_id IS NULL 
             OR f.force_unit_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- MIMOSA      

    UPDATE frz_pfsa_maint_work_tmp 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE   physical_item_id = cv_physical_item_id 
        AND physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;  
    
    MERGE  
    INTO   frz_pfsa_maint_work pmw 
    USING  (SELECT 
               rec_id, source_rec_id,
               pba_id, physical_item_id,
               physical_item_sn_id,
               force_unit_id,
               mimosa_item_sn_id,
               maint_ev_id, maint_task_id,
               maint_work_id, maint_work_mh,
               mil_civ_kon, mos,
               spec_person, repair,
               mos_sent, heir_id,
               priority, status,
               lst_updt, updt_by,
               frz_input_date,
               frz_input_date_id,
               rec_frz_flag, frz_date,
               insert_by, insert_date,
               update_by, update_date,
               delete_flag, delete_date,
               delete_by, hidden_flag,
               hidden_date, hidden_by        
            FROM   frz_pfsa_maint_work_tmp ) tmp 
    ON     (    tmp.physical_item_id = cv_physical_item_id 
            AND pmw.rec_id    = tmp.rec_id
            )  
    WHEN MATCHED THEN 
        UPDATE SET   
            pmw.source_rec_id = tmp.source_rec_id, 
            pmw.pba_id = tmp.pba_id,
            pmw.physical_item_sn_id = tmp.physical_item_sn_id, 
            pmw.force_unit_id = tmp.force_unit_id,
            pmw.mimosa_item_sn_id = tmp.mimosa_item_sn_id,
            pmw.maint_ev_id             = tmp.maint_ev_id,            
            pmw.maint_task_id              = tmp.maint_task_id,            
            pmw.maint_work_id              = tmp.maint_work_id,            
            pmw.maint_work_mh = tmp.maint_work_mh,
            pmw.mil_civ_kon = tmp.mil_civ_kon,
            pmw.mos = tmp.mos,
            pmw.spec_person = tmp.spec_person,
            pmw.repair = tmp.repair,
            pmw.mos_sent = tmp.mos_sent,
            pmw.heir_id = tmp.heir_id,
            pmw.priority = tmp.priority,
            pmw.status = tmp.status,
            pmw.lst_updt = tmp.lst_updt,
            pmw.updt_by = tmp.updt_by,
            pmw.frz_input_date = tmp.frz_input_date, 
            pmw.frz_input_date_id = tmp.frz_input_date_id,
            pmw.rec_frz_flag = tmp.rec_frz_flag,
            pmw.frz_date =  tmp.frz_date, 
            pmw.insert_by = tmp.insert_by, 
            pmw.insert_date = tmp.insert_date,
            pmw.update_by = tmp.update_by, 
            pmw.update_date = tmp.update_date, 
            pmw.delete_flag = tmp.delete_flag, 
            pmw.delete_date = tmp.delete_date, 
            pmw.delete_by = tmp.delete_by,
            pmw.hidden_flag = tmp.hidden_flag, 
            pmw.hidden_date = tmp.hidden_date, 
            pmw.hidden_by = tmp.hidden_by 
    WHEN NOT MATCHED THEN 
        INSERT (
               rec_id, source_rec_id,
               pba_id, physical_item_id,
               physical_item_sn_id,
               force_unit_id,
               mimosa_item_sn_id,
               maint_ev_id, maint_task_id,
               maint_work_id, maint_work_mh,
               mil_civ_kon, mos,
               spec_person, repair,
               mos_sent, heir_id,
               priority, status,
               lst_updt, updt_by,
               frz_input_date,
               frz_input_date_id,
               rec_frz_flag, frz_date,
               insert_by, insert_date,
               update_by, update_date,
               delete_flag, delete_date,
               delete_by, hidden_flag,
               hidden_date, hidden_by        
                )
        VALUES (
                tmp.rec_id, tmp.source_rec_id, 
                tmp.pba_id, tmp.physical_item_id, 
                tmp.physical_item_sn_id, 
                tmp.force_unit_id,
                tmp.mimosa_item_sn_id,
                tmp.maint_ev_id, tmp.maint_task_id, 
                tmp.maint_work_id, tmp.maint_work_mh, 
                tmp.mil_civ_kon, tmp.mos, 
                tmp.spec_person, tmp.repair, 
                tmp.mos_sent, tmp.heir_id, 
                tmp.priority, tmp.status, 
                tmp.lst_updt, tmp.updt_by,
                tmp.frz_input_date, 
                tmp.frz_input_date_id, 
                tmp.rec_frz_flag, tmp.frz_date, 
                tmp.insert_by, tmp.insert_date,
                tmp.update_by, tmp.update_date, 
                tmp.delete_flag, tmp.delete_date, 
                tmp.delete_by, tmp.hidden_flag,
                tmp.hidden_date, tmp.hidden_by                
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

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 740; 
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
        
    
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                    Populate pfsawh_maint_itm_wrk_fact                      */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 
    ps_location := 'PFSA 135';            -- For std_pfsawh_debug_tbl logging. 

    DELETE pfsawh_maint_itm_wrk_fact
    WHERE  physical_item_id = cv_physical_item_id;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT; 
    

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
        FROM   frz_pfsa_maint_event ev, 
               frz_pfsa_maint_task tk,
               frz_pfsa_maint_work wk 
        WHERE  ev.PHYSICAL_ITEM_ID   = cv_physical_item_id  
            AND tk.pba_id (+)        = ev.pba_id
            AND tk.maint_ev_id (+)   = ev.maint_ev_id
            AND wk.pba_id (+)        = tk.pba_id 
            AND wk.maint_ev_id (+)   = tk.maint_ev_id 
            AND wk.maint_task_id (+) = tk.maint_task_id
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
        tsk_begin_date_id, 
        tsk_begin_time_id, 
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item_id, 
        physical_item_sn_id, 
        mimosa_item_sn_id, 
        force_unit_id, 
        pba_id, 
        maint_ev_id_a, 
        maint_ev_id_b, 
        maint_task_id, 
        maint_work_id, 
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
        won, 
        etl_processed_by                           
        )
        VALUES 
        (
        metw.tsk_begin_date_id, 
        metw.tsk_begin_time_id, 
        metw.tsk_end_date_id, 
        metw.tsk_end_time_id, 
        metw.physical_item_id, 
        metw.physical_item_sn_id, 
        metw.mimosa_item_sn_id, 
        metw.force_unit_id, 
        metw.pba_id, 
        metw.maint_ev_id_a, 
        metw.maint_ev_id_b, 
        metw.maint_task_id, 
        metw.maint_work_id, 
        metw.maint_org, 
        metw.maint_uic, 
        metw.maint_lvl_cd, 
        metw.elapsed_tsk_wk_tm, 
        metw.inspect_tsk, 
        metw.essential, 
        metw.maint_work_mh, 
        metw.mil_civ_kon, 
        metw.mos, 
        metw.spec_person, 
        metw.repair, 
        metw.mos_sent,
        metw.cust_org,
        metw.cust_uic,
        metw.evnt_begin_date_id,
        metw.evnt_cmpl_date_id,
        metw.fault_malfunction_descr,
        metw.won, 
        ps_procedure_name                           
        );  
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 

    ps_location := 'PFSA 140';            -- For std_pfsawh_debug_tbl logging. 

    UPDATE  pfsawh_maint_itm_wrk_fact f
    SET     tsk_days_to_cmplt = f.evnt_cmpl_date_id - f.evnt_begin_date_id 
    WHERE   f.physical_item_id = cv_physical_item_id;  

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;
    
    -- calsulate date_cmplt_readiness_prd_id

    UPDATE  pfsawh_maint_itm_wrk_fact f
    SET     date_cmplt_readiness_prd_id = 
                (
                SELECT fn_date_to_date_id(b.READY_DATE) 
                FROM    pfsawh_ready_date_dim   b
                WHERE   b.date_dim_id = f.evnt_cmpl_date_id  
                )
    WHERE   f.physical_item_id = cv_physical_item_id
        AND f.date_cmplt_readiness_prd_id IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    UPDATE  pfsawh_maint_itm_wrk_fact a
    SET     date_cmplt_readiness_prd_id = 
                (
                SELECT fn_date_to_date_id(b.READY_DATE) 
                FROM    pfsawh_ready_date_dim   b
                WHERE   a.EVNT_CMPL_DATE_ID = b.DATE_DIM_ID
                )
    WHERE   a.physical_item_id = cv_physical_item_id;
     
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- calculate dpfsawh_item_sn_p_fact - maint_action_cnt & total_down_time -

   MERGE INTO pfsawh_item_sn_p_fact pf
   USING        (
                SELECT  physical_item_id, physical_item_sn_id, pba_id, force_unit_id, 
                        date_cmplt_readiness_prd_id,
                        COUNT(physical_item_sn_id) as act_cnt, 
                        SUM(tsk_days_to_cmplt) as tdt 
                FROM    pfsawh_maint_itm_wrk_fact
                WHERE   physical_item_id = 307543
                    AND pba_id in (select pba_id 
                                      from pfsa_pba_ref pba 
                                      WHERE  pba.pba_key1 <> 'USA') 
                GROUP BY physical_item_id, physical_item_sn_id, pba_id, force_unit_id, 
                        date_cmplt_readiness_prd_id 
                )iwf 
   ON  (   pf.physical_item_id    = iwf.physical_item_id
       AND pf.physical_item_sn_id = iwf.physical_item_sn_id
       AND pf.pba_id              = iwf.pba_id 
       AND pf.ITEM_FORCE_ID       = iwf.force_unit_id
       AND pf.item_date_to_id     = iwf.date_cmplt_readiness_prd_id )
 WHEN MATCHED THEN UPDATE SET
     maint_action_cnt = act_cnt, 
     total_down_time  = tdt;
     
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

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

    -- Update the pfsa_process table to indicate main process has ended.  
    -- Housekeeping for the end of the MAIN process 
    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, 'COMPLETE',  
        SYSDATE, SYSDATE
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

END etl_pfsa_maint_frz_niin; -- end of procedure
/
