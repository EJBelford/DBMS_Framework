/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: cbmwh_item_sn_dim 
--      PURPOSE: A major grouping End Items.  
--
-- TABLE SOURCE: cbmwh_item_sn_dim.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 9 January 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Indexs -----*/

DROP INDEX idx_cbmwh_itmsn_dim_itemid;        

CREATE INDEX idx_cbmwh_itmsn_dim_itemid 
    ON cbmwh_item_sn_dim 
    (
    physical_item_id,
    physical_item_sn_id     
    );

