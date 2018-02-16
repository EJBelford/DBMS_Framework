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

/*----- Test script ----- 

BEGIN  
    
    pr_ld_pfsawh_itm_sn_bld_fact(0); 
     
    COMMIT; 

    pr_vld_pfsawh_itm_sn_bld_fact(0);   
    
    COMMIT; 
        
END; 

*/   

CREATE OR REPLACE PROCEDURE pr_vld_pfsawh_itm_sn_bld_fact 
    (
    in_rec_Id                IN      NUMBER  
    )

IS

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'PR_VLD_PFSAWH_ITM_SN_BLD_FACT';  /*  */
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

    proc0.process_RecId      := 112; 
    proc0.process_Key        := NULL;
    proc0.module_Num         := 0;
    proc0.step_Num           := 0;
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
        DBMS_OUTPUT.ENABLE(1000000);
        
        DBMS_OUTPUT.NEW_LINE;
    
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || proc0.process_RecId || ', ' || proc0.process_Key);

--        dbms_lock.sleep(1);
    END IF;  
    
    UPDATE pfsawh_item_sn_bld_fact
    SET    status = 'Z' 
    WHERE  UPPER(status) = 'E';

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_id - Get id'); 
    END IF;

    proc1.process_RecId      := 112; 
    proc1.process_Key        := NULL;
    proc1.user_Login_Id      := USER; 
    proc1.process_Start_Date := SYSDATE;
    proc1.module_Num         := 5;
    proc1.step_Num           := 0;
    proc1.sql_Error_Code     := NULL; 
    proc1.rec_Read_Int       := NULL;
    proc1.rec_Valid_Int      := NULL;
    proc1.rec_Updated_Int    := NULL;
  
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
        
    COMMIT;     
    
    SELECT COUNT(rec_id) 
    INTO   proc0.rec_Read_Int 
    FROM   pfsawh_item_sn_bld_fact;

    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  physical_item_id IS NULL 
        OR physical_item_id < 1;

    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Valid_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  physical_item_id >= 1;

--  physical_item_id      
     
    ps_location := '05-Item'; 
        
    UPDATE pfsawh_item_sn_bld_fact 
    SET    physical_item_id = 
               NVL((
               SELECT physical_item_id   
               FROM   pfsawh_item_dim
               WHERE  niin = s_sys_ei_niin 
               ), -1)
    WHERE  physical_item_id IS NULL 
        OR physical_item_id < 1; 

    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    
    COMMIT;
    
    proc1.process_End_Date    := sysdate;
    proc1.sql_Error_Code      := sqlcode;
    proc1.process_Status_Code := NVL(proc1.sql_Error_Code, sqlcode);
    proc1.message             := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
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

--  physical_item_sn_id 

    ps_location := '10-Item SN'; 
    
    proc1_recId              := NULL; 
    proc1.process_Start_Date := sysdate;
    proc1.module_Num         := 10;
    proc1.sql_Error_Code     := NULL; 
    proc1.rec_Read_Int       := NULL;
    proc1.rec_Valid_Int      := NULL;
    proc1.rec_Updated_Int    := NULL;
            
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Flag aggregate'); 
    END IF;

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
        
    COMMIT;     
        
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Read_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  physical_item_sn_id IS NULL 
        OR physical_item_sn_id < 1;

    SELECT COUNT(rec_id) 
    INTO   proc1.sql_Error_Code 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  UPPER(s_sys_ei_sn) LIKE '%AGGREGATE%';

    SELECT COUNT(rec_id) 
    INTO   proc1.rec_Valid_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  physical_item_sn_id >= 1;

--    UPDATE pfsawh_item_sn_bld_fact 
--    SET    physical_item_sn_id = 0, 
--           status   = 'E', 
--           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
--           lst_updt = sysdate, 
--           notes    = SUBSTR('Aggregate' || NVL(('~' || notes), ''), 1, 255)
--    WHERE  UPPER(s_sys_ei_sn) LIKE '%AGGREGATE%';  
    
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;
    
    COMMIT; 
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Get id'); 
    END IF;

--    UPDATE pfsawh_item_sn_bld_fact 
--    SET    physical_item_sn_id = 
--               NVL((
--                   SELECT sn.physical_item_sn_id   
--                   FROM   pfsawh_item_sn_dim sn 
--                   WHERE  sn.item_niin = s_sys_ei_niin 
--                       AND sn.item_serial_number = s_sys_ei_sn
--                   ), -1)
--    WHERE physical_item_id > 0 
--        /*AND physical_item_sn_id > 0*/;  
        
    UPDATE pfsawh_item_sn_bld_fact 
    SET    physical_item_sn_id = 
               fn_pfsawh_get_item_sn_dim_id(s_sys_ei_niin, s_sys_ei_sn), 
           mimosa_item_sn_id = 
               LPAD(LTRIM(TO_CHAR(fn_pfsawh_get_item_sn_dim_id(s_sys_ei_niin, s_sys_ei_sn), 'XXXXXXX')), 8, '0')
    WHERE  physical_item_id > 0
        AND ( physical_item_sn_id IS NULL OR physical_item_sn_id < 1 )
--        AND UPPER(s_sys_ei_sn) NOT LIKE '%AGGREGATE%'
        ; 
        
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
--    UPDATE pfsawh_item_sn_bld_fact  
--    SET    status = 'E', 
--           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
--           lst_updt = sysdate, 
--           notes    = SUBSTR(NVL((notes || '~'), '') || 'Item SN not found: ' || s_sys_ei_sn, 1, 255) 
--    WHERE  physical_item_sn_id < 1; 

--    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
--    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

--    COMMIT; 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Update status'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    status   = 'E', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR('Item SN not found: ' || s_sys_ei_sn || NVL(('~' || notes), ''), 1, 255) 
    WHERE  physical_item_sn_id < 1;  
    
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    proc1.process_End_Date    := sysdate;
    proc1.sql_Error_Code      := sqlcode;
    proc1.process_Status_code := NVL(proc1.sql_Error_Code, sqlcode);
    proc1.message             := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
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
    
-- mimosa_item_sn_id     
    
    ps_location := '15-MIMOSA'; 
    
    proc1_recId              := NULL; 
    proc1.process_Start_Date := sysdate;
    proc1.module_Num         := 15; 
    proc1.sql_Error_Code     := NULL; 
    proc1.rec_Read_Int       := NULL;
    proc1.rec_Valid_Int      := NULL;
    proc1.rec_Updated_Int    := NULL;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('physical_item_sn_id - Flag aggregate'); 
    END IF;

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
        
    COMMIT;     
        
--    UPDATE pfsawh_item_sn_bld_fact  
--    SET    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR(physical_item_sn_id , 'XXXXXXX')), 8, '0')
--    WHERE  physical_item_sn_id > 0; 
    
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;
    
    COMMIT; 
    
    proc1.process_End_Date    := sysdate;
    proc1.sql_Error_Code      := sqlcode;
    proc1.process_Status_Code := NVL(proc1.sql_Error_Code, sqlcode);
    proc1.message             := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
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
    
-- force_id  

    ps_location := '20-Force'; 
    
    proc1_recId              := NULL; 
    proc1.process_Start_Date := sysdate;
    proc1.module_Num         := 20;
    proc1.sql_Error_Code     := NULL; 
    proc1.rec_Read_Int       := NULL;
    proc1.rec_Valid_Int      := NULL;
    proc1.rec_Updated_Int    := NULL;
        
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
        
    COMMIT;     
        
----- force_unit_id 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_force_unit_id - Get id'); 
    END IF;

    SELECT COUNT(rec_id) 
    INTO   proc1.rec_read_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  item_force_unit_id IS NULL 
        OR item_force_unit_id < 1;

    SELECT COUNT(rec_id) 
    INTO   proc1.rec_valid_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  item_force_unit_id >= 1;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    item_force_unit_id = NVL((  
                                SELECT force_unit_id  
                                FROM   pfsawh_force_unit_dim 
                                WHERE  uic = s_uic
                                    AND UPPER(SUBSTR(LTRIM(status), 1, 1)) = 'C' 
                                ), -1)
    WHERE  item_force_unit_id IS NULL 
        OR item_force_unit_id < 1; 
    
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
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
                                ), -1)
    WHERE  item_bct_force_id IS NULL 
        OR item_bct_force_id < 1; 
    
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_bct_force_id - Update status'); 
    END IF;

--    UPDATE pfsawh_item_sn_bld_fact 
--    SET    status   = 'E', 
--           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
--           lst_updt = sysdate, 
--           notes    = SUBSTR(NVL((notes || '~'), '') || 'BCT Force not found: ' || s_uic, 1, 255)
--    WHERE  item_bct_force_id = -1;  
--    
--    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
--    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
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
                                ), -1)
    WHERE  item_uto_force_id IS NULL 
        OR item_uto_force_id < 1; 
    
   proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
   proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_uto_force_id - Update status'); 
    END IF;

--    UPDATE pfsawh_item_sn_bld_fact 
--    SET    status   = 'E', 
--           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
--           lst_updt = sysdate, 
--           notes    = SUBSTR(NVL((notes || '~'), '') || 'UTO Force not found: ' || s_uic, 1, 255)
--    WHERE  item_uto_force_id = -1;  
--    
--    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
--    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

--    COMMIT; 
    
----- tfb_force_dim_id 

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_tfb_force_id - Get id'); 
    END IF;

    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_tfb_force_id - Update status'); 
    END IF;

    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 
    
    proc1.process_End_date := sysdate;
    proc1.sql_Error_Code := sqlcode;
    proc1.process_Status_Code := NVL(proc1.sql_Error_Code, sqlcode);
    proc1.message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
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
    
-- date_id  
      
    ps_location := '25-Dates'; 
    
    proc1_recId              := NULL; 
    proc1.process_Start_date := sysdate;
    proc1.module_Num         := 25; 
    proc1.sql_Error_Code     := NULL; 
    proc1.rec_Read_Int       := NULL;
    proc1.rec_Valid_Int      := NULL;
    proc1.rec_Updated_Int    := NULL;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('date_id - Get id'); 
    END IF;

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
        
    COMMIT;     
        
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_read_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  date_id IS NULL 
        OR date_id < 1;

    SELECT COUNT(rec_id) 
    INTO   proc1.rec_valid_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  date_id >= 1;

-- date_id --

    UPDATE pfsawh_item_sn_bld_fact  
    SET    date_id = NVL(( 
                        SELECT date_dim_id 
                        FROM   date_dim 
                        WHERE  oracle_date = TO_CHAR( s_ready_date ) 
                        ), -1)
    WHERE  physical_item_id > 0
        AND physical_item_sn_id > 0
        AND (date_id IS NULL OR date_id < 1);  
        
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

--    UPDATE pfsawh_item_sn_bld_fact  
--    SET    date_id = fn_date_to_date_id(s_ready_date)
--    WHERE  physical_item_id > 0
--        AND physical_item_sn_id > 0
--        AND date_id < 1;    
--                        
--    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
--    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
            
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('date_id - Update status'); 
    END IF;

    UPDATE pfsawh_item_sn_bld_fact 
    SET    status   = 'E', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR('DATE_ID set: ' || s_ready_date || NVL(('~' || notes), ''), 1, 255)
    WHERE  date_id IS NULL 
        OR date_id < 0; 
        
    COMMIT;     

    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

-- item_date_from_id     
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_date_from_id - Get id'); 
    END IF;

--    UPDATE pfsawh_item_sn_bld_fact  
--    SET    item_date_from_id = NVL((  
--                                SELECT date_dim_id  
--                                FROM   date_dim 
--                                WHERE  oracle_date = s_from_dt
--                                ), -1)
--    WHERE  physical_item_id > 0 
--        AND physical_item_sn_id > 0; 
            
    UPDATE pfsawh_item_sn_bld_fact  
    SET    item_date_from_id = fn_date_to_date_id(NVL(s_from_dt, s_ready_date))
    WHERE  physical_item_id > 0
        AND physical_item_sn_id > 0
        AND (item_date_from_id IS NULL OR item_date_from_id < 1);    
                        
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
            
    UPDATE pfsawh_item_sn_bld_fact 
    SET    status   = 'E', 
           updt_by  = 'pr_vld_pfsawh_itm_sn_bld_fact',
           lst_updt = sysdate, 
           notes    = SUBSTR('ITEM_DATE_FROM_ID not set: ' || s_from_dt || NVL(('~' || notes), ''), 1, 255)
    WHERE  item_date_from_id IS NULL 
        OR item_date_from_id < 0;  

    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
-- item_date_to_id        
    
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('item_date_to_id - Get id'); 
    END IF;

--    UPDATE pfsawh_item_sn_bld_fact  
--    SET    item_date_to_id = NVL((
--                                SELECT date_dim_id  
--                                FROM   date_dim 
--                                WHERE  oracle_date = TO_CHAR( s_to_dt, 'DD-MON-YYYY')
--                                ), -1)
--    WHERE  physical_item_id > 0
--        AND physical_item_sn_id > 0; 

    UPDATE pfsawh_item_sn_bld_fact  
    SET    item_date_to_id = fn_date_to_date_id(NVL(s_to_dt, s_ready_date))
    WHERE  physical_item_id > 0
        AND physical_item_sn_id > 0
        AND (item_date_to_id IS NULL OR item_date_to_id < 1);    
                        
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    
    COMMIT; 

    proc1.process_End_Date    := sysdate;
    proc1.sql_Error_Code      := sqlcode;
    proc1.process_Status_code := NVL(proc1.sql_Error_Code, sqlcode);
    proc1.message             := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
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
    
-- item_date_to_id        
    
    ps_location := '90-Rec Flg'; 
    
    proc1_recId              := NULL; 
    proc1.process_Start_date := sysdate;
    proc1.module_Num         := 90; 
    proc1.sql_Error_Code     := NULL; 
    proc1.rec_Read_Int       := NULL;
    proc1.rec_Valid_Int      := NULL;
    proc1.rec_Updated_Int    := NULL;
        
    IF v_debug > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Set record status to DW use.'); 
    END IF;

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
        
    COMMIT;     
        
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_read_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  status IS NULL 
        OR status NOT IN ('E');

    UPDATE pfsawh_item_sn_bld_fact  
    SET    status = 'C' 
    WHERE  status NOT IN ('E'); 
    
    SELECT COUNT(rec_id) 
    INTO   proc1.rec_valid_Int 
    FROM   pfsawh_item_sn_bld_fact
    WHERE  status = 'C';

    proc1.rec_Updated_Int     := SQL%ROWCOUNT;
    proc1.process_End_date    := sysdate;
    proc1.sql_Error_Code      := sqlcode;
    proc1.process_Status_code := NVL(proc1.sql_Error_Code, sqlcode);
    proc1.message             := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    proc0.rec_Updated_Int := NVL(proc0.rec_Updated_Int, 0) + SQL%ROWCOUNT; 
    proc1.rec_Updated_Int := NVL(proc1.rec_Updated_Int, 0) + SQL%ROWCOUNT;

    COMMIT; 
    
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
    
-- This need to be compiled as a SP 
--     
--    pr_load_pfsawh_item_sn_p_pbaft(0); 
    
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

--    proc0.recUpdatedInt := NVL(proc0.recUpdatedInt, 0) + SQL%ROWCOUNT;
    
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
                ps_procedure_name, ps_oerr, ps_location, proc1.user_Login_Id, 
                ps_id_key, ps_msg, sysdate
                );
                
            COMMIT;

END; 
