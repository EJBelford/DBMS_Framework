DROP TABLE gb_pfsa_pba_rules_ref; 
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsa_pba_rules_ref
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsa_pba_rules_ref.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 11 March 2008 
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
-- 11MAR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsa_pba_rules_ref 
(
    rec_id                        NUMBER              NOT NULL ,
--
    metric_id                     NUMBER              DEFAULT    -2 ,
    rule_id                       NUMBER              DEFAULT    0 ,
    rule_description              VARCHAR2(50)        DEFAULT    'unk' , 
--
    rule_date_from_id             NUMBER              DEFAULT    0 ,
    rule_date_to_id               NUMBER              DEFAULT    0 ,
    rule_lower_limit              NUMBER              DEFAULT    100 ,
    rule_upper_limit              NUMBER              DEFAULT    0 ,
--
    bi_display_object             VARCHAR2(2)         NULL , 
    bi_display_attribute          VARCHAR2(2)         NULL , 
    bi_color_id                   VARCHAR2(2)         DEFAULT    'W' ,	--green, amber, red, black, white
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
CONSTRAINT pk_gb_pfsa_pba_rules_ref PRIMARY KEY 
    (
    metric_id,
    rule_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsa_pba_rules_ref_recid;

CREATE UNIQUE INDEX ixu_pfsa_pba_rules_ref_recid 
    ON gb_pfsa_pba_rules_ref
    (
    rec_id
    );

/*----- Foreign Key -----*/

ALTER TABLE gb_pfsa_pba_rules_ref  
    DROP CONSTRAINT fk_pfsa_pba_rules_ref_metricid;        

ALTER TABLE gb_pfsa_pba_rules_ref  
    ADD CONSTRAINT fk_pfsa_pba_rules_ref_metricid 
    FOREIGN KEY (metric_id) 
    REFERENCES gb_pfsa_pba_metrics_ref(metric_id);

/*----- Constraints -----*/

ALTER TABLE gb_pfsa_pba_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_met_ref_color;        

ALTER TABLE gb_pfsa_pba_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_met_ref_color 
    CHECK (bi_color_id='B' OR bi_color_id='W' OR bi_color_id='R' 
        OR bi_color_id='A' OR bi_color_id='G' 
        );

ALTER TABLE gb_pfsa_pba_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_rule_ref_act_fl;        

ALTER TABLE gb_pfsa_pba_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_met_rule_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsa_pba_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_rule_ref_del_fl;        

ALTER TABLE gb_pfsa_pba_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_rule_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsa_pba_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_rule_ref_hid_fl;       

ALTER TABLE gb_pfsa_pba_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_rule_ref_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsa_pba_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_rule_ref_status;        

ALTER TABLE gb_pfsa_pba_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_rule_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsa_pba_rule_ref_seq;

CREATE SEQUENCE pfsa_pba_rule_ref_seq
    START WITH 1000000
    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create the Trigger now -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsa_pba_rules_ref 
IS ''; 


COMMENT ON COLUMN gb_pfsa_pba_rules_ref.rec_id 
IS ''; 

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.STATUS 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.UPDT_BY 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.LST_UPDT 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.ACTIVE_FLAG 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.ACTIVE_DATE 
IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.INACTIVE_DATE 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.INSERT_BY 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.INSERT_DATE 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.UPDATE_BY 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.UPDATE_DATE 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.DELETE_FLAG 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.DELETE_DATE 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.HIDDEN_FLAG 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsa_pba_rules_ref.HIDDEN_DATE 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsa_pba_rules_ref'); 

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
    ON  b.table_name  = UPPER('gb_pfsa_pba_rules_ref') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsa_pba_rules_ref') 
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
        SELECT a.perf_met_id, a.xx_DESCRIPTION
        FROM gb_pfsa_pba_rules_ref a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO gb_pfsa_pba_rules_ref (perf_met_id, xx_code, xx_description) 
        VALUES (1, 'N/A', 'NOT APPLICABLE');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.perf_met_id || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT * FROM gb_pfsa_pba_rules_ref; 

*/
