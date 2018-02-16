-- Figure A-4 

SELECT ft.*  
FROM   gb_pfsawh_item_sn_p_fact ft 
WHERE  ft.physical_item_id = 141223; 


SELECT 
     ft.item_date_to_id, 
     dt0.calendar_month_name_char3 || '-' || dt0.calendar_year AS period, 
     COUNT(ft.rec_id) AS row_cnt, 
     ft.item_force_id, 
     ft.item_location_id, 
     ft.item_location_id, 
     lcd.st_cntry_name,    
     SUM(ft.period_hrs), 
     SUM(ft.item_days), 
     SUM(ft.period_hrs) / SUM(ft.item_days) AS quantity, 
     SUM(ft.fmc_hrs), 
     ROUND((SUM(ft.fmc_hrs) / SUM(ft.period_hrs)) * 100, 0) AS FMC_PCT, 
     SUM(ft.nmcm_hrs), 
     100 - ROUND((SUM(ft.fmc_hrs) / SUM(ft.period_hrs)) * 100, 0) 
     - ROUND((SUM(ft.nmcs_hrs) / SUM(ft.period_hrs)) * 100, 0) AS NMCM_PCT_ADJ,   
     ROUND((SUM(ft.nmcm_hrs) / SUM(ft.period_hrs)) * 100, 0) AS NMCM_PCT, 
     SUM(ft.nmcs_hrs), 
     ROUND((SUM(ft.nmcs_hrs) / SUM(ft.period_hrs)) * 100, 0) AS NMCS_PCT  
FROM   gb_pfsawh_item_sn_p_fact ft 
LEFT OUTER JOIN gb_pfsawh_date_dim dt0 ON ft.item_date_to_id = dt0.date_id 
LEFT OUTER JOIN gb_pfsawh_location_dim lcd ON lcd.geo_id = ft.item_location_id
WHERE  ft.physical_item_id = 141223 
GROUP BY ft.item_date_to_id, dt0.calendar_month_name_char3, dt0.calendar_year, 
    ft.item_force_id, 
    ft.item_location_id, lcd.st_cntry_name
ORDER BY ft.item_date_to_id; 


-- Figure A-7  


SELECT ft.*  
FROM   gb_pfsawh_item_sn_p_fact ft 
WHERE  ft.item_sys_ei_id = 141223  
    AND ft.item_date_to_id = 31137 
    AND ft.period_hrs <> ft.fmc_hrs; 


-- Figure A-9  



