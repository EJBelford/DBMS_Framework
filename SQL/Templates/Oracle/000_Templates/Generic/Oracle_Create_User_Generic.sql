ALTER SESSION SET CONTAINER=orclpdb;

CREATE USER generic
    IDENTIFIED BY pwd4generic 
    DEFAULT TABLESPACE "USERS"
    TEMPORARY TABLESPACE "TEMP" 
    QUOTA 20M ON "USERS";
    
-- Validate    
    
SELECT * FROM dba_users;

SELECT username FROM dba_users WHERE username LIKE 'G%';

-- ROLES



-- SYSTEM PRIVILEGES
GRANT CONNECT TO generic;
GRANT RESOURCE TO generic;

GRANT CREATE ANY PROCEDURE TO generic ;
GRANT CREATE VIEW TO generic ;
GRANT CREATE SESSION TO generic ;
GRANT CREATE TABLE TO generic ;
GRANT CREATE SYNONYM TO generic ;
GRANT CREATE SEQUENCE TO generic ;
GRANT CREATE ANY TRIGGER TO generic ;

-- orca-01033: Oracle initialization or shutdown in progress
-- https://dba.stackexchange.com/questions/150338/ora-01033-oracle-initialization-or-shutdown-in-progress-error-after-pc-restar

ALTER DATABASE MOUNT;
ALTER DATABASE OPEN;

SELECT username FROM dba_users;
SELECT instance_name, status, database_status FROM v$instance;

SELECT name, open_mode FROM v$pdbs;
ALTER PLUGGABLE DATABASE orclpdb OPEN;
ALTER PLUGGABLE DATABASE orclpdb SAVE STATE;

