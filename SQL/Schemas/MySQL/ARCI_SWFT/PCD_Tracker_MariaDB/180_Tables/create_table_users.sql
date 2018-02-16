/* Source File: create_table_users.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: users                                                         */
/*      Author: Gene Belford                                                  */
/* Description: Holds a list of PCD users and their assigned roles.           */
/*        Date: 2017-06-13                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-13             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS pcd_tracker.users;

CREATE TABLE pcd_tracker.users 
(
rec_id                          INTEGER      NOT NULL  AUTO_INCREMENT PRIMARY KEY 
                                COMMENT 'rec_id - Individual unique identification id for the record.  ',
rec_uuid                        CHAR(36)     NOT NULL DEFAULT uuid()
                                COMMENT 'rec_uuid - Stores the Universally Unique Identifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.  ', 
--
name_first                      VARCHAR(24)   NOT NULL
                                COMMENT 'name_first - ',
name_last                       VARCHAR(24)   NOT NULL
                                COMMENT 'name_lastt - ',
name_nick                       VARCHAR(12) 
                                COMMENT 'name_nick - ',
email_1                         VARCHAR(50) 
                                COMMENT 'email - ',
email_2                         VARCHAR(50) 
                                COMMENT 'email - ',
phone_work                      VARCHAR(50) 
                                COMMENT 'phone - ',
cell                            VARCHAR(50) 
                                COMMENT 'cell - ',
addr_1                          VARCHAR(50) 
                                COMMENT 'addr_1 - ',
addr_2                          VARCHAR(50) 
                                COMMENT 'addr_2 - ',
city                            VARCHAR(50) 
                                COMMENT 'city - ',
state                           VARCHAR(2) 
                                COMMENT 'state - ',
zip_code                        VARCHAR(10) 
                                COMMENT 'zip_code - ',
--
last_access                     TIMESTAMP    NOT NULL DEFAULT SYSDATE() 
                                COMMENT 'last_access - ',
--
flag_user                       BOOL         NOT NULL DEFAULT '0' 
                                COMMENT 'flag_user - ',
flag_admin                      BOOL         NOT NULL DEFAULT '0' 
                                COMMENT 'flag_admin - ',
flag_reviewer                   BOOL         NOT NULL DEFAULT '0' 
                                COMMENT 'flag_reviewer - ',
flag_action                     BOOL         NOT NULL DEFAULT '0' 
                                COMMENT 'flag_action - ',
flag_receipient                 BOOL         NOT NULL DEFAULT '0' 
                                COMMENT 'flag_admin - ',
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

-- ALTER TABLE pcd_tracker.users 
-- ADD CONSTRAINT pk_users PRIMARY KEY (rec_id);

ALTER TABLE pcd_tracker.users 
COMMENT 'users - Holds a list of PCD users and their assigned roles. ';


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
    AND pd.table_name = 'users'
ORDER BY pd.ordinal_position;
*/


/* Source File: users_status.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: users_status                                            */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint for users.              */
/*        Date: 2017-06-13                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-13             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 217 Constraint 

-- ALTER TABLE pcd_tracker.users DROP CONSTRAINT users_status; 

ALTER TABLE pcd_tracker.users 
   ADD CONSTRAINT users_status 
   CHECK (status_cd IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

-- COMMENT ON CONSTRAINT users_status_cd
-- ON pcd_tracker.users
--     IS 'users_status_cd - Defines the "status" constraint for users.'; 

ALTER TABLE pcd_tracker.users 
    DROP INDEX udx_users_namel_namef; 

CREATE UNIQUE INDEX udx_users_namel_namef 
    ON pcd_tracker.users (name_last, name_first);


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DELETE FROM pcd_tracker.users;

INSERT
INTO pcd_tracker.users (
    rec_id, rec_uuid, name_first, name_last, name_nick, 
    email_1, email_2, phone_work, cell, 
    addr_1, addr_2, city, state, zip_code  
--    , last_access, 
--    flag_user, flag_admin, flag_reviewer, flag_action, flag_receipient  
    )
VALUES 
(   01, uuid_v4(), 'Eugene', 'Belford', 'Gene', 
    'eugene.j.belford@lmco.com', null, '703.367.2108', '203.530.3121', 
    '0 Main Street', null, 'Manassas', 'MD', '01234-5678' 
),  
(   02, uuid_v4(), 'Joey', 'Eubank', 'Joey', 
    'joey.eubank@lmco.com', null, '703.367.3214', null, 
    '9500 Godwin Drive', null, 'Manassas', 'VA', '20110' 
), 
(   03, uuid_v4(), 'Eric', 'Mencke', 'Eric', 
    'eric.j.mencke@lmco.com', null, '703.367.1292', null, 
    '9500 Godwin Drive', null, 'Manassas', 'VA', '20110' 
),
(   04, uuid_v4(), 'Joe', 'Fanto', 'Joe', 
    'joe.fanto@lmco.com', null, '703.367.1562', null, 
    '9500 Godwin Drive', null, 'Manassas', 'VA', '20110' 
);

SELECT u.*
FROM   pcd_tracker.users u
ORDER BY u.name_last, u.name_first; 
