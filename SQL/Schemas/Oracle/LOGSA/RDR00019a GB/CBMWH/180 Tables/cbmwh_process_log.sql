/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--
--         Table Name: cbmwh_Process_Log
--         Table Desc: Process log tracking stored procedure performance in the the CMIS database.  
--                     Data is inserted by stored procedure dbo.spr_InsUpd_RptToCourt_ProcessLog.
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 18 December 2007
--
--       Table Source: cbmwh_Process_Log.sql 
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 18Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/

-- DROP TABLE cbmwh_process_log; 

CREATE TABLE cbmwh_process_log
(
    process_batch_id                NUMBER, 
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
    rec_merged_int                  NUMBER,
    rec_selected_int                NUMBER,
    rec_updated_int                 NUMBER,
    rec_deleted_int                 NUMBER, 
--
    user_login_id                   VARCHAR2(30),
    message                         VARCHAR2(255)    
) 
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE cbmwh_process_log 
IS 'CBMWH_PROCESS_LOG - Process log tracking stored procedure performance in the the CMIS database.  Data is inserted by stored procedure dbo.spr_InsUpd_RptToCourt_ProcessLog.'; 


COMMENT ON COLUMN cbmwh_process_log.process_key 
IS 'PROCESS_KEY - Identity and Primary key for facRptToCourtProcessLog records.'; 

COMMENT ON COLUMN cbmwh_process_log.module_num 
IS 'MODULE_NUM - Identities module within a give mutli-step process.'; 

COMMENT ON COLUMN cbmwh_process_log.step_num 
IS 'STEP_NUM - Identities steps within a give mutli-step process.'; 

COMMENT ON COLUMN cbmwh_process_log.process_start_date 
IS 'PROCESS_START_DATE - When the process started.';

COMMENT ON COLUMN cbmwh_process_log.process_end_date 
IS 'PROCESS_END_DATE - When the process ended.';

COMMENT ON COLUMN cbmwh_process_log.process_status_code  
IS 'PROCESS_STATUS_CODE - Processing status of the process. ';

COMMENT ON COLUMN cbmwh_process_log.process_recid 
IS 'PROCESS_RECID - Primary key for facRptToCourtProcessLog records.';

COMMENT ON COLUMN cbmwh_process_log.sql_error_code 
IS 'SQL_ERROR_CODE - Return status of the select statement executed.';

COMMENT ON COLUMN cbmwh_process_log.rec_read_int 
IS 'REC_READ_INT - Number of records read by the process.';

COMMENT ON COLUMN cbmwh_process_log.rec_valid_int 
IS 'REC_VALID_INT - Number of records found to be valid by the process.';

COMMENT ON COLUMN cbmwh_process_log.rec_load_int 
IS 'REC_LOAD_INT - Number of records loaded by the process.';

COMMENT ON COLUMN cbmwh_process_log.rec_inserted_int 
IS 'REC_INSERTED_INT - Number of records inserted by the process';

COMMENT ON COLUMN cbmwh_process_log.rec_merged_int 
IS 'REC_MERGED_INT - Number of records merged by the process';

COMMENT ON COLUMN cbmwh_process_log.rec_selected_int 
IS 'REC_SELECTED_INT - Number of records selected by the process';

COMMENT ON COLUMN cbmwh_process_log.rec_updated_int 
IS 'REC_UPDATED_INT - Number of records updateded by the process';

COMMENT ON COLUMN cbmwh_process_log.rec_deleted_int 
IS 'REC_DELETED_INT - Number of records deleteed by the process';

COMMENT ON COLUMN cbmwh_process_log.user_login_id 
IS 'USER_LOGIN_ID - The user id the this process was run under.';

COMMENT ON COLUMN cbmwh_process_log.message 
IS 'MESSAGE - Captures any informated needed for process review.';

/*----- Check to see if the table comment is present -----*/

--SELECT table_name, comments 
--FROM   user_tab_comments 
--WHERE  table_name = UPPER('cbmwh_process_log');

/*----- Check to see if the table column comments are present -----*/

--SELECT    b.column_id, 
--        a.table_name, 
--        a.column_name, 
--        b.data_type, 
--        b.data_length, 
--        b.nullable, 
--        a.comments 
--FROM    user_col_comments a
--LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('cbmwh_process_log') 
--    AND a.column_name = b.column_name
--WHERE    a.table_name = UPPER('cbmwh_process_log') 
--ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

--SELECT a.* 
--FROM   lidb_cmnt@pfsawh.lidbdev a
--WHERE  a.col_name LIKE UPPER('%type_cl%')
--ORDER BY a.col_name 
   
