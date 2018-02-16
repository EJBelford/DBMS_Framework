DROP TABLE GB_PFSAWH_PROCESS_CONTROL;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: GB_PFSAWH_PROCESS_CONTROL
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: GB_PFSAWH_PROCESS_CONTROL.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 02 JANUSRY 2008
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
CREATE TABLE GB_PFSAWH_PROCESS_CONTROL 
(
    PROCESS_CONTROL_ID            NUMBER              NOT NULL ,
--
    PROCESS_CONTROL_NAME          VARCHAR2(30)        NOT NULL ,
    PROCESS_CONTROL_VALUE         VARCHAR2(10)        NOT NULL ,
    PROCESS_CONTROL_DESCRIPTION   VARCHAR2(100)       NULL ,
--
    STATUS                        VARCHAR2(1)         DEFAULT    'N' ,
    UPDT_BY                       VARCHAR2(30)        DEFAULT    user ,
    LST_UPDT                      DATE                DEFAULT    sysdate ,
--
    ACTIVE_FLAG                   VARCHAR2(1)         DEFAULT    'I' , 
    ACTIVE_DATE                   DATE                DEFAULT    '01-JAN-1900' , 
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
constraint PK_GB_PFSAWH_PROCESS_CONTROL primary key 
    (
    PROCESS_CONTROL_NAME
    )    
) 
logging 
nocompress 
nocache
noparallel
monitoring;

/*----- Indexs -----*/

DROP INDEX IXU_PFSAWH_Blank_DIM;

CREATE UNIQUE INDEX IXU_PFSAWH_Blank_DIM 
    ON GB_PFSAWH_PROCESS_CONTROL(PROCESS_CONTROL_ID);

/*----- Foreign Key -----*/
/*
ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    DROP CONSTRAINT FK_PFSA_Code_xx_ID;        

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    ADD CONSTRAINT FK_PFSA_Code_xx_ID 
    FOREIGN KEY (xx_ID) 
    REFERENCES xx_PFSA_yyyyy_DIM(xx_ID);
*/
/*----- Constraints -----*/

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    DROP CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_ACT_FL        

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    ADD CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_ACT_FL 
    CHECK (ACTIVE_FLAG='I' OR ACTIVE_FLAG='N' OR ACTIVE_FLAG='Y');

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    DROP CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_DEL_FL        

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    ADD CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_DEL_FL 
    CHECK (DELETE_FLAG='N' OR DELETE_FLAG='Y');

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    DROP CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_HID_FL        

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    ADD CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_HID_FL 
    CHECK (HIDDEN_FLAG='N' OR HIDDEN_FLAG='Y');

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    DROP CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_STATUS        

ALTER TABLE GB_PFSAWH_PROCESS_CONTROL  
    ADD CONSTRAINT CK_PFSAWH_PROCESS_CNTRL_STATUS 
    CHECK (STATUS='C' OR STATUS='D' OR STATUS='E' OR STATUS='H' 
        OR STATUS='L' OR STATUS='P' OR STATUS='Q' OR STATUS='R'
        OR STATUS='T' OR STATUS='Z' OR STATUS='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE PFSAWH_PROCESS_CONTROL_SEQ;

CREATE SEQUENCE PFSAWH_PROCESS_CONTROL_SEQ
    START WITH 1000
    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- trigger 

CREATE OR REPLACE TRIGGER TR_I_PFSAWH_PROCESS_CNTRL_SEQ
BEFORE INSERT
ON GB_PFSAWH_PROCESS_CONTROL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    TR_I_PFSAWH_PROCESS_CNTRL_SEQ

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
01/02/2008                   Gene Belford     Trigger Created
*/

BEGIN
   v_item_dim_id := 0;

   SELECT PFSAWH_PROCESS_CONTROL_SEQ.nextval 
   INTO   v_item_dim_id 
   FROM   dual;
       :new.process_control_id := v_item_dim_id;
       :new.status             := 'Z';
       :new.lst_updt           := sysdate;
       :new.updt_by            := user;

   EXCEPTION
       WHEN others THEN
       -- consider logging the error and then re-raise
       RAISE;
       
END TR_I_PFSAWH_PROCESS_CNTRL_SEQ;

SHOW ERRORS;

/*----- Table Meta-Data -----*/ 

comment on table GB_PFSAWH_PROCESS_CONTROL 
is 'Master process control table for PFSAWH to eliminate hard coding in processes. '; 

comment on column GB_PFSAWH_PROCESS_CONTROL.PROCESS_CONTROL_ID
is 'Record sequenece. '; 
    
comment on column GB_PFSAWH_PROCESS_CONTROL.PROCESS_CONTROL_NAME 
is 'Field name. '; 

comment on column GB_PFSAWH_PROCESS_CONTROL.PROCESS_CONTROL_VALUE 
is 'The value used by other processes. '; 

comment on column GB_PFSAWH_PROCESS_CONTROL.PROCESS_CONTROL_DESCRIPTION
is 'Purpose/description of control field. '; 

comment on column GB_PFSAWH_PROCESS_CONTROL.STATUS 
is 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]'

comment on column GB_PFSAWH_PROCESS_CONTROL.UPDT_BY 
is 'The date/timestamp of when the record was created/updated.'

comment on column GB_PFSAWH_PROCESS_CONTROL.LST_UPDT 
is 'Indicates either the program name or user ID of the person who updated the record.'

comment on column GB_PFSAWH_PROCESS_CONTROL.ACTIVE_FLAG 
is 'Flag indicating if the record is active or not.'

comment on column GB_PFSAWH_PROCESS_CONTROL.ACTIVE_DATE 
is 'Additional control for active_Fl indicating when the record became active.'

comment on column GB_PFSAWH_PROCESS_CONTROL.INACTIVE_DATE 
is 'Additional control for active_Fl indicating when the record went inactive.'

comment on column GB_PFSAWH_PROCESS_CONTROL.INSERT_BY 
is 'Reports who initially created the record.'

comment on column GB_PFSAWH_PROCESS_CONTROL.INSERT_DATE 
is 'Reports when the record was initially created.'

comment on column GB_PFSAWH_PROCESS_CONTROL.UPDATE_BY 
is 'Reports who last updated the record.'

comment on column GB_PFSAWH_PROCESS_CONTROL.UPDATE_DATE 
is 'Reports when the record was last updated.'

comment on column GB_PFSAWH_PROCESS_CONTROL.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'

comment on column GB_PFSAWH_PROCESS_CONTROL.DELETE_DATE 
is 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.'

comment on column GB_PFSAWH_PROCESS_CONTROL.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'

comment on column GB_PFSAWH_PROCESS_CONTROL.HIDDEN_DATE 
is 'Additional control for HIDDEN_FLAG indicating when the record was hidden.'

/*----- Check to see if the table comment is present -----*/

SELECT    TABLE_NAME, COMMENTS 
FROM    USER_TAB_COMMENTS 
WHERE    Table_Name = UPPER('GB_PFSAWH_PROCESS_CONTROL') 

/*----- Check to see if the table column comments are present -----*/

SELECT    b.COLUMN_ID, 
        a.TABLE_NAME, 
        a.COLUMN_NAME, 
        b.DATA_TYPE, 
        b.DATA_LENGTH, 
        b.NULLABLE, 
        a.COMMENTS 
FROM    USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b 
    ON b.TABLE_NAME = UPPER('GB_PFSAWH_PROCESS_CONTROL') 
    AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE    a.TABLE_NAME = UPPER('GB_PFSAWH_PROCESS_CONTROL') 
ORDER BY b.COLUMN_ID 

/*----- Populate -----*/

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM GB_PFSAWH_PROCESS_CONTROL a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 
    DELETE GB_PFSAWH_PROCESS_CONTROL;

    INSERT 
    INTO GB_PFSAWH_PROCESS_CONTROL 
        (
        PROCESS_CONTROL_NAME, 
        PROCESS_CONTROL_VALUE, 
        PROCESS_CONTROL_DESCRIPTION 
        ) 
    VALUES 
        ('v_keep_n_days_of_debug', '5', 'NOT APPLICABLE');
        
    INSERT 
    INTO GB_PFSAWH_PROCESS_CONTROL 
        (
        PROCESS_CONTROL_NAME, 
        PROCESS_CONTROL_VALUE, 
        PROCESS_CONTROL_DESCRIPTION 
        ) 
    VALUES 
        ('v_keep_n_days_of_log', '5', 'NOT APPLICABLE');
    
    UPDATE GB_PFSAWH_PROCESS_CONTROL 
    SET	status = 'C', 
           active_date = sysdate,
           active_flag = 'Y',
           updt_by = 'EJB',
           lst_updt = sysdate;
        
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

SELECT * FROM GB_PFSAWH_PROCESS_CONTROL; 

SELECT process_control_value
FROM   GB_PFSAWH_PROCESS_CONTROL 
WHERE  process_control_name = 'v_keep_n_days_of_debug' 
    AND status = 'C' 
    AND active_flag = 'Y' 
    AND sysdate BETWEEN active_date AND inactive_date; 

*/
