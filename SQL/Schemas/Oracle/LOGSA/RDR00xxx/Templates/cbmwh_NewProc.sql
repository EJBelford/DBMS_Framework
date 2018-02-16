CREATE OR REPLACE PROCEDURE pr_PHSAWH_blank 
    (
    in_rec_Id                IN      NUMBER  
    )

IS

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

-- Exception handling variables (ps_)

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'pr_CBMWH_blank';     /*  */
ps_location                      std_cbmwh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_cbmwh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_cbmwh_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_cbmwh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

s0_rec_Id                        cbmwh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  cbmwh_process_log.process_RecId%TYPE   
    := 102;                  /* NUMBER */
s0_processKey                    cbmwh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_moduleNum                     cbmwh_process_log.Module_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_stepNum                       cbmwh_process_log.Step_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_processStartDt                cbmwh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  cbmwh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               cbmwh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  cbmwh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    cbmwh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   cbmwh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    cbmwh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                cbmwh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                cbmwh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 cbmwh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 cbmwh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   cbmwh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       cbmwh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     cbmwh_process_log a
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
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || s0_processRecId || ', ' || s0_processKey);

        dbms_lock.sleep(1);
    END IF;  

-- If the v_rec_Id is NULL then we assume that a new log record is required

    IF s0_rec_Id IS NULL THEN
 
        ps_location := '05-Insert'; 
        
        IF v_debug > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Insert'); 
        END IF;

    ELSE
    
        ps_location := '10-Update'; 
        
        IF v_debug > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Update in_rec_Id: ' || in_rec_Id); 
        END IF;

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
    s0_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
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
                ps_id_key, ps_msg, sysdate
                );
                
--     RAISE;

--     ROLLBACK;
            
END pr_PHSAWH_blank;

/

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
FROM cbmwh_process_log log ORDER BY log.process_key DESC;

SELECT bug.msg_dt, bug.* FROM std_pfsa_debug_tbl bug ORDER BY bug.msg_dt DESC; 

*/

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
