/* Source File: t_trackers_audit.sql                                          */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: trackers                                                      */
/*      Author: Gene Belford                                                  */
/* Description:                                                               */
/*        Date: 2017-05-24                                                    */
/* Source File:                                                               */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-24             Gene Belford           Created                      */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 280 Trigger 

-- DROP TRIGGER IF EXISTS t_trackers_audit ON trackers;

CREATE TRIGGER t_trackers_audit 
    AFTER INSERT OR UPDATE OR DELETE 
    ON pcd_tracker.trackers 
    FOR EACH ROW 
    EXECUTE PROCEDURE pcd_tracker.f_trackers_audit(); 


COMMENT ON TRIGGER t_trackers_audit 
    ON pcd_tracker.trackers 
    IS 't_trackers_audit - This trigger ';
