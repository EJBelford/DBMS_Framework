/* Source File: remarks.sql                                                   */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: remarks                                                       */
/*      Author: Gene Belford                                                  */
/* Description: Contains a remark information about a given PCD, tasks, or    */
/*              item.  There can be multiple remarks linked to the            */
/*              parent record.                                                */
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

-- 180 Table 

-- DROP TABLE IF EXISTS pcd_tracker.remarks;

CREATE TABLE pcd_tracker.remarks 
(
rec_id                INTEGER      NOT NULL DEFAULT nextval('pcd_tracker.remarks_seq'::regclass),
--
rec_uuid              UUID         NOT NULL DEFAULT uuid_generate_v4(), 
--
parent_rec_id         INTEGER      NOT NULL,
parent_rec_uuid       UUID         NOT NULL DEFAULT uuid_generate_v4(), 
--
remark_type           VARCHAR(8)   NOT NULL,
remark_pcd_flag       BOOLEAN      NOT NULL DEFAULT true,
remark_date           TIMESTAMP    NOT NULL DEFAULT CLOCK_TIMESTAMP(),
remark_user           VARCHAR(50)  NOT NULL, 
remark                TEXT         NOT NULL, 
--
status                CHAR(1)      NOT NULL DEFAULT 'C', 
status_by             VARCHAR(50)  DEFAULT USER,
status_date           TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(), 
--
insert_date           TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(),
insert_by             VARCHAR(50)  DEFAULT USER,
update_date           TIMESTAMP    WITH TIME ZONE,
update_by             VARCHAR(50),
delete_flag           BOOLEAN      DEFAULT 'FALSE',   
delete_date           TIMESTAMP    WITH TIME ZONE,
delete_by             VARCHAR(50),
hidden_flag           BOOLEAN      DEFAULT 'FALSE',   
hidden_date           TIMESTAMP    WITH TIME ZONE,
hidden_by             VARCHAR(50),
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );

COMMENT ON TABLE pcd_tracker.remarks 
IS 'remarks - Contains a remark information about a given PCD, tasks, or item.  There can be multiple remarks linked to the parent record.  ';

COMMENT ON COLUMN pcd_tracker.remarks.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN pcd_tracker.remarks.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 

COMMENT ON COLUMN pcd_tracker.remarks.parent_rec_id  
IS 'parent_rec_id - ';
COMMENT ON COLUMN pcd_tracker.remarks.COMMENT ON COLUMN pcd_tracker.remarks.parent_rec_uuid  
IS 'parent_rec_uuid - ';

COMMENT ON COLUMN pcd_tracker.remarks.remark_type  
IS 'remark_type - (tracker, task, review, rework)  '; 
COMMENT ON COLUMN pcd_tracker.remarks.remark_pcd_flag  
IS 'remark_pcd_flag - Flag that indicates if the remark is to be included in the PCD.  '; 
COMMENT ON COLUMN pcd_tracker.remarks.remark_date  
IS 'remark_date - The date the remark was enter into the application.  ';
COMMENT ON COLUMN pcd_tracker.remarks.remark_user  
IS 'remark_user - The user id of the individual making the remark.  ';
COMMENT ON COLUMN pcd_tracker.remarks.remark  
IS 'remark - The text field containing the actual remark.  '; 

COMMENT ON COLUMN pcd_tracker.remarks.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)'; 
COMMENT ON COLUMN pcd_tracker.remarks.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN pcd_tracker.remarks.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN pcd_tracker.remarks.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN pcd_tracker.remarks.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN pcd_tracker.remarks.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN pcd_tracker.remarks.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN pcd_tracker.remarks.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN pcd_tracker.remarks.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN pcd_tracker.remarks.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN pcd_tracker.remarks.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN pcd_tracker.remarks.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN pcd_tracker.remarks.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';

/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('remarks') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: remarks_audit.sql                                             */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: remarks_audit                                                 */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for remarks that tracks changes        */
/*              to the parent table as they are made.                         */
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

-- 180 Table 

-- DROP TABLE IF EXISTS pcd_tracker.remarks_audit;

-- CREATE TABLE pcd_tracker.remarks_audit 
-- (
-- rec_id               INTEGER      NOT NULL,
-- --
-- rec_uuid             UUID         NOT NULL,
-- --
-- cmd                  CHAR(1)      NOT NULL,
-- update_date          TIMESTAMP    WITH TIME ZONE NOT NULL,
-- update_by            VARCHAR(50),
-- --
-- n_remarks_nm     VARCHAR(50),
-- o_remarks_nm     VARCHAR(50),
-- n_remarks_desc   VARCHAR(50),
-- o_remarks_desc   VARCHAR(50),
-- --
-- PRIMARY KEY (rec_id, cmd, update_date) 
-- )
-- WITH (
--     OIDS = FALSE 
--     );
-- 
-- 
-- COMMENT ON TABLE pcd_tracker.remarks_audit 
--     IS 'remarks_audit - Creates an audit table for remarks that tracks changes to the parent table as they are made.';


-- DROP FUNCTION IF EXISTS pcd_tracker.f_remarks_audit;

-- CREATE OR REPLACE FUNCTION pcd_tracker.f_remarks_audit() 
--     RETURNS TRIGGER AS 
--     
-- $BODY$ 
--     
-- /* Source File: f_remarks_audit.sql                                       */
-- /*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
-- /*                                                                            */
-- /* Module Name: f_remarks_audit                                           */
-- /*      Author: Gene Belford                                                      */
-- /* Description:                                                               */
-- /*        Date: 2017-05-25                                                  */
-- /*                                                                            */
-- /*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
-- /*                                                                            */
-- /* Change History                                                             */
-- /* ==============                                                             */
-- /* Date:       Chng_Ctrl  Name                  Description                   */
-- /* ==========  =========  ====================  ============================= */
-- /* 2017-05-25            Gene Belford           Created                       */
-- /*                                                                            */
-- /*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
-- /*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
-- /*                                                                            */
-- /* Unit Test                                                                  */
-- /*
-- 
-- 
-- */
-- /*                                                                            */
-- /*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
-- 
-- -- 260 Function 
-- 
-- BEGIN 
-- 
--     IF (TG_OP='INSERT') THEN 
--         
--         INSERT INTO pcd_tracker.remarks_audit 
--             (
--             rec_id, rec_uuid, cmd, 
--             update_date, update_by, 
--             n_remarks_nm
--             )  
--         SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
--             CLOCK_TIMESTAMP(), USER, 
--             NEW.remarks_nm;
--     
--     ELSIF (TG_OP='UPDATE') THEN 
--         
--         INSERT INTO pcd_tracker.remarks_audit 
--             (
--             rec_id, rec_uuid, cmd, 
--             update_date, update_by, 
--             n_remarks_nm, o_remarks_nm
--             )  
--         SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
--             CLOCK_TIMESTAMP(), USER, 
--             NEW.remarks_nm, OLD.remarks_nm;
--     
--     ELSIF (TG_OP='DELETE') THEN 
--         
--         INSERT INTO pcd_tracker.remarks_audit 
--             (
--             rec_id, rec_uuid, cmd, 
--             update_date, update_by, 
--             o_remarks_nm
--             )  
--         SELECT OLD.rec_id, OLD.rec_uuid, 'D', 
--             CLOCK_TIMESTAMP(), USER, 
--             OLD.remarks_nm;
--     
--     END IF;
--     
--     RETURN NULL;
-- 
-- END;
--     
-- $BODY$
-- LANGUAGE plpgsql VOLATILE 
-- COST 100;
-- 
-- 
-- COMMENT ON FUNCTION pcd_tracker.f_remarks_audit() 
--     IS 'f_remarks_audit() - This function ';


-- ALTER FUNCTION pcd_tracker.f_remarks_audit() 
--     OWNER TO postgres; 
    
    
/* Source File: t_remarks_audit.sql                                           */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: remarks                                                       */
/*      Author: Gene Belford                                                  */
/* Description:                                                               */
/*        Date: 2017-05-25                                                    */
/* Source File:                                                               */
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

-- 280 Trigger 

-- DROP TRIGGER IF EXISTS t_remarks_audit ON pcd_tracker.remarks;

-- CREATE TRIGGER t_remarks_audit 
--     AFTER INSERT OR UPDATE OR DELETE 
--     ON pcd_tracker.remarks 
--     FOR EACH ROW 
--     EXECUTE PROCEDURE pcd_tracker.f_remarks_audit(); 
-- 
-- 
-- COMMENT ON TRIGGER t_remarks_audit 
--     ON pcd_tracker.remarks 
--     IS 't_remarks_audit - This trigger ';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- INSERT 
-- INTO pcd_tracker.remarks (
--     parent_rec_id, parent_rec_uuid, 
--     remark_type, remark_user, remark 
--     )
-- VALUES (
--     15, '00000000-0000-0000-0000-000000000001', 
--     'TRACKER', 'EJB', 'test_' || CLOCK_TIMESTAMP()
--     );
--     
-- SELECT r.* 
-- FROM   pcd_tracker.remarks r 
-- ORDER BY r.rec_id DESC; 


    
    
