/*----- Sequence  -----*/

DROP SEQUENCE frz_pfsa_maint_task_seq;

CREATE SEQUENCE frz_pfsa_maint_task_seq
    START WITH 1
    MINVALUE   1
--    MAXVALUE   9999999 
    NOCYCLE
    NOCACHE
    NOORDER; 

DROP TABLE frz_pfsa_maint_task;
    
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_maint_event 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_maint_event.sql 
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
--
--
CREATE TABLE frz_pfsa_maint_task 
(
    rec_id                           NUMBER              NOT NULL, 
    source_rec_id                    NUMBER              DEFAULT  0, 
---    
    pba_id                           NUMBER              NOT NULL, 
    phyiscal_item_id                 NUMBER              DEFAULT  0,
    phyiscal_item_sn_id              NUMBER              DEFAULT  0,
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
    hidden_date                      DATE                DEFAULT '01-JAN-1900'  
)
TABLESPACE ECPTBS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2M
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

COMMENT ON TABLE frz_pfsa_maint_task  
IS 'FRZ_PFSA_MAINT_TASK - This table documents the tasks which occur during a maintenance event.  Work not attributable to a task is aggregated';


COMMENT ON COLUMN frz_pfsa_maint_task.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_maint_task.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_maint_task.phyiscal_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task.phyiscal_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_task.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_maint_task.MAINT_EV_ID 
IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN frz_pfsa_maint_task.MAINT_TASK_ID 
IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN frz_pfsa_maint_task.ELAPSED_TSK_WK_TM 
IS 'ELAPSED_TSK_WK_TM - The elapsed task work time.';

COMMENT ON COLUMN frz_pfsa_maint_task.ELAPSED_PART_WT_TM 
IS 'ELAPSED_PART_WT_TM - The elapsed task wait time.';

COMMENT ON COLUMN frz_pfsa_maint_task.TSK_BEGIN 
IS 'TSK_BEGIN - The actual or estimated task start date\time.';

COMMENT ON COLUMN frz_pfsa_maint_task.TSK_END 
IS 'TSK_END - The actual or estimated task completion date\time.';

COMMENT ON COLUMN frz_pfsa_maint_task.INSPECT_TSK 
IS 'INSPECT_TSK - Flag indicating if this was an inspection task. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_task.TSK_WAS_DEF 
IS 'TSK_WAS_DEF - Flag indicating if this task was the result of a defect. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_task.SCHED_UNSCHED 
IS 'SCHED_UNSCHED - Flag indicating if this task was a scheduled or un-scheduled. Values are ?\S\U';

COMMENT ON COLUMN frz_pfsa_maint_task.ESSENTIAL 
IS 'ESSENTIAL RECORD FLAG - A flag for indicating that essential maintenance was required. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_task.HEIR_ID 
IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN frz_pfsa_maint_task.PRIORITY 
IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN frz_pfsa_maint_task.STATUS 
IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN frz_pfsa_maint_task.LST_UPDT 
IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN frz_pfsa_maint_task.UPDT_BY 
IS 'UPDT_BY - Who/what updated the record.';

--COMMENT ON COLUMN frz_pfsa_maint_task.active_flag 
--IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

--COMMENT ON COLUMN frz_pfsa_maint_task.active_date 
--IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

--COMMENT ON COLUMN frz_pfsa_maint_task.inactive_date 
--IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN frz_pfsa_maint_task.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_maint_task.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_maint_task.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_task.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_maint_task.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_maint_task.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_maint_task.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_maint_task.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_pfsa_maint_task'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_maint_task') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_maint_task') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%UIC%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%UIC%'); 
   

/*----- Constraints - Primary Key -----*/ 

CREATE UNIQUE INDEX pk_frz_pfsa_maint_task  
    ON frz_pfsa_maint_task 
        (
        MAINT_EV_ID, 
        MAINT_TASK_ID
        )
    LOGGING
    TABLESPACE ECPTBSNDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5464K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    NOPARALLEL;
    
    
/*----- Non Foreign Key Constraints -----*/ 

ALTER TABLE frz_pfsa_maint_task  
    DROP CONSTRAINT idu_frz_pfsa_maint_event;        

ALTER TABLE frz_pfsa_maint_task  
    ADD CONSTRAINT idu_frz_pfsa_maint_event 
    UNIQUE 
    (
    rec_id
    );    


/*----- Non Foreign Key Constraints -----*/ 



/*----- Foreign Key Constraints -----*/ 

ALTER TABLE frz_pfsa_maint_task  
    ADD (   
        CONSTRAINT fk_frz_maint_ev_to_tsk 
        FOREIGN KEY 
            (
            maint_ev_id
            ) 
        REFERENCES frz_pfsa_maint_event 
            (
            maint_ev_id
            )
        );
/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM frz_pfsa_maint_task FOR pfsawh.pfsawh_force_unit_dim; 

/*----- Grants-----*/

GRANT SELECT ON frz_pfsa_maint_task TO LIW_BASIC; 

GRANT SELECT ON frz_pfsa_maint_task TO LIW_RESTRICTED; 

GRANT SELECT ON frz_pfsa_maint_task TO S_PFSAW; 

-- GRANT SELECT ON frz_pfsa_maint_task TO MD2L043; 

-- GRANT SELECT ON frz_pfsa_maint_task TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON frz_pfsa_maint_task TO S_PBUSE; 

-- GRANT SELECT ON frz_pfsa_maint_task TO S_WEBPROP; 

GRANT SELECT ON frz_pfsa_maint_task TO C_PFSAW; 


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

    SELECT pmt.*, 
        '|', pme.*
    FROM   pfsa_maint_task pmt, 
           pfsa_maint_task pme 
    WHERE pmt.maint_ev_id = pme.maint_ev_id; 
    
    SELECT ir.pba_id, pme.sys_ei_niin, pmt.* 
    FROM   pfsa_maint_task pmt, 
           pfsa_maint_event pme, 
           pfsa_pba_items_ref ir 
    WHERE  pmt.maint_ev_id = pme.maint_ev_id 
        AND pme.sys_ei_niin = ir.item_type_value;
    
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

SELECT * FROM frz_pfsa_maint_task; 

*/
