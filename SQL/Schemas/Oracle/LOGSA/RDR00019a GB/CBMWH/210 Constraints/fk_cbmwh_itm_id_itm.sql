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

/*----- Foreign Key -----*/
 
-- ALTER TABLE cbmwh_item_sn_dim  
--     DROP CONSTRAINT fk_cbmwh_itm_id_itm;        

ALTER TABLE cbmwh_item_sn_dim  
    ADD CONSTRAINT fk_cbmwh_itm_id_itm
    FOREIGN KEY 
        (
        physical_item_id
        ) 
    REFERENCES cbmwh_item_dim
        (
        physical_item_id
        );
 
