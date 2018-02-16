CREATE OR REPLACE PROCEDURE etl_pfsa_usage_event_frz_niin 
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS
/************ TEAM ITSS********************************************************


       NAME:    etl_pfsa_usage_event_frz_niin 

    PURPOSE:    To get the freeze usage event data for the passed 
                PHYSICAL_ITEM _ID from the PSFA tables on lidb, resolve the 
                normal identifiers to the warehouse dimension ids then sums and load the 
                facts in the PFSAWH_ITEM_SN_P_FACT.


 PARAMETERS:   See procedure definition

      INPUT:   See procedure definition

     OUTPUT:   See procedure definition

ASSUMPTIONS:  That the fact records for the PHYSICL_ITEM_ID and time period 
              exist in the PFSAWH_ITEM_SN_P_FACT. 

LIMITATIONS:  Expects valid PHYSICAL_ITEM_ID 

      NOTES:

  
  Date     ECP #                 Author           Description
---------  ---------------       ---------------  -----------------------------
24 Nov 08  EECP03680-CPTSK09335  jean             Procedure Created
03 Dec 08                        G. Belford       Removed the date limit on the 
                                                    select since this is a NIIN 
                                                    reload. 




************* TEAM ITSS *******************************************************/

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_PFSA_USAGE_EVENT_NIIN';  /*  */
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

l_ps_start                       DATE          := sysdate;

proc0_recId                          pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 pfsawh_process_log%ROWTYPE; 

ps_last_process       pfsawh_processes%ROWTYPE;
ps_this_process       pfsawh_processes%ROWTYPE;

v_etl_copy_cutoff_days        pfsawh_process_control.process_control_value%TYPE 
    := NULL; 

-- module variables (v_)

v_debug                    NUMBER 
    := 0;   -- Controls debug options (0 -Off)

cv_physical_item_id        pfsawh_item_dim.physical_item_id%TYPE; 

v_niin                     pfsawh_item_dim.niin%TYPE; 
v_item_nomen_standard      pfsawh_item_dim.item_nomen_standard%TYPE; 

-- add  by lmj 10/10/08 variables to manaage truncation and index control --

myrowcount              NUMBER;
mytablename             VARCHAR2(32);


my_lst_updt             DATE := null;
my_insert_dt            DATE := null;
my_update_dt            DATE := null;

 BEGIN 

    ps_location := 'PFSA 00';            -- For std_pfsawh_debug_tbl logging. 

    -- Get the process control values from pfsawh_PROCESS_CONTROL. 
    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');
        
    cv_physical_item_id := v_physical_item_id;

    ps_id_key := nvl(type_maintenance, ps_procedure_name);

    SELECT  niin,   item_nomen_standard 
    INTO    v_niin, v_item_nomen_standard  
    FROM    pfsawh_item_dim    
    WHERE   physical_item_id = cv_physical_item_id;

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_etl_copy_cutoff_days: ' || v_etl_copy_cutoff_days 
           );
    END IF;  

    proc0.process_RecId      := 720; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    proc0.message            := cv_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
  
    pr_pfsawh_insupd_processlog 
        (
        proc0.process_RecId, proc0.process_Key, 
        proc0.module_Num, proc0.step_Num,  
        proc0.process_Start_Date, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, 
        proc0.user_Login_Id, proc0.message, proc0_recId
        );  
                
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE
           ( 
           'proc0_recId: ' || proc0_recId || ', ' || 
           proc0.process_RecId || ', ' || proc0.process_Key
           );
    END IF;  


    -- Housekeeping for the process 
  

    -- get the run criteria from the pfsa_processes table for the last run of this 
    -- main process 
      get_pfsawh_process_info ( 
        ps_procedure_name, ps_procedure_name, ps_last_process.last_run, 
        ps_last_process.who_ran, ps_last_process.last_run_status, 
        ps_last_process.last_run_status_time, ps_last_process.last_run_compl
        );

    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_compl       := ps_last_process.last_run_compl;

    -- Update the PFSA_PROCESSES table to indicate MAIN process began.  

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, 'BEGAN', 
        SYSDATE, ps_this_process.last_run_compl
        );
      
    COMMIT;    
 
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
    ps_location := 'PFSA 10';            -- For std_pfsawh_debug_tbl logging. 

/*
    added by lmj 10/10/08 for truncation of tables rather than delete for 
    increase in performance with each transaction set wrapped with delete
    calls as designed should reduce overhead cost and cycles.

*/
 
    -- Limit the data pull from LIDB.PFSAW to x number of days/months. 

    select max(insert_date) into my_insert_dt from frz_pfsa_usage_event;
    select max(update_date) into my_update_dt from frz_pfsa_usage_event;
    
    if (my_insert_dt is null) or (my_update_dt is null) then
       my_lst_updt := add_months (sysdate, -30);
    elsif my_insert_dt > my_update_dt then
      my_lst_updt := my_update_dt;
    else
      my_lst_updt := my_insert_dt;
    end if;
    
    my_lst_updt := my_lst_updt - v_etl_copy_cutoff_days;
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_usage_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_usage_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;

    INSERT 
    INTO   frz_pfsa_usage_event_tmp
        (
        rec_id,           source_rec_id,       pba_id, 
        physical_item_id, physical_item_sn_id,
        force_unit_id,    mimosa_item_sn_id,
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag,  
        frz_input_date, 
        frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by,
        active_flag, active_date, inactive_date
        )
    SELECT 
        ue.rec_id,           ue.source_rec_id,       ue.pba_id, 
        cv_physical_item_id, ue.physical_item_sn_id,
        ue.force_unit_id,    ue.mimosa_item_sn_id,
        ue.sys_ei_niin, ue.pfsa_item_id, ue.record_type, ue.usage_mb, ue.from_dt, 
        ue.usage, ue.type_usage, ue.to_dt, ue.usage_date, ue.ready_date, 
        ue.day_date, ue.month_date, ue.pfsa_org, ue.uic, ue.sys_ei_sn, 
        ue.item_days, ue.data_src, ue.genind, ue.lst_updt, ue.updt_by, 
        ue.status, ue.reading, ue.reported_usage, ue.actual_mb, ue.actual_reading, 
        ue.actual_usage, ue.actual_data_rec_flag,
        ue.frz_input_date, 
        ue.frz_input_date_id, ue.rec_frz_flag, ue.frz_date,
        ue.insert_by, 
        ue.insert_date, ue.update_by, ue.update_date, ue.delete_flag, ue.delete_date, 
        ue.hidden_flag, ue.hidden_date, ue.delete_by, ue.hidden_by,
        ue.active_flag, ue.active_date, ue.inactive_date        
    FROM   frz_pfsa_usage_event@pfsaw.lidb ue 
    WHERE ue.sys_ei_niin = v_niin
-- 03Dec08 - G. Belford - Removed the date limit on the select since this 
--                          is a NIIN reload. 
--       AND (insert_date > my_lst_updt or update_date > my_lst_updt) 
       AND delete_flag = 'N'
       AND hidden_flag = 'N';
 
 
    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    --  Set warehouse ids  
    -- ITEM_SN     

    UPDATE frz_pfsa_usage_event_tmp pue
    SET    physical_item_sn_id = 
            NVL((
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  physical_item_id = pue.physical_item_id 
                AND item_serial_number = pue.sys_ei_sn 
            ), -1)
    WHERE  pue.physical_item_id = cv_physical_item_id
       AND (   pue.physical_item_sn_id IS NULL 
            OR pue.physical_item_sn_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    
    -- FORCE 

    UPDATE frz_pfsa_usage_event_tmp pue
    SET    force_unit_id = 
            NVL((
            SELECT force_unit_id  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic = pue.uic 
                AND status = 'C'
            ), -1)
    WHERE  pue.physical_item_id  = cv_physical_item_id
       AND (   pue.force_unit_id IS NULL 
            OR pue.force_unit_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- LOCATION     
         -- not implemented at this time 7 Nov 2008 

    -- FRZ_INPUT_DATE_ID    

    UPDATE frz_pfsa_usage_event_tmp pue 
    SET    frz_input_date_id = fn_date_to_date_id(pue.frz_input_date) 
    WHERE  pue.PHYSICAL_ITEM_ID = cv_physical_item_id  
       AND frz_input_date_id IS NULL; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- MIMOSA      

    UPDATE frz_pfsa_usage_event_tmp 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE   physical_item_id = cv_physical_item_id
        AND physical_item_sn_id >= 0 
        AND (   mimosa_item_sn_id IS NULL 
             OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- FROM_DT_ID 

    UPDATE frz_pfsa_usage_event_tmp pue
    SET    from_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  ref.oracle_date = pue.from_dt 
                    )
    WHERE  pue.physical_item_id = cv_physical_item_id
       AND pue.from_dt_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- TO_DT_ID 

    UPDATE frz_pfsa_usage_event_tmp pue
    SET    to_dt_id = (
                    SELECT ref.date_dim_id
                    FROM   date_dim ref
                    WHERE  TO_CHAR(to_dt, 'DD-MON-YYYY') = ref.oracle_date 
                    )
    WHERE  pue.physical_item_id = cv_physical_item_id
       AND pue.to_dt_id IS NULL; 
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- Set MONTH_SEG_DATE_ID 

    UPDATE frz_pfsa_usage_event_tmp 
    SET    month_seg_date_id = 
               fn_date_to_date_id (
               CASE WHEN TO_CHAR(fn_date_id_to_date(from_dt_id), 'DD') < 16 THEN
                   TO_DATE('01' || TO_CHAR(fn_date_id_to_date(from_dt_id), 'MON-YYYY'), 'DD-MON-YYYY') 
               ELSE 
                   TO_DATE('16' || TO_CHAR(fn_date_id_to_date(from_dt_id), 'MON-YYYY'), 'DD-MON-YYYY') 
               END )
    WHERE  physical_item_id = cv_physical_item_id
       AND month_seg_date_id IS NULL;
    
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
 
    ps_location := 'PFSA 20';            -- For std_pfsawh_debug_tbl logging. 
    
    MERGE   
    INTO frz_pfsa_usage_event pue 
    USING ( 
        SELECT
        rec_id,           source_rec_id,       pba_id, 
        physical_item_id, physical_item_sn_id,
        force_unit_id,    mimosa_item_sn_id,
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt,
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date,
        month_date,
        pfsa_org,
        uic,
        sys_ei_sn,
        item_days,
        data_src,
        genind,
        lst_updt,
        updt_by,
        status,
        reading,
        reported_usage,
        actual_mb,
        actual_reading,
        actual_usage, actual_data_rec_flag,
        frz_input_date,
        frz_input_date_id, rec_frz_flag, frz_date, 
        insert_by,
        insert_date, update_by, update_date, delete_flag, delete_date,
        hidden_flag, hidden_date, delete_by, hidden_by,
        active_flag, active_date, inactive_date,
        from_dt_tm_id, to_dt_tm_id, crc_value,
        from_dt_id, to_dt_id, month_seg_date_id 
        FROM frz_pfsa_usage_event_tmp) tmp
    ON (tmp.physical_item_id = cv_physical_item_id 
        AND pue.rec_id = tmp.rec_id 
        )
    WHEN MATCHED THEN
    UPDATE SET 
        pue.source_rec_id        = tmp.source_rec_id,       
        pue.pba_id               = tmp.pba_id, 
        pue.physical_item_sn_id  = tmp.physical_item_sn_id,
        pue.force_unit_id        = tmp.force_unit_id,    
        pue.mimosa_item_sn_id    = tmp.mimosa_item_sn_id,
        pue.sys_ei_niin          = tmp.sys_ei_niin, 
        pue.pfsa_item_id         = tmp.pfsa_item_id,  
        pue.record_type          = tmp.record_type, 
        pue.usage_mb             = tmp.usage_mb, 
        pue.from_dt              = tmp.from_dt,
        pue.usage                = tmp.usage,
        pue.type_usage           = tmp.type_usage,
        pue.to_dt                = tmp.to_dt,
        pue.usage_date           = tmp.usage_date,
        pue.ready_date           = tmp.ready_date,
        pue.day_date             = tmp.day_date,
        pue.month_date           = tmp.month_date,
        pue.pfsa_org             = tmp.pfsa_org,
        pue.uic                  = tmp.uic,
        pue.sys_ei_sn            = tmp.sys_ei_sn,
        pue.item_days            = tmp.item_days,
        pue.data_src             = tmp.data_src,
        pue.genind               = tmp.genind,
        pue.lst_updt             = tmp.lst_updt,
        pue.updt_by              = tmp.updt_by,
        pue.status               = tmp.status,
        pue.reading              = tmp.reading,
        pue.reported_usage       = tmp.reported_usage,
        pue.actual_mb            = tmp.actual_mb,
        pue.actual_reading       = tmp.actual_reading,
        pue.actual_usage         = tmp.actual_usage,
        pue.actual_data_rec_flag = tmp.actual_data_rec_flag,
        pue.frz_input_date       = tmp.frz_input_date,
        pue.frz_input_date_id    = tmp.frz_input_date_id,
        pue.rec_frz_flag         = tmp.rec_frz_flag, 
        pue.frz_date             = tmp.frz_date,
        pue.insert_by            = tmp.insert_by,
        pue.insert_date          = tmp.insert_date,
        pue.update_by            = tmp.update_by,
        pue.update_date          = tmp.update_date,
        pue.delete_flag          = tmp.delete_flag,
        pue.delete_date          = tmp.delete_date,
        pue.hidden_flag          = tmp.hidden_flag,
        pue.hidden_date          = tmp.hidden_date,
        pue.delete_by            = tmp.delete_by,
        pue.hidden_by            = tmp.hidden_by,   
        pue.active_flag          = tmp.active_flag, 
        pue.active_date          = tmp.active_date, 
        pue.inactive_date        = tmp.inactive_date,
        pue.from_dt_tm_id        = tmp.from_dt_tm_id, 
        pue.to_dt_tm_id          = tmp.to_dt_tm_id, 
        pue.crc_value            = tmp.crc_value,
        pue.from_dt_id           = tmp.from_dt_id, 
        pue.to_dt_id             = tmp.to_dt_id, 
        pue.month_seg_date_id    = tmp.month_seg_date_id 
    WHEN NOT MATCHED THEN 
    INSERT 
        (
        rec_id,           source_rec_id,       pba_id, 
        physical_item_id, physical_item_sn_id,
        force_unit_id,    mimosa_item_sn_id,
        sys_ei_niin, pfsa_item_id, record_type, usage_mb, from_dt, 
        usage, type_usage, to_dt, usage_date, ready_date, 
        day_date, month_date, pfsa_org, uic, sys_ei_sn, 
        item_days, data_src, genind, lst_updt, updt_by, 
        status, reading, reported_usage, actual_mb, actual_reading, 
        actual_usage, actual_data_rec_flag, frz_input_date, 
        frz_input_date_id, rec_frz_flag, frz_date,
        insert_by, 
        insert_date, update_by, update_date, delete_flag, delete_date, 
        hidden_flag, hidden_date, delete_by, hidden_by,
        active_flag, active_date, inactive_date,
        from_dt_tm_id, to_dt_tm_id, crc_value,
        from_dt_id, to_dt_id, month_seg_date_id 
        )
    VALUES 
        (
        tmp.rec_id,           tmp.source_rec_id,       tmp.pba_id, 
        tmp.physical_item_id, tmp.physical_item_sn_id,
        tmp.force_unit_id,    tmp.mimosa_item_sn_id,
        tmp.sys_ei_niin, tmp.pfsa_item_id, tmp.record_type, tmp.usage_mb, tmp.from_dt, 
        tmp.usage, tmp.type_usage, tmp.to_dt, tmp.usage_date, tmp.ready_date, 
        tmp.day_date, tmp.month_date, tmp.pfsa_org, tmp.uic, tmp.sys_ei_sn, 
        tmp.item_days, tmp.data_src, tmp.genind, tmp.lst_updt, tmp.updt_by, 
        tmp.status, tmp.reading, tmp.reported_usage, tmp.actual_mb, tmp.actual_reading, 
        tmp.actual_usage, tmp.actual_data_rec_flag, tmp.frz_input_date, 
        tmp.frz_input_date_id, tmp.rec_frz_flag, tmp.frz_date, 
        tmp.insert_by, 
        tmp.insert_date, tmp.update_by, tmp.update_date, tmp.delete_flag, tmp.delete_date, 
        tmp.hidden_flag, tmp.hidden_date, tmp.delete_by, tmp.hidden_by, 
        tmp.active_flag, tmp.active_date, tmp.inactive_date,
        tmp.from_dt_tm_id, tmp.to_dt_tm_id, tmp.crc_value,
        tmp.from_dt_id, tmp.to_dt_id, tmp.month_seg_date_id 
        );
        
    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT; 

    ps_location := 'PFSA 30';            -- For std_pfsawh_debug_tbl logging. 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_usage_event_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_usage_event_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
    
    COMMIT; 
    
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                               Populate  period facts                       */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 
     
    ps_location := 'PFSA 70';            -- For std_pfsawh_debug_tbl logging. 
    
    -- Insert the new facts within the cutoff window.  

    -- M - Miles 

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   frz_pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('M')   
             GROUP BY physical_item_id, usage_mb, pba_id, physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_0 = tf.usage_mb, 
              pf.item_usage_0      = tf.usage;    

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- H - Hours 

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   frz_pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('H')   
             GROUP BY physical_item_id, usage_mb, pba_id, physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_1 = tf.usage_mb, 
              pf.item_usage_1      = tf.usage; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    
    -- F - Flight hours     

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   frz_pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('F')   
             GROUP BY physical_item_id, usage_mb, pba_id, physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_0 = tf.usage_mb, 
              pf.item_usage_0      = tf.usage; 
              
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    
    -- L - Landings     

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   frz_pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('L')   
             GROUP BY physical_item_id, usage_mb, pba_id, physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_1 = tf.usage_mb, 
              pf.item_usage_1      = tf.usage; 
 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    
    -- LA - Landing auto-ratation --    

    MERGE INTO pfsawh_item_sn_p_fact pf
    USING 
          (
          SELECT 
                physical_item_id, pba_id, physical_item_sn_id, month_seg_date_id, usage_mb,  
                SUM(usage) as usage
             FROM   frz_pfsa_usage_event  
             WHERE   physical_item_id = cv_physical_item_id
                 AND usage_mb = ('LA')   
             GROUP BY physical_item_id, usage_mb, pba_id, physical_item_sn_id, month_seg_date_id 
          )tf  
    ON (    tf.physical_item_id = pf.physical_item_id
        AND tf.physical_item_id = pf.physical_item_id 
        AND tf.physical_item_sn_id = pf.physical_item_sn_id
        AND tf.month_seg_date_id = pf.date_id 
        AND tf.pba_id = pf.pba_id) 
    WHEN MATCHED THEN UPDATE SET
              pf.item_usage_type_2 = tf.usage_mb, 
              pf.item_usage_2      = tf.usage; 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT;   

/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
    ps_location := 'PFSA 70';            -- For std_pfsawh_debug_tbl logging. 
  
    proc0.process_end_date := sysdate;
    proc0.sql_error_code := sqlcode;
    proc0.process_status_code := NVL(proc0.sql_error_code, sqlcode);
    proc0.message := proc0.message || ' - ' || sqlcode || ' - ' || sqlerrm; 
    
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


-- Update the pfsa_process table to indicate main process has ended.  
-- Housekeeping for the end of the MAIN process 
    updt_pfsawh_processes
        (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run, 
        ps_this_process.who_ran, 'COMPLETE',  
        SYSDATE, SYSDATE
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
        ps_procedure_name, ps_oerr, ps_location, NULL, 
        ps_id_key, ps_msg, SYSDATE
        );
        
        COMMIT; 

END etl_pfsa_usage_event_frz_niin; -- end of procedure
/
