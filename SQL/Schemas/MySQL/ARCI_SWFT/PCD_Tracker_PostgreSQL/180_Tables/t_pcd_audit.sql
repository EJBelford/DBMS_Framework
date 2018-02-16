/* Source File: t_pcd_audit.sql                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd                                                           */
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
/* 2017-05-24             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 280 Trigger 

-- DROP TRIGGER IF EXISTS t_pcd_audit ON pcd_tracker.pcd;

CREATE TRIGGER t_pcd_audit 
    AFTER INSERT OR UPDATE OR DELETE 
    ON pcd_tracker.pcd 
    FOR EACH ROW 
    EXECUTE PROCEDURE pcd_tracker.f_pcd_audit(); 


COMMENT ON TRIGGER t_pcd_audit 
    ON pcd_tracker.pcd 
    IS 't_pcd_audit - This trigger ';

