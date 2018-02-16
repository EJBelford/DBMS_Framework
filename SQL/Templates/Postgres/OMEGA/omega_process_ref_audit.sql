/* Source File: omega_process_ref_audit.sql                                   */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_process_ref_audit                                       */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for omega_process_ref that tracks      */
/*              changes to the parent table as they are made.                 */
/*        Date: 2013-12-18                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-18             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_process_ref_audit;

CREATE TABLE omega_process_ref_audit 
(
rec_id                         INTEGER      NOT NULL,
--
rec_uuid                       UUID         NOT NULL,
--
cmd                            CHAR(1)      NOT NULL,
update_date                    TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by                      VARCHAR(50),
--
n_process_id                   INTEGER,
o_process_id                   INTEGER,
n_process_name                 VARCHAR(50),
o_process_name                 VARCHAR(50),
n_process_run_ctrl             INTEGER,
o_process_run_ctrl             INTEGER,
n_process_run_ctrl_override    BOOLEAN,
o_process_run_ctrl_override    BOOLEAN,
n_active_flag                  BOOLEAN,
o_active_flag                  BOOLEAN,
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE omega_process_ref_audit  
IS 'omega_process_ref_audit - Creates an audit table for omega_process_ref that tracks changes to the parent table as they are made.';

  

