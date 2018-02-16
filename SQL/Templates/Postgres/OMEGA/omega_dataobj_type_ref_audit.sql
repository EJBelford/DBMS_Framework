/* Source File: omega_dataobj_type_ref_audit.sql                              */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_dataobj_type_ref_audit                                  */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for omega_dataobj_type_ref that tracks */
/*              changes to the parent table as they are made.                 */
/*        Date: 2014-01-29                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2014-01-29             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_dataobj_type_ref_audit;

CREATE TABLE omega_dataobj_type_ref_audit 
(
rec_id          INTEGER         NOT NULL,
--
rec_uuid        UUID            NOT NULL,
--
cmd             CHAR(1)         NOT NULL,
update_date     TIMESTAMP       WITH TIME ZONE NOT NULL,
update_by       VARCHAR(50),
--
n_dataobj_type_cd     INTEGER,
o_dataobj_type_cd     INTEGER,
n_dataobj_type_nm     VARCHAR(50),
o_dataobj_type_nm     VARCHAR(50),
n_dataobj_type_desc   VARCHAR(50),
o_dataobj_type_desc   VARCHAR(50),
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE omega_dataobj_type_ref_audit 
    IS 'omega_dataobj_type_ref_audit - Creates an audit table for omega_dataobj_type_ref that tracks changes to the parent table as they are made.';
