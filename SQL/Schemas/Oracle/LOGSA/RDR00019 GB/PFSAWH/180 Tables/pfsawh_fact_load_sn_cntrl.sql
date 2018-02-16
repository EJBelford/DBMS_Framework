/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_fact_ld_sn_cntrl 
--      PURPOSE: 
--
-- TABLE SOURCE: pfsawh_fact_ld_sn_cntrl.sql 
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 12 November 2008 
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
-- 12NOV08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE pfsawh_fact_ld_sn_cntrl_seq;

CREATE SEQUENCE pfsawh_fact_ld_sn_cntrl_seq
    START WITH 1000000
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create Table  -----*/

-- DROP TABLE pfsawh_fact_ld_sn_cntrl;
	
CREATE TABLE pfsawh_fact_ld_sn_cntrl 
(
    rec_id                           NUMBER              NOT NULL ,
--
    physical_item_id                 NUMBER              NOT NULL ,
    niin                             VARCHAR2(9)         DEFAULT 'UNK' ,
    physical_item_sn_id              NUMBER              NOT NULL ,
    serial_number                    VARCHAR2(48)        DEFAULT 'UNK' ,
    item_nomen_standard              VARCHAR2(35)        DEFAULT 'UNK' , 
--    
    status                           VARCHAR2(1)         DEFAULT 'W' , 
--    
    load_date                        DATE , 
    load_date_id                     NUMBER , 
    touch_count                      NUMBER              DEFAULT 0 , 
    serial_number_new_flag           VARCHAR2(1) ,
    new_period_data_flag             VARCHAR2(1) ,
    scheduled_load_date              DATE , 
    scheduled_load_date_id           NUMBER , 
--
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
--    grab_stamp                       VARCHAR2(30)        NULL ,
--    proc_stamp                       VARCHAR2(30)        NULL ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'Y' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
--    wh_record_status                 VARCHAR2(10)        NULL , 
--    wh_last_update_date              DATE                NULL ,
--    wh_effective_date                DATE                NULL , 
--    wh_expiration_date               DATE                NULL ,
--
--    source_rec_id                    NUMBER              NOT NULL ,
    insert_by                        VARCHAR2(50)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
--    lst_update_rec_id                NUMBER              NOT NULL ,
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

COMMENT ON TABLE pfsawh_fact_ld_sn_cntrl 
IS 'PFSAWH_FACT_LD_SN_CNTRL - Identifies what niin are scheduled to be reloaded in the fact tables, or whne they were last reloaded. '; 


COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_fact_ld_sn_cntrl table.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.niin 
IS 'NIIN - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.item_nomen_standard 
IS 'ITEM_NOMEN_STANDARD - Description of the item.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.scheduled_load_date 
IS 'SCHEDULED_LOAD_DATE - When the NIIN is to be reloaded.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.scheduled_load_date_id 
IS 'SCHEDULED_LOAD_DATE_ID - Foreign key of the PFSAWH_DATE_DIM table for when the NIIN is to be reloaded.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.load_date 
IS 'LOAD_DATE - When the NIIN was reloaded.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.load_date_id 
IS 'LOAD_DATE_ID - Foreign key of the PFSAWH_DATE_DIM table when the NIIN was reloaded.'; 

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.delete_by 
IS 'DELETE_BY - Reports who last deleted the record.';       

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.hidden_by 
IS 'HIDDEN_BY - Reports who last hide the record.';       

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_fact_ld_sn_cntrl.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_fact_ld_sn_cntrl'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_fact_ld_sn_cntrl') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_fact_ld_sn_cntrl') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%niin%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%date_id%'); 

/*----- Primary Key -----*/

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT pk_pfsawh_fact_ld_sn_cntrl 
    PRIMARY KEY 
    (
    rec_id
    );    
   
/*----- Indexs -----*/

--DROP INDEX ixu_pfsawh_fact_ld_sn_cntrl;

CREATE UNIQUE INDEX ixu_pfsawh_fact_ld_sn_cntrl 
    ON pfsawh_fact_ld_sn_cntrl
        (
        physical_item_id, 
        physical_item_sn_id   
        );

/*----- Foreign Key -----*/

--ALTER TABLE pfsawh_fact_ld_sn_cntrl  
--    DROP CONSTRAINT fk_pfsawh_code_physical_itm;        

--ALTER TABLE pfsawh_fact_ld_sn_cntrl  
--    ADD CONSTRAINT fk_pfsawh_code_physical_itm 
--    FOREIGN KEY (physical_item_id) 
--    REFERENCES pfsawh_item_dim(physical_item_id);

/*----- Constraints -----*/

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    DROP CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_act_fl;        

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    DROP CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_del_fl;        

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    DROP CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_hid_fl;       

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    DROP CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_status;        

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_status 
    CHECK (status='C' OR status='W' OR status='Z');

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    DROP CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_new_fl;        

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_new_fl 
    CHECK (serial_number_new_flag='N' OR serial_number_new_flag='Y');

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    DROP CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_dat_fl;        

ALTER TABLE pfsawh_fact_ld_sn_cntrl  
    ADD CONSTRAINT ck_pfsawh_ft_ld_sn_ctrl_dat_fl 
    CHECK (new_period_data_flag='N' OR new_period_data_flag='Y');

/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM pfsawh_fact_ld_sn_cntrl FOR pfsawh.pfsawh_fact_ld_sn_cntrl; 

/*----- Grants-----*/

GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO LIW_BASIC; 

GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO LIW_RESTRICTED; 

GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO S_PFSAW; 

-- GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO MD2L043; 

-- GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO S_PBUSE; 

-- GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO S_WEBPROP; 

GRANT SELECT ON pfsawh_fact_ld_sn_cntrl TO C_PFSAW; 


    
/*

SELECT * FROM pfsawh_fact_ld_sn_cntrl; 

*/
