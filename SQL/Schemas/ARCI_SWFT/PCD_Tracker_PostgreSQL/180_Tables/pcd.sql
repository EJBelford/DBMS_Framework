/* Source File: pcd.sql                                                       */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd                                                           */
/*      Author: Gene Belford                                                  */
/* Description: Contains the high-level information regarding the PCD.        */
/*        Date: 2017-05-24                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-24             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS pcd_tracker.pcd;

CREATE TABLE pcd_tracker.pcd 
(
rec_id                          INTEGER      NOT NULL DEFAULT nextval('pcd_tracker.pcd_seq'::regclass),
--
rec_uuid                        UUID         NOT NULL DEFAULT uuid_generate_v4(), 
--
tracker_id                      INTEGER      NOT NULL,
tracker_uuid                    UUID         NOT NULL, 
--
pcd_id                          VARCHAR(50)  UNIQUE NOT NULL,
subject                         VARCHAR(100) NOT NULL, 
classification_code             VARCHAR(100) NOT NULL,
department                      VARCHAR(6),
revision                        VARCHAR(50), 
--programs  
originator                      VARCHAR(50), 
--approver 
current_status                  VARCHAR(3),
--action_responsible_persons     
pcd_required_date               DATE         NOT NULL,
--contracts 
--reference 
--action 
--program_recipients 
--additional_recipients 
--work_package
program_to_use_in_pcd_number    VARCHAR(50),  
--
status                          CHAR(1)      NOT NULL DEFAULT 'C', 
status_by                       VARCHAR(50)  DEFAULT USER,
status_date                     TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(), 
--
insert_date                     TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(),
insert_by                       VARCHAR(50)  DEFAULT USER,
update_date                     TIMESTAMP    WITH TIME ZONE,
update_by                       VARCHAR(50),
delete_flag                     BOOLEAN      DEFAULT 'FALSE',   
delete_date                     TIMESTAMP    WITH TIME ZONE,
delete_by                       VARCHAR(50),
hidden_flag                     BOOLEAN      DEFAULT 'FALSE',   
hidden_date                     TIMESTAMP    WITH TIME ZONE,
hidden_by                       VARCHAR(50),
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );

COMMENT ON TABLE pcd_tracker.pcd 
IS 'pcd - Contains the high-level information regarding the PCD.';

COMMENT ON COLUMN pcd_tracker.pcd.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN pcd_tracker.pcd.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 

COMMENT ON COLUMN pcd_tracker.pcd.tracker_id 
IS 'tracker_id - '; 
COMMENT ON COLUMN pcd_tracker.pcd.tracker_uuid 
IS 'tracker_uuid - '; 

COMMENT ON COLUMN pcd_tracker.pcd.pcd_id 
IS 'pcd_id - A unique identifier for each PCD. It is automatically generated.  (ex: DRAFT- ARCI-FY01-TI16-000010)'; 
COMMENT ON COLUMN pcd_tracker.pcd.subject 
IS 'subject - The subject of this PCD; entered by the originator.  '; 
COMMENT ON COLUMN pcd_tracker.pcd.classification_code 
IS 'classification_code - '; 
COMMENT ON COLUMN pcd_tracker.pcd.department 
IS 'department - Text box prefilled with department of the originator, but can be changed to any department.  '; 
COMMENT ON COLUMN pcd_tracker.pcd.revision 
IS 'revision - This is an uneditable field that shows whether this PCD has had a revision approved. If so, it will show the number of that PCD. If not, it will simply say "Current". '; 
COMMENT ON COLUMN pcd_tracker.pcd.originator 
IS 'originator - Uneditable field that shows the name of the PCD''s originator'; 
COMMENT ON COLUMN pcd_tracker.pcd.current_status 
IS 'current_status - Uneditable field filled with the current state of the PCD. In the case of rework, approved, or closed the name of the approver(s) who put it in that state and the date they did it will also be displayed.  '; 
COMMENT ON COLUMN pcd_tracker.pcd.pcd_required_date 
IS 'pcd_required_date - The date the PCD is to be ready by.  '; 
COMMENT ON COLUMN pcd_tracker.pcd.program_to_use_in_pcd_number 
IS 'program_to_use_in_pcd_number - The author must select the program to have the system use when it assigns a PCD number to the PCD.  '; 

COMMENT ON COLUMN pcd_tracker.pcd.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)'; 
COMMENT ON COLUMN pcd_tracker.pcd.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN pcd_tracker.pcd.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN pcd_tracker.pcd.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN pcd_tracker.pcd.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN pcd_tracker.pcd.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN pcd_tracker.pcd.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN pcd_tracker.pcd.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN pcd_tracker.pcd.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN pcd_tracker.pcd.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN pcd_tracker.pcd.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN pcd_tracker.pcd.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN pcd_tracker.pcd.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';
    
/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('pcd') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/
