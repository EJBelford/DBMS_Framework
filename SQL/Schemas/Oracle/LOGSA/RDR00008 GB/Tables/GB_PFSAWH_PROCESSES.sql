DROP TABLE gb_pfsawh_processes    

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
-- 
--         Table Name: gb_pfsawh_processes
--         Table Desc: Contains a mapping to the name of the stored procedure or function
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 19 December 2007
-- 
--       Table Source: gb_pfsawh_processes.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 19Dec07 - GB  - 00000000 - 0000 - Created 
-- 
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_processes     
(
    process_RecId                                NUMBER              NOT NULL ,
    process_Key                                  NUMBER              NOT NULL ,
    process_Description                          VARCHAR2(50)        NOT NULL ,
--
    status                                       VARCHAR2(1)         DEFAULT    'N' ,
    updt_by                                      VARCHAR2(30)        DEFAULT    USER ,
    lst_updt                                     DATE                DEFAULT    SYSDATE ,
--
    active_flag                                  VARCHAR2(1)         DEFAULT    'I' , 
    active_date                                  DATE                DEFAULT    '01-JAN-1900' , 
    inactive_date                                DATE                DEFAULT    '31-DEC-2099' ,
--
    insert_by                                    VARCHAR2(20)        DEFAULT    USER , 
    insert_date                                  DATE                DEFAULT    SYSDATE , 
    update_by                                    VARCHAR2(20)        NULL ,
    update_date                                  DATE                DEFAULT    '01-JAN-1900' ,
    delete_flag                                  VARCHAR2(1)         DEFAULT    'N' ,
    delete_date                                  DATE                DEFAULT    '01-JAN-1900' ,
    hidden_flag                                  VARCHAR2(1)         DEFAULT    'Y' ,
    hidden_date                                  DATE                DEFAULT    '01-JAN-1900' ,
CONSTRAINT gb_pfsawh_processes PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_processes_id;

CREATE UNIQUE INDEX ixu_pfsawh_processes_id 
    ON gb_pfsawh_processes(process_recid);

DROP INDEX ixu_pfsawh_processes_desc;

CREATE UNIQUE INDEX ixu_pfsawh_processes_desc 
    ON gb_pfsawh_processes(process_description);

/*----- Constraints -----*/

ALTER TABLE GB_PFSAWH_Processes  
    DROP CONSTRAINT ck_gb_pfsawh_processes_act_fl;        

ALTER TABLE GB_PFSAWH_Processes  
    ADD CONSTRAINT ck_gb_pfsawh_processes_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE GB_PFSAWH_Processes  
    DROP CONSTRAINT CK_GB_PFSAWH_Processes_DEL_FL;        

ALTER TABLE GB_PFSAWH_Processes  
    ADD CONSTRAINT ck_gb_pfsawh_processes_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_processes  
    DROP CONSTRAINT ck_gb_pfsawh_processes_hide_fl;        

ALTER TABLE gb_pfsawh_processes  
    ADD CONSTRAINT ck_gb_pfsawh_processes_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_processes  
    DROP CONSTRAINT ck_gb_pfsawh_processes_status        

ALTER TABLE gb_pfsawh_processes  
    ADD CONSTRAINT ck_gb_pfsawh_processes_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_processes 
IS 'Contains a mapping to the name of the stored procedure or function'; 


COMMENT ON COLUMN gb_pfsawh_processes.process_recid 
IS ''; 

COMMENT ON COLUMN gb_pfsawh_processes.process_key 
IS '';

COMMENT ON COLUMN gb_pfsawh_processes.process_description 
IS '';

COMMENT ON COLUMN gb_pfsawh_processes.status 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_processes.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_processes.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_processes.active_flag 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_processes.active_date 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_processes.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_processes.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_processes.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_processes.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_processes.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_processes.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_processes.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_processes.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_processes.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT  table_name, comments 
FROM    user_tab_comments 
WHERE   table_name = UPPER('gb_pfsawh_processes'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_processes') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_processes') 
ORDER BY b.column_id; 

/*----- Populate -----*/

DECLARE

    CURSOR processes_cur IS
        SELECT a.process_RecId, a.process_Key, a.process_Description
        FROM GB_PFSAWH_Processes a
        ORDER BY a.process_RecId;
        
    processes_rec    processes_cur%ROWTYPE;
        
BEGIN 
    INSERT INTO GB_PFSAWH_Processes (process_Key, process_Description, status) 
        VALUES ( -1,   'NOT APPLICABLE', 'C');
    INSERT INTO GB_PFSAWH_Processes (process_Key, process_Description, status) 
        VALUES (  1,   'pr_PHSAWH_InsUpd_ProcessLog', 'C');
    INSERT INTO GB_PFSAWH_Processes (process_Key, process_Description, status) 
        VALUES (  10,  'pr_PFSAWH_Processlog_Cleanup', 'C');
    INSERT INTO GB_PFSAWH_Processes (process_Key, process_Description, status) 
        VALUES (  11,  'pr_PFSAWH_stdPfsaDebugTbl_Del', 'C');
    INSERT INTO GB_PFSAWH_Processes (process_Key, process_Description, status) 
        VALUES (  100, 'maintain_PFSA_Warehouse', 'C'); 
    INSERT INTO GB_PFSAWH_Processes (process_Key, process_Description, status) 
        VALUES (  101, 'pr_PHSAWH_Item_Part_Load', 'C'); 
    
    DBMS_OUTPUT.ENABLE(10000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN processes_cur;
    
    LOOP
        FETCH processes_cur 
        INTO  processes_rec;
        
        EXIT WHEN processes_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE( processes_rec.process_RecId || ', ' || 
                              processes_rec.process_Key || ', ' || 
                              processes_rec.process_Description);
        
    END LOOP;
    
    CLOSE processes_cur;
    
END;  
    
COMMIT;   

/*

SELECT * FROM gb_pfsawh_processes; 

*/
