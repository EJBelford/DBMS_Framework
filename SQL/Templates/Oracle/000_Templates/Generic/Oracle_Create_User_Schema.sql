-- %SCHEMA%

ALTER SESSION SET CONTAINER=orclpdb;

CREATE USER %SCHEMA%
    IDENTIFIED BY pwd4%SCHEMA% 
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
GRANT CONNECT TO %SCHEMA%;
GRANT RESOURCE TO %SCHEMA%;

GRANT CREATE ANY PROCEDURE TO %SCHEMA% ;
GRANT CREATE VIEW TO %SCHEMA% ;
GRANT CREATE SESSION TO %SCHEMA% ;
GRANT CREATE TABLE TO %SCHEMA% ;
GRANT CREATE SYNONYM TO %SCHEMA% ;
GRANT CREATE SEQUENCE TO %SCHEMA% ;
GRANT CREATE ANY TRIGGER TO %SCHEMA% ;

-- orca-01033: Oracle initialization or shutdown in progress
-- https://dba.stackexchange.com/questions/150338/ora-01033-oracle-initialization-or-shutdown-in-progress-error-after-pc-restar

ALTER DATABASE MOUNT;
ALTER DATABASE OPEN;

SELECT username FROM dba_users;
SELECT instance_name, status, database_status FROM v$instance;

SELECT name, open_mode FROM v$pdbs;
ALTER PLUGGABLE DATABASE orclpdb OPEN;
ALTER PLUGGABLE DATABASE orclpdb SAVE STATE;

