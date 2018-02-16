
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: generic_sys_dict_ref
--      PURPOSE: Load data into the generic_sys_dict_ref% table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-11
--
--       SOURCE: generic_sys_dict_ref_load.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         2017-12-11
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-11 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM generic_sys_dict_ref;

-- Default record --

INSERT INTO generic_sys_dict_ref ( term, term_status, term_cat_1, term_acro_1, 
    term_sort_ordr, term_def, term_source, term_date, term_example_1, 
	term_note_1 
    ) 
VALUES ( ' ', 'A', 'N', 'N', -1, 'N/A', 'N/A', '', 'N/A', 'N/A' ); 

-- Load records --

INSERT INTO generic_sys_dict_ref ( term, term_status, term_cat_1, term_acro_1, 
    term_sort_ordr, term_def, term_source, term_date, term_example_1, 
	term_note_1 
	) 
          SELECT 'AAFES', 'A', 'N', 'N', 0, 'Army and Air Force Exchange Service', 'FM 7-15', 'February 2009', 'N/A', 'N/A' FROM DUAL 
UNION ALL SELECT 'A/DACG', 'A', 'N', 'N', 5, 'arrival/departure airfield control group', 'FM 7-15', 'February 2009', 'N/A', 'N/A' FROM DUAL 
UNION ALL SELECT 'ALSA', 'A', 'N', 'N', 10, 'Air Land Sea Application Center', 'FM 7-15', 'February 2009', 'N/A', 'N/A' FROM DUAL  
UNION ALL SELECT 'ATIS', 'A', 'N', 'N', 10, 'Army Training Information System', 'N/A', 'N/A', 'N/A', 'N/A' FROM DUAL ;

-- Test SELECT --

SELECT term, term_status, term_cat_1, term_acro_1, 
    term_sort_ordr, term_def, term_source, term_date, term_example_1, 
	term_note_1 
FROM generic_sys_dict_ref;

