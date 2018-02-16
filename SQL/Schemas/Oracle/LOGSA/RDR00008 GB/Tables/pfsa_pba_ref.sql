DROP TABLE gb_pfsa_pba_ref;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsa_pba_ref 
--      PURPOSE: PERFORMANCE BASED LOGISTICS - Parent record for all the 
--               contract related information, (NIIN, UIC, SN, etc.) 
--
-- TABLE SOURCE: gb_pfsa_pba_ref.sql 
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
CREATE TABLE gb_pfsa_pba_ref 
(
    pba_id                        NUMBER              DEFAULT    0 ,
--
    pba_key1                      VARCHAR2(3)         DEFAULT    'xxx' ,
    pba_key2                      VARCHAR2(10)        DEFAULT    'yyyy' ,
    pba_seq                       NUMBER              DEFAULT    0 ,
    pba_title                     VARCHAR2(100)       DEFAULT    'unk' ,
    pba_point_of_contact          VARCHAR2(30)        DEFAULT    'unk' ,
    pba_description               VARCHAR2(100)       DEFAULT    'unk' ,
    pba_agreement_date_id         NUMBER              DEFAULT    -1 ,
    pba_status_code               VARCHAR2(2)         DEFAULT    '-1' ,
    pba_from_date_id              NUMBER              DEFAULT    -1 ,
    pba_to_date_id                NUMBER              DEFAULT    -1 ,
    pba_lifecyle_logistics_phase  VARCHAR2(2)         DEFAULT    '-1' ,
    pba_retention_period          NUMBER              DEFAULT    -1 ,
    pba_freeze_flag               VARCHAR2(2)         DEFAULT    '-1' ,
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
CONSTRAINT pk_gb_pfsa_pba_ref PRIMARY KEY 
    (
    pba_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_gb_pfsa_pba_ref;

CREATE UNIQUE INDEX ixu_gb_pfsa_pba_ref 
    ON gb_pfsa_pba_ref
    (
    pba_key1,
    pba_key2,
    pba_seq
    );

/*----- Foreign Key -----*/
/*
ALTER TABLE gb_pfsa_pba_ref  
    DROP CONSTRAINT fk_pfsa_code_pba_id;        

ALTER TABLE gb_pfsa_pba_ref  
    ADD CONSTRAINT fk_pfsa_code_pba_id 
    FOREIGN KEY (pba_id) 
    REFERENCES xx_pfsa_yyyyy_dim(pba_id);
*/
/*----- Constraints -----*/

ALTER TABLE gb_pfsa_pba_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_ref_act_fl;        

ALTER TABLE gb_pfsa_pba_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsa_pba_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_ref_del_fl;        

ALTER TABLE gb_pfsa_pba_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsa_pba_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_ref_hide_fl;       

ALTER TABLE gb_pfsa_pba_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_ref_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsa_pba_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_ref_status;        

ALTER TABLE gb_pfsa_pba_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsa_pba_ref_seq;

CREATE SEQUENCE pfsa_pba_ref_seq
    START WITH 1000000
    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create trigger  -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsa_pba_ref 
IS 'PFSA_PBA_REF - PERFORMANCE BASED AGREEMENTS - Parent record for all the contract related information, (NIIN, UIC, SN, etc.)'; 


COMMENT ON COLUMN gb_pfsa_pba_ref.pba_id 
IS 'PBA_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_key1 
IS 'PBA_KEY1 - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_key2 
IS 'PBA_KEY2 - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_seq 
IS 'PBA_SEQ - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_title 
IS 'PBA_TITLE - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_point_of_contact 
IS 'PBA_POINT_OF_CONTACT - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_description 
IS 'PBA_DESCRIPTION - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_agreement_date_id 
IS 'PBA_AGREEMENT_DATE_ID - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_status_code 
IS 'PBA_STATUS_CODE - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_from_date_id 
IS 'PBA_FROM_DATE_ID - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_to_date_id 
IS 'PBA_TO_DATE_ID - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_lifecyle_phase 
IS 'PBA_LIFECYLE_PHASE - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_retention_period 
IS 'PBA_RETENTION_PERIOD - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.pba_freeze_flag 
IS 'PBA_FREEZE_FLAG - ';

COMMENT ON COLUMN gb_pfsa_pba_ref.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsa_pba_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsa_pba_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsa_pba_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsa_pba_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsa_pba_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsa_pba_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsa_pba_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsa_pba_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsa_pba_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsa_pba_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsa_pba_ref.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsa_pba_ref');  

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
    ON  b.table_name  = UPPER('gb_pfsa_pba_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsa_pba_ref') 
ORDER BY b.column_id;  

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 
   
/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.pba_id, a.xx_DESCRIPTION
        FROM gb_pfsa_pba_ref a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    DELETE gb_pfsa_pba_ref; 

    INSERT INTO gb_pfsa_pba_ref 
    (pba_key1, pba_key2, pba_seq, pba_description, pba_status_code)
        VALUES ('000', '000',      -2,  'Not found', 'C');
    
    INSERT INTO gb_pfsa_pba_ref 
    (pba_key1, pba_key2, pba_seq, pba_description, pba_status_code)
        VALUES ('000', '000',      -1,  'Select one ...', 'C');
    
    INSERT INTO gb_pfsa_pba_ref
    (pba_key1, pba_key2, pba_seq, pba_description, pba_status_code)
        VALUES ('AR_', '700-138',  100, 'Army Regulation 700-138', 'C');

    INSERT INTO gb_pfsa_pba_ref
    (pba_key1, pba_key2, pba_seq, pba_description, pba_status_code)
        VALUES ('AR_', '750-1',    101, 'Army Regulation 750-1', 'C');

    INSERT INTO gb_pfsa_pba_ref
    (pba_key1, pba_key2, pba_seq, pba_description, pba_status_code)
        VALUES ('SOC', 'AVN_',     111, 'Sepcial Operations Command', 'C');

    INSERT INTO gb_pfsa_pba_ref
    (pba_key1, pba_key2, pba_seq, pba_description, pba_status_code)
        VALUES ('FCS', 'GRD_',     112, 'Future Combat Systems', 'C'); 
        
    COMMIT; 

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.pba_id || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT * FROM gb_pfsa_pba_ref; 

*/
