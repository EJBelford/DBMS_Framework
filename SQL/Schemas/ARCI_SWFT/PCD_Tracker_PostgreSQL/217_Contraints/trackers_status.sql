/* Source File: trackers_status.sql                                           */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: trackers_status                                               */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint for trackers.                 */
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

-- ALTER TABLE pcd_tracker.trackers DROP CONSTRAINT trackers_status; 

ALTER TABLE pcd_tracker.trackers 
   ADD CONSTRAINT trackers_status 
   CHECK (status IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

COMMENT ON CONSTRAINT trackers_status 
    ON pcd_tracker.trackers 
    IS 'trackers_status - Defines the "status" constraint for trackers.';







