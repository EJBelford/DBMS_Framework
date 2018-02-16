DROP TABLE gb_pfsawh_maint_itm_prt_fact;
    
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsawh_maint_itm_prt_fact
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_maint_itm_prt_fact.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: February 25, 2008 
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
-- 25FEB08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_maint_itm_prt_fact 
(
    rec_id                           NUMBER           NOT NULL ,
--
    tsk_end_date_id                  NUMBER,
    tsk_end_time_id                  NUMBER,
    physical_item_id                 NUMBER           NOT NULL ,        --    pfsa_maint_event.sys_ei_niin  
    physical_item_sn_id              NUMBER           NOT NULL ,        --    pfsa_maint_event.sys_ei_sn 
--    pfsa_maint_event.maint_item_niin                  VARCHAR2(9 BYTE),
    mimosa_item_sn_id                VARCHAR2(8)      DEFAULT    '00000000' ,        
    force_unit_id                    NUMBER           DEFAULT 0 ,
    pba_id                           NUMBER           DEFAULT    1000000 ,
--
    item_comp_id                     NUMBER           DEFAULT    '-1' ,        
--    pfsa_maint_items.niin                             VARCHAR2(9),
    item_part_id                     NUMBER           DEFAULT    '-1' ,        
--    pfsa_maint_event.maint_item_sn                    VARCHAR2(32 BYTE),
    item_comp_sn                     NUMBER           DEFAULT    '-1' ,        
-- 
    part_num                         VARCHAR2(32),
    part_sn                          VARCHAR2(32),
--    num_items                        NUMBER,
    part_num_used                    NUMBER,
    part_cntld_exchng_flag           VARCHAR2(1),
    part_removed_flag                VARCHAR2(1),
    part_cage_cd                     VARCHAR2(5),
--
    tsk_elapsed_part_wt_tm           NUMBER,
    tsk_was_def_flag                 VARCHAR2(1 BYTE),
--    pfsa_maint_task.sched_unsched       VARCHAR2(1 BYTE),
    tsk_sched_flag                   VARCHAR2(1 BYTE),
--
    status                           VARCHAR2(1)      DEFAULT    'N' ,
    updt_by                          VARCHAR2(30)     DEFAULT    USER ,
    lst_updt                         DATE             DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)      DEFAULT    'I' , 
    active_date                      DATE             DEFAULT    '01-JAN-1900' , 
    inactive_date                    DATE             DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)     DEFAULT    USER , 
    insert_date                      DATE             DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)     NULL ,
    update_date                      DATE             DEFAULT    '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    delete_date                      DATE             DEFAULT    '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)      DEFAULT    'Y' ,
    hidden_date                      DATE             DEFAULT    '01-JAN-1900' ,
CONSTRAINT pk_gb_pfsawh_itm_prt_fact PRIMARY KEY 
    (
    rec_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsawh_maint_itm_prt_fact;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_maint_itm_prt_fact 
    ON pfsawh.gb_pfsawh_maint_itm_prt_fact
    (
    physical_item_id,        
    physical_item_sn_id,        
    tsk_end_date_id,
    tsk_end_time_id, 
    item_comp_id,        
    item_part_id         
    );

/*----- Foreign Key -----*/
 
ALTER TABLE gb_pfsawh_maint_itm_prt_fact  
    DROP CONSTRAINT fk_pfsawh_maint_itm_prt_id_itm;        

ALTER TABLE gb_pfsawh_maint_itm_prt_fact  
    ADD CONSTRAINT fk_pfsawh_maint_itm_prt_id_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);
 
ALTER TABLE gb_pfsawh_maint_itm_prt_fact  
    DROP CONSTRAINT fk_pfsawh_mnt_itm_prt_id_itmsn;        

ALTER TABLE gb_pfsawh_maint_itm_prt_fact  
    ADD CONSTRAINT fk_pfsawh_mnt_itm_prt_id_itmsn
    FOREIGN KEY 
        (
--        physical_item_id, 
        physical_item_sn_id
        ) 
    REFERENCES gb_pfsawh_item_sn_dim
        (
--        physical_item_id, 
        physical_item_sn_id
        );
 
/*----- Constraints -----*/

ALTER TABLE pfsawh.gb_pfsawh_maint_itm_prt_fact   
    DROP CONSTRAINT ck_maint_itm_prt_fact_status;        

ALTER TABLE pfsawh.gb_pfsawh_maint_itm_prt_fact  
    ADD CONSTRAINT ck_maint_itm_prt_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_maint_itm_prt_fact_seq; 

CREATE SEQUENCE pfsawh_maint_itm_prt_fact_seq
    START WITH 1
    MAXVALUE 9999999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_maint_itm_prt_fact 
IS 'PFSAWH_MAINT_ITM_PRT_FACT - This table serves as the daily/transactional fact for a particular item/serial number combination.'; 


COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.rec_id
IS 'REC_ID - Sequence/identity for dimension/fact table.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_end_date_id 
IS 'TSK_END_DATE_ID - Foreign key to the PFSAWH_DATE_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_end_time_id 
IS 'TSK_END_TIME_ID - Foreign key to the PFSAWH_DATE_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key to the PFSAWH_ITEM_DIM table.'; 
     
COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key to the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.item_comp_id 
IS 'ITEM_COMP_ID - Foreign key to the PFSAWH_ITEM_DIM table.';   

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.item_part_id 
IS 'ITEM_PART_ID - Foreign key to the PFSAWH_ITEM_DIM table.';     

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.item_comp_sn 
IS 'ITEM_COMP_SN - ';   

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.part_num 
IS 'PART_NUM - PART NUMBER - This field may contain a 13-digit FSC/NIIN, ACVC, Manufacturers Control Number, or a part number of variable length.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.part_sn 
IS 'PART_SN - The serial number of the repair part INSTALLED???? during the maintenance event.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.part_num_used 
IS 'PART_NUM_USED - NUM_ITEMS - The number items with this NIIN used as part of the maintenance event and task.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.part_cntld_exchng_flag 
IS 'PART_CNTLD_EXCHNG_FLAG - CNTLD_EXCHNG - A flag indicating is controlled exchange item. Values are F\T\U'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.part_removed_flag 
IS 'PART_REMOVED_FLAG - REMOVED - A flag indicating that the item was removed. Values are F\T\U'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.part_cage_cd 
IS 'PART_CAGE_CD - COMMERCIAL AND GOVERNMENT ENTITY (CAGE) CODE - The Commercial and Government Entity (CAGE) Code is a five-character code assigned by the Defense Logistics Information Service (DLIS) to the design control activity or actual manufacturer of an item.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_elapsed_part_wt_tm 
IS 'TSK_ELAPSED_PART_WT_TM - ELAPSED_PART_WT_TM - The elapsed task wait time.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_end_date_id 
IS 'TSK_END_DATE_ID - Foreign key of the PFSAWH_DATE_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_end_time_id 
IS 'TSK_END_TIME_ID - Foreign key of the PFSAWH_TIME_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_was_def_flag 
IS 'TSK_WAS_DEF_FLAG - Flag indicating if this task was the result of a defect.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.tsk_sched_flag 
IS 'TSK_SCHED_FLAG - SCHED_UNSCHED - Flag indicating if this task was a scheduled or un-scheduled. Values are ?\S\U'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_prt_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT   table_name, comments 
FROM     user_tab_comments 
WHERE    table_name = UPPER('gb_pfsawh_maint_itm_prt_fact'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_maint_itm_prt_fact') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_maint_itm_prt_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%amac%')
ORDER BY a.col_name; 

SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%ITEM_SYS_EI_ID%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

BEGIN 

    INSERT 
    INTO   gb_pfsawh_maint_itm_prt_fact 
        (
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item__id, 
        physical_item_sn_id, 
        item_comp_id, 
        item_part_id, 
        part_num, 
        part_sn, 
        part_num_used, 
        part_cntld_exchng_flag, 
        part_removed_flag, 
        part_cage_cd, 
        tsk_elapsed_part_wt_tm, 
        tsk_was_def_flag, 
        tsk_sched_flag 
        )
    SELECT CASE 
               WHEN tk.tsk_end <> NULL THEN fn_pfsawh_get_date_dim_id(tk.tsk_end)   
               WHEN ev.dt_maint_ev_cmpl <> NULL THEN fn_pfsawh_get_date_dim_id(ev.dt_maint_ev_cmpl) 
               ELSE 10000 
           END CASE, 
           NVL(tk.tsk_end, NVL(ev.dt_maint_ev_cmpl, '01-JAN-1950')) AS tsk_end_time_id, 
           fn_pfsawh_get_item_dim_id(NVL(ev.sys_ei_niin, '000000000')) AS physical_item_id,  
           NVL(ev.sys_ei_sn, 'UNKNOWN') AS physical_item_sn_id, 
           fn_pfsawh_get_item_dim_id(NVL(ev.maint_item_niin, '000000000')) AS item_comp_id,  
           fn_pfsawh_get_item_dim_id(NVL(it.niin, '000000000')) AS item_part_id, 
           NVL(it.part_num, 'UNKNOWN') AS part_num, 
           NVL(it.part_sn, 'UNKNOWN') AS part_sn, 
           NVL(it.num_items, 1) AS part_num_used,  
           NVL(it.cntld_exchng, 'U') AS part_cntld_exchng_flag, 
           NVL(it.removed, 'U') AS part_removed_flag, 
           NVL(it.cage_cd, '-1') AS part_cage_cd, 
           NVL(tk.elapsed_part_wt_tm, 0), 
           NVL(tk.tsk_was_def, 'U'), 
           NVL(tk.sched_unsched, '?')    
--           , '|', 
--           it.*, 
--           tk.*, 
--           ev.* 
    FROM   pfsa_maint_event@pfsawh.lidbdev ev, 
           pfsa_maint_task@pfsawh.lidbdev tk,
           pfsa_maint_items@pfsawh.lidbdev it 
    WHERE  ev.maint_ev_id = tk.maint_ev_id
        AND ev.maint_ev_id = it.maint_ev_id 
        AND tk.maint_task_id = it.maint_task_id
    ORDER BY ev.sys_ei_niin, ev.sys_ei_sn, tk.tsk_end DESC, ev.maint_item_niin;  
        
END;

/* 

SELECT * FROM gb_pfsawh_maint_itm_prt_fact; 

*/