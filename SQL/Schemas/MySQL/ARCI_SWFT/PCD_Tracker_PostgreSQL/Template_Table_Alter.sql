/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>_alter_<yyyy-mm-dd>                                */
/*      Author: <author>                                                      */
/* Description: This script alters the base table.  It is intended to         */
/*              support the change management process.                        */
/*        Date: <yyyy-mm-dd>                                                  */
/* Source File: <tableName>_seq.sql                                           */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>           Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 130 Schema_Pre_Deploy 

ALTER TABLE <tableName> 
    DROP mandatorymetadata_security_c_0,
    DROP mandatorymetadata_security_c_2,
    DROP mandatorymetadata_security_c_1,
    DROP mandatorymetadata_security_d_7,
    DROP mandatorymetadata_security_d_6,
    DROP mandatorymetadata_security_d_3,
    DROP mandatorymetadata_security_d_4,
    DROP mandatorymetadata_security_d_5,
    DROP mandatorymetadata_security_d_1,
    DROP mandatorymetadata_security_d_2,
    DROP mandatorymetadata_security_d_0,
    DROP mandatorymetadata_security_f_0,
    DROP mandatorymetadata_security_f_1,
    DROP mandatorymetadata_security_n_0,
    DROP mandatorymetadata_security_o_0,
    DROP mandatorymetadata_security_r_0,
    DROP mandatorymetadata_security_s_1,
    DROP mandatorymetadata_security_s_0,
    DROP mandatorymetadata_security_t_0; 
    
ALTER TABLE <tableName> 
    ADD  mandatorymetadata_security_c_0 VARCHAR(254),
    ADD  mandatorymetadata_security_c_2 VARCHAR(254),
    ADD  mandatorymetadata_security_c_1 VARCHAR(254),
    ADD  mandatorymetadata_security_d_7 VARCHAR(254),
    ADD  mandatorymetadata_security_d_6 VARCHAR(254),
    ADD  mandatorymetadata_security_d_3 VARCHAR(254),
    ADD  mandatorymetadata_security_d_4 VARCHAR(254),
    ADD  mandatorymetadata_security_d_5 VARCHAR(254),
    ADD  mandatorymetadata_security_d_1 VARCHAR(254),
    ADD  mandatorymetadata_security_d_2 VARCHAR(254),
    ADD  mandatorymetadata_security_d_0 VARCHAR(254),
    ADD  mandatorymetadata_security_f_0 VARCHAR(254),
    ADD  mandatorymetadata_security_f_1 VARCHAR(254),
    ADD  mandatorymetadata_security_n_0 VARCHAR(254),
    ADD  mandatorymetadata_security_o_0 VARCHAR(254),
    ADD  mandatorymetadata_security_r_0 VARCHAR(254),
    ADD  mandatorymetadata_security_s_1 VARCHAR(254),
    ADD  mandatorymetadata_security_s_0 VARCHAR(254),
    ADD  mandatorymetadata_security_t_0 VARCHAR(254);  
    
    
