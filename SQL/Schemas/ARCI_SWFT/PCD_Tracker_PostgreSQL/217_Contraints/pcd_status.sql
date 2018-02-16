/* Source File: pcd_status.sql                                                */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd_status                                                    */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint for pcd.                      */
/*        Date: 2013-12-18                                                    */
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

-- 217 Constraint 

-- ALTER TABLE pcd_tracker.pcd DROP CONSTRAINT pcd_status; 

ALTER TABLE pcd_tracker.pcd 
   ADD CONSTRAINT pcd_status 
   CHECK (status IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

COMMENT ON CONSTRAINT pcd_status 
    ON pcd_tracker.pcd 
    IS 'pcd_status - Defines the "status" constraint for pcd.';
