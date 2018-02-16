CREATE OR REPLACE PROCEDURE PR_CREATE_PFSAWH_FRZ_SHEL_NIN    
    (
    v_physical_item_id    IN    NUMBER,  -- Warehouse id for the NIIN 
    type_maintenance      IN    VARCHAR2 -- calling procedure name, used in 
                                         -- debugging, calling procedure 
                                         -- responsible for maintaining 
                                         -- heirachy 
    )
    
IS
/************ TEAM ITSS********************************************************


       NAME:    PR_CREATE_PFSAWH_FRZ_SHEL_NIN 

    PURPOSE:    Based on the passed PHYSICAL_ITEM _ID uses the PSFA_PBA... and 
                PFASWH_ITEM_SN_P_FACT  tables, and when appropriate, creates the 
                fact shell for the periods between the PBA's dates. 


 PARAMETERS:   See procedure definition

      INPUT:   See procedure definition

     OUTPUT:   See procedure definition

ASSUMPTIONS:  That the "All ARMY" fact records for the PHYSICL_ITEM_ID  
              exist in the PFSAWH_ITEM_SN_P_FACT. 

LIMITATIONS:  Expects valid PHYSICAL_ITEM_ID 

      NOTES:

  
  Date     ECP #                 Author           Description
---------  ---------------       ---------------  ----------------------------------
24 Nov 08  EECP03680-CPTSK09335  j-ann            Procedure Created




************* TEAM ITSS *******************************************************/

-- Exception handling variables (ps_) 

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_CREAT_PFSAWH_FRZ_SHEL_NIIN';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'No message defined'; /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- standard variables


l_ps_start                       DATE          := sysdate;


proc0_recId           pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

proc0                 pfsawh_process_log%ROWTYPE; 

ps_last_process       pfsawh_processes%ROWTYPE;
ps_this_process       pfsawh_processes%ROWTYPE;

-- module variables (v_)
v_data_flag                boolean;

v_debug                    PLS_INTEGER        
     := 0;   -- Controls debug options (0 -Off)

cv_physical_item_id        pfsawh_item_dim.physical_item_id%TYPE; 

v_niin                     pfsawh_item_dim.niin%TYPE; 
v_item_nomen_standard      pfsawh_item_dim.item_nomen_standard%TYPE; 

----------------------------------- START --------------------------------------

BEGIN

    ps_location := 'PFSAWH 00';            -- For std_pfsawh_debug_tbl logging. 

    IF v_debug > 0 THEN
        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE
           ( 
           'v_physical_item_id: ' || v_physical_item_id || ', ' || 
           'type_maintenance:   ' || type_maintenance
           );
    END IF;  
    
    v_data_flag := False;
    cv_physical_item_id := v_physical_item_id;

    ps_id_key := NVL(type_maintenance, ps_procedure_name);

    SELECT  NIIN,   ITEM_NOMEN_STANDARD 
    INTO    v_niin, v_item_nomen_standard  
    FROM    PFSAWH_ITEM_DIM    
    WHERE   PHYSICAL_ITEM_ID = cv_physical_item_id;

    --  Set the outer calling module (proc_0.) values.

    proc0.process_RecId      := 706; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.process_Start_Date := SYSDATE;
    proc0.user_Login_Id      := USER; 
    proc0.message            := v_physical_item_id || '-' || 
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

    -- Housekeeping for the process 
  
    -- get the run criteria from the pfsa_processes table for the last run of this 
    -- main process 
    get_pfsawh_process_info ( 
        ps_procedure_name, ps_procedure_name, ps_last_process.last_run, 
        ps_last_process.who_ran, ps_last_process.last_run_status, 
        ps_last_process.last_run_status_time, ps_last_process.last_run_compl
        );

    -- Set up for and Update the pfsawh_PROCESSES table to indicate MAIN process began.  
    ps_this_process.last_run             := l_ps_start;
    ps_this_process.who_ran              := ps_id_key;
    ps_this_process.last_run_status      := 'BEGAN';
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_compl       := ps_last_process.last_run_compl;

    updt_pfsawh_processes (
        ps_procedure_name, ps_procedure_name, ps_this_process.last_run,  
        ps_this_process.who_ran, ps_this_process.last_run_status, 
        ps_this_process.last_run_status_time, ps_this_process.last_run_compl
        );
      
    COMMIT;

/*----------------------------------------------------------------------------*/ 
/*----- Start of actual work                                             -----*/  
/*----------------------------------------------------------------------------*/ 

    ps_location := 'PFSAWH 40';            -- For std_pfsawh_debug_tbl logging.
    
    
   -- Get the PBAs for the Freeze data

   FOR pba_rec IN (SELECT DISTINCT pir.pba_id, pir.item_identifier_type_id 
                      FROM  pfsa_pba_items_ref pir,
                            pfsa_pba_ref pr
                      WHERE  pr.pba_freeze_flag           = 'Y'
                         AND pr.pba_id                    = pir.pba_id
                         AND pir.item_identifier_type_id <> 13
                      ORDER BY pir.pba_id)
   LOOP    

      IF pba_rec.item_identifier_type_id = 16 THEN
         --  Get SN and dates Based on PBA, NIIN and UIC from PFSA_PBA_ITEM_REF 
         
         ps_location := 'PFSAWH 42';            -- For std_pfsawh_debug_tbl logging.
         
         FOR uic_rec in --Any 'AGGREGATE's will be include in this cursor.
               (SELECT  distinct cpir.force_unit_id, cpir.item_from_date_id   , 
                                 cpir.item_to_date_id
                   FROM    pfsawh_item_sn_p_fact cisd,
                           pfsa_pba_items_ref cpir 
                   WHERE   cv_physical_item_id in (SELECT physical_item_id
                                                      FROM pfsa_pba_items_ref
                                                      WHERE  pba_id = pba_rec.pba_id
                                                         AND item_identifier_type_id = 13)       
                      AND cpir.pba_id                  = pba_rec.pba_id
                      AND cpir.item_identifier_type_id = 16
                      AND cisd.physical_item_id        = cv_physical_item_id 
                      AND cpir.force_unit_id           = cisd.item_force_id
                      ORDER BY  cpir.force_unit_id)
         LOOP
            v_data_flag := TRUE;
            proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
            
         --  ##### Create the period records starting at the begining of the freeze period 
             --      ###### ending which ever comes first: the current all army or the end of the freze period.                 
            --  ITEM_DAYS is copied since it is calculated based on id fields so would be the same for the 
            --       records being copied. 
            INSERT 
               INTO   pfsawh_item_sn_p_fact 
                   (
                   period_type,
                   date_id,                          
                   physical_item_id,                         
                   physical_item_sn_id,                      
                   mimosa_item_sn_id,        
                   pba_id,
                   item_date_from_id,                
                   item_time_from_id,
                   item_date_to_id, 
                   item_time_to_id,
                   item_force_id, 
                   item_location_id, 
                   item_days 
                   ) 
            SELECT 
                   cisd.period_type ,
                   cisd.date_id,                           
                   cisd.physical_item_id, 
                   cisd.physical_item_sn_id, 
                   cisd.mimosa_item_sn_id,        
                   pba_rec.pba_id,
                   cisd.item_date_from_id,                
                   cisd.item_time_from_id,
                   cisd.item_date_to_id, 
                   cisd.item_time_to_id,
                   cisd.item_force_id, 
                   cisd.item_location_id, 
                   cisd.item_days 
            FROM   pfsawh_item_sn_p_fact cisd 
            WHERE  cisd.physical_item_id = cv_physical_item_id
               AND cisd.pba_id in (select pba_id 
                                      from pfsa_pba_ref pba 
                                      WHERE  pba.pba_key1 = 'USA') 
               AND cisd.item_force_id = uic_rec.force_unit_id
               AND cisd.date_id BETWEEN 
                          uic_rec.item_from_date_id
                           and
                          uic_rec.item_to_date_id                               
               AND NOT EXISTS (SELECT l.rec_id 
                               FROM   pfsawh_item_sn_p_fact l
                               WHERE  l.date_id = cisd.date_id
                                  AND l.physical_item_sn_id = cisd.physical_item_sn_id 
                                  AND l.pba_id = pba_rec.pba_id
                                  AND l.item_force_id = cisd.item_force_id
                               );
                        
            proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;
                
         END LOOP;
         COMMIT;             
         
      ELSE
         --  Get SN and dates Based on PBA, NIIN and UIC from PFSA_PBA_ITEM_REF 
         ps_location := 'PFSAWH 44';            -- For std_pfsawh_debug_tbl logging.
         
         FOR sn_rec in 
               (SELECT  distinct cisd.physical_item_sn_id, cpir.item_from_date_id   , 
                                 cpir.item_to_date_id
                   FROM    pfsawh_item_sn_p_fact cisd,
                           pfsa_pba_items_ref cpir 
                   WHERE   cv_physical_item_id in (SELECT physical_item_id
                                                      FROM pfsa_pba_items_ref
                                                      WHERE  pba_id = pba_rec.pba_id
                                                         AND item_identifier_type_id = 13)       
                      AND cpir.pba_id                  = pba_rec.pba_id
                      AND cpir.item_identifier_type_id = 14
                      AND cisd.physical_item_id        = cv_physical_item_id 
                      AND cisd.physical_item_sn_id     = cpir.physical_item_sn_id
                   ORDER BY  cisd.physical_item_sn_id)
         LOOP
            v_data_flag := TRUE;
            proc0.rec_read_int := NVL(proc0.rec_read_int, 0) + 1;
            
         --  ##### Create the period records starting at the begining of the freeze period 
             --      ###### ending which ever comes first: the current all army or the end of the freze period.                 
         --  ITEM_DAYS is copied since it is calculated based on id fields so would be the same for the 
            --       records being copied. 
               INSERT 
               INTO   pfsawh_item_sn_p_fact 
                   (
                   period_type,
                   date_id,                          
                   physical_item_id,                         
                   physical_item_sn_id,                      
                   mimosa_item_sn_id,        
                   pba_id,
                   item_date_from_id,                
                   item_time_from_id,
                   item_date_to_id, 
                   item_time_to_id,
                   item_force_id, 
                   item_location_id, 
                   item_days 
                   ) 
            SELECT 
                   cisd.period_type ,
                   cisd.date_id,                           
                   cisd.physical_item_id, 
                   cisd.physical_item_sn_id, 
                   cisd.mimosa_item_sn_id,        
                   pba_rec.pba_id,
                   cisd.item_date_from_id,                
                   cisd.item_time_from_id,
                   cisd.item_date_to_id, 
                   cisd.item_time_to_id,
                   cisd.item_force_id, 
                   cisd.item_location_id, 
                   cisd.item_days 
            FROM   pfsawh_item_sn_p_fact cisd 
            WHERE   cisd.physical_item_id = cv_physical_item_id
               AND cisd.pba_id in (select pba_id 
                                      from pfsa_pba_ref pba 
                                      WHERE  pba.pba_key1 = 'USA') 
               AND cisd.physical_item_sn_id = sn_rec.physical_item_sn_id
               AND cisd.date_id BETWEEN 
                          sn_rec.item_from_date_id
                           and
                          sn_rec.item_to_date_id                               
               AND NOT EXISTS (SELECT l.rec_id 
                               FROM   pfsawh_item_sn_p_fact l
                               WHERE  cisd.physical_item_sn_id = l.physical_item_sn_id 
                                  AND l.pba_id = pba_rec.pba_id
                                  AND cisd.date_id = l.date_id
                               );
                        
            proc0.rec_inserted_int := NVL(proc0.rec_inserted_int, 0) + SQL%ROWCOUNT;

         end LOOP;
         
         COMMIT;
         
      END IF;
      
    
-- Set the annual records start and stop range. 
-- The stop point is padded to create the next anual record 6 months in advance.
    --Not used for Freeze               
                
-- See if we have any reporting_org for this SN 
    -- Handled by pr_create_pfsawh_fact_shel_nin

-- If the reporting_org exists, get the earliest date 
    -- Handled by pr_create_pfsawh_fact_shel_nin
-- Check to see if the UIC is in the force_unit_dim 
    -- Handled by pr_create_pfsawh_fact_shel_nin
            
-- Get the id from the dim 
    -- Handled by pr_create_pfsawh_fact_shel_nin
            
-- Logging the missing UIC in the functional_warnings 
    -- Handled by pr_create_pfsawh_fact_shel_nin
 
        
-- Create the Annual fact records 
    --Annual fact records not needed for the Freeze data.
        
-- Get the force id   
    -- Handled by pr_create_pfsawh_fact_shel_nin
        
-- See if we have any reporting_org for this SN for the 1st to 15th period 
    -- Handled by pr_create_pfsawh_fact_shel_nin
        
-- If the reporting_org exists, get the uis for the latest date 
    -- Handled by pr_create_pfsawh_fact_shel_nin
                    
-- Check to see if the UIC is in the force_unit_dim 
    -- Handled by pr_create_pfsawh_fact_shel_nin
                
-- Get the id from the dim 
    -- Handled by pr_create_pfsawh_fact_shel_nin

-- Logging the missing UIC in the functional_warnings 
    -- Handled by pr_create_pfsawh_fact_shel_nin
                
-- Create the life records   
    -- Life fact records not needed for the Freeze data.

    END LOOP;   --PBA_REC  
    
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
               
    if v_data_flag then
    -- Call the processes to fill in the Facts for the shells
       etl_pfsa_equip_avail_frz_niin (cv_physical_item_id, ps_procedure_name); 
    
       COMMIT; 
        
       etl_pfsa_usage_event_frz_niin (cv_physical_item_id, ps_procedure_name); 
        
       COMMIT; 
        
       etl_pfsa_maint_frz_niin (cv_physical_item_id, ps_procedure_name); 
       
       COMMIT;
    
    end if; 
    
/*----------------------------------------------------------------------------*/ 
/*----- End of actual work                                               -----*/  
/*----------------------------------------------------------------------------*/ 
  
    ps_location := 'PFSAWH 60';            -- For std_pfsawh_debug_tbl logging.
  
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

END pr_create_pfsawh_frz_shel_nin; -- end of procedure
.
/



