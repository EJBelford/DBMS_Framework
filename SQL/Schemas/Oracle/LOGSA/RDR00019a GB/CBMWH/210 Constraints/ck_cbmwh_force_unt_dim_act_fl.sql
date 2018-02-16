/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: cbmwh_force_unit_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_force_UNIT_DIM.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 07 April 2008 
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
-- 07APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Constraints -----*/ 

--ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT ck_cbmwh_force_unt_dim_act_fl;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT ck_cbmwh_force_unt_dim_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

