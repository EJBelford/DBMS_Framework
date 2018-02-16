BEGIN 

    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '-1',  1, 'Select one...');   
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '0',   2, 'Not reportable under CBS-X, SIMS-X, or UIT.');   
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '1',   3, 'Deleted.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '2',   4, 'Selected TOE/MTOE/TDA/CTA/JTA Authorized Items (including NSNs of a generic family) and non-authorized and obsolete items designated by Commodity Managers for management under CBS-X. This category includes major items on which data are required for the Army Materiel Plan and selected type classified secondary items and repair parts that require special control by commodity managers due to their importance and criticality. This category requires no serial number tracking.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '3',   5, 'Deleted.');
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '8',   6, 'Army-managed items selected and designated by AMC MRCs for intensive management under SIMS-X per AR 710-1 . Does not require serial number tracking.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'A',   7, 'Same as RICC 2, except asset requires serial number tracking for visibility.'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'B',   8, 'Same as RICC 2, except asset requires serial number tracking for maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'C',   9, 'Same as RICC 2, except asset requires serial number tracking for both supply visibility and maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'D',  10, 'Same as RICC 8 except asset requires serial number tracking for supply visibility.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'E',  11, 'Same as RICC 8 except asset requires serial number tracking for maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'F',  12, 'Same as RICC 8 except asset requires serial number tracking for both supply visibility and maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'G',  13, 'Asset requires no CBS-X or SIMS-X reporting, but does require serial number tracking for supply visibility.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'H',  14, 'Asset requires no CBS-X or SIMS-X reporting, but does require serial number tracking for maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'J',  15, 'Asset requires no CBS-X or SIMS-X reporting, but does require serial number tracking for both supply visibility and maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'K',  16, 'Same as RICC 2. Asset does not require serial number tracking, but contains installed component(s) that require serial number tracking for supply visibility.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'L',  17, 'Same as RICC 2. Asset does not require serial number tracking, but contains installed component(s) that require serial number tracking for maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'M',  18, 'Same as RICC 2, Asset does not require serial number tracking, but contains installed component(s) that require serial number tracking for both supply visibility and maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'N',  19, 'Same as RICC 0, except asset contains installed component(s) that require serial number tracking.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'P',  20, 'Same as RICC A, except asset contains installed component(s) that require serial number tracking for supply visibility.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'Q',  21, 'Same as RICC A, except asset contains installed component(s) that require serial number tracking for maintenance data.'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'R',  22, 'Same as RICC A, except asset contains installed component(s) that require serial number tracking for both supply visibility and maintenance data.');  
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, 'Z',  23, 'Asset has been type classified obsolete, but still requires CBS-X tracking.'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1017, '99', 24, 'Unknown'); 

    COMMIT; 

END;

/*

SELECT cat_code, item_code, code_sort_order, item_text 
FROM gb_pfsawh_code_ref 
WHERE cat_code = 1017 
ORDER BY code_sort_order; 

*/

