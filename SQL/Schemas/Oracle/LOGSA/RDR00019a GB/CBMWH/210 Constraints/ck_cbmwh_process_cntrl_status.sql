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
--    DROP CONSTRAINT ck_cbmwh_process_cntrl_status        

ALTER TABLE cbmwh_process_control  
    ADD CONSTRAINT ck_cbmwh_process_cntrl_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

