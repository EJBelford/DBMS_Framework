/*
--
-- PFSA_FCS_SYS_DATES  (Table) 
--
CREATE TABLE pfsa_fcs_sys_dates
(
  equip_avail_period_date  DATE,
  maint_event_period_date  DATE,
  usage_period_date        DATE,
  monthly_cwt_period_date  DATE,
  status                   VARCHAR2(1 BYTE)     DEFAULT 'C',
  lst_updt                 DATE                 DEFAULT SYSDATE,
  updt_by                  VARCHAR2(30 BYTE)    DEFAULT SUBSTR(USER,1,30)
)
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


COMMENT ON COLUMN pfsa_fcs_sys_dates.equip_avail_period_date 
IS 'EQUIP_AVAIL_PERIOD_DATE  <= READY_DATE  <=  PFSA_EQUIP_AVAIL  Current period date for the most current full period of data imported from pfsa_equip_avail into the pfsawh warehouse.  Used in the BI tool to filter data for monthly availability screens.';

COMMENT ON COLUMN pfsa_fcs_sys_dates.maint_event_period_date 
IS 'MAINT_EVENT_PERIOD_DATE  <= MAINT_EV_ID or DT_MAINT_EV_EST or DT_MAINT_EV_COMP <= PFSA_MAINT_EVENT  Current period date for the most current full period of data imported from pfsa_maint_* tables into the pfsawh warehouse.  Used in the BI tool to filter data for monthly Mean Down Time screens.';

COMMENT ON COLUMN pfsa_fcs_sys_dates.usage_period_date 
IS 'USAGE_PERIOD_DATE        <= READY_DATE  <=  PFSA_USAGE_EVENT  Current period date for the most current full period of data imported from pfsa_usage_event into the pfsawh warehouse.  Used in the BI tool to filter data for monthly MTBMA screens.';

COMMENT ON COLUMN pfsa_fcs_sys_dates.monthly_cwt_period_date 
IS 'MONTHLY_CWT_PERIOD_DATE  <=   Current period date for the most current full period of data imported from ilap cwt view into the pfsawh warehouse.  Used in the BI tool to filter data for monthly CWT screens.';

*/ 

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_upd_pfsa_fsc_sys_dates 
--            SP Desc: 
--
--      SP Created By: Gene Belford 
--    SP Created Date: 12 Aug 2008  
--
--          SP Source: pr_upd_pfsa_fsc_sys_dates.sql 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--      SP Parameters: 
--              Input: TYPE_MAINTENANCE  - calling procedure name, used in 
--                     debugging, calling procedure responsible for maintaining 
--                     heirachy 
--                     FSC_SYS_DATE_FIELD - The field to be update in the 
--                     PFSA_FCS_SYS_DATES table. 
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
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Testing Scripts 

/* 

BEGIN 

    pr_upd_pfsa_fsc_sys_dates ('GBelford', 'EQUIP_AVAIL_PERIOD_DATE' ); 
    
    COMMIT; 

    pr_upd_pfsa_fsc_sys_dates ('GBelford', 'MAINT_EVENT_PERIOD_DATE' ); 
    
    COMMIT; 

    pr_upd_pfsa_fsc_sys_dates ('GBelford', 'USAGE_PERIOD_DATE'); 
    
    COMMIT; 

    pr_upd_pfsa_fsc_sys_dates ('GBelford', 'MONTHLY_CWT_PERIOD_DATE' ); 
    
    COMMIT; 

END; 

*/ 

CREATE OR REPLACE PROCEDURE pr_upd_pfsa_fsc_sys_dates    
    (
    type_maintenance     IN   VARCHAR2, -- Calling procedure name, used in 
                                        -- debugging, calling procedure 
                                        -- responsible for maintaining 
                                        -- heirachy 
    fsc_sys_date_field   IN   VARCHAR2  -- The field to be update in the 
                                        -- PFSA_FCS_SYS_DATES table.
    )
    
IS

-- Exception handling variables (ps_) 

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_UPD_PFSA_FSC_SYS_DATES';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'Field to update not found'; /*  */
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

v_fsc_sys_date          DATE; 
v_fsc_sys_date_01       DATE; 
v_fsc_sys_date_02       DATE; 
v_fsc_sys_date_03       DATE; 

BEGIN 

    proc0.process_RecId      := 108; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    
    ps_id_key := NVL(type_maintenance, ps_procedure_name); 

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

-- Housekeeping for the process 
  
    ps_location := 'FSC DT 00';            -- For std_pfsawh_debug_tbl logging. 

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

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Start: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY  HH24:MI:SS'));
    END IF;  

/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    IF UPPER(fsc_sys_date_field) = 'EQUIP_AVAIL_PERIOD_DATE' THEN 
    
        ps_location := 'FSC DT 10';
        
        SELECT NVL(MAX(ready_date), TO_DATE('01-JAN-1900', 'DD-MON-YYYY')) 
        INTO   v_fsc_sys_date 
        FROM   pfsa_equip_avail
        WHERE  ready_date <= (SYSDATE - 3); 
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Field: ' || fsc_sys_date_field ||  
               ' Max Date: ' || TO_CHAR(v_fsc_sys_date, 'DD-MON-YYYY'));
        END IF;  

        UPDATE pfsa_fcs_sys_dates 
        SET    equip_avail_period_date = v_fsc_sys_date, 
               lst_updt = SYSDATE, 
               updt_by  = ps_id_key 
        WHERE  equip_avail_period_date < v_fsc_sys_date 
            AND v_fsc_sys_date < SYSDATE;
    
        COMMIT; 
            
    ELSIF UPPER(fsc_sys_date_field) = 'MAINT_EVENT_PERIOD_DATE' THEN 

        ps_location := 'FSC DT 20'; 
        
        v_fsc_sys_date := TO_DATE('01-JAN-1900', 'DD-MON-YYYY'); 
    
        SELECT 
--            NVL(TO_CHAR(TO_DATE(MAX(TO_NUMBER(SUBSTR(maint_ev_id, INSTR(maint_ev_id, '|')+1, LENGTH(maint_ev_id)))), 'YYYYMMDD'), 'DD-MON-YYYY'), 'DD-MON-YYYY'), 
--            NVL(TO_CHAR(MAX(TO_DATE(dt_maint_ev_est,  'DD-MON-YY')), 'DD-MON-YYYY'), 'DD-MON-YYYY'),   
            NVL(TO_CHAR(MAX(TO_DATE(dt_maint_ev_cmpl, 'DD-MON-YY')), 'DD-MON-YYYY'), SYSDATE) 
        INTO --  v_fsc_sys_date_01,  
             --  v_fsc_sys_date_02, 
               v_fsc_sys_date_03
        FROM   pfsa_maint_event 
        WHERE  dt_maint_ev_cmpl < SYSDATE;
--            AND dt_maint_ev_est < SYSDATE; 
            
--        IF v_fsc_sys_date < v_fsc_sys_date_01 
--            AND v_fsc_sys_date_01 < (SYSDATE - 3) THEN 
--            
--            v_fsc_sys_date := v_fsc_sys_date_01;
--            
--        END IF;

--        IF v_fsc_sys_date < v_fsc_sys_date_02 
--            AND v_fsc_sys_date_02 < (SYSDATE - 30) THEN 
--            
--            v_fsc_sys_date := v_fsc_sys_date_02;
--            
--        END IF;

        IF v_fsc_sys_date < v_fsc_sys_date_03 
            AND v_fsc_sys_date_03 < (SYSDATE - 30) THEN 
            
--            SELECT  ready_date 
--            INTO    v_fsc_sys_date 
--            FROM    pfsawh_ready_date_dim
--            WHERE   v_fsc_sys_date_03 = oracle_date; 

            v_fsc_sys_date := v_fsc_sys_date_03;
            
            SELECT  ready_date 
            INTO    v_fsc_sys_date 
            FROM    pfsawh_ready_date_dim
            WHERE   v_fsc_sys_date_03 = oracle_date; 

        END IF;
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Field: ' || fsc_sys_date_field ||  
               ' Max Date: ' || TO_CHAR(v_fsc_sys_date, 'DD-MON-YYYY') ||   
               ' Event ID Date: ' || TO_CHAR(v_fsc_sys_date_01, 'DD-MON-YYYY') ||    
               ' Event Est Date: ' || TO_CHAR(v_fsc_sys_date_02, 'DD-MON-YYYY') ||    
               ' Event Cmpl Date: ' || TO_CHAR(v_fsc_sys_date_03, 'DD-MON-YYYY'));
        END IF;  

        UPDATE pfsa_fcs_sys_dates 
        SET    maint_event_period_date = v_fsc_sys_date, 
               lst_updt = SYSDATE, 
               updt_by  = ps_id_key 
        WHERE  maint_event_period_date < v_fsc_sys_date 
            AND v_fsc_sys_date < SYSDATE; 

        COMMIT; 
            
    ELSIF UPPER(fsc_sys_date_field) = 'USAGE_PERIOD_DATE' THEN 
    
        ps_location := 'FSC DT 30';
    
        SELECT NVL(MAX(ready_date), TO_DATE('01-JAN-1900', 'DD-MON-YYYY')) 
        INTO   v_fsc_sys_date 
        FROM   pfsa_usage_event 
        WHERE  ready_date <= (SYSDATE - 3); 
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Field: ' || fsc_sys_date_field ||  
               ' Max Date: ' || TO_CHAR(v_fsc_sys_date, 'DD-MON-YYYY'));
        END IF;  

        UPDATE pfsa_fcs_sys_dates 
        SET    usage_period_date = v_fsc_sys_date, 
               lst_updt = SYSDATE, 
               updt_by  = ps_id_key 
        WHERE  usage_period_date < v_fsc_sys_date 
            AND v_fsc_sys_date < SYSDATE;
    
        COMMIT; 
            
    ELSIF UPPER(fsc_sys_date_field) = 'MONTHLY_CWT_PERIOD_DATE' THEN 
    
        ps_location := 'FSC DT 40';
    
        SELECT NVL(MAX(wh_period_date), TO_DATE('01-JAN-1900', 'DD-MON-YYYY')) 
        INTO   v_fsc_sys_date 
        FROM   pfsa_supply_ilap 
        WHERE  wh_period_date <= (SYSDATE - 3); 
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Field: ' || fsc_sys_date_field ||  
               ' Max Date: ' || TO_CHAR(v_fsc_sys_date, 'DD-MON-YYYY'));
        END IF;  

        UPDATE pfsa_fcs_sys_dates 
        SET    monthly_cwt_period_date = v_fsc_sys_date, 
               lst_updt = SYSDATE, 
               updt_by  = ps_id_key 
        WHERE  monthly_cwt_period_date < v_fsc_sys_date 
            AND v_fsc_sys_date < SYSDATE;
            
        COMMIT; 
            
    ELSE         

        ps_oerr := -1; 
        ps_msg  := fsc_sys_date_field; 
        
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
        
    END IF;
  
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/  

    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Stop:  ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY  HH24:MI:SS'));
    END IF;  

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

END; 

