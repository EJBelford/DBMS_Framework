CREATE OR REPLACE FORCE EDITIONABLE VIEW atis.vw_atis_personnel_roster 
  ("UIC_NAME", "RANK_ABBR", "LNAME", "FNAME", "MOS_P", "MOS_SPECIALTY", "UIC") 
  
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
--         NAME: vw_atis_personnel_roster_seq
--      PURPOSE: REC_ID sequence for vw_atis_personnel_roster
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-11-30
--
--       SOURCE: vw_atis_personnel_roster.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     vw_atis_personnel_roster
--    Sysdate:         2017-11-30
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details
-- 2017-11-30 - Gene Belford  - RDPTSK00xxx - Created 
-- 2017-12-05 - Gene Belford  - RDPTSK00xxx - Updated with proper UIC fields. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- Sequence  -----*/

-- DROP VIEW vw_atis_personnel_roster_seq;

SELECT aor.dispname,
  arr.rank_abbr, 
  apr.lname, 
  apr.fname, 
  apr.mos_p, 
  amr.mos_specialty, 
  apr.uic   
  -- , apr.*
  -- , amr.*
FROM atis_personnel_ref apr 
LEFT OUTER JOIN atis_mos_ref amr ON TRIM(apr.mos_p) = TRIM(amr.mos_code)
LEFT OUTER JOIN atis_ranks_ref arr ON apr.rank_id = arr.rank_id 
LEFT OUTER JOIN atis_organizations_ref aor ON apr.uic = aor.uic 
ORDER BY apr.uic, apr.rank_id;
