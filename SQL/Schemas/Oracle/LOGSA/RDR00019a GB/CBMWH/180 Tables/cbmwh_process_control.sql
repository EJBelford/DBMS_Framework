/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: cbmwh_process_control
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_process_control.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 02 JANUSRY 2008
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/

-- DROP TABLE   cbmwh_process_control;
	
CREATE TABLE cbmwh_process_control 
(
    process_control_id            NUMBER              NOT NULL ,
--
    process_control_name          VARCHAR2(30)        NOT NULL ,
    process_control_value         VARCHAR2(10)        NOT NULL ,
    process_control_description   VARCHAR2(100)       NULL ,
--
    status                        VARCHAR2(1)         DEFAULT    'N' ,
    updt_by                       VARCHAR2(30)        DEFAULT    user ,
    lst_updt                      DATE                DEFAULT    sysdate ,
--
    active_flag                   VARCHAR2(1)         DEFAULT    'I' , 
    active_date                   DATE                DEFAULT    '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT    '31-DEC-2099' ,
--
    insert_by                     VARCHAR2(30)        DEFAULT    user , 
    insert_date                   DATE                DEFAULT    sysdate , 
    update_by                     VARCHAR2(30)        NULL ,
    update_date                   DATE                DEFAULT    '01-JAN-1900' ,
    delete_by                     VARCHAR2(30)        NULL ,
    delete_flag                   VARCHAR2(1)         DEFAULT    'N' ,
    delete_date                   DATE                DEFAULT    '01-JAN-1900' ,
    hidden_by                     VARCHAR2(30)        NULL ,
    hidden_flag                   VARCHAR2(1)         DEFAULT    'Y' ,
    hidden_date                   DATE                DEFAULT    '01-JAN-1900'
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
logging 
nocompress 
nocache
noparallel
monitoring;


/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE cbmwh_process_control 
IS 'CBMWH_PROCESS_CONTROL - Master process control table for CBMWH to eliminate hard coding in processes. '; 


COMMENT ON COLUMN cbmwh_process_control.process_control_id
IS 'PROCESS_CONTROL_ID - Record sequenece. '; 
    
COMMENT ON COLUMN cbmwh_process_control.process_control_name 
IS 'PROCESS_CONTROL_NAME - Field name. '; 

COMMENT ON COLUMN cbmwh_process_control.process_control_value 
IS 'PROCESS_CONTROL_VALUE - The value used by other processes. '; 

COMMENT ON COLUMN cbmwh_process_control.process_control_description
IS 'PROCESS_CONTROL_DESCRIPTION - Purpose/description of control field. '; 

COMMENT ON COLUMN cbmwh_process_control.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN cbmwh_process_control.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN cbmwh_process_control.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN cbmwh_process_control.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN cbmwh_process_control.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN cbmwh_process_control.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN cbmwh_process_control.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN cbmwh_process_control.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN cbmwh_process_control.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN cbmwh_process_control.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN cbmwh_process_control.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN cbmwh_process_control.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN cbmwh_process_control.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN cbmwh_process_control.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT  table_name, comments 
FROM    user_tab_comments 
WHERE   table_name = UPPER('cbmwh_process_control'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b 
    ON b.table_name = UPPER('cbmwh_process_control') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('cbmwh_process_control') 
ORDER BY b.column_id 

