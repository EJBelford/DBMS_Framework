DECLARE 

l_now_is                         DATE          := sysdate;

my_lst_updt                      DATE; 

BEGIN

    my_lst_updt := TO_DATE('01-DEC-2008', 'DD-MON-YYYY'); 

    MERGE 
    INTO  pfsawh_fact_ld_sn_cntrl snc 
    USING (
        SELECT pea.physical_item_id, 
            it.niin, 
            it.item_nomen_standard, 
            pea.physical_item_sn_id, 
            pea.sys_ei_sn, 
            COUNT(pea.rec_id) AS rec_cnt
        FROM   pfsa_equip_avail pea 
        LEFT OUTER JOIN pfsawh_item_dim it ON it.physical_item_id = pea.physical_item_id 
        WHERE (pea.insert_date > my_lst_updt OR pea.update_date > my_lst_updt) 
            AND pea.physical_item_sn_id IS NOT NULL 
            AND pea.physical_item_sn_id > 0 
        GROUP BY pea.physical_item_id, 
            it.niin, 
            it.item_nomen_standard, 
            pea.sys_ei_sn, 
            pea.physical_item_sn_id  
        ORDER BY pea.physical_item_id ) tmp 
    ON (snc.physical_item_id = tmp.physical_item_id 
        AND snc.physical_item_sn_id = tmp.physical_item_sn_id)
    WHEN MATCHED THEN 
        UPDATE SET 
            touch_count = touch_count + 1, 
            update_by   = USER,
            update_date = SYSDATE 
    WHEN NOT MATCHED THEN
        INSERT (
                snc.physical_item_id,
                snc.niin,
                snc.physical_item_sn_id,
                snc.serial_number,
                snc.item_nomen_standard,
                snc.serial_number_new_flag,
                snc.new_period_data_flag,
                snc.status, 
                touch_count 
               )
        VALUES (
               tmp.physical_item_id, 
               tmp.niin,
               tmp.physical_item_sn_id,
               tmp.sys_ei_sn,
               tmp.item_nomen_standard, 
               'N', 
               'N',
               'W', 
               tmp.rec_cnt 
               ); 
               
    COMMIT;            
END;
/


SELECT * 
FROM   pfsawh_fact_ld_sn_cntrl
ORDER BY touch_count DESC;   

