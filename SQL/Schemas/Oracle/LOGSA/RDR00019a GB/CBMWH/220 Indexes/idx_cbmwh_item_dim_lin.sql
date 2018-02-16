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

-- DROP INDEX idx_cbmwh_item_dim_lin;        

CREATE INDEX idx_cbmwh_item_dim_lin 
    ON cbmwh_item_dim
    (lin)
    LOGGING
    NOPARALLEL;

