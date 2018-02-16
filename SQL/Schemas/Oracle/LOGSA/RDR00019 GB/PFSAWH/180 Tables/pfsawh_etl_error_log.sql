/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_etl_error_log 
--      PURPOSE: To calculate the desired information. 
--
-- TABLE SOURCE: pfsawh_etl_error_log.sql 
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

/*----- Sequence -----*/

DROP SEQUENCE pfsawh_etl_error_log_seq;

CREATE SEQUENCE pfsawh_etl_error_log_seq
    START WITH 1
--    MAXVALUE   9999999999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create Table-----*/

DROP TABLE pfsawh_etl_error_log;
	
CREATE TABLE pfsawh_etl_error_log 
(
    rec_id                           NUMBER              NOT NULL ,
--
    rec_source                       VARCHAR2(65)        DEFAULT '' ,
    source_rec_id                    NUMBER              DEFAULT 0 ,
    etl_processed_by                 VARCHAR2(50),  
    etl_error_field                  VARCHAR2(30),
    etl_error_value                  VARCHAR2(50),
    etl_error_code                   NUMBER,
    etl_message                      VARCHAR2(255) ,
--
    process_key                      NUMBER              DEFAULT 0 ,
    process_recid                    NUMBER              DEFAULT 0 ,
    module_num                       NUMBER              DEFAULT 0 ,
    step_num                         NUMBER              DEFAULT 0 ,
    process_start_date               DATE,
    source_record                    VARCHAR2(2000)      DEFAULT '' ,
--
    status                           VARCHAR2(1)         DEFAULT 'E' ,
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
    delete_by                        VARCHAR2(30)        NULL ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    hidden_by                        VARCHAR2(30)        NULL ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' 
) 
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE pfsawh_etl_error_log 
IS 'PFSAWH_ETL_ERROR_LOG - This table is used to record the DISTINCT value that the ETL has an issue will.  '; 


COMMENT ON COLUMN pfsawh_etl_error_log.rec_id 
IS 'REC_ID - Sequence/identity for dimension/fact table.'; 

COMMENT ON COLUMN pfsawh_etl_error_log.rec_source 
IS 'REC_SOURCE - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN pfsawh_etl_error_log.etl_processed_by 
IS 'ETL_PROCESSED_BY - Indicates which ETL process is responsible for inserting and maintainfing this record.  This is critically for dealing with records similar in nature to the freeze records.';

COMMENT ON COLUMN pfsawh_etl_error_log.etl_error_field 
IS 'ETL_ERROR_FIELD - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.etl_error_value 
IS 'ETL_ERROR_VALUE - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.etl_error_code 
IS 'ETL_ERROR_CODE - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.etl_message 
IS 'ETL_MESSAGE - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.process_key 
IS 'PROCESS_KEY - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.process_recid 
IS 'PROCESS_RECID - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.module_num 
IS 'MODULE_NUM - Identities module within a give mutli-step process.'; 

COMMENT ON COLUMN pfsawh_etl_error_log.step_num 
IS 'STEP_NUM - Identities steps within a give mutli-step process.'; 

COMMENT ON COLUMN pfsawh_etl_error_log.process_start_date 
IS 'PROCESS_START_DATE - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.source_record 
IS 'SOURCE_RECORD - '; 

COMMENT ON COLUMN pfsawh_etl_error_log.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN pfsawh_etl_error_log.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_etl_error_log.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

--COMMENT ON COLUMN pfsawh_etl_error_log.active_flag 
--IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

--COMMENT ON COLUMN pfsawh_etl_error_log.active_date 
--IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

--COMMENT ON COLUMN pfsawh_etl_error_log.inactive_date 
--IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_etl_error_log.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_etl_error_log.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_etl_error_log.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_etl_error_log.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_etl_error_log.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_etl_error_log.delete_by 
IS 'DELETE_BY - Reports who deleted the record.';

COMMENT ON COLUMN pfsawh_etl_error_log.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_etl_error_log.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_etl_error_log.hidden_by 
IS 'HIDDEN_BY -  Reports who last hide the record.';

COMMENT ON COLUMN pfsawh_etl_error_log.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_etl_error_log'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_etl_error_log') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_etl_error_log') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%PROCESS_START_DATE%'); 
   
/*----- Primary Key -----*/ 

ALTER TABLE pfsawh_etl_error_log  
    DROP CONSTRAINT pk_pfsawh_elt_error_log;        

ALTER TABLE pfsawh_etl_error_log  
    ADD CONSTRAINT pk_pfsawh_elt_error_log 
    PRIMARY KEY 
        (
        rec_id
        );

/*----- Unique Index -----*/ 

ALTER TABLE pfsawh_etl_error_log  
    DROP CONSTRAINT ixu_pfsawh_elt_error_log;        

ALTER TABLE pfsawh_etl_error_log 
    ADD (
        CONSTRAINT ixu_pfsawh_elt_error_logl
        UNIQUE 
            (
            etl_error_value
            )
        USING INDEX 
        PCTFREE    10
        INITRANS   2
        MAXTRANS   255
        STORAGE    (
                   INITIAL          64K
                   NEXT             32K
                   MINEXTENTS       1
                   MAXEXTENTS       UNLIMITED
                   PCTINCREASE      0
                   )
        );
/*----- Indexs -----*/ 

DROP INDEX   idx_pfsawh_etl_error_log;

CREATE INDEX idx_pfsawh_etl_error_log 
    ON pfsawh_etl_error_log
    (
    rec_source,
    source_rec_id,
    etl_error_code
    );

/*----- Foreign Key -----*/
/* 
ALTER TABLE pfsawh_elt_log  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE pfsawh_elt_log  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);
*/ 
/*----- Constraints -----*/
/*
ALTER TABLE pfsawh_etl_error_log  
    DROP CONSTRAINT ck_pfsawh_etl_error_log_act_fl;        

ALTER TABLE pfsawh_etl_error_log  
    ADD CONSTRAINT ck_pfsawh_etl_error_log_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');
*/
ALTER TABLE pfsawh_etl_error_log  
    DROP CONSTRAINT ck_pfsawh_etl_error_log_del_fl;        

ALTER TABLE pfsawh_etl_error_log  
    ADD CONSTRAINT ck_pfsawh_etl_error_log_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_etl_error_log  
    DROP CONSTRAINT ck_pfsawh_etl_error_log_hid_fl;       

ALTER TABLE pfsawh_etl_error_log  
    ADD CONSTRAINT ck_pfsawh_etl_error_log_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');
/*
ALTER TABLE pfsawh_etl_error_log  
    DROP CONSTRAINT ck_pfsawh_etl_error_log_status;        

ALTER TABLE pfsawh_etl_error_log  
    ADD CONSTRAINT ck_pfsawh_etl_error_log_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );
*/
/*----- Create the Trigger now -----*/

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM pfsawh_etl_error_log a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    DELETE pfsawh_etl_error_log; 

    INSERT 
    INTO   pfsawh_etl_error_log 
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

SELECT * FROM pfsawh_etl_error_log; 

*/
