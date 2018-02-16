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

/*----- Primary Key -----*/

--ALTER TABLE cbmwh_item_dim  
--    DROP CONSTRAINT pk_cbmwh_item_dim_phy_itm_id;        

ALTER TABLE cbmwh_item_dim 
	ADD CONSTRAINT pk_cbmwh_item_dim_phy_itm_id 
    PRIMARY KEY 
        (
        physical_item_id
        );


