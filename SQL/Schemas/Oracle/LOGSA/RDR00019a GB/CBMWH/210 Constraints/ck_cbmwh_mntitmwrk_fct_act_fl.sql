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

/*----- Constraints -----*/

-- ALTER TABLE cbmwh_maint_itm_wrk_fact  
--     DROP CONSTRAINT ck_cbmwh_mntitmwrk_fct_act_fl;        

ALTER TABLE cbmwh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_cbmwh_mntitmwrk_fct_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

