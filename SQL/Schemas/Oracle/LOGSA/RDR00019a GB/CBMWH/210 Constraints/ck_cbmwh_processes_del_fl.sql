/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
-- 
--         Table Name: cbmwh_processes
--         Table Desc: Contains a mapping to the name of the stored procedure or function
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 19 December 2007 
-- 
--       Table Source: cbmwh_processes.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 19Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

--ALTER TABLE cbmwh_processes  
--    DROP CONSTRAINT ck_cbmwh_processes_del_fl;        

ALTER TABLE cbmwh_processes  
    ADD CONSTRAINT ck_cbmwh_processes_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

