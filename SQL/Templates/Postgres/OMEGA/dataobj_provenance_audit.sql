/* Source File: dataobj_provenance_audit.sql                                  */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: dataobj_provenance_audit                                      */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for dataobj_provenance that tracks     */
/*              changes to the parent table as they are made.                 */
/*        Date: 2014-02-27                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2014-02-27             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS dataobj_provenance_audit;

CREATE TABLE dataobj_provenance_audit 
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             UUID         NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by            VARCHAR(50),
--
n_provenance_cd         VARCHAR(24), 
o_provenance_cd         VARCHAR(24), 
n_prov_who              VARCHAR(50),
o_prov_who              VARCHAR(50),
n_was_generated_by      VARCHAR(50), 
o_was_generated_by      VARCHAR(50), 
n_act_on_behalf_of      VARCHAR(50), 
n_was_attributed_to     VARCHAR(50), 
n_prov_what             VARCHAR(50), 
n_was_derived_from      VARCHAR(50), 
n_prov_where            VARCHAR(50), 
n_prov_how              VARCHAR(50), 
n_prov_why              VARCHAR(50),
n_provenance_comment    VARCHAR(50), 
n_was_associated_wtih   VARCHAR(50), 
n_was_informed_by       VARCHAR(50), 
n_was_used_by           VARCHAR(50), 
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE dataobj_provenance_audit 
    IS 'dataobj_provenance_audit - Creates an audit table for dataobj_provenance that tracks changes to the parent table as they are made.';
