-- DROP FUNCTION IF EXISTS f_trackers_audit;

CREATE OR REPLACE FUNCTION pcd_tracker.f_trackers_audit() 
    RETURNS TRIGGER AS 
    
$BODY$ 
    
/* Source File: f_trackers_audit.sql                                          */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_trackers_audit                                              */
/*      Author: Gene Belford                                                  */
/* Description:                                                               */
/*        Date: 2017-05-24                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-24            Gene Belford           Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*


*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 260 Function 

BEGIN 

    IF (TG_OP='INSERT') THEN 
        
        INSERT INTO pcd_tracker.trackers_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_on_dock_need_date
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.on_dock_need_date;
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO pcd_tracker.trackers_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_on_dock_need_date, o_on_dock_need_date
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.on_dock_need_date, OLD.on_dock_need_date;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO pcd_tracker.trackers_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            o_on_dock_need_date
            )  
        SELECT OLD.rec_id, OLD.rec_uuid, 'D', 
            CLOCK_TIMESTAMP(), USER, 
            OLD.on_dock_need_date;
    
    END IF;
    
    RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION pcd_tracker.f_trackers_audit() 
    IS 'f_trackers_audit() - This function ';


ALTER FUNCTION pcd_tracker.f_trackers_audit() 
    OWNER TO postgres; 







