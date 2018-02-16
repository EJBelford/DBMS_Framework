/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
-- 
--         Table Name: cbmwh_process_ref
--         Table Desc: Contains a mapping to the name of the stored procedure 
--                     or function
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 19 December 2007 
-- 
--       Table Source: cbmwh_process_ref.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 19Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/

-- DROP TABLE cbmwh_process_ref;    

CREATE TABLE cbmwh_process_ref     
(
    process_recid                    NUMBER           NOT NULL ,
    process_key                      NUMBER           NOT NULL ,
    process_description              VARCHAR2(50)     NOT NULL ,
--
    run_cntrl                        NUMBER,
    override_run_cntrl               VARCHAR2(1)      DEFAULT    'N' ,
--  
    status                           VARCHAR2(1)      DEFAULT    'N' ,
    updt_by                          VARCHAR2(30)     DEFAULT    USER ,
    lst_updt                         DATE             DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)      DEFAULT    'I' , 
    active_date                      DATE             DEFAULT    '01-JAN-1900' , 
    inactive_date                    DATE             DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)     DEFAULT    USER , 
    insert_date                      DATE             DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)     NULL ,
    update_date                      DATE             DEFAULT    '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    delete_date                      DATE             DEFAULT    '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)      DEFAULT    'Y' ,
    hidden_date                      DATE             DEFAULT    '01-JAN-1900'     
) 
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             32K
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

COMMENT ON TABLE cbmwh_process_ref 
IS 'CBMWH_PROCESS_REF - Contains a mapping to the name of the stored procedure or function'; 


COMMENT ON COLUMN cbmwh_process_ref.process_recid 
IS 'PROCESS_RECID - '; 

COMMENT ON COLUMN cbmwh_process_ref.process_key 
IS 'PROCESS_KEY - ';

COMMENT ON COLUMN cbmwh_process_ref.process_description 
IS 'PROCESS_DESCRIPTION - ';

COMMENT ON COLUMN cbmwh_process_ref.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN cbmwh_process_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN cbmwh_process_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN cbmwh_process_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN cbmwh_process_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN cbmwh_process_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN cbmwh_process_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN cbmwh_process_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN cbmwh_process_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN cbmwh_process_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN cbmwh_process_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN cbmwh_process_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN cbmwh_process_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN cbmwh_process_ref.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

ALTER TABLE cbmwh_process_ref   
  ADD CONSTRAINT ck_item_dim_subj_flg 
  CHECK (override_run_cntrl='Y'    OR override_run_cntrl='N');
    
/*----- Check to see if the table comment is present -----*/

--SELECT  table_name, comments 
--FROM    user_tab_comments 
--WHERE   table_name = UPPER('cbmwh_process_ref'); 

/*----- Check to see if the table column comments are present -----*/

--SELECT  b.column_id, 
--        a.table_name, 
--        a.column_name, 
--        b.data_type, 
--        b.data_length, 
--        b.nullable, 
--        a.comments 
--FROM    user_col_comments a
--LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('cbmwh_process_ref') 
--    AND a.column_name = b.column_name
--WHERE    a.table_name = UPPER('cbmwh_process_ref') 
--ORDER BY b.column_id; 

