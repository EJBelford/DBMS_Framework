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

/*----- Unique Indexs -----*/

--DROP INDEX ixu_cbmwh_item_dim_recid;        

CREATE UNIQUE INDEX ixu_cbmwh_item_dim_recid 
    ON cbmwh_item_dim
    (
    rec_id
    );



