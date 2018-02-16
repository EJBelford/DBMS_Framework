/*<TOAD_FILE_CHUNK>*/

/******************************************************************************
   NAME:       pr_PFSAWH_InsUpd_ProcessLog
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/18/2007          1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     spr_PFSAWH_InsUpd_ProcessLog
      Sysdate:         12/18/2007
      Date and Time:   12/18/2007, 7:58:31 AM, and 12/18/2007 7:58:31 AM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

*******************************************************************************/
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         SP Name: pr_PFSAWH_InsUpd_ProcessLog
--         SP Desc: Captures SQL processing information for debugging 
--                  and monitoring
--
--   SP Created By: Gene Belford
-- SP Created Date: 18 December 2007 
--
--       SP Source: pr_PFSAWH_InsUpd_ProcessLog.sql
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--   SP Parameters: 
--           Input: For INSERT:
--                  v_rec_Id - NULL will create a new record 
--                  v_processRecId -  
--                  v_processKey - Code value for which process is 
--                       logging activity 
-- 
--          Output: v_rec_Id - The IDENTITY of the log record
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 18Dec07 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

CREATE OR REPLACE PROCEDURE pr_PFSAWH_InsUpd_ProcessLog 
    (
    v_processRecId          IN      NUMBER, 
    v_processKey            IN      NUMBER,
    v_moduleNum             IN      NUMBER        := NULL,
    v_stepNum               IN      NUMBER        := NULL,
    v_processStartDt        IN      DATE          := NULL,
    v_processEndDt          IN      DATE          := NULL,
    v_processStatusCd       IN      NUMBER        := NULL,
    v_sqlErrorCode          IN      NUMBER        := NULL,
    v_recReadInt            IN      NUMBER        := NULL,
    v_recValidInt           IN      NUMBER        := NULL,
    v_recLoadInt            IN      NUMBER        := NULL,
    v_recInsertedInt        IN      NUMBER        := NULL,
    v_recSelectedInt        IN      NUMBER        := NULL,
    v_recUpdatedInt         IN      NUMBER        := NULL,
    v_recDeletedInt         IN      NUMBER        := NULL,
    v_userLoginId           IN      VARCHAR2      := '',
    v_message               IN      VARCHAR2      := '', 
    v_rec_Id                IN OUT  NUMBER  
    )

IS

ps_procedure_name       VARCHAR2(30)  := 'pr_pfsawh_insupd_processlog';
ps_location             VARCHAR2(10)  := 'needed'; 
ps_oerr                 VARCHAR2(6)   := null;
ps_msg                  VARCHAR2(200) := null;
ps_id_key               VARCHAR2(200) := null;  

tmpVar                  NUMBER;

v_debug                 NUMBER; 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     pfsawh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
BEGIN
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    v_debug := 0;

    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('v_rec_Id: ' || v_rec_Id 
            || ' | ' || v_processRecId || ' | ' || v_processKey
            );
    END IF;  


-- If the v_rec_Id is NULL then we assume that a new log record is required

    IF v_rec_Id IS NULL THEN
 
        ps_location := 'Insert'; 
        
        IF v_debug > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Insert'); 
        END IF;

        INSERT 
        INTO   pfsawh_process_log                
            (
            process_key,
            process_start_date, 
            process_RecId, 
            user_login_id        
            )
        VALUES 
            (
            v_ProcessKey, 
            v_processStartDt, 
            v_processRecId, 
            v_userLoginId
            ); 

-- Get the IDENTITY of the new record to pass back out for 
-- updates to the log entry

        SELECT MAX(process_key) 
        INTO   v_rec_Id 
        FROM   pfsawh_process_log;                 

    ELSE
    
        ps_location := 'Update'; 
        
        IF v_debug > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Update v_rec_Id: ' || v_rec_Id); 
        END IF;

        UPDATE pfsawh_process_log                
        SET    module_num          = v_moduleNum, 
               step_num            = v_stepNum, 
               process_End_Date    = v_processEndDt,
               process_Status_Code = NVL(v_processStatusCd, v_sqlErrorCode),
               sql_Error_Code      = v_sqlErrorCode,
               rec_Read_Int        = v_recReadInt,
               rec_Valid_Int       = v_recValidInt,
               rec_Load_Int        = v_recLoadInt,
               rec_Inserted_Int    = v_recInsertedInt,
               rec_Selected_Int    = v_recSelectedInt,
               rec_Updated_Int     = v_recUpdatedInt,
               rec_Deleted_Int     = v_recDeletedInt,
               message             = v_message 
        WHERE  process_key = v_rec_Id;
    END IF;

    IF v_debug > 0 THEN 
    
        DBMS_OUTPUT.NEW_LINE;

        OPEN process_cur;
    
        LOOP
            FETCH process_cur 
            INTO  process_rec;
        
            EXIT WHEN process_cur%NOTFOUND;
        
            DBMS_OUTPUT.PUT_LINE(process_rec.process_key 
                || ', ' || process_rec.message
                );
        
        END LOOP;
    
        CLOSE process_cur;
    
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
            
		     INSERT 
            INTO   std_pfsa_debug_tbl (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
		     VALUES (
                ps_procedure_name, ps_oerr, ps_location, v_userLoginId, 
                ps_id_key, ps_msg, sysdate
                );

--          RAISE;
            
END pr_PFSAWH_InsUpd_ProcessLog;
/
/*<TOAD_FILE_CHUNK>*/

/*----- Test script -----*/

/*
DECLARE 
    v_processRecId          NUMBER        := 1 ; 
    v_processKey            NUMBER        := 1 ;
    v_processStartDt        DATE          := sysdate ;
    v_processEndDt          DATE          := NULL ;
    v_processStatusCd       NUMBER        := NULL ;
    v_sqlErrorCode          NUMBER        := NULL ;
    v_recReadInt            NUMBER        := NULL ;
    v_recValidInt           NUMBER        := NULL ;
    v_recLoadInt            NUMBER        := NULL ;
    v_recInsertedInt        NUMBER        := NULL ;
    v_recSelectedInt        NUMBER        := NULL ;
    v_recUpdatedInt         NUMBER        := NULL ;
    v_recDeletedInt         NUMBER        := NULL ;
    v_userLoginId           VARCHAR2(20)  := user ;
    v_message               VARCHAR2(255) := 'test - ' || sysdate  ; 
    v_rec_Id                NUMBER        := NULL ;    
BEGIN    
    pr_PHSAWH_InsUpd_ProcessLog (v_processRecId, v_processKey, 
        v_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        v_userLoginId, NULL, v_rec_Id);
    DBMS_OUTPUT.PUT_LINE('v_rec_Id: ' || v_rec_Id);
    UPDATE GB_PFSAWH_Process_Log SET rec_updated_int = 0;
    v_recUpdatedInt := SQL%ROWCOUNT;
    v_processEndDt := sysdate;
    v_sqlErrorCode := sqlcode;
    v_message := sqlcode || ' - ' || sqlerrm; 
    pr_PHSAWH_InsUpd_ProcessLog (v_processRecId, v_processKey, 
        v_processStartDt, v_processEndDt, 
        1, v_sqlErrorCode, 
        v_recReadInt, v_recValidInt, v_recLoadInt, 
        v_recInsertedInt, v_recSelectedInt, v_recUpdatedInt, v_recDeletedInt, 
        v_userLoginId, v_message, v_rec_Id);
END; 
-- DELETE GB_PFSAWH_Process_Log WHERE process_key < 1000059
-- SELECT * FROM GB_PFSAWH_Process_Log ORDER BY process_key DESC
-- SELECT * FROM std_pfsa_debug_tbl ORDER BY msg_dt DESC 
*/
