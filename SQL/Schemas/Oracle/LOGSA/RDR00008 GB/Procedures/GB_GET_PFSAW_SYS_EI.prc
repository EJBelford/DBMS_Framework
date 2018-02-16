/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE get_pfsaw_sys_ei
    (
    in_rec_Id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: get_pfsaw_sys_ei
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 14 January 2008 
--
--          SP Source: get_pfsaw_sys_ei.prc
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
-- 14JAN08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'get_pfsaw_sys_ei';   /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := 'get_pfsaw_sys_ei';   /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

s0_rec_Id                        gb_pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_pfsawh_process_log.process_RecId%TYPE   
    := 105;                  /* NUMBER */
s0_processKey                    gb_pfsawh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_moduleNum                     gb_pfsawh_process_log.Module_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_stepNum                       gb_pfsawh_process_log.Step_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_processStartDt                gb_pfsawh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  gb_pfsawh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               gb_pfsawh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  gb_pfsawh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    gb_pfsawh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   gb_pfsawh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    gb_pfsawh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                gb_pfsawh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                gb_pfsawh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 gb_pfsawh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 gb_pfsawh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   gb_pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       gb_pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_debug                 NUMBER        
     := 0;   -- Controls debug options (0 -Off)

l_max_prd_rowcnt        PLS_INTEGER   := NULL; -- # rowsa found in target 
                                               -- production PFSADW table.  
l_max_prd_lst_updt      DATE          := NULL; -- The most recent update to the  
                                               -- production PFSADW table.  
l_max_src_rowcnt        PLS_INTEGER   := NULL; -- # rowsa found in target 
                                               -- production table.  
l_max_src_lst_updt      DATE          := NULL; -- The most recent update to the  
                                               -- production table.  
l_src_lst_chck_date     DATE          := NULL; -- The last time the source table
                                               -- was checked. 
l_source_last_processed_date DATE     := NULL; 
                                               
l_cnt_updt              PLS_INTEGER   := NULL; -- 

l_run_flg               PLS_INTEGER   := 0;    -- Run additional modules 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     GB_PFSAWH_Process_Log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
----------------------------------- START --------------------------------------

BEGIN
    ps_location := '00-Start';
    s0_stepNum  := 0;

    pr_pfsawh_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        0, s0_stepNum, 
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, s0_rec_id);

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || s0_processRecId || ', ' || s0_processKey);
    END IF;  

-- Collect facts about source and DW tables.

/*----- pfsa_sys_ei -----*/

    ps_location := '05-ei';
    s0_stepNum  := 5;
    
-- Currently designed to work on the whole table.  
-- Next version should process seperately for different status codes. 
-- Date range logic would be nice to.  

    SELECT source_last_processed_date 
    INTO   l_source_last_processed_date
    FROM   gb_pfsawh_source_hist_ref 
    WHERE  source_table = 'PFSA_SYS_EI';
    
    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   pfsa_sys_ei; 
        
    IF l_source_last_processed_date = NULL THEN
        l_run_flg := 1;
        s0_message := 'Never loaded ' || 'PFSA_SYS_EI' || ' before.';
    ELSIF NVL(l_source_last_processed_date, '01-JAN-1900') < l_max_prd_lst_updt THEN 
        l_run_flg := 2;
        s0_message := 'Updates found for ' || 'PFSA_SYS_EI' || '.';
    ELSE 
        l_run_flg := 0;
        s0_message := 'No updates need for ' || 'PFSA_SYS_EI' || ' dimension.';
    END IF;
    
    IF l_run_flg > 0 THEN 
    
        ps_location := '10-ei';
        s0_stepNum  := 10;

        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
               || s0_processRecId || ', ' || s0_processKey || ', ' 
               || ps_location || ', ' || s0_stepNum);
        END IF;  

        MERGE 
        INTO   gb_pfsawh_item_dim item
        USING  (
               SELECT sys_ei_niin, pfsa_system, eic, lin, aircraft, 
                      status, lst_updt, updt_by, sys_ei_nomen 
               FROM   pfsa_sys_ei 
               ) ei
            ON (item.niin = ei.sys_ei_niin)   
        WHEN MATCHED THEN 
            UPDATE 
            SET  pfsa_subject_flag = 'Y', 
                 lin               = NVL(ei.lin, 'unk'), 
                 ecc_code          = ei.eic, 
                 update_by         = 'get_pfsaw_sys_ei', 
                 update_date       = SYSDATE 
        WHEN NOT MATCHED THEN 
            INSERT ( 
                   item.item_id, 
                   pfsa_subject_flag, 
                   lin, 
                   niin, 
                   eic_code, 
                   end_item_nomen, 
                   gen_nomen, 
                   status, 
                   lst_updt, 
                   updt_by 
                   )
            VALUES ( 
                   fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'), 
                   'Y', 
                   NVL(ei.lin, 'unk'), 
                   ei.sys_ei_niin, 
                   ei.eic, 
                   ei.sys_ei_nomen, 
                   ei.sys_ei_nomen, 
                   /* ei.pfsa_system, ei.aircraft, */
                   ei.status, ei.lst_updt, ei.updt_by
                   ); 
    
        s0_recLoadInt := SQL%ROWCOUNT; 
        
        UPDATE gb_pfsawh_item_dim a
        SET    (fsc, nsn) = 
                   ( SELECT fsc, NVL(nsn, fsc || niin)  
                     FROM   item_control@pfsawh.lidbdev ctrl
                     WHERE  a.niin = ctrl.niin  
                   ), 
                 update_by    = 'get_pfsaw_sys_ei', 
                 update_date  = SYSDATE 
        WHERE  UPPER(a.fsc) = 'UNK';  
           
        s0_recUpdatedInt := SQL%ROWCOUNT;
        
        SELECT COUNT(*) 
        INTO   l_max_prd_rowcnt 
        FROM   pfsa_sys_ei; 
    
        SELECT COUNT(lst_updt) 
        INTO   l_cnt_updt 
        FROM   pfsa_sys_ei 
        WHERE  lst_updt = l_max_prd_lst_updt; 
        
        UPDATE gb_pfsawh_source_hist_ref 
        SET    source_last_processed_date = SYSDATE, 
               source_last_checked_date   = SYSDATE, 
               source_last_record_count   = l_max_prd_rowcnt,
               source_last_update_date    = l_max_prd_lst_updt,
               source_last_update_count   = l_cnt_updt,
               source_last_insert_count   = NULL,
               source_last_delete_count   = NULL
        WHERE  source_table = 'PFSA_SYS_EI';
        
        COMMIT;
    END IF;
    
    IF v_debug > 0 THEN 
    
        DBMS_OUTPUT.NEW_LINE;

        OPEN process_cur;
    
        LOOP
            FETCH process_cur 
            INTO  process_rec;
        
            EXIT WHEN process_cur%NOTFOUND;
        
            DBMS_OUTPUT.PUT_LINE(process_rec.process_key || ', ' 
                || process_rec.message);
        
        END LOOP;
    
        CLOSE process_cur;
    
    END IF;

    ps_location := '99-Close';

    --    s0_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := SUBSTR(sqlcode || ' - ' || 
                         sqlerrm || ' - ' || 
                         s0_message, 1, 255); 
    
    pr_pfsawH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        0, s0_stepNum, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, s0_rec_id); 
        
    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
		     INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
		     VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, s0_userLoginId, 
                ps_id_key, ps_msg, sysdate);
                
--    RAISE;
--    ROLLBACK;
            
END get_pfsaw_sys_ei;

/
/*<TOAD_FILE_CHUNK>*/

/*----- Test script -----*/

/*

BEGIN

    get_pfsaw_sys_ei(0);
    
END;

SELECT log.process_key As prc_lg_sq, ':', log.process_recid AS prc, log.module_num AS mod_#, log.step_num AS stp_#, 
    '|', log.process_start_date AS started, log.process_end_date AS ended, process_status_code AS status,
         log.sql_error_code AS sql_err, log.rec_read_int AS read, log.rec_valid_int AS valid, log.rec_load_int AS load, 
         log.rec_inserted_int AS inserted, log.rec_selected_int AS selected, log.rec_updated_int AS updated, log.rec_deleted_int AS deleted,
         log.message, log.user_login_id AS user_id
---    , '||', log.* 
FROM GB_PFSAWH_Process_Log log ORDER BY log.process_key DESC;

SELECT bug.msg_dt, bug.* FROM std_pfsa_debug_tbl bug ORDER BY bug.msg_dt DESC; 

*/

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
/
