CREATE OR REPLACE PROCEDURE maintain_PFSA_Warehouse 

IS

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--            SP Name: maintain_PFSA_Warehouse
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 19 December 2007 
--
--          SP Source: maintain_PFSA_Warehouse.sql
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

ps_procedure_name       VARCHAR2(30)  := 'maintain_PFSA_Warehouse';
ps_location             VARCHAR2(30)  := 'Begin'; 
ps_oerr                 VARCHAR2(6)   := null;
ps_msg                  VARCHAR2(200) := null;
ps_id_key               VARCHAR2(200) := null;              -- coder responsible 
                                                            -- for identying key 
                                                            -- for debug

-- Process status variables (s0_ & s1_)

s0_rec_Id               NUMBER        := NULL; 

s0_processRecId         NUMBER        := 100; 
s0_processKey           NUMBER        := NULL;
s0_moduleNum            NUMBER        := 0;
s0_stepNum              NUMBER        := 0;
s0_processStartDt       DATE          := sysdate;
s0_processEndDt         DATE          := NULL;
s0_processStatusCd      NUMBER        := NULL;
s0_sqlErrorCode         NUMBER        := NULL;
s0_recReadInt           NUMBER        := NULL;
s0_recValidInt          NUMBER        := NULL;
s0_recLoadInt           NUMBER        := NULL;
s0_recInsertedInt       NUMBER        := NULL;
s0_recSelectedInt       NUMBER        := NULL;
s0_recUpdatedInt        NUMBER        := NULL;
s0_recDeletedInt        NUMBER        := NULL;
s0_userLoginId          VARCHAR2(30)  := user;
s0_message              VARCHAR2(255) := ''; 

-- module variables (v_)

v_debug                 NUMBER        := 0; 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     GB_PFSAWH_Process_Log a
    ORDER BY a.process_key DESC;
       
process_rec    process_cur%ROWTYPE;
       
BEGIN 
    ps_location := '00 - Create log record';

    pr_PHSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 00, 00, 
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

-- Cleanup the process log file - "PFSAWH.PFSAWH_PROCESS_LOG".

    pr_PFSAWH_log_cleanup;
    
-- Cleanup the debug log file - "PFSAWH.STD_PFSA_DEBUG_TBL".

    pr_PFSAWH_DebugTbl_cleanup;
    
--    COMMIT;

    IF v_debug > 0 THEN 
    
        DBMS_OUTPUT.NEW_LINE;

        OPEN process_cur;
    
        LOOP
            FETCH process_cur 
            INTO  process_rec;
        
            EXIT WHEN process_cur%NOTFOUND;
        
            DBMS_OUTPUT.PUT_LINE(process_rec.process_key || ', ' || process_rec.message);
        
        END LOOP;
    
        CLOSE process_cur;
    
    END IF;

    ps_location := '99 - Close log record';

    --    s0_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := sqlcode || ' - ' || sqlerrm; 
    
    pr_PHSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 00, 00, 
        s0_processStartDt, s0_processEndDt, 
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
--        RAISE;

--        ROLLBACK;
            
END maintain_PFSA_Warehouse;
/
