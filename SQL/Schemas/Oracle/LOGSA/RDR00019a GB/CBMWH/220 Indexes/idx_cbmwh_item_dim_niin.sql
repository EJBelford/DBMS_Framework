/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: cbmwh_item_dim
--      PURPOSE: A major grouping End Items. 
--
-- TABLE SOURCE: cbmwh_item_dim.sql 
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 9 NOVEMBER 2007
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Indexs -----*/

-- DROP INDEX idx_cbmwh_item_dim_niin;        

CREATE INDEX idx_cbmwh_item_dim_niin 
    ON cbmwh_item_dim
    (niin)
    LOGGING
    NOPARALLEL;


