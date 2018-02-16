
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: generic_sys_dict_load
--      PURPOSE: Load data into the generic_sys_dict table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-11
--
--       SOURCE: generic_sys_dict_load.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details
-- 2017-12-11 - Gene Belford  -             - Created 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM generic_sys_dict;

-- Default record --

INSERT INTO generic_sys_dict ( sys_dict_nm, sys_dict_desc, sys_dict_sort_ordr, 
    sys_dict_abbr_flg, sys_dict_acro_flg, sys_dict_dict_flg
    ) 
VALUES ( 'Blank', 'Placeholder for a new entry.', -1, 'N', 'N', 'N' ); 

-- Load records --

INSERT INTO generic_sys_dict ( sys_dict_nm, sys_dict_desc, sys_dict_sort_ordr, 
    sys_dict_abbr_flg, sys_dict_acro_flg, sys_dict_dict_flg
	) 
          SELECT 'FM 7-15', 'Army Universal Task List', 1, 'N', 'N', 'N'  FROM dual;

-- Test SELECT --

SELECT  sys_dict_nm, sys_dict_desc, sys_dict_sort_ordr, 
    sys_dict_abbr_flg, sys_dict_acro_flg, sys_dict_dict_flg  
FROM generic_sys_dict;

