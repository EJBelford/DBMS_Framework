/* Source File: omega_std_debug.sql                                           */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_std_debug                                               */
/*      Author: Gene Belford                                                  */
/* Description: This table is intended to capture exceptions throw by the     */
/*              SQL code.  In theory this should only happen in development.  */
/*        Date: 2013-11-20                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-11-20             Gene Belford          Created                      */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_std_debug;

CREATE TABLE omega_std_debug 
(
rec_id          INTEGER        NOT NULL DEFAULT nextval('omega_std_debug_seq'::regclass),
--
insert_date     TIMESTAMP      WITH TIME ZONE,
process_name    VARCHAR(50),
module_name     VARCHAR(50),
error_code      VARCHAR(10),
dbms_ver        VARCHAR(50),
error_message   VARCHAR(200), 
parameters      VARCHAR(200),
insert_by       VARCHAR(50)    NOT NULL,
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE omega_std_debug 
IS 'omega_std_debug - This tbale is intended to capture exceptions throw by the SQL code.  In theory this should only happen in development.';

COMMENT ON COLUMN omega_std_debug.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN omega_std_debug.insert_date 
IS 'insert_date - Timestamp of when the issue occured.';
COMMENT ON COLUMN omega_std_debug.process_name 
IS 'process_name - ';
COMMENT ON COLUMN omega_std_debug.module_name 
IS 'module_name - ';
COMMENT ON COLUMN omega_std_debug.dbms_ver 
IS 'dbms_ver - The version of the DBMS that is installed.';
COMMENT ON COLUMN omega_std_debug.error_code 
IS 'error_code - The error code as defined by the DBMS.';
COMMENT ON COLUMN omega_std_debug.error_message 
IS 'error_message - Any error message that the DBMS generated.  The actual code might appended addition information.'; 
COMMENT ON COLUMN omega_std_debug.parameters 
IS 'parameters - Any specific parameters that might help defined the issue.';
COMMENT ON COLUMN omega_std_debug.insert_by 
IS 'insert_by - This might be either the USER() or an actual user depending on what is passed in.';

/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('omega_std_debug') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/
