/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: xx_pfsawh_blank_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: xx_pfsawh_blank_dim.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 
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
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Sequence  -----*/

DROP SEQUENCE xx_pfsawh_blank_dim_seq;

CREATE SEQUENCE xx_pfsawh_blank_dim_seq
    START WITH 1000000
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create Table  -----*/

DROP TABLE xx_pfsawh_blank_dim;
	
--
CREATE TABLE xx_pfsawh_blank_dim 
(
    rec_id                           NUMBER              NOT NULL ,
--
    xx_id                            NUMBER              DEFAULT 0 ,
    xx_description                   VARCHAR2(20)        DEFAULT 'unk' ,
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    grab_stamp                       VARCHAR2(30)        NULL ,
    proc_stamp                       VARCHAR2(30)        NULL ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'Y' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    wh_record_status                 VARCHAR2(10)        NULL , 
    wh_last_update_date              DATE                NULL ,
    wh_effective_date                DATE                NULL , 
    wh_expiration_date               DATE                NULL ,
--
    source_rec_id                    NUMBER              NOT NULL ,
    insert_by                        VARCHAR2(50)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    lst_update_rec_id                NUMBER              NOT NULL ,
    update_by                        VARCHAR2(50)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_by                        VARCHAR2(50)        NULL ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_by                        VARCHAR2(50)        NULL ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900'  
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             32K
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

COMMENT ON TABLE xx_pfsawh_blank_dim 
IS 'XX_PFSAWH_BLANK_DIM - '; 


COMMENT ON COLUMN xx_pfsawh_blank_dim.rec_id 
IS 'REC_ID - Primary, blind key of the XX_PFSAWH_BLANK_DIM table.'; 

COMMENT ON COLUMN xx_pfsawh_blank_dim.xx_id 
IS 'XX_ID - '; 

COMMENT ON COLUMN xx_pfsawh_blank_dim.xx_description 
IS 'XX_DESCRIPTION - '; 

COMMENT ON COLUMN xx_pfsawh_blank_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN xx_pfsawh_blank_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.grab_stamp 
IS 'GRAB_STAMP - The date and time the record entered the PFSA world.  The actual value is the sysdate when the PFSA grab procedure that populated a PFSA table (BLD, POTENTIAL or production) table for the first time in PFSA.  When the record move from "BLD to POTENITAL" or "BLD to production" the grab_date does not change.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.proc_stamp 
IS 'PROC_STAMP - The date timestamp (sysdate) of the promotion action.  ie: "BLD to POTENITAL" or "BLD to production"';       

COMMENT ON COLUMN xx_pfsawh_blank_dim.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_force_dim.wh_record_status 
IS 'WH_RECORD_STATUS - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_force_dim.wh_last_update_date 
IS 'WH_LAST_UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_force_dim.wh_effective_date 
IS 'WH_EFFECTIVE_DATE - Additional control for ACTIVE_FL indicating when the record became active.';

COMMENT ON COLUMN pfsawh_force_dim.wh_expiration_date 
IS 'WH_EXPIRATION_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from a outside source.';       

COMMENT ON COLUMN xx_pfsawh_blank_dim.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.lst_update_rec_id 
IS 'LST_UPDATE_REC_ID - Identifier to the last update record received from an outside source.';       

COMMENT ON COLUMN xx_pfsawh_blank_dim.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.delete_by 
IS 'DELETE_BY - Reports who last deleted the record.';       

COMMENT ON COLUMN xx_pfsawh_blank_dim.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.hidden_by 
IS 'HIDDEN_BY - Reports who last hide the record.';       

COMMENT ON COLUMN xx_pfsawh_blank_dim.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('xx_pfsawh_blank_dim'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('xx_pfsawh_blank_dim') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('xx_pfsawh_blank_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%rec_id%'); 

/*----- Primary Key -----*/

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT pk_xx_pfsawh_blank_dim 
    PRIMARY KEY 
    (
    rec_id
    );    
   
/*----- Indexs -----*/

DROP INDEX ixu_xx_pfsawh_blank_dim;

CREATE UNIQUE INDEX ixu_xx_pfsawh_blank_dim 
    ON xx_pfsawh_blank_dim(xx_id);

/*----- Foreign Key -----*/

ALTER TABLE xx_pfsawh_blank_dim  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);

/*----- Constraints -----*/

ALTER TABLE xx_pfsawh_blank_dim  
    DROP CONSTRAINT ck_xx_pfsawh_blank_dim_act_fl;        

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT ck_xx_pfsawh_blank_dim_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE xx_pfsawh_blank_dim  
    DROP CONSTRAINT ck_xx_pfsawh_blank_dim_del_fl;        

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT ck_xx_pfsawh_blank_dim_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE xx_pfsawh_blank_dim  
    DROP CONSTRAINT ck_xx_pfsawh_blank_dim_hide_fl;       

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT ck_xx_pfsawh_blank_dim_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE xx_pfsawh_blank_dim  
    DROP CONSTRAINT ck_xx_pfsawh_blank_dim_status;        

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT ck_xx_pfsawh_blank_dim_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM xx_pfsawh_blank_dim FOR pfsawh.xx_pfsawh_blank_dim; 

/*----- Grants-----*/

GRANT SELECT ON xx_pfsawh_blank_dim TO LIW_BASIC; 

GRANT SELECT ON xx_pfsawh_blank_dim TO LIW_RESTRICTED; 

GRANT SELECT ON xx_pfsawh_blank_dim TO S_PFSAW; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO MD2L043; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO S_PBUSE; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO S_WEBPROP; 

GRANT SELECT ON xx_pfsawh_blank_dim TO C_PFSAW; 


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM xx_pfsawh_blank_dim a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO xx_pfsawh_blank_dim (xx_id, xx_code, xx_description) 
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

SELECT * FROM xx_pfsawh_blank_dim; 

*/
