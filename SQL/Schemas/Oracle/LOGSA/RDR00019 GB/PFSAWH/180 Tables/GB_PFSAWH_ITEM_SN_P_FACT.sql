DROP TABLE gb_pfsawh_item_sn_p_fact;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: pfsawh_item_sn_p_fact
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: pfsawh_item_sn_p_fact.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 19 November 2007
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES: 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_item_sn_p_fact
    (
    rec_id                           NUMBER           NOT NULL ,
--    
    period_type                      VARCHAR2(2)      DEFAULT    'MN' ,
    date_id                          NUMBER           NOT NULL , 
    physical_item_id                 NUMBER           NOT NULL ,        
    physical_item_sn_id              NUMBER           NOT NULL ,        
    mimosa_item_sn_id                VARCHAR2(8)      DEFAULT    '00000000' ,        
    item_date_from_id                NUMBER           NOT NULL ,
    item_time_from_id                NUMBER           DEFAULT    10001 ,
    item_date_to_id                  NUMBER           NOT NULL ,
    item_time_to_id                  NUMBER           DEFAULT    86401 ,
    item_force_id                    NUMBER           DEFAULT    0 , 
    item_location_id                 NUMBER           DEFAULT    0 , 
--  
    item_usage                       NUMBER , 
    item_usage_type                  VARCHAR2(12) ,
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
    delete_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    delete_date                      DATE             DEFAULT    '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)      DEFAULT    'N' ,
    hidden_date                      DATE             DEFAULT    '01-JAN-1900' ,
    notes                            VARCHAR2(255)    DEFAULT    '' ,
 CONSTRAINT pk_availability_p_fact PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_item_sn_p_fact;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_item_sn_p_fact 
    ON gb_pfsawh_item_sn_p_fact
    (
    date_id, 
    item_date_from_id,
    item_date_to_id,
    physical_item_id, 
    physical_item_sn_id
    );

DROP INDEX ixu_pfsawh_item_sn_p_fact_sys;

CREATE INDEX ixu_pfsawh_item_sn_p_fact_sys 
    ON gb_pfsawh_item_sn_p_fact(physical_item_id);

DROP INDEX ixu_pfsawh_item_sn_p_fact_sn;

CREATE INDEX ixu_pfsawh_item_sn_p_fact_sn 
    ON gb_pfsawh_item_sn_p_fact(physical_item_sn_id);

/*----- Foreign Key -----*/
 
ALTER TABLE gb_pfsawh_item_sn_p_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_p_fact_itm;        

ALTER TABLE gb_pfsawh_item_sn_p_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_p_fact_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);
 
ALTER TABLE gb_pfsawh_item_sn_p_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_p_fact_itmsn;        

ALTER TABLE gb_pfsawh_item_sn_p_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_p_fact_itmsn
    FOREIGN KEY (physical_item_id, physical_item_sn_id) 
    REFERENCES gb_pfsawh_item_sn_dim(physical_item_id, physical_item_sn_id);
 
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_item_sn_p_fact  
    DROP CONSTRAINT ck_availability_p_fact_status;        

ALTER TABLE gb_pfsawh_item_sn_p_fact  
    ADD CONSTRAINT ck_availability_p_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_sn_p_fact_seq;

CREATE SEQUENCE pfsawh_item_sn_p_fact_seq
    START WITH 1
    MAXVALUE 999999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_item_sn_p_fact 
IS 'PFSAWH_ITEM_SN_P_FACT - This table serves as the period fact for a particular item/serial number combination.'; 


COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.date_id 
IS 'PERIOD_TYPE - '; 

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.date_id 
IS 'DATE_ID - Foreign key of the PFSAWH_DATE_DIM table.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_date_from_id 
IS 'ITEM_DATE_FROM_ID - Start date of the availability report period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_time_from_id 
IS 'ITEM_TIME_FROM_ID - Start time of the availability report period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_date_to_id 
IS 'ITEM_DATE_TO_ID - End date of the availability report period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_time_to_id 
IS 'ITEM_TIME_TO_ID - End time of the availability report period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.';
   
COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 
    
COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_location_id 
IS 'ITEM_LOCATION_ID - Foreign key of the PFSAWH_LOCATION_DIM table.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_force_id 
IS 'ITEM_FORCE_ID - Foreign key of the PFSAWH_FORCE_DIM table.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_usage 
IS 'ITEM_USAGE - The actual usage of the system/end item accumulated during the period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_usage_type 
IS 'ITEM_USAGE_TYPE - An indicator of the type of usage captured.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.item_days 
IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.period_hrs 
IS 'PERIOD_HRS - The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcm_hrs 
IS 'NMCM_HRS - The total number of hours in a not mission capable maintenance status durint the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcm_user_hrs 
IS 'NMCM_USER_HRS - The total number of hours in a non mission capable maintenance status at the user level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcm_int_hrs 
IS 'NMCM_INT_HRS - The total number of hours in a non mission capable maintenance status at the intermediate level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcm_dep_hrs 
IS 'NMCM_DEP_HRS - The total number of hours in a non mission capable maintenance status at the depot level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.fmc_hrs 
IS 'FMC_HRS - The total number of hours in a fully mission capable status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcs_hrs 
IS 'NMCS_HRS - The total number of hours in a not mission capable supply status durint the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmc_hrs 
IS 'PMC_HRS - The total number of hours in a partially mission capable status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmc_hrs 
IS 'NMC_HRS - The total number of hours in a not mission capable status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.mc_hrs 
IS 'MC_HRS - The total number of hours in a mission capable status (fully or partially) during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcs_user_hrs 
IS 'NMCS_USER_HRS - The total number of hours in a non mission capable supply status at the user level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcs_int_hrs 
IS 'NMCS_INT_HRS - The total number of hours in a non mission capable supply status at the intermediate level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.nmcs_dep_hrs 
IS 'NMCS_DEP_HRS - The total number of hours in a non mission capable supply status at the depot level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmcm_hrs 
IS 'PMCM_HRS - The total number of hours in a partial mission capable maintenance status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmcm_user_hrs 
IS 'PMCM_USER_HRS - The total number of hours in a partially mission capability maintenance status at the user level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmcm_int_hrs 
IS 'PMCM_INT_HRS - The total number of hours in a partially mission capability maintenance status at the intermediate level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.dep_hrs 
IS 'DEP_HRS - The total number of hours in a non mission capable status at the depot level.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmcs_hrs 
IS 'PMCS_HRS - The total number of hours in a partial mission capable supply status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmcs_user_hrs 
IS 'PMCS_USER_HRS - The total number of hours in a partially mission capability supply status at the user level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.pmcs_int_hrs 
IS 'PMCS_INT_HRS - The total number of hours in a partially mission capability supply status at the intermediate level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.operational_readiness_rate 
IS 'OPERATIONAL_READINESS_RATE - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.operating_cost_per_hour 
IS 'OPERATING_COST_PER_HOUR - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.cost_parts 
IS 'COST_PARTS - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.cost_manpower 
IS 'COST_MANPOWER - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.deferred_maint_items 
IS 'DEFERRED_MAINT_ITEMS - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.operat_hrs_since_last_overhaul 
IS 'OPERAT_HRS_SINCE_LAST_OVERHAUL - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.maint_hrs_since_last_overhaul 
IS 'MAINT_HRS_SINCE_LAST_OVERHAUL - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.time_since_last_overhaul 
IS 'TIME_SINCE_LAST_OVERHAUL - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.notes 
IS 'NOTES - Processing notes from the ETL process.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.active_date 
IS 'ACTIVE_DATE - Addition control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.inactive_date 
IS 'INACTIVE_DATE - Addition control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.delete_date 
IS 'DELETE_DATE - Addition control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_item_sn_p_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_item_sn_p_fact'); 

/*----- Check to see if the table column comments are present -----*/
    
SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_item_sn_p_fact') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_item_sn_p_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%read%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/* 

SELECT * 
FROM   gb_pfsawh_item_sn_p_fact; 

*/
