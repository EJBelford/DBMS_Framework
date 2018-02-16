/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd_tracker.pcd_seq                                           */
/*      Author: Gene Belford                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
/*        Date: 2017-05-24                                                    */
/* Source File: pcd_seq.sql                                                   */
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

-- 170 Sequence 

DROP SEQUENCE IF EXISTS pcd_tracker.pcd_seq;

CREATE SEQUENCE pcd_tracker.pcd_seq 
    INCREMENT   1
    MINVALUE    1
    MAXVALUE    9223372036854775807
    START       1
    CACHE       1;

    
COMMENT ON SEQUENCE pcd_tracker.pcd_seq 
    IS 'pcd_seq - Creates a sequence number for pcd that is assigned to the rec_id each new record is created.';


ALTER TABLE pcd_tracker.pcd_seq 
    OWNER TO postgres; 
