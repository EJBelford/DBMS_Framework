CREATE OR REPLACE FORCE EDITIONABLE VIEW vw_atis_organizational_structure 
  (
  "UIC",
  "PARENT UIC",
  "UNIT NAME", 
  "TREE",
  "LVL"
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
--         NAME: vw_atis_organizational_structure
--      PURPOSE: %Description%
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-05
--
--       SOURCE: vw_atis_organizational_structure.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- 2017-12-05 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 230 Views  -----*/

-- DROP VIEW vw_atis_organizational_structure;

-- SET PAGESIZE 50 LINESIZE 130
-- COLUMN tree FORMAT A20

WITH t1(uic, parentuic, dispname, lvl) AS (
  -- Anchor member.
  SELECT uic,
         parentuic,
         dispname,
         1 AS lvl
  FROM   atis_organizations_ref
  WHERE  parentuic IS NULL
  UNION ALL
  -- Recursive member.
  SELECT t2.uic,
         t2.parentuic,
         t2.dispname, 
         lvl+1
  FROM   atis_organizations_ref t2, t1
  WHERE  t2.parentuic = t1.uic
)
SEARCH DEPTH FIRST BY uic SET order1
SELECT uic AS "UIC",
       parentuic AS "PARENT UIC",
       SUBSTR(dispname, 1, 50) "UNIT NAME", 
       RPAD('.', (lvl-1)*2, '.') || uic AS tree,
       lvl
FROM t1
ORDER BY order1;
