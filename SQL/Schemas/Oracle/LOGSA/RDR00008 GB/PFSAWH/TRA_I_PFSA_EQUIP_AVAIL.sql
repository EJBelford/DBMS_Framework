CREATE OR REPLACE TRIGGER tra_i_pfsa_equip_avail 
--
-- this trigger ensures data source heirarchy is maintained when updating data 
--
AFTER INSERT ON pfsa_equip_avail
FOR EACH ROW
DECLARE

  ps_oerr               varchar2(6)   := null;
  ps_location           varchar2(10)  := null;
  ps_procedure_name     varchar2(30)  := 'TRA_U_PFSA_EQUIP_AVAIL';
  ps_msg                varchar2(200) := 'trigger_failed';
  ps_id_key             varchar2(200) := null; -- set in cases


BEGIN

    INSERT 
    INTO   frz_pfsa_equip_avail 
        (
--        rec_id, 
--        source_rec_id, 
--    
        pba_id, 
        phyiscal_item_id,
        phyiscal_item_sn_id,
--        force_unit_id,
        mimosa_item_sn_id,
--    
        sys_ei_niin,
        pfsa_item_id,
        record_type,
        from_dt,
        to_dt,
        ready_date,
        day_date,
        month_date,
        pfsa_org,
        sys_ei_sn,
        item_days,
        period_hrs,
        nmcm_hrs,
        nmcs_hrs,
        nmc_hrs,
        fmc_hrs,
        pmc_hrs,
        mc_hrs,
        nmcm_user_hrs,
        nmcm_int_hrs,
        nmcm_dep_hrs,
        nmcs_user_hrs,
        nmcs_int_hrs,
        nmcs_dep_hrs,
        pmcm_hrs,
        pmcs_hrs,
        source_id,
        pmcs_user_hrs,
        pmcs_int_hrs,
        pmcm_user_hrs,
        pmcm_int_hrs,
        dep_hrs,
        heir_id,
        priority,
        uic,
        grab_stamp,
        proc_stamp,
        sys_ei_uid, 
--    
--        status,
        lst_updt,
        updt_by --, 
--
--        rec_frz_flag, 
--        active_date , 
--        frz_date,
--
--        insert_by, 
--        insert_date, 
--        update_by,
--        update_date,
--        delete_flag,
--        delete_date,
--        hidden_flag,
--        hidden_date  
        )
    SELECT
--        rec_id, 
--        source_rec_id, 
--    
        ir1.pba_id, 
        ir1.physical_item_id ,
        ir2.physical_item_sn_id ,
--        force_unit_id,
        LPAD(LTRIM(TO_CHAR(ir2.physical_item_sn_id , 'XXXXXXX')), 8, '0'), 
--    
        :new.sys_ei_niin,
        :new.pfsa_item_id,
        :new.record_type,
        :new.from_dt,
        :new.to_dt,
        :new.ready_date,
        :new.day_date,
        :new.month_date,
        :new.pfsa_org,
        :new.sys_ei_sn,
        :new.item_days,
        :new.period_hrs,
        :new.nmcm_hrs,
        :new.nmcs_hrs,
        :new.nmc_hrs,
        :new.fmc_hrs,
        :new.pmc_hrs,
        :new.mc_hrs,
        :new.nmcm_user_hrs,
        :new.nmcm_int_hrs,
        :new.nmcm_dep_hrs,
        :new.nmcs_user_hrs,
        :new.nmcs_int_hrs,
        :new.nmcs_dep_hrs,
        :new.pmcm_hrs,
        :new.pmcs_hrs,
        :new.source_id,
        :new.pmcs_user_hrs,
        :new.pmcs_int_hrs,
        :new.pmcm_user_hrs,
        :new.pmcm_int_hrs,
        :new.dep_hrs,
        :new.heir_id,
        :new.priority,
        :new.uic,
        :new.grab_stamp,
        :new.proc_stamp,
        :new.sys_ei_uid, 
--    
--        status,
        :new.lst_updt,
        :new.updt_by --, 
--
--        rec_frz_flag, 
--        active_date , 
--        frz_date,
--
--        insert_by, 
--        insert_date, 
--        update_by,
--        update_date,
--        delete_flag,
--        delete_date,
--        hidden_flag,
--        hidden_date  
    FROM   pfsa_pba_items_ref ir1, 
           pfsa_pba_items_ref ir2 
    WHERE  :new.sys_ei_niin = ir1.item_type_value 
        AND :new.sys_ei_sn = ir2.item_type_value; 

EXCEPTION WHEN others THEN
    ps_oerr   := sqlcode;
    ps_id_key := :new.sys_ei_niin||' '||:new.pfsa_item_id||' '||:new.record_type||' '||:new.from_dt;
    ps_msg    := SUBSTR(ps_msg || ' - ' || sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    INSERT 
    INTO std_pfsa_debug_tbl 
        (
        ps_procedure, 
        ps_oerr, 
        ps_location, 
        called_by, 
        ps_id_key, 
        ps_msg, 
        msg_dt
        )
    VALUES 
        (ps_procedure_name, 
        ps_oerr, 
        ps_location, 
        NULL, 
        ps_id_key, 
        ps_msg, 
        SYSDATE
        );

end;
 

/* 

DELETE pfsa_equip_avail  
WHERE  pfsa_item_id LIKE 'GB%'; 

DELETE frz_pfsa_equip_avail  
WHERE  pfsa_item_id LIKE 'GB%'; 

COMMIT; 

INSERT 
INTO pfsa_equip_avail 
    ( 
    sys_ei_niin,
    pfsa_item_id,
    record_type,
    from_dt,
    to_dt,
    ready_date, 
    sys_ei_sn  
    ) 
VALUES  
    ( 
    '014172886',
    'GB6',
    'D', 
    TO_DATE('01-JAN-1900', 'DD-MON-YYYY'),  
    TO_DATE('31-DEC-1900', 'DD-MON-YYYY'),  
    TO_DATE('15-JAN-1901', 'DD-MON-YYYY'), 
    '10KA0946'  
    );    
    
INSERT 
INTO pfsa_equip_avail 
    ( 
    sys_ei_niin,
    pfsa_item_id,
    record_type,
    from_dt,
    to_dt,
    ready_date, 
    sys_ei_sn  
    ) 
VALUES  
    ( 
    '014172886',
    'GB3',
    'D', 
    TO_DATE('01-JAN-1900', 'DD-MON-YYYY'),  
    TO_DATE('31-DEC-1900', 'DD-MON-YYYY'),  
    TO_DATE('15-JAN-1901', 'DD-MON-YYYY'), 
    '10KA0943'  
    );    
    
INSERT 
INTO pfsa_equip_avail 
    ( 
    sys_ei_niin,
    pfsa_item_id,
    record_type,
    from_dt,
    to_dt,
    ready_date, 
    sys_ei_sn  
    ) 
VALUES  
    ( 
    '01417288x',
    'GB',
    'D', 
    TO_DATE('01-JAN-1900', 'DD-MON-YYYY'),  
    TO_DATE('31-DEC-1900', 'DD-MON-YYYY'),  
    TO_DATE('15-JAN-1901', 'DD-MON-YYYY'), 
    '10KA0946'  
    );    
    
COMMIT;  
    
SELECT * 
FROM   pfsa_equip_avail  
WHERE  pfsa_item_id LIKE 'GB%'; 

SELECT * 
FROM   std_pfsa_debug_tbl 
ORDER BY msg_dt DESC;   

DELETE  std_pfsa_debug_tbl  
WHERE   ps_procedure = 'TRA_U_PFSA_EQUIP_AVAIL'; '

COMMIT; 
    
SELECT * 
FROM   frz_pfsa_equip_avail;   
  
    
*/ 
