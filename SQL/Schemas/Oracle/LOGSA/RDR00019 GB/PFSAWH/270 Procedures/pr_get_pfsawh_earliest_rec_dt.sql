/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_get_cbmwh_earliest_rec_dt  
--            SP Desc: 
--
--      SP Created By: Gene Belford 
--    SP Created Date: 29 September 2008 
--
--          SP Source: pr_get_cbmwh_earliest_rec_dt.sql 
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
-- 24SEP08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Testing Scripts 

/* 

BEGIN 

    pr_get_cbmwh_earliest_rec_dt ('GBelford'); 
    
    COMMIT; 
    
END; 

*/ 

CREATE OR REPLACE PROCEDURE pr_get_cbmwh_earliest_rec_dt    
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       -- heirachy 
    )
    
IS

-- Exception handling variables (ps_) 

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'pr_get_cbmwh_earliest_rec_dt';  /*  */
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

v_etl_copy_cutoff       DATE; 
v_t_fact_cutoff         DATE; 
v_t_fact_cutoff_id      NUMBER; 
v_p_fact_cutoff         DATE; 
v_p_fact_cutoff_id      NUMBER; 

v_beg_a      NUMBER;
v_end_a      NUMBER; 
v_beg_m      NUMBER;
v_end_m      NUMBER; 
v_fr_dt_id   NUMBER;
v_fr_dt      DATE;
v_fr_dt_str  VARCHAR2(10);
v_to_dt_id   NUMBER;

cv_physical_item_id        NUMBER; 

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

--CURSOR item_sn_cur IS
--    SELECT   cisd.physical_item_id, cisd.item_niin, 
--        cisd.physical_item_sn_id, cisd.item_serial_number, 
--        cisd.wh_earliest_fact_rec_dt
--    FROM     cbmwh_item_sn_dim cisd 
--    WHERE    cisd.physical_item_id = cv_physical_item_id 
--        AND cisd.wh_flag = 'Y' 
--        AND cisd.wh_earliest_fact_rec_dt IS NOT NULL
--    ORDER BY cisd.physical_item_id, cisd.physical_item_sn_id;
--        
--item_sn_rec    item_sn_cur%ROWTYPE;
        
----------------------------------- START --------------------------------------

BEGIN

--    IF v_debug > 0 THEN
--        DBMS_OUTPUT.ENABLE(1000000);
--        DBMS_OUTPUT.NEW_LINE;
--        DBMS_OUTPUT.PUT_LINE
--           ( 
--           'v_physical_item_id: ' || v_physical_item_id || ', ' || 
--           'type_maintenance:   ' || type_maintenance
--           );
--    END IF;  
    
--    cv_physical_item_id := v_physical_item_id;

--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 202; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    
    ps_id_key := NVL(type_maintenance, ps_procedure_name);
  
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
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

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

--  Set the inner calling module (proc1.) values.

    proc1.process_RecId      := 202; 
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
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc1_recId: ' || proc1_recId || ', ' || 
           proc1.process_RecId || ', ' || proc1.process_Key
           );
    END IF;  

-- Housekeeping for the process 
  
    ps_location := 'cbmwh 00';            -- For std_cbmwh_debug_tbl logging. 

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

-- Update the CBMWH_PROCESSES table to indicate MAIN process began.  

    updt_cbmwh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );
      
    COMMIT;

-- Call the xxxxx routine.  

    ps_location := 'cbmwh 10';            -- For std_cbmwh_debug_tbl logging.

    ls_current_process.cbmwh_process := 'FACT'; 
  
-- Get the run criteria from the CBMWH_PROCESSES table for the last run of 
-- the xxxxx process 
  
    get_cbmwh_process_info
        (
        ps_procedure_name, ls_current_process.cbmwh_process, 
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

    ps_location := 'cbmwh 20';            -- For std_cbmwh_debug_tbl logging.

    updt_cbmwh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

-- Update the pfsa_processes table to indicate the sub-process 
-- MERGE PBA REF has started.  

    ps_location := 'cbmwh 30';            -- For std_cbmwh_debug_tbl logging.

    updt_cbmwh_processes
        (
        ps_procedure_name, ls_current_process.cbmwh_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 

    ps_location := 'cbmwh 40';            -- For std_cbmwh_debug_tbl logging.

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || ', '
           );
    END IF;  

-- Item -- 

    UPDATE cbmwh_item_dim cid 
    SET    wh_flag = 'Y' 
    WHERE  EXISTS (
                  SELECT 
                  DISTINCT item_type_value 
                  FROM   pfsawh.pfsa_pba_items_ref 
                  WHERE  item_type_value = cid.niin 
                  ); 
                  
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT; 
    
--    SELECT * FROM cbmwh_item_dim WHERE wh_flag = 'Y'; 
    
-- Set the earliest record data --     

    UPDATE cbmwh_item_dim cid
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(TO_CHAR(bpseh.event_dt_time, 'DD-MON-YYYY')) 
               FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb bpseh 
               WHERE  cid.niin = bpseh.sys_ei_niin 
                   AND cid.wh_earliest_fact_rec_dt > bpseh.event_dt_time 
               )
    WHERE  wh_flag = 'Y'; 
                  
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT; 

--    SELECT cid.wh_flag, cid.wh_earliest_fact_rec_dt, '|', cid.* 
--    FROM cbmwh_item_dim cid
--    WHERE cid.wh_flag = 'Y' ORDER BY cid.wh_earliest_fact_rec_dt; 
    
    UPDATE cbmwh_item_dim cid
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(TO_CHAR(pea.from_dt, 'DD-MON-YYYY'))  
               FROM   pfsa_equip_avail@pfsaw.lidb pea
               WHERE  cid.niin = pea.sys_ei_niin 
                   AND cid.wh_earliest_fact_rec_dt > pea.from_dt
               )
    WHERE  wh_flag = 'Y';

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT;

--    SELECT cid.wh_flag, cid.wh_earliest_fact_rec_dt, '|', cid.* 
--    FROM cbmwh_item_dim cid
--    WHERE cid.wh_flag = 'Y' ORDER BY cid.wh_earliest_fact_rec_dt; 
    
-- Item SN --
-- Should use the item dim to update the Item SN --    

    UPDATE cbmwh_item_sn_dim cisd 
    SET    wh_flag = (
                      SELECT cid.wh_flag  
                      FROM   cbmwh_item_dim cid
                      WHERE  cid.physical_item_id = cisd.physical_item_id 
                          AND cid.wh_flag = 'Y'
                      )
    WHERE  (cisd.wh_flag = 'N' OR cisd.wh_flag IS NULL); 
              
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT; 
    
--    SELECT cisd.wh_flag, cisd.wh_earliest_fact_rec_dt, '|', cisd.* 
--    FROM cbmwh_item_sn_dim cisd 
--    WHERE cisd.wh_flag = 'Y';
                    
    UPDATE cbmwh_item_sn_dim cid
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(TO_CHAR(bpseh.event_dt_time, 'DD-MON-YYYY')) 
               FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb bpseh 
               WHERE  cid.item_serial_number = bpseh.sys_ei_sn 
                   AND cid.wh_earliest_fact_rec_dt > bpseh.event_dt_time
               )
    WHERE  wh_flag = 'Y'; 
                  
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT; 

    UPDATE cbmwh_item_sn_dim cid
    SET    wh_earliest_fact_rec_dt = 
               ( 
--               SELECT MIN(TO_CHAR(pea.from_dt, 'DD-MON-YYYY'))  -- Performace ? 
               SELECT MIN(pea.from_dt)  -- Performace ? 
               FROM   pfsa_equip_avail@pfsaw.lidb pea
               WHERE  cid.item_niin = pea.sys_ei_niin 
                   AND cid.item_serial_number = pea.sys_ei_sn 
                   AND cid.wh_earliest_fact_rec_dt > pea.from_dt
               )
    WHERE  wh_flag = 'Y'  
        AND wh_earliest_fact_rec_dt IS NULL; 
--    WHERE  cid.item_niin = '014321526';

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT;

--    SELECT cisd.wh_flag, cisd.wh_earliest_fact_rec_dt, '|', cisd.* 
--    FROM cbmwh_item_sn_dim cisd 
--    WHERE cisd.wh_flag = 'Y'
--    ORDER BY cisd.wh_earliest_fact_rec_dt;
    
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := 'cbmwh 47';            -- For std_cbmwh_debug_tbl logging.

    l_now_is := sysdate; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
    ps_location := 'cbmwh 48';            -- For std_cbmwh_debug_tbl logging.

-- update the pfsa_process table to indicate STATUS of MAINTAIN_PFSA_DATES 
  
    updt_cbmwh_processes
        (
        ps_procedure_name, ls_current_process.cbmwh_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    ps_location := 'cbmwh 49';            -- For std_cbmwh_debug_tbl logging.

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

/*----------------------------------------------------------------------------*/  

-- Create the life records   

--    INSERT 
--    INTO   cbmwh_item_sn_l_fact 
--        (
--        physical_item_id, 
--        physical_item_sn_id, 
--        mimosa_item_sn_id, 
--        pba_id, 
--        item_force_unit_id
--        )
--    SELECT cisd.physical_item_id, 
--        cisd.physical_item_sn_id, 
--        cisd.mimosa_item_sn_id, 
--        1000000, 
--        cisd.item_force_unit_id 
--    FROM   cbmwh_item_sn_dim cisd 
--    WHERE cisd.wh_flag = 'Y' 
--        AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
--        AND cisd.physical_item_sn_id = item_sn_rec.physical_item_sn_id
--        AND NOT EXISTS (
--            SELECT l.rec_id 
--            FROM   cbmwh_item_sn_l_fact l
--            WHERE  cisd. physical_item_sn_id = l.physical_item_sn_id
--            )
--    ORDER BY cisd.physical_item_id, cisd.physical_item_sn_id;  
--    
--    COMMIT; 
    
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

--    proc1.process_end_date := sysdate;
--    proc1.sql_error_code := sqlcode;
--    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
--    proc1.message := sqlcode || ' - ' || sqlerrm; 
--    
--    pr_cbmwh_insupd_processlog 
--        (
--        proc1.process_recid, proc1.process_key, 
--        proc1.module_num, proc1.step_num,  
--        proc1.process_start_date, proc1.process_end_date, 
--        proc1.process_status_code, proc1.sql_error_code, 
--        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
--        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
--        proc1.rec_updated_int, proc1.rec_deleted_int, 
--        proc1.user_login_id, proc1.message, proc1_recid
--        );

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

SELECT cid.wh_flag, cid.wh_earliest_fact_rec_dt, cid.* 
FROM   cbmwh_item_dim cid 
WHERE cid.wh_flag = 'Y'
ORDER BY niin; 

SELECT cisd.wh_flag, cisd.wh_earliest_fact_rec_dt, cisd.* 
FROM   cbmwh_item_sn_dim cisd 
WHERE cisd.wh_flag = 'Y' 
    AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
ORDER BY item_niin, item_serial_number; 

*/ 


           
