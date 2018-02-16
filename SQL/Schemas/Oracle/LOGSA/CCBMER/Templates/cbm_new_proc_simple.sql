CREATE OR REPLACE PROCEDURE %YourObjectName% 
(
p_physical_item_id             IN    cbm_pba_items_ref.physical_item_id%TYPE, -- Warehouse id for the NIIN 
p_type_maintenance             IN    std_cbm_debug_tbl.ps_id_key%TYPE -- Calling procedure name, used in 
                               -- debugging, calling procedure responsible for maintaining heirachy 
)

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: %YourObjectName%..
--            SP Desc: 
--
--      SP Created By: %USERNAME%..
--    SP Created Date: %SYSDATE%..
--
--          SP Source: %YourObjectName%.sql..
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
-- DD-MMM-YYYY - Who         - RDPTSK##### / ECPTSK##### - Details..
-- %SYSDATE% - %USERNAME%  -                 - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         %SYSDATE%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

DECLARE 
  
p_physical_item_id             cbm_pba_items_ref.physical_item_id%TYPE;  
p_type_maintenance             std_cbm_debug_tbl.ps_id_key%TYPE; 

BEGIN 

    p_physical_item_id := 141146; 
    p_type_maintenance := 'GBelford'; 

    %YourObjectName% (p_physical_item_id, p_type_maintenance); 
    
    COMMIT;  

END; 

*/ 

-- Exception handling variables (ps_)..

ps_procedure_name                std_cbm_debug_tbl.ps_procedure%TYPE  
    := '%YourObjectName%';     /*  */
ps_location                      std_cbm_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_cbm_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_cbm_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_cbm_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

proc0_recId                      cbm_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                      cbm_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                            cbm_process_log%ROWTYPE; 
proc1                            cbm_process_log%ROWTYPE; 

ps_last_process                  cbm_processes%ROWTYPE;
ps_this_process                  cbm_processes%ROWTYPE;
ls_current_process               cbm_processes%ROWTYPE; 

v_etl_copy_cutoff_days           cbm_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days             cbm_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months           cbm_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                          NUMBER        
     := 0;   -- Controls debug options (0 - Off)..

v_physical_item_id               NUMBER; 

v_pba_id                         cbm_pba_items_ref.pba_id%TYPE; 

----------------------------------- START --------------------------------------

BEGIN

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'p_physical_item_id: ' || p_physical_item_id || ', ' || 
           'p_type_maintenance: ' || p_type_maintenance
           );
    END IF;  
    
    v_physical_item_id := p_physical_item_id;

    BEGIN 
        SELECT pba_id 
        INTO   v_pba_id 
        FROM   cbm_pba_items_ref 
        WHERE  physical_item_id = p_physical_item_id; 
    EXCEPTION 
        WHEN OTHERS THEN 
            ps_oerr   := SQLCODE; 
            ps_msg    := SUBSTR(SQLERRM, 1, 200); 
            ps_id_key := SUBSTR(ps_id_key, 1, 200);
                
            INSERT 
            INTO std_cbm_debug_tbl 
            (
            ps_procedure,      ps_oerr, ps_location, called_by, 
            ps_id_key,         ps_msg,  msg_dt
            )
            VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, NULL, 
            ps_id_key,         ps_msg,  SYSDATE
            );
    END; 

--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 215; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    
    ps_id_key := NVL(p_type_maintenance, ps_procedure_name);
  
    ps_location := SUBSTR('00-Start', 1, 200); 

    cbm_insupd_processlog (
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

-- If the v_rec_Id is NULL then we assume that a new log record is required

--    IF s0_rec_Id IS NULL THEN
-- 
--        ps_location := '05-Insert'; 
--        
--        IF v_debug > 0 THEN 
--            DBMS_OUTPUT.PUT_LINE('Insert'); 
--        END IF;

--    ELSE
--    
--        ps_location := '10-Update'; 
--        
--        IF v_debug > 0 THEN 
--            DBMS_OUTPUT.PUT_LINE('Update in_rec_Id: ' || in_rec_Id); 
--        END IF;

--    END IF;

    IF v_debug > 0 THEN 
    
        DBMS_OUTPUT.NEW_LINE;

        FOR c_pba_ref 
        IN (
            SELECT pba_id, pba_title  
            FROM   cbm_pba_ref 
            WHERE  status = 'C' 
            )
        LOOP
            DBMS_OUTPUT.PUT_LINE(c_pba_ref.pba_id || ' - ' 
                || c_pba_ref.pba_title);
        
        END LOOP;
    
    END IF;

    ps_location := SUBSTR('99-Close', 1, 10);

    proc0.process_end_date    := SYSDATE;
    proc0.sql_error_code      := SQLCODE;
    proc0.process_status_code := NVL(proc0.sql_error_code, SQLCODE);
    proc0.message             := SUBSTR(SQLCODE || ' - ' || SQLERRM, 1, 200); 
    
    cbm_insupd_processlog 
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
        WHEN NO_DATA_FOUND THEN
            ps_oerr   := SQLCODE; 
            ps_msg    := SUBSTR(SQLERRM, 1, 200); 
            ps_id_key := SUBSTR(ps_id_key, 1, 200);
            
            INSERT 
            INTO std_cbm_debug_tbl 
            (
            ps_procedure,      ps_oerr, ps_location, called_by, 
            ps_id_key,         ps_msg,  msg_dt
            )
            VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, NULL, 
            ps_id_key,         ps_msg,  SYSDATE
            );
        WHEN OTHERS THEN
            ps_oerr   := SQLCODE; 
            ps_msg    := SUBSTR(SQLERRM, 1, 200); 
            ps_id_key := SUBSTR(ps_id_key, 1, 200);
            
            INSERT 
            INTO std_cbm_debug_tbl 
            (
            ps_procedure,      ps_oerr, ps_location, called_by, 
            ps_id_key,         ps_msg,  msg_dt
            )
            VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, NULL, 
            ps_id_key,         ps_msg,  SYSDATE
            );
            
END %YourObjectName%;
/
