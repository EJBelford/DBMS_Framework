/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: cbmwh_process_control
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_process_control.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 02 JANUSRY 2008
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/

/*----- Constraints -----*/

--ALTER TABLE cbmwh_process_control  
--    DROP CONSTRAINT ck_cbmwh_process_cntrl_del_fl        

ALTER TABLE cbmwh_process_control  
    ADD CONSTRAINT ck_cbmwh_process_cntrl_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

