/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_load_pfsawh_item_sn_p_fact
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 02 January 2008 
--
--          SP Source: pr_load_pfsawh_item_sn_p_fact.sql
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

/*----- Test script ----- 

BEGIN 

--    pr_ld_pfsawh_itm_sn_bld_fact(0); 
     
    COMMIT; 

--    pr_vld_pfsawh_itm_sn_bld_fact(0);   
    
    COMMIT; 
        
    pr_load_pfsawh_item_sn_p_fact(0); 
    
    COMMIT; 

END; 

*/

CREATE OR REPLACE PROCEDURE pr_load_pfsawh_item_sn_p_fact 
    (
    in_rec_id                IN      NUMBER  
    )

IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_LOAD_PFSAWH_ITEM_SN_P_FACT';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

proc0_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 pfsawh_process_log%ROWTYPE; 
proc1                 pfsawh_process_log%ROWTYPE; 

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days          pfsawh_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off) 

v_etl_copy_cutoff       DATE; 
v_t_fact_cutoff         DATE; 
v_t_fact_cutoff_id      NUMBER; 
v_p_fact_cutoff         DATE; 
v_p_fact_cutoff_id      NUMBER; 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     pfsawh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
----------------------------------- START --------------------------------------

BEGIN

    ps_location := '00-Start'; 
    
-- Get the process control values from PFSAWH_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
    v_t_fact_cutoff_days   := fn_pfsawh_get_prcss_cntrl_val('v_t_fact_cutoff_days'); 
    v_p_fact_cutoff_months := fn_pfsawh_get_prcss_cntrl_val('v_p_fact_cutoff_months');  

-- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    v_etl_copy_cutoff    := SYSDATE - v_etl_copy_cutoff_days; 
    v_t_fact_cutoff      := SYSDATE - v_t_fact_cutoff_days; 
    v_t_fact_cutoff_id   := fn_date_to_date_id(v_t_fact_cutoff); 
    v_p_fact_cutoff      := ADD_MONTHS(SYSDATE,  (-1 * v_p_fact_cutoff_months)); 
    v_p_fact_cutoff_id   := fn_date_to_date_id(v_p_fact_cutoff); 

    proc0.process_RecId      := 113; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
  
    pr_pfsawh_insupd_processlog 
        (
        proc0.process_RecId, proc0.process_Key, 
        proc0.module_Num, proc0.step_Num,  
        proc0.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc0.user_Login_Id, NULL, proc0_recId
        );  
        
    COMMIT;     
        
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || proc0.process_RecId || ', ' || proc0.process_Key);
    END IF;  

-- 
   
    SELECT COUNT(rec_id) 
    INTO   proc0.rec_Read_Int 
    FROM   pfsawh_item_sn_bld_fact; 

    SELECT COUNT(rec_id) 
    INTO   proc0.rec_Valid_Int 
    FROM   pfsawh_item_sn_bld_fact 
    WHERE  UPPER(status) = ('C'); 

    DELETE pfsawh_item_sn_p_fact
    WHERE  notes LIKE 'PR_LOAD_PFSAWH_ITEM_SN_P_FACT%'; 
    
    proc0.rec_Deleted_Int := NVL(proc0.rec_Deleted_Int, 0) + SQL%ROWCOUNT;

    COMMIT;
    
    INSERT 
    INTO   pfsawh_item_sn_p_fact
        (
        rec_id,    
        period_type,
        date_id, item_date_from_id, item_date_to_id,
        item_time_from_id,
        item_time_to_id,
        physical_item_id, physical_item_sn_id, mimosa_item_sn_id,    
        item_force_id,     
--  item_location_id                0,
--  item_usage_0                    
--  item_usage_type_0               
--  item_usage_1                    
--  item_usage_type_1              
--  item_usage_2                    
--  item_usage_type_2            
        item_days, period_hrs, 
        fmc_hrs, mc_hrs, pmc_hrs, nmc_hrs, nmcm_hrs, nmcs_hrs, 
        nmcm_user_hrs, nmcm_int_hrs, nmcm_dep_hrs, 
        nmcs_user_hrs, nmcs_int_hrs, nmcs_dep_hrs, 
        pmcm_hrs, pmcm_user_hrs, pmcm_int_hrs, 
        dep_hrs, 
        pmcs_hrs, pmcs_user_hrs, pmcs_int_hrs,  
--        operational_readiness_rate , 
-- 
--  maint_action_cnt                
--  meantime_btwn_maint_act         
--  meandown_item                   
--  customer_wait_time              
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
        updt_by, lst_updt,
--        active_flag , 
--        active_date , 
--        inactive_date ,
        insert_by, 
--        insert_date , 
--        update_by ,
--        update_date ,
--        delete_flag ,
--        delete_date ,
--        hidden_flag ,
--        hidden_date , 
        pba_id, notes, etl_processed_by, 
        readiness_reported_qty 
        )
        SELECT 
            rec_id, 
            'MN',
            date_id, item_date_from_id, item_date_to_id,
            10001,
            86401,
---            day_date,
---            month_date,
            physical_item_id,
            physical_item_sn_id,
            mimosa_item_sn_id,
            item_force_unit_id,     
--            pfsa_item_id,
--            record_type,
--            pfsa_org,
            item_days, period_hrs,
            fmc_hrs, mc_hrs, pmc_hrs, nmc_hrs, nmcm_hrs, nmcs_hrs,
            nmcm_user_hrs, nmcm_int_hrs, nmcm_dep_hrs,
            nmcs_user_hrs, nmcs_int_hrs, nmcs_dep_hrs,
            pmcm_hrs, pmcm_user_hrs, pmcm_int_hrs,
            dep_hrs,
            pmcs_hrs, pmcs_user_hrs, pmcs_int_hrs, 
--            heir_id,
--            priority,
--            uic,
--            status, notes,  
            updt_by, lst_updt,
            s_source_id,
            pba_id, 'PR_LOAD_PFSAWH_ITEM_SN_P_FACT', etl_processed_by,
            ROUND(item_days / (item_date_to_id - item_date_from_id))
        FROM pfsawh_item_sn_bld_fact 
        WHERE UPPER(status) = ('C'); 
    
    proc0.rec_Inserted_Int := NVL(proc0.rec_Inserted_Int, 0) + SQL%ROWCOUNT;

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

--    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT;
    
    proc0.process_End_date    := sysdate;
    proc0.sql_Error_Code      := sqlcode;
    proc0.process_Status_code := NVL(proc0.sql_Error_Code, sqlcode);
    proc0.message             := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    pr_pfsawh_insupd_processlog 
        (
        proc0.process_recid, proc0.process_key, 
        proc0.module_num, proc0.step_num,  
        proc0.process_start_date, proc0.process_end_date, 
        proc0.process_status_code, proc0.sql_error_code, 
        proc0.rec_read_int, proc0.rec_valid_int, proc0.rec_load_int, 
        proc0.rec_inserted_int, proc0.rec_merged_int, proc0.rec_selected_int, 
        proc0.rec_updated_int, proc0.rec_deleted_int, 
        proc0.user_login_id, proc0.message, proc0_recid
        );

    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
		    ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
		     
            INSERT 
            INTO std_pfsawh_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
		     VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, proc0.user_Login_Id, 
                ps_id_key, ps_msg, sysdate);
                
            COMMIT;

END pr_load_pfsawh_item_sn_p_fact;
/


