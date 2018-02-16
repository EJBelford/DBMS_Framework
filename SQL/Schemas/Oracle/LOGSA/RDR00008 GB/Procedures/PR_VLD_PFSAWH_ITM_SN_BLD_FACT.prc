CREATE OR REPLACE PROCEDURE pr_vld_pfsawh_itm_sn_bld_fact 
    (
    in_rec_Id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_vld_pfsawh_itm_sn_bld_fact
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 02 April 2008  
--
--          SP Source: PR_VLD_PFSAWH_ITM_SN_BLD_FACT.prc
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
-- 02APR08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_vld_pfsawh_itm_sn_bld_fact';  /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

s0_rec_Id                        pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  pfsawh_process_log.process_RecId%TYPE   
    := 112;                  /* NUMBER */
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
    
-- Process status variables (s1_)

s1_rec_Id                        pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s1_processRecId                  pfsawh_process_log.process_RecId%TYPE   
    := 112;                  /* NUMBER */
s1_processKey                    pfsawh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s1_moduleNum                     pfsawh_process_log.Module_Num%TYPE   
    := NULL;                 /* NUMBER */
s1_stepNum                       pfsawh_process_log.Step_Num%TYPE   
    := NULL;                 /* NUMBER */
s1_processStartDt                pfsawh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s1_processEndDt                  pfsawh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s1_processStatusCd               pfsawh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s1_sqlErrorCode                  pfsawh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s1_recReadInt                    pfsawh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s1_recValidInt                   pfsawh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s1_recLoadInt                    pfsawh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s1_recInsertedInt                pfsawh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s1_recSelectedInt                pfsawh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s1_recUpdatedInt                 pfsawh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s1_recDeletedInt                 pfsawh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s1_userLoginId                   pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s1_message                       pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     pfsawh_process_log a
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

--        dbms_lock.sleep(1);
    END IF;  

    --  physical_item_id      
     
    ps_location := '05-Item'; 
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_id - Get id'); 
    END IF;

    s1_processStartDt := sysdate;

    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 5, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    UPDATE pfsawh_item_sn_bld_fact 
    SET    physical_item_id = 
               NVL((
               SELECT item_id   
               FROM   pfsawh_item_dim
               WHERE  niin = s_sys_ei_niin 
               ), -1); 

    s1_recUpdatedInt := SQL%ROWCOUNT;
    s1_processEndDt := sysdate;
    s1_sqlErrorCode := sqlcode;
    s1_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s1_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 5, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s0_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    COMMIT; 
    
--  physical_item_sn_id 

    ps_location := '10-Item SN'; 
    s1_rec_id   := NULL; 
    s1_processStartDt := sysdate;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Flag aggregate'); 
    END IF;

    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 10, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    UPDATE pfsawh_item_sn_bld_fact 
    SET    physical_item_sn_id = 0, 
           status   = 'E', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR(NVL((notes || '~'), '') || 'Aggregate. ', 1, 255)
    WHERE  UPPER(s_sys_ei_sn) LIKE '%AGGREGATE%';  
    
    s1_recUpdatedInt := SQL%ROWCOUNT;
    
    COMMIT; 
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Get id'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    physical_item_sn_id = 
               NVL((
                   SELECT sn.physical_item_sn_id   
                   FROM   pfsawh_item_sn_dim sn 
                   WHERE  sn.item_niin = s_sys_ei_niin 
                       AND sn.item_serial_number = s_sys_ei_sn
                   ), -1)
    WHERE physical_item_id > 0 
        /*AND physical_item_sn_id > 0*/;  
        
    s1_recUpdatedInt := s1_recUpdatedInt + SQL%ROWCOUNT;

    COMMIT; 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Update status'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    status   = 'Z', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR(NVL((notes || '~'), '') || 'Item SN not found: ' || s_sys_ei_sn, 1, 255) 
    WHERE  physical_item_sn_id = -1;  
    
    s1_recUpdatedInt := s1_recUpdatedInt + SQL%ROWCOUNT;
    s1_processEndDt := sysdate;
    s1_sqlErrorCode := sqlcode;
    s1_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s1_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    COMMIT; 
    
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 10, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s0_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

-- mimosa_item_sn_id     
    
    ps_location := '15-MIMOSA'; 
    s1_rec_id   := NULL; 
    s1_processStartDt := sysdate;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Flag aggregate'); 
    END IF;

    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 15, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    UPDATE pfsawh_item_sn_bld_fact  
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id , 'XXXXXXX')), 8, '0')
    WHERE  physical_item_sn_id > 0; 
    
    s1_recUpdatedInt := SQL%ROWCOUNT;
    s1_processEndDt := sysdate;
    s1_sqlErrorCode := sqlcode;
    s1_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s1_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    COMMIT; 
    
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 15, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s0_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

-- force_id  

    ps_location := '20-Force'; 
    s1_rec_id   := NULL; 
    s1_processStartDt := sysdate;
        
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 20, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

----- bct_force_dim_id 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_bct_force_id - Get id'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    item_bct_force_id = NVL((  
                                SELECT bct_force_dim_id  
                                FROM   forcewh.bct_force_dim 
                                WHERE  uic = s_uic
                                    AND UPPER(SUBSTR(LTRIM(wh_record_status), 1, 1)) = 'C' 
                                ), -1); 
    
    COMMIT; 
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_bct_force_id - Update status'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    status   = 'Z', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR(NVL((notes || '~'), '') || 'BCT Force not found: ' || s_uic, 1, 255)
    WHERE  item_bct_force_id = -1;  
    
    s1_recUpdatedInt := SQL%ROWCOUNT;

    COMMIT; 
    
----- uto_force_dim_id 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_uto_force_id - Get id'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    item_uto_force_id = NVL((  
                                SELECT uto_force_dim_id  
                                FROM   forcewh.uto_force_dim 
                                WHERE  uic = s_uic
                                    AND UPPER(SUBSTR(LTRIM(wh_record_status), 1, 1)) = 'C' 
                                ), -1); 
    
    s1_recUpdatedInt := s1_recUpdatedInt + SQL%ROWCOUNT;

    COMMIT; 
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_uto_force_id - Update status'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    status   = 'Z', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR(NVL((notes || '~'), '') || 'UTO Force not found: ' || s_uic, 1, 255)
    WHERE  item_uto_force_id = -1;  
    
    COMMIT; 
    
----- tfb_force_dim_id 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_tfb_force_id - Get id'); 
    END IF;

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_tfb_force_id - Update status'); 
    END IF;

    s1_recUpdatedInt :=  s1_recUpdatedInt + SQL%ROWCOUNT;
    s1_processEndDt := sysdate;
    s1_sqlErrorCode := sqlcode;
    s1_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s1_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 20, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s0_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

-- date_id  
      
    ps_location := '25-Dates'; 
    s1_rec_id   := NULL; 
    s1_processStartDt := sysdate;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('date_id - Get id'); 
    END IF;

    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 25, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    UPDATE pfsawh_item_sn_bld_fact  
    SET    date_id = NVL(( 
                        SELECT date_dim_id 
                        FROM   date_dim 
                        WHERE  oracle_date = TO_CHAR( s_ready_date ) 
                        ), -1)
    WHERE  physical_item_id > 0
        AND physical_item_sn_id > 0;  
                        
    COMMIT; 
            
-- item_date_from_id     
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_date_from_id - Get id'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact  
    SET    item_date_from_id = NVL((  
                                SELECT date_dim_id  
                                FROM   date_dim 
                                WHERE  oracle_date = s_from_dt
                                ), -1)
    WHERE  physical_item_id > 0
        AND physical_item_sn_id > 0; 
            
    COMMIT; 
            
-- item_date_to_id        
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_date_to_id - Get id'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact  
    SET    item_date_to_id = NVL((
                                SELECT date_dim_id  
                                FROM   date_dim 
                                WHERE  oracle_date = TO_CHAR( s_to_dt, 'DD-MON-YYYY')
                                ), -1)
    WHERE  physical_item_id > 0
        AND physical_item_sn_id > 0; 

    s1_recUpdatedInt := SQL%ROWCOUNT;
    s1_processEndDt := sysdate;
    s1_sqlErrorCode := sqlcode;
    s1_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s1_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    COMMIT; 
    
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 25, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s0_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

-- item_date_to_id        
    
    ps_location := '90-Rec Flg'; 
    s1_rec_id   := NULL; 
    s1_processStartDt := sysdate;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Set record status to DW use.'); 
    END IF;

    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 90, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    UPDATE pfsawh_item_sn_bld_fact  
    SET    status = 'C' 
    WHERE  status NOT IN ('E', 'Z'); 
    
    s1_recUpdatedInt := SQL%ROWCOUNT;
    s1_processEndDt := sysdate;
    s1_sqlErrorCode := sqlcode;
    s1_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s1_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    COMMIT; 
    
    pr_pfsawh_InsUpd_ProcessLog (s1_processRecId, s1_processKey, 
        0, 90, 
        s1_processStartDt, s1_processEndDt, 
        s1_processStatusCd, s1_sqlErrorCode, 
        s1_recReadInt, s1_recValidInt, s0_recLoadInt, 
        s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
        s1_userLoginId, s1_message, s1_rec_id); 

    pr_load_pfsawh_item_sn_p_fact(0); 
    
    pr_load_pfsawh_item_sn_p_pbaft(0); 
    
    COMMIT; 
            
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
            
END; 

/*----- Test script -----*/

/* 

BEGIN  
    
    UPDATE pfsawh_item_sn_bld_fact
    SET physical_item_id = NULL, 
        physical_item_sn_id = NULL,  
        status = 'R';  
        
    COMMIT; 
        
    EXEC pr_vld_pfsawh_itm_sn_bld_fact(0);  
    
END; 

*/ 

