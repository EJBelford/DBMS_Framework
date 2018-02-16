/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
-- 
--         NAME: cbmwh_item_sn_evnt_t_fct 
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: cbmwh_item_sn_evnt_t_fct.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 16 January 2009  
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES: 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_item_sn_evnt_t_fct_seq;

CREATE SEQUENCE cbm_hbct_vhms_item_sn_r_fc_seq
    START WITH 1
--    MAXVALUE 999999999 
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     


/*----- Create table -----*/

DROP TABLE cbmwh_item_sn_evnt_t_fct;
	
CREATE TABLE cbmwh_item_sn_evnt_t_fct
    (
    rec_id                           NUMBER           NOT NULL ,
--    
    date_id                          NUMBER           NOT NULL , 
    physical_item_id                 NUMBER           NOT NULL ,        
    physical_item_sn_id              NUMBER           NOT NULL ,        
    pba_id                           NUMBER           DEFAULT    1000000 ,
    item_date_from_id                NUMBER           NOT NULL ,
    item_time_from_id                NUMBER           DEFAULT    10001 ,
    item_date_to_id                  NUMBER           NOT NULL ,
    item_time_to_id                  NUMBER           DEFAULT    86401 ,
    item_force_id                    NUMBER           DEFAULT    0 ,
    force_parent_unit_id             NUMBER           DEFAULT    0 ,
    force_command_unit_id            NUMBER           DEFAULT    0 , 
    item_location_id                 NUMBER           DEFAULT    0 , 
--
    plat_phys_item_id                NUMBER           NOT NULL ,        
    plat_phys_item_sn_id             NUMBER           NOT NULL ,        
    plat_mimosa_enterprise_id        VARCHAR2(8)      DEFAULT '00000430' NOT NULL,
    plat_mimosa_site_id              VARCHAR2(8)      DEFAULT '00000001' NOT NULL,
    plat_mimosa_item_sn_id           VARCHAR2(8)      DEFAULT '00000000' ,        
--  
    mimosa_enterprise_id             VARCHAR2(8)      DEFAULT '00000430' NOT NULL,
    mimosa_site_id                   VARCHAR2(8)      DEFAULT '00000001' NOT NULL,
    mimosa_item_sn_id                VARCHAR2(8)      DEFAULT '00000000' ,       
--
    comp_usag_mile_driv              NUMBER,
    comp_usag_eng_oprg_hr            NUMBER,
    comp_usag_fuel_csmp              NUMBER,
    comp_usag_wepn_rnd_fire          NUMBER,
    comp_usag_wepn_op_strs           NUMBER,
    comp_usag_veh_excp_cond          NUMBER,
    comp_usag_mri_hlth_stat          NUMBER,
    comp_usag_mri_test_rslt          NUMBER,
-- 
    item_usage_0                     NUMBER , 
    item_usage_type_0                VARCHAR2(12) ,
    item_usage_1                     NUMBER , 
    item_usage_type_1                VARCHAR2(12) ,
    item_usage_2                     NUMBER , 
    item_usage_type_2                VARCHAR2(12) ,
--
    item_days                        NUMBER , 
    period_hrs                       NUMBER , 
    mc_hrs                           NUMBER , 
    fmc_hrs                          NUMBER , 
--    
    pmc_hrs                          NUMBER , 
    pmcm_hrs                         NUMBER , 
    pmcm_user_hrs                    NUMBER , 
    pmcm_int_hrs                     NUMBER , 
    pmcs_hrs                         NUMBER , 
    pmcs_user_hrs                    NUMBER , 
    pmcs_int_hrs                     NUMBER , 
--
    nmc_hrs                          NUMBER , 
    nmcm_hrs                         NUMBER , 
    nmcm_user_hrs                    NUMBER , 
    nmcm_int_hrs                     NUMBER , 
    nmcs_hrs                         NUMBER , 
    nmcs_user_hrs                    NUMBER , 
    nmcs_int_hrs                     NUMBER , 
--     
    dep_hrs                          NUMBER , 
    nmcm_dep_hrs                     NUMBER , 
    nmcs_dep_hrs                     NUMBER , 
--
    operational_readiness_rate       NUMBER , 
    readiness_reported_qty           NUMBER ,
    total_down_time                  NUMBER ,
--
    maint_action_cnt                 NUMBER , 
    meantime_btwn_maint_act          NUMBER ,
    meandown_item                    NUMBER ,
    customer_wait_time               NUMBER ,
--    
    operating_cost_per_hour          NUMBER , 
    cost_parts                       NUMBER , 
    cost_manpower                    NUMBER , 
    deferred_maint_items             NUMBER , 
    operat_hrs_since_last_overhaul   NUMBER , 
    maint_hrs_since_last_overhaul    NUMBER , 
    time_since_last_overhaul         NUMBER , 
--
    status                           VARCHAR2(1)      DEFAULT    'C' ,
    updt_by                          VARCHAR2(30)     DEFAULT    USER ,
    lst_updt                         DATE             DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)      DEFAULT    'Y' , 
    active_date                      DATE             DEFAULT    '01-JAN-1900' , 
    inactive_date                    DATE             DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)     DEFAULT    USER , 
    insert_date                      DATE             DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)     NULL ,
    update_date                      DATE             DEFAULT    '01-JAN-1900' ,
    delete_by                        VARCHAR2(20)     NULL ,
    delete_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    delete_date                      DATE             DEFAULT    '01-JAN-1900' ,
    hidden_by                        VARCHAR2(20)     NULL ,
    hidden_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    hidden_date                      DATE             DEFAULT    '01-JAN-1900' ,
    etl_processed_by                 VARCHAR2(50) ,
    notes                            VARCHAR2(255)    DEFAULT    ''  
) 
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512M
            NEXT             256M
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

COMMENT ON TABLE cbmwh_item_sn_evnt_t_fct 
IS 'cbmwh_item_sn_evnt_t_fct - This table serves as the period fact for a particular item/serial number combination.'; 


COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.rec_id 
IS 'REC_ID - Primary, blind key of the cbmwh_item_sn_evnt_t_fct table.'; 

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.date_id 
IS 'DATE_ID - Foreign key of the PFSAWH_DATE_DIM table.'; 

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_date_from_id 
IS 'ITEM_DATE_FROM_ID - Start date of the availability report period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_time_from_id 
IS 'ITEM_TIME_FROM_ID - Start time of the availability report period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_date_to_id 
IS 'ITEM_DATE_TO_ID - End date of the availability report period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_time_to_id 
IS 'ITEM_TIME_TO_ID - End time of the availability report period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the cbmwh_item_DIM table.';
   
COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the cbmwh_item_SN_DIM table.';
    
COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 
    
COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pba_id 
IS 'PBA_ID - '; 
    
COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_location_id 
IS 'ITEM_LOCATION_ID - Foreign key of the PFSAWH_LOCATION_DIM table.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_force_id 
IS 'ITEM_FORCE_ID - Foreign key of the PFSAWH_FORCE_DIM table.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_usage 
IS 'ITEM_USAGE - The actual usage of the system/end item accumulated during the period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_usage_type 
IS 'ITEM_USAGE_TYPE - An indicator of the type of usage captured.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.item_days 
IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.period_hrs 
IS 'PERIOD_HRS - The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcm_hrs 
IS 'NMCM_HRS - The total number of hours in a not mission capable maintenance status durint the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcm_user_hrs 
IS 'NMCM_USER_HRS - The total number of hours in a non mission capable maintenance status at the user level during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcm_int_hrs 
IS 'NMCM_INT_HRS - The total number of hours in a non mission capable maintenance status at the intermediate level during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcm_dep_hrs 
IS 'NMCM_DEP_HRS - The total number of hours in a non mission capable maintenance status at the depot level during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.fmc_hrs 
IS 'FMC_HRS - The total number of hours in a fully mission capable status during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcs_hrs 
IS 'NMCS_HRS - The total number of hours in a not mission capable supply status durint the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmc_hrs 
IS 'PMC_HRS - The total number of hours in a partially mission capable status during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmc_hrs 
IS 'NMC_HRS - The total number of hours in a not mission capable status during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.mc_hrs 
IS 'MC_HRS - The total number of hours in a mission capable status (fully or partially) during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcs_user_hrs 
IS 'NMCS_USER_HRS - The total number of hours in a non mission capable supply status at the user level during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcs_int_hrs 
IS 'NMCS_INT_HRS - The total number of hours in a non mission capable supply status at the intermediate level during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.nmcs_dep_hrs 
IS 'NMCS_DEP_HRS - The total number of hours in a non mission capable supply status at the depot level during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmcm_hrs 
IS 'PMCM_HRS - The total number of hours in a partial mission capable maintenance status during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmcm_user_hrs 
IS 'PMCM_USER_HRS - The total number of hours in a partially mission capability maintenance status at the user level during the indicated period';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmcm_int_hrs 
IS 'PMCM_INT_HRS - The total number of hours in a partially mission capability maintenance status at the intermediate level during the indicated period';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.dep_hrs 
IS 'DEP_HRS - The total number of hours in a non mission capable status at the depot level.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmcs_hrs 
IS 'PMCS_HRS - The total number of hours in a partial mission capable supply status during the indicated period.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmcs_user_hrs 
IS 'PMCS_USER_HRS - The total number of hours in a partially mission capability supply status at the user level during the indicated period';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.pmcs_int_hrs 
IS 'PMCS_INT_HRS - The total number of hours in a partially mission capability supply status at the intermediate level during the indicated period';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.maint_action_cnt 
IS 'MAINT_ACTION_CNT - The number of maintenance actions that have been identified during the period';
 
COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.meantime_btwn_maint_act 
IS 'MEANTIME_BTWN_MAINT_ACT - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.meandown_item 
IS 'MEANDOWN_ITEM - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.customer_wait_time 
IS 'CUSTOMER_WAIT_TIME - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.operational_readiness_rate 
IS 'OPERATIONAL_READINESS_RATE - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.operating_cost_per_hour 
IS 'OPERATING_COST_PER_HOUR - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.cost_parts 
IS 'COST_PARTS - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.cost_manpower 
IS 'COST_MANPOWER - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.deferred_maint_items 
IS 'DEFERRED_MAINT_ITEMS - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.operat_hrs_since_last_overhaul 
IS 'OPERAT_HRS_SINCE_LAST_OVERHAUL - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.maint_hrs_since_last_overhaul 
IS 'MAINT_HRS_SINCE_LAST_OVERHAUL - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.time_since_last_overhaul 
IS 'TIME_SINCE_LAST_OVERHAUL - ';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.notes 
IS 'NOTES - Processing notes from the ETL process.'; 

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.active_date 
IS 'ACTIVE_DATE - Addition control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.inactive_date 
IS 'INACTIVE_DATE - Addition control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.delete_date 
IS 'DELETE_DATE - Addition control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN cbmwh_item_sn_evnt_t_fct.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('cbmwh_item_sn_evnt_t_fct'); 

/*----- Check to see if the table column comments are present -----*/
    
SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('cbmwh_item_sn_evnt_t_fct') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('cbmwh_item_sn_evnt_t_fct') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a 
WHERE  a.col_name LIKE UPPER('%read%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 
   
/*----- Primary Key -----*/ 

ALTER TABLE cbmwh_item_sn_evnt_t_fct  
    DROP CONSTRAINT pk_cbmwh_item_sn_evnt_t_fct; 
    
ALTER TABLE cbmwh_item_sn_evnt_t_fct  
    ADD CONSTRAINT  pk_cbmwh_item_sn_evnt_t_fct 
    PRIMARY KEY 
        (
        rec_id
        );    

/*----- Indexs -----*/

-- DROP INDEX idx_cbm_hbct_vhms_itm_sn_r_fct;

CREATE INDEX idx_cbm_hbct_vhms_itm_sn_r_fct 
    ON cbmwh_item_sn_evnt_t_fct
        (
        date_id, 
        item_date_from_id,
        item_date_to_id,
        physical_item_id, 
        physical_item_sn_id
        );

-- DROP INDEX idx_hbct_vhms_itm_sn_r_fct_sys;

CREATE INDEX idx_hbct_vhms_itm_sn_r_fct_id 
    ON cbmwh_item_sn_evnt_t_fct
        (
        physical_item_id
        );

-- DROP INDEX idx_hbct_vhms_item_sn_r_fct_sn;

CREATE INDEX idx_hbct_vhms_item_sn_r_fct_sn 
    ON cbmwh_item_sn_evnt_t_fct
        (
        physical_item_sn_id
        );

/*----- Foreign Key -----*/
 
-- ALTER TABLE cbmwh_item_sn_evnt_t_fct  
--     DROP CONSTRAINT fk_hbct_vhms_item_sn_r_fct_itm;        

ALTER TABLE cbmwh_item_sn_evnt_t_fct  
    ADD CONSTRAINT fk_hbct_vhms_item_sn_r_fct_itm
    FOREIGN KEY 
        (
        physical_item_id
        ) 
    REFERENCES cbmwh_item_dim
        (
        physical_item_id
        );
 
-- ALTER TABLE cbmwh_item_sn_evnt_t_fct  
--     DROP CONSTRAINT fk_hbct_vhms_itm_sn_r_fct_snid;        

ALTER TABLE cbmwh_item_sn_evnt_t_fct  
    ADD CONSTRAINT fk_hbct_vhms_itm_sn_r_fct_snid
    FOREIGN KEY 
        (
        physical_item_sn_id
        ) 
    REFERENCES cbmwh_item_sn_dim
        (
        physical_item_sn_id
        );
 
-- ALTER TABLE cbmwh_item_sn_evnt_t_fct  
--     DROP CONSTRAINT fk_hbct_vhms_itm_sn_r_fct_pba;        

ALTER TABLE cbmwh_item_sn_evnt_t_fct 
    ADD CONSTRAINT fk_hbct_vhms_itm_sn_r_fct_pba 
    FOREIGN KEY 
        (
        pba_id
        ) 
    REFERENCES cbm_pba_ref 
        (
        pba_id
        ); 
  
/*----- Constraints -----*/

-- ALTER TABLE cbmwh_item_sn_evnt_t_fct  
--     DROP CONSTRAINT ck_hbct_vhms_itm_sn_r_fct_stat;        

ALTER TABLE cbmwh_item_sn_evnt_t_fct  
    ADD CONSTRAINT ck_hbct_vhms_itm_sn_r_fct_stat 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/* 

SELECT * 
FROM   cbmwh_item_sn_evnt_t_fct; 

*/
