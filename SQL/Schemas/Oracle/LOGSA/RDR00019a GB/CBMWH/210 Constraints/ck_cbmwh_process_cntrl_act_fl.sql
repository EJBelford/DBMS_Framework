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
--    DROP CONSTRAINT ck_cbmwh_process_cntrl_act_fl        

ALTER TABLE cbmwh_process_control  
    ADD CONSTRAINT ck_cbmwh_process_cntrl_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

