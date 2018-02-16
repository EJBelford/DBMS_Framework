CREATE OR REPLACE PROCEDURE PFSAWH.gb_load_pfsawh_item_sn_p_fact 
    (
    in_rec_Id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: GB_LOAD_PFSAWH_AVAIL_P_FACT
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
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
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'load_pfsawh_avail_p_fact';  /*  */
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

s0_rec_Id                        gb_pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_pfsawh_process_log.process_RecId%TYPE   
    := 107;                  /* NUMBER */
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

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

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
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || s0_processRecId || ', ' || s0_processKey);
    END IF;  

--

    SELECT COUNT(*) 
    INTO   s0_recReadInt 
    FROM   pfsa_equip_avail;

    DELETE gb_pfsawh_item_sn_p_fact; 
    
    s0_recDeletedInt := SQL%ROWCOUNT;

    COMMIT;
    
    INSERT 
    INTO   gb_pfsawh_item_sn_p_fact
        (
--        rec_id ,
--    
        date_id , 
        item_date_from_id ,
        item_date_to_id ,
--        AVAIL_FLEET_ID ,
--        AVAIL_MACOM_ID ,
--        AVAIL_UIC_ID ,
--        AVAIL_GEO_ID , 
-- 
        item_sys_ei_id ,        
        item_sn_ei_id ,        
--        AVAIL_LIN_CODE ,    
--        AVAIL_NIN_CODE ,        
--        AVAIL_NSN_CODE ,        
--        AVAIL_EIC_CODE ,        
--        AVAIL_UID_CODE ,        
--
        item_days , 
        period_hrs , 
        fmc_hrs , 
        mc_hrs , 
        pmc_hrs , 
        nmc_hrs , 
        nmcm_hrs , 
        nmcm_user_hrs , 
        nmcm_int_hrs , 
        nmcm_dep_hrs , 
        nmcs_hrs , 
        nmcs_user_hrs , 
        nmcs_int_hrs , 
        nmcs_dep_hrs , 
        pmcm_hrs , 
        pmcm_user_hrs , 
        pmcm_int_hrs , 
        dep_hrs , 
        pmcs_hrs , 
        pmcs_user_hrs , 
        pmcs_int_hrs --, 
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
--        updt_by ,
--        lst_updt ,
--
--        active_flag , 
--        active_date , 
--        inactive_date ,
--
--        insert_by , 
--        insert_date , 
--        update_by ,
--        update_date ,
--        delete_flag ,
--        delete_date ,
--        hidden_flag ,
--        hidden_date , 
        , notes
        )
        SELECT 
        NVL(( 
        SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( ready_date ) 
        ), -1),
---        day_date,
---        month_date,
        NVL((  
        SELECT date_id  
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = from_dt
        ), -1), 
        NVL((
        SELECT date_id  
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( to_dt, 'DD-MON-YYYY')
        ), -1),
--        
        NVL((
        SELECT item_id   
        FROM   gb_pfsawh_item_dim
        WHERE  niin = sys_ei_niin 
        ), -1),
        CASE
            WHEN UPPER(sys_ei_sn) = 'AGGREGATE' THEN 
                0
            ELSE
                NVL((
                SELECT item_sn_id   
                FROM   gb_pfsawh_item_sn_dim
                WHERE  item_niin = sys_ei_niin 
                    AND item_serial_number = sys_ei_sn
                ), -1)
        END CASE,
--        pfsa_item_id,
--        record_type,
--        pfsa_org,
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
        pmcs_int_hrs /*, 
--        
--        source_id,
--        heir_id,
--        priority,
--        uic,
        lst_updt,
        updt_by */
        , ready_date || ' - ' || sys_ei_niin || ' - ' || sys_ei_sn
        FROM pfsa_equip_avail; 
    
    s0_recInsertedInt := SQL%ROWCOUNT;

    COMMIT;
    
/*  the section below needs to written correctly.    */
/*  this is to give BI tool somethuing to work with. */    
/*
UPDATE gb_pfsawh_item_sn_dim sn
SET    (
       item_uic, 
       item_registration_num, 
       item_acq_date
       ) = 
    ( 
    SELECT  
        NVL(hr.uic, 'UNK'), 
        NVL(hr.registration_num, 'UNK'), 
        NVL(hr.acq_date, '01-JAN-1900')  
    FROM   gcssa_hr_asset@pfsawh.lidbdev hr
    WHERE  hr.lst_updt > '01-JUL-2007'  
        AND hr.serial_num LIKE '2AGR%'
        AND sn.item_serial_number = hr.serial_num 
    );
*/
/*  the section above needs to written correctly.    */
    
    s0_recUpdatedInt := SQL%ROWCOUNT;

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
            
END GB_LOAD_PFSAWH_ITEM_SN_P_FACT;
/
