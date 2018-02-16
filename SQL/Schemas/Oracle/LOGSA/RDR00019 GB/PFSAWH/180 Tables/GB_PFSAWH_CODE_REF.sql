DROP TABLE gb_pfsawh_code_ref;
	
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- 
--         Table Name: pfsawh_code_ref 
--         Table Desc: Contains the code values and descriptions used in CMIS
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 6 June 2007
-- 
--       Table Source: pfsawh_code_ref.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 06Jun07 - GB  - 00000000 - 0000 - Created
-- 11Jul07 - GB  -          -      - Created under CMIS 
-- 11Jul07 - GB  -          -      - Broad update to meet JIS best practices 
--                                   standards 
-- 01Oct07 - GB  -          -      - Added sort order key 
-- 26Nov07 - GB  -          -      - Converted to Oracle 
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_code_ref
(
    rec_id		             NUMBER         NOT NULL ,
--     
    cat_code                         NUMBER         NOT NULL ,
    item_code                        VARCHAR2(50)   NOT NULL ,
    item_text                        VARCHAR2(500)  NULL ,
--
    code_source                      VARCHAR2(20)   NULL ,  
    code_source_id                   VARCHAR2(20)   NULL , 
    code_source_code                 VARCHAR2(50)   NULL , 
    code_source_text                 VARCHAR2(255)  NULL , 
    code_sort_order                  NUMBER         NULL ,           
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
CONSTRAINT gb_pfsawh_code_ref PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_code_ref;

CREATE UNIQUE INDEX ixu_pfsawh_code_ref 
    ON gb_pfsawh_code_ref
    (
    cat_code, 
    item_code
    );

/*----- Foreign Key -----*/

ALTER TABLE gb_pfsawh_code_ref  
    DROP CONSTRAINT fk_pfsa_code_catcode;        

ALTER TABLE gb_pfsawh_code_ref  
    ADD CONSTRAINT fk_pfsa_code_catcode 
    FOREIGN KEY (cat_code) 
    REFERENCES gb_pfsawh_code_definition_ref(cat_code);

/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_code_ref  
    DROP CONSTRAINT ck_gb_pfsawh_code_ref_act_flg;        

ALTER TABLE gb_pfsawh_code_ref  
    ADD CONSTRAINT ck_gb_pfsawh_code_ref_act_flg 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsawh_code_ref  
    DROP CONSTRAINT ck_gb_pfsawh_code_ref_del_flg;       

ALTER TABLE gb_pfsawh_code_ref  
    ADD CONSTRAINT ck_gb_pfsawh_code_ref_del_flg 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_code_ref  
    DROP CONSTRAINT ck_gb_pfsawh_code_ref_hide_flg;        

ALTER TABLE gb_pfsawh_code_ref  
    ADD CONSTRAINT ck_gb_pfsawh_code_ref_hide_flg 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_code_ref  
    DROP CONSTRAINT ck_gb_pfsawh_code_ref_status;        

ALTER TABLE gb_pfsawh_code_ref  
    ADD CONSTRAINT ck_gb_pfsawh_code_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N' OR status='T'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_code_ref_seq;

CREATE SEQUENCE pfsawh_code_ref_seq
    START WITH 1000
    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_code_ref 
IS 'Contains the values and description of the codes that change very slowly.'; 


COMMENT ON COLUMN gb_pfsawh_code_ref.rec_id 
IS ''; 

COMMENT ON COLUMN gb_pfsawh_code_ref.status 
IS 'The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_code_ref.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_code_ref.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_code_ref.active_flag 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_code_ref.active_date 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_code_ref.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_code_ref.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_code_ref.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_code_ref.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_code_ref.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_code_ref.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_code_ref.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_code_ref.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_code_ref.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_code_ref'); 

/*----- Check to see if the table column comments are present -----*/

SELECT b.column_id, 
       a.table_name, 
       a.column_name, 
       b.data_type, 
       b.data_length, 
       b.nullable, 
       a.comments 
FROM   user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_code_ref') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_code_ref') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
/*
---------------------------------------
------- dimCmisCodes            ------- 
---------------------------------------

PRINT    '*** dimCmisCodes ***'
PRINT    '* Insert test *' 

INSERT 
INTO    dimCmisCodesDefinition (CatCd, CodeNm) VALUES (-100, 'Unit test')

INSERT 
INTO    dimCmisCodes (catCd, itmCd, itmTxt) 
VALUES    (-100, 1, 'Unit test case 1')

--- Default Review ---

PRINT    '* Default Review *' 

SELECT    catCd, itmCd, itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
        update_By, update_Dt, delete_Fl, delete_Dt 
FROM    dimCmisCodes 
WHERE    catCd < -1

----- PRIMARY KEY constraint -----

PRINT    '* PRIMARY KEY constraint *' 

INSERT 
INTO    dimCmisCodes (catCd, itmCd, itmTxt) 
VALUES    (-100, 1, 'Unit test case 1')

----- FOREIGN KEY constraint -----

PRINT    '* FOREIGN KEY constraint *' 

INSERT 
INTO    dimCmisCodes (catCd, itmCd, itmTxt) 
VALUES    (-200, 1, 'Unit test case 4')

--- Trigger Review ---

PRINT    '* Trigger Review *' 

UPDATE    dimCmisCodes 
SET        itmTxt = 'Unit test case 3' 
WHERE    catCd = -100  

SELECT    catCd, itmCd, itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
        update_By, update_Dt, delete_Fl, delete_Dt 
FROM    dimCmisCodes 
WHERE    catCd = -100 

----- NOT NULL constraint -----

PRINT    '* NOT NULL constraint *' 

INSERT 
INTO    dimCmisCodes (catCd) 
VALUES    (NULL)

INSERT 
INTO    dimCmisCodes (itmCd) 
VALUES    (NULL)

-----Cleanup -----

PRINT    '* Cleanup *' 

DELETE    dimCmisCodes WHERE catCd < -1
DELETE    dimCmisCodesDefinition WHERE CatCd < 0

*/

/*----- Populate -----*/

DECLARE
    CURSOR code_cur IS
        SELECT cd.catcode AS def_codeDef, cd.CODENAME, c.rec_id, c.catCode, c.itemCode, c.itemText 
        FROM gb_pfsawh_code_definition_ref cd
        LEFT OUTER JOIN gb_pfsawh_code_ref c ON cd.CATCODE = c.CATCODE 
        ORDER BY cd.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN

    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1000;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1000;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1000, 'ACTIVE_FLAG'); 
    
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1000, 'N', 'No', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1000, 'Y', 'Yes', sysdate);
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1001;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1001;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1001, 'DELETE_FLAG');
    
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1001, 'N', 'No', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1001, 'Y', 'Yes', sysdate);
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1002;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1002;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1002, 'HIDDEN_FLAG'); 
    
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1002, 'N', 'No', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1002, 'Y', 'Yes', sysdate);
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1003;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1003;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1003, 'STATUS'); 
    
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'C', 'Current Record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'D', 'Duplicate Record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'E', 'Error record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'H', 'Historical record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'L', 'Logical record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'P', 'Processed', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'Q', 'Questionable record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'R', 'Ready to Process', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'Z', 'Future record', sysdate);
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, ACTIVE_DATE) 
        VALUES (1003, 'N', 'Not applicable', sysdate);
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1004;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1004;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1004, 'GEN_MB_REF'); 
    
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, ACTIVE_DATE ) 
        VALUES (1004, 'M', 'Miles', 'C', sysdate); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, ACTIVE_DATE ) 
        VALUES (1004, 'H', 'Hours', 'C', sysdate); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, ACTIVE_DATE ) 
        VALUES (1004, 'R', 'Rounds', 'C', sysdate); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, ACTIVE_DATE ) 
        VALUES (1004, 'L', 'Landings', 'C', sysdate); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, ACTIVE_DATE ) 
        VALUES (1004, 'E', 'Events', 'C', sysdate); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, ACTIVE_DATE ) 
        VALUES (1004, 'C', 'Cycles', 'C', sysdate); 
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1005;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1005;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1005, 'LMI_MB_REF'); 
    
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'A', 'Message units', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'C', 'Cycles', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'D', 'Days', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'F', 'Flight Hours', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'G', 'Minutes', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'H', 'Hours', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'K', 'Kilometers', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'L', 'Landings', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'M', 'Miles', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'O', 'Operating Hours', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'R', 'Rounds', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'S', 'Starts', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'T', 'Months', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'U', 'Underway/steaming hours', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'Y', 'Years', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'E', 'Arrestments', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  'B', 'Catapults', 'C',  TO_Date( '03/20/2002 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'MIL-PRF-49506'); 
    INSERT INTO gb_pfsawh_code_ref (CATCODE, ItemCode, ItemText, STATUS, LST_UPDT, UPDT_BY ) 
        VALUES (1005,  '_', 'unknown', 'Q',  TO_Date( '05/18/2006 02:40:29 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'Kluge'); 
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1006;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1006;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1006, 'PFSA_EVENT_REF'); 
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1007;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1007;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1007, 'PFSA_SOURCE_ID_REF'); 
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1008;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1008;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1008, 'READY_STATE_REF'); 
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1009;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1009;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1009, 'TYPE_ANAL_VIEW_REF'); 
    
    DELETE gb_pfsawh_code_ref WHERE CATCODE = 1010;
    DELETE gb_pfsawh_code_definition_ref WHERE CATCODE = 1010;
    
    INSERT INTO gb_pfsawh_code_definition_ref (CATCODE, CODENAME) 
        VALUES (1010, 'USAGE_MB_REF'); 
        
    COMMIT;
	
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO    code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.def_codeDef || ', ' || code_rec.CODENAME 
            || ', ' || code_rec.rec_id || ', ' || code_rec.catCode 
            || ', ' || code_rec.itemCode || ', ' || code_rec.itemText);
        
    END LOOP;
    
    CLOSE code_cur;
END;

/*

SELECT cd.catcode, cd.CODENAME, c.* 
FROM   gb_pfsawh_code_definition_ref cd
LEFT OUTER JOIN gb_pfsawh_code_ref c ON cd.CATCODE = c.CATCODE 
ORDER BY cd.catcode, c.itemCode 

*/

