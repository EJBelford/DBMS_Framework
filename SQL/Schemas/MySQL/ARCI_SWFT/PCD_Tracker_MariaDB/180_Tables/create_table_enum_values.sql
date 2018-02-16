
/* Source File: create_table_enum_values.sql                                  */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_values                                                   */
/*      Author: Gene Belford                                                  */
/* Description: Individual enumeration values that belong under a particular enumeration type.                                                   */
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

-- DROP TABLE IF EXISTS pcd_tracker.enum_values;

CREATE TABLE pcd_tracker.enum_values 
(
rec_id                          INTEGER      NOT NULL  AUTO_INCREMENT PRIMARY KEY 
                                COMMENT 'rec_id - Individual unique identification id for the record.  ',
rec_uuid                        CHAR(36)     NOT NULL DEFAULT uuid()
                                COMMENT 'rec_uuid - Stores the Universally Unique Identifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.  ', 
--
parent_rec_id                   INTEGER      NOT NULL
                                COMMENT 'parent_rec_id - The integer identifier of the parent record.  ',
parent_rec_uuid                 CHAR(36)     NULL 
                                COMMENT 'parent_rec_uuid - The UUID identifier of the parent record.  ', 
--
enum_type                       VARCHAR(25)   NOT NULL
                                COMMENT 'enum_type - Name/identifier of the overarching enumeration type that this value belongs to.  ',
enum_value                      VARCHAR(25)   NOT NULL
                                COMMENT 'enum_value - The actual specific enumeration value.  ',
order_by                        INTEGER       NOT NULL DEFAULT 0 
                                COMMENT 'order_by - Integer value used to create a custom sort order not possible programmatically.  ',
enum_display_name               VARCHAR(50)   NOT NULL
                                COMMENT 'enum_display_name - ',
description                     TEXT 
                                COMMENT 'description - Brief description of the enumeration value.  ',	
constant                        BOOL          NOT NULL DEFAULT 0 
                                COMMENT 'constant - Whether or not enumeration value is unchangeable or dynamic.  ',
--
status_cd                       CHAR(1)      NOT NULL DEFAULT 'C'
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

-- ALTER TABLE pcd_tracker.enum_values 
-- ADD CONSTRAINT pk_enum_values PRIMARY KEY (rec_id);

ALTER TABLE pcd_tracker.enum_values 
COMMENT 'enum_values - Individual enumeration values that belong under a particular enumeration type.  ';


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
    AND pd.table_name = 'enum_values'
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

-- ALTER TABLE pcd_tracker.enum_values DROP CONSTRAINT enum_values_status; 

ALTER TABLE pcd_tracker.enum_values 
   ADD CONSTRAINT enum_values_status 
   CHECK (status_cd IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

-- COMMENT ON CONSTRAINT enum_values_status_cd
-- ON pcd_tracker.enum_values
--     IS 'enum_values_status_cd - Defines the "status" constraint for enum_values.';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: enum_values_audit.sql                                             */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_values_audit                                                 */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for enum_values that tracks changes        */
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

DROP TABLE IF EXISTS pcd_tracker.enum_values_audit;

CREATE TABLE pcd_tracker.enum_values_audit
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             VARCHAR(36)  NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    NOT NULL,
update_by            VARCHAR(50),
--
n_enum_type                       VARCHAR(25),
o_enum_type                       VARCHAR(25),
n_enum_value                      VARCHAR(25),
o_enum_value                      VARCHAR(25),
n_order_by                        INTEGER,
o_order_by                        INTEGER,
n_enum_display_name               VARCHAR(50),
o_enum_display_name               VARCHAR(50),
n_description                     TEXT,	
o_description                     TEXT,	
n_constant                        BOOL,
o_constant                        BOOL 
);


ALTER TABLE pcd_tracker.enum_values_audit 
ADD CONSTRAINT pk_enum_values_audit PRIMARY KEY (rec_id, cmd, update_date);

ALTER TABLE pcd_tracker.enum_values_audit
COMMENT 'enum_values_audit - Creates an audit table for enum_values that tracks changes to the parent table as they are made.';


/* Source File: t_enum_values_audit.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_values                                                    */
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
/* 2017-06-01           Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 280 Trigger 

DROP TRIGGER IF EXISTS t_insert_enum_values_audit;
DROP TRIGGER IF EXISTS t_update_enum_values_audit;
DROP TRIGGER IF EXISTS t_delete_enum_values_audit;

DELIMITER $$

CREATE TRIGGER t_insert_enum_values_audit
    AFTER INSERT 
    ON pcd_tracker.enum_values
    FOR EACH ROW
        BEGIN
            INSERT INTO pcd_tracker.enum_values_audit
            (
            rec_id, rec_uuid, cmd,
            update_date, update_by,
            n_enum_type, n_enum_value, n_order_by, n_enum_display_name, n_description, n_constant
            )
        SELECT NEW.rec_id, NEW.rec_uuid, 'I',
            SYSDATE(), USER(),
            NEW.enum_type, NEW.enum_value, NEW.order_by, NEW.enum_display_name, NEW.description, NEW.constant;
        END; 
        
CREATE TRIGGER t_update_enum_values_audit
    AFTER UPDATE 
    ON pcd_tracker.enum_values
    FOR EACH ROW
        BEGIN
            INSERT INTO pcd_tracker.enum_values_audit
                (
                rec_id, rec_uuid, cmd,
                update_date, update_by,
                n_enum_type, n_enum_value, n_order_by, n_enum_display_name, n_description, n_constant, 
                o_enum_type, o_enum_value, o_order_by, o_enum_display_name, o_description, o_constant
                )
            SELECT NEW.rec_id, NEW.rec_uuid, 'U',
                SYSDATE(), USER(),
                NEW.enum_type, NEW.enum_value, NEW.order_by, NEW.enum_display_name, NEW.description, NEW.constant, 
                OLD.enum_type, OLD.enum_value, OLD.order_by, OLD.enum_display_name, OLD.description, OLD.constant;
            END; 
        
CREATE TRIGGER t_delete_enum_values_audit
    AFTER DELETE 
    ON pcd_tracker.enum_values
    FOR EACH ROW
        BEGIN
            INSERT INTO pcd_tracker.enum_values_audit
                (
                rec_id, rec_uuid, cmd,
                update_date, update_by,
                o_enum_type, o_enum_value, o_order_by, o_enum_display_name, o_description, o_constant
                )
            SELECT OLD.rec_id, OLD.rec_uuid, 'D',
                SYSDATE(), USER(),
                OLD.enum_type, OLD.enum_value, OLD.order_by, OLD.enum_display_name, OLD.description, OLD.constant;
        END; $$


-- COMMENT ON TRIGGER t_enum_types_audit 
--     ON pcd_tracker.enum_types 
--     IS 't_enum_types_audit - This trigger ';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DELETE FROM pcd_tracker.enum_values;
DELETE FROM pcd_tracker.enum_values_audit;

INSERT
INTO pcd_tracker.enum_values (
    rec_id, rec_uuid, parent_rec_id, enum_type, enum_value, order_by, enum_display_name, description 
    )
VALUES 
(  60, UUID(),  6, 'FISCAL_YEAR', 'FY15',     5,    '2015',  'Fiscal 2015'),
(  61, UUID(),  6, 'FISCAL_YEAR', 'FY16',    10,    '2016',  'Fiscal 2015'),
(  62, UUID(),  6, 'FISCAL_YEAR', 'FY17',    15,    '2017',  'Fiscal 2015'),
(  63, UUID(),  6, 'FISCAL_YEAR', 'FY18',    20,    '2018',  'Fiscal 2015'),
(  64, UUID(),  6, 'FISCAL_YEAR', 'FY19',    25,    '2019',  'Fiscal 2015'),
(  65, UUID(),  6, 'FISCAL_YEAR', 'FY20',    30,    '2020',  'Fiscal 2015'),

(1070, UUID(),  7, 'HULL',  '21',          5,    'Hull 21',   'USS New York (LPD-21)'),
(1071, UUID(),  7, 'HULL',  '22',         10,    'Hull 22',   'USS New York (LPD-221)'),
(1072, UUID(),  7, 'HULL', '752',         15,    'Hull 752',  'USS Pasadena (SSN-752)'),
(1073, UUID(),  7, 'HULL', '763',         20,    'Hull 763',  'USS Santa Fe (SSN-763)'),
(1074, UUID(),  7, 'HULL', 'SSBN #1L',    25,    'SSBN #1L',  'SSBN #1L'),

(1075, UUID(),  7, 'HULL', '589',        900,    'SSN 589',   'USS Scorpion'),

( 150, UUID(), 15, 'TASK', '',     0,    'Blank',                         CONCAT('test_', SYSDATE())),
( 151, UUID(), 15, 'TASK', 'BOM',  5,    'Bill of Materials',             CONCAT('test_', SYSDATE())),
( 152, UUID(), 15, 'TASK', 'DWG', 10,    'Drawings',                      CONCAT('test_', SYSDATE())),
( 153, UUID(), 15, 'TASK', 'PCD', 15,    'Program Control Directives',    CONCAT('test_', SYSDATE())),
( 154, UUID(), 15, 'TASK', 'PN',  20,    'Part Number',                   CONCAT('test_', SYSDATE())),
( 155, UUID(), 15, 'TASK', 'PL',  25,    'Parts List',                    CONCAT('test_', SYSDATE())),

( 170, UUID(), 17, 'TECHNOLOGY_INSERTION', 'TI10',     5,    'TI10',  'TI 10'),
( 171, UUID(), 17, 'TECHNOLOGY_INSERTION', 'TI14',    10,    'TI14',  'TI 14'),
( 172, UUID(), 17, 'TECHNOLOGY_INSERTION', 'TI16',    15,    'TI16',  'TI 16'),
( 173, UUID(), 17, 'TECHNOLOGY_INSERTION', 'TI18',    20,    'TI18',  'TI 18'), 

( 180, UUID(), 18, 'FEA', 'NA',    0,    'Not Applicable',  'Not Applicable'),
( 181, UUID(), 18, 'FEA', 'N',    10,    'NO',              'No'),
( 182, UUID(), 18, 'FEA', 'Y',    15,    'YES',             'Yes') , 

( 193, UUID(), 19, 'STATUS_PCD', 'A',    15,    'Approved',  'Approved'), 
( 190, UUID(), 19, 'STATUS_PCD', 'D',     0,    'Draft',     'Draft'),
( 192, UUID(), 19, 'STATUS_PCD', 'R',    10,    'Rework',    'Rework'), 
( 191, UUID(), 19, 'STATUS_PCD', 'S',     5,    'Submitted', 'Submitted') 
; 

SELECT et.*
FROM   pcd_tracker.enum_values et
ORDER BY et.enum_type, et.order_by; 

SELECT eta.*
FROM   pcd_tracker.enum_values_audit eta
ORDER BY eta.rec_id, eta.update_date DESC; 
