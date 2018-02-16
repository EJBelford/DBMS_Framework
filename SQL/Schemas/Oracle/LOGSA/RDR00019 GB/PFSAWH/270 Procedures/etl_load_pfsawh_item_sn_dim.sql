/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_PHSAWH_blank
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_PHSAWH_blank.sql
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
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

BEGIN 

    etl_load_pfsawh_item_sn_dim ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_load_pfsawh_item_sn_dim 
    (
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )

IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_LOAD_PFSAWH_ITEM_SN_DIM';     /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

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

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

v_nsn                        pfsawh_item_dim.nsn%TYPE            := '';
v_niin                       pfsawh_item_dim.niin%TYPE           := '';

v_item_id                    pfsawh_item_sn_dim.physical_item_id%TYPE     := '';
v_status                     pfsawh_item_sn_dim.status%TYPE      := '';
v_notes                      pfsawh_item_sn_dim.item_notes%TYPE  := '';

CURSOR ei_sn_cur IS
    SELECT ei.status, 
        pid.physical_item_id, 
        ei.sys_ei_niin,
        ei.sys_ei_sn,
        ei.sn_item_state,
        ei.ready_state,
        ei.sys_ei_state,
        ei.sensored_item,
        ei.owning_org,
        ei.sys_ei_uid,
        ei.physical_item_id as sn_physical_item_id,
        ei.physical_item_sn_id,
        ei.mimosa_item_sn_id,
        ei.as_of_date   
--        , ei.lst_updt,      ei.updt_by,
--        ei.possessor,
--        ei.active_flag,   ei.active_date,   ei.inactive_date,
--        ei.insert_by,     ei.insert_date,
--        ei.update_by,     ei.update_date,
--        ei.delete_flag,   ei.delete_date,   ei.delete_by,
--        ei.hidden_flag,   ei.hidden_date,   ei.hidden_by
    FROM pfsa_sn_ei@pfsaw.lidb ei, 
        pfsawh_item_dim pid  
    WHERE NOT EXISTS ( 
            SELECT isd.item_serial_number 
            FROM   pfsawh_item_sn_dim isd 
            WHERE  ei.sys_ei_niin = isd.item_niin 
                AND ei.sys_ei_sn = isd.item_serial_number  
        )
        AND EXISTS (
            SELECT pidd.niin 
            FROM   pfsawh_item_dim pidd 
            WHERE  ei.sys_ei_niin = pidd.niin 
        ) 
        AND ei.status = 'C' 
        AND ei.sys_ei_niin = pid.niin
    ORDER BY ei.sys_ei_niin, ei.sys_ei_sn;
    
ei_sn_rec    ei_sn_cur%ROWTYPE;
    
----------------------------------- START --------------------------------------
   
BEGIN 

    ps_location := 'PFSA 0';            -- For std_pfsawh_debug_tbl logging. 
    ls_current_process.pfsa_process := 'ETL_LOAD_PFSAWH_ITEM_SN_DIM'; 
    
--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 106; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    proc0.message            := NULL;
    
    ps_id_key := NVL(type_maintenance, ps_procedure_name);
  
    ps_location := '00-Start';

    pr_pfsawh_InsUpd_ProcessLog (
        proc0.process_RecId, proc0.process_Key, 
        proc0.module_Num, proc0.step_Num,  
        proc0.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc0.user_Login_Id, NULL, proc0_recId
        );

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
    
        DBMS_OUTPUT.PUT_LINE('type_maintenance: ' || type_maintenance 
--        || ', ' || s0_processRecId || ', ' || s0_processKey
        );
    END IF;  
    
    COMMIT; 

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
    ps_this_process.who_ran              := ps_id_key;

-- update the pfsa_process table to indicate SUB process has started 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging. 
    
-- Check pfsa_equip_avail@pfsaw.lidbdev for new serial numbers     
    
    OPEN ei_sn_cur;
    
    LOOP
        FETCH ei_sn_cur 
        INTO  ei_sn_rec;
        
        EXIT WHEN (ei_sn_cur%NOTFOUND 
--            OR (ei_sn_cur%ROWCOUNT > 10)
            ); 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        v_notes := '';
        
-- Skip the record if it is a 'AGGREGATE'             
            
        IF ei_sn_rec.sys_ei_sn = 'AGGREGATE' THEN
        
            v_item_id := 0; 
            v_status := 'C';
            v_notes  := 'Aggregate';
         
            proc0.rec_valid_int := NVL(proc0.rec_valid_int, 0) + 1;
        
        END IF;
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE
                (
                   ' physical_item_id ' || ei_sn_rec.physical_item_id 
                || '      sys_ei_niin ' || ei_sn_rec.sys_ei_niin
                || '        sys_ei_sn ' || ei_sn_rec.sys_ei_sn
                || '       owning_org ' || ei_sn_rec.owning_org
                || '       sys_ei_uid ' || ei_sn_rec.sys_ei_uid
                || '          v_notes ' || v_notes
                );
        END IF;
            
        INSERT INTO pfsawh_item_sn_dim 
            (
            physical_item_sn_id ,
            physical_item_id , 
            item_serial_number , 
            item_niin , 
            item_uic ,
            status , 
            item_notes  
            ) 
            VALUES 
            (
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
            ei_sn_rec.physical_item_id, 
            ei_sn_rec.sys_ei_sn, 
            ei_sn_rec.sys_ei_niin,  
            NVL(ei_sn_rec.owning_org, -1), 
--                ei_sn_rec.sys_ei_uid, 
            ei_sn_rec.status, 
            v_notes 
            );
            
        proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + 1; 
            
    END LOOP;
    
    CLOSE ei_sn_cur;
    
    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := '99-Close';

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

    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status := 'ERROR';
    END IF;
  
-- update the pfsa_process table to indicate STATUS of the SUB peocess
  
    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
            ps_oerr := sqlcode; 
            ps_msg  := ei_sn_rec.sys_ei_niin || '-' ||  
                ei_sn_rec.sys_ei_sn || '-' || 
                sqlerrm; 
            
            INSERT 
            INTO std_pfsawh_debug_tbl 
            (
            ps_procedure,      ps_oerr, ps_location, called_by, 
            ps_id_key, ps_msg, msg_dt
            )
            VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, ps_procedure_name, 
            ps_id_key, ps_msg, SYSDATE
            );
            
END;  -- etl_load_pfsawh_item_sn_dim 
/

