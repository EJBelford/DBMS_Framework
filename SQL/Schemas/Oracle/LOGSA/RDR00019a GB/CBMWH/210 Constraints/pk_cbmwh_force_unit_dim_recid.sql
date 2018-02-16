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

/*----- Constraints - Primary Key -----*/ 

--ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT pk_cbmwh_force_unit_dim_recid;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT pk_cbmwh_force_unit_dim_recid 
    PRIMARY KEY 
    (
    rec_id
    );    

