/*----- Sequence  -----*/

DROP SEQUENCE frz_pfsa_maint_items_seq;

CREATE SEQUENCE frz_pfsa_maint_items_seq
    START WITH 1
    MINVALUE   1
--    MAXVALUE   9999999
    NOCYCLE
    NOCACHE
    NOORDER; 

/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_maint_items 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_maint_items.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 14 April 2008 
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
-- 14APR08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

DROP TABLE frz_pfsa_maint_items;
    
CREATE TABLE frz_pfsa_maint_items
(
    rec_id                           NUMBER         NOT NULL, 
    source_rec_id                    NUMBER         DEFAULT  0, 
---    
    pba_id                           NUMBER         NOT NULL, 
    phyiscal_item_id                 NUMBER         DEFAULT  0,
    phyiscal_item_sn_id              NUMBER         DEFAULT  0,
    force_unit_id                    NUMBER         DEFAULT  0,
    mimosa_item_sn_id                VARCHAR2(8)    DEFAULT '00000000',
--    
    MAINT_EV_ID                      VARCHAR2(40)   NOT NULL,
    MAINT_TASK_ID                    VARCHAR2(50)   NOT NULL,
    MAINT_ITEM_ID                    VARCHAR2(37)   NOT NULL,
    CAGE_CD                          VARCHAR2(5),
    PART_NUM                         VARCHAR2(32),
    NIIN                             VARCHAR2(9),
    PART_SN                          VARCHAR2(32),
    NUM_ITEMS                        NUMBER,
    CNTLD_EXCHNG                     VARCHAR2(1),
    REMOVED                          VARCHAR2(1),
    FAILURE                          VARCHAR2(1),
    HEIR_ID                          VARCHAR2(20),
    PRIORITY                         NUMBER, 
--     
    STATUS                           VARCHAR2(1), 
    LST_UPDT                         DATE,
    UPDT_BY                          VARCHAR2(30), 
--
    rec_frz_flag                     VARCHAR2(1)         DEFAULT 'N' , 
--    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    frz_date                         DATE                DEFAULT '31-DEC-2099' ,
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
            INITIAL          8M
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

COMMENT ON TABLE frz_pfsa_maint_items 
IS 'FRZ_PFSA_MAINT_ITEMS - This table documents all items used/consumed during a maintenance event';


COMMENT ON COLUMN frz_pfsa_maint_items.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_maint_items.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_maint_items.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_maint_items.phyiscal_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_items.phyiscal_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_items.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_items.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_maint_items.MAINT_EV_ID 
IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN frz_pfsa_maint_items.MAINT_TASK_ID 
IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN frz_pfsa_maint_items.MAINT_ITEM_ID 
IS 'MAINT_ITEM_ID - The identifier that when combined with the MAINT_EV_ID and MAINT_TASK_ID creates a unique maintenance task part id.';

COMMENT ON COLUMN frz_pfsa_maint_items.CAGE_CD 
IS 'COMMERCIAL AND GOVERNMENT ENTITY (CAGE) CODE - The Commercial and Government Entity (CAGE) Code is a five-character code assigned by the Defense Logistics Information Service (DLIS) to the design control activity or actual manufacturer of an item.';

COMMENT ON COLUMN frz_pfsa_maint_items.PART_NUM 
IS 'PART_NUM - PART NUMBER - This field may contain a 13-digit FSC/NIIN, ACVC, Manufacturers Control Number, or a part number of variable length.';

COMMENT ON COLUMN frz_pfsa_maint_items.NIIN 
IS 'NIIN - The NIIN of the repair part installed/consumable used during the maintenance event.';

COMMENT ON COLUMN frz_pfsa_maint_items.PART_SN 
IS 'PART_SN - The serial number of the repair part installed during the maintenance event.';

COMMENT ON COLUMN frz_pfsa_maint_items.NUM_ITEMS 
IS 'NUM_ITEMS - The number items with this NIIN used as part of the maintenance event and task.';

COMMENT ON COLUMN frz_pfsa_maint_items.CNTLD_EXCHNG 
IS 'CNTLD_EXCHNG - A flag indicating is controlled exchange item. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_items.REMOVED 
IS 'REMOVED - A flag indicating that the item was removed. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_items.FAILURE 
IS 'FAILURE - A flag indicating that the item failed. Values are F\T\U';

COMMENT ON COLUMN frz_pfsa_maint_items.HEIR_ID 
IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN frz_pfsa_maint_items.PRIORITY 
IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN frz_pfsa_maint_items.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN frz_pfsa_maint_items.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN frz_pfsa_maint_items.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_items.rec_frz_flag 
IS 'REC_FRZ_FLAG - Flag indicating if the record is frozen or not.  Values: N - Not frozen, Y - Frozen';

--COMMENT ON COLUMN frz_pfsa_maint_items.active_date 
--IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN frz_pfsa_maint_items.frz_date 
IS 'FRZ_DATE - Additional control for REC_FRZ_FLAG indicating when the record was frozen.';

COMMENT ON COLUMN frz_pfsa_maint_items.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_maint_items.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_maint_items.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_items.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_maint_items.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_maint_items.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_maint_items.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_maint_items.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_pfsa_maint_items'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_maint_items') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_maint_items') 
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

ALTER TABLE frz_pfsa_maint_items  
    DROP CONSTRAINT pk0_frz_pfsa_maint_items;        

ALTER TABLE frz_pfsa_maint_items  
    ADD CONSTRAINT pk0_frz_pfsa_maint_items 
    PRIMARY KEY 
    (
    rec_id
    );    


/*----- Non Foreign Key Constraints -----*/ 

ALTER TABLE frz_pfsa_equip_avail 
    ADD (
        CONSTRAINT PK1_frz_pfsa_maint_items
        UNIQUE 
            (
            MAINT_EV_ID, 
            MAINT_TASK_ID, 
            MAINT_ITEM_ID
            )
        LOGGING
        TABLESPACE ECPTBSNDX
        PCTFREE    10
        INITRANS   2
        MAXTRANS   255
        STORAGE    (
                    INITIAL          8M
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
        NOPARALLEL
        );

-- 
-- Foreign Key Constraints for Table frz_pfsa_maint_items 
-- 

ALTER TABLE frz_pfsa_maint_items 
    ADD (
        CONSTRAINT FK_ITEMS_TO_TASK 
        FOREIGN KEY 
            (
            MAINT_EV_ID, 
            MAINT_TASK_ID
            ) 
        REFERENCES frz_pfsa_maint_task 
            (
            MAINT_EV_ID,
            MAINT_TASK_ID
            ));

/*----- Constraints -----*/

ALTER TABLE frz_pfsa_maint_items  
    DROP CONSTRAINT ck_frz_pfsa_maint_items_act_fl;        

ALTER TABLE frz_pfsa_maint_items  
    ADD CONSTRAINT ck_frz_pfsa_maint_items_act_fl 
    CHECK (rec_frz_flag='N' OR rec_frz_flag='Y');

ALTER TABLE frz_pfsa_maint_items  
    DROP CONSTRAINT ck_frz_pfsa_maint_items_del_fl;        

ALTER TABLE frz_pfsa_maint_items  
    ADD CONSTRAINT ck_frz_pfsa_maint_items_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE frz_pfsa_maint_items  
    DROP CONSTRAINT ck_frz_pfsa_maint_items_hd_fl;       

ALTER TABLE frz_pfsa_maint_items  
    ADD CONSTRAINT ck_frz_pfsa_maint_items_hd_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE frz_pfsa_maint_items  
    DROP CONSTRAINT ck_frz_pfsa_maint_items_status;        

ALTER TABLE frz_pfsa_maint_items  
    ADD CONSTRAINT ck_frz_pfsa_maint_items_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Indexs -----*/

/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM frz_pfsa_maint_items FOR pfsaw.frz_pfsa_maint_items; 

/*----- Grants-----*/

GRANT SELECT ON frz_pfsa_maint_items TO LIW_BASIC; 

GRANT SELECT ON frz_pfsa_maint_items TO LIW_RESTRICTED; 

GRANT SELECT ON frz_pfsa_maint_items TO S_PFSAW; 

-- GRANT SELECT ON frz_pfsa_maint_items TO MD2L043; 

-- GRANT SELECT ON frz_pfsa_maint_items TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON frz_pfsa_maint_items TO S_PBUSE; 

-- GRANT SELECT ON frz_pfsa_maint_items TO S_WEBPROP; 

GRANT SELECT ON frz_pfsa_maint_items TO C_PFSAW; 

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

    SELECT 
    DISTINCT niin 
    FROM   pfsa_maint_items; 
    
    SELECT ir.pba_id, 
           pme.sys_ei_niin, pme.maint_ev_id AS pme_maint_ev_id, 
           pmt.maint_task_id AS pmt_maint_task_id, 
           pmi.*   
    FROM   pfsa_maint_items pmi, 
           pfsa_maint_event pme, 
           pfsa_maint_task pmt, 
           pfsa_pba_items_ref ir 
    WHERE  pme.sys_ei_niin = ir.item_type_value
        AND pme.maint_ev_id = pmt.maint_ev_id 
        AND pmt.maint_ev_id = pmi.maint_ev_id 
        AND pmt.maint_task_id = pmi.maint_task_id;
    
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

SELECT * FROM frz_pfsa_maint_items; 

*/
