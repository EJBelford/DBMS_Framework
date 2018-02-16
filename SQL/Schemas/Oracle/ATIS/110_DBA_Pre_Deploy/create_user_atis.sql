ALTER SESSION SET CONTAINER=orclpdb;

CREATE USER atis
    IDENTIFIED BY pwd4atis 
    DEFAULT TABLESPACE "USERS"
    TEMPORARY TABLESPACE "TEMP" 
    QUOTA 20M ON "USERS";
    
-- Validate    
    
SELECT * FROM dba_users;

SELECT username 
FROM dba_users
WHERE username LIKE 'A%';

-- ROLES



-- SYSTEM PRIVILEGES
GRANT CONNECT TO atis;
GRANT RESOURCE TO atis;

GRANT CREATE ANY PROCEDURE TO atis ;
GRANT CREATE VIEW TO atis ;
GRANT CREATE SESSION TO atis ;
GRANT CREATE TABLE TO atis ;
GRANT CREATE SYNONYM TO atis ;
GRANT CREATE SEQUENCE TO atis ;
GRANT CREATE ANY TRIGGER TO atis ;

-- orca-01033: Oracle initialization or shutdown in progress
-- https://dba.stackexchange.com/questions/150338/ora-01033-oracle-initialization-or-shutdown-in-progress-error-after-pc-restar

ALTER DATABASE MOUNT;
ALTER DATABASE OPEN;

SELECT username FROM dba_users;
SELECT instance_name, status, database_status FROM v$instance;

SELECT name, open_mode FROM v$pdbs;
ALTER PLUGGABLE DATABASE orclpdb OPEN;
ALTER PLUGGABLE DATABASE orclpdb SAVE STATE;

