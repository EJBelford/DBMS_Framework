CREATE OR REPLACE PROCEDURE pr_cbmwh_debugtbl_cleanup 

IS

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--            SP Name: pr_cbmwh_debugtbl_cleanup
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 19 December 2007 
--
--          SP Source: pr_cbmwh_debugtbl_cleanup.sql
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
-- 19DEC07 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Exception handling variables (ps_)

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'pr_cbmwh_debugtbl_cleanup';
ps_location                      std_cbmwh_debug_tbl.ps_location%TYPE  
    := 'Begin'; 
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
    := 11;                   /* NUMBER */
s0_processKey                    cbmwh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_moduleNum                     cbmwh_process_log.Module_Num%TYPE   
    := 0;                    /* NUMBER */
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
s0_recMergedInt                  cbmwh_process_log.rec_Merged_Int%TYPE     
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

v_debug                  PLS_INTEGER   := 0; 
v_keep_n_days_of_debug   PLS_INTEGER   := 5; 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     pfsawh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
BEGIN
    ps_location := '00-Start';

    pr_cbmwh_insupd_processlog (s0_processRecId, s0_processKey, 
        s0_moduleNum, s0_stepNum,  
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, s0_rec_Id);

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000); 
        DBMS_OUTPUT.NEW_LINE; 
        DBMS_OUTPUT.PUT_LINE
           (
           's0_rec_Id: ' || s0_rec_Id || ', ' || 
           s0_processRecId || ', ' || s0_processKey
           );
    END IF;  

-- Get the # of days to delete fro process control, (CBMWH_PROCESS_CONTROL).

    v_keep_n_days_of_debug := fn_cbmwh_get_prcss_cntrl_val('v_keep_n_days_of_debug'); 

-- Delete all PFSADW_Process_Log records more than # days old. 

    DELETE std_cbmwh_debug_tbl  
    WHERE  msg_dt < (sysdate - v_keep_n_days_of_debug);

    s0_recDeletedInt := SQL%ROWCOUNT;
    
    ps_location := '99-Close';

    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := sqlcode || ' - ' || sqlerrm; 
    
    pr_cbmwh_insupd_processlog (s0_processRecId, s0_processKey,  
        s0_moduleNum, s0_stepNum,  
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recMergedInt, s0_recSelectedInt, 
        s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, s0_rec_Id);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
            ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
            
		    INSERT 
            INTO std_cbmwh_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, 
                called_by, ps_id_key, ps_msg, msg_dt
                )
		    VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, 
                s0_userLoginId, ps_id_key, ps_msg, sysdate
                );
            
END pr_cbmwh_debugtbl_cleanup;
/

