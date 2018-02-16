DROP TABLE gb_pfsawh_source_hist_ref;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: GB_PFSAWH_SOURCE_HIST_REF
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: GB_PFSAWH_SOURCE_HIST_REF.sql
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
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--
CREATE TABLE GB_PFSAWH_SOURCE_HIST_REF 
(
    SOURCE_HIST_REF_ID                           NUMBER              NOT NULL ,
--
    SOURCE_LAST_CHECKED_DATE                     DATE                NULL ,
    SOURCE_LAST_PROCESSED_DATE                   DATE                NULL ,
    SOURCE_DATABASE                              VARCHAR2(30)        NULL ,
    SOURCE_SCHEMA                                VARCHAR2(30)        NULL ,
    SOURCE_TABLE                                 VARCHAR2(30)        NOT NULL ,
--
    SOURCE_LAST_RECORD_COUNT                     NUMBER              NULL ,
    SOURCE_LAST_UPDATE_DATE                      DATE                NULL ,
    SOURCE_LAST_UPDATE_COUNT                     NUMBER              NULL ,
    SOURCE_LAST_INSERT_COUNT                     NUMBER              NULL ,
    SOURCE_LAST_DELETE_COUNT                     NUMBER              NULL ,
--
    STATUS                                       VARCHAR2(1)         DEFAULT    'N' ,
    UPDT_BY                                      VARCHAR2(30)        DEFAULT    user ,
    LST_UPDT                                     DATE                DEFAULT    sysdate ,
--
    ACTIVE_FLAG                                  VARCHAR2(1)         DEFAULT    'I' , 
    ACTIVE_DATE                                  DATE                DEFAULT    '01-JAN-1900' , 
    INACTIVE_DATE                                DATE                DEFAULT    '31-DEC-2099' ,
--
    INSERT_BY                                    VARCHAR2(20)        DEFAULT    user , 
    INSERT_DATE                                  DATE                DEFAULT    sysdate , 
    UPDATE_BY                                    VARCHAR2(20)        NULL ,
    UPDATE_DATE                                  DATE                DEFAULT    '01-JAN-1900' ,
    DELETE_FLAG                                  VARCHAR2(1)         DEFAULT    'N' ,
    DELETE_DATE                                  DATE                DEFAULT    '01-JAN-1900' ,
    HIDDEN_FLAG                                  VARCHAR2(1)         DEFAULT    'Y' ,
    HIDDEN_DATE                                  DATE                DEFAULT    '01-JAN-1900' ,
CONSTRAINT pk_gb_pfsawh_source_hist_ref PRIMARY KEY 
    (
    SOURCE_HIST_REF_ID
    )    
) 
logging 
nocompress 
nocache
noparallel
monitoring;

/*----- Indexs -----*/

DROP INDEX IXU_PFSA_SOURCE_TABLE_HIST_REF;

CREATE UNIQUE INDEX IXU_PFSA_SOURCE_TABLE_HIST_REF 
    ON GB_PFSAWH_SOURCE_HIST_REF(SOURCE_TABLE);

/*----- Foreign Key -----*/
/*
ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  DROP CONSTRAINT FK_PFSA_Code_xx_ID;        

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  ADD CONSTRAINT FK_PFSA_Code_xx_ID foreign key (xx_ID) 
    REFERENCES xx_PFSA_yyyyy_DIM(xx_ID);
*/
/*----- Constraints -----*/

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    DROP CONSTRAINT CK_PFSAWH_SRC_HIST_REF_ACT_FLG        

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    ADD CONSTRAINT CK_PFSAWH_SRC_HIST_REF_ACT_FLG 
    CHECK (ACTIVE_FLAG='I' OR ACTIVE_FLAG='N' OR ACTIVE_FLAG='Y');

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    DROP CONSTRAINT CK_PFSAWH_SRC_HIST_REF_DEL_FLG        

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    ADD CONSTRAINT CK_PFSAWH_SRC_HIST_REF_DEL_FLG 
    CHECK (DELETE_FLAG='N' OR DELETE_FLAG='Y');

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    DROP CONSTRAINT CK_PFSAWH_SRC_HIST_REF_HIDE_FL        

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    ADD CONSTRAINT CK_PFSAWH_SRC_HIST_REF_HIDE_FL 
    CHECK (HIDDEN_FLAG='N' OR HIDDEN_FLAG='Y');

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  
    DROP CONSTRAINT CK_PFSAWH_SRC_HIST_REF_STATUS        

ALTER TABLE GB_PFSAWH_SOURCE_HIST_REF  ADD CONSTRAINT CK_PFSAWH_SRC_HIST_REF_STATUS 
    CHECK (STATUS='C' OR STATUS='D' OR STATUS='E' OR STATUS='H' 
        OR STATUS='L' OR STATUS='P' OR STATUS='Q' OR STATUS='R'
        OR STATUS='T' OR STATUS='Z' OR STATUS='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE PFSAWH_SOURCE_HIST_REF_ID;

CREATE SEQUENCE PFSAWH_SOURCE_HIST_REF_ID
    START WITH 10000
    MAXVALUE 99999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- trigger 

CREATE OR REPLACE TRIGGER TR_I_PFSAWH_SRC_HIST_REF_SEQ
BEFORE INSERT
ON GB_PFSAWH_SOURCE_HIST_REF
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    TR_I_PFSAWH_SRC_HIST_REF_SEQ

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

begin
   v_item_dim_id := 0;

   select PFSAWH_SOURCE_HIST_REF_ID.nextval into v_item_dim_id from dual;
   :new.SOURCE_HIST_REF_ID := v_item_dim_id;
   :new.status := 'Z';
   :new.lst_updt := sysdate;
   :new.updt_by  := user;

   exception
     when others then
       -- consider logging the error and then re-raise
       raise;
       
end TR_I_PFSAWH_SRC_HIST_REF_SEQ;

/*----- Table Meta-Data -----*/ 

comment on table GB_PFSAWH_SOURCE_HIST_REF 
is 'Contains usefull information for the warehouse ETL process use in processing upstream information. '; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_HIST_REF_ID 
is 'Row identity'; 


comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_CHECKED_DATE
is 'The last time the source table was audited by the warehouse or the source flagged changes for the warehouse.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_PROCESSED_DATE
is 'The last time the source table were loaded to the warehouse.';

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_DATABASE
is 'The database where the source schema and table can be found.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_SCHEMA
is 'The schema where the source table can be found.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_TABLE
is 'The source table.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_RECORD_COUNT
is 'The number of records in the source table when last processed by the warehouse ETL.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_UPDATE_DATE
is 'The date of the last source table update when processed by the warehouse ETL.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_UPDATE_COUNT
is 'The number of updated records in the source table when last processed by the warehouse ETL.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_INSERT_COUNT
is 'The number of new records in the source table when last processed by the warehouse ETL.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.SOURCE_LAST_DELETE_COUNT
is 'The number of delete/hidden records in the source table when last processed by the warehouse ETL.'; 

comment on column GB_PFSAWH_SOURCE_HIST_REF.STATUS 
is 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]'

comment on column GB_PFSAWH_SOURCE_HIST_REF.UPDT_BY 
is 'The date/timestamp of when the record was created/updated.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.LST_UPDT 
is 'Indicates either the program name or user ID of the person who updated the record.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.ACTIVE_FLAG 
is 'Flag indicating if the record is active or not.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.ACTIVE_DATE 
is 'Additional control for active_Fl indicating when the record became active.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.INACTIVE_DATE 
is 'Additional control for active_Fl indicating when the record went inactive.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.INSERT_BY 
is 'Reports who initially created the record.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.INSERT_DATE 
is 'Reports when the record was initially created.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.UPDATE_BY 
is 'Reports who last updated the record.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.UPDATE_DATE 
is 'Reports when the record was last updated.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.DELETE_DATE 
is 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'

comment on column GB_PFSAWH_SOURCE_HIST_REF.HIDDEN_DATE 
is 'Additional control for HIDDEN_FLAG indicating when the record was hidden.'

/*----- Check to see if the table comment is present -----*/

SELECT    TABLE_NAME, COMMENTS 
FROM    USER_TAB_COMMENTS 
WHERE    Table_Name = UPPER('GB_PFSAWH_SOURCE_HIST_REF') 

/*----- Check to see if the table column comments are present -----*/

SELECT    b.COLUMN_ID, 
        a.TABLE_NAME, 
        a.COLUMN_NAME, 
        b.DATA_TYPE, 
        b.DATA_LENGTH, 
        b.NULLABLE, 
        a.COMMENTS 
FROM    USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('GB_PFSAWH_SOURCE_HIST_REF') 
    AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE    a.TABLE_NAME = UPPER('GB_PFSAWH_SOURCE_HIST_REF') 
ORDER BY b.COLUMN_ID 

/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM GB_PFSAWH_SOURCE_HIST_REF a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO GB_PFSAWH_SOURCE_HIST_REF (source_database, source_schema, source_table) 
        VALUES ('LIDBDEV', NULL, 'MANUFACTURER_PART');
    INSERT INTO GB_PFSAWH_SOURCE_HIST_REF (source_database, source_schema, source_table) 
        VALUES ('LIDBDEV', NULL, 'ITEM_CONTROL');
    INSERT INTO GB_PFSAWH_SOURCE_HIST_REF (source_database, source_schema, source_table) 
        VALUES ('LIDBDEV', NULL, 'ITEM_DATA');
    INSERT INTO GB_PFSAWH_SOURCE_HIST_REF (source_database, source_schema, source_table) 
        VALUES ('LIDBDEV', NULL, 'GCSSA_LIN');
    INSERT INTO GB_PFSAWH_SOURCE_HIST_REF (source_database, source_schema, source_table) 
        VALUES ('LIDBDEV', NULL, 'GCSSA_HR_ASSET');
    INSERT INTO GB_PFSAWH_SOURCE_HIST_REF (source_database, source_schema, source_table) 
        VALUES ('LIDBDEV', NULL, 'LIN');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO    code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.xx_ID || ', ' || code_rec.xx_CODE || ', ' || code_rec.xx_DESCRIPTION);
        
    END LOOP;
    
    CLOSE code_cur;
    
END;  
    
-- COMMIT    

/*

SELECT * FROM GB_PFSAWH_SOURCE_HIST_REF; 

*/
