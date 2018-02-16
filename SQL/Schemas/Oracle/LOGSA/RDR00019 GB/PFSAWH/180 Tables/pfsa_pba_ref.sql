/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsa_pba_ref 
--      PURPOSE: PERFORMANCE BASED LOGISTICS - Parent record for all the 
--               contract related information, (NIIN, UIC, SN, etc.) 
--
-- TABLE SOURCE: pfsa_pba_ref.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 20 February 2008
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
-- 20FEB08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

-- DROP TABLE pfsa_pba_ref;
	
CREATE TABLE pfsa_pba_ref 
(
    pba_id                        NUMBER              DEFAULT    0 ,
--
    pba_key1                      VARCHAR2(3)         DEFAULT    'xxx' ,
    pba_key2                      VARCHAR2(10)        DEFAULT    'yyyy' ,
    pba_seq                       NUMBER              DEFAULT    0 ,
    pba_title                     VARCHAR2(100)       DEFAULT    'unk' ,
    pba_point_of_contact          VARCHAR2(30)        DEFAULT    'unk' ,
    pba_description               VARCHAR2(100)       DEFAULT    'unk' ,
    pba_agreement_date_id         NUMBER              DEFAULT    -1 ,
    pba_status_code               VARCHAR2(2)         DEFAULT    '-1' ,
    pba_from_date_id              NUMBER              DEFAULT    -1 ,
    pba_to_date_id                NUMBER              DEFAULT    -1 ,
    pba_lifecyle_logistics_phase  VARCHAR2(2)         DEFAULT    '-1' ,
    pba_retention_period          NUMBER              DEFAULT    -1 ,
    pba_freeze_flag               VARCHAR2(2)         DEFAULT    '-1' ,
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
    hidden_date                   DATE                DEFAULT    '01-JAN-1900' 
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

COMMENT ON TABLE pfsa_pba_ref 
IS 'PFSA_PBA_REF - PERFORMANCE BASED AGREEMENTS - Parent record for all the contract related information, (NIIN, UIC, SN, etc.)'; 


COMMENT ON COLUMN pfsa_pba_ref.pba_id 
IS 'PBA_ID - '; 

COMMENT ON COLUMN pfsa_pba_ref.pba_key1 
IS 'PBA_KEY1 - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_key2 
IS 'PBA_KEY2 - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_seq 
IS 'PBA_SEQ - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_title 
IS 'PBA_TITLE - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_point_of_contact 
IS 'PBA_POINT_OF_CONTACT - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_description 
IS 'PBA_DESCRIPTION - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_agreement_date_id 
IS 'PBA_AGREEMENT_DATE_ID - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_status_code 
IS 'PBA_STATUS_CODE - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_from_date_id 
IS 'PBA_FROM_DATE_ID - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_to_date_id 
IS 'PBA_TO_DATE_ID - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_lifecyle_logistics_phase 
IS 'PBA_LIFECYLE_LOGISTICS_PHASE - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_retention_period 
IS 'PBA_RETENTION_PERIOD - ';

COMMENT ON COLUMN pfsa_pba_ref.pba_freeze_flag 
IS 'PBA_FREEZE_FLAG - ';

COMMENT ON COLUMN pfsa_pba_ref.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsa_pba_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsa_pba_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsa_pba_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsa_pba_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_pba_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_pba_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsa_pba_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_pba_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsa_pba_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_pba_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsa_pba_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_pba_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsa_pba_ref.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

--SELECT table_name, comments 
--FROM   user_tab_comments 
--WHERE  table_name = UPPER('pfsa_pba_ref');  

/*----- Check to see if the table column comments are present -----*/

--SELECT  b.column_id, 
--        a.table_name, 
--        a.column_name, 
--        b.data_type, 
--        b.data_length, 
--        b.nullable, 
--        a.comments 
--FROM    user_col_comments a
--LEFT OUTER JOIN user_tab_columns b  
--    ON  b.table_name  = UPPER('pfsa_pba_ref') 
--    AND a.column_name = b.column_name
--WHERE    a.table_name = UPPER('pfsa_pba_ref') 
--ORDER BY b.column_id;  

/*----- Look-up field description from master LIDB table -----*/

--SELECT a.* 
--FROM   lidb_cmnt@pfsawh.lidbdev a
--WHERE  a.col_name LIKE UPPER('%supply%')
--ORDER BY a.col_name;  
--   
--SELECT a.* 
--FROM   user_col_comments a
--WHERE  a.column_name LIKE UPPER('%defer%'); 
   
