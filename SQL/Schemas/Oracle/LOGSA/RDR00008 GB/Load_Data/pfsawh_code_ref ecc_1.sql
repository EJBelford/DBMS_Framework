BEGIN

    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, '0',    1, 'Select one...'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'A',    2, 'A - AIRCRAFT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'B',    3, 'B - AIR DEFENSE SYSTEM'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'C',    4, 'C - MISSILE SYSTEMS LAND COMBAT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'D',    5, 'D - ARTILLERY WEAPONS'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'E',    6, 'E - SMALL ARMS'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'F',    7, 'F - TANKS'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'G',    8, 'G - COMBAT VEHICLES'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'H',    9, 'H - TACTICAL VEHICLES'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'J',   10, 'J - COMMUNICATIONS AND ELECTRONIC EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'K',   11, 'K - ELECTRONIC TEST EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'L',   12, 'L - FLOATING EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'M',   13, 'M - RAILWAY EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'N',   14, 'N - CONSTRUCTION EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'O',   15, 'O - MEDICAL AND DENTAL EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'P',   26, 'P - MATERIAL HANDLING EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'Q',   17, 'Q - SUPPORT EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'R',   18, 'R - AMMUNITION AND AMMUNITION EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'S',   19, 'S - INSTALLATIONS DEPOT PECULIAR SERVICE EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'T',   20, 'T - MACHINE TOOLS'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'U',   21, 'U - SHOP SUPPORT EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'V',   22, 'V - NON-TACTICAL WHEEL VEHICLE (COMMERCIAL DESIGN)'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'W',   23, 'W - FURNITURE AND APPLIANCES'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'X',   24, 'X - OFFICE EQUIPMENT'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'Y',   25, 'Y - TOOLS NOT CLASSIFIED ELSEWHERE'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, 'Z',   26, 'Z - EQUIPMENT NOT LISTED ELSEWHERE'); 
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1015, '-1',  27, 'Unknwn'); 
    
    COMMIT; 
    
END;

SELECT catcode, itemcode, codeSortOrder, itemtext 
FROM gb_pfsawh_code_ref 
WHERE catcode = 1015 
ORDER BY codeSortOrder;
