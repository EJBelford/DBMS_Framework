/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_daily_incr_load 
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 5 Novemner 2008 
--
--          SP Source: etl_daily_incr_load.sql 
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
-- 05NOV08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

BEGIN 

    etl_daily_incr_load ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_daily_incr_load    
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_DAILY_INCR_LOAD';  /*  */
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

---- e-mail variables (e_) 

--e_from_address        VARCHAR2(500); -- any string formatted as an email addr 
--e_recipient_list      VARCHAR2(500); -- comma delimited list of email addr 
--e_subject             VARCHAR2(500); -- any string 
--e_message             VARCHAR2(500); -- any string 

--e_cr_lf_str                      VARCHAR2(30)
--    := ' ' || CHR(10) || CHR(13);

--e_user_env_server_host           VARCHAR2(30);
--e_user_env_server_host_nm        VARCHAR2(65);
--e_user_env_db_domain             VARCHAR2(30);
--e_user_env_db_name               VARCHAR2(30);

-- module variables (v_)

v_debug                          NUMBER        
     := 0;   -- Controls debug options (0 -Off) 
     
-- 01NOV08 - GB  -          -      - Added logic to determine whether to run 
--                                   the sub-process.  

v_process_run_flag               VARCHAR2(1); 

BEGIN

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE
           ( 
           'type_maintenance:   ' || type_maintenance
           );
    END IF;  
    
    proc0.process_RecId      := 500; 
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

    ps_id_key := nvl(type_maintenance, ps_procedure_name); 
    
-- Housekeeping for the MAIN process 
  
    ps_location := '00-Start';

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

-- update the pfsa_process table to indicate MAIN process began

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'eqip avail';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_EQUIP_AVAIL_LOAD'; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    IF run_today('daily_incr_equip_avail_load') THEN 
        daily_incr_equip_avail_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'use event';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_USAGE_EVENT_LOAD'; 
    l_call_error := NULL; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    IF run_today('daily_incr_usage_event_load') THEN 
        daily_incr_usage_event_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'mnt event';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_MAINT_EVENT_LOAD'; 
    l_call_error := NULL; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    IF run_today('daily_incr_maint_event_load') THEN 
        daily_incr_maint_event_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'mnt task';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_MAINT_TASK_LOAD'; 
    l_call_error := NULL; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    IF run_today('daily_incr_maint_task_load') THEN 
        daily_incr_maint_task_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'mnt work';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_MAINT_WORK_LOAD'; 
    l_call_error := NULL; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    v_process_run_flag := fn_pfsawh_get_prcss_run_flag('daily_incr_maint_work_load');   
    
    IF run_today('daily_incr_maint_work_load') THEN 
        daily_incr_maint_work_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'mnt items';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_MAINT_ITEMS_LOAD'; 
    l_call_error := NULL; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    IF run_today('daily_incr_maint_items_load') THEN 
        daily_incr_maint_items_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'mnt items';
    ls_current_process.pfsa_process := 'CALL DAILY_INCR_SUPPLY_ILAP_LOAD'; 
    l_call_error := NULL; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
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

-- update the pfsa_process table to indicate MAIN process location 

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );
        
    IF run_today('daily_incr_supply_ilap_load') THEN 
        daily_incr_supply_ilap_load(ps_this_process.who_ran); 
    ELSE 
        l_call_error := 'SKIPPED'; 
    END IF; 
  
    l_now_is := sysdate; 
          
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSIF l_call_error = 'SKIPPED' THEN
        ls_current_process.last_run_status := 'SKIPPED';
        ps_main_status := 'SKIPPED';
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB process 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----------------------------------------------------------------------------*/  
-- Housekeeping for the end of the MAIN process 

    ps_this_process.last_run_status_time := sysdate; 
      
    IF ps_main_status IS NULL THEN
     ps_main_status := 'COMPLETE';
    ELSIF ps_main_status = 'SKIPPED' THEN
     ps_main_status := 'CMPL_SKIP';
    ELSE
     ps_main_status := 'CMPLERROR';
    END IF;
  
    ps_this_process.last_run_compl := ps_this_process.last_run_status_time; 
      
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

        RAISE; 

END; -- end of ETL_DAILY_INCR_LOAD procedure 
/
