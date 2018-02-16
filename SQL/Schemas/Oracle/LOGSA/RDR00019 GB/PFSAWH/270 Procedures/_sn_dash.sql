SELECT item_serial_number, 
    INSTR(item_serial_number, '-') AS dash,  
    CASE INSTR(item_serial_number, '-') 
        WHEN 0 THEN 
            ''
        ELSE 
            item_serial_number
    END AS item_sn_w_dashes,
    REPLACE(item_serial_number, '-') AS item_sn_wo_dashes  
FROM   pfsawh_item_sn_dim
ORDER BY INSTR(item_serial_number, '-') DESC;