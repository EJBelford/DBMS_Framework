/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE pr_get_dim_source_statistics 
    (
    in_rec_Id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_get_dim_source_statistics
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_get_dim_source_statistics.sql
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
-- EXECUTE pr_get_dim_source_statistics(0);

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsa_debug_tbl.ps_procedure%TYPE  
    := 'pr_get_dim_source_statistics';  /*  */
ps_location                      std_pfsa_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsa_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsa_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_pfsa_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

s0_rec_Id                        gb_pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_pfsawh_process_log.process_RecId%TYPE   
    := 210;                  /* NUMBER */
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
    := 0;      -- Controls debug options (0 -Off) 
v_time_difference       NUMBER 
    := NULL;   -- 
v_pass_flag             NUMBER 
    := NULL;   -- 0 - Pass 1 check, 1 - , 2- 

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
                                               
l_cnt_updt              PLS_INTEGER   := NULL; -- 

l_run_flg               PLS_INTEGER   := 0;    -- Run additional modules

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     gb_pfsawh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
----------------------------------- START --------------------------------------

BEGIN
    ps_location := '00-Start';

    pr_pfsawh_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        0, 0, 
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, s0_rec_id);

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
           || s0_processRecId || ' | ' || ps_location);
    END IF;  

/*----- manufacturer_part@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   gb_pfsawh_processes; 
/*    FROM   manufacturer_part@pfsawh.lidbdev 
    WHERE  rncc = '3'; */

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   gb_pfsawh_processes; 
/*    FROM   manufacturer_part@pfsawh.lidbdev 
    WHERE  rncc = '3'; */
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   gb_pfsawh_processes  
/*    FROM   manufacturer_part@pfsawh.lidbdev */
    WHERE  lst_updt = l_max_prd_lst_updt ;
--        AND rncc = '3'; 
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
           || s0_processRecId || ' | ' || ps_location || ' | '  
           || l_max_prd_rowcnt || ' | ' || l_max_prd_lst_updt || ' | ' 
           || l_cnt_updt);
    END IF;  
    
    SELECT TO_CHAR(SYSDATE-NVL(source_last_checked_date, SYSDATE))
    INTO   v_time_difference  
    FROM   gb_pfsawh_source_stat_ref 
    WHERE  source_for_code = 'D' 
        AND source_table   = 'MANUFACTURER_PART';
        
    IF v_time_difference BETWEEN 0.0 AND 0.04166667 THEN 
        v_pass_flag := 1; 
    ELSE 
        v_pass_flag := 2; 
    END IF;
            
    IF v_pass_flag = 1 THEN 

        UPDATE gb_pfsawh_source_stat_ref 
        SET    -- source_last_checked_date  = SYSDATE,
               source_past1_record_count = l_max_prd_rowcnt,
               source_past1_insert_date  = NULL,
               source_past1_insert_count = NULL,
               source_past1_update_date  = l_max_prd_lst_updt,
               source_past1_update_count = l_cnt_updt,
               source_past1_delete_count = NULL, 
               
               source_past2_record_count = NULL,
               source_past2_insert_date  = NULL,
               source_past2_insert_count = NULL,
               source_past2_update_date  = NULL,
               source_past2_update_count = NULL,
               source_past2_delete_count = NULL
        WHERE  source_for_code = 'D' 
            AND source_table   = 'MANUFACTURER_PART'; 
        
    ELSIF v_pass_flag = 2 THEN
    
        UPDATE gb_pfsawh_source_stat_ref 
        SET    source_past2_record_count = l_max_prd_rowcnt,
               source_past2_insert_date  = NULL,
               source_past2_insert_count = NULL,
               source_past2_update_date  = l_max_prd_lst_updt,
               source_past2_update_count = l_cnt_updt,
               source_past2_delete_count = NULL
        WHERE  source_for_code = 'D' 
            AND source_table   = 'MANUFACTURER_PART'; 
        
    ELSIF v_pass_flag = 3 THEN
    
        UPDATE gb_pfsawh_source_stat_ref 
        SET    source_last_checked_date   = SYSDATE, 
               source_last_processed_date = NULL 
        WHERE  source_for_code = 'D' 
            AND source_table   = 'MANUFACTURER_PART'; 
            
    END IF;
        
    s0_recUpdatedInt := SQL%ROWCOUNT; 

    COMMIT;
    
/*-----  -----*/
    
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
    s0_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
           || s0_processRecId || ' | ' || ps_location || ' | '  
           || l_max_prd_rowcnt || ' | ' || l_max_prd_lst_updt || ' | ' 
           || l_cnt_updt || ' | ' || s0_recUpdatedInt);
    END IF;  

    pr_pfsawh_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        0, 0, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, s0_rec_id); 
        
    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
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
                
--       RAISE;

--       ROLLBACK;
            
END pr_get_dim_source_statistics;

/
/*<TOAD_FILE_CHUNK>*/

/*----- Test script -----*/

/*

BEGIN
    maintain_PFSA_Warehouse; 
    
--    pr_PFSAWH_DebugTbl_cleanup;
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