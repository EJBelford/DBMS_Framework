/* Source File: pcd_audit.sql                                                 */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd_audit                                                     */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for pcd that tracks changes            */
/*              to the parent table as they are made.                         */
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

-- DROP TABLE IF EXISTS pcd_tracker.pcd_audit;

CREATE TABLE pcd_tracker.pcd_audit 
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             UUID         NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by            VARCHAR(50),
--
n_classification_code            VARCHAR(100),
o_classification_code            VARCHAR(100),
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE pcd_tracker.pcd_audit 
    IS 'pcd_audit - Creates an audit table for pcd that tracks changes to the parent table as they are made.';

