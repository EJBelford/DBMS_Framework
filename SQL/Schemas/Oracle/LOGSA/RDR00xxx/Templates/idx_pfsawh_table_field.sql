/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_table 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: pfsawh_table.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: dd month yyyy 
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
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Indexs -----*/

-- DROP INDEX idx_table_field; 

CREATE INDEX idx_table_field 
    ON pfsawh_table
    (
    field
    ); 
/ 



