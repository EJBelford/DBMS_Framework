BEGIN

    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, '-1', 1, 'Select one...'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, '0', 2, 'DLA'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'A', 3, 'N/A'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'B', 4, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'C', 5, 'USAMMA'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'D', 6, 'OSC'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'E', 7, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'F', 8, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'G', 9, 'CECOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'H', 10, 'AMCOM, AVIATION'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'J', 11, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'K', 12, 'TACOM, WARREN'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'L', 13, 'AMCOM, MISSILES'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'M', 14, 'TACOM, ROCK ISLAND'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'N', 15, 'CECOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'O', 16, 'DLA'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'P', 17, 'CECOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'Q', 18, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'R', 19, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'S', 20, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'T', 21, 'SBCCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'U', 22, 'CECOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'V', 23, 'ARMY ENGINEERS'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'W', 24, 'SOFSA'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'X', 25, 'STRICOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, 'Z', 26, 'SOCOM'); 
    INSERT INTO gb_pfsawh_code_ref (cat_code, item_code, code_sort_order, item_text) VALUES (1018, '99', 27, 'Unknown'); 

    COMMIT; 
    
    UPDATE gb_pfsawh_code_ref a
    SET    (status, updt_by, lst_updt) = 
        (    
        SELECT mc1.status, mc1.updt_by, mc1.lst_updt 
        FROM   mat_cat_1_ref@pfsawh.lidbdev mc1 
        WHERE  mc1.mat_cat_cd_1 = a.item_code
        )
    WHERE cat_code = 1018; 
    
    COMMIT; 
    
END; 

/*

SELECT cat_code, item_code, code_sort_order, item_text 
FROM gb_pfsawh_code_ref 
WHERE cat_code = 1018 
ORDER BY code_sort_order; 

*/

