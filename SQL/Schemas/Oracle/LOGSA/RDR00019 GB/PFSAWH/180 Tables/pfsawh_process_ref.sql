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

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_process_ref_seq;

CREATE SEQUENCE pfsawh_process_ref_seq
    START WITH 1000
--    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     

DROP TABLE pfsawh_process_ref;
/

CREATE TABLE pfsawh_process_ref     
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
    hidden_date                                  DATE                DEFAULT    '01-JAN-1900' --,
--CONSTRAINT pfsawh_process_ref PRIMARY KEY 
--    (
--    process_key
--    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

/*----- Indexs -----*/

DROP INDEX ixu_pfsawh_process_ref_id;

CREATE UNIQUE INDEX ixu_pfsawh_process_ref_id 
    ON pfsawh_process_ref(process_recid);

DROP INDEX ixu_pfsawh_processes_desc;

CREATE UNIQUE INDEX ixu_pfsawh_process_ref_desc 
    ON pfsawh_process_ref(process_description);

/*----- Constraints -----*/

ALTER TABLE pfsawh_process_ref  
    DROP CONSTRAINT ck_pfsawh_process_ref_act_fl;        

ALTER TABLE pfsawh_process_ref  
    ADD CONSTRAINT ck_pfsawh_process_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE pfsawh_process_ref  
    DROP CONSTRAINT CK_pfsawh_process_ref_DEL_FL;        

ALTER TABLE pfsawh_process_ref  
    ADD CONSTRAINT ck_pfsawh_process_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_process_ref  
    DROP CONSTRAINT ck_pfsawh_process_ref_hide_fl;        

ALTER TABLE pfsawh_process_ref  
    ADD CONSTRAINT ck_pfsawh_process_ref_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE pfsawh_process_ref  
    DROP CONSTRAINT ck_pfsawh_process_ref_status;        

ALTER TABLE pfsawh_process_ref  
    ADD CONSTRAINT ck_pfsawh_process_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

ALTER TABLE pfsawh_process_ref 
ADD (
  run_cntrl                 NUMBER,
  override_run_cntrl        VARCHAR2(1)        DEFAULT 'N'  
  ); 
 /
 
ALTER TABLE pfsawh_process_ref   
  ADD CONSTRAINT ck_item_dim_subj_flg 
  CHECK (override_run_cntrl='Y'    OR override_run_cntrl='N');
/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE pfsawh_process_ref 
IS 'Contains a mapping to the name of the stored procedure or function'; 


COMMENT ON COLUMN pfsawh_process_ref.process_recid 
IS ''; 

COMMENT ON COLUMN pfsawh_process_ref.process_key 
IS '';

COMMENT ON COLUMN pfsawh_process_ref.process_description 
IS '';

COMMENT ON COLUMN pfsawh_process_ref.status 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsawh_process_ref.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_process_ref.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_process_ref.active_flag 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_process_ref.active_date 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsawh_process_ref.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_process_ref.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_process_ref.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_process_ref.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_process_ref.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_process_ref.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_process_ref.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_process_ref.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_process_ref.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT  table_name, comments 
FROM    user_tab_comments 
WHERE   table_name = UPPER('pfsawh_process_ref'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_process_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_process_ref') 
ORDER BY b.column_id; 

/*----- Populate -----*/

DECLARE

    CURSOR processes_cur IS
        SELECT a.process_RecId, a.process_Key, a.process_Description
        FROM pfsawh_process_ref a
        ORDER BY a.process_RecId;
        
    processes_rec    processes_cur%ROWTYPE;
        
BEGIN 
    INSERT INTO pfsawh_process_ref (process_Key, process_Description, status) 
        VALUES ( -1,   'NOT APPLICABLE', 'C');
    INSERT INTO pfsawh_process_ref (process_Key, process_Description, status) 
        VALUES (  1,   'pr_PHSAWH_InsUpd_ProcessLog', 'C');
    INSERT INTO pfsawh_process_ref (process_Key, process_Description, status) 
        VALUES (  10,  'pr_PFSAWH_Processlog_Cleanup', 'C');
    INSERT INTO pfsawh_process_ref (process_Key, process_Description, status) 
        VALUES (  11,  'pr_PFSAWH_stdPfsaDebugTbl_Del', 'C');
    INSERT INTO pfsawh_process_ref (process_Key, process_Description, status) 
        VALUES (  100, 'maintain_PFSA_Warehouse', 'C'); 
    INSERT INTO pfsawh_process_ref (process_Key, process_Description, status) 
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

SELECT * FROM pfsawh_process_ref; 

*/
