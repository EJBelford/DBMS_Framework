/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_reload_niin 
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 23 October 2008 
--
--          SP Source: etl_reload_niin.sql 
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
-- 21NOV08 - GB  -          -      - Merged in Jean Stuart's reload freeze niin 
--                                     procedures. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Testing Scripts 

/* 

DECLARE 

l_call_error                     VARCHAR2(20); 

BEGIN 

    etl_reload_niin ('GBelford', l_call_error); 
    
    COMMIT; 

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_reload_niin    
    (
    type_maintenance    IN     VARCHAR2, -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         --  heirachy 
    unexpected_error    IN OUT VARCHAR2                                      
    )
    
IS

-- Exception handling variables (ps_) 

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_PFSAWH_LOAD_NIIN_SHEL';  /*  */
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

v_fact_ld_niin_cntrl_start    pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_fact_ld_niin_cntrl_cutoff   pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_physical_item_id               NUMBER;
v_time_id                        NUMBER; 

v_debug                          NUMBER        
     := 0;   -- Controls debug options (0 -Off)

CURSOR item_cur IS
    SELECT  niin.rec_id,  
        niin.physical_item_id, niin.niin, niin.item_nomen_standard,
        niin.scheduled_load_date, niin.scheduled_load_date_id,
        niin.load_date, niin.load_date_id, niin.status
    FROM     pfsawh_fact_ld_niin_cntrl niin 
    WHERE   niin.status = 'W' 
        AND niin.load_date IS NULL 
        AND ( niin.scheduled_load_date IS NULL 
              OR niin.scheduled_load_date < SYSDATE )
    ORDER BY niin.physical_item_id;

item_rec    item_cur%ROWTYPE; 
        
BEGIN 

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
    END IF;  
    
    proc0.process_RecId      := 200; 
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
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := nvl(type_maintenance, 'etl_reload_niin');

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
      
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    proc1.process_RecId      := 200; 
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
       
--    get_pfsawh_process_info
--        (
--        ps_procedure_name, ls_current_process.pfsa_process, 
--        ls_current_process.last_run, ls_current_process.who_ran, 
--        ls_current_process.last_run_status, 
--        ls_current_process.last_run_status_time, 
--        ls_current_process.last_run_compl
--        );

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

-- Get the process control values from PFSAWH_PROCESS_CONTROL. 

    v_fact_ld_niin_cntrl_start  := fn_pfsawh_get_prcss_cntrl_val('v_fact_ld_niin_cntrl_start');
    v_fact_ld_niin_cntrl_cutoff := fn_pfsawh_get_prcss_cntrl_val('v_fact_ld_niin_cntrl_cutoff'); 

-- Create the fact records based upon SN     

    OPEN item_cur;
    
    LOOP
        FETCH item_cur 
        INTO  item_rec;
        
        EXIT WHEN (item_cur%NOTFOUND 
--            OR (item_cur%ROWCOUNT > 2)
            ); 
            
        v_time_id := fn_time_to_time_id(SYSDATE); 
        
        IF v_fact_ld_niin_cntrl_cutoff < v_fact_ld_niin_cntrl_start THEN 
        
            EXIT WHEN (v_time_id > v_fact_ld_niin_cntrl_cutoff 
                AND v_time_id < v_fact_ld_niin_cntrl_start
                );
        
        ELSE

            EXIT WHEN ((v_time_id < v_fact_ld_niin_cntrl_start) 
                OR (v_time_id > v_fact_ld_niin_cntrl_cutoff)
                ); 
                
        END IF; 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        proc1.rec_read_int := NVL(proc1.rec_read_int, 0) + 1; 
        
        v_physical_item_id := item_rec.physical_item_id;

        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE
               ( 
               'v_physical_item_id: ' || v_physical_item_id || ', ' 
    --           || 'type_maintenance:   ' || type_maintenance
               );
        END IF;  
    
        pr_get_pfsawh_earliest_rcdt_ni (v_physical_item_id, ps_id_key);   
        
        COMMIT; 

        pr_create_pfsawh_fact_shel_nin (v_physical_item_id, ps_id_key); 
        
        COMMIT; 
    
        etl_pfsa_equip_avail_niin (v_physical_item_id, ps_id_key); 
        
        COMMIT; 
        
        etl_pfsa_usage_event_niin (v_physical_item_id, ps_id_key); 
        
        COMMIT; 
        
        etl_pfsa_maint_niin (v_physical_item_id, ps_id_key); 

        COMMIT; 
    
-- 21NOV08 - GB  - Merged in Jean Stuart's reload freeze niin procedures. 
-- Start 

        pr_create_pfsawh_frz_shel_nin (v_physical_item_id, ps_id_key); 
        
        COMMIT; 
    
        etl_pfsa_equip_avail_frz_niin (v_physical_item_id, ps_id_key); 
        
        COMMIT; 
        
        etl_pfsa_usage_event_frz_niin (v_physical_item_id, ps_id_key); 
        
        COMMIT; 
        
        etl_pfsa_maint_frz_niin (v_physical_item_id, ps_id_key); 

        COMMIT; 

-- End 
-- 21NOV08 - GB  - Merged in Jean Stuart's reload freeze niin procedures. 

        UPDATE pfsawh_fact_ld_niin_cntrl 
        SET    load_date  = SYSDATE,
               status     = 'C'             
        WHERE  rec_id = item_rec.rec_id; 

        COMMIT; 
    
    END LOOP;       -- end of cursor loop. 
        
    CLOSE item_cur; 
    
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

END; -- etl_reload_niin
/ 

