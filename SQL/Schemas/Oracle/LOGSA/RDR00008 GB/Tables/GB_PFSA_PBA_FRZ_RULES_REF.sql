DROP TABLE gb_pfsa_pba_frz_rules_ref;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsa_pba_frz_rules_ref 
--      PURPOSE: To calculate the desired information. 
--
-- TABLE SOURCE: gb_pfsa_pba_frz_rules_ref.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 24 March 2008 
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
-- 24MAR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsa_pba_frz_rules_ref 
(
    rec_id                           NUMBER              NOT NULL ,
--
    pba_id                           NUMBER              DEFAULT -2 ,
    frz_rule_typ_cd                  NUMBER              DEFAULT 0 ,
    frz_day_mnth_cd                  VARCHAR2(3)         DEFAULT 'LST' ,
    frz_interval_cd                  NUMBER              DEFAULT 0 ,
    frz_cutoff_typ_cd                NUMBER              DEFAULT 0 ,
    frz_cutoff_adj_val               NUMBER              DEFAULT 0 ,
    frz_notes                        VARCHAR2(255)       NULL ,
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' ,
CONSTRAINT pk_gb_pfsa_pba_frz_rules_ref PRIMARY KEY 
    (
    pba_id ,
    frz_rule_typ_cd
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsa_pba_frz_rules_ref;

CREATE UNIQUE INDEX ixu_pfsa_pba_frz_rules_ref 
    ON gb_pfsa_pba_frz_rules_ref
    (
    rec_id
    );

DROP INDEX ix_pfsa_pba_frz_rules_ref_pba;

CREATE UNIQUE INDEX ixu_pfsa_pba_frz_rules_ref_pba 
    ON gb_pfsa_pba_frz_rules_ref
    (
    pba_id
    );

/*----- Foreign Key -----*/

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    DROP CONSTRAINT fk_pfsa_items_pba_id;        

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    ADD CONSTRAINT fk_pfsa_items_pba_id 
    FOREIGN KEY (pba_id) 
    REFERENCES gb_pfsa_pba_ref(pba_id);

/*----- Constraints -----*/

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_frz_rul_ref_act_fl;        

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_frz_rul_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_frz_rul_ref_del_fl;        

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_frz_rul_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_frz_rul_ref_hid_fl;       

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_frz_rul_ref_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    DROP CONSTRAINT ck_pfsa_pba_frz_rul_ref_status;        

ALTER TABLE gb_pfsa_pba_frz_rules_ref  
    ADD CONSTRAINT ck_pfsa_pba_frz_rul_ref_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsa_pba_frz_rules_ref_seq;

CREATE SEQUENCE pfsa_pba_frz_rules_ref_seq
    START WITH 10000
    MAXVALUE   99999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create the Trigger now -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsa_pba_frz_rules_ref 
IS 'gb_pfsa_pba_frz_rules_ref - '; 


COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.rec_id 
IS 'REC_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.pba_id 
IS 'PDA_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.frz_rule_typ_cd 
IS 'FRZ_RULE_TYP_CD - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.frz_day_mnth_cd 
IS 'FRZ_DAY_MNTH_CD - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.frz_interval_cd 
IS 'FRZ_INTERVAL_CD - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.frz_cutoff_typ_cd 
IS 'FRZ_CUTOFF_TYP_CD - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.frz_cutoff_adj_val 
IS 'FRZ_CUTOFF_ADJ_VAL - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.frz_notes 
IS 'FRZ_NOTES - '; 

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsa_pba_frz_rules_ref.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsa_pba_frz_rules_ref'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        b.data_default,  
        a.comments 
--        , '|', b.*  
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsa_pba_frz_rules_ref') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsa_pba_frz_rules_ref') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%ITEM_SYS_EI_ID%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM gb_pfsa_pba_frz_rules_ref a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO gb_pfsa_pba_frz_rules_ref (xx_id, xx_code, xx_description) 
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

SELECT * FROM gb_pfsa_pba_frz_rules_ref; 

*/
