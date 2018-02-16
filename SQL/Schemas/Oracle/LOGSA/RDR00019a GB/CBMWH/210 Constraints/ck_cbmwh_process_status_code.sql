/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--
--         Table Name: cbmwh_Process_Log
--         Table Desc: Process log tracking stored procedure performance in the the CMIS database.  
--                     Data is inserted by stored procedure dbo.spr_InsUpd_RptToCourt_ProcessLog.
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 18 December 2007
--
--       Table Source: cbmwh_Process_Log.sql 
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 18Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/

/*----- Constraints -----*/

--ALTER TABLE cbmwh_process_log  
--    DROP CONSTRAINT ck_cbmwh_process_status_code;       

ALTER TABLE cbmwh_process_log  
    ADD CONSTRAINT ck_cbmwh_process_status_code 
    CHECK (process_status_code=-1 OR process_status_code=0 
        OR process_status_code=1);

