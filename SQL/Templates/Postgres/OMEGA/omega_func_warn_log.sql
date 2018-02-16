/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_func_warn_log                                           */
/*      Author: Gene Belford                                                  */
/* Description: This table is used to capture warnings for the OMEGA          */
/*              functional user.  Warnings are processing exceptions, and     */
/*              data integrity issues.                                        */
/*        Date: 2013-12-17                                                    */
/* Source File: omega_func_warn_log.sql                                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-17             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_func_warn_log;

CREATE TABLE omega_func_warn_log 
(
rec_id             INTEGER        NOT NULL DEFAULT nextval('omega_func_warn_log_seq'::regclass),
--
rec_uuid           UUID           NOT NULL DEFAULT uuid_generate_v4(), 
--
warning_type       VARCHAR(50),
warning_from       VARCHAR(100), 
warning_msg        VARCHAR(2000), 
warning_status     CHAR(1)        NOT NULL DEFAULT 'C', 
warning_timestamp  TIMESTAMP      WITH TIME ZONE NOT NULL DEFAULT NOW(), 
warning_action     VARCHAR(2000), 
--
update_date        TIMESTAMP      WITH TIME ZONE,
update_by          VARCHAR(50),
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );

COMMENT ON TABLE omega_func_warn_log 
IS 'omega_func_warn_log - This table is used to capture warnings for the OMEGA functional user.  Warnings are processing exceptions, and dat integrity issues.';

COMMENT ON COLUMN omega_func_warn_log.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN omega_process_log.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 
COMMENT ON COLUMN omega_func_warn_log.warning_type 
IS 'warning_type - PROCESSING/DATA INTEGRITY/REVIEW REQUIRED/tdb as idicated by raising module.';
COMMENT ON COLUMN omega_func_warn_log.warning_from 
IS 'warning_from - Should contain the name of the raising module with the entire calling string.';
COMMENT ON COLUMN omega_func_warn_log.warning_msg 
IS 'warning_msg - Information with the rasing module that helps resolve, and/or research the issue.';
COMMENT ON COLUMN omega_func_warn_log.warning_status 
IS 'warning_status - A 1 character code for the statsu of the record, (Current, Error, Historical, New, Processing, Waiting)'; 
COMMENT ON COLUMN omega_func_warn_log.warning_timestamp  
IS 'warning_timestamp - The timestamp of when warning was recorded.';
COMMENT ON COLUMN omega_func_warn_log.warning_action 
IS 'warning_action - The action taken to coreect the warning.';

COMMENT ON COLUMN omega_func_warn_log.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN omega_func_warn_log.update_by 
IS 'update_by - The user/function that last updated the record';

/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('omega_func_warn_log') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/
