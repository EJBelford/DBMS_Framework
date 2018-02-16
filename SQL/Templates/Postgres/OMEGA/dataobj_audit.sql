/* Source File: dataobj_audit.sql                                             */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: dataobj_audit                                                 */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for dataobj that tracks changes        */
/*              to the parent table as they are made.                         */
/*        Date: 2013-12-31                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-31             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS dataobj_audit;

CREATE TABLE dataobj_audit 
(
rec_id                          INTEGER      NOT NULL,
--
rec_uuid                        UUID         NOT NULL, 
--
cmd                             CHAR(1)      NOT NULL,
update_date                     TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by                       VARCHAR(50),
--
n_dataobj_nm                    VARCHAR(255),
o_dataobj_nm                    VARCHAR(255),
n_dataobj_desc                  VARCHAR(2040),
o_dataobj_desc                  VARCHAR(2040),
n_dataobj_type_cd               INTEGER,
o_dataobj_type_cd               INTEGER,
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE dataobj_audit 
    IS 'dataobj_audit - Creates an audit table for dataobj that tracks changes to the parent table as they are made.';
