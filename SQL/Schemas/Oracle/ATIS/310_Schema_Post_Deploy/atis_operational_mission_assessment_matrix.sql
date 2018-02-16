
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                            Copyright, US Army, 2017
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: atis_operational_mission_assessment_matrix
--      PURPOSE: Load data into the atis_operational_mission_assessment_matrix table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-07
--
--       SOURCE: atis_operational_mission_assessment_matrix.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-07 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM atis_operational_mission_assessment_matrix;

-- Load records --

INSERT INTO atis_operational_mission_assessment_matrix ( mission_assessment_id, 
    oper_plan_id ,met_code ,met_assessment ,met_assessment_date ) 
          SELECT 1, 1, 'OP 1.1.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 2, 1, 'OP 1.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 3, 1, 'OP 1.1.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 4, 1, 'OP 1.2.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 5, 1, 'OP 1.2.4.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 6, 1, 'OP 1.2.4.8', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 7, 1, 'OP 1.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 8, 1, 'OP 1.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 9, 1, 'OP 1.5.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 10, 1, 'OP 1.5.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 11, 1, 'OP 1.5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 12, 1, 'OP 2.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 13, 1, 'OP 2.2.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 14, 1, 'OP 2.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 15, 1, 'OP 2.4.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 16, 1, 'OP 2.5', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 17, 1, 'OP 3.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 18, 1, 'OP 3.2.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 19, 1, 'OP 3.2.2.4', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 20, 1, 'OP 3.2.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 21, 1, 'OP 3.2.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 22, 1, 'OP 3.2.7', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 23, 1, 'OP 4.4.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 24, 1, 'OP 4.4.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 25, 1, 'OP 4.4.3.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 26, 1, 'OP 4.4.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 27, 1, 'OP 4.4.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 28, 1, 'OP 4.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 29, 1, 'OP 4.7.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 30, 1, 'OP 4.7.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 31, 1, 'OP 4.7.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 32, 1, 'OP 4.7.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 33, 1, 'OP 5.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 34, 1, 'OP 5.1.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 35, 1, 'OP 5.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 36, 1, 'OP 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 37, 1, 'OP 5.2.2', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 38, 1, 'OP 5.3.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 39, 1, 'OP 5.4.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 40, 1, 'OP 5.4.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 41, 1, 'OP 5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 42, 1, 'OP 5.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 43, 1, 'OP 5.5.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 44, 1, 'OP 5.7.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 45, 1, 'OP 5.8', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 46, 1, 'OP 6.1', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 47, 1, 'OP 6.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 48, 1, 'OP 6.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 49, 1, 'OP 6.2.2', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 50, 1, 'OP 6.2.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 51, 1, 'OP 6.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 52, 1, 'OP 6.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 53, 1, 'OP 6.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 54, 1, 'OP 6.3.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 55, 1, 'OP 6.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 56, 1, 'OP 6.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 57, 1, 'OP 6.5.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 58, 1, 'SN 8.1.10', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 59, 1, 'ST 1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 60, 1, 'ST 1.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 61, 1, 'ST 1.1.6', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 62, 1, 'ST 1.3.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 63, 1, 'ST 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 64, 1, 'ST 2.2.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 65, 1, 'ST 4.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 66, 1, 'ST 4.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 67, 1, 'ST 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 68, 1, 'ST 5.6.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 69, 1, 'ST 5.6.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 70, 1, 'ST 6.2.6', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 71, 1, 'ST 8.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 72, 1, 'ST 8.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 73, 1, 'ST 8.1.4', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 74, 1, 'ST 8.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 75, 1, 'ST 8.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 76, 1, 'ST 8.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 77, 1, 'ST 8.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 78, 1, 'ST 8.3.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 79, 1, 'ST 8.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 80, 1, 'ST 8.4.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 81, 1, 'ST 8.4.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 82, 2, 'OP 1.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 83, 2, 'OP 1.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 84, 2, 'OP 1.1.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 85, 2, 'OP 1.2.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 86, 2, 'OP 1.2.4.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 87, 2, 'OP 1.2.4.8', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 88, 2, 'OP 1.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 89, 2, 'OP 1.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 90, 2, 'OP 1.5.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 91, 2, 'OP 1.5.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 92, 2, 'OP 1.5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 93, 2, 'OP 2.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 94, 2, 'OP 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 95, 2, 'OP 2.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 96, 2, 'OP 2.4.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 97, 2, 'OP 2.5', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 98, 2, 'OP 3.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 99, 2, 'OP 3.2.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 100, 2, 'OP 3.2.2.4', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 101, 2, 'OP 3.2.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 102, 2, 'OP 3.2.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 103, 2, 'OP 3.2.7', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 104, 2, 'OP 4.4.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 105, 2, 'OP 4.4.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 106, 2, 'OP 4.4.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 107, 2, 'OP 4.4.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 108, 2, 'OP 4.4.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 109, 2, 'OP 4.5.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 110, 2, 'OP 4.7.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 111, 2, 'OP 4.7.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 112, 2, 'OP 4.7.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 113, 2, 'OP 4.7.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 114, 2, 'OP 5.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 115, 2, 'OP 5.1.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 116, 2, 'OP 5.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 117, 2, 'OP 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 118, 2, 'OP 5.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 119, 2, 'OP 5.3.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 120, 2, 'OP 5.4.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 121, 2, 'OP 5.4.4', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 122, 2, 'OP 5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 123, 2, 'OP 5.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 124, 2, 'OP 5.5.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 125, 2, 'OP 5.7.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 126, 2, 'OP 5.8', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 127, 2, 'OP 6.1', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 128, 2, 'OP 6.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 129, 2, 'OP 6.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 130, 2, 'OP 6.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 131, 2, 'OP 6.2.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 132, 2, 'OP 6.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 133, 2, 'OP 6.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 134, 2, 'OP 6.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 135, 2, 'OP 6.3.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 136, 2, 'OP 6.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 137, 2, 'OP 6.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 138, 2, 'OP 6.5.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 139, 2, 'SN 8.1.10', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 140, 2, 'ST 1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 141, 2, 'ST 1.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 142, 2, 'ST 1.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 143, 2, 'ST 1.3.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 144, 2, 'ST 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 145, 2, 'ST 2.2.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 146, 2, 'ST 4.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 147, 2, 'ST 4.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 148, 2, 'ST 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 149, 2, 'ST 5.6.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 150, 2, 'ST 5.6.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 151, 2, 'ST 6.2.6', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 152, 2, 'ST 8.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 153, 2, 'ST 8.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 154, 2, 'ST 8.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 155, 2, 'ST 8.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 156, 2, 'ST 8.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 157, 2, 'ST 8.2.6', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 158, 2, 'ST 8.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 159, 2, 'ST 8.3.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 160, 2, 'ST 8.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 161, 2, 'ST 8.4.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 162, 2, 'ST 8.4.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 163, 3, 'OP 1.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 164, 3, 'OP 1.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 165, 3, 'OP 1.1.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 166, 3, 'OP 1.2.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 167, 3, 'OP 1.2.4.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 168, 3, 'OP 1.2.4.8', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 169, 3, 'OP 1.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 170, 3, 'OP 1.5.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 171, 3, 'OP 1.5.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 172, 3, 'OP 1.5.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 173, 3, 'OP 1.5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 174, 3, 'OP 2.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 175, 3, 'OP 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 176, 3, 'OP 2.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 177, 3, 'OP 2.4.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 178, 3, 'OP 2.5', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 179, 3, 'OP 3.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 180, 3, 'OP 3.2.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 181, 3, 'OP 3.2.2.4', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 182, 3, 'OP 3.2.5.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 183, 3, 'OP 3.2.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 184, 3, 'OP 3.2.7', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 185, 3, 'OP 4.4.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 186, 3, 'OP 4.4.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 187, 3, 'OP 4.4.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 188, 3, 'OP 4.4.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 189, 3, 'OP 4.4.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 190, 3, 'OP 4.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 191, 3, 'OP 4.7.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 192, 3, 'OP 4.7.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 193, 3, 'OP 4.7.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 194, 3, 'OP 4.7.6', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 195, 3, 'OP 5.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 196, 3, 'OP 5.1.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 197, 3, 'OP 5.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 198, 3, 'OP 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 199, 3, 'OP 5.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 200, 3, 'OP 5.3.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 201, 3, 'OP 5.4.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 202, 3, 'OP 5.4.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 203, 3, 'OP 5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 204, 3, 'OP 5.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 205, 3, 'OP 5.5.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 206, 3, 'OP 5.7.4', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 207, 3, 'OP 5.8', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 208, 3, 'OP 6.1', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 209, 3, 'OP 6.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 210, 3, 'OP 6.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 211, 3, 'OP 6.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 212, 3, 'OP 6.2.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 213, 3, 'OP 6.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 214, 3, 'OP 6.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 215, 3, 'OP 6.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 216, 3, 'OP 6.3.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 217, 3, 'OP 6.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 218, 3, 'OP 6.5.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 219, 3, 'OP 6.5.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 220, 3, 'SN 8.1.10', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 221, 3, 'ST 1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 222, 3, 'ST 1.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 223, 3, 'ST 1.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 224, 3, 'ST 1.3.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 225, 3, 'ST 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 226, 3, 'ST 2.2.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 227, 3, 'ST 4.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 228, 3, 'ST 4.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 229, 3, 'ST 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 230, 3, 'ST 5.6.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 231, 3, 'ST 5.6.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 232, 3, 'ST 6.2.6', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 233, 3, 'ST 8.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 234, 3, 'ST 8.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 235, 3, 'ST 8.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 236, 3, 'ST 8.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 237, 3, 'ST 8.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 238, 3, 'ST 8.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 239, 3, 'ST 8.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 240, 3, 'ST 8.3.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 241, 3, 'ST 8.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 242, 3, 'ST 8.4.2', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 243, 3, 'ST 8.4.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 244, 4, 'OP 1.1.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 245, 4, 'OP 1.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 246, 4, 'OP 1.1.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 247, 4, 'OP 1.2.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 248, 4, 'OP 1.2.4.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 249, 4, 'OP 1.2.4.8', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 250, 4, 'OP 1.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 251, 4, 'OP 1.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 252, 4, 'OP 1.5.2', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 253, 4, 'OP 1.5.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 254, 4, 'OP 1.5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 255, 4, 'OP 2.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 256, 4, 'OP 2.2.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 257, 4, 'OP 2.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 258, 4, 'OP 2.4.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 259, 4, 'OP 2.5', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 260, 4, 'OP 3.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 261, 4, 'OP 3.2.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 262, 4, 'OP 3.2.2.4', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 263, 4, 'OP 3.2.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 264, 4, 'OP 3.2.6', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 265, 4, 'OP 3.2.7', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 266, 4, 'OP 4.4.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 267, 4, 'OP 4.4.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 268, 4, 'OP 4.4.3.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 269, 4, 'OP 4.4.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 270, 4, 'OP 4.4.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 271, 4, 'OP 4.5.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 272, 4, 'OP 4.7.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 273, 4, 'OP 4.7.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 274, 4, 'OP 4.7.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 275, 4, 'OP 4.7.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 276, 4, 'OP 5.1.1', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 277, 4, 'OP 5.1.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 278, 4, 'OP 5.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 279, 4, 'OP 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 280, 4, 'OP 5.2.2', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 281, 4, 'OP 5.3.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 282, 4, 'OP 5.4.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 283, 4, 'OP 5.4.4', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 284, 4, 'OP 5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 285, 4, 'OP 5.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 286, 4, 'OP 5.5.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 287, 4, 'OP 5.7.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 288, 4, 'OP 5.8', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 289, 4, 'OP 6.1', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 290, 4, 'OP 6.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 291, 4, 'OP 6.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 292, 4, 'OP 6.2.2', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 293, 4, 'OP 6.2.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 294, 4, 'OP 6.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 295, 4, 'OP 6.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 296, 4, 'OP 6.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 297, 4, 'OP 6.3.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 298, 4, 'OP 6.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 299, 4, 'OP 6.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 300, 4, 'OP 6.5.4', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 301, 4, 'SN 8.1.10', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 302, 4, 'ST 1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 303, 4, 'ST 1.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 304, 4, 'ST 1.1.6', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 305, 4, 'ST 1.3.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 306, 4, 'ST 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 307, 4, 'ST 2.2.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 308, 4, 'ST 4.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 309, 4, 'ST 4.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 310, 4, 'ST 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 311, 4, 'ST 5.6.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 312, 4, 'ST 5.6.3', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 313, 4, 'ST 6.2.6', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 314, 4, 'ST 8.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 315, 4, 'ST 8.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 316, 4, 'ST 8.1.4', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 317, 4, 'ST 8.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 318, 4, 'ST 8.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 319, 4, 'ST 8.2.6', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 320, 4, 'ST 8.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 321, 4, 'ST 8.3.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 322, 4, 'ST 8.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 323, 4, 'ST 8.4.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 324, 4, 'ST 8.4.5', 'N', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 325, 5, 'OP 1.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 326, 5, 'OP 1.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 327, 5, 'OP 1.1.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 328, 5, 'OP 1.2.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 329, 5, 'OP 1.2.4.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 330, 5, 'OP 1.2.4.8', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 331, 5, 'OP 1.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 332, 5, 'OP 1.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 333, 5, 'OP 1.5.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 334, 5, 'OP 1.5.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 335, 5, 'OP 1.5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 336, 5, 'OP 2.1.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 337, 5, 'OP 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 338, 5, 'OP 2.4.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 339, 5, 'OP 2.4.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 340, 5, 'OP 2.5', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 341, 5, 'OP 3.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 342, 5, 'OP 3.2.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 343, 5, 'OP 3.2.2.4', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 344, 5, 'OP 3.2.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 345, 5, 'OP 3.2.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 346, 5, 'OP 3.2.7', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 347, 5, 'OP 4.4.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 348, 5, 'OP 4.4.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 349, 5, 'OP 4.4.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 350, 5, 'OP 4.4.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 351, 5, 'OP 4.4.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 352, 5, 'OP 4.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 353, 5, 'OP 4.7.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 354, 5, 'OP 4.7.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 355, 5, 'OP 4.7.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 356, 5, 'OP 4.7.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 357, 5, 'OP 5.1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 358, 5, 'OP 5.1.3', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 359, 5, 'OP 5.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 360, 5, 'OP 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 361, 5, 'OP 5.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 362, 5, 'OP 5.3.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 363, 5, 'OP 5.4.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 364, 5, 'OP 5.4.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 365, 5, 'OP 5.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 366, 5, 'OP 5.5.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 367, 5, 'OP 5.5.2', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 368, 5, 'OP 5.7.4', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 369, 5, 'OP 5.8', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 370, 5, 'OP 6.1', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 371, 5, 'OP 6.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 372, 5, 'OP 6.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 373, 5, 'OP 6.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 374, 5, 'OP 6.2.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 375, 5, 'OP 6.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 376, 5, 'OP 6.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 377, 5, 'OP 6.3.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 378, 5, 'OP 6.3.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 379, 5, 'OP 6.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 380, 5, 'OP 6.5.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 381, 5, 'OP 6.5.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 382, 5, 'SN 8.1.10', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 383, 5, 'ST 1.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 384, 5, 'ST 1.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 385, 5, 'ST 1.1.6', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 386, 5, 'ST 1.3.5', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 387, 5, 'ST 2.2.1', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 388, 5, 'ST 2.2.3', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 389, 5, 'ST 4.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 390, 5, 'ST 4.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 391, 5, 'ST 5.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 392, 5, 'ST 5.6.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 393, 5, 'ST 5.6.3', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 394, 5, 'ST 6.2.6', 'Q*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 395, 5, 'ST 8.1.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 396, 5, 'ST 8.1.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 397, 5, 'ST 8.1.4', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 398, 5, 'ST 8.2.1', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 399, 5, 'ST 8.2.2', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 400, 5, 'ST 8.2.6', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 401, 5, 'ST 8.2.7', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 402, 5, 'ST 8.3.1', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 403, 5, 'ST 8.3.3', 'Q', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 404, 5, 'ST 8.4.2', 'Y', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL 
UNION ALL SELECT 405, 5, 'ST 8.4.5', 'Y*', TO_DATE('2017/07/01', 'yyyy/mm/dd') FROM DUAL ;

-- Test SELECT --

SELECT mission_assessment_id, 
    oper_plan_id ,met_code ,met_assessment ,met_assessment_date  
FROM atis_operational_mission_assessment_matrix;

