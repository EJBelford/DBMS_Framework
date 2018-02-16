/* Source File: remarks_seq.sql                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd_tracker.remarks_seq                                       */
/*      Author: Gene Belford                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
/*        Date: 2017-05-25                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-25             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 170 Sequence 

DROP SEQUENCE IF EXISTS pcd_tracker.remarks_seq;

CREATE SEQUENCE pcd_tracker.remarks_seq 
    INCREMENT   1
    MINVALUE    1
    MAXVALUE    9223372036854775807
    START       1
    CACHE       1;

    
COMMENT ON SEQUENCE pcd_tracker.remarks_seq 
    IS 'remarks_seq - Creates a sequence number for remarks that is assigned to the rec_id each new record is created.';


ALTER TABLE pcd_tracker.remarks_seq 
    OWNER TO postgres; 

