/* Source File: omega_batch_tasks_audit.sql                                   */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_batch_tasks_audit                                       */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for omega_batch_tasks that tracks      */
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

-- DROP TABLE IF EXISTS omega_batch_tasks_audit;

CREATE TABLE omega_batch_tasks_audit 
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             UUID         NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by            VARCHAR(50),
--
n_omega_batch_tasks_nm     VARCHAR(50),
o_omega_batch_tasks_nm     VARCHAR(50),
n_omega_batch_tasks_desc   VARCHAR(50),
o_omega_batch_tasks_desc   VARCHAR(50),
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE omega_batch_tasks_audit 
    IS 'omega_batch_tasks_audit - Creates an audit table for omega_batch_tasks that tracks changes to the parent table as they are made.';
