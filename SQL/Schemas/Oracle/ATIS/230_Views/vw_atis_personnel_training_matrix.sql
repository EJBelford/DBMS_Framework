CREATE OR REPLACE FORCE EDITIONABLE VIEW "vw_atis_personnel_training_matrix.sql" 
  (
  pt_id, 
  individual, 
  training_event_name,   
  event_date, 
  score, 
  pass_fail
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
--         NAME: vw_atis_personnel_training_matrix.sql
--      PURPOSE: %Description%
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-01
--
--       SOURCE: vw_atis_personnel_training_matrix.sql.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     vw_atis_personnel_training_matrix.sql
--    Sysdate:         2017-12-01
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- 2017-12-01 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 230_Views -----*/

-- DROP VIEW vw_atis_personnel_training_matrix.sql;

SELECT aptm.pt_id, 
  -- aptm.person_id,  
  apr.lname || ', ' || apr.fname AS individual, 
  -- aptm.training_event_id, 
  ater.training_event_name, 
  aptm.event_date, 
  NVL(aptm.score, 0) AS score, 
  aptm.pass_fail 
FROM atis_personnel_training_matrix aptm 
LEFT OUTER JOIN atis_personnel_ref apr ON aptm.person_id = apr.person_id
LEFT OUTER JOIN atis_training_events_ref ater ON aptm.training_event_id = ater.training_event_id
WHERE aptm.person_id <> 0 
ORDER BY aptm.event_date DESC, aptm.training_event_id, aptm.person_id;