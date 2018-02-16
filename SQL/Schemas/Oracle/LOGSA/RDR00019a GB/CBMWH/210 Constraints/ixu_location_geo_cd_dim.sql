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

/*----- Unique Indexs -----*/

-- ALTER TABLE cbmwh_location_dim
--     DROP CONSTRAINT idu_location_geo_cd_dim;

ALTER TABLE cbmwh_location_dim
    ADD CONSTRAINT  ixu_location_geo_cd_dim 
    UNIQUE 
    (
    geo_cd
    );

