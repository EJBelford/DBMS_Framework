CREATE OR REPLACE PROCEDURE PFSAWH.pr_load_pfsawh_item_sn_p_fact 
    (
    in_rec_id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: GB_LOAD_PFSAWH_AVAIL_P_FACT
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 02 January 2008 
--
--          SP Source: GB_LOAD_PFSAWH_AVAIL_P_FACT.prc
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
-- 02JAN08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_load_pfsawh_item_sn_p_fact';  /*  */
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
    := 113;                  /* NUMBER */
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
    END IF;  

-- 

    s0_recUpdatedInt := SQL%ROWCOUNT;

    COMMIT;

    SELECT COUNT(*) 
    INTO   s0_recReadInt 
    FROM   pfsa_equip_avail;

    DELETE pfsawh_item_sn_p_fact; 
    
    s0_recDeletedInt := SQL%ROWCOUNT;

    COMMIT;
    
    INSERT 
    INTO   pfsawh_item_sn_p_fact
        (
        rec_id ,    
        date_id , 
        item_date_from_id ,
        item_date_to_id ,
        physical_item_id ,        
        physical_item_sn_id ,        
        mimosa_item_sn_id ,        
        item_days , 
        period_hrs , 
        fmc_hrs , 
        mc_hrs , 
        pmc_hrs , 
        nmc_hrs , 
        nmcm_hrs , 
        nmcs_hrs , 
        nmcm_user_hrs , 
        nmcm_int_hrs , 
        nmcm_dep_hrs , 
        nmcs_user_hrs , 
        nmcs_int_hrs , 
        nmcs_dep_hrs , 
        pmcm_hrs , 
        pmcm_user_hrs , 
        pmcm_int_hrs , 
        dep_hrs , 
        pmcs_hrs , 
        pmcs_user_hrs , 
        pmcs_int_hrs,  
--
--        operational_readiness_rate , 
--
--        operating_cost_per_hour , 
--        cost_parts , 
--        cost_manpower , 
--        deferred_maint_items , 
--        operat_hrs_since_last_overhaul , 
--        maint_hrs_since_last_overhaul , 
--        time_since_last_overhaul , 
--
--        status ,
        updt_by ,
        lst_updt ,
--
--        active_flag , 
--        active_date , 
--        inactive_date ,
--
        insert_by , 
--        insert_date , 
--        update_by ,
--        update_date ,
--        delete_flag ,
--        delete_date ,
--        hidden_flag ,
--        hidden_date , 
        notes
        )
        SELECT 
            rec_id, 
            date_id,
---            day_date,
---            month_date,
            item_date_from_id, 
            item_date_to_id,
--        
            physical_item_id,
            physical_item_sn_id,
            mimosa_item_sn_id,
--            pfsa_item_id,
--            record_type,
--            pfsa_org,
            item_days,
            period_hrs,
            fmc_hrs,
            mc_hrs,
            pmc_hrs,
            nmc_hrs,
            nmcm_hrs,
            nmcs_hrs,
            nmcm_user_hrs,
            nmcm_int_hrs,
            nmcm_dep_hrs,
            nmcs_user_hrs,
            nmcs_int_hrs,
            nmcs_dep_hrs,
            pmcm_hrs,
            pmcm_user_hrs,
            pmcm_int_hrs,
            dep_hrs,
            pmcs_hrs,
            pmcs_user_hrs,
            pmcs_int_hrs, 
--            heir_id,
--            priority,
--            uic,
            updt_by, 
            lst_updt,
            s_source_id,
            '' 
        FROM pfsawh_item_sn_bld_fact 
        WHERE UPPER(status) = ('C'); 
    
    s0_recInsertedInt := SQL%ROWCOUNT;

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
                ps_id_key, ps_msg, sysdate);
                
--     RAISE;

--     ROLLBACK;
            
END pr_load_pfsawh_item_sn_p_fact;
/

/*----- Test script -----*/

/* 

BEGIN  
    
    EXEC pr_load_pfsawh_item_sn_p_fact(0);  
    
END; 

*/ 