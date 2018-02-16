DROP TABLE gb_pfsawh_process_log; 

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--
--         Table Name: PFSAWH_Process_Log
--         Table Desc: Process log tracking stored procedure performance in the the CMIS database.  
--                     Data is inserted by stored procedure dbo.spr_InsUpd_RptToCourt_ProcessLog.
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 18 December 2007
--
--       Table Source: PFSAWH_Process_Log.sql 
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 18Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--
--
CREATE TABLE gb_pfsawh_process_log
(
    process_key                     NUMBER          NOT NULL,
--
    process_RecId                   NUMBER          NOT NULL,
    module_num                      NUMBER          DEFAULT    0,
    step_num                        NUMBER          DEFAULT    0,
    process_start_date              DATE,
    process_end_date                DATE,
    process_status_code             INT,
--
    sql_error_code                  NUMBER,
    rec_read_int                    NUMBER,
    rec_valid_int                   NUMBER,
    rec_load_int                    NUMBER,
    rec_inserted_int                NUMBER,
    rec_selected_int                NUMBER,
    rec_updated_int                 NUMBER,
    rec_deleted_int                 NUMBER, 
--
    user_login_id                   VARCHAR2(30),
    message                         VARCHAR2(255), 
CONSTRAINT pk_pfsawh_process_log PRIMARY KEY 
    (
    process_key
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsawh_process_log;

CREATE UNIQUE INDEX ixu_pfsawh_process_log 
    ON gb_pfsawh_process_log
    (
    process_key, process_RecId, module_num, step_num
    );

DROP INDEX ixu_pfsawh_process_recid;

CREATE INDEX ixu_pfsawh_process_recid 
    ON GB_PFSAWH_Process_Log
    (
    process_RecId
    );

/*----- Foreign Key -----*/

ALTER TABLE GB_PFSAWH_Process_Log  
    DROP CONSTRAINT FK_PFSAWH_Process_recId;        

ALTER TABLE gb_pfsawh_process_log  
    ADD CONSTRAINT fk_pfsawh_process_recid 
    FOREIGN KEY (process_RecId) 
    REFERENCES gb_pfsawh_processes(process_key);

/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_process_log  
    DROP CONSTRAINT CK_GB_PFSA_process_status_code;       

ALTER TABLE GB_PFSAWH_Process_Log  
    ADD CONSTRAINT ck_gb_pfsa_process_status_code 
    CHECK (process_status_code=-1 OR process_status_code=0 OR process_status_code=1);

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_process_log 
IS 'Process log tracking stored procedure performance in the the CMIS database.  Data is inserted by stored procedure dbo.spr_InsUpd_RptToCourt_ProcessLog.'; 

COMMENT ON COLUMN gb_pfsawh_process_log.process_key 
IS 'Identity and Primary key for facRptToCourtProcessLog records.'; 

COMMENT ON COLUMN gb_pfsawh_process_log.module_num 
IS 'Identities module within a give mutli-step process.'; 

COMMENT ON COLUMN gb_pfsawh_process_log.step_num 
IS 'Identities steps within a give mutli-step process.'; 

COMMENT ON COLUMN gb_pfsawh_process_log.process_start_date 
IS 'When the process started.';

COMMENT ON COLUMN gb_pfsawh_process_log.process_end_date 
IS 'When the process ended.';

COMMENT ON COLUMN gb_pfsawh_process_log.process_status_code  
IS 'Processing status of the process. ';

COMMENT ON COLUMN gb_pfsawh_process_log.process_recid 
IS 'Primary key for facRptToCourtProcessLog records.';

COMMENT ON COLUMN gb_pfsawh_process_log.sql_error_code 
IS 'Return status of the select statement executed.';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_read_int 
IS 'Number of records read by the process.';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_valid_int 
IS 'Number of records found to be valid by the process.';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_load_int 
IS 'Number of records loaded by the process.';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_inserted_int 
IS 'Number of records inserted by the process';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_selected_int 
IS 'Number of records selected by the process';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_updated_int 
IS 'Number of records updateded by the process';

COMMENT ON COLUMN gb_pfsawh_process_log.rec_deleted_int 
IS 'Number of records deleteed by the process';

COMMENT ON COLUMN gb_pfsawh_process_log.user_login_id 
IS 'The user id the this process was run under.';

COMMENT ON COLUMN gb_pfsawh_process_log.message 
IS 'Captures any informated needed for process review.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_process_log');

/*----- Check to see if the table column comments are present -----*/

SELECT    b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_process_log') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_process_log') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
/*----- Populate -----*/

DECLARE

    CURSOR process_cur IS
        SELECT a.process_key, a.message
        FROM gb_pfsawh_process_log a
        ORDER BY a.process_key DESC;
        
    process_rec    process_cur%ROWTYPE;
        
BEGIN 

    DELETE gb_pfsawh_process_log;

    INSERT INTO gb_pfsawh_process_log (process_recid, process_status_code, message) 
        VALUES (1, -1, 'test message');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN process_cur;
    
    LOOP
        FETCH process_cur 
        INTO  process_rec;
        
        EXIT WHEN process_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(process_rec.process_key || ', ' || process_rec.message);
        
    END LOOP;
    
    CLOSE process_cur;
    
END;  

-- COMMIT  
-- ROLLBACK  

/*

SELECT * FROM gb_pfsawh_process_log ORDER BY process_key DESC;  

*/

/*
---------------------------------------
------- dimCMISProcesses        ------- 
---------------------------------------

PRINT    '*** dimCMISProcesses ***'
PRINT    '* Insert test *' 

INSERT 
INTO    dimCMISProcesses (process_Key, process_Desc) 
VALUES    (-100, 'Unit test case 1')

--- Default Review ---

PRINT    '* Default Review *' 

SELECT    process_Key, process_Desc, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
        update_By, update_Dt, delete_Fl, delete_Dt 
FROM    dimCMISProcesses 
WHERE    process_Key < -1

----- PRIMARY KEY constraint -----

PRINT    '* PRIMARY KEY constraint *' 

INSERT 
INTO    dimCMISProcesses (process_Key, process_Desc) 
VALUES    (-100, 'Unit test case 1')

----- FOREIGN KEY constraint -----

--PRINT    '* FOREIGN KEY constraint *' 

--INSERT 
--INTO    dimCMISProcesses (process_Key, process_Desc) 
--VALUES    (-100, 'Unit test case 4')

--- Trigger Review ---

PRINT    '* Trigger Review *' 

UPDATE    dimCMISProcesses 
SET        process_Desc = 'Unit test case 3' 
WHERE    process_Key = -100  

SELECT    process_Key, process_Desc, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
        update_By, update_Dt, delete_Fl, delete_Dt 
FROM    dimCMISProcesses 
WHERE    process_Key = -100 

----- NOT NULL constraint -----

PRINT    '* NOT NULL constraint *' 

INSERT 
INTO    dimCMISProcesses (process_Key) 
VALUES    (NULL)

INSERT 
INTO    dimCMISProcesses (process_Desc) 
VALUES    (NULL)

-----Cleanup -----

PRINT    '* Cleanup *' 

DELETE    dimCMISProcesses WHERE process_Key < -1
--DELETE    dimCMISProcesses_yyy WHERE CatCd < 0

*/
