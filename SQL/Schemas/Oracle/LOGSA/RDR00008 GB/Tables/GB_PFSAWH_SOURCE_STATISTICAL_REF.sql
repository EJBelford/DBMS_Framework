DROP TABLE gb_pfsawh_source_stat_ref;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: gb_pfsawh_source_stat_ref
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_source_statistical_ref.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_source_stat_ref 
(
    source_hist_stat_id                NUMBER        NOT NULL ,
--
    source_for_code                    VARCHAR2(1)   NOT NULL ,
    source_last_checked_date           DATE          NULL ,
    source_last_processed_date         DATE          NULL ,
    source_database                    VARCHAR2(30)  NULL ,
    source_schema                      VARCHAR2(30)  NULL ,
    source_table                       VARCHAR2(30)  NOT NULL ,
--
    source_load_date                   DATE          NULL ,
    source_load_record_count           NUMBER        NULL ,
    source_load_insert_date            DATE          NULL ,
    source_load_insert_count           NUMBER        NULL ,
    source_load_update_date            DATE          NULL ,
    source_load_update_count           NUMBER        NULL ,
    source_load_delete_count           NUMBER        NULL ,
--
    source_past1_date                  DATE          NULL ,
    source_past1_record_count          NUMBER        NULL ,
    source_past1_insert_date           DATE          NULL ,
    source_past1_insert_count          NUMBER        NULL ,
    source_past1_update_date           DATE          NULL ,
    source_past1_update_count          NUMBER        NULL ,
    source_past1_delete_count          NUMBER        NULL ,
--
    source_past2_date                  DATE          NULL ,
    source_past2_record_count          NUMBER        NULL ,
    source_past2_insert_date           DATE          NULL ,
    source_past2_insert_count          NUMBER        NULL ,
    source_past2_update_date           DATE          NULL ,
    source_past2_update_count          NUMBER        NULL ,
    source_past2_delete_count          NUMBER        NULL ,
--
    status                             VARCHAR2(1)   DEFAULT    'N' ,
    updt_by                            VARCHAR2(30)  DEFAULT    USER ,
    lst_updt                           DATE          DEFAULT    SYSDATE ,
--
    active_flag                        VARCHAR2(1)   DEFAULT    'I' , 
    active_date                        DATE          DEFAULT    '01-JAN-1900' , 
    inactive_date                      DATE          DEFAULT    '31-DEC-2099' ,
--
    insert_by                          VARCHAR2(20)  DEFAULT    USER , 
    insert_date                        DATE          DEFAULT    SYSDATE , 
    update_by                          VARCHAR2(20)  NULL ,
    update_date                        DATE          DEFAULT    '01-JAN-1900' ,
    delete_flag                        VARCHAR2(1)   DEFAULT    'N' ,
    delete_date                        DATE          DEFAULT    '01-JAN-1900' ,
    hidden_flag                        VARCHAR2(1)   DEFAULT    'Y' ,
    hidden_date                        DATE          DEFAULT    '01-JAN-1900' ,
CONSTRAINT pk_gb_pfsawh_source_stat_ref PRIMARY KEY 
    (
    source_hist_stat_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX Ixu_pfsa_source_table_stat_ref;

CREATE UNIQUE INDEX ixu_pfsa_source_table_stat_ref 
    ON gb_pfsawh_source_stat_ref
    (
    source_for_code, 
    source_schema, 
    source_table
    );

/*----- Foreign Key -----*/
/*
ALTER TABLE gb_pfsawh_source_stat_ref  DROP CONSTRAINT FK_PFSA_Code_xx_ID;        

ALTER TABLE gb_pfsawh_source_stat_ref  ADD CONSTRAINT FK_PFSA_Code_xx_ID foreign key (xx_ID) 
    REFERENCES xx_PFSA_yyyyy_DIM(xx_ID);
*/
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_source_stat_ref  
    DROP CONSTRAINT ck_pfsawh_src_stat_code;        

ALTER TABLE gb_pfsawh_source_stat_ref  
    ADD CONSTRAINT ck_pfsawh_src_stat_code 
    CHECK (source_for_code='D' OR source_for_code='F');

ALTER TABLE gb_pfsawh_source_stat_ref  
    DROP CONSTRAINT ck_pfsawh_src_stat_ref_act_flg;        

ALTER TABLE gb_pfsawh_source_stat_ref  
    ADD CONSTRAINT ck_pfsawh_src_stat_ref_act_flg 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsawh_source_stat_ref  
    DROP CONSTRAINT ck_pfsawh_src_stat_ref_del_flg;        

ALTER TABLE gb_pfsawh_source_stat_ref  
    ADD CONSTRAINT ck_pfsawh_src_stat_ref_del_flg 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_source_stat_ref  
    DROP CONSTRAINT ck_pfsawh_src_stat_ref_hide_fl;        

ALTER TABLE gb_pfsawh_source_stat_ref  
    ADD CONSTRAINT ck_pfsawh_src_stat_ref_hide_fl 
    CHECK (hidden_flaG='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_source_stat_ref  
    DROP CONSTRAINT ck_pfsawh_src_stat_ref_status;        

ALTER TABLE gb_pfsawh_source_stat_ref  
    ADD CONSTRAINT ck_pfsawh_src_stat_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_source_stat_ref_id;

CREATE SEQUENCE pfsawh_source_stat_ref_id
    START WITH 1000
    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_source_stat_ref 
IS 'Contains usefull information for the warehouse ETL process use in processing upstream information. '; 


COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_hist_stat_id 
IS 'Row identity'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_for_code 
IS 'Indicates if the source should be used for a "F"imension or "F"act.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_last_checked_date
IS 'The last time the source table was audited by the warehouse or the source flagged changes for the warehouse.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_last_processed_date
IS 'The last time the source table were loaded to the warehouse.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_database
IS 'The database where the source schema and table can be found.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_schema
IS 'The schema where the source table can be found.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_table
IS 'The source table.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_date
IS 'When the last load successfully completed.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_record_count
IS 'The number of records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_insert_date
IS 'The date the insert occured.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_update_date
IS 'The date of the last source table update when processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_update_count
IS 'The number of updated records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_insert_count
IS 'The number of new records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_load_delete_count
IS 'The number of delete/hidden records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_date
IS 'When the last load successfully completed.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_record_count
IS 'The number of records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_insert_date
IS 'The date the insert occured.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_update_date
IS 'The date of the last source table update when processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_update_count
IS 'The number of updated records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_insert_count
IS 'The number of new records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past1_delete_count
IS 'The number of delete/hidden records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_date
IS 'When the last load successfully completed.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_record_count
IS 'The number of records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_insert_date
IS 'The date the insert occured.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_update_date
IS 'The date of the last source table update when processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_update_count
IS 'The number of updated records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_insert_count
IS 'The number of new records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.source_past2_delete_count
IS 'The number of delete/hidden records in the source table when last processed by the warehouse ETL.'; 

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.status 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.active_flag 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.active_date 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_source_stat_ref.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT  table_name, comments 
FROM    user_tab_comments 
WHERE   table_name = UPPER('gb_pfsawh_source_stat_ref') 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_source_stat_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_source_stat_ref') 
ORDER BY b.column_id 

/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM gb_pfsawh_source_stat_ref a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO gb_pfsawh_source_stat_ref 
        (source_for_code, source_database, 
         source_schema, source_table) 
        VALUES ('D', 'LIDBDEV', NULL, 'MANUFACTURER_PART');
    INSERT INTO gb_pfsawh_source_stat_ref  
        (source_for_code, source_database, 
         source_schema, source_table) 
        VALUES ('D', 'LIDBDEV', NULL, 'ITEM_CONTROL');
    INSERT INTO gb_pfsawh_source_stat_ref  
        (source_for_code, source_database, 
         source_schema, source_table) 
        VALUES ('D', 'LIDBDEV', NULL, 'ITEM_DATA');
    INSERT INTO gb_pfsawh_source_stat_ref  
        (source_for_code, source_database, 
         source_schema, source_table) 
        VALUES ('D', 'LIDBDEV', NULL, 'GCSSA_LIN');
    INSERT INTO gb_pfsawh_source_stat_ref  
        (source_for_code, source_database, 
         source_schema, source_table) 
        VALUES ('D', 'LIDBDEV', NULL, 'GCSSA_HR_ASSET');
    INSERT INTO gb_pfsawh_source_stat_ref  
        (source_for_code, source_database, 
         source_schema, source_table) 
        VALUES ('D', 'LIDBDEV', NULL, 'LIN');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO    code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.xx_ID || ', ' || code_rec.xx_CODE || ', ' || code_rec.xx_DESCRIPTION);
        
    END LOOP;
    
    CLOSE code_cur;
    
END;  
    
-- COMMIT    

/*

SELECT * FROM gb_pfsawh_source_stat_ref; 

*/
