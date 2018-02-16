
/* Source File: enum_types.sql                                                */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_types                                                    */
/*      Author: Gene Belford                                                  */
/* Description: The overarching data object that represents whole             */
/*              enumerations in the database by their names.                  */
/*        Date: 2017-06-01                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-01             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

DROP TABLE IF EXISTS pcd_tracker.enum_types;

CREATE TABLE pcd_tracker.enum_types 
(
rec_id                          INTEGER      NOT NULL  AUTO_INCREMENT 
                                COMMENT 'rec_id - Individual unique identification id for the record.  ',
rec_uuid                        CHAR(36)     NOT NULL DEFAULT uuid()
                                COMMENT 'rec_uuid - Stores the Universally Unique Identifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.  ', 
--
enum_type                       VARCHAR(25)  NOT NULL
                                COMMENT 'enum_type - Identifying name of the enumeration in the database.  ',
enum_type_desc                  TEXT         NOT NULL
                                COMMENT 'enum_type_desc - Brief description of the enumeration.  ',
classification                  VARCHAR(100) 
                                COMMENT 'classification - Overall classification of the enumeration and all of its values.  ',
constant                        BOOL         NOT NULL DEFAULT FALSE 
                                COMMENT 'constant - Whether or not the enumeration is constant (unchangeable, probably used in the system), or dynamic (changeable, probably just used for visualization purposes).  ', 
--
status_cd                       CHAR(1)      NOT NULL DEFAULT 'C'
                                COMMENT 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)  ', 
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

ALTER TABLE pcd_tracker.enum_types 
ADD CONSTRAINT pk_enum_types PRIMARY KEY (rec_id);

ALTER TABLE pcd_tracker.enum_types 
COMMENT 'enum_types - The overarching data object that represents whole enumerations in the database by their names.  ';


/*
SELECT pd.table_schema, pd.table_name, pd.table_comment 
FROM information_schema.tables pd 
WHERE pd.table_schema = 'pcd_tracker'
ORDER BY pd.table_name;
*/

/*
SELECT pd.table_schema, pd.table_name, pd.column_name, pd.column_comment 
FROM information_schema.columns pd 
WHERE pd.table_schema = 'pcd_tracker'
    AND pd.table_name = 'enum_types'
ORDER BY pd.ordinal_position;
*/


/* Source File: <tableName>_status.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>_status                                            */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint for <tableName>.              */
/*        Date: 2017-06-01                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-01             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 217 Constraint 

-- ALTER TABLE pcd_tracker.enum_types DROP CONSTRAINT enum_types_status; 

ALTER TABLE pcd_tracker.enum_types 
   ADD CONSTRAINT enum_types_status 
   CHECK (status_cd IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

-- COMMENT ON CONSTRAINT enum_types_status_cd
-- ON pcd_tracker.enum_types
--     IS 'enum_types_status_cd - Defines the "status" constraint for enum_types.';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: enum_types_audit.sql                                          */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_types_audit                                              */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for enum_types that tracks changes     */
/*              to the parent table as they are made.                         */
/*        Date: 2017-06-01                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-01             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

DROP TABLE IF EXISTS pcd_tracker.enum_types_audit;

CREATE TABLE pcd_tracker.enum_types_audit 
(
rec_id                  INTEGER      NOT NULL,
rec_uuid                VARCHAR(36)  NOT NULL,
--
cmd                     CHAR(1)      NOT NULL,
update_date             TIMESTAMP    NOT NULL,
update_by               VARCHAR(50),
--
n_enum_type             VARCHAR(25),  
o_enum_type             VARCHAR(25),   
n_enum_type_desc        TEXT,  
o_enum_type_desc        TEXT, 
n_classification        VARCHAR(100), 
o_classification        VARCHAR(100), 
n_constant              BOOL,
o_constant              BOOL
);
 

ALTER TABLE pcd_tracker.enum_types_audit 
ADD CONSTRAINT pk_enum_types_audit PRIMARY KEY (rec_id, cmd, update_date);

ALTER TABLE pcd_tracker.enum_types_audit 
COMMENT 'enum_types_audit - Creates an audit table for enum_types that tracks changes to the parent table as they are made.';


/* Source File: t_enum_types_audit.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_types                                                    */
/*      Author: Gene Belford                                                  */
/* Description:                                                               */
/*        Date: 2017-06-01                                                    */
/* Source File:                                                               */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-01             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 280 Trigger 

DROP TRIGGER IF EXISTS t_insert_enum_types_audit;
DROP TRIGGER IF EXISTS t_update_enum_types_audit;
DROP TRIGGER IF EXISTS t_delete_enum_types_audit;

DELIMITER $$

CREATE TRIGGER t_insert_enum_types_audit
    AFTER INSERT 
    ON pcd_tracker.enum_types
    FOR EACH ROW
        BEGIN
            INSERT INTO pcd_tracker.enum_types_audit
            (
            rec_id, rec_uuid, cmd,
            update_date, update_by,
            n_enum_type, n_enum_type_desc, n_classification, n_constant
            )
        SELECT NEW.rec_id, NEW.rec_uuid, 'I',
            SYSDATE(), USER(),
            NEW.enum_type, NEW.enum_type_desc, NEW.classification, NEW.constant;
        END; 
        
CREATE TRIGGER t_update_enum_types_audit
    AFTER UPDATE 
    ON pcd_tracker.enum_types
    FOR EACH ROW
        BEGIN
            INSERT INTO pcd_tracker.enum_types_audit
                (
                rec_id, rec_uuid, cmd,
                update_date, update_by,
                n_enum_type, n_enum_type_desc, n_classification, n_constant,
                o_enum_type, o_enum_type_desc, o_classification, o_constant
                )
            SELECT NEW.rec_id, NEW.rec_uuid, 'U',
                SYSDATE(), USER(),
                NEW.enum_type, NEW.enum_type_desc, NEW.classification, NEW.constant,
                OLD.enum_type, OLD.enum_type_desc, OLD.classification, OLD.constant;
            END; 
        
CREATE TRIGGER t_delete_enum_types_audit
    AFTER DELETE 
    ON pcd_tracker.enum_types
    FOR EACH ROW
        BEGIN
            INSERT INTO pcd_tracker.enum_types_audit
                (
                rec_id, rec_uuid, cmd,
                update_date, update_by,
                o_enum_type, o_enum_type_desc, o_classification, o_constant
                )
            SELECT OLD.rec_id, OLD.rec_uuid, 'D',
                SYSDATE(), USER(),
                OLD.enum_type, OLD.enum_type_desc, OLD.classification, OLD.constant;
        END; $$


-- COMMENT ON TRIGGER t_enum_types_audit 
--     ON pcd_tracker.enum_types 
--     IS 't_enum_types_audit - This trigger ';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DELETE FROM pcd_tracker.enum_types;
DELETE FROM pcd_tracker.enum_types_audit;

INSERT
INTO pcd_tracker.enum_types (
    rec_id, rec_uuid, enum_type, enum_type_desc, classification, constant 
    )
VALUES 
(  1, UUID(), 'ACTION',                 CONCAT('test_', SYSDATE()), '', FALSE),
(  2, UUID(), 'APPROVER',               CONCAT('test_', SYSDATE()), '', FALSE),
(  3, UUID(), 'CLASSIFICATION',         CONCAT('test_', SYSDATE()), '', FALSE),
(  4, UUID(), 'CONTRACT',               CONCAT('test_', SYSDATE()), '', FALSE),
(  5, UUID(), 'DEPARTMENT',             CONCAT('test_', SYSDATE()), '', FALSE),
( 18, UUID(), 'FEA',                    CONCAT('test_', SYSDATE()), '', FALSE),
(  6, UUID(), 'FISCAL_YEAR',            CONCAT('test_', SYSDATE()), '', FALSE),
(  7, UUID(), 'HULL',                   CONCAT('test_', SYSDATE()), '', FALSE),
(  8, UUID(), 'LEAD_TIME_DELIVERY',     CONCAT('test_', SYSDATE()), '', FALSE),
(  9, UUID(), 'LEAD_TIME_PCD',          CONCAT('test_', SYSDATE()), '', FALSE),
( 10, UUID(), 'PROGRAM',                CONCAT('test_', SYSDATE()), '', FALSE),
( 11, UUID(), 'ROLE',                   CONCAT('test_', SYSDATE()), '', FALSE),
( 12, UUID(), 'STATUS_DELIVERY',        CONCAT('test_', SYSDATE()), '', FALSE),
( 13, UUID(), 'STATUS_DRAWINGS',        CONCAT('test_', SYSDATE()), '', FALSE),
( 14, UUID(), 'STATUS_PARTS_LIST',      CONCAT('test_', SYSDATE()), '', FALSE),
( 19, UUID(), 'STATUS_PCD',             CONCAT('test_', SYSDATE()), '', FALSE),
( 15, UUID(), 'TASK',                   CONCAT('test_', SYSDATE()), '', FALSE),
( 16, UUID(), 'TECHNOLOGY_INSERTION',   CONCAT('test_', SYSDATE()), '', FALSE),
( 17, UUID(), 'USER',                   CONCAT('test_', SYSDATE()), '', FALSE)
;

SELECT et.*
FROM   pcd_tracker.enum_types et
ORDER BY et.enum_type; 

SELECT eta.*
FROM   pcd_tracker.enum_types_audit eta
ORDER BY eta.rec_id, eta.update_date DESC; 
