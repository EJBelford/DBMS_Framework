/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_load_pfsawh_item_dim
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 27 October 2008 
--
--          SP Source: etl_load_pfsawh_item_dim.sql
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

    etl_load_pfsawh_item_dim ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_load_pfsawh_item_dim 
    (
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )

IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_LOAD_PFSAWH_ITEM_DIM';     /*  */
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
v_notes                          pfsawh_item_sn_dim.item_notes%TYPE       := '';

CURSOR ei_sys_cur IS
    SELECT pid.status,  
        PBA_ID, 
        pid.physical_item_id, 
        sys_ei_niin,
        pfsa_system,
        eic,
        lin,
        aircraft,
        sys_ei_nomen,
        all_army_default_pba_grouping 
--        , lst_updt,      updt_by,
--        active_flag,   active_date,
--        inactive_date, insert_by,    insert_date,
--        update_by,     update_date,
--        delete_flag,   delete_date,  delete_by,
--        hidden_flag,   hidden_by,    hidden_date 
    FROM pfsa_sys_ei@pfsaw.lidb pid
    WHERE NOT EXISTS ( 
            SELECT isd.niin 
            FROM   pfsawh_item_dim isd 
            WHERE  pid.sys_ei_niin = isd.niin   
        ) 
        AND pid.status = 'C' 
    ORDER BY pid.sys_ei_niin;
    
ei_sys_rec    ei_sys_cur%ROWTYPE;

CURSOR comp_cur IS
    SELECT 
    DISTINCT --    cbs.sys_ei_niin,
        cbs.component_niin,
        NVL(cbs.nomenclature, 'UNKNOWN') AS nomenclature, 
        cbs.status 
--        , cbs.lst_updt, cbs.updt_by
    FROM component_by_system@pfsaw.lidb cbs
    WHERE cbs.status = 'C' 
        AND cbs.lst_updt = (
             SELECT MAX(cbss.lst_updt) 
             FROM   component_by_system@pfsaw.lidb cbss 
             WHERE  cbss.component_niin = cbs.component_niin 
             )
        AND NOT EXISTS ( 
            SELECT isd.niin 
            FROM   pfsawh_item_dim isd 
            WHERE  cbs.component_niin = isd.niin   
            ) 
--        AND cbs.nomenclature IS NOT NULL 
    ORDER BY cbs.component_niin; 
    
comp_rec    comp_cur%ROWTYPE;

----------------------------------- START --------------------------------------
   
BEGIN 

    ps_location := 'PFSAWH 0';            -- For std_pfsawh_debug_tbl logging. 
    
--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 105; 
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
      
    ps_location := 'PFSAWH 10';            -- For std_pfsawh_debug_tbl logging. 
    ls_current_process.pfsa_process := 'ETL_LOAD_PFSAWH_ITEM_DIM'; 
  
    proc1.process_RecId      := 105; 
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
 
-- Check pfsa_sys_ei@pfsaw.lidb for new end items     
    
    OPEN ei_sys_cur;
    
    LOOP
        FETCH ei_sys_cur 
        INTO  ei_sys_rec;
        
        EXIT WHEN (ei_sys_cur%NOTFOUND 
--            OR (ei_sys_cur%ROWCOUNT > 10)
            ); 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        v_notes := '';
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE
                (
                   'sys_ei_niin ' || ei_sys_rec.sys_ei_niin 
                );
        END IF; 
            
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE
                (
                   ' physical_item_id ' || ei_sys_rec.physical_item_id 
                || '      sys_ei_niin ' || ei_sys_rec.sys_ei_niin
                );
        END IF;
            
        INSERT INTO pfsawh_item_dim 
            (
            physical_item_id , 
            niin,  
            mcn, 
            status 
            ) 
            VALUES 
            (
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'), 
            ei_sys_rec.sys_ei_niin,
            'UNK', 
            ei_sys_rec.status
            );
            
        proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + 1; 
        proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + 1; 
            
    END LOOP;
    
    CLOSE ei_sys_cur;
    
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
    
/*----- Sub Process -----*/ 
      
    ps_location := 'PFSAWH 20';            -- For std_pfsawh_debug_tbl logging. 
  
    proc1_recId              := NULL;
    
    proc1.process_RecId      := 105; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 20;
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

-- update the pfsa_process table to indicate SUB process has started 

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
 
-- Check pfsa_equip_avail@pfsaw.lidbdev for new serial numbers     
    
    OPEN comp_cur;
    
    LOOP
        FETCH comp_cur 
        INTO  comp_rec;
        
        EXIT WHEN (comp_cur%NOTFOUND 
--            OR (comp_cur%ROWCOUNT > 10)
            ); 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        v_notes := '';
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE
                (
                   'component_niin ' || comp_rec.component_niin 
                || '  nomenclature ' || comp_rec.nomenclature
                );
        END IF;
            
        INSERT INTO pfsawh_item_dim 
            (
            physical_item_id , 
            niin ,  
            mcn , 
            item_nomen_standard ,
            status 
            ) 
            VALUES 
            (
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'), 
            comp_rec.component_niin,
            'UNK', 
            comp_rec.nomenclature, 
            comp_rec.status 
            );
            
        proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + 1; 
        proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + 1; 
            
    END LOOP;
    
    CLOSE comp_cur;
    
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

/*----- Sub Process -----*/ 
      
    ps_location := 'PFSAWH 30';            -- For std_pfsawh_debug_tbl logging. 
  
    proc1_recId              := NULL;
    
    proc1.process_RecId      := 105; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 30;
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

    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    UPDATE pfsawh_item_dim imd 
    SET    (mat_cat_cd_4_5, cl_of_supply_cd, subclass_of_supply_cd, ecc) = 
            (
            SELECT -- component_niin, cmp.nomenclature,
                cmp.mat_cat_cd_4_5,
                cmp.cl_of_supply_cd,
                cmp.subclass_of_supply_cd,
            --    cmp.maint_rpr_cd,
                cmp.ecc 
            --   , cmp.rqn_days_ago, cmp.pkg_days_ago, cmp.status,
            --    cmp.lst_updt,      cmp.updt_by 
            FROM pfsaw.pfsa_components@pfsaw.lidb cmp 
            WHERE cmp.component_niin = imd.niin  
                AND cmp.status = 'C'
           )
    WHERE (mat_cat_cd_4_5 IS NULL OR cl_of_supply_cd IS NULL 
        OR subclass_of_supply_cd IS NULL OR ecc IS NULL)      
    ; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + 1; 
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + 1; 
            
--    UPDATE pfsawh_item_dim imd 
--    SET    cl_of_supply_cd = 
--            (
--            SELECT 
--            DISTINCT(it.cl_of_supply_cd)
--            FROM item_dim it 
--            WHERE it.niin = imd.niin 
--                AND it.wh_record_status = 'CURRENT' 
--            )
--    WHERE  imd.cl_of_supply_cd IS NULL; 
    
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + 1; 
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + 1; 
            
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
            ps_msg  := comp_rec.component_niin || '-' || 
                comp_rec.nomenclature || '-' || 
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
            
END;  -- etl_load_pfsawh_item_dim 
/

