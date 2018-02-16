/* Source File: trackers.sql                                                  */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: trackers                                                      */
/*      Author: Gene Belford                                                  */
/* Description: Contains all the data need to track the development of        */
/*              the PCD.                                                      */
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

-- DROP TABLE IF EXISTS pcd_tracker.trackers CASCADE;

CREATE TABLE pcd_tracker.trackers 
(
rec_id                          INTEGER      NOT NULL  AUTO_INCREMENT PRIMARY KEY 
                                COMMENT 'rec_id - The unquie durable single field key assigned to the record.',
--
rec_uuid                        CHAR(36)     NOT NULL  -- DEFAULT uuid_generate_v4()
                                COMMENT 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.', 
--
hull_number                     CHAR(10)     NOT NULL DEFAULT 'Unknown'
                                COMMENT 'hull_number - The hull number the tracker is reporting on.  ',
fiscal_year                     CHAR(4)      NOT NULL DEFAULT 'FY--'
                                COMMENT 'fiscal_year - The fiscal year the tracker is reporting on.  ',
technical_insert                CHAR(4)      NOT NULL DEFAULT 'TI--'
                                COMMENT 'technical_insert - The technical insert the tracker is reporting on.  ',
funded_flag                     BOOLEAN      DEFAULT FALSE
                                COMMENT 'funded_flag - Flag indicating whether the program is funded.  ',
fea_flag                        BOOLEAN      DEFAULT FALSE
                                COMMENT 'fea_flag - Flag indicating whether the work is being done under a Financial Exposure Authorization (FEA).  ',
on_dock_need_date               DATE
                                COMMENT 'on_dock_need_date - The date the item(s) is to be delivered to the customer.  ',
pcd_lead_time                   INTEGER      DEFAULT 365
                                COMMENT 'pcd_lead_time - The number of days before the ‘On Dock/Need Date’ the PCD should be completed.  ',
internal_rdd_lead_time          INTEGER      DEFAULT 0
                                COMMENT 'internal_rdd_lead_time - The number of days before the ‘On Dock/Need Date’ the item should be completed by the production organization.  ',
internal_rdd                    DATE
                                COMMENT 'internal_rdd - The date the item(s) should be complete by the production organization.  ',
delivery_lead_time              INTEGER      DEFAULT 30
                                COMMENT 'delivery_lead_time - The number of days before the ‘On Dock/Need Date’ the item(s) should be delivered to the customer.  ',
delivery_required               DATE
                                COMMENT 'delivery_required - The date the item(s) is to be delivered to the customer.  ',
delivery_status                 CHAR(15)
                                COMMENT 'delivery_status - The delivery status of the items to the client.  (‘’, Delivered, Lost, Shipped)  ',
man_pr                          BOOLEAN      DEFAULT FALSE
                                COMMENT 'man_pr - Manassas purchase requisition flag.  ',
man_del_ol                      DATE
                                COMMENT 'man_del_ol - Manassas delivery date outlook.  ',
clw_pr                          BOOLEAN      DEFAULT FALSE
                                COMMENT 'clw_pr - Clearwater purchase requisition flag.  ',
clw_del_ol                      DATE
                                COMMENT 'clw_del_ol - Clearwater delivery date outlook.  ',
part_number                     VARCHAR(50)
                                COMMENT 'part_number - Part Number or BOM.  ',
parts_list_status               CHAR(15)
                                COMMENT 'parts_list_status - The status of the parts list preparation task.  ',
drawing_status                  CHAR(15)
                                COMMENT 'drawing_status - The status of the engineering drawings preparation task.  ',
model                           VARCHAR(30)
                                COMMENT '',
slin                            VARCHAR(30)
                                COMMENT 'slin - Sub-line item number.  ',
est_dollars                     INTEGER      DEFAULT 0
                                COMMENT 'est_dollars - The estimated budget dollars of the PCD.  ',
bom_status                      CHAR(15)
                                COMMENT 'bom_status - The status of the bill of materials preparation task.  ',
date_next_review                DATE
                                COMMENT 'date_next_review - The date the task should next be reviewed.  ',
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

ALTER TABLE pcd_tracker.trackers 
COMMENT 'trackers - Contains all the data need to track the development of the PCD.';


/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('trackers') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/
