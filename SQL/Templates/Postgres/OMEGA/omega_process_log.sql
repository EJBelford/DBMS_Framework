/* Source File: omega_process_log.sql                                         */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_process_log                                             */
/*      Author: Gene Belford                                                  */
/* Description: The purpose of this table is to capture processing metrics    */
/*              related to OMEGA modules.  Data is collected by an automated  */
/*              process.                                                      */
/*        Date: 2013-12-06                                                    */
/* Source File: omega_process_log.sql                                         */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-06             Gene Belford           Created                      */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_process_log;

CREATE TABLE omega_process_log 
(
rec_id                  INTEGER      NOT NULL DEFAULT nextval('omega_process_log_seq'::regclass),
--
rec_uuid                UUID         NOT NULL UNIQUE, 
--
batch_id                INTEGER, 
process_id              INTEGER,
process_module          INTEGER, 
process_step            INTEGER,
process_start           TIMESTAMP    WITH TIME ZONE NOT NULL, 
process_stop            TIMESTAMP    WITH TIME ZONE, 
process_status          CHAR(1)      NOT NULL DEFAULT 'C', 
process_status_date     TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT NOW(), 
--
sql_error_code          CHAR(5),
--
rec_read                INTEGER, 
rec_valid               INTEGER, 
rec_load                INTEGER, 
--
rec_insert              INTEGER,
rec_merge               INTEGER,
rec_select              INTEGER, 
rec_update              INTEGER, 
rec_delete              INTEGER,
--
process_run_id          VARCHAR(50), 
process_message         VARCHAR(254),
process_message_err     VARCHAR(254),
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );

COMMENT ON TABLE omega_process_log 
IS 'omega_process_log - The purpose of this table is to capture processing metrics related to OMEGA modules.  Data is collected by an automated process. ';


COMMENT ON COLUMN omega_process_log.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN omega_process_log.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 
COMMENT ON COLUMN omega_process_log.batch_id 
IS 'batch_id - The idebtifier that group processes together as a logical unit.'; 
COMMENT ON COLUMN omega_process_log.process_id 
IS 'process_id - The FK into process reference table that provides the description of the process being run.'; 
COMMENT ON COLUMN omega_process_log.process_module 
IS 'process_module - Identities the module within a give mutli-step process'; 
COMMENT ON COLUMN omega_process_log.process_step 
IS 'process_step - Identities the tep within a give givn multi-step orocess module'; 
COMMENT ON COLUMN omega_process_log.process_start 
IS 'process_start - When the task started.'; 
COMMENT ON COLUMN omega_process_log.process_stop 
IS 'process_stop - When the task ended.'; 
COMMENT ON COLUMN omega_process_log.process_status 
IS 'process_status - A 1 character code for the statsu of the record, (Current, Error, Historical, New, Processing, Waiting)'; 
COMMENT ON COLUMN omega_process_log.process_status_date 
IS 'process_status_date - When the process status was last updated.'; 
COMMENT ON COLUMN omega_process_log.sql_error_code 
IS 'sql_error_code - Return status of the SQL statment executed.'; 
COMMENT ON COLUMN omega_process_log.rec_read 
IS 'rec_read - Number of records read by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_valid 
IS 'rec_valid - Number of records found to be valid by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_load 
IS 'rec_load - Number of records loaded by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_insert 
IS 'rec_insert - Number of records inserted by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_merge 
IS 'rec_merge - Number of records merged by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_select 
IS 'rec_select - Number of records selected by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_update 
IS 'rec_update - Number of records updated by the process.'; 
COMMENT ON COLUMN omega_process_log.rec_delete 
IS 'rec_delete - Number of records deleted by the process.'; 
COMMENT ON COLUMN omega_process_log.process_run_id 
IS 'process_run_id - The user id that this process was run under.'; 
COMMENT ON COLUMN omega_process_log.process_message 
IS 'process_message - Proves information regarding the process state.'; 
COMMENT ON COLUMN omega_process_log.process_message_err 
IS 'process_message_err  - Proves information regarding the error that occured.'; 


/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = 'omega_process_log' AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/
