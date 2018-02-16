/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_get_pfsawh_earliest_rcdt_ni  
--            SP Desc: 
--
--      SP Created By: Gene Belford 
--    SP Created Date: 30 September 2008 
--
--          SP Source: pr_get_pfsawh_earliest_rcdt_ni.sql 
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
-- 30SEP08 - GB  -          -      - Created 
-- 27NOV08 - GB  -          -      - Add tem table to grab PFSAW data 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Testing Scripts 

/* 

BEGIN 

    pr_get_pfsawh_earliest_rcdt_nx (141223, 'GBelford'); 
    
    COMMIT; 
    
END; 

*/ 

CREATE OR REPLACE PROCEDURE pr_get_pfsawh_earliest_rcdt_ni    
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS

-- Exception handling variables (ps_) 

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_GET_PFSAWH_EARLIEST_RCDT_NI';  /*  */
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

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days          pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months        pfsawh_process_control.process_control_value%TYPE 
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

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

cv_physical_item_id        pfsawh_item_dim.physical_item_id%TYPE; 
cv_physical_item_sn_id     pfsawh_item_sn_dim.physical_item_sn_id%TYPE; 
cv_mimosa_item_sn_id       pfsawh_item_sn_dim.mimosa_item_sn_id%TYPE; 
cv_force_unit_id           pfsawh_force_unit_dim.force_unit_id%TYPE; 
cv_last_force_unit_id      pfsawh_force_unit_dim.force_unit_id%TYPE; 

v_niin                     pfsawh_item_dim.niin%TYPE; 
v_item_nomen_standard      pfsawh_item_dim.item_nomen_standard%TYPE; 

cv_force_unit_uic          VARCHAR2(50); 
cv_last_force_unit_uic     VARCHAR2(50); 
cv_max_date                DATE; 
cv_select_cnt              NUMBER; 

-- add  by lmj 10/10/08 variables to manaage truncation and index control --

myrowcount              NUMBER;
mytablename             VARCHAR2(32);

----------------------------------- START --------------------------------------

BEGIN

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_physical_item_id: ' || v_physical_item_id || ', ' || 
           'type_maintenance:   ' || type_maintenance
           );
    END IF;  
    
    cv_physical_item_id := v_physical_item_id;

    SELECT  niin,   item_nomen_standard 
    INTO    v_niin, v_item_nomen_standard  
    FROM    pfsawh_item_dim    
    WHERE   physical_item_id = v_physical_item_id;

--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 203; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    proc0.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
    
    ps_id_key := NVL(type_maintenance, ps_procedure_name);
  
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
        
--    COMMIT;     
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

-- Get the process control values from pfsawh_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
    v_t_fact_cutoff_days   := fn_pfsawh_get_prcss_cntrl_val('v_t_fact_cutoff_days'); 
    v_p_fact_cutoff_months := fn_pfsawh_get_prcss_cntrl_val('v_p_fact_cutoff_months');  

-- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    v_etl_copy_cutoff    := SYSDATE - v_etl_copy_cutoff_days; 
    v_t_fact_cutoff      := SYSDATE - v_t_fact_cutoff_days; 
    v_t_fact_cutoff_id   := fn_date_to_date_id(v_t_fact_cutoff); 
    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  (-1 * v_p_fact_cutoff_months)); 
    v_p_fact_cutoff_id   := fn_date_to_date_id(v_p_fact_cutoff); 

--  Set the inner calling module (proc1.) values.

    proc1.process_RecId      := 203; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
  
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
           'proc1_recId: ' || proc1_recId || ', ' || 
           proc1.process_RecId || ', ' || proc1.process_Key
           );
    END IF;  

-- Housekeeping for the process 
  
    ps_location := 'pfsawh 00';            -- For std_pfsawh_debug_tbl logging. 

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

-- Update the pfsawh_PROCESSES table to indicate MAIN process began.  

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );
      
-- Call the xxxxx routine.  

    ps_location := 'pfsawh 10';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'FACT'; 
  
-- Get the run criteria from the pfsawh_PROCESSES table for the last run of 
-- the xxxxx process 
  
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

    ps_location := 'pfsawh 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- Update the pfsa_processes table to indicate the sub-process 
-- MERGE PBA REF has started.  

    ps_location := 'pfsawh 30';            -- For std_pfsawh_debug_tbl logging.

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

    ps_location := 'pfsawh 40';            -- For std_pfsawh_debug_tbl logging.

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || ', '
           );
    END IF;  

-- Item -- 

    UPDATE pfsawh_item_dim cid 
    SET    wh_flag = 'Y' 
    WHERE  EXISTS (
                  SELECT 
                  DISTINCT item_type_value 
                  FROM   pfsawh.pfsa_pba_items_ref 
                  WHERE  item_type_value = cid.niin 
                  )
        AND cid.physical_item_id = cv_physical_item_id; 
                  
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
-- Set the earliest record data --     

    UPDATE pfsawh_item_dim cid
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(TO_CHAR(bpseh.event_dt_time, 'DD-MON-YYYY')) 
               FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb bpseh 
               WHERE  bpseh.sys_ei_niin = cid.niin 
                   AND NVL(cid.wh_earliest_fact_rec_dt, SYSDATE) > bpseh.event_dt_time 
               )
    WHERE  cid.wh_flag = 'Y'  
        AND cid.physical_item_id = cv_physical_item_id; 
                  
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    UPDATE pfsawh_item_dim cid
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(TO_CHAR(pea.from_dt, 'DD-MON-YYYY'))  
               FROM   pfsa_equip_avail@pfsaw.lidb pea
               WHERE  cid.niin = pea.sys_ei_niin 
                   AND NVL(cid.wh_earliest_fact_rec_dt, SYSDATE) > pea.from_dt
               )
    WHERE  wh_flag = 'Y' 
        AND cid.physical_item_id = cv_physical_item_id; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
    ps_location := 'pfsawh 110';            -- For std_pfsawh_debug_tbl logging.

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

/*--------------------------------------------------------*/    
/*-----                    Item SN                   -----*/
/*--------------------------------------------------------*/    

    proc1_recId            := NULL;

    proc1.rec_selected_int := NULL; 
    proc1.rec_updated_int  := NULL; 
    proc1.rec_deleted_int  := NULL; 

--  Set the inner calling module (proc1.) values.

    proc1.process_RecId      := 203; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 20;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
  
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
        
-- Do we have nay serial numbers for this item? 

    SELECT COUNT(physical_item_id)  
    INTO   cv_select_cnt 
    FROM   pfsawh_item_sn_dim 
    WHERE  physical_item_id = cv_physical_item_id; 
    
    IF cv_select_cnt < 1 THEN 
    
-------------------------------------------------------------------- 
-- This should be converted to a procedure call in the future   
-------------------------------------------------------------------- 
        
        INSERT 
        INTO pfsawh_functional_warnings 
            (
            warning_type,
            warning_from,
            warning_msg,
            warning_status,
            warning_time 
            )
        VALUES 
            (
            'No records in Item SN dim', 
            ps_procedure_name, 
            v_physical_item_id || '-' || 
                v_niin || '-' || 
                v_item_nomen_standard, 
            'C', 
            l_ps_start
            ); 
            
        INSERT 
        INTO pfsawh_item_sn_dim 
            (
            physical_item_sn_id ,
            physical_item_id , 
            item_niin , 
            item_serial_number, 
            status, 
            item_notes  
            ) 
        SELECT 
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
            v_physical_item_id, 
            bpseh.sys_ei_niin,  
            bpseh.sys_ei_sn, 
            'C', 
            ps_procedure_name 
        FROM pfsa_sn_ei@pfsaw.lidb bpseh 
        WHERE  sys_ei_niin = v_niin;
            
        COMMIT;    

    END IF;

-- Should use the item dim to update the Item SN --    

    UPDATE pfsawh_item_sn_dim cisd 
    SET    wh_flag = (
                      SELECT cid.wh_flag  
                      FROM   pfsawh_item_dim cid
                      WHERE  cid.physical_item_id = cisd.physical_item_id 
                          AND cid.wh_flag = 'Y'
                      )
    WHERE  (cisd.wh_flag = 'N' OR cisd.wh_flag IS NULL)  
        AND cisd.physical_item_id = cv_physical_item_id; 
              
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
-- 27NOV08 - GB  - Add tmp table to grab PFSAW data 
    
-- 28NOV08 - GB  - Clear the tmp table  
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   tmp_earliest_item_sn_fact;
    
    IF myrowcount > 0 THEN
       mytablename := 'tmp_earliest_item_sn_fact';
       truncate_a_tmp_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO  tmp_earliest_item_sn_fact 
        (
        source_table,
        sys_ei_niin,
        physical_item_id, 
        sys_ei_sn,
        physical_item_sn_id, 
        min_date
        ) 
    SELECT 'bld_pfsa_sn_ei_hist', 
        sys_ei_niin,
        cv_physical_item_id, 
        sys_ei_sn, 
        0,
        MIN(TO_CHAR(event_dt_time, 'DD-MON-YYYY')) AS min_date
    FROM   bld_pfsa_sn_ei_hist@PFSAW.LIDB  
    WHERE  sys_ei_niin = v_niin  -- '013285964'  
    GROUP BY sys_ei_niin, sys_ei_sn  
    ORDER BY sys_ei_sn; 

    proc0.rec_selected_int := NVL(proc0.rec_selected_int, 0) + myrowcount;
    proc1.rec_selected_int := NVL(proc1.rec_selected_int, 0) + myrowcount;
    
    UPDATE pfsawh_item_sn_dim cisd
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(TO_CHAR(bpseh.min_date, 'DD-MON-YYYY')) 
               FROM   tmp_earliest_item_sn_fact bpseh 
               WHERE  bpseh.sys_ei_sn = cisd.item_serial_number
                   AND NVL(cisd.wh_earliest_fact_rec_dt, SYSDATE) > bpseh.min_date
               )
    WHERE  wh_flag = 'Y'  
        AND cisd.physical_item_id = cv_physical_item_id; 
                  
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
-- 27NOV08 - GB  - Add tmp table to grab PFSAWH data 
    
-- 28NOV08 - GB  - Clear the tmp table  
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   tmp_earliest_item_sn_fact;
    
    IF myrowcount > 0 THEN
       mytablename := 'tmp_earliest_item_sn_fact';
       truncate_a_tmp_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
    INSERT 
    INTO  tmp_earliest_item_sn_fact 
        (
        source_table,
        sys_ei_niin,
        physical_item_id, 
        sys_ei_sn,
        physical_item_sn_id, 
        min_date
        ) 
    SELECT 'pfsa_equip_avail', 
        sys_ei_niin, 
        cv_physical_item_id, 
        sys_ei_sn, 
        0, 
        MIN(from_dt) AS min_date
    FROM   pfsa_equip_avail@PFSAW.LIDB 
    WHERE  sys_ei_niin = v_niin  -- '013285964' 
    GROUP BY sys_ei_niin, sys_ei_sn  
    ORDER BY sys_ei_sn; 

    proc0.rec_selected_int := NVL(proc0.rec_selected_int, 0) + myrowcount;
    proc1.rec_selected_int := NVL(proc1.rec_selected_int, 0) + myrowcount;
    
    UPDATE pfsawh_item_sn_dim cisd
    SET    wh_earliest_fact_rec_dt = 
               ( 
               SELECT MIN(pea.min_date)   
               FROM   tmp_earliest_item_sn_fact pea
               WHERE  pea.sys_ei_niin = cisd.item_niin 
                   AND cisd.item_serial_number = pea.sys_ei_sn 
                   AND NVL(cisd.wh_earliest_fact_rec_dt, '01-JAN-1900') < pea.min_date
               )
    WHERE  wh_flag = 'Y'  
        AND wh_earliest_fact_rec_dt IS NULL  
        AND cisd.physical_item_id = cv_physical_item_id; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT; 
                
    COMMIT;

    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   tmp_earliest_item_sn_fact;
    
    IF myrowcount > 0 THEN
       mytablename := 'tmp_earliest_item_sn_fact';
       truncate_a_tmp_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + myrowcount;
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := 'pfsawh 90';            -- For std_pfsawh_debug_tbl logging.

    l_now_is := sysdate; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
    ps_location := 'pfsawh 100';            -- For std_pfsawh_debug_tbl logging.

-- update the pfsa_process table to indicate STATUS of MAINTAIN_PFSA_DATES 
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
    ps_location := 'pfsawh 110';            -- For std_pfsawh_debug_tbl logging.

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

--    proc1.process_end_date := sysdate;
--    proc1.sql_error_code := sqlcode;
--    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
--    proc1.message := sqlcode || ' - ' || sqlerrm; 
--    
--    pr_pfsawh_insupd_processlog 
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

--    COMMIT;

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
        ps_procedure_name, ps_oerr, ps_location, ps_id_key, 
        ps_id_key, ps_msg, SYSDATE
        );
        
    COMMIT; 

END; -- end of PR_GET_PFSAWH_EARLIEST_RCDT_NI procedure     
/

           
