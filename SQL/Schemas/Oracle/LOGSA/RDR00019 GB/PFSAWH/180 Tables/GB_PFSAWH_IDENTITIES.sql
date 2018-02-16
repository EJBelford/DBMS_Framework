DROP TABLE gb_pfsawh_identities;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: gb_pfsawh_identities
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_identities.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: January 4, 2008
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
--      USED BY: fn_pfsawh_get_dim_identity
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_identities 
(
    REC_ID                        NUMBER              NOT NULL ,
--    
    DIMENSION_TABLENAME           VARCHAR2(30)        NOT NULL ,
    LAST_DIMENSION_IDENTITY       NUMBER              NOT NULL ,
--
    STATUS                        VARCHAR2(1)         DEFAULT    'C' ,
    UPDT_BY                       VARCHAR2(30)        DEFAULT    user ,
    LST_UPDT                      DATE                DEFAULT    sysdate ,
--
    ACTIVE_FLAG                   VARCHAR2(1)         DEFAULT    'Y' , 
    ACTIVE_DATE                   DATE                DEFAULT    sysdate , 
    INACTIVE_DATE                 DATE                DEFAULT    '31-DEC-2099' ,
--
    INSERT_BY                     VARCHAR2(20)        DEFAULT    user , 
    INSERT_DATE                   DATE                DEFAULT    sysdate , 
    UPDATE_BY                     VARCHAR2(20)        NULL ,
    UPDATE_DATE                   DATE                DEFAULT    '01-JAN-1900' ,
    DELETE_FLAG                   VARCHAR2(1)         DEFAULT    'N' ,
    DELETE_DATE                   DATE                DEFAULT    '01-JAN-1900' ,
    HIDDEN_FLAG                   VARCHAR2(1)         DEFAULT    'Y' ,
    HIDDEN_DATE                   DATE                DEFAULT    '01-JAN-1900' ,
constraint PK_gb_pfsawh_identities primary key 
    (
    DIMENSION_TABLENAME
    )    
) 
logging 
nocompress 
nocache
noparallel
monitoring;

/*----- Indexs -----*/

DROP INDEX IXU_PFSAWH_IDENTITIES;

CREATE UNIQUE INDEX IXU_PFSAWH_IDENTITIES 
    ON gb_pfsawh_identities(rec_id);

/*----- Foreign Key -----*/
/*
ALTER TABLE gb_pfsawh_identities  
    DROP CONSTRAINT FK_PFSA_Code_xx_ID;        

ALTER TABLE gb_pfsawh_identities  
    ADD CONSTRAINT FK_PFSA_Code_xx_ID 
    FOREIGN KEY (xx_ID) 
    REFERENCES xx_PFSA_yyyyy_DIM(xx_ID);
*/
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_identities  
    DROP CONSTRAINT CK_PFSAWH_IDENTITIES_ACT_FL;        

ALTER TABLE gb_pfsawh_identities  
    ADD CONSTRAINT CK_PFSAWH_IDENTITIES_ACT_FL 
    CHECK (ACTIVE_FLAG='I' OR ACTIVE_FLAG='N' OR ACTIVE_FLAG='Y');

ALTER TABLE gb_pfsawh_identities  
    DROP CONSTRAINT CK_PFSAWH_IDENTITIES_DEL_FL;        

ALTER TABLE gb_pfsawh_identities  
    ADD CONSTRAINT CK_PFSAWH_IDENTITIES_DEL_FL 
    CHECK (DELETE_FLAG='N' OR DELETE_FLAG='Y');

ALTER TABLE gb_pfsawh_identities  
    DROP CONSTRAINT CK_PFSAWH_IDENTITIES_HIDE_FL;        

ALTER TABLE gb_pfsawh_identities  
    ADD CONSTRAINT CK_PFSAWH_IDENTITIES_HIDE_FL 
    CHECK (HIDDEN_FLAG='N' OR HIDDEN_FLAG='Y');

ALTER TABLE gb_pfsawh_identities  
    DROP CONSTRAINT CK_PFSAWH_IDENTITIES_STATUS;        

ALTER TABLE gb_pfsawh_identities  
    ADD CONSTRAINT CK_PFSAWH_IDENTITIES_STATUS 
    CHECK (STATUS='C' OR STATUS='D' OR STATUS='E' OR STATUS='H' 
        OR STATUS='L' OR STATUS='P' OR STATUS='Q' OR STATUS='R'
        OR STATUS='T' OR STATUS='Z' OR STATUS='N'
        );

/*----- Table Meta-Data -----*/ 

comment on table gb_pfsawh_identities 
is 'Stores the last value used as a identity for a given dimension.'; 

comment on column gb_pfsawh_identities.rec_id 
is 'Record identity'; 

comment on column gb_pfsawh_identities.dimension_tablename 
is 'Dimension table name'; 

comment on column gb_pfsawh_identities.last_dimension_identity 
is 'The last value used for the dimension.';

comment on column gb_pfsawh_identities.status 
is 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

comment on column gb_pfsawh_identities.updt_by 
is 'The date/timestamp of when the record was created/updated.';

comment on column gb_pfsawh_identities.lst_updt 
is 'Indicates either the program name or user ID of the person who updated the record.';

comment on column gb_pfsawh_identities.active_flag 
is 'Flag indicating if the record is active or not.';

comment on column gb_pfsawh_identities.active_date 
is 'Additional control for active_Fl indicating when the record became active.';

comment on column gb_pfsawh_identities.inactive_date 
is 'Additional control for active_Fl indicating when the record went inactive.';

comment on column gb_pfsawh_identities.insert_by 
is 'Reports who initially created the record.';

comment on column gb_pfsawh_identities.insert_date 
is 'Reports when the record was initially created.';

comment on column gb_pfsawh_identities.update_by 
is 'Reports who last updated the record.';

comment on column gb_pfsawh_identities.update_date 
is 'Reports when the record was last updated.';

comment on column gb_pfsawh_identities.delete_flag 
is 'Flag indicating if the record can be deleted.';

comment on column gb_pfsawh_identities.delete_date 
is 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

comment on column gb_pfsawh_identities.hidden_flag 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

comment on column gb_pfsawh_identities.hidden_date 
is 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT  table_name, comments 
FROM    user_tab_comments 
WHERE   table_name = UPPER('GB_PFSAWH_IDENTITIES'); 

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
    ON b.table_name = UPPER('GB_PFSAWH_IDENTITIES') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('GB_PFSAWH_IDENTITIES') 
ORDER BY b.column_id; 

/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_description
        FROM gb_pfsawh_identities a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO gb_pfsawh_identities 
        (dimension_tablename, last_dimension_identity) 
        VALUES ('PFSAWH_ITEM_DIM', 0);
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO    code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.xx_ID || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_description
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
END;  
    
-- COMMIT    

/*

SELECT * FROM gb_pfsawh_identities; 

*/
