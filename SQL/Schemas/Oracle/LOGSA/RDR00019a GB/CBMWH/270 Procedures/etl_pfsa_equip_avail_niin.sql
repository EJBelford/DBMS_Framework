/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: etl_pfsa_equip_avail_niin
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 30 Sept 2008
--
--          SP Source: etl_pfsa_equip_avail_niin.sql
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
-- 30SEP08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Test script -----*/

/*

BEGIN 

    etl_pfsa_equip_avail_niin (141146, 'GBelford'); 
    
    COMMIT;  

END; 

*/ 

CREATE OR REPLACE PROCEDURE etl_pfsa_equip_avail_niin 
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )

IS

-- Exception handling variables (ps_)

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'etl_pfsa_equip_avail_niin';     /*  */
ps_location                      std_cbmwh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_cbmwh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_cbmwh_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_cbmwh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

proc0_recId                          cbmwh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */
proc1_recId                          cbmwh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 cbmwh_process_log%ROWTYPE; 
proc1                 cbmwh_process_log%ROWTYPE; 

ps_last_process       cbmwh_processes%ROWTYPE;
ps_this_process       cbmwh_processes%ROWTYPE;
ls_current_process    cbmwh_processes%ROWTYPE; 

v_etl_copy_cutoff_days        cbmwh_process_control.process_control_value%TYPE 
    := NULL; 
v_t_fact_cutoff_days          cbmwh_process_control.process_control_value%TYPE 
    := NULL; 
v_p_fact_cutoff_months        cbmwh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

cv_physical_item_id        NUMBER; 

v_niin                     VARCHAR2(9); 

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     cbmwh_process_log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
----------------------------------- START --------------------------------------

BEGIN

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_physical_item_id: ' || v_physical_item_id || ', ' || 
           'type_maintenance:   ' || type_maintenance
           );
    END IF;  
    
    cv_physical_item_id := v_physical_item_id;

    SELECT niin 
    INTO   v_niin 
    FROM   cbmwh_item_dim 
    WHERE  physical_item_id = v_physical_item_id; 

--  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 215; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    
    ps_id_key := NVL(type_maintenance, ps_procedure_name);
  
    ps_location := '00-Start';

    pr_cbmwh_InsUpd_ProcessLog (
        proc0.process_RecId, proc0.process_Key, 
        proc0.module_Num, proc0.step_Num,  
        proc0.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc0.user_Login_Id, NULL, proc0_recId
        );

    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  

/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    ps_location := 'PFSA 92';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE pfsa_equip_avail_tmp; 
        
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 
    
    ps_location := 'PFSA 94';            -- For std_pfsawh_debug_tbl logging. 
    
    INSERT 
    INTO   pfsa_equip_avail_tmp 
        (
        sys_ei_niin,      pfsa_item_id,
        record_type,      from_dt,             to_dt,
        ready_date,       day_date,            month_date,
        pfsa_org,         sys_ei_sn,           item_days,
        period_hrs,
        nmcm_hrs,       nmcs_hrs,
        nmc_hrs,        fmc_hrs,           pmc_hrs,        mc_hrs,
        nmcm_user_hrs,  nmcm_int_hrs,      nmcm_dep_hrs,
        nmcs_user_hrs,  nmcs_int_hrs,      nmcs_dep_hrs,
        pmcm_hrs,       pmcs_hrs,
        source_id,
        pmcs_user_hrs,  pmcs_int_hrs,      pmcm_user_hrs,  pmcm_int_hrs,
        dep_hrs,
        heir_id,        priority,          uic,
        grab_stamp,     proc_stamp,
        sys_ei_uid,
        status,         lst_updt,          updt_by,
        insert_by,      insert_date,
        update_by,      update_date,
        delete_flag,    delete_date,       delete_by,
        hidden_flag,    hidden_date,       hidden_by
        )
    SELECT sys_ei_niin,      pfsa_item_id,
        record_type,      from_dt,             to_dt,
        ready_date,       day_date,            month_date,
        pfsa_org,         sys_ei_sn,           item_days,
        period_hrs,
        nmcm_hrs,       nmcs_hrs,
        nmc_hrs,        fmc_hrs,           pmc_hrs,        mc_hrs,
        nmcm_user_hrs,  nmcm_int_hrs,      nmcm_dep_hrs,
        nmcs_user_hrs,  nmcs_int_hrs,      nmcs_dep_hrs,
        pmcm_hrs,       pmcs_hrs,
        source_id,
        pmcs_user_hrs,  pmcs_int_hrs,      pmcm_user_hrs,  pmcm_int_hrs,
        dep_hrs,
        heir_id,        priority,          uic,
        grab_stamp,     proc_stamp,
        sys_ei_uid,
        status,         lst_updt,          updt_by,
        insert_by,      insert_date,
        update_by,      update_date,
        delete_flag,    delete_date,       delete_by,
        hidden_flag,    hidden_date,       hidden_by
    FROM   pfsa_equip_avail@pfsaw.lidb
    WHERE sys_ei_niin = v_niin; 

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_inserted_int := NVL(proc1.rec_inserted_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 
    
    ps_location := 'PFSA 96';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE  
    INTO   pfsa_equip_avail pea 
    USING  (SELECT 
--                rec_id,           source_rec_id,       pba_id, 
--                physical_item_id, physical_item_sn_id,
--                force_unit_id,    mimosa_item_sn_id,
                sys_ei_niin,      pfsa_item_id,
                record_type,      from_dt,             to_dt,
                ready_date,       day_date,            month_date,
                pfsa_org,         sys_ei_sn,           item_days,
                period_hrs,
                nmcm_hrs,       nmcs_hrs,
                nmc_hrs,        fmc_hrs,           pmc_hrs,        mc_hrs,
                nmcm_user_hrs,  nmcm_int_hrs,      nmcm_dep_hrs,
                nmcs_user_hrs,  nmcs_int_hrs,      nmcs_dep_hrs,
                pmcm_hrs,       pmcs_hrs,
                source_id,
                pmcs_user_hrs,  pmcs_int_hrs,      pmcm_user_hrs,  pmcm_int_hrs,
                dep_hrs,
                heir_id,        priority,          uic,
                grab_stamp,     proc_stamp,
                sys_ei_uid,
                status,         lst_updt,          updt_by,
--                frz_input_date, frz_input_date_id, rec_frz_flag,   frz_date,
                insert_by,      insert_date,
                update_by,      update_date,
                delete_flag,    delete_date,       delete_by,
                hidden_flag,    hidden_date,       hidden_by
            FROM   pfsa_equip_avail_tmp ) tmp 
    ON     (pea.sys_ei_niin      = tmp.sys_ei_niin
            AND pea.pfsa_item_id = tmp.pfsa_item_id 
            AND pea.record_type  = tmp.record_type
            AND pea.from_dt      = tmp.from_dt)  
    WHEN MATCHED THEN 
        UPDATE SET   
--            pea.rec_id              = tmp.rec_id,            
--            pea.source_rec_id       = tmp.source_rec_id,        
--            pea.pba_id              = tmp.pba_id,  
--            pea.physical_item_id    = tmp.physical_item_id,  
--            pea.physical_item_sn_id = tmp.physical_item_sn_id, 
--            pea.force_unit_id       = tmp.force_unit_id,     
--            pea.mimosa_item_sn_id   = tmp.mimosa_item_sn_id, 
--            pea.sys_ei_niin         = tmp.sys_ei_niin,       
--            pea.pfsa_item_id        = tmp.pfsa_item_id, 
--            pea.record_type         = tmp.record_type,       
--            pea.from_dt             = tmp.from_dt,              
            pea.to_dt               = tmp.to_dt, 
            pea.ready_date          = tmp.ready_date,        
            pea.day_date            = tmp.day_date,             
            pea.month_date          = tmp.month_date, 
            pea.pfsa_org            = tmp.pfsa_org,          
            pea.sys_ei_sn           = tmp.sys_ei_sn,            
            pea.item_days           = tmp.item_days, 
            pea.period_hrs          = tmp.period_hrs, 
            pea.nmcm_hrs            = tmp.nmcm_hrs,        
            pea.nmcs_hrs            = tmp.nmcs_hrs, 
            pea.nmc_hrs             = tmp.nmc_hrs,         
            pea.fmc_hrs             = tmp.fmc_hrs,            
            pea.pmc_hrs             = tmp.pmc_hrs,         
            pea.mc_hrs              = tmp.mc_hrs, 
            pea.nmcm_user_hrs       = tmp.nmcm_user_hrs,   
            pea.nmcm_int_hrs        = tmp.nmcm_int_hrs,       
            pea.nmcm_dep_hrs        = tmp.nmcm_dep_hrs, 
            pea.nmcs_user_hrs       = tmp.nmcs_user_hrs,   
            pea.nmcs_int_hrs        = tmp.nmcs_int_hrs,       
            pea.nmcs_dep_hrs        = tmp.nmcs_dep_hrs, 
            pea.pmcm_hrs            = tmp.pmcm_hrs,        
            pea.pmcs_hrs            = tmp.pmcs_hrs, 
            pea.source_id           = tmp.source_id, 
            pea.pmcs_user_hrs       = tmp.pmcs_user_hrs,   
            pea.pmcs_int_hrs        = tmp.pmcs_int_hrs,       
            pea.pmcm_user_hrs       = tmp.pmcm_user_hrs,   
            pea.pmcm_int_hrs        = tmp.pmcm_int_hrs, 
            pea.dep_hrs             = tmp.dep_hrs, 
            pea.heir_id             = tmp.heir_id,         
            pea.priority            = tmp.priority,           
            pea.uic                 = tmp.uic, 
            pea.grab_stamp          = tmp.grab_stamp,      
            pea.proc_stamp          = tmp.proc_stamp, 
            pea.sys_ei_uid          = tmp.sys_ei_uid, 
            pea.status              = tmp.status,          
            pea.lst_updt            = tmp.lst_updt,           
            pea.updt_by             = tmp.updt_by, 
--            pea.frz_input_date      = tmp.frz_input_date,  
--            pea.frz_input_date_id   = tmp.frz_input_date_id,  
--            pea.rec_frz_flag        = tmp.rec_frz_flag,   
--            pea.frz_date            = tmp.frz_date, 
            pea.insert_by           = tmp.insert_by,       
            pea.insert_date         = tmp.insert_date, 
            pea.update_by           = tmp.update_by,       
            pea.update_date         = tmp.update_date, 
            pea.delete_flag         = tmp.delete_flag,     
            pea.delete_date         = tmp.delete_date,        
            pea.delete_by           = tmp.delete_by, 
            pea.hidden_flag         = tmp.hidden_flag,     
            pea.hidden_date         = tmp.hidden_date,        
            pea.hidden_by           = tmp.hidden_by              
    WHEN NOT MATCHED THEN 
        INSERT (
--                pea.rec_id,           pea.source_rec_id,       pea.pba_id, 
--                pea.physical_item_id, pea.physical_item_sn_id,
--                pea.force_unit_id,    pea.mimosa_item_sn_id,
                pea.sys_ei_niin,      pea.pfsa_item_id,
                pea.record_type,      pea.from_dt,             pea.to_dt,
                pea.ready_date,       pea.day_date,            pea.month_date,
                pea.pfsa_org,         pea.sys_ei_sn,           pea.item_days,
                pea.period_hrs,
                pea.nmcm_hrs,       pea.nmcs_hrs,
                pea.nmc_hrs,        pea.fmc_hrs,           
                pea.pmc_hrs,        pea.mc_hrs,
                pea.nmcm_user_hrs,  pea.nmcm_int_hrs,      pea.nmcm_dep_hrs,
                pea.nmcs_user_hrs,  pea.nmcs_int_hrs,      pea.nmcs_dep_hrs,
                pea.pmcm_hrs,       pea.pmcs_hrs,
                pea.source_id,
                pea.pmcs_user_hrs,  pea.pmcs_int_hrs,      
                pea.pmcm_user_hrs,  pea.pmcm_int_hrs,
                pea.dep_hrs,
                pea.heir_id,        pea.priority,          pea.uic,
                pea.grab_stamp,     pea.proc_stamp,
                pea.sys_ei_uid,
                pea.status,         pea.lst_updt,          pea.updt_by,
--                pea.frz_input_date, pea.frz_input_date_id, pea.rec_frz_flag,   pea.frz_date,
                pea.insert_by,      pea.insert_date,
                pea.update_by,      pea.update_date,
                pea.delete_flag,    pea.delete_date,       pea.delete_by,
                pea.hidden_flag,    pea.hidden_date,       pea.hidden_by)
        VALUES (
--                tmp.rec_id,           tmp.source_rec_id,       tmp.pba_id, 
--                tmp.physical_item_id, tmp.physical_item_sn_id,
--                tmp.force_unit_id,    tmp.mimosa_item_sn_id,
                tmp.sys_ei_niin,      tmp.pfsa_item_id,
                tmp.record_type,      tmp.from_dt,             tmp.to_dt,
                tmp.ready_date,       tmp.day_date,            tmp.month_date,
                tmp.pfsa_org,         tmp.sys_ei_sn,           tmp.item_days,
                tmp.period_hrs,
                tmp.nmcm_hrs,       tmp.nmcs_hrs,
                tmp.nmc_hrs,        tmp.fmc_hrs,           
                tmp.pmc_hrs,        tmp.mc_hrs,
                tmp.nmcm_user_hrs,  tmp.nmcm_int_hrs,      tmp.nmcm_dep_hrs,
                tmp.nmcs_user_hrs,  tmp.nmcs_int_hrs,      tmp.nmcs_dep_hrs,
                tmp.pmcm_hrs,       tmp.pmcs_hrs,
                tmp.source_id,
                tmp.pmcs_user_hrs,  tmp.pmcs_int_hrs,      
                tmp.pmcm_user_hrs,  tmp.pmcm_int_hrs,
                tmp.dep_hrs,
                tmp.heir_id,        tmp.priority,          tmp.uic,
                tmp.grab_stamp,     tmp.proc_stamp,
                tmp.sys_ei_uid,
                tmp.status,         tmp.lst_updt,          tmp.updt_by,
--                tmp.frz_input_date, tmp.frz_input_date_id, tmp.rec_frz_flag,   tmp.frz_date,
                tmp.insert_by,      tmp.insert_date,
                tmp.update_by,      tmp.update_date,
                tmp.delete_flag,    tmp.delete_date,       tmp.delete_by,
                tmp.hidden_flag,    tmp.hidden_date,       tmp.hidden_by);

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;
    proc1.rec_merged_int := NVL(proc1.rec_merged_int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 
    
-- Set warehouse ids    

    ps_location := 'PFSA 97';            -- For std_pfsawh_debug_tbl logging. 
    
-- ITEM 

    UPDATE pfsa_equip_avail pue
    SET    physical_item_id = 
            (
            SELECT NVL(physical_item_id, 0)  
            FROM   cbmwh_item_dim 
            WHERE  niin = pue.sys_ei_niin
--                AND status = 'C'
            )  
    WHERE pue.physical_item_id IS NULL
        OR pue.physical_item_id < 1; 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- ITEM_SN  

    UPDATE pfsa_equip_avail pue
    SET    physical_item_sn_id = 
            (
            SELECT physical_item_sn_id 
            FROM   cbmwh_item_sn_dim 
            WHERE  item_niin = pue.sys_ei_niin 
                AND item_serial_number = pue.sys_ei_sn 
            )
    WHERE  pue.physical_item_sn_id IS NULL
        OR pue.physical_item_sn_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;

-- FORCE 

    UPDATE pfsa_equip_avail pue
    SET    force_unit_id = 
            (
            SELECT NVL(force_unit_id, -1)  
            FROM   cbmwh_force_unit_dim 
            WHERE  uic = pue.uic 
                AND status = 'C'
            )
    WHERE  force_unit_id IS NULL 
        OR force_unit_id < 1; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

-- LOCATION     

-- MIMOSA      

    UPDATE pfsa_equip_avail 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_sn_id >= 0 
        AND (mimosa_item_sn_id IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    ps_location := 'PFSA 98';            -- For std_pfsawh_debug_tbl logging. 
    
-- PBA_ID 

    UPDATE pfsa_equip_avail sn
    SET    pba_id = (
                    SELECT NVL(ref.pba_id, 1000000)
                    FROM   pfsawh.pfsa_pba_items_ref ref
                    WHERE  ref.item_identifier_type_id = 13 
                        AND ref.pba_id > 1000007 
                        AND sn.physical_item_id = ref.physical_item_id 
                    )
    WHERE sn.pba_id = 1000000 
        OR sn.pba_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

--    pr_upd_pfsa_fsc_sys_dates (ps_this_process.who_ran, 'EQUIP_AVAIL_PERIOD_DATE'); 
    
    COMMIT; 

    ps_location := 'PFSA 99';            -- For std_pfsawh_debug_tbl logging. 
    
    DELETE pfsa_equip_avail_tmp; 
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + SQL%ROWCOUNT;
    proc1.rec_deleted_int := NVL(proc1.rec_deleted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
--    UPDATE cbmwh_item_sn_p_fact pf
--    SET    item_days = NULL,
--           period_hrs = NULL,
--           mc_hrs = NULL,
--           fmc_hrs = NULL,
--           pmc_hrs = NULL,
--           pmcm_hrs = NULL,
--           pmcs_hrs = NULL,
--           nmc_hrs = NULL,
--           nmcm_hrs = NULL,
--           nmcm_user_hrs = NULL,
--           nmcm_int_hrs = NULL,
--           nmcm_dep_hrs = NULL,
--           nmcs_hrs = NULL,
--           nmcs_user_hrs = NULL,
--           nmcs_int_hrs = NULL,
--           nmcs_dep_hrs = NULL
--    WHERE pf.physical_item_sn_id = 91646; 
    
    UPDATE cbmwh_item_sn_p_fact pf
    SET    (   
            item_days,
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
            nmcs_dep_hrs
            ) = ( 
            SELECT   SUM(item_days),
                SUM(period_hrs),
                SUM(mc_hrs),
                SUM(fmc_hrs),
                SUM(pmc_hrs),
                SUM(pmcm_hrs),
                SUM(pmcs_hrs),
                SUM(nmc_hrs),
                SUM(nmcm_hrs),
                SUM(nmcm_user_hrs),
                SUM(nmcm_int_hrs),
                SUM(nmcm_dep_hrs),
                SUM(nmcs_hrs),
                SUM(nmcs_user_hrs),
                SUM(nmcs_int_hrs),
                SUM(nmcs_dep_hrs)
            FROM   pfsa_equip_avail pea 
            WHERE  pea.physical_item_sn_id = pf.physical_item_sn_id  
                AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
                AND pea.physical_item_sn_id IS NOT NULL  
                AND pea.force_unit_id IS NOT NULL
            GROUP BY pea.physical_item_id, pea.physical_item_sn_id, pea.ready_date
                ) 
    WHERE pf.physical_item_id = v_physical_item_id; 
    
--    SELECT * 
--    FROM cbmwh_item_sn_p_fact pf 
--    WHERE pf.physical_item_id = 141146
--    ORDER BY mc_hrs DESC;

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    proc1.rec_updated_int := NVL(proc1.rec_updated_int, 0) + SQL%ROWCOUNT;

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

    proc0.process_end_date := sysdate;
    proc0.sql_error_code := sqlcode;
    proc0.process_status_code := NVL(proc0.sql_error_code, sqlcode);
    proc0.message := sqlcode || ' - ' || sqlerrm; 
    
    pr_cbmwh_insupd_processlog 
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
            ps_oerr := sqlcode; 
            ps_msg  := sqlerrm; 
            
            INSERT 
            INTO std_cbmwh_debug_tbl 
            (
            ps_procedure,      ps_oerr, ps_location, called_by, 
            ps_id_key, ps_msg, msg_dt
            )
            VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, NULL, 
            ps_id_key, ps_msg, SYSDATE
            );
            
END etl_pfsa_equip_avail_niin;

/

