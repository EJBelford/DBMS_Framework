/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: vw_platform_crew_matrix
--      PURPOSE: %Description%
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-11-30
--
--       SOURCE: vw_platform_crew_matrix.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     vw_platform_crew_matrix
--    Sysdate:         2017-11-30
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- 2017-11-30 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- Sequence -----*/

-- DROP VIEW %YourObjectName%;

CREATE OR REPLACE FORCE EDITIONABLE VIEW vw_platform_crew_matrix 
  ( crew_id, lname, model_name, platform_name ) 
  
AS 

SELECT apcm.crew_id,
  -- apcm.person_id, 
  apr.lname,
  -- apcm.weapon_id,
  awr.model_name,
  -- apcm.platform_id,
  aplr.platform_name
--  , '|', apcm.* 
FROM atis_platform_crew_matrix apcm 
LEFT OUTER JOIN atis_personnel_ref apr ON apcm.person_id = apr.person_id
LEFT OUTER JOIN atis_weapons_ref awr ON apcm.weapon_id = awr.weapon_id
LEFT OUTER JOIN atis_platforms_ref aplr ON apcm.platform_id = aplr.platform_id
ORDER BY apcm.crew_id,
  apcm.platform_id, 
  apcm.weapon_id, 
  apcm.person_id;
