/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_pfsa_pba 
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 23 October 2008 
--
--          SP Source: etl_pfsa_pba.sql 
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
--
--  This is the main controlling procedure for maintaining the logical 
--  construct of the PFSA world.
--
--  It is not a data loading procedure, and should be called prior to the 
--  actual running of any data loads.  The value type_maintenance is a place 
--  holder for segregation of future implementation issues as well as
--  to accomodate special procedures which may need to be handled separately
--
--  Created 18 Jan 04 by Dave Hendricks
--             
--  Production Date 25 Sep 2004
--            
--  Modification Date 24 Apr 2007 added the grab_new_geo_data procedure call 
--  and corrected the calls to org data
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 23OCT08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/* 

BEGIN 

    etl_pfsa_pba ('GBelford'); 
    
    COMMIT; 

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_pfsa_pba    
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_PFSA_PBA';  /*  */
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

-- module variables (v_)

v_debug                 NUMBER        := 0; 

BEGIN

    proc0.process_RecId      := 600; 
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
        
    proc1.process_RecId      := 600; 
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
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := nvl(type_maintenance, 'GENERIC PBA ETL');

-- HOUSEKEEP the process 
  
    ps_location := 'HOUSEKEEP';

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

    ps_location                     := 'PBA';
    ls_current_process.pfsa_process := 'MERGE PBA REF'; 
  
    proc1.rec_Read_Int              := NULL; 

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

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

-- Update the pfsa_processes table to indicate the sub-process 
-- MERGE PBA REF has started.  

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

    SELECT COUNT(pba_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_ref ppr 
    USING  (SELECT 
            pba_id,
            pba_key1, pba_key2, pba_seq,
            pba_title, pba_point_of_contact, pba_description,
            pba_agreement_date_id, 
            pba_status_code, pba_from_date_id, pba_to_date_id, 
            pba_lifecyle_logistics_phase, pba_retention_period,
            pba_freeze_flag,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date
            FROM   pfsa_pba_ref@pfsaw.lidb ) tmp 
    ON     (ppr.pba_id = tmp.pba_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.pba_id             = tmp.pba_id,            
            ppr.pba_key1 = tmp.pba_key1, 
            ppr.pba_key2 = tmp.pba_key2, 
            ppr.pba_seq = tmp.pba_seq,
            ppr.pba_title = tmp.pba_title, 
            ppr.pba_point_of_contact = tmp.pba_point_of_contact, 
            ppr.pba_description = tmp.pba_description,
            ppr.pba_agreement_date_id = tmp.pba_agreement_date_id, 
            ppr.pba_status_code = tmp.pba_status_code, 
            ppr.pba_from_date_id = tmp.pba_from_date_id, 
            ppr.pba_to_date_id = tmp.pba_to_date_id, 
            ppr.pba_lifecyle_logistics_phase = tmp.pba_lifecyle_logistics_phase, 
            ppr.pba_retention_period = tmp.pba_retention_period,
            ppr.pba_freeze_flag = tmp.pba_freeze_flag,
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
                pba_id,
                pba_key1, pba_key2, pba_seq,
                pba_title, pba_point_of_contact, pba_description,
                pba_agreement_date_id, 
                pba_status_code, pba_from_date_id, pba_to_date_id, 
                pba_lifecyle_logistics_phase, pba_retention_period,
                pba_freeze_flag,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.pba_id,
                tmp.pba_key1, tmp.pba_key2, tmp.pba_seq,
                tmp.pba_title, tmp.pba_point_of_contact, tmp.pba_description,
                tmp.pba_agreement_date_id, 
                tmp.pba_status_code, tmp.pba_from_date_id, tmp.pba_to_date_id, 
                tmp.pba_lifecyle_logistics_phase, tmp.pba_retention_period,
                tmp.pba_freeze_flag,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;            

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    l_now_is := sysdate; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
    ps_location := 'ENDDATES';
  
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
      
    proc1.process_RecId      := 600; 
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
        
    ps_location                     := 'TYPE';
    ls_current_process.pfsa_process := 'MERGE PBA TYPE REF'; 
  
    proc1.rec_Read_Int              := NULL; 

-- Get the run criteria for the MERGE PBA TYPE REF from pfsa_process table 

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
 
-- Update the pfsa_process table to indicate STATUS of MERGE PBA TYPE REF 

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
 
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_type_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_type_ref ppr 
    USING  (SELECT 
            rec_id,
            item_identifier_type_cd,
            item_identifier_type_desc,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date
            FROM   pfsa_pba_type_ref@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.item_identifier_type_cd = tmp.item_identifier_type_cd,
            ppr.item_identifier_type_desc = tmp.item_identifier_type_desc,
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
                rec_id,
                item_identifier_type_cd, item_identifier_type_desc,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.rec_id,
                tmp.item_identifier_type_cd, tmp.item_identifier_type_desc,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;            
 
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                             -----*/  
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

/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_merged_int     := NULL;
      
    proc1.process_RecId      := 600; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 30;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    ps_location                     := 'ITEMS';

    proc1.rec_Read_Int              := NULL; 

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
  
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_items_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_items_ref ppr 
    USING  (SELECT 
            rec_id,
            pba_id,
            item_identifier_type_id,
            item_type_value,
            item_from_date_id,
            item_to_date_id,
            item_change_reason_desc,
            item_implementation_lvl_cd,
            physical_item_id, 
            physical_item_sn_id,
            force_unit_id,
            force_parent_unit_id,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date 
            FROM   pfsa_pba_items_ref@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.pba_id = tmp.pba_id,
            ppr.item_identifier_type_id = tmp.item_identifier_type_id,
            ppr.item_type_value = tmp.item_type_value,
            ppr.item_from_date_id = tmp.item_from_date_id,
            ppr.item_to_date_id = tmp.item_to_date_id,
            ppr.item_change_reason_desc = tmp.item_change_reason_desc,
            ppr.item_implementation_lvl_cd = tmp.item_implementation_lvl_cd,
            ppr.physical_item_id = tmp.physical_item_id, 
            ppr.physical_item_sn_id = tmp.physical_item_sn_id,
            ppr.force_unit_id = tmp.force_unit_id,
            ppr.force_parent_unit_id = tmp.force_parent_unit_id,
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
                rec_id,
                pba_id,
                item_identifier_type_id,
                item_type_value,
                item_from_date_id,
                item_to_date_id,
                item_change_reason_desc,
                item_implementation_lvl_cd,
                physical_item_id, 
                physical_item_sn_id,
                force_unit_id,
                force_parent_unit_id,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.rec_id,
                tmp.pba_id,
                tmp.item_identifier_type_id,
                tmp.item_type_value,
                tmp.item_from_date_id,
                tmp.item_to_date_id,
                tmp.item_change_reason_desc,
                tmp.item_implementation_lvl_cd,
                tmp.physical_item_id, 
                tmp.physical_item_sn_id,
                tmp.force_unit_id,
                tmp.force_parent_unit_id,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;    

-- Set warehouse ids    

-- ITEM 

    UPDATE pfsa_pba_items_ref pue
    SET    physical_item_id = 
            (
            SELECT physical_item_id 
            FROM   pfsawh_item_dim 
            WHERE  niin = pue.item_type_value
            )
    WHERE  pue.item_identifier_type_id = 13
        AND ( pue.physical_item_id < 1 
        OR pue.physical_item_id IS NULL); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- FORCE_UNIT 

    UPDATE pfsa_pba_items_ref pue
    SET    force_unit_id = 
            (
            SELECT force_unit_id 
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = pue.item_type_value 
                AND status = 'C' 
            )
    WHERE  pue.item_identifier_type_id = 16
        AND ( pue.force_unit_id < 1 
        OR pue.force_unit_id IS NULL); 

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

/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 600; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 40;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    ps_location                     := 'APPL';

    proc1.rec_Read_Int              := NULL; 

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
  
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_appl_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_appl_ref ppr 
    USING  (SELECT 
            rec_id,
            pba_menu_id,
            pba_menu_desc,
            pba_menu_sort_order,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date 
            FROM   pfsa_pba_appl_ref@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.pba_menu_id = tmp.pba_menu_id,
            ppr.pba_menu_desc = tmp.pba_menu_desc,
            ppr.pba_menu_sort_order = tmp.pba_menu_sort_order,
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
                rec_id,
                pba_menu_id,
                pba_menu_desc,
                pba_menu_sort_order,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.rec_id,
                tmp.pba_menu_id,
                tmp.pba_menu_desc,
                tmp.pba_menu_sort_order,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

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

/*----------------------------------------------------------------------------*/  
  
    proc1_recId              := NULL; 
    proc1.rec_merged_int     := NULL;
      
    proc1.process_RecId      := 600; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 50;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    ps_location                     := 'MENU';

    proc1.rec_Read_Int              := NULL; 

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
  
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_appl_menu_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_appl_menu_ref ppr 
    USING  (SELECT 
            rec_id,
            pba_menu_id,
            pba_menu_location,
            pba_menu_category,
            pba_id,
            pba_menu_sort_order,
            pba_menu_url,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date 
            FROM   pfsa_pba_appl_menu_ref@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.pba_menu_id = tmp.pba_menu_id,
            ppr.pba_menu_location = tmp.pba_menu_location,
            ppr.pba_menu_category = tmp.pba_menu_category,
            ppr.pba_id = tmp.pba_id,
            ppr.pba_menu_sort_order = tmp.pba_menu_sort_order,
            ppr.pba_menu_url = tmp.pba_menu_url,
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
                rec_id,
                pba_menu_id,
                pba_menu_location,
                pba_menu_category,
                pba_id,
                pba_menu_sort_order,
                pba_menu_url,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.rec_id,
                tmp.pba_menu_id,
                tmp.pba_menu_location,
                tmp.pba_menu_category,
                tmp.pba_id,
                tmp.pba_menu_sort_order,
                tmp.pba_menu_url,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

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

/*----------------------------------------------------------------------------*/  
  
    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 600; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 60;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    ps_location                     := 'METRICS';

    proc1.rec_Read_Int              := NULL; 

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
  
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_metrics_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_metrics_ref ppr 
    USING  (SELECT 
            rec_id,
            metric_id,
            metric_desc,
            ar_reg,
            ar_reg_sec,
            ar_reg_date_id,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date 
            FROM   pfsa_pba_metrics_ref@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.metric_id = tmp.metric_id,
            ppr.metric_desc = tmp.metric_desc,
            ppr.ar_reg = tmp.ar_reg,
            ppr.ar_reg_sec = tmp.ar_reg_sec,
            ppr.ar_reg_date_id = tmp.ar_reg_date_id,
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
                rec_id,
                metric_id,
                metric_desc,
                ar_reg,
                ar_reg_sec,
                ar_reg_date_id,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.rec_id,
                tmp.metric_id,
                tmp.metric_desc,
                tmp.ar_reg,
                tmp.ar_reg_sec,
                tmp.ar_reg_date_id,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

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

/*----------------------------------------------------------------------------*/  
  
    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 600; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 70;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    ps_location                     := 'RULES';

    proc1.rec_Read_Int              := NULL; 

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
  
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_rules_ref@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_rules_ref ppr 
    USING  (SELECT 
            rec_id,
            metric_id,
            rule_id,
            rule_description,
            rule_date_from_id,
            rule_date_to_id,
            rule_lower_limit,
            rule_upper_limit,
            bi_display_object,
            bi_display_attribute,
            bi_color_id,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date, 
            delete_by, hidden_by, rule_display_text 
            FROM   pfsa_pba_rules_ref@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.rule_id = tmp.rule_id,
            ppr.rule_description = tmp.rule_description,
            ppr.rule_date_from_id = tmp.rule_date_from_id,
            ppr.rule_date_to_id = tmp.rule_date_to_id,
            ppr.rule_lower_limit = tmp.rule_lower_limit,
            ppr.rule_upper_limit = tmp.rule_upper_limit,
            ppr.bi_display_object = tmp.bi_display_object,
            ppr.bi_display_attribute = tmp.bi_display_attribute,
            ppr.bi_color_id = tmp.bi_color_id,
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
            ppr.hidden_date = tmp.hidden_date, 
            ppr.delete_by = tmp.delete_by, 
            ppr.hidden_by = tmp.hidden_by, 
            ppr.rule_display_text = tmp.rule_display_text
    WHEN NOT MATCHED THEN 
        INSERT (
                rec_id,
                metric_id,
                rule_id,
                rule_description,
                rule_date_from_id,
                rule_date_to_id,
                rule_lower_limit,
                rule_upper_limit,
                bi_display_object,
                bi_display_attribute,
                bi_color_id,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date, 
                delete_by, hidden_by, rule_display_text
                )
        VALUES (
                tmp.rec_id,
                tmp.metric_id,
                tmp.rule_id,
                tmp.rule_description,
                tmp.rule_date_from_id,
                tmp.rule_date_to_id,
                tmp.rule_lower_limit,
                tmp.rule_upper_limit,
                tmp.bi_display_object,
                tmp.bi_display_attribute,
                tmp.bi_color_id,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date, 
                tmp.delete_by, tmp.hidden_by, tmp.rule_display_text
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

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

/*----------------------------------------------------------------------------*/  
  
    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 600; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 80;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    ps_location                     := 'RULE_MAP';

    proc1.rec_Read_Int              := NULL; 

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
  
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsa_pba_itm_metric_rul_map@pfsaw.lidb; 
  
    MERGE  
    INTO   pfsa_pba_itm_metric_rul_map ppr 
    USING  (SELECT 
            rec_id,
            pba_id,
            physical_item_id,
            metric_id,
            rule_id,
            status, updt_by, lst_updt,
            active_flag, active_date, inactive_date,
            insert_by, insert_date, update_by, update_date,
            delete_flag, delete_date, hidden_flag, hidden_date 
            FROM   pfsa_pba_itm_metric_rul_map@pfsaw.lidb ) tmp 
    ON     (ppr.rec_id = tmp.rec_id)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            ppr.rec_id             = tmp.rec_id,            
            ppr.pba_id = tmp.pba_id,
            ppr.physical_item_id = tmp.physical_item_id,
            ppr.metric_id = tmp.metric_id,
            ppr.rule_id = tmp.rule_id,
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
                rec_id,
                pba_id,
                physical_item_id,
                metric_id,
                rule_id,
                status, updt_by, lst_updt,
                active_flag, active_date, inactive_date,
                insert_by, insert_date, update_by, update_date,
                delete_flag, delete_date, hidden_flag, hidden_date
                )
        VALUES (
                tmp.rec_id,
                tmp.pba_id,
                tmp.physical_item_id,
                tmp.metric_id,
                tmp.rule_id,
                tmp.status, tmp.updt_by, tmp.lst_updt,
                tmp.active_flag, tmp.active_date, tmp.inactive_date,
                tmp.insert_by, tmp.insert_date, tmp.update_by, tmp.update_date,
                tmp.delete_flag, tmp.delete_date, tmp.hidden_flag, tmp.hidden_date
               ); 
               
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT;    

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process MAINTAIN_POTENTIAL_PFSA_ITEM. 

    updt_pfsawh_processes
      (
      ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
      ps_this_process.who_ran, ls_current_process.last_run_status, 
      l_now_is, ls_current_process.last_run_compl
      ); 
          
    COMMIT;
  
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

END; -- end of procedure
/

