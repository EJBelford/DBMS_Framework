DROP TABLE gb_pfsa_perf_based_log_ref;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsa_perf_based_log_ref 
--      PURPOSE: PERFORMANCE BASED LOGISTICS - Parent record for all the 
--               contract related information, (NIIN, UIC, SN, etc.) 
--
-- TABLE SOURCE: gb_pfsa_perf_based_log_ref.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 20 February 2008
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 20FEB08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsa_perf_based_log_ref 
(
    rec_id                        NUMBER              NOT NULL ,
--
    pbl_id                        NUMBER              DEFAULT    0 ,
    pbl_key1                      VARCHAR2(3)         DEFAULT    'xxx' ,
    pbl_key2                      VARCHAR2(10)        DEFAULT    'yyyy' ,
    pbl_seq                       NUMBER              DEFAULT    0 ,
    pbl_description               VARCHAR2(100)       DEFAULT    'unk' ,
    pbl_status_code               VARCHAR2(2)         DEFAULT    '-1' ,
    pbl_from_date_id              NUMBER              DEFAULT    '-1' ,
    pbl_to_date_id                NUMBER              DEFAULT    '-1' ,
--
    status                        VARCHAR2(1)         DEFAULT    'N' ,
    updt_by                       VARCHAR2(30)        DEFAULT    USER ,
    lst_updt                      DATE                DEFAULT    SYSDATE ,
--
    active_flag                   VARCHAR2(1)         DEFAULT    'I' , 
    active_date                   DATE                DEFAULT    '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT    '31-DEC-2099' ,
--
    insert_by                     VARCHAR2(20)        DEFAULT    USER , 
    insert_date                   DATE                DEFAULT    SYSDATE , 
    update_by                     VARCHAR2(20)        NULL ,
    update_date                   DATE                DEFAULT    '01-JAN-1900' ,
    delete_flag                   VARCHAR2(1)         DEFAULT    'N' ,
    delete_date                   DATE                DEFAULT    '01-JAN-1900' ,
    hidden_flag                   VARCHAR2(1)         DEFAULT    'Y' ,
    hidden_date                   DATE                DEFAULT    '01-JAN-1900' ,
CONSTRAINT pk_gb_pfsa_perf_based_log_ref PRIMARY KEY 
    (
    rec_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_gb_pfsa_perf_based_log_ref;

CREATE UNIQUE INDEX ixu_gb_pfsa_perf_based_log_ref 
    ON gb_pfsa_perf_based_log_ref(pbl_id);

/*----- Foreign Key -----*/
/*
ALTER TABLE gb_pfsa_perf_based_log_ref  
    DROP CONSTRAINT fk_pfsa_code_pbl_id;        

ALTER TABLE gb_pfsa_perf_based_log_ref  
    ADD CONSTRAINT fk_pfsa_code_pbl_id 
    FOREIGN KEY (pbl_id) 
    REFERENCES xx_pfsa_yyyyy_dim(pbl_id);
*/
/*----- Constraints -----*/

ALTER TABLE gb_pfsa_perf_based_log_ref  
    DROP CONSTRAINT ck_gb_pfsa_pbl_ref_act_fl;        

ALTER TABLE gb_pfsa_perf_based_log_ref  
    ADD CONSTRAINT ck_gb_pfsa_pbl_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsa_perf_based_log_ref  
    DROP CONSTRAINT ck_gb_pfsa_pbl_ref_del_fl;        

ALTER TABLE gb_pfsa_perf_based_log_ref  
    ADD CONSTRAINT ck_gb_pfsa_pbl_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsa_perf_based_log_ref  
    DROP CONSTRAINT ck_gb_pfsa_pbl_ref_hide_fl;       

ALTER TABLE gb_pfsa_perf_based_log_ref  
    ADD CONSTRAINT ck_gb_pfsa_pbl_ref_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsa_perf_based_log_ref  
    DROP CONSTRAINT ck_gb_pfsa_pbl_ref_status;        

ALTER TABLE gb_pfsa_perf_based_log_ref  
    ADD CONSTRAINT ck_gb_pfsa_pbl_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsa_pbl_ref_seq;

CREATE SEQUENCE pfsa_pbl_ref_seq
    START WITH 1000000
    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsa_perf_based_log_ref 
IS 'PERFORMANCE BASED LOGISTICS - Parent record for all the contract related information, (NIIN, UIC, SN, etc.)'; 


COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.rec_id 
IS ''; 

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.STATUS 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.UPDT_BY 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.LST_UPDT 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.ACTIVE_FLAG 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.ACTIVE_DATE 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.INACTIVE_DATE 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.INSERT_BY 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.INSERT_DATE 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.UPDATE_BY 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.UPDATE_DATE 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.DELETE_FLAG 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.DELETE_DATE 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.HIDDEN_FLAG 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsa_perf_based_log_ref.HIDDEN_DATE 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsa_perf_based_log_ref');  

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
    ON  b.table_name  = UPPER('gb_pfsa_perf_based_log_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsa_perf_based_log_ref') 
ORDER BY b.column_id;  

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.pbl_id, a.xx_DESCRIPTION
        FROM gb_pfsa_perf_based_log_ref a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO gb_pfsa_perf_based_log_ref (pbl_id, xx_code, xx_description) 
        VALUES (1, 'N/A', 'NOT APPLICABLE');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.pbl_id || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT * FROM gb_pfsa_perf_based_log_ref; 

*/
