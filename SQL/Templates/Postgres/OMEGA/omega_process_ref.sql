/* Source File: omega_process_ref.sql                                         */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_process_ref                                             */
/*      Author: Gene Belford                                                  */
/* Description: Contains the reference and operating information for the      */
/*              OMEGA modules.                                                */
/*        Date: 2013-12-18                                                    */
/* Source File: omega_process_ref.sql                                         */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-18             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_process_ref;

CREATE TABLE omega_process_ref 
(
rec_id                      INTEGER      NOT NULL DEFAULT nextval('omega_process_ref_seq'::regclass),
--
rec_uuid                    UUID         UNIQUE NOT NULL DEFAULT uuid_generate_v4(), 
--
process_id                  INTEGER      UNIQUE NOT NULL,
process_name                VARCHAR(50)  NOT NULL, 
--
process_run_ctrl            INTEGER,
process_run_ctrl_override   BOOLEAN DEFAULT 'FALSE',
--
active_flag                 BOOLEAN DEFAULT 'TRUE',
active_date                 DATE    DEFAULT '01-JAN-1900',
inactive_date               DATE    DEFAULT '31-DEC-2099',   
--
status                      CHAR(1)      NOT NULL DEFAULT 'C', 
status_by                   VARCHAR(50)  DEFAULT USER,
status_date                 TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT NOW(), 
--
insert_date                 TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT NOW(),
insert_by                   VARCHAR(50)  DEFAULT USER,
update_date                 TIMESTAMP    WITH TIME ZONE,
update_by                   VARCHAR(50),
delete_flag                 BOOLEAN      DEFAULT 'FALSE',   
delete_date                 TIMESTAMP    WITH TIME ZONE,
delete_by                   VARCHAR(50),
hidden_flag                 BOOLEAN      DEFAULT 'FALSE',   
hidden_date                 TIMESTAMP    WITH TIME ZONE,
hidden_by                   VARCHAR(50),
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );

COMMENT ON TABLE omega_process_ref 
IS 'omega_process_ref - Contains the reference and operating information for the OMEGA modules';

COMMENT ON COLUMN omega_process_ref.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN omega_process_ref.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 
COMMENT ON COLUMN omega_process_ref.process_id 
IS 'process_id - ';
COMMENT ON COLUMN omega_process_ref.process_name 
IS 'process_name - ';

COMMENT ON COLUMN omega_process_ref.process_run_ctrl 
IS 'process_run_ctrl - ';
COMMENT ON COLUMN omega_process_ref.process_run_ctrl_override 
IS 'process_run_ctrl_override - ';
 
COMMENT ON COLUMN omega_process_ref.active_flag 
IS 'active_flag - Flag indicating if the record can be used';
COMMENT ON COLUMN omega_process_ref.active_date 
IS 'active_date - Additional control for the active_flag indicating when the record became active.';
COMMENT ON COLUMN omega_process_ref.inactive_date 
IS 'inactive_date - Additional control for the active_flag indicating when the record became inactive.';  

COMMENT ON COLUMN omega_process_ref.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)'; 
COMMENT ON COLUMN omega_process_ref.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN omega_process_ref.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN omega_process_ref.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN omega_process_ref.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN omega_process_ref.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN omega_process_ref.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN omega_process_ref.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN omega_process_ref.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN omega_process_ref.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN omega_process_ref.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN omega_process_ref.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN omega_process_ref.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';

/*

SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('omega_process_ref') AND pn.nspname = 'public';

SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;

*/

