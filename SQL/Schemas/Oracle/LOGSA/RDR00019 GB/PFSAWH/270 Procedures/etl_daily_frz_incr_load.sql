/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_daily_frz_incr_load 
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 5 Novemner 2008 
--
--          SP Source: etl_daily_frz_incr_load.sql 
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

    etl_daily_frz_incr_load ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_daily_frz_incr_load    
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_DAILY_FRZ_INCR_LOAD';  /*  */
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

-- e-mail variables (e_) 

e_from_address        VARCHAR2(500);  -- any string formatted as an email addr 
e_recipient_list      VARCHAR2(500);  -- comma delimited list of email addr 
e_subject             VARCHAR2(500); -- any string 
e_message             VARCHAR2(500);  -- any string 

e_cr_lf_str                      VARCHAR2(30)
    := ' ' || CHR(10) || CHR(13);

e_user_env_server_host           VARCHAR2(30);
e_user_env_server_host_nm        VARCHAR2(65);
e_user_env_db_domain             VARCHAR2(30);
e_user_env_db_name               VARCHAR2(30);

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
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := nvl(type_maintenance, ps_procedure_name); 
    
-- E-mail setup  
  
    SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST')
    INTO   e_user_env_server_host 
    FROM   dual;

    SELECT SYS_CONTEXT('USERENV', 'DB_DOMAIN')
    INTO   e_user_env_db_domain 
    FROM   dual;
    
    SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
    INTO   e_user_env_db_name 
    FROM   dual;
    
    IF e_user_env_db_name = 'LIWWH' THEN 
        e_user_env_server_host_nm := 'PFSAWH@LIWWH';

        e_from_address   := e_user_env_server_host_nm;   
        e_recipient_list := 'pfsa@conus.army.mil, '  
             ||  'david.hendricks@us.army.mil, '  
             ||  'Eugene.Belford@us.army.mil ';  

        e_subject := 'Production e-mail message - ' || e_user_env_db_name;      
    ELSIF e_user_env_db_name = 'LIWWHTST' THEN 
        e_user_env_server_host_nm := 'PFSAWH@LIWWHTST';

        e_from_address   := e_user_env_server_host_nm;   
        e_recipient_list := 'david.hendricks@us.army.mil, '  
             ||  'julie.southworth@us.army.mil, '  
             ||  'Eugene.Belford@us.army.mil ';  

        e_subject := 'Test e-mail message - ' || e_user_env_db_name;      
    ELSIF e_user_env_db_name = 'LIWWHDEV' THEN 
        e_user_env_server_host_nm := 'PFSAWH@LIWWHDEV';

        e_from_address   := e_user_env_server_host_nm;   
        e_recipient_list := 'pfsa@conus.army.mil, ' || 
    --         'david.hendricks@us.army.mil, '  || 
    --         'julie.southworth@us.army.mil, '  || 
             'Eugene.Belford@us.army.mil ';  

        e_subject := 'Development e-mail message - ' || e_user_env_db_name;      
    ELSE 
        e_user_env_server_host_nm := 'Unknown server name';

        e_from_address   := e_user_env_server_host_nm;   
        e_recipient_list := 'pfsa@conus.army.mil, ' || 
    --         'david.hendricks@us.army.mil, '  || 
    --         'julie.southworth@us.army.mil, '  ||  
             'Eugene.Belford@us.army.mil ';  

    END IF;

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
  
-- Cleanup the process log file - "PFSAWH.PFSAWH_PROCESS_LOG".

    ps_location := 'frz eq avl';
    ls_current_process.pfsa_process := 'frz_equip_avail'; 
  
-- get the run criteria from the pfsa_processes table for the last run of 
-- the SUB process 
  
---    pr_pfsawh_log_cleanup;
    
/*----- Sub Process -----*/ 
      
-- Housekeeping for the SUB process 
  
    ps_location := 'frz use ev';
    ls_current_process.pfsa_process := 'frz_usage_event'; 
  
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
        
--    IF run_today('etl_xxx') THEN 
--        etl_xxx(ps_this_process.who_ran); 
--    ELSE 
--        l_call_error := 'SKIPPED'; 
--    END IF; 
  
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

/*----- Send status e-mail -----*/ 

    e_subject := 'Success - ' || e_subject;      
    e_message := 'Generated ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI:SS') || e_cr_lf_str 
        || e_user_env_server_host || ' - ' || e_user_env_server_host_nm || e_cr_lf_str 
        || e_user_env_db_domain || e_cr_lf_str 
        || e_user_env_db_name || e_cr_lf_str 
        || ps_procedure_name || e_cr_lf_str 
        || 'Success test e-mail message from Eugene.Belford@us.army.mil ' || e_cr_lf_str  
        || '/*----- End of Message -----*/';   

--    email.send_email(
--        e_from_address,     -- any string formatted as an email address
--        e_recipient_list,   -- comma delimited list of email addresses
--        e_subject,          -- any string
--        e_message           -- any string
--        );

  COMMIT;

EXCEPTION 
    WHEN OTHERS THEN

/*----- Send status e-mail -----*/ 

        e_subject := 'Exception - ' || e_subject;      
        e_message := 'Generated ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI:SS') || e_cr_lf_str 
            || e_user_env_server_host || ' - ' || e_user_env_server_host_nm || e_cr_lf_str 
            || e_user_env_db_domain || e_cr_lf_str 
            || e_user_env_db_name || e_cr_lf_str 
            || ps_procedure_name || e_cr_lf_str 
            || 'Exception test e-mail message from Eugene.Belford@us.army.mil ' || e_cr_lf_str  
            || '/*----- End of Message -----*/';   

--        email.send_email(
--            e_from_address,     -- any string formatted as an email address
--            e_recipient_list,   -- comma delimited list of email addresses
--            e_subject,          -- any string
--            e_message           -- any string
--            );

        RAISE; 

END; -- end of ETL_DAILY_FRZ_INCR_LOAD procedure 
/