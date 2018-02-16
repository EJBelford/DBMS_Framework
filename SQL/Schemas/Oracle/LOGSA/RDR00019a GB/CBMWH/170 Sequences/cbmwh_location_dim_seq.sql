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

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_location_dim_seq;

CREATE SEQUENCE cbmwh_location_dim_seq
    START WITH 30000
--    MAXVALUE 999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

