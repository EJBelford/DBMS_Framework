BEGIN

    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '-1', 0, 'Select one...'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '0', 1, 'DLA/GSA MATERIEL');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '1', 2, 'FROM PURGED MDR');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '2', 3, 'MISSILE CLASS V COMPONENTS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '3', 4, 'MISSILE CLASS V COMPONENTS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '4', 5, 'COMMUNICATIONS SYSTEM AGENCY AND SATELLITE COMMUNICATIONS AGENCY EQUIPMENT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '5', 6, 'COMMUNICATIONS SYSTEMS EQUIPMENT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '6', 7, 'INDIVIDUAL AND CREW-SERVED WEAPONS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '7', 8, 'COMMUNICATIONS SYSTEMS EQUIPMENT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '8', 9, 'TRAINING DEVICES, SIMULATIONS AND SIMULATORS');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '9', 10, 'SIGNAL INTELLIGENCE');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'A', 11, 'FIXED WING AIRCRAFT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'B', 12, 'ROTARY WING AIRCRAFT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'C', 13, 'OTHER AIRCRAFT CATEGORIES.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'D', 14, 'SURFACE TO AIR MISSILES.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'E', 15, 'SURFACE TO SURFACE MISSILES.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'F', 16, 'OTHER MISSILE RELATED MATERIAL.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'G', 17, 'ARTILLERY.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'H', 18, 'INDIVIDUAL AND CREW SERVED WEAPONS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'I', 19, 'CONSTRUCTION EQUIPMENT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'J', 20, 'TANKS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'K', 21, 'COMBAT VEHICLES.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'L', 22, 'OTHER WEAPONS CATEGORIES.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'M', 23, 'ARMORED CARRIERS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'N', 24, 'TACTICAL VEHICLES');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'P', 25, 'OTHER AUTOMOTIVE CATEGORIES.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'Q', 26, 'AVIONICS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'R', 27, 'TACTICAL AND STRATEGIC COMMUNICATIONS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'S', 28, 'SURVEILLANCE, TARGET ACQUISITION, AND NIGHT OBSERVATION.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'T', 29, 'OTHER ELECTRONICS EQUIPMENT.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'U', 30, 'POL, SOLDIER AND COMBAT SUPPORT SYSTEMS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'V', 31, 'POWER GENERATION SYSTEMS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'W', 32, 'LINE OF COMMUNICATION AND BASE SUPPORT SYSTEMS.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'X', 33, 'SPECIAL AMMUNITION.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'Y', 34, 'CONVENTIONAL AMMUNITION.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, 'Z', 35, 'OTHER MUNITIONS/CHEMICAL, BIOLOGICAL, RADIOLOGICAL (CBR) CATEGORIES.'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1016, '99', 36, 'Unknown'); 

    
    COMMIT;
    
    UPDATE gb_pfsawh_code_ref a
    SET    (status, updt_by, lst_updt) = 
        (    
        SELECT mc4.status, mc4.updt_by, mc4.lst_updt 
        FROM   mat_cat_4_ref@pfsawh.lidbdev mc4 
        WHERE  mc4.mat_cat_cd_4 = a.item_code
        )
    WHERE cat_code = 1016; 
    
    COMMIT; 
    
END;    

SELECT cat_code, item_code, item_text, 
    status, fn_pfsawh_get_code_ref_desc(1003, status) AS status_desc, 
    updt_by, lst_updt, code_sort_order   
FROM gb_pfsawh_code_ref 
WHERE cat_code = 1016 
ORDER BY code_sort_order;

SELECT df.cat_code, 
    df.code_name, 
    COUNT(cd.item_code) AS CNT, 
    MIN(cd.item_code)   AS MIN, 
    MAX(cd.item_code)   AS MAX,  
    MAX(LENGTH(cd.item_code))   AS LEN_CODE,  
    MAX(LENGTH(cd.item_text))   AS LEN_TEXT 
    --, cd.* 
FROM	gb_pfsawh_code_definition_ref df, 
       gb_pfsawh_code_ref cd 
WHERE  df.cat_code = cd.cat_code  (+)
GROUP BY df.cat_code, 
    df.code_name 
ORDER BY df.cat_code; 