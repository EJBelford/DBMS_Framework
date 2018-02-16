/* Source File: fileobj_audit.sql                                             */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: fileobj_audit                                                 */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for fileobj that tracks changes        */
/*              to the parent table as they are made.                         */
/*        Date: 2014-02-26                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2014-02-26             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS fileobj_audit;

CREATE TABLE fileobj_audit 
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             UUID         NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by            VARCHAR(50),
--
n_file_nm                       VARCHAR(255),
o_file_nm                       VARCHAR(255),
n_file_desc                     VARCHAR(2040),
o_file_desc                     VARCHAR(2040),
n_file_type_cd                  VARCHAR(254), 
o_file_type_cd                  VARCHAR(254), 
n_file_retention_policy_cd      INT, 
o_file_retention_policy_cd      INT, 
n_storage_device                VARCHAR(254),
o_storage_device                VARCHAR(254),
n_storage_path                  VARCHAR(254),
o_storage_path                  VARCHAR(254),
n_url                           VARCHAR(254),
o_url                           VARCHAR(254),
n_urn                           VARCHAR(254),
o_urn                           VARCHAR(254),
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE fileobj_audit 
    IS 'fileobj_audit - Creates an audit table for fileobj that tracks changes to the parent table as they are made.'
