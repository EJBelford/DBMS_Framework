BEGIN

    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, '0',    1, 'Select one...');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'I',    2, 'I    - Subsistence, gratuitous health and comfort items.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'II',   3, 'II   - Clothing, individual equipment, tentage, organizational tool sets and kits, hand tools, unclassified maps, administrative and housekeeping supplies and equipment.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'III',  4, 'III  - Petroleum, fuels, lubricants, hydraulic and insulating oils, preservatives, liquids and gases, bulk chemical products, coolants, deicer and antifreeze compounds, components, and additives of petroleum and chemical products, and coal.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'IV',   5, 'IV   - Construction materials, including installed equipment, and all fortification and barrier materials.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'V',    6, 'V    - Ammunition of all types, bombs, explosives, mines, fuzes, detonators, pyrotechnics, missiles, rockets, propellants, and associated items.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'VI',   7, 'VI   - Personal demand items (such as health and hygiene products, soaps and toothpaste, writing material, snack food, beverages, cigarettes, batteries, and cameras—nonmilitary sales items).');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'VII',  8, 'VII  - Major end items such as launchers, tanks, mobile machine shops, and vehicles.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'VIII', 9, 'VIII - Medical materiel including repair parts peculiar to medical equipment.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'IX',  10, 'IX   - Repair parts and components to include kits, assemblies, and subassemblies (repairable or non-repairable) required for maintenance support of all equipment.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'X',   11, 'X    - Material to support nonmilitary programs such as agriculture and economic development (not included in Classes I through IX).)');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, 'M',   12, 'M    - Miscellaneous Water, salvage, and captured material.');
    
    INSERT INTO gb_pfsawh_code_ref (catcode, itemcode, codeSortOrder, itemtext) 
    VALUES (1013, '-1',  13, 'Unknown.'); 
    
    COMMIT;
    
END;
    
-- SELECT * FROM gb_pfsawh_code_ref WHERE catcode = 1013 ORDER BY  codeSortOrder; 
    
