CREATE OR REPLACE PROCEDURE etl_load_pfsawh_force_unit_dim 
    (
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_load_pfsawh_force_unit_dim
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 27 October 2008 
--
--          SP Source: etl_load_pfsawh_force_unit_dim.sql
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
-- 27OCT08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

BEGIN 

    etl_load_pfsawh_force_unit_dim ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_LOAD_PFSAWH_FORCE_UNIT_DIM';     /*  */
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

proc0_recId                      pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                      pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                            pfsawh_process_log%ROWTYPE; 
proc1                            pfsawh_process_log%ROWTYPE; 

ps_last_process                  pfsawh_processes%ROWTYPE;
ps_this_process                  pfsawh_processes%ROWTYPE;
ls_current_process               pfsawh_processes%ROWTYPE; 

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days          pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                          NUMBER        
     := 0;   -- Controls debug options (0 -Off)

v_nsn                            pfsawh_item_dim.nsn%TYPE                 := '';
v_niin                           pfsawh_item_dim.niin%TYPE                := '';

v_item_id                        pfsawh_item_sn_dim.physical_item_id%TYPE := '';
v_status                         pfsawh_item_sn_dim.status%TYPE           := '';
v_delete                         pfsawh_item_sn_dim.delete_flag%TYPE      := '';
v_hidden                         pfsawh_item_sn_dim.hidden_flag%TYPE      := '';
v_notes                          pfsawh_item_sn_dim.item_notes%TYPE       := ''; 

o_uic                            VARCHAR2(6); 

----------------------------------- START --------------------------------------
   
BEGIN 

    ps_location := 'PFSA 0';            -- For std_pfsawh_debug_tbl logging. 
    
--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 108; 
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

/*----- Sub Process -----*/ 
      
    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging. 
    ls_current_process.pfsa_process := 'ETL_LOAD_PFSAWH_FORCE_UNIT_DIM'; 
  
    proc1.process_RecId      := 108; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := NULL;
    
    pr_pfsawh_InsUpd_ProcessLog (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        );

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

    o_uic := 'x'; 
 
    FOR org_hist2_rec IN (
        SELECT oh2.pfsa_org, oh2.day_date_from, oh2.day_date_thru,
            oh2.uic, oh2.derived_unt_desc, oh2.macom, oh2.tpsn,
            oh2.branch, oh2.parent_org, oh2.cmd_uic, oh2.parent_uic,
            oh2.geo_cd, oh2.comp_cd,
            oh2.lst_updt, oh2.updt_by, oh2.goof_uic_ind  
        FROM   pfsa_org_hist2@pfsaw.lidb oh2
        WHERE  NOT EXISTS (
            SELECT uic 
            FROM   pfsawh_force_unit_dim fud 
            WHERE  fud.uic = oh2.pfsa_org 
            )
        AND LENGTH(oh2.pfsa_org) = 6
        AND oh2.pfsa_org = oh2.uic
        AND UPPER(oh2.goof_uic_ind) = 'N'
        ORDER BY oh2.pfsa_org, day_date_thru DESC)
    LOOP 
    
        IF o_uic <> org_hist2_rec.pfsa_org THEN 
            o_uic := org_hist2_rec.pfsa_org; 
            
            v_status := 'C'; 
            v_hidden := 'N';
        ELSE 
            v_status := 'H';  
            v_hidden := 'Y';
        END IF;  
        

        INSERT  
        INTO  pfsawh_force_unit_dim 
            ( 
            force_unit_id, 
            uic,
            unit_description,
            pfsa_org,
            wh_effective_date,
            wh_expiration_date,
            macom,
            pfsa_tpsn,
            pfsa_branch,
            pfsa_parent_org,
            pfsa_cmd_uic,
            pfsa_parent_uic,
            pfsa_geo_cd,
            pfsa_comp_cd,
            status, 
            lst_updt,
            updt_by,
            pfsa_goof_uic_ind,
            hidden_flag, 
            hidden_date,
            hidden_by 
            ) 
        VALUES 
            (
            fn_pfsawh_get_dim_identity('pfsawh_force_unit_dim'), 
            org_hist2_rec.uic ,
            org_hist2_rec.derived_unt_desc ,
            org_hist2_rec.pfsa_org ,
            org_hist2_rec.day_date_from ,
            org_hist2_rec.day_date_thru ,
            org_hist2_rec.macom ,
            org_hist2_rec.tpsn ,
            org_hist2_rec.branch ,
            org_hist2_rec.parent_org ,
            org_hist2_rec.cmd_uic ,
            org_hist2_rec.parent_uic ,
            org_hist2_rec.geo_cd ,
            org_hist2_rec.comp_cd ,
            v_status ,
            org_hist2_rec.lst_updt ,
            org_hist2_rec.updt_by ,
            org_hist2_rec.goof_uic_ind,
            v_hidden, 
            l_now_is,
            ps_procedure_name   
            ); 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1; 
        proc1.rec_read_int := NVL(proc1.rec_read_int, 0) + 1; 
            
    END LOOP; -- org_hist2_rec    
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + 1; 
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + 1; 
            
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
    
/*----- Sub Process -----*/ 
      
    ps_location := 'PFSA 20';            -- For std_pfsawh_debug_tbl logging. 
  
    proc1.process_RecId      := 108; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 20;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
    proc1.message            := NULL;
    
    proc1_recId              := NULL;
    
    proc1.rec_read_int       := NULL; 
    proc1.rec_inserted_int   := NULL; 
    
    pr_pfsawh_InsUpd_ProcessLog (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        );

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

    o_uic := 'EOF'; 
 
    UPDATE pfsawh_force_unit_dim fud 
    SET    fud.force_command_unit_code = 
            ( 
            SELECT 
            DISTINCT poh.cmd_uic 
            FROM   pfsa_org_hist2@PFSAW.LIDB poh 
            WHERE  poh.pfsa_org = fud.uic 
                AND LENGTH(poh.cmd_uic) = 6 
                AND day_date_thru = TO_DATE('31-DEC-4712', 'DD-MON-YYYY')
            ) 
    WHERE  fud.status = 'C' 
        AND fud.force_command_unit_code IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + 1; 
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + 1; 
            
    UPDATE pfsawh_force_unit_dim fud 
    SET    fud.force_command_unit_id = 
            ( 
            SELECT fud2.force_unit_id 
            FROM   pfsawh_force_unit_dim fud2
            WHERE  fud2.uic = fud.force_command_unit_code  
                AND fud2.status = 'C' 
            )  
    WHERE  fud.status = 'C' 
        AND fud.force_command_unit_code IS NOT NULL
        AND fud.force_command_unit_id IS NULL; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + 1; 
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + 1; 
            
    COMMIT; 

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := '99-Close';

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
            ps_msg  := o_uic || '-' || 
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
            
END;  -- etl_load_pfsawh_force_unit_dim 
/

