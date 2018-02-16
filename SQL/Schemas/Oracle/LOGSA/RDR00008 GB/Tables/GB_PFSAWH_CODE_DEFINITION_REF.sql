DROP TABLE gb_pfsawh_code_definition_ref;
	
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- 
--         Table Name: gb_pfsawh_code_definition_ref 
--         Table Desc: Contains the description of the code type value 
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 6 June 2007
-- 
--       Table Source: gb_pfsawh_code_definition_ref.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 06Jun07 - GB  - 00000000 - 0000 - Created
-- 11Jul07 - GB  -          -      - Created under CMIS 
-- 11Jul07 - GB  -          -      - Broad update to meet JIS best practices 
--                                   standards 
-- 26Jul07 - GB  -          -      - Add Hidden flag and date 
-- 26Nov07 - GB  -          -      - Converted to Oracle 
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
CREATE TABLE gb_pfsawh_code_definition_ref 
(
	 rec_id				              NUMBER         NOT NULL ,
--    
    cat_code                         NUMBER         NOT NULL ,
    code_name                        VARCHAR2(60)   NOT NULL ,
--
    code_source                      VARCHAR2(20)   NULL ,  
    code_source_id                   VARCHAR2(20)   NULL , 
--
    status                           VARCHAR2(1)    DEFAULT    'N' ,
    updt_by                          VARCHAR2(30)   DEFAULT    USER ,
    lst_updt                         DATE           DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)    DEFAULT    'I' , 
    active_date                      DATE           DEFAULT    '01-JAN-1900' , 
    inactive_date                    DATE           DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)   DEFAULT    USER , 
    insert_date                      DATE           DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)   NULL ,
    update_date                      DATE           DEFAULT    '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)    DEFAULT    'N' ,
    delete_date                      DATE           DEFAULT    '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)    DEFAULT    'Y' ,
    hidden_date                      DATE           DEFAULT    '01-JAN-1900' ,
CONSTRAINT gb_pfsawh_codedefinition_ref PRIMARY KEY 
    (
    cat_code
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsa_codedefinition_dim;

CREATE UNIQUE INDEX ixu_pfsa_codedefinition_dim 
    ON gb_pfsawh_code_definition_ref(rec_id);

/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_code_definition_ref  
    DROP CONSTRAINT ck_gb_pfsa_cddef_dim_act_flag;       

ALTER TABLE gb_pfsawh_code_definition_ref  
    ADD CONSTRAINT ck_gb_pfsa_cddef_dim_act_flag 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsawh_code_definition_ref  
    DROP CONSTRAINT ck_gb_pfsa_cddef_dim_del_flg;        

ALTER TABLE gb_pfsawh_code_definition_ref  
    ADD CONSTRAINT ck_gb_pfsa_cddef_dim_del_flg 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_code_definition_ref  
    DROP CONSTRAINT ck_gb_pfsa_cddef_dim_hide_flag;         

ALTER TABLE gb_pfsawh_code_definition_ref  
    ADD CONSTRAINT ck_gb_pfsa_cddef_dim_hide_flag 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_code_definition_ref  
    DROP CONSTRAINT ck_gb_pfsa_cddef_dim_status;        

ALTER TABLE gb_pfsawh_code_definition_ref  
    ADD CONSTRAINT ck_gb_pfsa_cddef_dim_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_code_definition_ref_seq;

CREATE SEQUENCE pfsawh_code_definition_ref_seq
    START WITH 1000
    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_code_definition_ref 
IS 'Parent table to PFSAWH_CODE_REF containing the description code set.'; 


COMMENT ON COLUMN gb_pfsawh_code_definition_ref.rec_id 
IS ''; 

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.status 
IS 'The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.active_flag
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.active_date 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_code_definition_ref.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_code_definition_ref'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_code_definition_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_code_definition_ref') 
ORDER BY b.column_id; 

/*----- Populate -----*/

BEGIN

    DELETE gb_pfsawh_code_definition_ref;

    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1000, 'ACTIVE_FLAG'); 
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1001, 'DELETE_FLAG'); 
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1002, 'HIDDEN_FLAG'); 
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1003, 'STATUS'); 
        
END;
    
-- COMMIT;    
    
SELECT * FROM gb_pfsawh_code_definition_ref

/*
---------------------------------------
------- dimCMISCodeDefinition   ------- 
---------------------------------------

PRINT    '*** dimCMISCode ***'
PRINT    '* Insert test *' 

INSERT 
INTO    dimCmisCodeDefinition (CatCd, CodeNm) 
VALUES (-100, 'Unit test')

--- Default Review ---

PRINT    '* Default Review *' 

SELECT    catCd, CodeNm, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
        update_By, update_Dt, delete_Fl, delete_Dt 
FROM    dimCMISCodeDefinition 
WHERE    catCd < -1

----- PRIMARY KEY constraint -----

PRINT    '* PRIMARY KEY constraint *' 

INSERT 
INTO    dimCmisCodeDefinition (CatCd, CodeNm) 
VALUES (-100, 'Unit test')

----- FOREIGN KEY constraint -----

--PRINT    '* FOREIGN KEY constraint *' 

--INSERT 
--INTO    dimCmisCodeDefinition (CatCd, CodeNm) 
--VALUES (-200, 'Unit test 1')

--- Trigger Review ---

PRINT    '* Trigger Review *' 

UPDATE    dimCMISCodeDefinition 
SET        codeNm = 'Unit test case 3' 
WHERE    catCd = -100  

SELECT    catCd, CodeNm, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
        update_By, update_Dt, delete_Fl, delete_Dt 
FROM    dimCMISCodeDefinition 
WHERE    catCd = -100 

----- NOT NULL constraint -----

PRINT    '* NOT NULL constraint *' 

INSERT 
INTO    dimCMISCodeDefinition (catCd) 
VALUES    (NULL)

INSERT 
INTO    dimCMISCodeDefinition (CodeNm) 
VALUES    (NULL)

-----Cleanup -----

PRINT    '* Cleanup *' 

--DELETE    dimCMISCode WHERE catCd < -1
DELETE    dimCMISCodeDefinition WHERE CatCd < 0

*/
