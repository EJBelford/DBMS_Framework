/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE pr_PFSAWH_DebugTbl_cleanup 

IS

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--            SP Name: pr_PFSAWH_DebugTbl_cleanup
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 19 December 2007 
--
--          SP Source: pr_PFSAWH_DebugTbl_cleanup.sql
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

ps_procedure_name        VARCHAR2(30)  := 'pr_PFSAWH_DebugTbl_cleanup';
ps_location              VARCHAR2(30)  := 'Begin'; 
ps_oerr                  VARCHAR2(6)   := null;
ps_msg                   VARCHAR2(200) := null;
ps_id_key                VARCHAR2(200) := null;            -- coder responsible 
                                                           -- for identying key 
                                                           -- for debug

-- Process status variables (s0_)

s0_rec_Id                PLS_INTEGER   := NULL; 

s0_processRecId          PLS_INTEGER   := 11; 
s0_processKey            PLS_INTEGER   := NULL;
s0_moduleNum             PLS_INTEGER   := 0;
s0_stepNum               PLS_INTEGER   := 0;
s0_processStartDt        DATE          := sysdate;
s0_processEndDt          DATE          := NULL;
s0_processStatusCd       PLS_INTEGER   := NULL;
s0_sqlErrorCode          PLS_INTEGER   := NULL;
s0_recReadInt            PLS_INTEGER   := NULL;
s0_recValidInt           PLS_INTEGER   := NULL;
s0_recLoadInt            PLS_INTEGER   := NULL;
s0_recInsertedInt        PLS_INTEGER   := NULL;
s0_recSelectedInt        PLS_INTEGER   := NULL;
s0_recUpdatedInt         PLS_INTEGER   := NULL;
s0_recDeletedInt         PLS_INTEGER   := NULL;
s0_userLoginId           VARCHAR2(30)  := user;
s0_message               VARCHAR2(255) := ''; 
    
-- module variables (v_)

v_debug                  PLS_INTEGER   := 0; 
v_keep_n_days_of_debug   PLS_INTEGER	:= 5; 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     pfsawh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
BEGIN
    ps_location := '00 - Create log record';

    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        s0_moduleNum, s0_stepNum,  
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
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

-- Get the # of days to delete fro process control, (PFSAWH_PROCESS_CONTROL).

    v_keep_n_days_of_debug := FN_PFSAWH_GET_PRCSS_CNTRL_VAL('v_keep_n_days_of_debug'); 

-- Delete all PFSADW_Process_Log records more than # days old. 

    DELETE std_pfsa_debug_tbl  
    WHERE  msg_dt < (sysdate - v_keep_n_days_of_debug)
        OR ps_procedure LIKE '%PFSAW%';

    s0_recDeletedInt := SQL%ROWCOUNT;
    
    ps_location := '99 - Close log record';

    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := sqlcode || ' - ' || sqlerrm; 
    
    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey,  
        s0_moduleNum, s0_stepNum,  
        '01-Jan-1900', /*s0_processStartDt,*/ s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, s0_rec_Id);

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
              ps_procedure, ps_oerr, ps_location, 
              called_by, ps_id_key, ps_msg, msg_dt
              )
		    VALUES 
              (
              ps_procedure_name, ps_oerr, ps_location, 
              s0_userLoginId, ps_id_key, ps_msg, sysdate
              );
--          RAISE;
            
END pr_PFSAWH_DebugTbl_cleanup;
/
/*<TOAD_FILE_CHUNK>*/

/*----- Test script -----*/

/*

BEGIN

    pr_PHSAWH_item_part_load;

-- Test - delete a row to force a refresh 
-- DELETE gb_pfsa_item_part_bld WHERE niin = '015148052'

--    maintain_PFSA_Warehouse; 
    
END;

SELECT log.process_key As prc_lg_sq, ':', log.process_recid AS prc, 
         prcs.process_description AS process_desc, log.module_num AS mod_#, 
         log.step_num AS stp_#, '|', log.process_start_date AS started, 
         log.process_end_date AS ended, process_status_code AS status,
         log.sql_error_code AS sql_err, log.rec_read_int AS read, 
         log.rec_valid_int AS valid, log.rec_load_int AS load, 
         log.rec_inserted_int AS inserted, log.rec_selected_int AS selected, 
         log.rec_updated_int AS updated, log.rec_deleted_int AS deleted,
         log.message, log.user_login_id AS user_id
---    , '||', log.*, prcs.* 
FROM GB_PFSAWH_Process_Log log 
LEFT OUTER JOIN gb_pfsawh_processes prcs ON log.process_recid = prcs.process_key
ORDER BY log.process_key DESC;

SELECT bug.msg_dt, bug.* FROM std_pfsa_debug_tbl bug ORDER BY bug.msg_dt DESC; 

*/
