/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: idx_cbmwh_itm_sn_dim_wh_flag 
--      PURPOSE:     
--
-- TABLE SOURCE: cbmwh_item_sn_dim
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

-- DROP INDEX  idx_cbmwh_itm_sn_dim_wh_flag;        

CREATE INDEX idx_cbmwh_itm_sn_dim_wh_flag 
    ON cbmwh_item_sn_dim 
    (
    wh_flag     
    );
/
