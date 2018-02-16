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

/*----- Foreign Key Constraints -----*/ 

-- ALTER TABLE cbmwh_maint_itm_wrk_fact  
--     DROP CONSTRAINT fk_cbmwh_maint_itm_wrk_id_itm;        

ALTER TABLE cbmwh_maint_itm_wrk_fact  
    ADD CONSTRAINT  fk_cbmwh_maint_itm_wrk_id_itm
    FOREIGN KEY 
        (
        physical_item_id
        ) 
    REFERENCES cbmwh_item_dim
        (
        physical_item_id
        );

