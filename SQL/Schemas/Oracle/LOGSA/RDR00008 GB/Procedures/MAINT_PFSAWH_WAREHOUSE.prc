CREATE OR REPLACE PROCEDURE maint_pfsawh_warehouse 

IS

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         SP Name: maint_pfsawh_warehouse
--         SP Desc: Master procedure for managing the PFSA Data Warehouse
--
--   SP Created By: Gene Belford
-- SP Created Date: 19 December 2007 
--
--       SP Source: maint_pfsawh_warehouse.prc
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--   SP Parameters: 
--           Input: Gets control information from pfsawh_process_control.
-- 
--          Output: pfsawh_process_log
--                  pfsa_debug_stat   
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 19DEC07 - GB  -          -      - Created 
-- 17JAN08 - GB  -          -      - Renamed and updated 
--                 from maintain_PFSA_Warehouse
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Exception handling variables (ps_)

ps_procedure_name       VARCHAR2(30)  := 'maint_pfsawh_warehouse';
ps_location             VARCHAR2(30)  := 'Begin'; 
ps_oerr                 VARCHAR2(6)   := NULL;
ps_msg                  VARCHAR2(200) := NULL;
ps_id_key               VARCHAR2(200) := 'master';          

-- Process status variables (s0_ & s1_)

s0_rec_Id               NUMBER        := NULL; 

s0_processRecId         NUMBER        := 100; 
s0_processKey           NUMBER        := NULL;
s0_moduleNum            NUMBER        := 0;
s0_stepNum              NUMBER        := 0;
s0_processStartDt       DATE          := SYSDATE;
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

s1_processRecId         NUMBER        := 100; 
s1_processKey           NUMBER        := NULL;
s1_moduleNum            NUMBER        := 0;
s1_stepNum              NUMBER        := 0;
s1_processStartDt       DATE          := SYSDATE;
s1_processEndDt         DATE          := NULL;
s1_processStatusCd      NUMBER        := NULL;
s1_sqlErrorCode         NUMBER        := NULL;
s1_recReadInt           NUMBER        := NULL;
s1_recValidInt          NUMBER        := NULL;
s1_recLoadInt           NUMBER        := NULL;
s1_recInsertedInt       NUMBER        := NULL;
s1_recSelectedInt       NUMBER        := NULL;
s1_recUpdatedInt        NUMBER        := NULL;
s1_recDeletedInt        NUMBER        := NULL;
s1_userLoginId          VARCHAR2(30)  := user;
s1_message              VARCHAR2(255) := ''; 

-- module variables (v_)

v_debug                 NUMBER        := 0; 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     pfsawh_process_log a
    ORDER BY a.process_key DESC;
       
process_rec    process_cur%ROWTYPE;
       
----------------------------------- START --------------------------------------

BEGIN 
    ps_location := '00 - Begin';

    pr_pfsawh_insupd_processlog (s0_processRecId, s0_processKey, 
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

-- Cleanup the process log file - "PFSAWH.PFSAWH_PROCESS_LOG".

    pr_pfsawh_log_cleanup;
    
-- Cleanup the debug log file - "PFSAWH.STD_PFSA_DEBUG_TBL".

    pr_pfsawh_debugtbl_cleanup;
    
-- Dimensions 

    pr_get_dim_source_statistics(s0_rec_Id);

    pr_set_dim_source_triggers(s0_rec_Id);

--   Item

--    bld_pfsawh_item(s0_rec_Id);
    get_pfsaw_sys_ei(0); 
    
--   Item_SN

--    bld_pfsawh_item_sn(s0_rec_Id);
    get_pfsaw_sn_ei(0); 
    
--   force    
    
    pr_bld_pfsawh_force_dim(s0_rec_Id);
    
--   Locaction    
    
    pr_bld_pfsawh_location_dim(s0_rec_Id);
    
-- Facts 

    pr_get_fact_source_statistics(s0_rec_Id);

    pr_set_fact_source_triggers(s0_rec_Id);

--   Availabilty

    pr_ld_pfsawh_itm_sn_bld_fact(0);
    
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

    ps_location := '99 - Close';

    --    s0_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog (s0_processRecId, s0_processKey, 
        s0_moduleNum, s0_stepNum,  
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

END maint_pfsawh_warehouse;
/
