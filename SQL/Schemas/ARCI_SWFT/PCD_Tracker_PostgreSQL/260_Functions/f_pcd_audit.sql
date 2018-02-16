-- DROP FUNCTION IF EXISTS pcd_tracker.f_pcd_audit;

CREATE OR REPLACE FUNCTION pcd_tracker.f_pcd_audit() 
    RETURNS TRIGGER AS 
    
$BODY$ 
    
/* Source File: f_pcd_audit.sql                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_pcd_audit                                                   */
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
        
        INSERT INTO pcd_tracker.pcd_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_classification_code
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.classification_code;
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO pcd_tracker.pcd_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_classification_code, o_classification_code
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.classification_code, OLD.classification_code;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO pcd_tracker.pcd_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            o_classification_code
            )  
        SELECT OLD.rec_id, OLD.rec_uuid, 'D', 
            CLOCK_TIMESTAMP(), USER, 
            OLD.classification_code;
    
    END IF;
    
    RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION pcd_tracker.f_pcd_audit() 
    IS 'f_pcd_audit() - This function ';


ALTER FUNCTION pcd_tracker.f_pcd_audit() 
    OWNER TO postgres; 
