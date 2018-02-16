--
-- TMP_EARLIEST_ITEM_SN_FACT  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE tmp_earliest_item_sn_fact 
(
  source_table                   VARCHAR2(30),
  sys_ei_niin                    VARCHAR2(9),
  physical_item_id               NUMBER, 
  sys_ei_sn                      VARCHAR2(48),
  physical_item_sn_id            NUMBER, 
  min_date                       DATE
)
ON COMMIT PRESERVE ROWS
NOCACHE;




SELECT 'bld_pfsa_sn_ei_hist', 
    sys_ei_niin, 
    sys_ei_sn, 
    MIN(TO_CHAR(event_dt_time, 'DD-MON-YYYY')) AS min_date
FROM   bld_pfsa_sn_ei_hist@PFSAW.LIDB  
WHERE  sys_ei_niin = '013285964' 
GROUP BY sys_ei_niin, sys_ei_sn  
ORDER BY sys_ei_sn; 

SELECT 'pfsa_equip_avail', 
    sys_ei_niin, 
    sys_ei_sn, 
    MIN(from_dt) AS min_date
FROM   pfsa_equip_avail@PFSAW.LIDB 
WHERE  sys_ei_niin = '013285964' 
GROUP BY sys_ei_niin, sys_ei_sn  
ORDER BY sys_ei_sn; 


