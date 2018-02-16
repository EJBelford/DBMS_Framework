/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_std_debug_seq                                           */
/*      Author: Gene Belford                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
/*        Date: 2013-11-20                                                    */
/* Source File: omega_std_debug_seq.sql                                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-11-20             Gene Belford          Created                      */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP SEQUENCE IF EXISTS omega_std_debug_seq;

CREATE SEQUENCE omega_std_debug_seq 
    INCREMENT   1
    MINVALUE    1
    MAXVALUE    9223372036854775807
    START       1
    CACHE       1;

    
COMMENT ON SEQUENCE omega_std_debug_seq 
    IS 'omega_std_debug_seq - Creates a sequence number for omega_std_debug that is assigned to the rec_id each new record is created.';


ALTER TABLE omega_std_debug_seq 
    OWNER TO postgres; 
