/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: cbmwh_maint_itm_wrk_fact
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_maint_itm_wrk_fact.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: February 29, 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 29FEB08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Non Foreign Key Constraints -----*/ 

-- DROP INDEX idx_cbmwh_maint_itm_wrk_fac;

CREATE INDEX idx_cbmwh_maint_itm_wrk_fac 
    ON cbmwh_maint_itm_wrk_fact
    (
    tsk_begin_date_id, 
    tsk_begin_time_id, 
    tsk_end_date_id, 
    tsk_end_time_id, 
    physical_item_id, 
    physical_item_sn_id, 
    maint_ev_id_a, 
    maint_ev_id_b, 
    maint_task_id, 
    maint_work_id 
    );

