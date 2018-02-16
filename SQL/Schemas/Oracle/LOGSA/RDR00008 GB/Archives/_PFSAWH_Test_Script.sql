BEGIN

--    maint_pfsawh_warehouse; 
    
--    pr_pfsawh_log_cleanup;

--    pr_pfsawh_debugtbl_cleanup;

--    get_pfsaw_sys_ei(0); 
    
--    get_pfsaw_sn_ei(0); 
    
--    gb_load_pfsawh_avail_p_fact(0);

    pr_get_dim_source_statistics(0);
    
    COMMIT;
        
END;

/*

SELECT log.process_key As prc_lg_sq, ':', 
    log.process_recid AS prc, p.process_description,  
    log.module_num AS mod_#, log.step_num AS stp_#, 
    '|', TO_CHAR(log.process_start_date, 'YYYY-MM-DD HH24:MM:SS') AS started, 
    TO_CHAR(log.process_end_date, 'YYYY-MM-DD HH24:MM:SS') AS ended, 
    process_status_code AS status,
    log.sql_error_code AS sql_err, log.rec_read_int AS read, 
    log.rec_valid_int AS valid, log.rec_load_int AS load, 
    log.rec_inserted_int AS inserted, log.rec_selected_int AS selected, 
    log.rec_updated_int AS updated, log.rec_deleted_int AS deleted,
    log.message, log.user_login_id AS user_id
---    , '||', log.* 
FROM GB_PFSAWH_Process_Log log 
LEFT OUTER JOIN gb_pfsawh_processes p ON log.process_recid = p.process_key 
ORDER BY log.process_key DESC;

SELECT bug.msg_dt, bug.* FROM std_pfsa_debug_tbl bug ORDER BY bug.msg_dt DESC; 

*/

/* 

SELECT * 
FROM   vw_pfsawh_availability_p_fact 
WHERE  to_date = '15-SEP-2007' 
    AND item_serial_number LIKE '%AGR%';

SELECT p.notes, ' | ', p.* 
FROM   gb_pfsawh_availability_p_fact p
ORDER BY p.avail_item_sn_ei_id, p.avail_item_sys_ei_id, p.avail_date_from;

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
