/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_maint_itm_wrk_fact_seq;

CREATE SEQUENCE pfsawh_maint_itm_wrk_fact_seq
    START WITH 1000000
--    MAXVALUE   9999999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_maint_itm_wrk_fact
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: pfsawh_maint_itm_wrk_fact.sql 
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
-- 29FEB08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

DROP TABLE pfsawh_maint_itm_wrk_fact;
    
CREATE TABLE pfsawh_maint_itm_wrk_fact 
(
    rec_id                           NUMBER              NOT NULL ,
--
    tsk_begin_date_id                NUMBER,
    tsk_begin_time_id                NUMBER,
    tsk_end_date_id                  NUMBER,
    tsk_end_time_id                  NUMBER,
--     
    physical_item_id                 NUMBER              NOT NULL ,  --    pfsa_maint_event.sys_ei_sn 
    physical_item_sn_id              NUMBER              NOT NULL ,    
    mimosa_item_sn_id                VARCHAR2(8)         DEFAULT '00000000' ,        
    force_unit_id                    NUMBER              DEFAULT 0 ,
    pba_id                           NUMBER              DEFAULT 1000000 , 
-- 
    wrk_tsk_cnt                      NUMBER              DEFAULT 0 ,   
    tsk_days_to_cmplt                NUMBER              DEFAULT 0 ,   
    tsk_hrs_to_cmplt                 NUMBER              DEFAULT 0 ,   
--
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
    hidden_date                      DATE                DEFAULT '01-JAN-1900' 
) 
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
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

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE pfsawh_maint_itm_wrk_fact 
IS 'PFSAWH_MAINT_ITM_WRK_FACT - '; 


COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.rec_id 
IS 'REC_ID - Sequence/identity for dimension/fact table.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.tsk_begin_date_id 
IS 'TSK_BEGIN_DATE_ID - Foreign key to the PFSAWH_DATE_DIM records.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.tsk_begin_time_id 
IS 'TSK_BEGIN_TIME_ID - Foreign key of the PFSAWH_TIME_DIM records.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.tsk_end_date_id 
IS 'TSK_END_DATE_ID - Foreign key to the PFSAWH_DATE_DIM records.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.tsk_end_time_id 
IS 'TSK_END_TIME_ID - Foreign key of the PFSAWH_TIME_DIM records.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key to the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key to the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 
     
COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.force_unit_id 
IS 'FORCE_UNIT_ID - Primary, blind key of the pfsawh_force_unit_dim table.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.wrk_tsk_cnt 
IS 'WRK_TSK_CNT - ????? Number of tasks completed as part of this work item.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.tsk_days_to_cmplt 
IS 'TSK_DAYS_TO_CMPLT - The total number of days elapsed time during the maintenance event when work was being performed.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.tsk_hrs_to_cmplt 
IS 'TSK_HRS_TO_CMPLT - The total number of hours elapsed time during the maintenance event when work was being performed.'; 
    
COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_ev_id_a 
IS 'MAINT_EV_ID_A - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_ev_id_b 
IS 'MAINT_EV_ID_B - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_task_id 
IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_work_id 
IS 'MAINT_WORK_ID - The identifier that when combined with the MAINT_EV_ID and MAINT_TASK_ID creates a unique maintenance task work id.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_org 
IS 'MAINT_ORG - The organization accomplishing the maintenance event.  If a UIC, the value will match the maint_uic.  Field used to identify manufacturer/non-UIC identified contractor maintenance.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_uic 
IS 'MAINT_UIC - The UIC provided by the STAMIS system for the Maintenance Event.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_lvl_cd 
IS 'MAINT_LVL_CD - The maint lvl of the org.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.elapsed_tsk_wk_tm 
IS 'ELAPSED_TSK_WK_TM - The total elapsed time during the maintenance event when work was being performed, when available from the data source.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.inspect_tsk 
IS 'INSPECT_TSK - Flag indicating if this was an inspection task. Values are F\T\U'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.essential_tsk 
IS 'ESSENTIAL_TSK - A flag for records that are essential. Values are ?\F\T\U\Y'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.maint_work_mh 
IS 'MAINT_WORK_MH - The number of hours the maintenance work took to complete.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.wrk_mil_civ_kon 
IS 'WRK_MIL_CIV_KON - The code for the type of person doing the maintenance, Civilian, Kontractor, Military or Unknown.  Values are C\K\M\U'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.wrk_mos 
IS 'WRK_MOS - OCCUPATIONAL SPECIALTY CODE - The code that represents the Military Occupational Specialty (MOS) of the person performing the maintenance action.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.wrk_spec_person 
IS 'WRK_SPEC_PERSON - SPEC_PERSON - Specific person who performed the work.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.wrk_repair 
IS 'WRK_REPAIR - Item was repaired.  Values should be Y - Yes, N - No, ? - Unknown'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.wrk_mos_sent 
IS 'WRK_MOS_SENT - The value of provided in the source data for the MOS.  This value is used to derive the MOS used.  The derived values generally remove the skill level code, and standardize terms used for Contractor and Civilian personnel.'; 

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_maint_itm_wrk_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_maint_itm_wrk_fact'); 

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
    ON  b.table_name  = UPPER('pfsawh_maint_itm_wrk_fact') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_maint_itm_wrk_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%spec_p%'); 
   
/*----- Constraints - Primary Key -----*/ 

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT pk_pfsawh_maint_itm_wrk_fact 
    PRIMARY KEY 
        (
        rec_id
        );    

/*----- Foreign Key Constraints -----*/ 

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT fk_pfsawh_maint_itm_wrk_id_itm;        

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT fk_pfsawh_maint_itm_wrk_id_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES pfsawh_item_dim(physical_item_id);
 
ALTER TABLE pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT fk_pfsawh_mnt_itm_wrk_id_itmsn;        

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT fk_pfsawh_mnt_itm_wrk_id_itmsn
    FOREIGN KEY 
        (
--        physical_item_id, 
        physical_item_sn_id
        ) 
    REFERENCES pfsawh_item_sn_dim
        (
--        physical_item_id, 
        physical_item_sn_id
        );
 
/*----- Non Foreign Key Constraints -----*/ 

DROP INDEX ixu_pfsawh_maint_itm_wrk_fac;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_maint_itm_wrk_fac 
    ON pfsawh_maint_itm_wrk_fact
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
    ON pfsawh_maint_itm_wrk_fact
    (
    physical_item_id, 
    physical_item_sn_id  
    );

/*----- Constraints -----*/

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_act_fl;        

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_del_fl;        

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_hid_fl;       

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    DROP CONSTRAINT ck_pfsawh_mntitmwrk_fct_status;        

ALTER TABLE pfsawh_maint_itm_wrk_fact  
    ADD CONSTRAINT ck_pfsawh_mntitmwrk_fct_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Create the Trigger now -----*/ 


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

BEGIN 

    DELETE pfsawh_maint_itm_wrk_fact;
    
    COMMIT; 

    INSERT 
    INTO   pfsawh_maint_itm_wrk_fact 
        (
        tsk_begin_date_id, 
        tsk_begin_time_id, 
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item_id, 
        physical_item_sn_id, 
--        mimosa_item_sn_id, 
--        force_unit_id, 
--        pba_id, 
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
    SELECT 
        NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_begin, 'DD-MON-YYYY')), 
            NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_est, 'DD-MON-YYYY')), 
                0)) AS tsk_begin_date_id, 
        NVL(fn_time_to_time_id(tk.tsk_begin),       
            NVL(fn_time_to_time_id(ev.dt_maint_ev_est), 
                10001)) AS tsk_begin_time_id, 
        NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_end, 'DD-MON-YYYY')), 
            NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_cmpl, 'DD-MON-YYYY')), 
                0)) AS tsk_end_date_id, 
        NVL(fn_time_to_time_id(tk.tsk_end),       
            NVL(fn_time_to_time_id(ev.dt_maint_ev_cmpl), 
                96400)) AS tsk_end_time_id, 
        fn_pfsawh_get_item_dim_id(NVL(ev.sys_ei_niin, '000000000')) AS item_sys_ei_id,  
        fn_pfsawh_get_item_sn_dim_id(NVL(ev.sys_ei_niin, '000000000'), NVL(ev.sys_ei_sn, 0)) AS item_sn_ei_id, 
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
--        AND rownum < 100 
    ORDER BY ev.sys_ei_niin, ev.sys_ei_sn, tk.tsk_end DESC, ev.maint_item_niin;  
    
    COMMIT; 
        
    INSERT 
    INTO   pfsawh_maint_itm_wrk_fact 
        (
        tsk_begin_date_id, 
        tsk_begin_time_id, 
        tsk_end_date_id, 
        tsk_end_time_id, 
        physical_item_id, 
        physical_item_sn_id, 
--        mimosa_item_sn_id, 
--        force_unit_id, 
--        pba_id, 
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
    SELECT 
        NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_begin, 'DD-MON-YYYY')), 
            NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_est, 'DD-MON-YYYY')), 
                0)) AS tsk_begin_date_id, 
        NVL(fn_time_to_time_id(tk.tsk_begin),       
            NVL(fn_time_to_time_id(ev.dt_maint_ev_est), 
                10001)) AS tsk_begin_time_id, 
        NVL(fn_date_to_date_id(TO_CHAR(tk.tsk_end, 'DD-MON-YYYY')), 
            NVL(fn_date_to_date_id(TO_CHAR(ev.dt_maint_ev_cmpl, 'DD-MON-YYYY')), 
                0)) AS tsk_end_date_id, 
        NVL(fn_time_to_time_id(tk.tsk_end),       
            NVL(fn_time_to_time_id(ev.dt_maint_ev_cmpl), 
                96400)) AS tsk_end_time_id, 
        fn_pfsawh_get_item_dim_id(NVL(ev.sys_ei_niin, '000000000')) AS item_sys_ei_id,  
        fn_pfsawh_get_item_sn_dim_id(NVL(ev.sys_ei_niin, '000000000'), NVL(ev.sys_ei_sn, 0)) AS item_sn_ei_id, 
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
    FROM   pfsa_maint_event ev, 
           pfsa_maint_task@pfsawh.lidbdev tk,
           pfsa_maint_work@pfsawh.lidbdev wk 
    WHERE  ev.maint_ev_id = tk.maint_ev_id
        AND ev.maint_ev_id = wk.maint_ev_id 
        AND tk.maint_task_id = wk.maint_task_id 
--        AND rownum < 100 
    ORDER BY ev.sys_ei_niin, ev.sys_ei_sn, tk.tsk_end DESC, ev.maint_item_niin;  
    
    COMMIT; 
        
END;

/* 

SELECT * FROM pfsawh_maint_itm_wrk_fact; 

*/

/*

SELECT 
DISTINCT physical_item_sn_id
FROM   pfsawh_maint_itm_wrk_fact
ORDER BY physical_item_sn_id; 

SELECT * 
FROM   pfsawh_maint_itm_wrk_fact
WHERE  physical_item_id = 141223 
    AND physical_item_sn_id = 10004; 

SELECT * 
FROM   pfsawh_maint_itm_wrk_fact
WHERE  physical_item_id = 141143; 

*/
