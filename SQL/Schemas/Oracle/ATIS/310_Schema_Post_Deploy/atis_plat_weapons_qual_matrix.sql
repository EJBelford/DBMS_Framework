
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: atis_plat_weapons_qual_matrix
--      PURPOSE: Load data into the atis_plat_weapons_qual_matrix table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-01
--
--       SOURCE: atis_plat_weapons_qual_matrix.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-01 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM atis_plat_weapons_qual_matrix;

-- Default record --

INSERT INTO atis_plat_weapons_qual_matrix (
  pq_id, platform_id, weapon_id, crew_id, 
  qual_status_date, qual_status, qual_comments
) 
VALUES ( 0, 'UNK', 'Unknown Weapon' ); 

-- Load records --

INSERT INTO atis_plat_weapons_qual_matrix (
  pq_id, platform_id, weapon_id, crew_id, 
  qual_status_date, qual_status, qual_comments
)  
          SELECT 1, 7, 4, 1, TO_DATE('2017/06/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 2, 7, 4, 1, TO_DATE('2017/03/25', 'yyyy/mm/dd'), 'NQ', 'Crew Change' FROM DUAL 
UNION ALL SELECT 3, 7, 4, 1, TO_DATE('2016/12/12', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 4, 7, 4, 1, TO_DATE('2016/09/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 5, 7, 4, 2, TO_DATE('2017/06/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 6, 7, 4, 2, TO_DATE('2017/03/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 7, 7, 4, 2, TO_DATE('2016/12/12', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 8, 7, 4, 2, TO_DATE('2016/09/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 9, 7, 4, 3, TO_DATE('2017/06/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 10, 7, 4, 3, TO_DATE('2017/03/25', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 11, 7, 4, 3, TO_DATE('2016/12/12', 'yyyy/mm/dd'), 'Q', null FROM DUAL 
UNION ALL SELECT 12, 7, 4, 3, TO_DATE('2016/09/25', 'yyyy/mm/dd'), 'NQ', 'Crew Change' FROM DUAL ;

-- Test SELECT --

SELECT 
  pq_id, platform_id, weapon_id, crew_id, 
  qual_status_date, qual_status, qual_comments 
FROM atis_plat_weapons_qual_matrix;

