/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
-- 
--         Table Name: cbmwh_process_log 
--         Table Desc: 
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 19 December 2007 
-- 
--       Table Source: cbmwh_process_log.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 19Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_process_log_seq;

CREATE SEQUENCE cbmwh_process_log_seq
    START WITH 1
--    MAXVALUE 9999 
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     

