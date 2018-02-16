/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
-- 
--         Table Name: cbmwh_processes
--         Table Desc: Contains a mapping to the name of the stored procedure 
--                     or function
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 19 December 2007 
-- 
--       Table Source: cbmwh_processes.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 19Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_processes_seq;

CREATE SEQUENCE cbmwh_processes_seq
    START WITH 1000
--    MAXVALUE 9999 
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     

