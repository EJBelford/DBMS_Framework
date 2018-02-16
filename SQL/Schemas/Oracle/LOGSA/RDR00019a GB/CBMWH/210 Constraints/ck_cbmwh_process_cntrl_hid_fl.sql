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
--    DROP CONSTRAINT ck_cbmwh_process_cntrl_hid_fl        

ALTER TABLE cbmwh_process_control  
    ADD CONSTRAINT ck_cbmwh_process_cntrl_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');



