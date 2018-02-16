/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/
--
--         Table Name: atis_awt_tasks
--         Table Desc: List of Army Warrior Task (AWT)
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 2017-11-27
--
--       Table Source: atis_awt_tasks 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/
--     Change History:
-- YYYY-MM-DD - Who           - Ticket # - CR # - Details
-- 2017-11-27 - Gene Belford  - 00000000 - 0000 - Created 
-- 
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

-- DROP TABLE atis_awt_tasks; 

CREATE TABLE atis_awt_tasks
(
    rec_id                           NUMBER,
    rec_uuid                         VARCHAR2(40),
--
    task_number                      VARCHAR2(12), 
    task_title                       VARCHAR2(100),
    skill_level                      INTEGER,
    subject_area                     INTEGER, 
--
    status                           VARCHAR2(1)      DEFAULT    'C' ,
    updt_by                          VARCHAR2(30)     DEFAULT    USER ,
    lst_updt                         DATE             DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)      DEFAULT    'I' , 
    active_date                      DATE             DEFAULT    '01-JAN-2017' , 
    inactive_date                    DATE             DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)     DEFAULT    USER , 
    insert_date                      DATE             DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)     NULL ,
    update_date                      DATE             DEFAULT    '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    delete_date                      DATE             DEFAULT    '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    hidden_date                      DATE             DEFAULT    '01-JAN-1900' ) 
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

COMMENT ON TABLE atis_awt_tasks 
IS 'atis_awt_tasks - Process log tracking stored procedure performance in the the CMIS database.  Data is inserted by stored procedure dbo.spr_InsUpd_RptToCourt_ProcessLog.'; 


COMMENT ON COLUMN atis_awt_tasks.rec_id 
IS 'rec_id - '; 

COMMENT ON COLUMN atis_awt_tasks.rec_uuid 
IS 'rec_uuid - '; 

--

COMMENT ON COLUMN atis_awt_tasks.task_number 
IS 'task_number - The task number is a l0-digit number that identifies each task. The first three digits of the number represent the proponent code for that task.'; 

COMMENT ON COLUMN atis_awt_tasks.task_name 
IS 'task_title - The task title identifies the action to perform'; 

COMMENT ON COLUMN atis_awt_tasks.skill_level 
IS 'skill_level - '; 

COMMENT ON COLUMN atis_awt_tasks.subject_area 
IS 'subject_area - '; 

--

COMMENT ON COLUMN atis_awt_tasks.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN atis_awt_tasks.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN atis_awt_tasks.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN atis_awt_tasks.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN atis_awt_tasks.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN atis_awt_tasks.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN atis_awt_tasks.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN atis_awt_tasks.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN atis_awt_tasks.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN atis_awt_tasks.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN atis_awt_tasks.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN atis_awt_tasks.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN atis_awt_tasks.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN atis_awt_tasks.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/
/*

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('atis_awt_tasks');

*/

/*----- Check to see if the table column comments are present -----*/
/*

SELECT b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('atis_awt_tasks') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('atis_awt_tasks') 
ORDER BY b.column_id; 

*/
/*----- Look-up field description from master LIDB table -----*/
/*

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
*/
