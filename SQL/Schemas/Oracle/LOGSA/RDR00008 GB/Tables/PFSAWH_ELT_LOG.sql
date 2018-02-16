DROP TABLE gb_pfsawh_etl_log;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsawh_audit_log 
--      PURPOSE: To calculate the desired information. 
--
-- TABLE SOURCE: gb_pfsawh_elt_log.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: April 01, 2008 
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
-- 01APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_etl_log 
(
    rec_id                           NUMBER              NOT NULL ,
--
    rec_source                       VARCHAR2(30)        DEFAULT '' ,
    source_rec_id                    NUMBER              DEFAULT 0 ,
    etl_error_code                   NUMBER,
    etl_message                      VARCHAR2(255 BYTE) ,
--
    process_key                      NUMBER              DEFAULT 0 ,
    process_recid                    NUMBER              DEFAULT 0 ,
    module_num                       NUMBER              DEFAULT 0 ,
    step_num                         NUMBER              DEFAULT 0 ,
    process_start_date               DATE,
    source_record                    VARCHAR2(2000)      DEFAULT '' ,
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
--    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
--    active_date                      DATE                DEFAULT '01-JAN-1900' , 
--    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' ,
CONSTRAINT pk_gb_pfsawh_elt_log PRIMARY KEY 
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

DROP INDEX ixu_gb_pfsawh_etl_log;

CREATE INDEX ix_gb_pfsawh_etl_log 
    ON gb_pfsawh_etl_log
    (
    rec_source,
    source_rec_id,
    etl_error_code
    );

/*----- Foreign Key -----*/
/* 
ALTER TABLE gb_pfsawh_elt_log  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE gb_pfsawh_elt_log  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);
*/ 
/*----- Constraints -----*/
/*
ALTER TABLE gb_pfsawh_etl_log  
    DROP CONSTRAINT ck_gb_pfsawh_etl_log_act_fl;        

ALTER TABLE gb_pfsawh_etl_log  
    ADD CONSTRAINT ck_gb_pfsawh_etl_log_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');
*/
ALTER TABLE gb_pfsawh_etl_log  
    DROP CONSTRAINT ck_gb_pfsawh_etl_log_del_fl;        

ALTER TABLE gb_pfsawh_etl_log  
    ADD CONSTRAINT ck_gb_pfsawh_etl_log_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_etl_log  
    DROP CONSTRAINT ck_gb_pfsawh_etl_log_hide_fl;       

ALTER TABLE gb_pfsawh_etl_log  
    ADD CONSTRAINT ck_gb_pfsawh_etl_log_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');
/*
ALTER TABLE gb_pfsawh_etl_log  
    DROP CONSTRAINT ck_gb_pfsawh_etl_log_status;        

ALTER TABLE gb_pfsawh_etl_log  
    ADD CONSTRAINT ck_gb_pfsawh_etl_log_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );
*/
/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_etl_log_seq;

CREATE SEQUENCE pfsawh_etl_log_seq
    START WITH 1000000000000
    MAXVALUE   9999999999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create the Trigger now -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_etl_log 
IS 'PFSAWH_ETL_LOG - '; 


COMMENT ON COLUMN gb_pfsawh_etl_log.rec_id 
IS 'REC_ID - '; 

COMMENT ON COLUMN gb_pfsawh_etl_log.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_etl_log.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_etl_log.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_etl_log.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_etl_log.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_etl_log.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_etl_log.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_etl_log.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_etl_log.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_etl_log.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_etl_log.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_etl_log.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_etl_log.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_etl_log.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_etl_log'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_etl_log') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_etl_log') 
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
        FROM gb_pfsawh_etl_log a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    DELETE gb_pfsawh_etl_log; 

    INSERT 
    INTO   gb_pfsawh_etl_log 
        (
--        rec_id,
        rec_source,
        etl_error_code,
        etl_message,
        process_key,
        process_recid,
        module_num,
        step_num,
        process_start_date,
        source_record 
       ) 
    SELECT 'pfsa_equip_avail', 1, 'test', 1, 2, 3, 4, sysdate, 
        sys_ei_niin || '~' || 
        pfsa_item_id || '~' ||
        record_type || '~' ||
        TO_CHAR(from_dt, 'DD-MON-YYYY HH:MI:SS')  || '~' || 
        TO_CHAR(to_dt, 'DD-MON-YYYY HH:MI:SS')  || '~' ||
        TO_CHAR(ready_date, 'DD-MON-YYYY')  || '~' ||
        TO_CHAR(day_date, 'DD-MON-YYYY')  || '~' ||
        TO_CHAR(month_date, 'DD-MON-YYYY')  || '~' ||
        pfsa_org || '~' ||
        sys_ei_sn || '~' ||
        item_days || '~' ||
        period_hrs || '~' ||
        nmcm_hrs || '~' ||
        nmcs_hrs || '~' ||
        nmc_hrs || '~' ||
        fmc_hrs || '~' ||
        pmc_hrs || '~' ||
        mc_hrs || '~' ||
        nmcm_user_hrs || '~' ||
        nmcm_int_hrs || '~' ||
        nmcm_dep_hrs || '~' ||
        nmcs_user_hrs || '~' ||
        nmcs_int_hrs || '~' ||
        nmcs_dep_hrs || '~' ||
        pmcm_hrs || '~' ||
        pmcs_hrs || '~' ||
        source_id || '~' ||
        TO_CHAR(lst_updt, 'DD-MON-YYYY HH:MI:SS')  || '~' ||
        updt_by || '~' ||
        pmcs_user_hrs || '~' ||
        pmcs_int_hrs || '~' ||
        pmcm_user_hrs || '~' ||
        pmcm_int_hrs || '~' ||
        dep_hrs || '~' ||
        heir_id || '~' ||
        priority || '~' ||
        uic
    FROM pfsa_equip_avail
    WHERE rownum < 50;
    
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

SELECT * FROM gb_pfsawh_etl_log; 

*/
