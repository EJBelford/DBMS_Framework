SELECT   pea.sys_ei_niin, pea.sys_ei_sn, 
    MIN(insert_date), 
    COUNT(rec_id)   
FROM     pfsa_equip_avail pea
WHERE    pea.physical_item_sn_id < 1
GROUP BY pea.sys_ei_niin, pea.sys_ei_sn
ORDER BY pea.sys_ei_niin, pea.sys_ei_sn; 


/*
  WARNING_TYPE    VARCHAR2(32 BYTE),
  WARNING_FROM    VARCHAR2(100 BYTE),
  WARNING_MSG     VARCHAR2(2000 BYTE),
  WARNING_STATUS  VARCHAR2(1 BYTE),
  WARNING_TIME    DATE,
*/

MERGE 
INTO  pfsawh_functional_warnings pfw
USING (
        SELECT   pea.sys_ei_sn 
            || ' ~ ' || pea.sys_ei_niin 
            || ' ~ ' || pea.physical_item_id AS warning_msg, 
            MIN(insert_date) AS min_insert_date, 
            COUNT(rec_id)   
        FROM     pfsa_equip_avail pea
        WHERE    pea.physical_item_sn_id < 1
        GROUP BY pea.sys_ei_niin, pea.sys_ei_sn, pea.physical_item_id
        ORDER BY pea.sys_ei_niin, pea.sys_ei_sn  
      ) tmp 
ON (pfw.warning_msg = tmp.warning_msg 
    AND pfw.warning_status = 'C'
    )
WHEN MATCHED THEN 
    UPDATE 
    SET  pfw.warning_time = min_insert_date
WHEN NOT MATCHED THEN
    INSERT ( 
        warning_type,
        warning_from,
        warning_msg,
        warning_status,
        warning_time 
           ) 
    VALUES ( 
           'Missing Item SN dim entry',
           'PFSA_EQUIP_AVAIL (-1 Item SN dim entry)',
           tmp.warning_msg, 
           'C', 
           tmp.min_insert_date
           );
/

SELECT  
DISTINCT TO_CHAR(MIN(warning_time), 'YYYY-MM-DD') AS warning_date, 
    warning_msg, 
    warning_type, 
    warning_from   
FROM    pfsawh_functional_warnings 
WHERE   warning_status = 'C' 
GROUP BY warning_type, warning_from, warning_msg
ORDER BY warning_type, warning_msg, 
    TO_CHAR(MIN(warning_time), 'YYYY-MM-DD'); 
    
    
