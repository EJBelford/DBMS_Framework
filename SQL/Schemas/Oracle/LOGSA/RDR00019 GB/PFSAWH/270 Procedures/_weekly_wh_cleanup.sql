/*----- pfsawh_item_dim -----*/ 


/*----- pfsawh_item_sn_dim -----*/ 

SELECT 
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    ) AS tot_rows, 
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  status = 'C'
    ) AS C_rows,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  status = 'H'
    ) AS H_rows,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  status = 'I'
    ) AS I_rows,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  status = 'Q'
    ) AS Q_rows,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  status = 'R' 
    ) AS R_rows,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  item_force_id = 0 
    ) AS force_0_errs,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  item_force_id < 0 
    ) AS force_1_errs,
    (
    SELECT COUNT(*) 
    FROM   pfsawh_item_sn_dim 
    WHERE  item_location_id < 1 
    ) AS loc_errs
FROM   dual;

SELECT status, COUNT(*) 
FROM   pfsawh_item_sn_dim 
GROUP BY status 
ORDER BY status; 

SELECT isd.status, 
    isd.physical_item_id, id.item_nomen_standard,  
    isd.physical_item_sn_id, isd.item_serial_number, 
    isd.item_force_id, 
    isd.item_location_id
    , '|', isd.* 
FROM   pfsawh_item_sn_dim isd 
JOIN pfsawh_item_dim id ON id.physical_item_id = isd.physical_item_id 
    AND id.status = 'C' 
WHERE  isd.status <> 'C'
ORDER BY isd.physical_item_id, isd.item_serial_number; 

SELECT isd.physical_item_id, 
    isd.physical_item_sn_id, 
    isd.item_uic, 
    isd.item_force_id, '|', 
    fud.force_unit_id, 
    fud.force_command_unit_code, 
    fud.force_command_unit_id 
FROM   pfsawh_item_sn_dim isd 
JOIN pfsawh_force_unit_dim fud ON fud.uic = isd.item_uic 
    AND fud.status = 'C' 
WHERE  isd.status = 'C' 
    AND isd.item_force_id < 1
ORDER BY item_uic DESC NULLS LAST, isd.physical_item_sn_id; 

/*

UPDATE pfsawh_item_sn_dim isd 
    SET (item_force_id,
        force_command_unit_code,  
        force_command_unit_id) = 
            (
            SELECT fud.force_unit_id, 
                fud.force_command_unit_code, 
                fud.force_command_unit_id 
            FROM  pfsawh_force_unit_dim fud 
            WHERE fud.uic = isd.item_uic 
                AND fud.status = 'C' 
            )
WHERE  isd.status = 'C' 
    AND isd.item_force_id < 1; 

COMMIT; 

*/


/* I have no clue what his was for */  

SELECT 
DISTINCT isd.item_niin, pid.physical_item_id, 
    COUNT(isd.item_niin)
FROM   pfsawh_item_sn_dim isd
LEFT OUTER JOIN pfsawh_item_dim pid ON isd.item_niin = pid.niin 
    AND pid.status = 'C' 
WHERE  isd.physical_item_id IS NOT NULL 
    OR isd.physical_item_id < 1 
GROUP BY isd.item_niin, pid.physical_item_id 
ORDER BY isd.item_niin; 

UPDATE pfsawh_item_sn_dim 
SET    physical_item_id = 305479
WHERE  item_niin = '014818579' 
    AND physical_item_id < 1; 
    
COMMIT; 
    
/*
   
DELETE pfsawh_item_sn_dim 
WHERE item_notes = 'PR_GET_PFSAWH_EARLIEST_RCDT_NI'; 
   
COMMIT; 

*/ 

/*----- Looks for Item SN that have more than 1 "C" status -----*/ 

SELECT item_niin, item_serial_number, COUNT(physical_item_sn_id) 
FROM   pfsawh_item_sn_dim 
WHERE  status = 'C'
GROUP BY item_niin, item_serial_number   
ORDER BY COUNT(physical_item_sn_id) DESC, 
    item_niin, item_serial_number; 
    
    
    
/*----- Force Unti Hidden Flag -----*/ 

SELECT uic, status, hidden_flag, hidden_date, hidden_by 
FROM   pfsawh_force_unit_dim  
WHERE  status = 'C' 
    AND hidden_flag = 'Y'; 
    

SELECT uic, status, hidden_flag, hidden_date, hidden_by 
FROM   pfsawh_force_unit_dim  
WHERE  status = 'C' 
    AND hidden_flag = 'N'; 
    

UPDATE pfsawh_force_unit_dim 
SET    hidden_flag = 'N', 
       hidden_date = SYSDATE, 
       hidden_by   = 'GBelford' 
WHERE  status = 'C' 
    AND hidden_flag = 'Y'
    AND force_unit_id <> 0; 
    
/*----- Test for Item SN that have a Item Id < 0 -----*/    

SELECT isd.item_niin, 
    isd.physical_item_id, 
    COUNT(isd.physical_item_id) AS item_id_zero, 
    (
    SELECT 
    DISTINCT isd2.physical_item_id 
    FROM   pfsawh_item_sn_dim isd2 
    WHERE  isd2.item_niin = isd.item_niin 
        AND isd2.physical_item_id > 0 
    ) AS item_id_not_zero, 
    (
    SELECT COUNT(isd.physical_item_id) 
    FROM   pfsawh_item_sn_dim isd2 
    WHERE  isd2.item_niin = isd.item_niin 
        AND isd2.physical_item_id > 0 
    ) AS cnt_item_id_not_zero    
FROM   pfsawh_item_sn_dim isd
WHERE  isd.physical_item_id IS NULL 
    OR  isd.physical_item_id < 1 
GROUP BY isd.item_niin, isd.physical_item_id 
ORDER BY isd.item_niin; 

/*

DELETE pfsawh_item_sn_dim 
WHERE  item_niin = '013900529'
    AND physical_item_id < 1; 

COMMIT; 

UPDATE pfsawh_item_sn_dim 
SET    physical_item_id = 141222 
WHERE  item_niin = '013469317'
    AND physical_item_id < 1; 
    
*/ 
