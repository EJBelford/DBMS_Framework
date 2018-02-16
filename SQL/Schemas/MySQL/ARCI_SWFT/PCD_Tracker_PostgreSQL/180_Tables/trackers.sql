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
rec_id                          INTEGER      NOT NULL DEFAULT nextval('pcd_tracker.trackers_seq'::regclass),
--
rec_uuid                        UUID         NOT NULL DEFAULT uuid_generate_v4(), 
--
hull_number                     CHAR(10)     NOT NULL DEFAULT 'Unknown',
fiscal_year                     CHAR(4)      NOT NULL DEFAULT 'FY--',
technical_insert                CHAR(4)      NOT NULL DEFAULT 'TI--',
funded_flag                     BOOLEAN      DEFAULT 'F',
fea_flag                        BOOLEAN      DEFAULT 'F',
on_dock_need_date               DATE,
pcd_lead_time                   INTEGER      DEFAULT 365,
internal_rdd_lead_time          INTEGER      DEFAULT 0,
internal_rdd                    DATE,
delivery_lead_time              INTEGER      DEFAULT 30,
delivery_required               DATE,
delivery_status                 CHAR(3),
man_pr                          BOOLEAN      DEFAULT 'F',
man_del_ol                      DATE,
clw_pr                          BOOLEAN      DEFAULT 'F',
clw_del_ol                      DATE,
part_number                     VARCHAR(30),
parts_list_status               CHAR(3),
drawing_status                  CHAR(3),
mod                             VARCHAR(30),
slin                            VARCHAR(30),
est_dollars                     INTEGER      DEFAULT 0,
bom_status                      CHAR(3),
date_next_review                DATE,
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

COMMENT ON TABLE pcd_tracker.trackers 
IS 'trackers - Contains all the data need to track the development of the PCD.';

COMMENT ON COLUMN pcd_tracker.trackers.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN pcd_tracker.trackers.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 

COMMENT ON COLUMN pcd_tracker.trackers.fiscal_year 
IS 'fiscal_year - The fiscal year the tracker is reporting on.  ';
COMMENT ON COLUMN pcd_tracker.trackers.hull_number 
IS 'hull_number - The hull number the tracker is reporting on.  ';
COMMENT ON COLUMN pcd_tracker.trackers.technical_insert 
IS 'technical_insert - The technical insert the tracker is reporting on.  ';
COMMENT ON COLUMN pcd_tracker.trackers.funded_flag 
IS 'funded_flag - Flag indicating whether the program is funded.  ';
COMMENT ON COLUMN pcd_tracker.trackers.fea_flag 
IS 'fea_flag - Flag indicating whether the work is being done under a Financial Exposure Authorization (FEA).  ';
COMMENT ON COLUMN pcd_tracker.trackers.on_dock_need_date 
IS 'on_dock_need_date - The date the item(s) is to be delivered to the customer.  ';
COMMENT ON COLUMN pcd_tracker.trackers.pcd_lead_time 
IS 'pcd_lead_time - The number of days before the ‘On Dock/Need Date’ the PCD should be completed.  ';
COMMENT ON COLUMN pcd_tracker.trackers.internal_rdd_lead_time 
IS 'internal_rdd_lead_time - The number of days before the ‘On Dock/Need Date’ the item should be completed by the production organization.  ';
COMMENT ON COLUMN pcd_tracker.trackers.internal_rdd 
IS 'internal_rdd - The date the item(s) should be complete by the production organization.  ';
COMMENT ON COLUMN pcd_tracker.trackers.delivery_lead_time 
IS 'delivery_lead_time - The number of days before the ‘On Dock/Need Date’ the item(s) should be delivered to the customer.  ';
COMMENT ON COLUMN pcd_tracker.trackers.delivery_required 
IS 'delivery_required - The date the item(s) is to be delivered to the customer.  ';
COMMENT ON COLUMN pcd_tracker.trackers.delivery_status 
IS 'delivery_status - The delivery status of the items to the client.  (‘’, Delivered, Lost, Shipped)  ';
COMMENT ON COLUMN pcd_tracker.trackers.man_pr  
IS 'trackers.man_pr - Manassas purchase requisition flag  ';
COMMENT ON COLUMN pcd_tracker.trackers.man_del_ol 
IS 'man_del_ol - Manassas delivery date outlook.  ';
COMMENT ON COLUMN pcd_tracker.trackers.clw_pr 
IS 'clw_pr - Clearwater purchase requisition flag  ';
COMMENT ON COLUMN pcd_tracker.trackers.clw_del_ol 
IS 'clw_del_ol - Clearwater delivery date outlook.  ';
COMMENT ON COLUMN pcd_tracker.trackers.part_number 
IS 'part_number - Part Number or BOM.  ';
COMMENT ON COLUMN pcd_tracker.trackers.parts_list_status 
IS 'parts_list_status - The status of the parts list preparation task.  ';
COMMENT ON COLUMN pcd_tracker.trackers.drawing_status 
IS 'drawing_status - The status of the engineering drawings preparation task.  ';
COMMENT ON COLUMN pcd_tracker.trackers.mod 
IS 'mod - ';
COMMENT ON COLUMN pcd_tracker.trackers.slin 
IS 'slin - Sub-line item number  ';
COMMENT ON COLUMN pcd_tracker.trackers.est_dollars 
IS 'est_dollars - The estimated budget dollars of the PCD.  ';
COMMENT ON COLUMN pcd_tracker.trackers.bom_status 
IS 'bom_status - The status of the bill of materials preparation task.  ';
COMMENT ON COLUMN pcd_tracker.trackers.date_next_review 
IS 'date_next_review - The date the task should next be reviewed.  ';

COMMENT ON COLUMN pcd_tracker.trackers.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)'; 
COMMENT ON COLUMN pcd_tracker.trackers.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN pcd_tracker.trackers.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN pcd_tracker.trackers.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN pcd_tracker.trackers.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN pcd_tracker.trackers.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN pcd_tracker.trackers.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN pcd_tracker.trackers.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN pcd_tracker.trackers.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN pcd_tracker.trackers.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN pcd_tracker.trackers.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN pcd_tracker.trackers.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN pcd_tracker.trackers.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';

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
