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

DROP INDEX  idx_cbmwh_itm_sn_dim_itm_sn_id;        

CREATE INDEX idx_cbmwh_itm_sn_dim_itm_sn_id 
    ON cbmwh_item_sn_dim 
    (
    physical_item_sn_id     
    );

