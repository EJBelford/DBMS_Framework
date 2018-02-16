/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: atis_ictl_tasks_seq
--      PURPOSE: REC_ID sequence for atis_ictl_tasks
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-11-28
--
--       SOURCE: atis_ictl_tasks_seq.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- YYMMDD - Who          - RDP / ECP # - Details..
-- 171128 - Gene Belford - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE atis_ictl_tasks_seq;

CREATE SEQUENCE atis_ictl_tasks_seq
--    START WITH 1000000 
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

