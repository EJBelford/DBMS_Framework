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

/*----- Indexs -----*/

-- DROP INDEX ixu_cbmwh_process_control;

CREATE UNIQUE INDEX ixu_cbmwh_process_control 
    ON cbmwh_process_control(process_control_id);

