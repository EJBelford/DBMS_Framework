CREATE OR REPLACE FORCE EDITIONABLE VIEW "vw_atis_mission_assessment_matrix" 
  (
  "MISSION_ASSESSMENT_ID", 
  "OPER_PLAN_DESC",
  "MET_ASSESSMENT",
  "MET_ASSESSMENT_DATE", 
  "MET_CODE",
  "MET_DESC"
  ) 
  
AS 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                            Copyright, US Army, 2017
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: vw_atis_mission_assessment_matrix
--      PURPOSE: %Description%
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-07
--
--       SOURCE: vw_atis_mission_assessment_matrix.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     vw_atis_mission_assessment_matrix
--    Sysdate:         2017-12-07
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- 2017-12-07 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 230 Views  -----*/

-- DROP VIEW vw_atis_mission_assessment_matrix;

SELECT aomam.mission_assessment_id, 
    -- aomam.oper_plan_id,
    aopr.oper_plan_desc,
    aomam.met_assessment,
    aomam.met_assessment_date, 
    aomam.met_code,
    metr.met_desc
--    , '|', aomam.* 
FROM atis_operational_mission_assessment_matrix aomam 
LEFT OUTER JOIN atis_operation_plans_ref aopr 
    ON aomam.oper_plan_id = aopr.oper_plan_id 
LEFT OUTER JOIN mission_essential_tasks_ref metr 
    ON aomam.met_code = metr.met_code  
ORDER BY aomam.oper_plan_id,
    aomam.met_code;
	