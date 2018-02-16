DROP TABLE gb_pfsawh_maint_itm_wrk_fact;
    
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: gb_pfsawh_maint_itm_wrk_fact
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_maint_itm_wrk_fact.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: February 29, 2008 
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
CREATE TABLE gb_pfsawh_maint_itm_wrk_fact 
(
    rec_id                           NUMBER              NOT NULL ,
--
    tsk_begin_date_id                NUMBER,
    tsk_begin_time_id                NUMBER,
    tsk_end_date_id                  NUMBER,
    tsk_end_time_id                  NUMBER,
    physical_item_id                 NUMBER              NOT NULL ,        
--    pfsa_maint_event.sys_ei_sn                        VARCHAR2(32),
--
    physical_item_sn_id              NUMBER              NOT NULL ,    
    MAINT_EV_ID_a                    VARCHAR2(40)        NOT NULL ,
    MAINT_EV_ID_b                    VARCHAR2(40)        NOT NULL ,
    MAINT_TASK_ID                    VARCHAR2(50)        NOT NULL ,
    MAINT_WORK_ID                    VARCHAR2(12)        NOT NULL ,
--    pfsa_maint_event.maint_item_niin                  VARCHAR2(9),
    maint_org                        VARCHAR2(32),
    maint_uic                        VARCHAR2(6),
    maint_lvl_cd                     VARCHAR2(1),
    elapsed_tsk_wk_tm                NUMBER,
    inspect_tsk                      VARCHAR2(1),
    essential_tsk                    VARCHAR2(1), 
--    
    maint_work_mh                    NUMBER,
    wrk_mil_civ_kon                  VARCHAR2(1),
    wrk_mos                          VARCHAR2(10),
    wrk_spec_person                  VARCHAR2(20),
    wrk_repair                       VARCHAR2(1),
    wrk_mos_sent                     VARCHAR2(10),
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' ,
CONSTRAINT pk_pfsawh_maint_itm_wrk_fact PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_maint_itm_wrk_fac;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_maint_itm_wrk_fac 
    ON gb_pfsawh_maint_itm_wrk_fact
    (
    tsk_begin_date_id, 
    tsk_begin_time_id, 
    tsk_end_date_id, 
    tsk_end_time_id, 
    physical_item_id, 
    physical_item_sn_id, 
    maint_ev_id_a, 
    maint_ev_id_b, 
    maint_task_id, 
    maint_work_id 
    );

DROP INDEX ixu_pfsawh_maint_itm_wrk_fac;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_maint_item_sn_fac 
    ON gb_pfsawh_maint_itm_wrk_fact
    (
    physical_item_id, 
    physical_item_sn_id  
    );

/*----- Foreign Key -----*/
 
ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT fk_pfsawh_maint_itm_wrk_id_itm;        

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT fk_pfsawh_maint_itm_wrk_id_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);
 
ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT fk_pfsawh_mnt_itm_wrk_id_itmsn;        

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT fk_pfsawh_mnt_itm_wrk_id_itmsn
    FOREIGN KEY (physical_item_id, physical_item_sn_id) 
    REFERENCES gb_pfsawh_item_sn_dim(physical_item_id, physical_item_sn_id);
 
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_act_fl;        

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_del_fl;        

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_hid_fl;       

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_status;        

ALTER TABLE gb_pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_maint_itm_wrk_fact_seq;

CREATE SEQUENCE pfsawh_maint_itm_wrk_fact_seq
    START WITH 1000000
    MAXVALUE   9999999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create the Trigger now -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_maint_itm_wrk_fact 
IS 'PFSAWH_MAINT_ITM_WRK_FACT - '; 


COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.rec_id 
IS 'REC_ID - Sequence/identity for dimension/fact table.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.tsk_begin_date_id 
IS 'TSK_BEGIN_DATE_ID - Foreign key to the PFSAWH_DATE_DIM records.';

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.tsk_begin_time_id 
IS 'TSK_BEGIN_TIME_ID - Foreign key of the PFSAWH_TIME_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.tsk_end_date_id 
IS 'TSK_END_DATE_ID - Foreign key to the PFSAWH_DATE_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.tsk_end_time_id 
IS 'TSK_END_TIME_ID - Foreign key of the PFSAWH_TIME_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.physical_item_id 
IS 'ITEM_SYS_EI_ID - Foreign key to the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.physical_item_sn_id 
IS 'ITEM_SN_EI_ID - Foreign key to the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_ev_id_a 
IS 'MAINT_EV_ID_A - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_ev_id_b 
IS 'MAINT_EV_ID_B - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_task_id 
IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_work_id 
IS 'MAINT_WORK_ID - The identifier that when combined with the MAINT_EV_ID and MAINT_TASK_ID creates a unique maintenance task work id.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_org 
IS 'MAINT_ORG - The organization accomplishing the maintenance event.  If a UIC, the value will match the maint_uic.  Field used to identify manufacturer/non-UIC identified contractor maintenance.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_uic 
IS 'MAINT_UIC - The UIC provided by the STAMIS system for the Maintenance Event.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_lvl_cd 
IS 'MAINT_LVL_CD - The maint lvl of the org.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.elapsed_tsk_wk_tm 
IS 'ELAPSED_TSK_WK_TM - The total elapsed time during the maintenance event when work was being performed, when available from the data source.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.inspect_tsk 
IS 'INSPECT_TSK - Flag indicating if this was an inspection task. Values are F\T\U'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.essential_tsk 
IS 'ESSENTIAL_TSK - A flag for records that are essential. Values are ?\F\T\U\Y'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.maint_work_mh 
IS 'MAINT_WORK_MH - The number of hours the maintenance work took to complete.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.wrk_mil_civ_kon 
IS 'WRK_MIL_CIV_KON - The code for the type of person doing the maintenance, Civilian, Kontractor, Military or Unknown.  Values are C\K\M\U'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.wrk_mos 
IS 'WRK_MOS - OCCUPATIONAL SPECIALTY CODE - The code that represents the Military Occupational Specialty (MOS) of the person performing the maintenance action.'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.wrk_spec_person 
IS 'WRK_SPEC_PERSON - Repair specialist????? .'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.wrk_repair 
IS 'WRK_REPAIR - Item was repaired.  Values should be Y - Yes, N - No, ? - Unknown'; 

COMMENT ON COLUMN gb_pfsawh_maint_itm_wrk_fact.wrk_mos_sent 
IS 'WRK_MOS_SENT - The .'; 

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

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_maint_itm_wrk_fact'); 

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
    ON  b.table_name  = UPPER('gb_pfsawh_maint_itm_wrk_fact') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_maint_itm_wrk_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
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
    INTO   gb_pfsawh_maint_itm_wrk_fact 
        (
        tsk_begin_date_id, 
        tsk_begin_time_id, 
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item_id, 
        physical_item_sn_id, 
        maint_ev_id_a, 
        maint_ev_id_b, 
        maint_task_id, 
        maint_work_id, 
        maint_org, 
        maint_uic, 
        maint_lvl_cd, 
        elapsed_tsk_wk_tm, 
        inspect_tsk, 
        essential_tsk, 
        maint_work_mh, 
        wrk_mil_civ_kon, 
        wrk_mos, 
        wrk_spec_person, 
        wrk_repair, 
        wrk_mos_sent   
        )
    SELECT NVL(tk.tsk_begin, NVL(ev.dt_maint_ev_est,  '01-JAN-1900')) AS tsk_begin_date_id, 
           NVL(tk.tsk_begin, NVL(ev.dt_maint_ev_est,  '01-JAN-1900')) AS tsk_begin_time_id, 
           NVL(tk.tsk_end,   NVL(ev.dt_maint_ev_cmpl, '01-JAN-1900')) AS tsk_end_date_id, 
           NVL(tk.tsk_end,   NVL(ev.dt_maint_ev_cmpl, '01-JAN-1900')) AS tsk_end_time_id, 
           fn_pfsawh_get_item_dim_id(NVL(ev.sys_ei_niin, '000000000')) AS item_sys_ei_id,  
           NVL(ev.sys_ei_sn, 'UNKNOWN') AS item_sn_ei_id, 
           SUBSTR(ev.maint_ev_id, 1, INSTR(ev.maint_ev_id, '|')-1) AS maint_ev_id_a, 
           SUBSTR(ev.maint_ev_id, INSTR(ev.maint_ev_id, '|')+1, LENGTH(ev.maint_ev_id)) AS maint_ev_id_b, 
           tk.maint_task_id, 
           wk.maint_work_id, 
           ev.maint_org, 
           ev.maint_uic, 
           ev.maint_lvl_cd, 
           NVL(tk.elapsed_tsk_wk_tm, 0), 
           NVL(tk.inspect_tsk, 'U'), 
           NVL(tk.essential, 'U'), 
           NVL(wk.maint_work_mh, ''), 
           NVL(wk.mil_civ_kon, 'U'), 
           NVL(wk.mos, 'UNK'), 
           NVL(wk.spec_person, 'UNKNOWN'), 
           NVL(wk.repair, 'U'), 
           NVL(wk.mos_sent, 'UNK')    
--           , '|', 
--           wk.*, tk.*, ev.* 
    FROM   pfsa_maint_event@pfsawh.lidbdev ev, 
           pfsa_maint_task@pfsawh.lidbdev tk,
           pfsa_maint_work@pfsawh.lidbdev wk 
    WHERE  ev.maint_ev_id = tk.maint_ev_id
        AND ev.maint_ev_id = wk.maint_ev_id 
        AND tk.maint_task_id = wk.maint_task_id
    ORDER BY ev.sys_ei_niin, ev.sys_ei_sn, tk.tsk_end DESC, ev.maint_item_niin;  
        
END;

/* 

SELECT * FROM gb_pfsawh_maint_itm_wrk_fact; 

*/

/*
--
-- PFSA_MAINT_EVENT  (Table) 
--
CREATE TABLE PFSAW.PFSA_MAINT_EVENT
(
    MAINT_EV_ID           VARCHAR2(40 BYTE)             NOT NULL,
    MAINT_ORG             VARCHAR2(32 BYTE),
    MAINT_UIC             VARCHAR2(6 BYTE),
    MAINT_LVL_CD          VARCHAR2(1 BYTE),
    MAINT_ITEM            VARCHAR2(37 BYTE),
    MAINT_ITEM_NIIN       VARCHAR2(9 BYTE),
    MAINT_ITEM_SN         VARCHAR2(32 BYTE),
    NUM_MAINT_ITEM        NUMBER,
    SYS_EI_NIIN           VARCHAR2(9 BYTE),
    SYS_EI_SN             VARCHAR2(32 BYTE),
    NUM_MI_NRTS           NUMBER,
    NUM_MI_RPRD           NUMBER,
    NUM_MI_CNDMD          NUMBER,
    NUM_MI_NEOF           NUMBER,
    DT_MAINT_EV_EST       DATE,
    DT_MAINT_EV_CMPL      DATE,
    SYS_EI_NMCM           VARCHAR2(1 BYTE),
    PHASE_EV              VARCHAR2(1 BYTE), 
    SOF_EV                VARCHAR2(1 BYTE),
    ASAM_EV               VARCHAR2(1 BYTE),
    MWO_EV                VARCHAR2(1 BYTE),
    ELAPSED_ME_WK_TM      NUMBER,
    SOURCE_ID             VARCHAR2(20 BYTE),
    HEIR_ID               VARCHAR2(20 BYTE),
    PRIORITY              NUMBER,
    CUST_ORG              VARCHAR2(32 BYTE),
    CUST_UIC              VARCHAR2(6 BYTE), 
--
    STATUS_EV             VARCHAR2(1 BYTE),
    LST_UPDT_EV           DATE,
    UPDT_BY_EV            VARCHAR2(30 BYTE),
----- PFSA_MAINT_TASK -----
    MAINT_EV_ID_TSK       VARCHAR2(40 BYTE)             NOT NULL,
    MAINT_TASK_ID         VARCHAR2(50 BYTE)             NOT NULL,
    ELAPSED_TSK_WK_TM     NUMBER,
    ELAPSED_PART_WT_TM    NUMBER,
    TSK_BEGIN             DATE,
    TSK_END               DATE,
    INSPECT_TSK           VARCHAR2(1 BYTE),
    TSK_WAS_DEF           VARCHAR2(1 BYTE),
    SCHED_UNSCHED_TSK     VARCHAR2(1 BYTE),
    ESSENTIAL_TSK         VARCHAR2(1 BYTE),
    HEIR_ID_TSK           VARCHAR2(20 BYTE),
    PRIORITY_TSK          NUMBER, 
--
    STATUS_TSK            VARCHAR2(1 BYTE),
    LST_UPDT_TSK          DATE,
    UPDT_BY_TSK           VARCHAR2(30 BYTE),
----- PFSA_MAINT_WORK -----
    MAINT_EV_ID_WRK       VARCHAR2(40 BYTE)              NOT NULL,
    MAINT_TASK_ID_WRK     VARCHAR2(50 BYTE)              NOT NULL,
    MAINT_WORK_ID         VARCHAR2(12 BYTE)              NOT NULL,
    MAINT_WORK_MH         NUMBER,
    MIL_CIV_KON_WRK       VARCHAR2(1 BYTE),
    MOS_WRK               VARCHAR2(10 BYTE),
    SPEC_PERSON_WRK       VARCHAR2(20 BYTE),
    REPAIR_WRK            VARCHAR2(1 BYTE),
    MOS_SENT_WRK          VARCHAR2(10 BYTE),
    HEIR_ID_WRK           VARCHAR2(20 BYTE),
    PRIORITY_WRK          NUMBER, 
--
    STATUS_WRK            VARCHAR2(1 BYTE),
    LST_UPDT_WRK          DATE,
    UPDT_BY_WRK           VARCHAR2(30 BYTE),
----- PFSA_MAINT_ITEMS ----- 
    MAINT_EV_ID_ITM       VARCHAR2(40 BYTE)              NOT NULL,
    MAINT_TASK_ID_ITM     VARCHAR2(50 BYTE)              NOT NULL,
    MAINT_ITEM_ID         VARCHAR2(37 BYTE)              NOT NULL,
    CAGE_CD_ITM           VARCHAR2(5 BYTE),
    PART_NUM_ITM          VARCHAR2(32 BYTE),
    NIIN_ITM              VARCHAR2(9 BYTE),
    PART_SN_ITM           VARCHAR2(32 BYTE),
    NUM_ITEMS_ITM         NUMBER,
    CNTLD_EXCHNG_ITM      VARCHAR2(1 BYTE),
    REMOVED_ITM           VARCHAR2(1 BYTE),
    FAILURE_ITM           VARCHAR2(1 BYTE),
    HEIR_ID_ITM           VARCHAR2(20 BYTE),
    PRIORITY_ITM          NUMBER,
--
    LST_UPDT_ITM          DATE,
    UPDT_BY_ITM           VARCHAR2(30 BYTE)
)
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1400K
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

COMMENT ON TABLE PFSAW.PFSA_MAINT_EVENT IS 'All maintenance data in the PFSA World is tied to a specific maintenance event.  This table documents all maintenance events.  Maintenance events are assumed to be tied to a specific instance of a system/end item.';

COMMENT ON COLUMN PFSAW.PFSA_MAINT_EVENT.MAINT_EV_ID IS 'A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN PFSAW.PFSA_MAINT_EVENT.MAINT_ORG IS 'The organization accomplishing the maintenance event.  If a UIC, the value will match the maint_uic.  Field used to identify manufacturer/non-UIC identified contractor maintenance';

COMMENT ON COLUMN PFSAW.PFSA_MAINT_EVENT.MAINT_LVL_CD IS 'The maint lvl of the org';


--
-- PK_PFSA_MAINT_EVENT  (Index) 
--

CREATE UNIQUE INDEX PFSAW.PK_PFSA_MAINT_EVENT ON PFSAW.PFSA_MAINT_EVENT
(MAINT_EV_ID)
LOGGING
TABLESPACE PFSANDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          4584K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSA_MAINT_EVENT 
-- 

ALTER TABLE PFSAW.PFSA_MAINT_EVENT ADD (
  CONSTRAINT PK_PFSA_MAINT_EVENT
 PRIMARY KEY
 (MAINT_EV_ID)
    USING INDEX 
    TABLESPACE PFSANDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          4584K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

----- PFSA_MAINT_TASK -----

--
-- PFSA_MAINT_TASK  (Table) 
--

CREATE TABLE PFSAW.PFSA_MAINT_TASK
(
  MAINT_EV_ID         VARCHAR2(40 BYTE)         NOT NULL,
  MAINT_TASK_ID       VARCHAR2(50 BYTE)         NOT NULL,
  ELAPSED_TSK_WK_TM   NUMBER,
  ELAPSED_PART_WT_TM  NUMBER,
  TSK_BEGIN           DATE,
  TSK_END             DATE,
  INSPECT_TSK         VARCHAR2(1 BYTE),
  TSK_WAS_DEF         VARCHAR2(1 BYTE),
  SCHED_UNSCHED       VARCHAR2(1 BYTE),
  ESSENTIAL           VARCHAR2(1 BYTE),
  STATUS              VARCHAR2(1 BYTE),
  LST_UPDT            DATE,
  UPDT_BY             VARCHAR2(30 BYTE),
  HEIR_ID             VARCHAR2(20 BYTE),
  PRIORITY            NUMBER
)
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1960K
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

COMMENT ON TABLE PFSAW.PFSA_MAINT_TASK IS 'This table documents the tasks which occur during a maintenance event.  Work not attributable to a task is aggregated';

--
-- PK_PFSA_MAINT_TASK  (Index) 
--
CREATE UNIQUE INDEX PFSAW.PK_PFSA_MAINT_TASK ON PFSAW.PFSA_MAINT_TASK
(MAINT_EV_ID, MAINT_TASK_ID)
LOGGING
TABLESPACE PFSANDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5368K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSA_MAINT_TASK 
-- 
ALTER TABLE PFSAW.PFSA_MAINT_TASK ADD (
  CONSTRAINT PK_PFSA_MAINT_TASK
 PRIMARY KEY
 (MAINT_EV_ID, MAINT_TASK_ID)
    USING INDEX 
    TABLESPACE PFSANDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5368K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

-- 
-- Foreign Key Constraints for Table PFSA_MAINT_TASK 
-- 
ALTER TABLE PFSAW.PFSA_MAINT_TASK ADD (
  CONSTRAINT FK_MAINT_EV_TO_TSK 
 FOREIGN KEY (MAINT_EV_ID) 
 REFERENCES PFSAW.PFSA_MAINT_EVENT (MAINT_EV_ID));

----- PFSA_MAINT_WORK -----

--
-- PFSA_MAINT_WORK  (Table) 
--
CREATE TABLE PFSAW.PFSA_MAINT_WORK
(
  MAINT_EV_ID    VARCHAR2(40 BYTE)              NOT NULL,
  MAINT_TASK_ID  VARCHAR2(50 BYTE)              NOT NULL,
  MAINT_WORK_ID  VARCHAR2(12 BYTE)              NOT NULL,
  MAINT_WORK_MH  NUMBER,
  MIL_CIV_KON    VARCHAR2(1 BYTE),
  MOS            VARCHAR2(10 BYTE),
  SPEC_PERSON    VARCHAR2(20 BYTE),
  REPAIR         VARCHAR2(1 BYTE),
  STATUS         VARCHAR2(1 BYTE),
  LST_UPDT       DATE,
  UPDT_BY        VARCHAR2(30 BYTE),
  MOS_SENT       VARCHAR2(10 BYTE),
  HEIR_ID        VARCHAR2(20 BYTE),
  PRIORITY       NUMBER
)
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2960K
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

COMMENT ON TABLE PFSAW.PFSA_MAINT_WORK IS 'This table documents all work performed by maintanenace personnel during a maintenance event.  Work not attributable to a specific person is aggregated';


--
-- PK_PFSA_METRIC_WORK  (Index) 
--
CREATE UNIQUE INDEX PFSAW.PK_PFSA_METRIC_WORK ON PFSAW.PFSA_MAINT_WORK
(MAINT_EV_ID, MAINT_TASK_ID, MAINT_WORK_ID)
LOGGING
TABLESPACE PFSANDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          6152K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSA_MAINT_WORK 
-- 
ALTER TABLE PFSAW.PFSA_MAINT_WORK ADD (
  CONSTRAINT PK_PFSA_METRIC_WORK
 PRIMARY KEY
 (MAINT_EV_ID, MAINT_TASK_ID, MAINT_WORK_ID)
    USING INDEX 
    TABLESPACE PFSANDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          6152K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

-- 
-- Foreign Key Constraints for Table PFSA_MAINT_WORK 
-- 
ALTER TABLE PFSAW.PFSA_MAINT_WORK ADD (
  CONSTRAINT FK_WORK_TO_TASK 
 FOREIGN KEY (MAINT_EV_ID, MAINT_TASK_ID) 
 REFERENCES PFSAW.PFSA_MAINT_TASK (MAINT_EV_ID,MAINT_TASK_ID));

----- PFSA_MAINT_ITEMS ----- 

--
-- PFSA_MAINT_ITEMS  (Table) 
--
CREATE TABLE PFSAW.PFSA_MAINT_ITEMS
(
  MAINT_EV_ID    VARCHAR2(40 BYTE)              NOT NULL,
  MAINT_TASK_ID  VARCHAR2(50 BYTE)              NOT NULL,
  MAINT_ITEM_ID  VARCHAR2(37 BYTE)              NOT NULL,
  CAGE_CD        VARCHAR2(5 BYTE),
  PART_NUM       VARCHAR2(32 BYTE),
  NIIN           VARCHAR2(9 BYTE),
  PART_SN        VARCHAR2(32 BYTE),
  NUM_ITEMS      NUMBER,
  CNTLD_EXCHNG   VARCHAR2(1 BYTE),
  REMOVED        VARCHAR2(1 BYTE),
  FAILURE        VARCHAR2(1 BYTE),
  LST_UPDT       DATE,
  UPDT_BY        VARCHAR2(30 BYTE),
  HEIR_ID        VARCHAR2(20 BYTE),
  PRIORITY       NUMBER
)
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          7840K
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

COMMENT ON TABLE PFSAW.PFSA_MAINT_ITEMS IS 'This table documents all items used/consumed during a maintenance event';


--
-- PK_PFSA_MAINT_ITEMS  (Index) 
--
CREATE UNIQUE INDEX PFSAW.PK_PFSA_MAINT_ITEMS ON PFSAW.PFSA_MAINT_ITEMS
(MAINT_EV_ID, MAINT_TASK_ID, MAINT_ITEM_ID)
LOGGING
TABLESPACE PFSANDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          8496K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSA_MAINT_ITEMS 
-- 
ALTER TABLE PFSAW.PFSA_MAINT_ITEMS ADD (
  CONSTRAINT PK_PFSA_MAINT_ITEMS
 PRIMARY KEY
 (MAINT_EV_ID, MAINT_TASK_ID, MAINT_ITEM_ID)
    USING INDEX 
    TABLESPACE PFSANDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          8496K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
*/ 
