/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_maint_work 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_maint_work.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 15 April 2008 
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
-- 15APR08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Create table  -----*/

-- DROP TABLE frz_pfsa_maint_work;
    
CREATE TABLE frz_pfsa_maint_work
(
    rec_id                           NUMBER         NOT NULL, 
    source_rec_id                    NUMBER         DEFAULT  0, 
---    
    pba_id                           NUMBER         NOT NULL, 
    physical_item_id                 NUMBER         DEFAULT  0,
    physical_item_sn_id              NUMBER         DEFAULT  0,
    force_unit_id                    NUMBER         DEFAULT  0,
    mimosa_item_sn_id                VARCHAR2(8)    DEFAULT '00000000',
--    
    MAINT_EV_ID                      VARCHAR2(40)   NOT NULL,
    MAINT_TASK_ID                    VARCHAR2(50)   NOT NULL,
    MAINT_WORK_ID                    VARCHAR2(12)   NOT NULL,
    MAINT_WORK_MH                    NUMBER,
    MIL_CIV_KON                      VARCHAR2(1),
    MOS                              VARCHAR2(10),
    SPEC_PERSON                      VARCHAR2(20),
    REPAIR                           VARCHAR2(1),
    MOS_SENT                         VARCHAR2(10),
    HEIR_ID                          VARCHAR2(20),
    PRIORITY                         NUMBER, 
--
    STATUS                           VARCHAR2(1),
    LST_UPDT                         DATE,
    UPDT_BY                          VARCHAR2(30), 
--
    frz_input_date                   DATE,
    frz_input_date_id                NUMBER,
    rec_frz_flag                     VARCHAR2(1)         DEFAULT 'N',
    frz_date                         DATE                DEFAULT '31-DEC-2099',
--
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_by                        VARCHAR2(20)        NULL ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' , 
    hidden_by                        VARCHAR2(20)        NULL  
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          3M
            NEXT             1M
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

COMMENT ON TABLE frz_pfsa_maint_work 
IS 'FRZ_PFSA_MAINT_WORK - This table documents all work performed by maintanenace personnel during a maintenance event.  Work not attributable to a specific person is aggregated';


COMMENT ON COLUMN frz_pfsa_maint_work.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_maint_work.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_maint_work.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_maint_work.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_work.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_work.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_work.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_maint_work.MAINT_EV_ID 
IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN frz_pfsa_maint_work.MAINT_TASK_ID 
IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN frz_pfsa_maint_work.MAINT_WORK_ID 
IS 'MAINT_WORK_ID - The identifier that when combined with the MAINT_EV_ID and MAINT_TASK_ID creates a unique maintenance task work id.';

COMMENT ON COLUMN frz_pfsa_maint_work.MAINT_WORK_MH 
IS 'MAINT_WORK_MH - The number of hours the maintenance work took to complete.';

COMMENT ON COLUMN frz_pfsa_maint_work.MIL_CIV_KON 
IS 'MIL_CIV_KON - The code for the type of person doing the maintenance, Civilian, Kontractor, Military or Unknown.  Values are C\K\M\U';

COMMENT ON COLUMN frz_pfsa_maint_work.MOS 
IS 'MOS - OCCUPATIONAL SPECIALTY CODE - The code that represents the Military Occupational Specialty (MOS) of the person performing the maintenance action.';

COMMENT ON COLUMN frz_pfsa_maint_work.SPEC_PERSON 
IS 'SPEC_PERSON ? Specific person who performed the work.';

COMMENT ON COLUMN frz_pfsa_maint_work.REPAIR 
IS 'REPAIR - Item was repaired.  Values should be Y - Yes, N - No, ? - Unknown';

COMMENT ON COLUMN frz_pfsa_maint_work.MOS_SENT 
IS 'MOS_SENT - The value of provided in the source data for the MOS.  This value is used to derive the MOS used.  The derived values generally remove the skill level code, and standardize terms used for Contractor and Civilian personnel.';

COMMENT ON COLUMN frz_pfsa_maint_work.HEIR_ID 
IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN frz_pfsa_maint_work.PRIORITY 
IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN frz_pfsa_maint_work.STATUS 
IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN frz_pfsa_maint_work.LST_UPDT 
IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN frz_pfsa_maint_work.UPDT_BY 
IS 'UPDT_BY - Who/what updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_work.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN frz_pfsa_maint_work.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN frz_pfsa_maint_work.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_work.FRZ_INPUT_DATE 
IS 'FRZ_INPUT_DATE - ';

COMMENT ON COLUMN frz_pfsa_maint_work.FRZ_INPUT_DATE_ID 
IS 'FRZ_INPUT_DATE_ID - ';

COMMENT ON COLUMN frz_pfsa_maint_work.rec_frz_flag 
IS 'REC_FRZ_FLAG - Flag indicating if the record is frozen or not.  Values: N - Not frozen, Y - Frozen';

COMMENT ON COLUMN frz_pfsa_maint_work.frz_date 
IS 'FRZ_DATE - Additional control for REC_FRZ_FLAG indicating when the record was frozen.';

COMMENT ON COLUMN frz_pfsa_maint_work.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_maint_work.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_maint_work.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_work.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_maint_work.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_maint_work.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_maint_work.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_maint_work.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN frz_pfsa_maint_work.DELETE_by 
IS 'DELETE_BY - Reports who deleted the record.';

COMMENT ON COLUMN frz_pfsa_maint_work.HIDDEN_by 
IS 'HIDDEN_BY - Reports who last hide the record.';

/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_pfsa_maint_work'); 
*/
/*----- Check to see if the table column comments are present -----*/
/*
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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_maint_work') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_maint_work') 
ORDER BY b.column_id; 
*/
/*----- Look-up field description from master LIDB table -----*/
/*
SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%UIC%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%UIC%'); 
*/   

