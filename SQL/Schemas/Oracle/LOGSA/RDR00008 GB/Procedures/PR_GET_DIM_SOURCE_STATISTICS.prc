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
--    SP Created Date: 22 Jan 2008 
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
-- 22JAN08 - GB  -          -      - Created 
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

s0_rec_Id                        pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  pfsawh_process_log.process_RecId%TYPE   
    := 210;                  /* NUMBER */
s0_processKey                    pfsawh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_moduleNum                     pfsawh_process_log.Module_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_stepNum                       pfsawh_process_log.Step_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_processStartDt                pfsawh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  pfsawh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               pfsawh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  pfsawh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    pfsawh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   pfsawh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    pfsawh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                pfsawh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                pfsawh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 pfsawh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 pfsawh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */

-- Native Dymanic SQL [NDS] (nds_)

nds_statement           VARCHAR2(2000) 
    := '';    
    
-- module variables (v_)

v_debug                 NUMBER        
    := 0;      -- Controls debug options (0 -Off) 
v_time_difference       NUMBER 
    := NULL;   -- 
v_pass_flag             NUMBER 
    := NULL;   -- 0 - Pass 1 check, 1 - , 2- 
    
v_status                pfsawh_source_stat_ref.status%TYPE  
    := NULL;   --  
v_src_past1_rec_cnt     pfsawh_source_stat_ref.source_past1_record_count%TYPE 
    := NULL;   -- 
v_src_past2_rec_cnt     pfsawh_source_stat_ref.source_past2_record_count%TYPE 
    := NULL;   -- 

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
    FROM     pfsawh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
CURSOR source_cur IS
    SELECT   a.source_hist_stat_id, a.source_schema, a.source_table 
    FROM     pfsawh_source_stat_ref a
    ORDER BY a.source_hist_stat_id;
        
source_rec    source_cur%ROWTYPE;
        
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

-- Loop through all the source tables for the dimensions and see if any changes 
-- have been made. 

    OPEN source_cur;

    LOOP
        FETCH source_cur 
        INTO  source_rec;
    
        EXIT WHEN source_cur%NOTFOUND; 
        
        s0_message        := source_rec.source_table;
        ps_msg            := source_rec.source_table;
        
        v_time_difference := NULL;   
        v_pass_flag       := NULL;
        
        SELECT TO_CHAR(SYSDATE-NVL(source_past1_date, SYSDATE)), 
               source_past1_record_count, 
               source_past2_record_count, 
               status 
        INTO   v_time_difference, 
               v_src_past1_rec_cnt, 
               v_src_past2_rec_cnt, 
               v_status   
        FROM   pfsawh_source_stat_ref 
        WHERE  source_for_code = 'D' 
            AND source_table   = source_rec.source_table; -- 'MANUFACTURER_PART' 

-- Only process lines that are current.            
            
        IF v_status = 'C' THEN  
        
            v_pass_flag := 0; 
            
-- Constraints the checks to hourly.  
----- This could be added to the process control table 
----- or to the pfsawh_source_stat_ref.             
            
            IF  v_src_past1_rec_cnt IS NULL 
                OR v_time_difference > 0.04166667 THEN 
                
-- second	86400	0.00001157
-- minute	1440	0.00069444
-- hour	24	    0.04166667
        
-- The SQL statements are dymanically built as each source line is processed. 
----- The WHERE clause could be added to the pfsawh_source_stat_ref. 

-- Get number of rows.             
                    
                nds_statement := 
                       'BEGIN '
                    || '   SELECT COUNT(*) '
                    || '   INTO :col1 '
                --    FROM   pfsawh_processes; 
                    || '   FROM ' || source_rec.source_table || NVL(source_rec.source_schema, '')
                --    || '   WHERE rncc = '''|| '3' ||''
                    || ';'
                    || ' END;';
                
                IF v_debug > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
                       ||  source_rec.source_table || ' | ' || nds_statement);
                END IF;  
    
                EXECUTE IMMEDIATE nds_statement USING OUT l_max_prd_rowcnt; 
                
-- Get the last update date.                 
            
                nds_statement := 
                       'BEGIN '
                    || '   SELECT MAX(lst_updt) '
                    || '   INTO :col1 '
                --    FROM   pfsawh_processes; 
                    || '   FROM ' || source_rec.source_table || NVL(source_rec.source_schema, '')
                --    || '   WHERE rncc = '''|| '3' ||''
                    || ';'
                    || ' END;';
                
                IF v_debug > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
                       ||  source_rec.source_table || ' | ' || nds_statement);
                END IF;  
    
                EXECUTE IMMEDIATE nds_statement USING OUT l_max_prd_lst_updt; 

-- Get the count of how many rows where updated on the last updated date.
            
                nds_statement := 
                       'BEGIN '
                    || '   SELECT COUNT(lst_updt) '
                    || '   INTO :col1 '
                --    FROM   pfsawh_processes; 
                    || '   FROM ' || source_rec.source_table || NVL(source_rec.source_schema, '')
                    || '   WHERE lst_updt = :col2'
                    || ';'
                    || ' END;';
                
                IF v_debug > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
                       || source_rec.source_table || ' | ' || nds_statement || ' | '
                       || TO_DATE(l_max_prd_lst_updt, 'DD-MON-YY') );
                END IF;  
    
                EXECUTE IMMEDIATE nds_statement 
                USING OUT l_cnt_updt, 
                      IN  TO_DATE(l_max_prd_lst_updt, 'DD-MON-YY'); 
                      
-- If the current stats do not match the historical (past_1), save the stats.                      
                      
                IF v_src_past1_rec_cnt <> l_max_prd_rowcnt THEN 
                
                    UPDATE pfsawh_source_stat_ref 
                    SET    source_past1_date         = SYSDATE,
                           source_past1_record_count = l_max_prd_rowcnt,
                           source_past1_insert_date  = NULL,
                           source_past1_insert_count = NULL,
                           source_past1_update_date  = l_max_prd_lst_updt,
                           source_past1_update_count = l_cnt_updt,
                           source_past1_delete_count = NULL, 
                           
                           source_past2_date         = NULL,
                           source_past2_record_count = NULL,
                           source_past2_insert_date  = NULL,
                           source_past2_insert_count = NULL,
                           source_past2_update_date  = NULL,
                           source_past2_update_count = NULL,
                           source_past2_delete_count = NULL
                    WHERE  source_for_code = 'D' 
                        AND source_table   = source_rec.source_table;  
                    
                    s0_recUpdatedInt := NVL(s0_recUpdatedInt, 0) + SQL%ROWCOUNT; 
    
-- If the current stats match the historical (past_1), 
-- but the current stats do not match the historical (past_2), save the stats.                      
                      
                ELSIF v_src_past1_rec_cnt =  l_max_prd_rowcnt AND 
                      NVL(v_src_past2_rec_cnt, 0) <> l_max_prd_rowcnt THEN   
                        
                    UPDATE pfsawh_source_stat_ref 
                    SET    source_past2_date         = SYSDATE,
                           source_past2_record_count = l_max_prd_rowcnt,
                           source_past2_insert_date  = NULL,
                           source_past2_insert_count = NULL,
                           source_past2_update_date  = l_max_prd_lst_updt,
                           source_past2_update_count = l_cnt_updt,
                           source_past2_delete_count = NULL
                    WHERE  source_for_code = 'D' 
                        AND source_table   = source_rec.source_table; 
                    
                    s0_recUpdatedInt := NVL(s0_recUpdatedInt, 0) + SQL%ROWCOUNT; 
                    
-- Insert the call to the dimension update procedure HERE.                     
    
                    UPDATE pfsawh_source_stat_ref 
                    SET    source_last_processed_date = SYSDATE 
                    WHERE  source_for_code = 'D' 
                        AND source_table   = source_rec.source_table; 
                        
                    s0_recUpdatedInt := NVL(s0_recUpdatedInt, 0) + SQL%ROWCOUNT; 
    
                END IF;  -- Count checks 
            
            END IF;  -- v_time_difference > 
            
-- Record when the last checks for updates occured for this particular source.             
            
            UPDATE pfsawh_source_stat_ref 
            SET    source_last_checked_date   = SYSDATE 
            WHERE  source_for_code = 'D' 
                AND source_table   = source_rec.source_table; 
                
            s0_recUpdatedInt := NVL(s0_recUpdatedInt, 0) + SQL%ROWCOUNT; 
    
        END IF;  -- v_status = 'C'
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ' | ' 
               || s0_processRecId || ' | ' || ps_location || ' | '  
               || l_max_prd_rowcnt || ' | ' || l_max_prd_lst_updt || ' | ' 
               || l_cnt_updt);
        END IF;  
        
        COMMIT;
    
    END LOOP;  -- source_cur

    CLOSE source_cur;
    
/*----- Debug - Dump the process log -----*/
    
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
    
/*----- Close the process log entry -----*/

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

/*----- Exceptions -----*/

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm || ' - ' || ps_msg;
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
