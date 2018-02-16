DROP TABLE gb_pfsa_pba_type_ref;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsa_pba_type_ref 
--      PURPOSE: PERFORMANCE BASED LOGISTICS - Parent record for all the 
--               contract related information, (NIIN, UIC, SN, etc.) 
--
-- TABLE SOURCE: gb_pfsa_pba_type_ref.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 10 March 2008
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
-- 10MAR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsa_pba_type_ref 
(
    rec_id                        NUMBER              DEFAULT    0 ,
--
    item_identifier_type_cd       VARCHAR2(10)        DEFAULT    'xxx' ,
    item_identifier_type_desc     VARCHAR2(200)       DEFAULT    'Needed' ,
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
CONSTRAINT pk_gb_pfsa_pba_type_ref PRIMARY KEY 
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

DROP INDEX ixu_gb_pfsa_pba_type_cd_ref;

CREATE UNIQUE INDEX ixu_gb_pfsa_pba_type_cd_ref 
    ON gb_pfsa_pba_type_ref
    (
    item_identifier_type_cd
    );

/*----- Foreign Key -----*/
/*
ALTER TABLE gb_pfsa_pba_type_ref  
    DROP CONSTRAINT fk_pfsa_code_pba_id;        

ALTER TABLE gb_pfsa_pba_type_ref  
    ADD CONSTRAINT fk_pfsa_code_pba_id 
    FOREIGN KEY (pba_id) 
    REFERENCES xx_pfsa_yyyyy_dim(pba_id);
*/
/*----- Constraints -----*/

ALTER TABLE gb_pfsa_pba_type_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_type_ref_act_fl;        

ALTER TABLE gb_pfsa_pba_type_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_type_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsa_pba_type_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_type_ref_del_fl;        

ALTER TABLE gb_pfsa_pba_type_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_type_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsa_pba_type_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_typ_ref_hide_fl;       

ALTER TABLE gb_pfsa_pba_type_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_typ_ref_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsa_pba_type_ref  
    DROP CONSTRAINT ck_gb_pfsa_pba_type_ref_status;        

ALTER TABLE gb_pfsa_pba_type_ref  
    ADD CONSTRAINT ck_gb_pfsa_pba_type_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsa_pba_type_ref_seq;

CREATE SEQUENCE pfsa_pba_type_ref_seq
    START WITH 10
    MAXVALUE   99 
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create trigger  -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsa_pba_type_ref 
IS 'PFSA_PBA_TYPE_REF - '; 


COMMENT ON COLUMN gb_pfsa_pba_type_ref.rec_id 
IS 'REC_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_type_ref.item_identifier_type_cd 
IS 'ITEM_IDENTIFIER_TYPE_CD - ';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.item_identifier_type_desc  
IS 'ITEM_IDENTIFIER_TYPE_DESC - ';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsa_pba_type_ref.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsa_pba_type_ref');  

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
    ON  b.table_name  = UPPER('gb_pfsa_pba_type_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsa_pba_type_ref') 
ORDER BY b.column_id;  

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%uic%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 
   
/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.pba_id, a.xx_DESCRIPTION
        FROM gb_pfsa_pba_type_ref a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    DELETE gb_pfsa_pba_type_ref; 

    INSERT INTO gb_pfsa_pba_type_ref 
    (item_identifier_type_cd, item_identifier_type_desc)
        VALUES ('-2',  'Not found');
    
    INSERT INTO gb_pfsa_pba_type_ref 
    (item_identifier_type_cd, item_identifier_type_desc)
        VALUES ('-1',  'Select one ... ');
    
    INSERT INTO gb_pfsa_pba_type_ref
    (item_identifier_type_cd, item_identifier_type_desc)
        VALUES ('NIIN', 'NIIN - NATIONAL ITEM IDENTIFICATION NUMBER - A 9-digit number sequentially assigned to each approved item identification number under the federal cataloging program.');

    INSERT INTO gb_pfsa_pba_type_ref
    (item_identifier_type_cd, item_identifier_type_desc)
        VALUES ('ITEM_SN', 'ITEM SN');

    INSERT INTO gb_pfsa_pba_type_ref
    (item_identifier_type_cd, item_identifier_type_desc)
        VALUES ('LIN', 'LIN');

    INSERT INTO gb_pfsa_pba_type_ref
    (item_identifier_type_cd, item_identifier_type_desc)
        VALUES ('UICN', 'UIC');

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

SELECT * FROM gb_pfsa_pba_type_ref; 

*/
