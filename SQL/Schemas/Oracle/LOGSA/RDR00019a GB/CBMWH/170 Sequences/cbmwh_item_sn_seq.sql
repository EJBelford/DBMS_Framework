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

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_item_sn_seq;

CREATE SEQUENCE cbmwh_item_sn_seq
  START WITH 1
--  MAXVALUE 99999999 
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;
