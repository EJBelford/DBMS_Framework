SELECT poh.uic, poh.pfsa_org,  poh.cmd_uic, 
    '|', poh.* 
FROM   pfsa_org_hist2@PFSAW.LIDB poh
ORDER BY poh.uic;



SELECT poh.pfsa_org, poh.cmd_uic, COUNT(poh.cmd_uic)  
FROM   pfsa_org_hist2@PFSAW.LIDB poh
WHERE  LENGTH(poh.pfsa_org) = 6 
    AND LENGTH(poh.cmd_uic) = 6
GROUP BY poh.pfsa_org, poh.cmd_uic
ORDER BY poh.pfsa_org, COUNT(poh.cmd_uic) DESC;



SELECT poh.uic, poh.cmd_uic, COUNT(poh.cmd_uic)  
FROM   pfsa_org_hist2@PFSAW.LIDB poh
GROUP BY poh.uic, poh.cmd_uic
ORDER BY poh.uic, COUNT(poh.cmd_uic) DESC;



SELECT 
DISTINCT  UPPER(poh.cmd_uic) 
FROM   pfsa_org_hist2@PFSAW.LIDB poh
ORDER BY UPPER(poh.cmd_uic);



SELECT fud.uic, fud.force_command_unit_code,   
    ( 
    SELECT 
    DISTINCT poh.cmd_uic 
    FROM   pfsa_org_hist2@PFSAW.LIDB poh 
    WHERE  poh.pfsa_org = fud.uic 
        AND LENGTH(poh.cmd_uic) = 6 
        AND day_date_thru = TO_DATE('31-DEC-4712', 'DD-MON-YYYY')
    ) AS cmd_uic,   
    '|', fud.* 
FROM   pfsawh_force_unit_dim fud
WHERE  fud.status = 'C' 
    AND fud.force_command_unit_code IS NULL;

UPDATE pfsawh_force_unit_dim fud 
SET    fud.force_command_unit_code = 
        ( 
        SELECT 
        DISTINCT poh.cmd_uic 
        FROM   pfsa_org_hist2@PFSAW.LIDB poh 
        WHERE  poh.pfsa_org = fud.uic 
            AND LENGTH(poh.cmd_uic) = 6 
            AND day_date_thru = TO_DATE('31-DEC-4712', 'DD-MON-YYYY')
        ) 
WHERE  fud.status = 'C' 
    AND fud.force_command_unit_code IS NULL; 
    

SELECT 
DISTINCT fud.force_command_unit_code, 
    fud.force_command_unit_id   
--    , '|', fud.* 
FROM   pfsawh_force_unit_dim fud 
WHERE  fud.status = 'C' 
    AND fud.force_command_unit_code IS NOT NULL
    AND fud.force_command_unit_id IS NULL
ORDER BY fud.force_command_unit_code; 


SELECT 
DISTINCT fud.force_command_unit_code, 
    fud.force_command_unit_id, 
    poh.pfsa_org    
FROM   pfsawh_force_unit_dim fud 
LEFT OUTER JOIN pfsa_org_hist2@PFSAW.LIDB poh ON poh.pfsa_org = fud.force_command_unit_code 
WHERE  fud.status = 'C' 
    AND fud.force_command_unit_code IS NOT NULL
    AND fud.force_command_unit_id IS NULL
ORDER BY fud.force_command_unit_code;
    

SELECT pea.pfsa_org, fud.force_command_unit_code, 
    pea.* 
FROM   frz_pfsa_equip_avail pea   
LEFT OUTER JOIN  pfsawh_force_unit_dim fud ON fud.force_command_unit_code = pea.pfsa_org AND fud.status = 'C' 
WHERE  pea.physical_item_id = 141143
    AND pea.pba_id in  (1000006, 1000007);
    

SELECT 
DISTINCT pea.pfsa_org, fud.force_command_unit_code  
--    , pea.* 
FROM   pfsa_equip_avail pea   
LEFT OUTER JOIN  pfsawh_force_unit_dim fud ON fud.force_command_unit_code = pea.pfsa_org AND fud.status = 'C' 
WHERE  pea.physical_item_id = 141143;


SELECT 
DISTINCT pea.physical_item_id, 
    pea.sys_ei_sn, 
    pea.physical_item_sn_id, 
    pea.sys_ei_sn, 
    fud.force_command_unit_code, fud.force_command_unit_id   
FROM   pfsa_equip_avail pea,    
    pfsawh_force_unit_dim fud  
WHERE  pea.physical_item_id = 141143
    AND pea.physical_item_sn_id > 0
    AND pea.pfsa_org = fud.force_command_unit_code 
    AND fud.status = 'C' 
    AND fud.force_command_unit_id IS NOT NULL
ORDER BY pea.physical_item_sn_id;  



SELECT 
DISTINCT pea.physical_item_id, 
    pea.physical_item_sn_id, 
    fud.force_command_unit_code, fud.force_command_unit_id   
FROM   pfsawh_item_sn_p_fact pea,    
    pfsawh_force_unit_dim fud  
WHERE  pea.physical_item_id = 141143
    AND pea.physical_item_sn_id > 0
    AND pea.item_force_id = fud.force_command_unit_id 
    AND fud.status = 'C' 
    AND fud.force_command_unit_id IS NOT NULL
ORDER BY pea.physical_item_sn_id;  


    