/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: cbmwh_maint_itm_wrk_fact
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_maint_itm_wrk_fact.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: February 29, 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 29FEB08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Sequence  -----*/

DROP SEQUENCE cbmwh_maint_itm_wrk_fact_seq;

CREATE SEQUENCE cbmwh_maint_itm_wrk_fact_seq
    START WITH 1
--    MAXVALUE   9999999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

