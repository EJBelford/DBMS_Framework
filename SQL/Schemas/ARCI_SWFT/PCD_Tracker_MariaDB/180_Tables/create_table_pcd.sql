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
rec_id                          INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY 
                                COMMENT 'rec_id - The unique durable single field key assigned to the record.  ',
rec_uuid                        CHAR(36)     NOT NULL DEFAULT uuid()
                                COMMENT 'rec_uuid - Stores the Universally Unique Identifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.  ', 
--
tracker_id                      INTEGER      NOT NULL
                                COMMENT 'tracker_id - The integer identifier of the parent record.  ',
tracker_uuid                    CHAR(36)     NOT NULL
                                COMMENT 'tracker_uuid - The UUID identifier of the parent record.  ', 
--
pcd_id                          VARCHAR(50)  NOT NULL
                                COMMENT 'pcd_id - A unique identifier for each PCD. It is automatically generated.  (ex: DRAFT-ARCI-FY01-TI16-000010) ',
subject                         VARCHAR(100) NOT NULL
                                COMMENT 'subject - The subject of this PCD; entered by the originator.  ', 
classification_code             VARCHAR(100) NOT NULL
                                COMMENT 'classification_code - ',
department                      VARCHAR(6)
                                COMMENT 'department - Text box prefilled with department of the originator, but can be changed to any department.  ',
revision                        VARCHAR(50)
                                COMMENT 'revision - This is an uneditable field that shows whether this PCD has had a revision approved. If so, it will show the number of that PCD. If not, it will simply say "Current". ', 
-- programs  
originator                      VARCHAR(50)
                                COMMENT 'originator - Uneditable field that shows the name of the PCD''s originator.  ', 
-- approver 
current_status                  VARCHAR(3)
                                COMMENT 'current_status - Uneditable field filled with the current state of the PCD. In the case of rework, approved, or closed the name of the approver(s) who put it in that state and the date they did it will also be displayed.  ',
-- action_responsible_persons     
pcd_required_date               DATE         NOT NULL
                                COMMENT 'pcd_required_date - The date the PCD is to be ready by.  ',
-- contracts 
-- reference 
-- action 
-- program_recipients 
-- additional_recipients 
-- work_package
program_to_use_in_pcd_number    VARCHAR(50)
                                COMMENT 'program_to_use_in_pcd_number - The author must select the program to have the system use when it assigns a PCD number to the PCD. To set it the author must select a program from the programs box and click the set code button. ',  
--
status                          CHAR(1)      NOT NULL DEFAULT 'C'
                                COMMENT 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)', 
status_by                       VARCHAR(50)  DEFAULT USER()
                                COMMENT 'status_by - The user who last changed the status of the record',
status_date                     TIMESTAMP    NOT NULL DEFAULT SYSDATE()
                                COMMENT 'status_date - The date when the record status was last changed', 
--
insert_date                     TIMESTAMP    NOT NULL DEFAULT SYSDATE()
                                COMMENT 'insert_date - The date the record was created',
insert_by                       VARCHAR(50)  DEFAULT USER()
                                COMMENT 'insert_by - The user/fuction that created the record',
update_date                     TIMESTAMP 
                                COMMENT 'update_date - The date the record was last modified',
update_by                       VARCHAR(50)
                                COMMENT 'update_by - The user/function that last updated the record',
delete_flag                     BOOLEAN      DEFAULT FALSE
                                COMMENT 'delete_flag - A logical flag used to ignore the record as if it was deleted',   
delete_date                     TIMESTAMP
                                COMMENT 'delete_date - The date the logical delete flag was set',
delete_by                       VARCHAR(50)
                                COMMENT 'delete_by - The user/function that set the logical delete flag',
hidden_flag                     BOOLEAN      DEFAULT FALSE
                                COMMENT 'hidden_flag - A flag used to hide/exclude the record from pick lists',   
hidden_date                     TIMESTAMP
                                COMMENT 'hidden_date - The date the hidden flag was set',
hidden_by                       VARCHAR(50)
                                COMMENT 'hidden_by - The user/function that set the hidden flag' 
);

ALTER TABLE pcd_tracker.pcd 
COMMENT 'pcd - Contains the high-level information regarding the PCD.';

    
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
