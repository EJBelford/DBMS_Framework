DELIMITER $$

/* Source File: create_table_<table>.sql                                      */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <table>                                                       */
/*      Author: <author>                                                      */
/* Description: <description>                                                 */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS <schema>.<table>;
$$
CREATE TABLE <schema>.<table> 
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
<field01>                       VARCHAR(8)   NOT NULL
                                COMMENT '<field01> - ',
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
$$
-- ALTER TABLE <schema>.<table> 
-- ADD CONSTRAINT pk_<table> PRIMARY KEY (rec_id);
$$
ALTER TABLE <schema>.<table> 
COMMENT '<table> - <description> ';

$$
/*
SELECT pd.table_schema, pd.table_name, pd.table_comment 
FROM information_schema.tables pd 
WHERE pd.table_schema = '<schema>'
ORDER BY pd.table_name;
*/
$$
/*
SELECT pd.table_schema, pd.table_name, pd.column_name, pd.column_comment 
FROM information_schema.columns pd 
WHERE pd.table_schema = '<schema>'
    AND pd.table_name = '<table>'
ORDER BY pd.ordinal_position;
*/


/* Source File: <table>_status.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <table>_status                                            */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint for <tableName>.              */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 217 Constraint 
$$
-- ALTER TABLE <schema>.<table> DROP CONSTRAINT <table>_status; 
$$
ALTER TABLE <schema>.<table> 
   ADD CONSTRAINT <table>_status 
   CHECK (status_cd IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     
$$
-- COMMENT ON CONSTRAINT <table>_status_cd
-- ON <schema>.<table>
--     IS '<table>_status_cd - Defines the "status" constraint for <table>.';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: <table>_audit.sql                                             */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <table>_audit                                                 */
/*      Author: <author>                                                  */
/* Description: Creates an audit table for <table> that tracks changes        */
/*              to the parent table as they are made.                         */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 
$$
DROP TABLE IF EXISTS <schema>.<table>_audit;
$$
CREATE TABLE <schema>.<table>_audit
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             VARCHAR(36)  NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    NOT NULL,
update_by            VARCHAR(50),
--
n_<table>_nm         VARCHAR(50),
o_<table>_nm         VARCHAR(50),
n_<table>_desc       VARCHAR(50),
o_<table>_desc       VARCHAR(50),
);

$$
ALTER TABLE <schema>.<table>_audit 
ADD CONSTRAINT pk_<table>_audit PRIMARY KEY (rec_id, cmd, update_date);
$$
ALTER TABLE <schema>.<table>_audit
COMMENT '<table>_audit - Creates an audit table for <table> that tracks changes to the parent table as they are made.';


/* Source File: t_<table>_audit.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <table>                                                    */
/*      Author: <author>                                                  */
/* Description:                                                               */
/*        Date: <yyyy-mm-dd>                                                    */
/* Source File:                                                               */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>           <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 280 Trigger 
$$
DROP TRIGGER IF EXISTS t_insert_<table>_audit;
DROP TRIGGER IF EXISTS t_update_<table>_audit;
DROP TRIGGER IF EXISTS t_delete_<table>_audit;

$$
CREATE TRIGGER t_insert_<table>_audit
    AFTER INSERT 
    ON <schema>.<table>
    FOR EACH ROW
        BEGIN
            INSERT INTO <schema>.<table>_audit
            (
            rec_id, rec_uuid, cmd,
            update_date, update_by,
            n_<table>_nm
            )
        SELECT NEW.rec_id, NEW.rec_uuid, 'I',
            SYSDATE(), USER(),
            NEW.n_<table>_nm;
        END; 
 
$$
CREATE TRIGGER t_update_<table>_audit
    AFTER UPDATE 
    ON <schema>.<table>
    FOR EACH ROW
        BEGIN
            INSERT INTO <schema>.<table>_audit
                (
                rec_id, rec_uuid, cmd,
                update_date, update_by,
                n_n_<table>_nm,
                o_n_<table>_nm
                )
            SELECT NEW.rec_id, NEW.rec_uuid, 'U',
                SYSDATE(), USER(),
                NEW.n_<table>_nm,
                OLD.n_<table>_nm;
            END; 

$$       
CREATE TRIGGER t_delete_<table>_audit
    AFTER DELETE 
    ON <schema>.<table>
    FOR EACH ROW
        BEGIN
            INSERT INTO <schema>.<table>_audit
                (
                rec_id, rec_uuid, cmd,
                update_date, update_by,
                n_<table>_nm
                )
            SELECT OLD.rec_id, OLD.rec_uuid, 'D',
                SYSDATE(), USER(),
                OLD.n_<table>_nm;
        END; $$


-- COMMENT ON TRIGGER t_enum_types_audit 
--     ON pcd_tracker.enum_types 
--     IS 't_enum_types_audit - This trigger ';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
$$

DELETE FROM <schema>.<table>;
$$

DELETE FROM <schema>.<table>_audit;
$$

INSERT
INTO <schema>.<table> (
    rec_id, rec_uuid, <table>, <table>_desc 
    )
VALUES 
(  1, UUID(), 'ACTION', CONCAT('test_', SYSDATE())),
( 17, UUID(), 'USER',   CONCAT('test_', SYSDATE()))
;
$$

SELECT et.*
FROM   <schema>.<table> et
ORDER BY et.enum_type; 
$$

SELECT eta.*
FROM   <schema>.<table>_audit eta
ORDER BY eta.rec_id, eta.update_date DESC; 
trackers
$$

DELIMITER ; 
