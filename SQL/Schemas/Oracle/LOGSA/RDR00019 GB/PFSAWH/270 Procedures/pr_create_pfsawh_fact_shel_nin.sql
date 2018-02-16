CREATE OR REPLACE PROCEDURE pr_create_pfsawh_fact_shel_nin    
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_create_pfsawh_fact_shel_nin 
--            SP Desc: 
--
--      SP Created By: Gene Belford 
--    SP Created Date: 24 September 2008 
--
--          SP Source: pr_create_cbmwh_fact_shel_nin.sql 
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

    pr_create_pfsawh_fact_shel_nin (303424, 'GBelford'); 
    
    COMMIT; 
    
END; 

*/ 

-- Exception handling variables (ps_) 

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_CREATE_PFSAWH_FACT_SHEL_NIN';  /*  */
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

v_etl_copy_cutoff          DATE; 
v_t_fact_cutoff            DATE; 
v_t_fact_cutoff_id         NUMBER; 
v_p_fact_cutoff            DATE; 
v_p_fact_cutoff_id         NUMBER; 

v_beg_a                    NUMBER;
v_end_a                    NUMBER; 
v_beg_m                    NUMBER;
v_end_m                    NUMBER; 
v_fr_dt_id                 NUMBER;
v_fr_dt                    DATE;
v_fr_dt_str                VARCHAR2(10);
v_to_dt_id                 NUMBER;

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

cv_physical_item_id        pfsawh_item_dim.physical_item_id%TYPE; 
cv_physical_item_sn_id     pfsawh_item_sn_dim.physical_item_sn_id%TYPE; 
cv_mimosa_item_sn_id       pfsawh_item_sn_dim.mimosa_item_sn_id%TYPE; 
cv_force_unit_id           pfsawh_force_unit_dim.force_unit_id%TYPE; 
cv_last_force_unit_id      pfsawh_force_unit_dim.force_unit_id%TYPE; 
cv_last_force_cmd_id       pfsawh_force_unit_dim.force_unit_id%TYPE; 

v_niin                     pfsawh_item_dim.niin%TYPE; 
v_item_nomen_standard      pfsawh_item_dim.item_nomen_standard%TYPE; 

cv_force_unit_uic          VARCHAR2(50); 
cv_last_force_unit_uic     VARCHAR2(50); 
cv_last_force_cmd_uic      VARCHAR2(50);
        
cv_force_lvl_chg           VARCHAR2(1); 
        
cv_max_date                DATE; 
cv_select_cnt              NUMBER; 

-- Unit cusor 

CURSOR item_sn_cur IS
    SELECT   cisd.physical_item_id, cisd.item_niin, 
        cisd.physical_item_sn_id, cisd.item_serial_number, 
        cisd.wh_earliest_fact_rec_dt
    FROM     pfsawh_item_sn_dim cisd 
    WHERE   cisd.physical_item_id = cv_physical_item_id -- cv_physical_item_id 141223 --
        AND cisd.wh_flag = 'Y' 
        AND cisd.wh_earliest_fact_rec_dt IS NOT NULL
    ORDER BY cisd.physical_item_id, cisd.physical_item_sn_id;

item_sn_rec    item_sn_cur%ROWTYPE; 

-- Command cursor 
        
CURSOR item_cmd_cur IS
    SELECT pea.physical_item_id, 
        pea.sys_ei_niin AS item_niin,  
        pea.physical_item_sn_id, 
        pea.sys_ei_sn AS item_serial_number, 
--        fud.uic, fud.force_unit_id, 
        fud.force_command_unit_code, fud.force_command_unit_id, 
        MIN(pea.ready_date) AS wh_earliest_fact_rec_dt  
    FROM   pfsa_equip_avail pea,    
        pfsawh_force_unit_dim fud  
    WHERE  pea.physical_item_id = v_physical_item_id 
        AND pea.physical_item_sn_id > 0 
        AND pea.sys_ei_sn <> 'AGGREGATE' 
        AND pea.pfsa_org = fud.force_command_unit_code 
        AND fud.status = 'C' 
        AND fud.force_unit_id = fud.force_command_unit_id 
        AND NOT EXISTS (
            SELECT rec_id 
            FROM   pfsawh_item_sn_p_fact pf 
            WHERE  pf.physical_item_id = pea.physical_item_id 
                AND pf.physical_item_sn_id = pea.physical_item_sn_id  
                AND pf.item_force_id = pea.force_unit_id 
            )
    GROUP BY pea.physical_item_id, pea.sys_ei_niin,  
        pea.physical_item_sn_id, pea.sys_ei_sn, 
        fud.force_command_unit_code, fud.force_command_unit_id 
    ORDER BY pea.physical_item_sn_id;  

item_cmd_rec    item_cmd_cur%ROWTYPE; 

-- AGGREGATE cursor 
        
CURSOR item_force_cur IS
    SELECT bpea.sys_ei_niin, bpea.sys_ei_sn, bpea.pfsa_item_id
        , MIN(bpea.from_dt) AS from_dt 
    FROM   bld_pfsa_equip_avail@pfsaw.lidb bpea
    WHERE  bpea.sys_ei_niin = v_niin  -- v_niin '014360007'  
        AND bpea.sys_ei_sn = 'AGGREGATE' 
    GROUP BY bpea.sys_ei_niin, bpea.sys_ei_sn, bpea.pfsa_item_id 
    ORDER BY bpea.pfsa_item_id;

item_force_rec    item_force_cur%ROWTYPE; 
        
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

    proc0.process_RecId      := 206; 
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
        
    COMMIT;     
        
    IF v_debug > 0 THEN
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

    proc1.process_RecId      := 206; 
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
        
    COMMIT;     
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc1_recId: ' || proc1_recId || ', ' || 
           proc1.process_RecId || ', ' || proc1.process_Key
           );
    END IF;  

-- Housekeeping for the process 
  
    ps_location := 'PFSAWH 00';            -- For std_pfsawh_debug_tbl logging. 

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
      
    COMMIT;

-- Call the xxxxx routine.  

    ps_location := 'PFSAWH 10';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'FACT-NIIN-ANNUAL, PERIOD'; 
  
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

    ps_location := 'PFSAWH 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

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

    DELETE pfsawh_item_sn_l_fact 
    WHERE  physical_item_id = v_physical_item_id;

    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
    DELETE pfsawh_item_sn_a_fact 
    WHERE  physical_item_id = v_physical_item_id;

    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
    DELETE pfsawh_item_sn_p_fact 
    WHERE  physical_item_id = v_physical_item_id;

    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
    DELETE pfsawh_item_sn_t_fact 
    WHERE  physical_item_id = v_physical_item_id;

    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || ', '
           );
    END IF;  
    
-- Create the fact records based upon SN     

    OPEN item_sn_cur;
    
    LOOP
        FETCH item_sn_cur 
        INTO  item_sn_rec;
        
        EXIT WHEN (item_sn_cur%NOTFOUND 
--            OR (item_sn_cur%ROWCOUNT > 1)
            ); 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        proc1.rec_read_int := NVL(proc1.rec_read_int, 0) + 1;

-- Set the annual records start and stop range. 
-- The stop point is padded to create the next anual record 6 months in advance.
        
        v_beg_a := TO_CHAR(item_sn_rec.wh_earliest_fact_rec_dt, 'YYYY');
        v_end_a := TO_CHAR((SYSDATE+185), 'YYYY');
        
-- Get the force id   
-- Initialize to NULL so it will set the last found FORCE_UNIT_ID 

        cv_select_cnt          := NULL; 
        cv_last_force_unit_uic := NULL;
        cv_last_force_unit_id  := NULL; 
        
-------------------------------------------------------------------- 
-- A future version of this procedure should include the cmd_uic   
-- from PFSA_ORG_HIST2  
-------------------------------------------------------------------- 
        
-- See if we have any reporting_org for this SN 

        SELECT COUNT(reporting_org)  
        INTO   cv_select_cnt 
        FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
        WHERE  sys_ei_niin = item_sn_rec.item_niin 
            AND sys_ei_sn = item_sn_rec.item_serial_number; 

-- If the reporting_org exists, get the earliest date 

        IF cv_select_cnt > 0 THEN 
            SELECT MAX(reporting_org)  
            INTO   cv_last_force_unit_uic
            FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
            WHERE  sys_ei_niin = item_sn_rec.item_niin 
                AND sys_ei_sn = item_sn_rec.item_serial_number 
                AND event_dt_time = ( 
                                   SELECT MIN(event_dt_time) 
                                   FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                                   WHERE  sys_ei_niin = item_sn_rec.item_niin 
                                       AND sys_ei_sn = item_sn_rec.item_serial_number 
                                   );

-- Check to see if the UIC is in the force_unit_dim 
                                   
            cv_select_cnt         := NULL; 
            
            SELECT COUNT(force_unit_id) 
            INTO   cv_select_cnt
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = cv_last_force_unit_uic 
                AND status = 'C';                 
        
            IF cv_select_cnt > 0 THEN 
            
-- Get the id from the dim 
            
                SELECT force_unit_id 
                INTO   cv_last_force_unit_id 
                FROM   pfsawh_force_unit_dim 
                WHERE  uic = cv_last_force_unit_uic  
                    AND status = 'C'; 
             
                cv_force_unit_id := cv_last_force_unit_id;    
                
            ELSE 
            
-- Logging the missing UIC in the functional_warnings 
            
                cv_force_unit_id := -1;
                -- last ? 
                
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
                    'Missing Force dim entry', 
                    ps_procedure_name, 
                    cv_last_force_unit_uic || ' - ' || v_niin, 
                    'C', 
                    l_ps_start
                    );
            END IF;
        END IF; 

        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE(item_sn_rec.physical_item_id || ', ' 
                || item_sn_rec.item_niin || ', ' 
                || item_sn_rec.physical_item_sn_id || ', ' 
                || item_sn_rec.item_serial_number || ', ' 
                || item_sn_rec.wh_earliest_fact_rec_dt || ', ' 
                || v_beg_a || ', ' || v_end_a
                );
        END IF;  
        
-- Create the Annual fact records 
        
        WHILE v_beg_a <= v_end_a 
            LOOP 
        
-- Get the force id   

            cv_select_cnt := NULL; 
        
-- See if we have any reporting_org for this SN for this year 

            SELECT COUNT(reporting_org)  
            INTO   cv_select_cnt 
            FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
            WHERE  sys_ei_niin = item_sn_rec.item_niin 
                AND sys_ei_sn = item_sn_rec.item_serial_number  
                AND event_dt_time BETWEEN TO_DATE('01-JAN-'||v_beg_a, 'DD-MON-YYYY') 
                    AND TO_DATE('31-DEC-'||v_beg_a, 'DD-MON-YYYY');

-- If the reporting_org exists, get the uis for the latest date 

            IF cv_select_cnt > 0 THEN 
                SELECT MAX(reporting_org) 
                INTO   cv_force_unit_uic
                FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                WHERE  sys_ei_niin = item_sn_rec.item_niin 
                    AND sys_ei_sn = item_sn_rec.item_serial_number 
                    AND event_dt_time = 
                       ( 
                       SELECT MAX(event_dt_time) 
                       FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                       WHERE  sys_ei_niin = item_sn_rec.item_niin 
                           AND sys_ei_sn = item_sn_rec.item_serial_number 
                           AND event_dt_time BETWEEN TO_DATE('01-JAN-'||v_beg_a, 'DD-MON-YYYY') 
                               AND TO_DATE('31-DEC-'||v_beg_a, 'DD-MON-YYYY') 
                       );
                                       
                cv_select_cnt         := NULL; 
                
-- Check to see if the UIC is in the force_unit_dim 
                                   
                SELECT COUNT(force_unit_id) 
                INTO   cv_select_cnt
                FROM   pfsawh_force_unit_dim 
                WHERE  uic = cv_force_unit_uic 
                    AND status = 'C'; 
            
                IF cv_select_cnt > 0 THEN 
                
-- Get the id from the dim 
            
                    SELECT force_unit_id 
                    INTO   cv_force_unit_id 
                    FROM   pfsawh_force_unit_dim 
                    WHERE  uic = cv_force_unit_uic  
                        AND status = 'C'; 
                 
                    cv_last_force_unit_id := cv_force_unit_id;    
                ELSE 
                        
                    cv_force_unit_id := -1;

-- Logging the missing UIC in the functional_warnings 
            
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
                        'Missing Force dim entry', 
                        ps_procedure_name, 
                        cv_force_unit_uic || ' - ' || v_niin, 
                        'C', 
                        l_ps_start
                        );
                END IF;
            END IF; 

            INSERT 
            INTO   pfsawh_item_sn_a_fact 
                (
                year_type, 
                rec_year,
                date_id, 
                physical_item_id, 
                physical_item_sn_id, 
                mimosa_item_sn_id, 
                pba_id, 
                item_force_id, 
                notes  
                )
            SELECT 'CY', 
                v_beg_a, 
                0, 
                cisd.physical_item_id, 
                cisd.physical_item_sn_id, 
                cisd.mimosa_item_sn_id, 
                1000000, 
                cv_force_unit_id, 
                item_sn_rec.item_niin || ' - ' 
                || item_sn_rec.item_serial_number
            FROM   pfsawh_item_sn_dim cisd 
            WHERE cisd.wh_flag = 'Y' 
                AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
                AND cisd.physical_item_sn_id = item_sn_rec.physical_item_sn_id
                AND NOT EXISTS (
                    SELECT l.rec_id 
                    FROM   pfsawh_item_sn_a_fact l
                    WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
                        AND v_beg_a = l.rec_year
                    );

            proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
            proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

            IF v_debug > 0 THEN
                DBMS_OUTPUT.PUT_LINE(v_beg_a); 
            END IF;  
            
-- Create the 2 period records per month 

            v_beg_m := 1;
            v_end_m := 12;
            
--            DELETE pfsawh_item_sn_p_fact;
--            COMMIT;
            
            WHILE v_beg_m <= v_end_m 
                LOOP 
                
--  Create the period record for the 1st to the 15th.                 
                
                v_fr_dt_id  := 1;
                v_fr_dt_str := v_fr_dt_id || '-' || v_beg_m || '-' || v_beg_a;
                v_fr_dt     := TO_DATE(v_fr_dt_str, 'DD-MM-YYYY'); 
                
                SELECT date_dim_id 
                INTO   v_fr_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt;
                
                SELECT date_dim_id 
                INTO   v_to_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt + 14;

-- Get the force id   
        
                cv_select_cnt := NULL; 
                cv_max_date   := NULL; 
        
-- See if we have any reporting_org for this SN for the 1st to 15th period 

                SELECT COUNT(reporting_org)
                INTO   cv_select_cnt
                FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                WHERE  sys_ei_niin = item_sn_rec.item_niin 
                    AND sys_ei_sn = item_sn_rec.item_serial_number 
                    AND event_dt_time BETWEEN v_fr_dt AND (v_fr_dt + 14); 
        
-- If the reporting_org exists, get the uis for the latest date 

                IF cv_select_cnt > 0 THEN 
                    SELECT MAX(reporting_org) 
                    INTO   cv_force_unit_uic  
                    FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                    WHERE  sys_ei_niin = item_sn_rec.item_niin 
                        AND sys_ei_sn = item_sn_rec.item_serial_number 
                        AND event_dt_time BETWEEN v_fr_dt AND (v_fr_dt + 14);

                    cv_select_cnt := NULL; 
                    
-- Check to see if the UIC is in the force_unit_dim 
                                   
                    SELECT COUNT(force_unit_id) 
                    INTO   cv_select_cnt
                    FROM   pfsawh_force_unit_dim 
                    WHERE  uic = cv_force_unit_uic 
                        AND status = 'C'; 
                
                    IF cv_select_cnt > 0 THEN 
                
-- Get the id from the dim 
            
                        SELECT force_unit_id 
                        INTO   cv_force_unit_id 
                        FROM   pfsawh_force_unit_dim 
                        WHERE  uic = cv_force_unit_uic  
                            AND status = 'C'; 
                     
                        cv_last_force_unit_id := cv_force_unit_id;    
                        
                    ELSIF cv_last_force_unit_id IS NOT NULL THEN         
                        cv_force_unit_id := cv_last_force_unit_id; 
                    ELSE 

-- Logging the missing UIC in the functional_warnings 
            
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
                            'Missing Force dim entry', 
                            ps_procedure_name, 
                            cv_force_unit_uic || ' - ' || v_niin, 
                            'C', 
                            l_ps_start
                            );
                            
                        cv_force_unit_id := cv_last_force_unit_id;
                    END IF;
                ELSE 
                    cv_force_unit_id := cv_last_force_unit_id; 
                END IF;
        
        
                IF v_debug > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('v_fr_dt_str: ' || v_fr_dt_str  
                        || ', v_fr_dt: ' || v_fr_dt
                        );
                END IF;  
            
                INSERT 
                INTO   pfsawh_item_sn_p_fact 
                    (
                    period_type,
                    date_id,                          
                    physical_item_id,                         
                    physical_item_sn_id,                      
                    mimosa_item_sn_id,        
                    pba_id,
                    item_date_from_id,                
                    item_time_from_id,
                    item_date_to_id, 
                    item_time_to_id,
                    item_force_id, 
                    item_location_id, 
                    item_days,
                    etl_processed_by 
                    ) 
                SELECT 
                    'MN' ,
                    v_fr_dt_id,                           
                    cisd.physical_item_id, 
                    cisd.physical_item_sn_id, 
                    cisd.mimosa_item_sn_id,        
                    1000000 ,
                    v_fr_dt_id,                
                    10001 ,
                    v_to_dt_id,                  
                    86401 ,
                    cv_force_unit_id, 
                    0, 
                    v_to_dt_id - v_fr_dt_id + 1, 
                    'item_sn_cur'   
                FROM   pfsawh_item_sn_dim cisd 
                WHERE cisd.wh_flag = 'Y' 
                    AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
                    AND cisd.physical_item_sn_id = item_sn_rec.physical_item_sn_id
                    AND NOT EXISTS (
                        SELECT l.rec_id 
                        FROM   pfsawh_item_sn_p_fact l
--                        WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
                        WHERE  l.physical_item_sn_id = item_sn_rec.physical_item_sn_id
                            AND v_fr_dt_id = l.date_id
                        );
                        
                proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
                
                COMMIT; 

--  Create the period record for the 16th to the end-of-month.                 
                
                v_fr_dt_id := 16;
                v_fr_dt_str := v_fr_dt_id || '-' || v_beg_m || '-' || v_beg_a;
                v_fr_dt     := TO_DATE(v_fr_dt_str, 'DD-MM-YYYY'); 
                
                SELECT date_dim_id 
                INTO   v_fr_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt;
                
                SELECT date_dim_id 
                INTO   v_to_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = LAST_DAY(v_fr_dt);
                
                INSERT 
                INTO   pfsawh_item_sn_p_fact 
                    (
                    period_type,
                    date_id,                          
                    physical_item_id,                         
                    physical_item_sn_id,                      
                    mimosa_item_sn_id,        
                    pba_id,
                    item_date_from_id,                
                    item_time_from_id,
                    item_date_to_id, 
                    item_time_to_id,
                    item_force_id, 
                    item_location_id,  
                    item_days,
                    etl_processed_by 
                    ) 
                SELECT 
                    'MN' ,
                    v_fr_dt_id,                           
                    cisd.physical_item_id, 
                    cisd.physical_item_sn_id, 
                    cisd.mimosa_item_sn_id,        
                    1000000 ,
                    v_fr_dt_id,                
                    10001 ,
                    v_to_dt_id,                  
                    86401 ,
                    cv_force_unit_id, 
                    0, 
                    v_to_dt_id - v_fr_dt_id + 1, 
                    'item_sn_cur'      
                FROM   pfsawh_item_sn_dim cisd 
                WHERE cisd.wh_flag = 'Y' 
                    AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
                    AND cisd.physical_item_sn_id = item_sn_rec.physical_item_sn_id
                    AND NOT EXISTS (
                        SELECT l.rec_id 
                        FROM   pfsawh_item_sn_p_fact l
--                        WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
                        WHERE  l.physical_item_sn_id = item_sn_rec.physical_item_sn_id
                            AND v_fr_dt_id = l.date_id
                        );
                
                proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
                
                COMMIT;         
            
                v_beg_m := v_beg_m + 1;

            END LOOP;   -- end of Period fact loop.
                
            COMMIT;         
        
            v_beg_a := v_beg_a + 1;

        END LOOP;       -- end of Annual fact loop.
    
    ps_location := 'PFSAWH 50';            -- For std_pfsawh_debug_tbl logging.

-- Create the life records   

        INSERT 
        INTO   pfsawh_item_sn_l_fact 
            (
            physical_item_id, 
            physical_item_sn_id, 
            mimosa_item_sn_id, 
            pba_id, 
            item_force_id
            )
        SELECT cisd.physical_item_id, 
            cisd.physical_item_sn_id, 
            cisd.mimosa_item_sn_id, 
            1000000, 
            cv_force_unit_id               -- cisd.item_force_id 
        FROM   pfsawh_item_sn_dim cisd 
        WHERE cisd.wh_flag = 'Y' 
            AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
            AND cisd.physical_item_sn_id = item_sn_rec.physical_item_sn_id
            AND NOT EXISTS (
                SELECT l.rec_id 
                FROM   pfsawh_item_sn_l_fact l
                WHERE  cisd. physical_item_sn_id = l.physical_item_sn_id
                )
        ORDER BY cisd.physical_item_id, cisd.physical_item_sn_id;  
        
        proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
        proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

        COMMIT; 
        
        END LOOP;       -- end of cursor loop. 
        
    CLOSE item_sn_cur; 
    
/*----------------------------------------------------------------------------*/    
    
-- Build shell fact records for 'COMMAND_UIC'     
    
    ps_location := 'PFSAWH 60';            -- For std_pfsawh_debug_tbl logging.

    OPEN item_cmd_cur;
    
    LOOP
        FETCH item_cmd_cur 
        INTO  item_cmd_rec;
        
        EXIT WHEN (item_cmd_cur%NOTFOUND 
--            OR (item_cmd_cur%ROWCOUNT > 10)
            ); 

        ps_location := 'PFSAWH 61';        -- For std_pfsawh_debug_tbl logging.

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        proc1.rec_read_int := NVL(proc1.rec_read_int, 0) + 1;

-- Set the annual records start and stop range. 
-- The stop point is padded to create the next anual record 6 months in advance.
        
        v_beg_a := TO_CHAR(item_cmd_rec.wh_earliest_fact_rec_dt, 'YYYY');
        v_end_a := TO_CHAR((SYSDATE+185), 'YYYY');
        
-- Get the force id   
-- Initialize to NULL so it will set the last found FORCE_UNIT_ID 

        cv_select_cnt          := NULL; 
        cv_last_force_cmd_uic  := NULL;
        cv_last_force_cmd_id   := NULL; 
        
-------------------------------------------------------------------- 
-- A future version of this procedure should include the cmd_uic   
-- from PFSA_ORG_HIST2  
-------------------------------------------------------------------- 
        
-- See if we have any reporting_org for this SN 

        SELECT COUNT(reporting_org)  
        INTO   cv_select_cnt 
        FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
        WHERE  sys_ei_niin = item_cmd_rec.item_niin 
            AND sys_ei_sn = item_cmd_rec.item_serial_number; 

-- If the reporting_org exists, get the earliest date 

        IF cv_select_cnt > 0 THEN 
            SELECT MAX(reporting_org)  
            INTO   cv_last_force_unit_uic
            FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
            WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                AND sys_ei_sn = item_cmd_rec.item_serial_number 
                AND event_dt_time = ( 
                                   SELECT MIN(event_dt_time) 
                                   FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                                   WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                                       AND sys_ei_sn = item_cmd_rec.item_serial_number 
                                   );

-- Check to see if the UIC is in the force_unit_dim 
                                   
            cv_select_cnt         := NULL; 
            
            SELECT COUNT(force_unit_id) 
            INTO   cv_select_cnt
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = cv_last_force_unit_uic 
                AND status = 'C';                 
        
            IF cv_select_cnt > 0 THEN 
            
-- Get the id from the dim 
            
                SELECT force_unit_id 
                INTO   cv_last_force_unit_id 
                FROM   pfsawh_force_unit_dim 
                WHERE  uic = cv_last_force_unit_uic  
                    AND status = 'C'; 
             
                cv_force_unit_id := cv_last_force_unit_id;    
                
            ELSE 
            
-- Logging the missing UIC in the functional_warnings 
            
                cv_force_unit_id := -1;
                -- last ? 
                
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
                    'Missing Force dim entry', 
                    ps_procedure_name, 
                    cv_last_force_unit_uic || ' - ' || v_niin, 
                    'C', 
                    l_ps_start
                    );
            END IF;
        END IF; 

        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE(item_cmd_rec.physical_item_id || ', ' 
                || item_cmd_rec.item_niin || ', ' 
                || item_cmd_rec.physical_item_sn_id || ', ' 
                || item_cmd_rec.item_serial_number || ', ' 
                || item_cmd_rec.wh_earliest_fact_rec_dt || ', ' 
                || v_beg_a || ', ' || v_end_a
                );
        END IF;  
        
-- Create the Annual fact records 
        
        WHILE v_beg_a <= v_end_a 
            LOOP 
        
-- Get the force command id   

            cv_select_cnt := NULL; 
        
-- See if we have any reporting_org for this SN for this year 

            SELECT COUNT(reporting_org)  
            INTO   cv_select_cnt 
            FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
            WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                AND sys_ei_sn = item_cmd_rec.item_serial_number  
                AND event_dt_time BETWEEN TO_DATE('01-JAN-'||v_beg_a, 'DD-MON-YYYY') 
                    AND TO_DATE('31-DEC-'||v_beg_a, 'DD-MON-YYYY');

-- If the reporting_org exists, get the uis for the latest date 

            IF cv_select_cnt > 0 THEN 
                SELECT MAX(reporting_org) 
                INTO   cv_force_unit_uic
                FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                    AND sys_ei_sn = item_cmd_rec.item_serial_number 
                    AND event_dt_time = 
                       ( 
                       SELECT MAX(event_dt_time) 
                       FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                       WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                           AND sys_ei_sn = item_cmd_rec.item_serial_number 
                           AND event_dt_time BETWEEN TO_DATE('01-JAN-'||v_beg_a, 'DD-MON-YYYY') 
                               AND TO_DATE('31-DEC-'||v_beg_a, 'DD-MON-YYYY') 
                       );
                                       
                cv_select_cnt         := NULL; 
                
-- Check to see if the UIC is in the force_unit_dim 
                                   
                SELECT COUNT(force_unit_id) 
                INTO   cv_select_cnt
                FROM   pfsawh_force_unit_dim 
                WHERE  uic = cv_force_unit_uic 
                    AND status = 'C'; 
            
                IF cv_select_cnt > 0 THEN 
                
-- Get the id from the dim 
            
                    SELECT force_unit_id 
                    INTO   cv_force_unit_id 
                    FROM   pfsawh_force_unit_dim 
                    WHERE  uic = cv_force_unit_uic  
                        AND status = 'C'; 
                 
                    cv_last_force_unit_id := cv_force_unit_id;    
                ELSE 
                        
                    cv_force_unit_id := -1;

-- Logging the missing UIC in the functional_warnings 
            
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
                        'Missing Force dim entry', 
                        ps_procedure_name, 
                        cv_force_unit_uic || ' - ' || v_niin, 
                        'C', 
                        l_ps_start
                        );
                END IF;
            END IF; 

--            INSERT 
--            INTO   pfsawh_item_sn_a_fact 
--                (
--                year_type, 
--                rec_year,
--                date_id, 
--                physical_item_id, 
--                physical_item_sn_id, 
--                mimosa_item_sn_id, 
--                pba_id, 
--                item_force_id, 
--                notes  
--                )
--            SELECT 'CY', 
--                v_beg_a, 
--                0, 
--                cisd.physical_item_id, 
--                cisd.physical_item_sn_id, 
--                cisd.mimosa_item_sn_id, 
--                1000000, 
--                cv_force_unit_id, 
--                item_cmd_rec.item_niin || ' - ' 
--                || item_cmd_rec.item_serial_number
--            FROM   pfsawh_item_sn_dim cisd 
--            WHERE cisd.wh_flag = 'Y' 
--                AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
--                AND cisd.physical_item_sn_id = item_cmd_rec.physical_item_sn_id
--                AND NOT EXISTS (
--                    SELECT l.rec_id 
--                    FROM   pfsawh_item_sn_a_fact l
--                    WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
--                        AND v_beg_a = l.rec_year
--                    );

            proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
            proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

            IF v_debug > 0 THEN
                DBMS_OUTPUT.PUT_LINE(v_beg_a); 
            END IF;  
            
-- Create the 2 period records per month 

            v_beg_m := 1;
            v_end_m := 12;
            
--            DELETE pfsawh_item_sn_p_fact;
--            COMMIT;
            
            WHILE v_beg_m <= v_end_m 
                LOOP 
                
--  Create the period record for the 1st to the 15th.                 
                
                v_fr_dt_id  := 1;
                v_fr_dt_str := v_fr_dt_id || '-' || v_beg_m || '-' || v_beg_a;
                v_fr_dt     := TO_DATE(v_fr_dt_str, 'DD-MM-YYYY'); 
                
                SELECT date_dim_id 
                INTO   v_fr_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt;
                
                SELECT date_dim_id 
                INTO   v_to_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt + 14;

-- Get the force id   
        
                cv_select_cnt := NULL; 
                cv_max_date   := NULL; 
        
-- See if we have any reporting_org for this SN for the 1st to 15th period 

                SELECT COUNT(reporting_org)
                INTO   cv_select_cnt
                FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                    AND sys_ei_sn = item_cmd_rec.item_serial_number 
                    AND event_dt_time BETWEEN v_fr_dt AND (v_fr_dt + 14); 
        
-- If the reporting_org exists, get the uis for the latest date 

                IF cv_select_cnt > 0 THEN 
                    SELECT MAX(reporting_org) 
                    INTO   cv_force_unit_uic  
                    FROM   bld_pfsa_sn_ei_hist@pfsaw.lidb 
                    WHERE  sys_ei_niin = item_cmd_rec.item_niin 
                        AND sys_ei_sn = item_cmd_rec.item_serial_number 
                        AND event_dt_time BETWEEN v_fr_dt AND (v_fr_dt + 14);

                    cv_select_cnt := NULL; 
                    
-- Check to see if the UIC is in the force_unit_dim 
                                   
                    SELECT COUNT(force_unit_id) 
                    INTO   cv_select_cnt
                    FROM   pfsawh_force_unit_dim 
                    WHERE  uic = cv_force_unit_uic 
                        AND status = 'C'; 
                
                    IF cv_select_cnt > 0 THEN 
                
-- Get the id from the dim 
            
                        SELECT force_unit_id 
                        INTO   cv_force_unit_id 
                        FROM   pfsawh_force_unit_dim 
                        WHERE  uic = cv_force_unit_uic  
                            AND status = 'C'; 
                     
                        cv_last_force_unit_id := cv_force_unit_id;    
                        
                    ELSIF cv_last_force_unit_id IS NOT NULL THEN         
                        cv_force_unit_id := cv_last_force_unit_id; 
                    ELSE 

-- Logging the missing UIC in the functional_warnings 
            
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
                            'Missing Force dim entry', 
                            ps_procedure_name, 
                            cv_force_unit_uic || ' - ' || v_niin, 
                            'C', 
                            l_ps_start
                            );
                            
                        cv_force_unit_id := cv_last_force_unit_id;
                    END IF;
                ELSE 
                    cv_force_unit_id := cv_last_force_unit_id; 
                END IF;
        
        
                IF v_debug > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('v_fr_dt_str: ' || v_fr_dt_str  
                        || ', v_fr_dt: ' || v_fr_dt
                        );
                END IF;  
            
                INSERT 
                INTO   pfsawh_item_sn_p_fact 
                    (
                    period_type,
                    date_id,                          
                    physical_item_id,                         
                    physical_item_sn_id,                      
                    mimosa_item_sn_id,        
                    pba_id,
                    item_date_from_id,                
                    item_time_from_id,
                    item_date_to_id, 
                    item_time_to_id,
                    item_force_id, 
                    item_location_id, 
                    item_days,
                    etl_processed_by 
                    ) 
                SELECT 
                    'MN' ,
                    v_fr_dt_id,                           
                    cisd.physical_item_id, 
                    cisd.physical_item_sn_id, 
                    cisd.mimosa_item_sn_id,        
                    1000000 ,
                    v_fr_dt_id,                
                    10001 ,
                    v_to_dt_id,                  
                    86401 ,
                    item_cmd_rec.force_command_unit_id, 
                    0, 
                    v_to_dt_id - v_fr_dt_id + 1, 
                    'item_cmd_cur'   
                FROM   pfsawh_item_sn_dim cisd 
                WHERE cisd.wh_flag = 'Y' 
                    AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
                    AND cisd.physical_item_sn_id = item_cmd_rec.physical_item_sn_id
                    AND NOT EXISTS (
                        SELECT l.rec_id 
                        FROM   pfsawh_item_sn_p_fact l
                        WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
                            AND v_fr_dt_id = l.date_id
                            AND item_cmd_rec.force_command_unit_id = l.force_command_unit_id
                        );
                        
                proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
                
                COMMIT; 

--  Create the period record for the 16th to the end-of-month.                 
                
                v_fr_dt_id := 16;
                v_fr_dt_str := v_fr_dt_id || '-' || v_beg_m || '-' || v_beg_a;
                v_fr_dt     := TO_DATE(v_fr_dt_str, 'DD-MM-YYYY'); 
                
                SELECT date_dim_id 
                INTO   v_fr_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt;
                
                SELECT date_dim_id 
                INTO   v_to_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = LAST_DAY(v_fr_dt);
                
                INSERT 
                INTO   pfsawh_item_sn_p_fact 
                    (
                    period_type,
                    date_id,                          
                    physical_item_id,                         
                    physical_item_sn_id,                      
                    mimosa_item_sn_id,        
                    pba_id,
                    item_date_from_id,                
                    item_time_from_id,
                    item_date_to_id, 
                    item_time_to_id,
                    item_force_id, 
                    item_location_id,   
                    item_days,
                    etl_processed_by 
                    ) 
                SELECT 
                    'MN' ,
                    v_fr_dt_id,                           
                    cisd.physical_item_id, 
                    cisd.physical_item_sn_id, 
                    cisd.mimosa_item_sn_id,        
                    1000000 ,
                    v_fr_dt_id,                
                    10001 ,
                    v_to_dt_id,                  
                    86401 ,
                    item_cmd_rec.force_command_unit_id, 
                    0,  
                    v_to_dt_id - v_fr_dt_id + 1, 
                    'item_cmd_cur'   
                FROM   pfsawh_item_sn_dim cisd 
                WHERE cisd.wh_flag = 'Y' 
                    AND cisd.wh_earliest_fact_rec_dt IS NOT NULL 
                    AND cisd.physical_item_sn_id = item_cmd_rec.physical_item_sn_id
                    AND NOT EXISTS (
                        SELECT l.rec_id 
                        FROM   pfsawh_item_sn_p_fact l
                        WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
                            AND v_fr_dt_id = l.date_id
                            AND item_cmd_rec.force_command_unit_id = l.force_command_unit_id
                        );
                
                proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
                
                COMMIT;         
            
                v_beg_m := v_beg_m + 1;

            END LOOP;   -- end of Period fact loop.
                
            COMMIT;         
        
            v_beg_a := v_beg_a + 1;

        END LOOP;       -- end of Annual fact loop.
    
    ps_location := 'PFSAWH 50';            -- For std_pfsawh_debug_tbl logging.

    COMMIT;  

    END LOOP;    
        
    CLOSE item_cmd_cur;
    
/*----------------------------------------------------------------------------*/    
    
-- Build shell fact records for 'AGGREGATE'     
    
    ps_location := 'PFSAWH 70';            -- For std_pfsawh_debug_tbl logging.

-- Get the 'AGGREGATE' serial number id 

    cv_select_cnt         := NULL;     
    cv_last_force_unit_id := NULL;
        
    SELECT COUNT(physical_item_sn_id) 
    INTO   cv_select_cnt
    FROM   pfsawh_item_sn_dim 
    WHERE  physical_item_id = cv_physical_item_id  
        AND item_serial_number = 'AGGREGATE'       
        AND status = 'C'; 
        
    IF cv_select_cnt > 0 THEN 
        SELECT physical_item_sn_id, 
               mimosa_item_sn_id 
        INTO   cv_physical_item_sn_id, 
               cv_mimosa_item_sn_id
        FROM   pfsawh_item_sn_dim 
        WHERE  physical_item_id = cv_physical_item_id  
            AND item_serial_number = 'AGGREGATE'       
            AND status = 'C'; 
    ELSE 
        cv_physical_item_sn_id := -1; 
            
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
            'Missing Item SN dim entry', 
            ps_procedure_name, 
            cv_physical_item_id || ' - ' || v_niin || ' - AGGREGATE', 
            'C', 
            l_ps_start
            ); 
            
        SELECT MAX(physical_item_sn_id) + 1 
        INTO   cv_physical_item_sn_id 
        FROM   pfsawh_item_sn_dim 
        WHERE  physical_item_sn_id < 10000;      
            
        INSERT 
        INTO  pfsawh_item_sn_dim 
            ( 
            physical_item_id, 
            physical_item_sn_id, 
            mimosa_item_sn_id, 
            item_serial_number, 
            item_niin, 
            item_registration_num, 
            status 
            )
        VALUES
            (
            cv_physical_item_id,
            cv_physical_item_sn_id,
            LPAD(LTRIM(TO_CHAR(cv_physical_item_sn_id, 'XXXXXXX')), 8, '0'), 
            'AGGREGATE',
            v_niin,
            'UNK',
            'C'
            );     
            
        UPDATE pfsawh_functional_warnings 
        SET    warning_status = 'H', 
               action_taken   = 'Automated added of sn AGGREGATE by ' || ps_procedure_name
        WHERE  warning_msg = cv_physical_item_id || ' - ' || v_niin || ' - AGGREGATE' 
            AND warning_status = 'C'; 
                
        COMMIT; 

    END IF;
            
    OPEN item_force_cur;
    
    LOOP
        FETCH item_force_cur 
        INTO  item_force_rec;
        
        EXIT WHEN (item_force_cur%NOTFOUND 
--            OR (item_force_cur%ROWCOUNT > 10)
            ); 

        ps_location := 'PFSAWH 80';        -- For std_pfsawh_debug_tbl logging.

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        proc1.rec_read_int := NVL(proc1.rec_read_int, 0) + 1;

-- Set the annual records start and stop range. 
-- The stop point is padded to create the next anual record 6 months in advance.
        
        v_beg_a := TO_CHAR(item_force_rec.from_dt, 'YYYY');
        v_end_a := TO_CHAR((SYSDATE+185), 'YYYY');
        
-- Get the force id   
        
        cv_select_cnt         := NULL; 

        SELECT COUNT(force_unit_id) 
        INTO   cv_select_cnt
        FROM   pfsawh_force_unit_dim 
        WHERE  uic = item_force_rec.pfsa_item_id 
            AND status = 'C'; 
        
        IF cv_select_cnt > 0 THEN 
            SELECT force_unit_id 
            INTO   cv_force_unit_id 
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = item_force_rec.pfsa_item_id 
                AND status = 'C'; 
        ELSIF cv_last_force_unit_id IS NOT NULL THEN  
            cv_force_unit_id := cv_last_force_unit_id; 
        ELSE 
            cv_force_unit_id := -1; 
            
--            INSERT 
--            INTO pfsawh_functional_warnings 
--                (
--                warning_type,
--                warning_from,
--                warning_msg,
--                warning_status,
--                warning_time 
--                )
--            VALUES 
--                (
--                'Missing dimension entry', 
--                ps_procedure_name, 
--                item_force_rec.pfsa_item_id, 
--                'C', 
--                l_ps_start
--                );
        END IF;

-- Set the periods record start and stop range. 
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE(item_force_rec.sys_ei_niin || ', ' 
                || item_force_rec.sys_ei_sn || ', ' 
                || item_force_rec.pfsa_item_id || ', ' 
                || item_force_rec.from_dt || ', ' 
                || v_beg_a || ', ' || v_end_a
                );
        END IF;  


-- Create the Annual fact records 
        
        WHILE v_beg_a <= v_end_a 
            LOOP 
        
            ps_location := 'PFSAWH 90';    -- For std_pfsawh_debug_tbl logging.

            cv_select_cnt         := NULL; 
             
            SELECT  COUNT(rec_id) 
            INTO    cv_select_cnt
            FROM    pfsawh_item_sn_a_fact af
            WHERE   af.rec_year             = v_beg_a 
                AND af.physical_item_id     = cv_physical_item_id 
                AND af.physical_item_sn_id  = cv_physical_item_sn_id  
                AND af.pba_id               = 1000000 
                and af.item_force_id        = cv_force_unit_id;

            IF cv_select_cnt < 1 THEN 
                INSERT 
                INTO   pfsawh_item_sn_a_fact 
                    (
                    year_type, 
                    rec_year,
                    date_id, 
                    physical_item_id, 
                    physical_item_sn_id, 
                    mimosa_item_sn_id, 
                    pba_id, 
                    item_force_id, 
                    item_location_id
                    )
                VALUES( 'CY', 
                    v_beg_a, 
                    0, 
                    cv_physical_item_id, 
                    cv_physical_item_sn_id,  
                    cv_mimosa_item_sn_id, 
                    1000000, 
                    cv_force_unit_id, 
                    -1
                    );
            END IF;

            proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
            proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT;

-- Create the 2 Period fact records per month 

            v_beg_m := 1;
            v_end_m := 12;
            
            WHILE v_beg_m <= v_end_m 
                LOOP 
                
                ps_location := 'PFSAWH 100'; -- For std_pfsawh_debug_tbl logging.

--  Create the period record for the 1st to the 15th.                 
                
                v_fr_dt_id  := 1;
                v_fr_dt_str := v_fr_dt_id || '-' || v_beg_m || '-' || v_beg_a;
                v_fr_dt     := TO_DATE(v_fr_dt_str, 'DD-MM-YYYY'); 
                
                SELECT date_dim_id 
                INTO   v_fr_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt;
                
                SELECT date_dim_id 
                INTO   v_to_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt + 14;
                
                IF v_debug > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('v_fr_dt_str: ' || v_fr_dt_str  
                        || ', v_fr_dt: ' || v_fr_dt
                        );
                END IF;  
            
                INSERT 
                INTO   pfsawh_item_sn_p_fact 
                    (
                    period_type,
                    date_id,                          
                    physical_item_id,                         
                    physical_item_sn_id,                      
                    mimosa_item_sn_id,        
                    pba_id,
                    item_date_from_id,                
                    item_time_from_id,
                    item_date_to_id, 
                    item_time_to_id,
                    item_force_id, 
                    item_location_id,
                    etl_processed_by 
                    ) 
--                VALUES ( 'MN',
--                    v_fr_dt_id,                           
--                    cv_physical_item_id, 
--                    cv_physical_item_sn_id, 
--                    cv_mimosa_item_sn_id,        
--                    1000000 ,
--                    v_fr_dt_id,                
--                    10001 ,
--                    v_to_dt_id,                  
--                    86401 ,
--                    cv_force_unit_id, 
--                    0   
--                    );
                SELECT  'MN',
                    v_fr_dt_id,                           
                    cv_physical_item_id, 
                    cv_physical_item_sn_id, 
                    cv_mimosa_item_sn_id,        
                    1000000 ,
                    v_fr_dt_id,                
                    10001 ,
                    v_to_dt_id,                  
                    86401 ,
                    cv_force_unit_id, 
                    0,
                    'item_force_cur'   
                FROM dual
                WHERE NOT EXISTS 
                    (
                    SELECT rec_id 
                    FROM   pfsawh_item_sn_p_fact 
                    WHERE  date_id              = v_fr_dt_id 
                        AND item_date_from_id   = v_fr_dt_id 
                        AND item_date_to_id     = v_to_dt_id 
                        AND physical_item_id    = cv_physical_item_id
                        AND physical_item_sn_id = cv_physical_item_sn_id 
                        AND item_force_id       = cv_force_unit_id 
                    );
                       
                proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
                
--                COMMIT; 

--  Create the period record for the 16th to the end-of-month.                 
                
                v_fr_dt_id := 16;
                v_fr_dt_str := v_fr_dt_id || '-' || v_beg_m || '-' || v_beg_a;
                v_fr_dt     := TO_DATE(v_fr_dt_str, 'DD-MM-YYYY'); 
                
                SELECT date_dim_id 
                INTO   v_fr_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = v_fr_dt;
                
                SELECT date_dim_id 
                INTO   v_to_dt_id  
                FROM   sharedwh.date_dim 
                WHERE  oracle_date = LAST_DAY(v_fr_dt);
                
                INSERT 
                INTO   pfsawh_item_sn_p_fact 
                    (
                    period_type,
                    date_id,                          
                    physical_item_id,                         
                    physical_item_sn_id,                      
                    mimosa_item_sn_id,        
                    pba_id,
                    item_date_from_id,                
                    item_time_from_id,
                    item_date_to_id, 
                    item_time_to_id,
                    item_force_id, 
                    item_location_id,
                    etl_processed_by 
                    ) 
                SELECT  'MN',
                    v_fr_dt_id,                           
                    cv_physical_item_id, 
                    cv_physical_item_sn_id, 
                    cv_mimosa_item_sn_id,        
                    1000000 ,
                    v_fr_dt_id,                
                    10001 ,
                    v_to_dt_id,                  
                    86401 ,
                    cv_force_unit_id, 
                    0, 
                    'item_force_cur'   
                FROM dual
                WHERE NOT EXISTS 
                    (
                    SELECT rec_id 
                    FROM   pfsawh_item_sn_p_fact 
                    WHERE  date_id              = v_fr_dt_id 
                        AND item_date_from_id   = v_fr_dt_id 
                        AND item_date_to_id     = v_to_dt_id 
                        AND physical_item_id    = cv_physical_item_id
                        AND physical_item_sn_id = cv_physical_item_sn_id
                        AND item_force_id       = cv_force_unit_id 
                    );
                
                proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
                
--                COMMIT;         
            
                v_beg_m := v_beg_m + 1;

            END LOOP;   -- end of Period fact loop.
                
            v_beg_a := v_beg_a + 1;

        END LOOP;       -- end of Annual fact loop.
    
---- Create the life records   

        END LOOP;       -- end of cursor loop. 
        
    COMMIT;     
        
    CLOSE item_force_cur;
    
-- Analyze the table and re-build the indexes 

    IF run_reindex('pfsawh_item_sn_p_fact') THEN 

        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsawh_item_sn_p_fact          DELETE STATISTICS'; 
        EXECUTE IMMEDIATE 'ANALYZE TABLE pfsawh_item_sn_p_fact          COMPUTE STATISTICS'; 
        
        EXECUTE IMMEDIATE 'ALTER INDEX   pk_pfsawh_item_sn_p_fact       REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   ixu_pfsawh_item_sn_p_fact      REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsawh_item_sn_p_fact_itm  REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX   idx_pfsawh_item_sn_p_fact_sn   REBUILD';
        
    END IF; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := 'PFSAWH 110';            -- For std_pfsawh_debug_tbl logging.

    l_now_is := sysdate; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
    ps_location := 'PFSAWH 120';            -- For std_pfsawh_debug_tbl logging.

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
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
    ps_location := 'PFSAWH 130';            -- For std_pfsawh_debug_tbl logging.

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

--  Set the inner calling module (proc1.) values.

    proc1_recId              := NULL; 

    proc1.process_RecId      := 206; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 20;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := v_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
  
    proc1.rec_read_int     := NULL;
    proc1.rec_inserted_int := NULL;

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
        
-- Call the xxxxx routine.  

    ps_location := 'PFSAWH 140';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'FACT-NIIN-LIFE'; 
  
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

-- Update the pfsa_processes table to indicate the sub-process has started.  

    ps_location := 'PFSAWH 150';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
    UPDATE pfsawh_item_sn_l_fact lf  
    SET    pba_id = ( 
                    SELECT NVL(ref.pba_id, 1000000)
                    FROM   pfsawh.pfsa_pba_items_ref ref, 
                           pfsawh.pfsa_pba_ref pba
                    WHERE  ref.item_identifier_type_id = 13 
                        AND pba.pba_key1 = 'USA' 
                        AND ref.pba_id = pba.pba_id  
                        AND ref.physical_item_id = lf.physical_item_id 
                    ) 
    WHERE lf.pba_id = 1000000 
        OR lf.pba_id IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    UPDATE pfsawh_item_sn_a_fact lf  
    SET    pba_id = ( 
                    SELECT NVL(ref.pba_id, 1000000)
                    FROM   pfsawh.pfsa_pba_items_ref ref, 
                           pfsawh.pfsa_pba_ref pba
                    WHERE  ref.item_identifier_type_id = 13 
                        AND pba.pba_key1 = 'USA' 
                        AND ref.pba_id = pba.pba_id  
                        AND ref.physical_item_id = lf.physical_item_id 
                    ) 
    WHERE lf.pba_id = 1000000 
        OR lf.pba_id IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    UPDATE pfsawh_item_sn_p_fact lf  
    SET    pba_id = ( 
                    SELECT NVL(ref.pba_id, 1000000)
                    FROM   pfsawh.pfsa_pba_items_ref ref, 
                           pfsawh.pfsa_pba_ref pba
                    WHERE  ref.item_identifier_type_id = 13 
                        AND pba.pba_key1 = 'USA' 
                        AND ref.pba_id = pba.pba_id  
                        AND ref.physical_item_id = lf.physical_item_id 
                    ) 
    WHERE lf.pba_id = 1000000 
        OR lf.pba_id IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := 'PFSAWH 160';            -- For std_pfsawh_debug_tbl logging.

    l_now_is := sysdate; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
    ps_location := 'PFSAWH 170';            -- For std_pfsawh_debug_tbl logging.

-- update the pfsa_process table to indicate STATUS of MAINTAIN_PFSA_DATES 
  
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
    proc1.message := proc1.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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
        ps_procedure_name, ps_oerr, ps_location, NULL, 
        ps_id_key, ps_msg, SYSDATE
        );
        
    COMMIT; 

END; -- end of procedure
/


