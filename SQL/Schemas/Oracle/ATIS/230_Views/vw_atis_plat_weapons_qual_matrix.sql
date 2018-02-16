CREATE OR REPLACE FORCE EDITIONABLE VIEW "vw_atis_plat_weapons_qual_matrix" 
  (
  pq_id, 
  platform_name,
  model_name,
  crew_id, 
  qual_status_date, 
  qual_status, 
  qual_comments
  ) 
  
AS 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: vw_atis_plat_weapons_qual_matrix
--      PURPOSE: %Description%
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-01
--
--       SOURCE: vw_atis_plat_weapons_qual_matrix.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- 2017-12-01 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 230 Views  -----*/

-- DROP VIEW vw_atis_plat_weapons_qual_matrix;

SELECT 
  apwqm.pq_id, 
  -- apwqm.platform_id, 
  apr.platform_name,
  -- apwqm.weapon_id, 
  awr.model_name,
  apwqm.crew_id, 
  apwqm.qual_status_date, 
  apwqm.qual_status, 
  NVL(apwqm.qual_comments, ' ') AS qual_comments 
FROM atis_plat_weapons_qual_matrix apwqm
LEFT OUTER JOIN atis_platforms_ref apr ON apwqm.platform_id = apr.platform_id
LEFT OUTER JOIN atis_weapons_ref awr ON apwqm.weapon_id = awr.weapon_id
ORDER BY apwqm.platform_id, 
  apwqm.weapon_id, 
  apwqm.crew_id, 
  apwqm.qual_status_date DESC;
