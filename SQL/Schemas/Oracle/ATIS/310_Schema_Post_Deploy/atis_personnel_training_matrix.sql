
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: atis_personnel_training_matrix
--      PURPOSE: Load data into the atis_personnel_training_matrix table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-01
--
--       SOURCE: atis_personnel_training_matrix.sql
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

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM atis_personnel_training_matrix;

-- Default record --

INSERT INTO atis_personnel_training_matrix (pt_id, person_id, training_event_id, event_date, score, pass_fail) 
VALUES ( 1, 1, 1, TO_DATE('1900/01/01', 'yyyy/mm/dd'), null, 'F' ); 

-- Load records --

INSERT INTO atis_personnel_training_matrix (pt_id, person_id, training_event_id, event_date, score, pass_fail) 
          SELECT 1, 1, 1, TO_DATE('2017/04/21', 'yyyy/mm/dd'), 290, 'P' FROM DUAL 
UNION ALL SELECT 2, 1, 3, TO_DATE('2017/04/21', 'yyyy/mm/dd'), null, 'P' FROM DUAL 
UNION ALL SELECT 3, 1, 2, TO_DATE('2017/05/15', 'yyyy/mm/dd'), 38, 'P' FROM DUAL 
UNION ALL SELECT 4, 2, 1, TO_DATE('2017/04/21', 'yyyy/mm/dd'), 265, 'P' FROM DUAL 
UNION ALL SELECT 5, 2, 3, TO_DATE('2017/04/21', 'yyyy/mm/dd'), null, 'P' FROM DUAL 
UNION ALL SELECT 6, 2, 2, TO_DATE('2017/05/15', 'yyyy/mm/dd'), 40, 'P' FROM DUAL 
UNION ALL SELECT 7, 3, 1, TO_DATE('2017/04/21', 'yyyy/mm/dd'), 300, 'P' FROM DUAL 
UNION ALL SELECT 8, 3, 3, TO_DATE('2017/04/21', 'yyyy/mm/dd'), null, 'P' FROM DUAL 
UNION ALL SELECT 9, 3, 2, TO_DATE('2017/05/15', 'yyyy/mm/dd'), 39, 'P' FROM DUAL 
UNION ALL SELECT 10, 4, 1, TO_DATE('2017/04/21', 'yyyy/mm/dd'), 290, 'P' FROM DUAL 
UNION ALL SELECT 11, 4, 3, TO_DATE('2017/04/21', 'yyyy/mm/dd'), null, 'P' FROM DUAL 
UNION ALL SELECT 12, 4, 2, TO_DATE('2017/05/15', 'yyyy/mm/dd'), 38, 'P' FROM DUAL 
UNION ALL SELECT 13, 5, 1, TO_DATE('2017/04/21', 'yyyy/mm/dd'), 225, 'F' FROM DUAL 
UNION ALL SELECT 14, 5, 3, TO_DATE('2017/04/21', 'yyyy/mm/dd'), null, 'P' FROM DUAL 
UNION ALL SELECT 15, 5, 2, TO_DATE('2017/05/15', 'yyyy/mm/dd'), 32, 'P' FROM DUAL ;

-- Test SELECT --

SELECT pt_id, person_id, training_event_id, event_date, score, pass_fail 
FROM atis_personnel_training_matrix;

