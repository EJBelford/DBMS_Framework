CREATE OR REPLACE PROCEDURE ETL_PFSA_EQUIP_AVAIL_FRZ_NIIN 
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )

IS
/************ TEAM ITSS********************************************************


       NAME:    ETL_PFSA_EQUIP_AVAIL_FRZ_NIIN 

    PURPOSE:    To get the freeze equipment available data for the passed 
                PHYSICAL_ITEM _ID from the PSFA tables on lidb, resolve the 
                normal identifiers to the warehouse dimension ids then sums and loads the 
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

/* 
 
BEGIN 

    etl_pfsa_equip_avail_frz_niin(141223, 'GBelford');  
    
    COMMIT;       

END; 

*/ 

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'ETL_PFSA_EQUIP_AVAIL_FRZ_NIIN';     /*  */
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
        
----------------------------------- START --------------------------------------

BEGIN

-- GB - 24NOV08 - Max of ps_location is 10 characters. 

    ps_location := 'PFSAWH 00';

    v_etl_copy_cutoff_days := fn_pfsawh_get_prcss_cntrl_val('v_etl_copy_cutoff_days');

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

    ps_id_key := NVL(type_maintenance, ps_procedure_name);

    SELECT  niin,   item_nomen_standard 
    INTO    v_niin, v_item_nomen_standard  
    FROM    pfsawh_item_dim    
    WHERE   physical_item_id = cv_physical_item_id;

    --  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 715; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    proc0.message            := cv_physical_item_id || '-' || 
                                v_niin || '-' || 
                                v_item_nomen_standard;
    
  

    pr_pfsawh_InsUpd_ProcessLog (
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
        ps_this_process.who_ran, 'BEGIN', 
        SYSDATE, ps_this_process.last_run_compl
        );
      
    COMMIT;
  
/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 
 
    ps_location := 'PFSA 40';            -- For std_pfsawh_debug_tbl logging. 
    
/*
    added by lmj 10/10/08 for truncation of tables rather than delete for 
    increase in performance with each transaction set wrapped with delete
    calls as designed should reduce overhead cost and cycles.
*/
 --add in max lst_updt compare lmj 05nov08   
        
    select max(insert_date) into my_insert_dt from frz_pfsa_equip_avail;
    select max(update_date) into my_update_dt from frz_pfsa_equip_avail;
    
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
    FROM   frz_pfsa_equip_avail_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_equip_avail_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;

    ps_location := 'PFSA 42';            -- For std_pfsawh_debug_tbl logging. 
    
    INSERT 
    INTO   frz_pfsa_equip_avail_tmp 
        (
        rec_id,             source_rec_id,         pba_id, 
        physical_item_id,   physical_item_sn_id,
        force_unit_id,      mimosa_item_sn_id,
        sys_ei_niin,        pfsa_item_id,
        record_type,        from_dt,               to_dt,
        ready_date,         day_date,              month_date,
        pfsa_org,           sys_ei_sn,             item_days,
        period_hrs,
        nmcm_hrs,           nmcs_hrs,
        nmc_hrs,            fmc_hrs,               pmc_hrs,        mc_hrs,
        nmcm_user_hrs,      nmcm_int_hrs,          nmcm_dep_hrs,
        nmcs_user_hrs,      nmcs_int_hrs,          nmcs_dep_hrs,
        pmcm_hrs,           pmcs_hrs,              source_id,
        pmcs_user_hrs,      pmcs_int_hrs,          pmcm_user_hrs,  pmcm_int_hrs,
        dep_hrs,            heir_id,               priority,       uic,
        grab_stamp,         proc_stamp,            sys_ei_uid,
        status,             lst_updt,              updt_by,
        frz_input_date,     frz_input_date_id,     rec_frz_flag,   frz_date, 
        insert_by,          insert_date,
        update_by,          update_date,
        delete_flag,        delete_date,           delete_by,
        hidden_flag,        hidden_date,           hidden_by,
        active_flag,        active_date,           inactive_date, 
        ridb_on_time_flag,  readiness_reported_qty 
        )
    SELECT 
        rec_id,                source_rec_id,       pba_id, 
        cv_physical_item_id,   physical_item_sn_id,
        force_unit_id,         mimosa_item_sn_id,
        sys_ei_niin,           pfsa_item_id,
        record_type,           from_dt,             to_dt,
        ready_date,            day_date,            month_date,
        pfsa_org,              sys_ei_sn,           item_days,
        period_hrs,
        nmcm_hrs,              nmcs_hrs,
        nmc_hrs,               fmc_hrs,             pmc_hrs,        mc_hrs,
        nmcm_user_hrs,         nmcm_int_hrs,        nmcm_dep_hrs,
        nmcs_user_hrs,         nmcs_int_hrs,        nmcs_dep_hrs,
        pmcm_hrs,              pmcs_hrs,
        source_id,
        pmcs_user_hrs,         pmcs_int_hrs,        pmcm_user_hrs,  pmcm_int_hrs,
        dep_hrs,
        heir_id,               priority,            uic,
        grab_stamp,            proc_stamp,          sys_ei_uid,
        status,                lst_updt,            updt_by,
        frz_input_date,        frz_input_date_id,   rec_frz_flag,   frz_date, 
        insert_by,             insert_date,
        update_by,             update_date,
        delete_flag,           delete_date,         delete_by,
        hidden_flag,           hidden_date,         hidden_by, 
        active_flag,           active_date,         inactive_date,
        ridb_on_time_flag,     ROUND(item_days / (to_dt - from_dt)) 
    FROM   frz_pfsa_equip_avail@pfsaw.lidb
    WHERE  sys_ei_niin = v_niin 
-- 03Dec08 - G. Belford - Removed the date limit on the select since this 
--                          is a NIIN reload. 
--       AND (insert_date > my_lst_updt or update_date > my_lst_updt) 
       AND delete_flag = 'N'
       AND hidden_flag = 'N';

    proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;    

    COMMIT; 
    
    ps_location := 'PFSA 44';            -- For std_pfsawh_debug_tbl logging. 
    

    -- Set warehouse ids    
    -- ITEM_SN  

    UPDATE frz_pfsa_equip_avail_tmp pea
    SET    physical_item_sn_id = 
            NVL((
            SELECT physical_item_sn_id 
            FROM   pfsawh_item_sn_dim 
            WHERE  physical_item_id   = pea.physical_item_id 
               AND item_serial_number = pea.sys_ei_sn
               AND status             = 'C'
                 
            ), -1)
    WHERE  pea.physical_item_id        = cv_physical_item_id
       AND (   pea.physical_item_sn_id IS NULL
            OR pea.physical_item_sn_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- FORCE 

    UPDATE frz_pfsa_equip_avail_tmp pea
    SET    force_unit_id = 
            NVL((
            SELECT force_unit_id  
            FROM   pfsawh_force_unit_dim 
            WHERE  uic     = pea.uic 
               AND status  = 'C'
            ), -1)
    WHERE  pea.physical_item_id  = cv_physical_item_id
       AND (   pea.force_unit_id IS NULL 
            OR pea.force_unit_id < 1); 

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    -- LOCATION     
        -- not implemented at this time 7 Nov 2008 
    
    ps_location := 'PFSA 46';            -- For std_pfsawh_debug_tbl logging. 
    
   -- MIMOSA      

    UPDATE frz_pfsa_equip_avail_tmp 
    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id, 'XXXXXXX')), 8, '0') 
    WHERE  physical_item_id    = cv_physical_item_id
       AND physical_item_sn_id >= 0 
       AND (mimosa_item_sn_id  IS NULL OR mimosa_item_sn_id = '00000000'); 
        
    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
        
    -- Ready Date      

    UPDATE frz_pfsa_equip_avail_tmp pea
    SET    ready_date_id = fn_date_to_date_id(pea.ready_date) 
    WHERE  ready_date_id   IS NULL
       AND pea.physical_item_id = cv_physical_item_id; 


    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;
    
    COMMIT;

    ps_location := 'PFSA 48';            -- For std_pfsawh_debug_tbl logging. 

    MERGE  
    INTO   frz_pfsa_equip_avail pea 
    USING  (SELECT 
                rec_id,             source_rec_id,       pba_id, 
                physical_item_id,   physical_item_sn_id,
                force_unit_id,      mimosa_item_sn_id,
                sys_ei_niin,        pfsa_item_id,
                record_type,        from_dt,             to_dt,
                ready_date,         day_date,            month_date,
                pfsa_org,           sys_ei_sn,           item_days,
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
                frz_input_date, frz_input_date_id, rec_frz_flag,   frz_date,
                insert_by,      insert_date,
                update_by,      update_date,
                delete_flag,    delete_date,       delete_by,
                hidden_flag,    hidden_date,       hidden_by,
                active_flag,    active_date,       inactive_date, 
                ridb_on_time_flag,  readiness_reported_qty, ready_date_id 
            FROM   frz_pfsa_equip_avail_tmp ) tmp 
    ON     ( tmp.physical_item_id       = cv_physical_item_id
            AND pea.rec_id  = tmp.rec_id
           )  
    WHEN MATCHED THEN 
        UPDATE SET   
            pea.source_rec_id       = tmp.source_rec_id,        
            pea.pba_id              = tmp.pba_id,  
            pea.physical_item_sn_id = tmp.physical_item_sn_id, 
            pea.force_unit_id       = tmp.force_unit_id,     
            pea.mimosa_item_sn_id   = tmp.mimosa_item_sn_id, 
            pea.sys_ei_niin         = tmp.sys_ei_niin,       
            pea.pfsa_item_id        = tmp.pfsa_item_id, 
            pea.record_type         = tmp.record_type,       
            pea.from_dt             = tmp.from_dt,              
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
            pea.frz_input_date      = tmp.frz_input_date,  
            pea.frz_input_date_id   = tmp.frz_input_date_id,  
            pea.rec_frz_flag        = tmp.rec_frz_flag,   
            pea.frz_date            = tmp.frz_date, 
            pea.insert_by           = tmp.insert_by,       
            pea.insert_date         = tmp.insert_date, 
            pea.update_by           = tmp.update_by,       
            pea.update_date         = tmp.update_date, 
            pea.delete_flag         = tmp.delete_flag,     
            pea.delete_date         = tmp.delete_date,        
            pea.delete_by           = tmp.delete_by, 
            pea.hidden_flag         = tmp.hidden_flag,     
            pea.hidden_date         = tmp.hidden_date,        
            pea.hidden_by           = tmp.hidden_by,
            pea.active_flag         = tmp.active_flag,    
            pea.active_date         = tmp.active_date,
            pea.inactive_date       = tmp.inactive_date, 
            pea.ridb_on_time_flag   = tmp.ridb_on_time_flag, 
            pea.ready_date_id       = tmp.ready_date_id, 
            pea.readiness_reported_qty = tmp.readiness_reported_qty              
    WHEN NOT MATCHED THEN 
        INSERT (
                pea.rec_id,           pea.source_rec_id,       pea.pba_id, 
                pea.physical_item_id, pea.physical_item_sn_id,
                pea.force_unit_id,    pea.mimosa_item_sn_id,
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
                pea.frz_input_date, pea.frz_input_date_id, pea.rec_frz_flag,   pea.frz_date,
                pea.insert_by,      pea.insert_date,
                pea.update_by,      pea.update_date,
                pea.delete_flag,    pea.delete_date,       pea.delete_by,
                pea.hidden_flag,    pea.hidden_date,       pea.hidden_by, 
                pea.active_flag,    pea.active_date,       pea.inactive_date, 
                pea.ridb_on_time_flag,  pea.readiness_reported_qty, pea.ready_date_id 
                )
        VALUES (
                tmp.rec_id,           tmp.source_rec_id,       tmp.pba_id, 
                tmp.physical_item_id, tmp.physical_item_sn_id,
                tmp.force_unit_id,    tmp.mimosa_item_sn_id,
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
                tmp.frz_input_date, tmp.frz_input_date_id, tmp.rec_frz_flag,   tmp.frz_date,
                tmp.insert_by,      tmp.insert_date,
                tmp.update_by,      tmp.update_date,
                tmp.delete_flag,    tmp.delete_date,       tmp.delete_by,
                tmp.hidden_flag,    tmp.hidden_date,       tmp.hidden_by, 
                tmp.active_flag,    tmp.active_date,       tmp.inactive_date, 
                tmp.ridb_on_time_flag,  tmp.readiness_reported_qty, tmp.ready_date_id 
);

    proc0.rec_merged_int := NVL(proc0.rec_merged_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
           
--    pr_upd_pfsa_fsc_sys_dates (ps_this_process.who_ran, 'EQUIP_AVAIL_PERIOD_DATE'); 
    
    ps_location := 'PFSA 50';            -- For std_pfsawh_debug_tbl logging. 
    
    myrowcount := 0;
    
    SELECT COUNT(*) 
    INTO   myrowcount
    FROM   frz_pfsa_equip_avail_tmp;
    
    IF myrowcount > 0 THEN
       mytablename := 'frz_pfsa_equip_avail_tmp';
       truncate_a_table (mytablename);
    END IF;
    
    proc0.rec_deleted_int := NVL(proc0.rec_deleted_int, 0) + myrowcount;
          
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
             FROM   frz_pfsa_equip_avail 
             WHERE  physical_item_id = cv_physical_item_id
             GROUP BY physical_item_id, physical_item_sn_id, pba_id, 
                      ready_date, force_unit_id
          ) pea 
    ON (    pf.physical_item_id = pea.physical_item_id
        AND pea.physical_item_sn_id = pf.physical_item_sn_id  
        AND pea.pba_id = pf.pba_id  
        AND pea.force_unit_id = pf.item_force_id
        AND fn_date_to_date_id(pea.ready_date) = pf.item_date_to_id 
       )   
    WHEN MATCHED THEN UPDATE SET
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
            pf.readiness_reported_qty = pea.rrq;

    proc0.rec_updated_int := NVL(proc0.rec_updated_int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
    

    IF v_debug > 0 THEN 
    
        DBMS_OUTPUT.NEW_LINE;

        FOR process_rec in (SELECT   a.process_key, a.message
                               FROM     pfsawh_process_log a
                               ORDER BY a.process_key DESC)
        LOOP
            DBMS_OUTPUT.PUT_LINE(process_rec.process_key || ', ' 
                || process_rec.message);
        
        END LOOP;
       
    END IF;

    -- Update the status of the process. 
    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, 'COMPLETE', 
        SYSDATE, SYSDATE
        );
      
    ps_location := '99-Close';

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

    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
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
            
END etl_pfsa_equip_avail_frz_niin;
/
