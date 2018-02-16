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

/*----- Primary Key -----*/

-- ALTER TABLE cbmwh_item_sn_dim  
--     DROP CONSTRAINT pk_cbmwh_itm_sn_dim_recid;        

ALTER TABLE cbmwh_item_sn_dim 
    ADD CONSTRAINT pk_cbmwh_itm_sn_dim_recid 
    PRIMARY KEY 
        (
        rec_id     
        );

