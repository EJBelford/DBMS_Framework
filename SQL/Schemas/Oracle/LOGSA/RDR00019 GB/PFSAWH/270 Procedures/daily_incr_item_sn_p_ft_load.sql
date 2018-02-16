CREATE OR REPLACE PROCEDURE daily_incr_item_sn_p_ft_load 
    (
    type_maintenance    IN    VARCHAR2 -- calling procedure name, used in 
                                       -- debugging, calling procedure 
                                       -- responsible for maintaining 
                                       --  heirachy 
    )
    
IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: daily_incr_item_sn_p_ft_load 
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 23 October 2008 
--
--          SP Source: daily_incr_item_sn_p_ft_load.sql 
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- 
-- Loads the PFSAWH_ITEM_SN_P_FACT fact table.    
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
-- 23OCT08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

BEGIN 

    daily_incr_item_sn_p_ft_load ('GBelford'); 
    
    COMMIT;  

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'DAILY_INCR_ITEM_SN_P_FT_LOAD';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'no message defined'; /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- standard variables

ps_status                        VARCHAR2(10)  := 'STARTED';

ps_main_status                   VARCHAR2(10)  := null;

l_ps_start                       DATE          := sysdate;
l_now_is                         DATE          := sysdate;

l_call_error                     VARCHAR2(20)  := null;
ls_start                         DATE          := null;

proc0_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 pfsawh_process_log%ROWTYPE; 
proc1                 pfsawh_process_log%ROWTYPE; 

ps_last_process       pfsawh_processes%ROWTYPE;
ps_this_process       pfsawh_processes%ROWTYPE;
ls_current_process    pfsawh_processes%ROWTYPE; 

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                 NUMBER        := 0; 

myrowcount              number;
mytablename             varchar2(64);

-- added date control lmj 05nov08

my_lst_updt             DATE := null;
my_insert_dt            DATE := null;
my_update_dt            DATE := null;

CURSOR item_sn_cur IS
    SELECT pea.physical_item_id, 
        it.niin, 
        it.item_nomen_standard, 
        pea.physical_item_sn_id, 
        pea.sys_ei_sn, 
        COUNT(pea.rec_id) 
    FROM   pfsa_equip_avail pea 
    LEFT OUTER JOIN pfsawh_item_dim it ON it.physical_item_id = pea.physical_item_id 
    WHERE (pea.insert_date > my_lst_updt OR pea.update_date > my_lst_updt) 
        AND pea.physical_item_sn_id IS NOT NULL 
        AND pea.physical_item_sn_id > 0 
--        AND pea.sys_ei_niin = '014360005'
    GROUP BY pea.physical_item_id, 
        it.niin, 
        it.item_nomen_standard, 
        pea.sys_ei_sn, 
        pea.physical_item_sn_id  
    ORDER BY pea.physical_item_id; 

item_sn_rec    item_sn_cur%ROWTYPE;

BEGIN 

-- Get the process control values from PFSAWH_PROCESS_CONTROL. 

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_etl_copy_cutoff_days: ' || v_etl_copy_cutoff_days   
--           || ', ' || 'v_etl_copy_cutoff'        || v_etl_copy_cutoff
           );
    END IF;  

    proc0.process_RecId      := 582; 
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
        
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

    ps_id_key := NVL(type_maintenance, 'daily_incr_item_sn_p_ft_load');

-- Housekeeping for the process 
  
    ps_location := 'PFSA 00';            -- For std_pfsawh_debug_tbl logging. 

    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_status      := 'BEGAN';
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_compl       := null;

-- get the run criteria from the pfsa_processes table for the last run of this 
-- main process 
  
    get_pfsawh_process_info ( 
        ps_procedure_name, ps_procedure_name, ps_last_process.last_run, 
        ps_last_process.who_ran, ps_last_process.last_run_status, 
        ps_last_process.last_run_status_time, ps_last_process.last_run_compl
        );

-- Update the PFSA_PROCESSES table to indicate MAIN process began.  

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );
      
    COMMIT;

-- Call the MERGE PBA REF routine.  

    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging.

    ls_current_process.pfsa_process := 'DAILY_INCR_ITEM_SN_P_FT_LOAD'; 
  
-- Get the run criteria from the PFSA_PROCESSES table for the last run of 
-- the MAINTAIN_PFSA_DATES process 
  
    get_pfsawh_process_info
        (
        ps_procedure_name, ls_current_process.pfsa_process, 
        ls_current_process.last_run, ls_current_process.who_ran, 
        ls_current_process.last_run_status, 
        ls_current_process.last_run_status_time, 
        ls_current_process.last_run_compl
        );

    ls_start                             := sysdate;
    ls_current_process.last_run          := ls_start;
    ls_current_process.last_run_status   := 'BEGAN';
    ls_current_process.who_ran           := ps_id_key;
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_status      := ps_location;

-- Update the pfsa_processes table to indicate MAIN process location.  

    ps_location := 'PFSA 20';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_last_process.last_run_compl
        );

    COMMIT;

-- Update the pfsa_processes table to indicate the sub-process 
-- MERGE PBA REF has started.  

    ps_location := 'PFSA 30';            -- For std_pfsawh_debug_tbl logging.

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
/*----------------------------------------------------------------------------*/  

    proc1_recId              := NULL; 
    proc1.rec_inserted_int   := NULL;
    proc1.rec_merged_int     := NULL;
    proc1.rec_selected_int   := NULL;
    proc1.rec_deleted_int    := NULL;
    proc1.rec_updated_int    := NULL;
      
    proc1.process_RecId      := 582; 
    proc1.process_Key        := NULL;
    proc1.module_Num         := 10;
    proc1.process_Start_Date := SYSDATE;
    proc1.user_Login_Id      := USER; 
  
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_RecId, proc1.process_Key, 
        proc1.module_Num, proc1.step_Num,  
        proc1.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc1.user_Login_Id, NULL, proc1_recId
        );
        
    ps_location := 'PFSA 40';            -- For std_pfsawh_debug_tbl logging. 
    
-- Get the run criteria for the PFSA_EQUIP_AVAIL from pfsa_process table 

    get_pfsawh_process_info
        (
        ps_procedure_name, ls_current_process.pfsa_process, 
        ls_current_process.last_run, ls_current_process.who_ran, 
        ls_current_process.last_run_status, 
        ls_current_process.last_run_status_time, 
        ls_current_process.last_run_compl
        );
  
    ls_start                           := SYSDATE;
    ls_current_process.last_run        := ls_start;
    l_call_error                       := NULL;
    ls_current_process.last_run_status := 'BEGAN';
    ls_current_process.who_ran         := ps_id_key;
 
-- Update the pfsa_process table to indicate STATUS of PFSA_EQUIP_AVAIL. 

    updt_pfsawh_processes
        (
        ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
        ps_this_process.who_ran, ls_current_process.last_run_status, 
        l_now_is, ls_current_process.last_run_compl
        );

    COMMIT;
  
    ps_status := ps_location;
  
-- Update main process to indicate where its at 

    updt_pfsawh_processes
        (ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_status, l_now_is, 
        ps_this_process.last_run_compl
        ); 
      
    COMMIT;  
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    ps_location  := 'PFSA 50';            -- For std_pfsawh_debug_tbl logging. 

    my_lst_updt  := NULL;
    my_insert_dt := NULL;
    my_update_dt := NULL;
    
    SELECT MAX(insert_date) INTO my_insert_dt FROM pfsa_equip_avail;
    SELECT MAX(update_date) INTO my_update_dt FROM pfsa_equip_avail; 
    
-- 13NOV08 - GB  -          -      - Adjusted the my_lst_updt to not use update
--                                   dates 01-Jan-2000 when calculating the 
--                                   last update date.  

    IF my_update_dt < TO_DATE('01-JAN-2000', 'DD-MON-YYYY') THEN
      my_lst_updt := my_insert_dt;  
    ELSIF my_insert_dt > my_update_dt THEN
      my_lst_updt := my_update_dt;
    ELSE
      my_lst_updt := my_insert_dt;
    END IF;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
 
    ps_location := 'PFSA 60';            -- For std_pfsawh_debug_tbl logging. 
    
    OPEN item_sn_cur;
    
    LOOP
        FETCH item_sn_cur 
        INTO  item_sn_rec;
        
        EXIT WHEN (item_sn_cur%NOTFOUND 
--            OR (item_sn_cur%ROWCOUNT > 10)
            ); 

        proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
        
        IF v_debug > 0 THEN
            DBMS_OUTPUT.PUT_LINE
                (
                   'sys_ei_niin '         || item_sn_rec.niin 
                || ' physical_item_id '    || item_sn_rec.physical_item_id 
                || ' sys_ei_sn '           || item_sn_rec.sys_ei_sn 
                || ' physical_item_sn_id ' || item_sn_rec.physical_item_sn_id 
                );
        END IF;
            
--        UPDATE pfsawh_item_sn_p_fact pf
--        SET    ( 
--              --  item_days,
--                period_hrs,
--                mc_hrs,
--                fmc_hrs,
--                pmc_hrs,
--                pmcm_hrs,
--                pmcs_hrs,
--                nmc_hrs,
--                nmcm_hrs,
--                nmcm_user_hrs,
--                nmcm_int_hrs,
--                nmcm_dep_hrs,
--                nmcs_hrs,
--                nmcs_user_hrs,
--                nmcs_int_hrs,
--                nmcs_dep_hrs, 
--                readiness_reported_qty, 
--                update_by, 
--                update_date, 
--                etl_processed_by  
--                ) = ( 
--                SELECT   
--             --       SUM(NVL(item_days, pf.item_date_to_id - pf.item_date_from_id + 1)),
--                    SUM(period_hrs),
--                    SUM(mc_hrs),
--                    SUM(fmc_hrs),
--                    SUM(pmc_hrs),
--                    SUM(pmcm_hrs),
--                    SUM(pmcs_hrs),
--                    SUM(nmc_hrs),
--                    SUM(nmcm_hrs),
--                    SUM(nmcm_user_hrs),
--                    SUM(nmcm_int_hrs),
--                    SUM(nmcm_dep_hrs),
--                    SUM(nmcs_hrs),
--                    SUM(nmcs_user_hrs),
--                    SUM(nmcs_int_hrs),
--                    SUM(nmcs_dep_hrs), 
--                    SUM(readiness_reported_qty), 
--                    USER, 
--                    l_now_is, 
--                    ps_procedure_name
--                FROM   pfsa_equip_avail pea 
--                WHERE  pea.physical_item_id = pf.physical_item_id    
--                    AND pea.physical_item_sn_id = pf.physical_item_sn_id  
--                    AND pea.pba_id = pf.pba_id  
--                    AND pea.force_unit_id = pf.item_force_id
--                    AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
--                    AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
--                GROUP BY pea.physical_item_sn_id, pea.pba_id, 
--                    pea.ready_date, pea.force_unit_id
--                    ) 
--        WHERE pf.physical_item_id = item_sn_rec.physical_item_id 
--            AND pf.physical_item_sn_id = item_sn_rec.physical_item_sn_id; 

        MERGE INTO pfsawh_item_sn_p_fact pf
        USING ( 
              SELECT   
                    physical_item_id, physical_item_sn_id, pba_id, 
                    ready_date, force_unit_id,
                    SUM(period_hrs) as period_hrs,
                    SUM(mc_hrs) as mc_hrs,
                    SUM(fmc_hrs) as fmc_hrs,
                    SUM(pmc_hrs) as pmc_hrs,
                    SUM(pmcm_hrs) as pmcm_hrs,
                    SUM(pmcs_hrs) as pmcs_hrs,
                    SUM(nmc_hrs) as nmc_hrs,
                    SUM(nmcm_hrs) as nmcm_hrs,
                    SUM(nmcm_user_hrs) as nmcm_user_hrs,
                    SUM(nmcm_int_hrs) as nmcm_int_hrs,
                    SUM(nmcm_dep_hrs) as nmcm_dep_hrs,
                    SUM(nmcs_hrs) as nmcs_hrs,
                    SUM(nmcs_user_hrs) as nmcs_user_hrs,
                    SUM(nmcs_int_hrs) as nmcs_int_hrs,
                    SUM(nmcs_dep_hrs) as nmcs_dep_hrs, 
                    SUM(readiness_reported_qty) as rrq
                 FROM   pfsa_equip_avail 
                 WHERE  physical_item_id = item_sn_rec.physical_item_id 
                     AND physical_item_sn_id = item_sn_rec.physical_item_sn_id 
                     AND delete_flag = 'N' 
                     AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
                 GROUP BY physical_item_id, physical_item_sn_id, pba_id, 
                          ready_date, force_unit_id
              ) pea 
        ON (    pf.physical_item_id     = item_sn_rec.physical_item_id 
            AND pf.physical_item_sn_id  = item_sn_rec.physical_item_sn_id 
            AND pea.physical_item_id    = pf.physical_item_id
            AND pea.physical_item_sn_id = pf.physical_item_sn_id  
            AND pea.pba_id              = pf.pba_id  
            AND pea.force_unit_id       = pf.item_force_id
            AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
           )   
        WHEN MATCHED THEN 
            UPDATE SET
                pf.period_hrs = pea.period_hrs,
                pf.mc_hrs = pea.mc_hrs,
                pf.fmc_hrs = pea.fmc_hrs,
                pf.pmc_hrs = pea.pmc_hrs,
                pf.pmcm_hrs = pea.pmcm_hrs,
                pf.pmcs_hrs = pea.pmcs_hrs,
                pf.nmc_hrs = pea.nmc_hrs,
                pf.nmcm_hrs = pea.nmcm_hrs,
                pf.nmcm_user_hrs = pea.nmcm_user_hrs,
                pf.nmcm_int_hrs = pea.nmcm_int_hrs,
                pf.nmcm_dep_hrs = pea.nmcm_dep_hrs,
                pf.nmcs_hrs = pea.nmcs_hrs,
                pf.nmcs_user_hrs = pea.nmcs_user_hrs,
                pf.nmcs_int_hrs = pea.nmcs_int_hrs,
                pf.nmcs_dep_hrs = pea.nmcs_dep_hrs,
                pf.readiness_reported_qty = pea.rrq, 
                pf.update_by = USER, 
                pf.update_date = l_now_is, 
                pf.etl_processed_by = ps_procedure_name 
        WHEN NOT MATCHED THEN
            INSERT (
                date_id, 
                pba_id,  
                physical_item_id, 
                physical_item_sn_id,  
                item_force_id, 
                item_date_from_id, 
                item_date_to_id, 
                period_hrs, 
                mc_hrs,
                fmc_hrs,
                pmc_hrs,
                pmcm_hrs,
                pmcs_hrs,
                nmc_hrs,
                nmcm_hrs,
                nmcm_user_hrs,
                nmcm_int_hrs,
                nmcm_dep_hrs,
                nmcs_hrs,
                nmcs_user_hrs,
                nmcs_int_hrs,
                nmcs_dep_hrs,
                readiness_reported_qty, 
                update_by, 
                update_date, 
                etl_processed_by
                )
            VALUES (
                fn_date_to_date_id(pea.ready_date),  
                pea.pba_id,  
                pea.physical_item_id,
                pea.physical_item_sn_id,  
                pea.force_unit_id, 
                fn_date_to_date_id(pea.ready_date) - 14,  
                fn_date_to_date_id(pea.ready_date),  
                pea.period_hrs,
                pea.mc_hrs,
                pea.fmc_hrs,
                pea.pmc_hrs,
                pea.pmcm_hrs,
                pea.pmcs_hrs,
                pea.nmc_hrs,
                pea.nmcm_hrs,
                pea.nmcm_user_hrs,
                pea.nmcm_int_hrs,
                pea.nmcm_dep_hrs,
                pea.nmcs_hrs,
                pea.nmcs_user_hrs,
                pea.nmcs_int_hrs,
                pea.nmcs_dep_hrs,
                pea.rrq, 
                USER, 
                l_now_is, 
                ps_procedure_name
                );

        proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
        proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;

        COMMIT; 
    
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/  

-- Insert the new facts within the cutoff window.  

-- M - Miles 

        MERGE INTO pfsawh_item_sn_p_fact pf
        USING 
              (
              SELECT 
                    ue.physical_item_id, ue.pba_id, ue.physical_item_sn_id, 
                    ue.month_seg_date_id, ue.usage_mb,   
                    SUM(ue.usage) as usage
                 FROM   pfsa_usage_event ue 
                 WHERE   (ue.insert_date > my_lst_updt OR ue.update_date > my_lst_updt) 
                     AND ue.physical_item_id = item_sn_rec.physical_item_id 
                     AND ue.physical_item_sn_id = item_sn_rec.physical_item_sn_id    
                     AND ue.usage_mb = ('M')
                     AND ue.delete_flag = 'N' 
--                     AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
                 GROUP BY ue.physical_item_id, ue.usage_mb, ue.pba_id, 
                     ue.physical_item_sn_id, ue.month_seg_date_id 
              )tf  
        ON (    pf.physical_item_id = item_sn_rec.physical_item_id 
            AND pf.physical_item_sn_id = item_sn_rec.physical_item_sn_id    
            AND tf.physical_item_id = pf.physical_item_id 
            AND tf.physical_item_sn_id = pf.physical_item_sn_id
            AND tf.month_seg_date_id = pf.date_id 
            AND tf.pba_id = pf.pba_id) 
        WHEN MATCHED THEN UPDATE SET
                  pf.item_usage_type_0 = tf.usage_mb, 
                  pf.item_usage_0      = tf.usage, 
                  pf.update_by         = USER, 
                  pf.update_date       = l_now_is, 
                  pf.etl_processed_by  = ps_procedure_name;    

        proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
        proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;
    
-- H - Hours 

        MERGE INTO pfsawh_item_sn_p_fact pf
        USING 
              (
              SELECT 
                    physical_item_id, pba_id, physical_item_sn_id, 
                    month_seg_date_id, usage_mb,   
                    SUM(usage) as usage
                 FROM   pfsa_usage_event  
                 WHERE   (insert_date > my_lst_updt OR update_date > my_lst_updt) 
                     AND usage_mb = ('H')
                     AND delete_flag = 'N'   
--                     AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
                 GROUP BY physical_item_id, usage_mb, pba_id, 
                     physical_item_sn_id, month_seg_date_id 
              )tf  
        ON (    pf.physical_item_id = item_sn_rec.physical_item_id 
            AND pf.physical_item_sn_id = item_sn_rec.physical_item_sn_id    
            AND tf.physical_item_id = pf.physical_item_id 
            AND tf.physical_item_sn_id = pf.physical_item_sn_id
            AND tf.month_seg_date_id = pf.date_id 
            AND tf.pba_id = pf.pba_id) 
        WHEN MATCHED THEN UPDATE SET
                  pf.item_usage_type_1 = tf.usage_mb, 
                  pf.item_usage_1      = tf.usage, 
                  pf.update_by         = USER, 
                  pf.update_date       = l_now_is, 
                  pf.etl_processed_by  = ps_procedure_name; 

        proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
        proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;
    
-- F - Flight hours     

        MERGE INTO pfsawh_item_sn_p_fact pf
        USING 
              (
              SELECT 
                    physical_item_id, pba_id, physical_item_sn_id, 
                    month_seg_date_id, usage_mb,  
                    SUM(usage) as usage
                 FROM   pfsa_usage_event  
                 WHERE  (insert_date > my_lst_updt OR update_date > my_lst_updt) 
                     AND usage_mb = ('F')
                     AND delete_flag = 'N'   
--                     AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
                 GROUP BY physical_item_id, usage_mb, pba_id, 
                     physical_item_sn_id, month_seg_date_id 
              )tf  
        ON (    pf.physical_item_id = item_sn_rec.physical_item_id 
            AND pf.physical_item_sn_id = item_sn_rec.physical_item_sn_id    
            AND tf.physical_item_id = pf.physical_item_id 
            AND tf.physical_item_sn_id = pf.physical_item_sn_id
            AND tf.month_seg_date_id = pf.date_id 
            AND tf.pba_id = pf.pba_id) 
        WHEN MATCHED THEN UPDATE SET
                  pf.item_usage_type_0 = tf.usage_mb, 
                  pf.item_usage_0      = tf.usage, 
                  pf.update_by         = USER, 
                  pf.update_date       = l_now_is, 
                  pf.etl_processed_by  = ps_procedure_name; 

        proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
        proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;
    
-- L - Landings     

        MERGE INTO pfsawh_item_sn_p_fact pf
        USING 
              (
              SELECT 
                    physical_item_id, pba_id, physical_item_sn_id, 
                    month_seg_date_id, usage_mb, 
                    SUM(usage) as usage
                 FROM   pfsa_usage_event  
                 WHERE  (insert_date > my_lst_updt OR update_date > my_lst_updt) 
                     AND usage_mb = ('L') 
                     AND delete_flag = 'N'   
--                     AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
                 GROUP BY physical_item_id, usage_mb, pba_id, 
                     physical_item_sn_id, month_seg_date_id 
              )tf  
        ON (    pf.physical_item_id = item_sn_rec.physical_item_id 
            AND pf.physical_item_sn_id = item_sn_rec.physical_item_sn_id    
            AND tf.physical_item_id = pf.physical_item_id 
            AND tf.physical_item_sn_id = pf.physical_item_sn_id
            AND tf.month_seg_date_id = pf.date_id 
            AND tf.pba_id = pf.pba_id) 
        WHEN MATCHED THEN UPDATE SET
                  pf.item_usage_type_1 = tf.usage_mb, 
                  pf.item_usage_1      = tf.usage, 
                  pf.update_by         = USER, 
                  pf.update_date       = l_now_is, 
                  pf.etl_processed_by  = ps_procedure_name; 
 
        proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
        proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;
    
-- LA - Landing auto-ratation --    

        MERGE INTO pfsawh_item_sn_p_fact pf
        USING 
              (
              SELECT 
                    physical_item_id, pba_id, physical_item_sn_id, 
                    month_seg_date_id, usage_mb,  
                    SUM(usage) as usage
                 FROM   pfsa_usage_event  
                 WHERE  (insert_date > my_lst_updt OR update_date > my_lst_updt) 
                     AND usage_mb = ('LA') 
                     AND delete_flag = 'N'  
--                     AND (insert_date > my_lst_updt OR update_date > my_lst_updt)
                 GROUP BY physical_item_id, usage_mb, pba_id, 
                     physical_item_sn_id, month_seg_date_id   
              )tf  
        ON (    pf.physical_item_id = item_sn_rec.physical_item_id 
            AND pf.physical_item_sn_id = item_sn_rec.physical_item_sn_id    
            AND tf.physical_item_id = pf.physical_item_id 
            AND tf.physical_item_sn_id = pf.physical_item_sn_id
            AND tf.month_seg_date_id = pf.date_id 
            AND tf.pba_id = pf.pba_id) 
        WHEN MATCHED THEN UPDATE SET
                  pf.item_usage_type_2 = tf.usage_mb, 
                  pf.item_usage_2      = tf.usage, 
                  pf.update_by         = USER, 
                  pf.update_date       = l_now_is, 
                  pf.etl_processed_by  = ps_procedure_name; 
              
        proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
        proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT;
    
    END LOOP;
    
    CLOSE item_sn_cur;
    
    ps_location := 'PFSA 90';            -- For std_pfsawh_debug_tbl logging. 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_recid, proc1.process_key, 
        proc1.module_num, proc1.step_num,  
        proc1.process_start_date, proc1.process_end_date, 
        proc1.process_status_code, proc1.sql_error_code, 
        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
        proc1.rec_updated_int, proc1.rec_deleted_int, 
        proc1.user_login_id, proc1.message, proc1_recid
        );

    COMMIT;

 
    l_now_is := SYSDATE; 
  
    IF l_call_error IS NULL THEN
        ls_current_process.last_run_status := 'COMPLETE';
        ls_current_process.last_run_compl  := l_now_is;
    ELSE
        ls_current_process.last_run_status := 'ERROR';
        ps_main_status                     := 'ERROR';
    END IF;
  
-- Update the status of the sub-process PFSA_EQUIP_AVAIL. 

    updt_pfsawh_processes
      (
      ps_procedure_name, ls_current_process.pfsa_process, ls_start, 
      ps_this_process.who_ran, ls_current_process.last_run_status, 
      l_now_is, ls_current_process.last_run_compl
      ); 
          
    COMMIT;
  
/*----------------------------------------------------------------------------*/  

-- Update the pfsa_process table to indicate main process has ended.  

-- Housekeeping for the end of the MAIN process 

    ps_this_process.last_run_status_time := SYSDATE; 
    ps_this_process.last_run_compl       := ps_this_process.last_run_status_time; 
  
    IF ps_main_status IS NULL THEN
        ps_main_status := 'COMPLETE';
    ELSE
        ps_main_status := 'CMPLERROR';
    END IF;
      
    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, ps_main_status,  
        ps_this_process.last_run_status_time, ps_this_process.last_run_compl
        );

    proc1.process_end_date := sysdate;
    proc1.sql_error_code := sqlcode;
    proc1.process_status_code := NVL(proc1.sql_error_code, sqlcode);
    proc1.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_pfsawh_insupd_processlog 
        (
        proc1.process_recid, proc1.process_key, 
        proc1.module_num, proc1.step_num,  
        proc1.process_start_date, proc1.process_end_date, 
        proc1.process_status_code, proc1.sql_error_code, 
        proc1.rec_read_int, proc1.rec_valid_int, proc1.rec_load_int, 
        proc1.rec_inserted_int, proc1.rec_merged_int, proc1.rec_selected_int, 
        proc1.rec_updated_int, proc1.rec_deleted_int, 
        proc1.user_login_id, proc1.message, proc1_recid
        );

    COMMIT;

    proc0.process_end_date := sysdate;
    proc0.sql_error_code := sqlcode;
    proc0.process_status_code := NVL(proc0.sql_error_code, sqlcode);
    proc0.message := sqlcode || ' - ' || sqlerrm; 
    
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
    WHEN OTHERS THEN
        ps_oerr := sqlcode; 
        ps_msg  := sqlerrm; 
        
        INSERT 
        INTO std_pfsawh_debug_tbl 
        (
        ps_procedure,      ps_oerr, ps_location, called_by, 
        ps_id_key, ps_msg, msg_dt
        )
        VALUES 
        (
        ps_procedure_name, ps_oerr, ps_location, ps_procedure_name, 
        ps_id_key, ps_msg, SYSDATE
        );
        
        COMMIT; 

END; -- end of procedure
/
