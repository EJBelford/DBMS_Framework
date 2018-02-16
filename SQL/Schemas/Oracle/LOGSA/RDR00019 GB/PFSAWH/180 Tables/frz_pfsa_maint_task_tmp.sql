/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_maint_task_tmp 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_maint_task_tmp.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 11 April 2008 
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
-- 11APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Create table  -----*/

-- DROP TABLE frz_pfsa_maint_task_tmp;
    
CREATE TABLE frz_pfsa_maint_task_tmp 
(
    rec_id                           NUMBER              NOT NULL, 
    source_rec_id                    NUMBER              DEFAULT  0, 
---    
    pba_id                           NUMBER              NOT NULL, 
    physical_item_id                 NUMBER              DEFAULT  0,
    physical_item_sn_id              NUMBER              DEFAULT  0,
    force_unit_id                    NUMBER              DEFAULT  0,
    mimosa_item_sn_id                VARCHAR2(8)         DEFAULT '00000000',
--    
    MAINT_EV_ID                      VARCHAR2(40)        NOT NULL,
    MAINT_TASK_ID                    VARCHAR2(50)        NOT NULL,
    ELAPSED_TSK_WK_TM                NUMBER,
    ELAPSED_PART_WT_TM               NUMBER,
    TSK_BEGIN                        DATE,
    TSK_END                          DATE,
    INSPECT_TSK                      VARCHAR2(1),
    TSK_WAS_DEF                      VARCHAR2(1),
    SCHED_UNSCHED                    VARCHAR2(1),
    ESSENTIAL                        VARCHAR2(1),
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
            INITIAL          512K
            NEXT             256K
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

COMMENT ON TABLE frz_pfsa_maint_task_tmp  
IS 'frz_pfsa_maint_task_tmp - This table documents the tasks which occur during a maintenance event.  Work not attributable to a task is aggregated';


COMMENT ON COLUMN frz_pfsa_maint_task_tmp.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_maint_task_tmp.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.MAINT_EV_ID 
IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.MAINT_TASK_ID 
IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.ELAPSED_TSK_WK_TM 
IS 'ELAPSED_TSK_WK_TM - The elapsed task work time.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.ELAPSED_PART_WT_TM 
IS 'ELAPSED_PART_WT_TM - The elapsed task wait time.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.TSK_BEGIN 
IS 'TSK_BEGIN - The actual or estimated task start date\time.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.TSK_END 
IS 'TSK_END - The actual or estimated task completion date\time.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.INSPECT_TSK 
IS 'INSPECT_TSK - Flag indicating if this was an inspection task. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.TSK_WAS_DEF 
IS 'TSK_WAS_DEF - Flag indicating if this task was the result of a defect. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.SCHED_UNSCHED 
IS 'SCHED_UNSCHED - Flag indicating if this task was a scheduled or un-scheduled. Values are ?\S\U';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.ESSENTIAL 
IS 'ESSENTIAL RECORD FLAG - A flag for indicating that essential maintenance was required. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.HEIR_ID 
IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.PRIORITY 
IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.STATUS 
IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.LST_UPDT 
IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.UPDT_BY 
IS 'UPDT_BY - Who/what updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.FRZ_INPUT_DATE 
IS 'FRZ_INPUT_DATE - ';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.FRZ_INPUT_DATE_ID 
IS 'FRZ_INPUT_DATE_ID - ';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.rec_frz_flag 
IS 'REC_FRZ_FLAG - Flag indicating if the record is frozen or not.  Values: N - Not frozen, Y - Frozen';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.frz_date 
IS 'FRZ_DATE - Additional control for REC_FRZ_FLAG indicating when the record was frozen.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.DELETE_by 
IS 'DELETE_BY - Reports who deleted the record.';

COMMENT ON COLUMN frz_pfsa_maint_task_tmp.HIDDEN_by 
IS 'HIDDEN_BY - Reports who last hide the record.';

/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_pfsa_maint_task_tmp'); 
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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_maint_task_tmp') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_maint_task_tmp') 
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

