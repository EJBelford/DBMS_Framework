/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
-- 
--         Table Name: cbmwh_process_ref
--         Table Desc: Contains a mapping to the name of the stored procedure or function
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 19 December 2007
-- 
--       Table Source: cbmwh_process_ref.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 19Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_process_ref_seq;

CREATE SEQUENCE cbmwh_process_ref_seq
    START WITH 1000
--    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

