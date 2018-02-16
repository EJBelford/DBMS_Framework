DROP TABLE gb_pfsawh_maint_dim;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsawh_maint_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_maint_dim.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: February 15, 2008 
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
-- 15FEB08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_maint_dim 
(
    rec_id                        NUMBER              NOT NULL ,
--
    maint_id                      NUMBER              DEFAULT    0 ,
    maint_description             VARCHAR2(20)        DEFAULT    'unk' ,
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
CONSTRAINT pk_gb_pfsawh_maint_dim PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_maintenance_dim;

CREATE UNIQUE INDEX ixu_pfsawh_maintenance_dim 
    ON gb_pfsawh_maint_dim(maint_id);

/*----- Foreign Key -----*/

ALTER TABLE gb_pfsawh_maint_dim  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE gb_pfsawh_maint_dim  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);

/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_maint_dim  
    DROP CONSTRAINT ck_pfsawh_maint_dim_act_fl;        

ALTER TABLE gb_pfsawh_maint_dim  
    ADD CONSTRAINT ck_pfsawh_maint_dim_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsawh_maint_dim  
    DROP CONSTRAINT ck_pfsawh_maint_dim_del_fl;        

ALTER TABLE gb_pfsawh_maint_dim  
    ADD CONSTRAINT ck_pfsawh_maint_dim_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_maint_dim  
    DROP CONSTRAINT ck_pfsawh_maint_dim_hide_fl;       

ALTER TABLE gb_pfsawh_maint_dim  
    ADD CONSTRAINT ck_pfsawh_maint_dim_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_maint_dim  
    DROP CONSTRAINT ck_gb_pfsawh_maint_dim_status;        

ALTER TABLE gb_pfsawh_maint_dim  
    ADD CONSTRAINT ck_gb_pfsawh_maint_dim_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_maint_dim_seq;

CREATE SEQUENCE pfsawh_maint_dim_seq
    START WITH 1000000
    MAXVALUE   999999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_maint_dim 
IS ''; 


COMMENT ON COLUMN gb_pfsawh_maint_dim.rec_id 
IS ''; 

COMMENT ON COLUMN gb_pfsawh_maint_dim.STATUS 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_maint_dim.UPDT_BY 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.LST_UPDT 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.ACTIVE_FLAG 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.ACTIVE_DATE 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.INACTIVE_DATE 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.INSERT_BY 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.INSERT_DATE 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.UPDATE_BY 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.UPDATE_DATE 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.DELETE_FLAG 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.DELETE_DATE 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.HIDDEN_FLAG 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_maint_dim.HIDDEN_DATE 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_maint_dim') 

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
    ON  b.table_name  = UPPER('gb_pfsawh_maint_dim') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_maint_dim') 
ORDER BY b.column_id 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name 
   
/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM gb_pfsawh_maint_dim a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO gb_pfsawh_maint_dim (xx_id, xx_code, xx_description) 
        VALUES (1, 'N/A', 'NOT APPLICABLE');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.xx_ID || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT * FROM gb_pfsawh_maint_dim; 

*/
