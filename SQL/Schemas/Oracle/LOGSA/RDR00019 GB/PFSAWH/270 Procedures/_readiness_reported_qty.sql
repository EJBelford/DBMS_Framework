SELECT ROUND(f.item_days / (f.item_date_to_id - f.item_date_from_id)),
    f.item_days, f.item_date_to_id, f.item_date_from_id, '|', f.* 
FROM   pfsawh_item_sn_p_fact f
WHERE  -- f.physical_item_id = 141147 AND 
    item_days IS NOT NULL;

UPDATE pfsawh_item_sn_p_fact 
SET    readiness_reported_qty = ROUND(item_days / (item_date_to_id - item_date_from_id)) 
WHERE  item_days IS NOT NULL; 

COMMIT; 