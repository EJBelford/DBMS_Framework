/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: idx_pfsawh_frce_unt_status  
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: pfsawh_force_unit_dim.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 17 November 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES: Created to improve ETL performance.
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 17NOV08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Indexs -----*/

--DROP INDEX idx_pfsawh_frce_unt_status; 

CREATE INDEX idx_pfsawh_frce_unt_status 
    ON pfsawh_force_unit_dim
    (
    status
    ); 

/ 



