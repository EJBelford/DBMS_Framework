/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: cbmwh_location_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_location_dim.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 27 November 2007 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 27NOV07 - GB  -          -      - Created 
-- 18JAN08 - GB  -          -      - Rename from pfsa_geo_dim 
--                 to pfsawh_location_dim.  
--
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/

/*----- Primary Key -----*/

-- ALTER TABLE cbmwh_location_dim
--     DROP CONSTRAINT pk_cbmwh_location_dim; 
     
ALTER TABLE cbmwh_location_dim
    ADD CONSTRAINT pk_cbmwh_location_dim 
    PRIMARY KEY 
    (
    rec_id
    );     


