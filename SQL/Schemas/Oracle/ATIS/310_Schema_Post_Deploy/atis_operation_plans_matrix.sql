
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: atis_operation_plans_matrix
--      PURPOSE: Load data into the atis_operation_plans_matrix table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: atis_operation_plans_matrix.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         2017-12-04
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM atis_operation_plans_ref;

-- Load records --

INSERT INTO atis_operation_plans_ref (oper_plan_id, oper_plan_desc, oper_date_last_approved, oper_plan_status, oper_mission_stmt) 
          SELECT 1, 'Plan_00', TO_DATE('2017/07/10', 'yyyy/mm/dd'), 'Approved', 'TBD' FROM DUAL 
UNION ALL SELECT 2, 'Plan_07', TO_DATE('2017/07/10', 'yyyy/mm/dd'), 'Approved', 'TBD' FROM DUAL 
UNION ALL SELECT 3, 'Plan_20', TO_DATE('2017/07/10', 'yyyy/mm/dd'), 'Approved', 'TBD' FROM DUAL 
UNION ALL SELECT 4, 'Plan_05', TO_DATE('2017/07/10', 'yyyy/mm/dd'), 'Approved', 'TBD' FROM DUAL 
UNION ALL SELECT 5, 'Plan_06', TO_DATE('2017/07/10', 'yyyy/mm/dd'), 'Approved', 'TBD' FROM DUAL ;

-- Test SELECT --

SELECT oper_plan_id, oper_plan_desc, oper_date_last_approved, oper_plan_status, oper_mission_stmt 
FROM atis_operation_plans_ref;

