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
rec_id                  INTEGER      NOT NULL  AUTO_INCREMENT PRIMARY KEY
                        COMMENT 'rec_id - Individual unique identification id for the record.  ',
rec_uuid                CHAR(36)     NOT NULL DEFAULT uuid()
                        COMMENT 'rec_uuid - Stores the Universally Unique Identifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.  ', 
--
parent_rec_id           INTEGER      NOT NULL
                        COMMENT 'parent_rec_id - The integer identifier of the parent record.  ',
parent_rec_uuid         CHAR(36)     NULL 
                        COMMENT 'parent_rec_uuid - The UUID identifier of the parent record.  ', 
--
remark_type             VARCHAR(8)   NOT NULL
                        COMMENT 'remark_type -  (tracker, task, review, rework)  ',
remark_pcd_flag         BOOLEAN      NOT NULL DEFAULT true
                        COMMENT 'remark_pcd_flag - Flag that indicates if the remark is to be included in the PCD.  ',
remark_date             TIMESTAMP    NOT NULL DEFAULT SYSDATE()
                        COMMENT 'remark_date - The user id of the individual making the remark.  ',
remark_user             VARCHAR(50)  NOT NULL
                        COMMENT 'remark_user - The user id of the individual making the remark.  ', 
remark                  TEXT         NOT NULL
                        COMMENT 'remark - The text field containing the actual remark.  ', 
--
status                          CHAR(1)      NOT NULL DEFAULT 'C'
                                COMMENT 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)', 
status_by                       VARCHAR(50)  DEFAULT USER()
                                COMMENT 'status_by - The user who last changed the status of the record',
status_date                     TIMESTAMP    NOT NULL DEFAULT SYSDATE()
                                COMMENT 'status_date - The date when the record status was last changed', 
--
insert_date                     TIMESTAMP    NOT NULL DEFAULT SYSDATE()
                                COMMENT 'insert_date - The date the record was created',
insert_by                       VARCHAR(50)  DEFAULT USER()
                                COMMENT 'insert_by - The user/fuction that created the record',
update_date                     TIMESTAMP 
                                COMMENT 'update_date - The date the record was last modified',
update_by                       VARCHAR(50)
                                COMMENT 'update_by - The user/function that last updated the record',
delete_flag                     BOOLEAN      DEFAULT FALSE
                                COMMENT 'delete_flag - A logical flag used to ignore the record as if it was deleted',   
delete_date                     TIMESTAMP
                                COMMENT 'delete_date - The date the logical delete flag was set',
delete_by                       VARCHAR(50)
                                COMMENT 'delete_by - The user/function that set the logical delete flag',
hidden_flag                     BOOLEAN      DEFAULT FALSE
                                COMMENT 'hidden_flag - A flag used to hide/exclude the record from pick lists',   
hidden_date                     TIMESTAMP
                                COMMENT 'hidden_date - The date the hidden flag was set',
hidden_by                       VARCHAR(50)
                                COMMENT 'hidden_by - The user/function that set the hidden flag' 
);

ALTER TABLE pcd_tracker.remarks 
COMMENT 'remarks - Contains a remark information about a given PCD, tasks, or item.  There can be multiple remarks linked to the parent record.  ';


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


    
    
