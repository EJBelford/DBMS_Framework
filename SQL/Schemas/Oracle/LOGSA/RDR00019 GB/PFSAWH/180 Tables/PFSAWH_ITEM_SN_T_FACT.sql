/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: PFSAWH_ITEM_SN_T_FACT 
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: PFSAWH_ITEM_SN_T_FACT.sql 
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

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_sn_t_fact_seq; 

CREATE SEQUENCE pfsawh_item_sn_t_fact_seq
    START WITH 1
--    MAXVALUE 9999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create trigger -----*/     

DROP TABLE pfsawh_item_sn_t_fact;
	
CREATE TABLE pfsawh_item_sn_t_fact
    (
    rec_id                           NUMBER           NOT NULL ,
--    
    date_id                          NUMBER           NOT NULL , 
    physical_item_id                 NUMBER           NOT NULL ,        
    physical_item_sn_id              NUMBER           NOT NULL ,        
    mimosa_item_sn_id                VARCHAR2(8)      DEFAULT    '00000000' ,        
    pba_id                           NUMBER           DEFAULT    1000000 ,
    item_date_from_id                NUMBER           NOT NULL ,
    item_time_from_id                NUMBER           DEFAULT    10001 ,
    item_date_to_id                  NUMBER           NOT NULL ,
    item_time_to_id                  NUMBER           DEFAULT    86401 ,
    item_force_id                    NUMBER           DEFAULT    0 , 
    item_location_id                 NUMBER           DEFAULT    0 , 
--
    item_usage_0                     NUMBER , 
    item_usage_type_0                VARCHAR2(12) ,
    item_usage_1                     NUMBER , 
    item_usage_type_1                VARCHAR2(12) ,
    item_usage_2                     NUMBER , 
    item_usage_type_2                VARCHAR2(12) ,
-- 
    period_hrs                       NUMBER , 
    item_mission_capable_code        VARCHAR2(3) , 
    item_nmc_cause_code              VARCHAR2(3) , 
    item_most_critical_part_code     VARCHAR2(12) , 
    item_deferred_maint_items        NUMBER , 
    item_project_flag                VARCHAR2(1) , 
    item_project_code                VARCHAR2(6) , 
--    
    tran_mc_hrs                      NUMBER ,
    tran_fmc_hrs                     NUMBER ,
--    
    tran_pmc_hrs                     NUMBER ,
    tran_pmcm_hrs                    NUMBER ,
    tran_pmcm_user_hrs               NUMBER ,
    tran_pmcm_int_hrs                NUMBER ,
    tran_pmcs_hrs                    NUMBER ,
    tran_pmcs_user_hrs               NUMBER ,
    tran_pmcs_int_hrs                NUMBER ,
--    
    tran_nmc_hrs                     NUMBER ,
    tran_nmcm_hrs                    NUMBER ,
    tran_nmcm_user_hrs               NUMBER ,
    tran_nmcm_int_hrs                NUMBER ,
    tran_nmcm_dep_hrs                NUMBER ,
    tran_nmcs_hrs                    NUMBER ,
    tran_nmcs_user_hrs               NUMBER ,
    tran_nmcs_int_hrs                NUMBER ,
    tran_nmcs_dep_hrs                NUMBER ,
--
    tran_dep_hrs                     NUMBER ,
--
    tran_operat_readiness_rate       NUMBER , 
--
    tran_maint_action_cnt            NUMBER , 
    tran_meantime_btwn_maint_act     NUMBER ,
    tran_meandown_item               NUMBER ,
    tran_customer_wait_time          NUMBER ,
--    
    tran_operat_cost_per_hour        NUMBER , 
    tran_cost_parts                  NUMBER , 
    tran_cost_manpower               NUMBER , 
    tran_deferred_maint_items        NUMBER , 
    tran_operat_hrs_since_lst_ovhl   NUMBER , 
    tran_maint_hrs_since_lst_ovhl    NUMBER , 
    tran_time_since_lst_ovhl         NUMBER , 
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
    etl_processed_by                 VARCHAR2(50) ,
CONSTRAINT pk_pfsawh_item_sn_t_fact PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_item_sn_t_fact;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_item_sn_t_fact 
    ON pfsawh.pfsawh_item_sn_t_fact
    (
    physical_item_id, 
    physical_item_sn_id, 
    item_date_from_id,
    item_time_from_id, 
    item_date_to_id,
    item_time_to_id 
    );
    
/*----- Foreign Key -----*/
 
ALTER TABLE pfsawh_item_sn_t_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_t_fact_itm;        

ALTER TABLE pfsawh_item_sn_t_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_t_fact_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES pfsawh_item_dim(physical_item_id);
 
ALTER TABLE pfsawh_item_sn_t_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_t_fact_itmsn;        

ALTER TABLE pfsawh_item_sn_t_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_t_fact_itmsn
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

ALTER TABLE pfsawh_item_sn_t_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_t_fact_pbaid;        

ALTER TABLE PFSAWH.pfsawh_item_sn_t_fact 
    ADD CONSTRAINT fk_pfsawh_item_sn_t_fact_pbaid 
    FOREIGN KEY 
        (
        pba_id
        ) 
    REFERENCES pfsa_pba_ref 
        (
        pba_id
        ); 
  
/*----- Constraints -----*/

ALTER TABLE pfsawh.pfsawh_item_sn_t_fact   
    DROP CONSTRAINT ck_pfsawh_item_sn_t_fact;        

ALTER TABLE pfsawh.pfsawh_item_sn_t_fact  
    ADD CONSTRAINT ck_availability_t_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE pfsawh_item_sn_t_fact 
IS 'PFSAWH_ITEM_SN_T_FACT - This table serves as the daily/transactional fact for a particular item/serial number combination.'; 


COMMENT ON COLUMN pfsawh_item_sn_t_fact.rec_id
IS 'REC_ID - Sequence/identity for fact'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.date_id 
IS 'DATE_ID - Identity for PFSA_DATE_DIM records.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - LIW/PFSAWH identitier for the item/part as represented in the PFSAWH_ITEM_DIM';
        
COMMENT ON COLUMN pfsawh_item_sn_t_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number as represented in the PFSAWH_ITEM_SN_DIM.'; 
       
COMMENT ON COLUMN pfsawh_item_sn_t_fact.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 
      
COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_date_from_id
IS 'ITEM_DATE_FROM_ID - The date this records coverage starts with.  Identity for PFSA_DATE_DIM records'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_time_from_id
IS 'ITEM_TIME_FROM_ID - The time this records coverage starts with.  Identity for PFSA_TIMEDIM records'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_date_to_id
IS 'ITEM_DATE_TO_ID - The date this records coverage ends with.  Identity for PFSA_DATE_DIM records'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_time_to_id
IS 'ITEM_TIME_TO_ID - The time this records coverage ends with.  Identity for PFSA_TIMEDIM records'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_force_id
IS 'ITEM_FORCE_ID - FORCE UIC - The unit identifier of valid Force UICs as represented in the PFSAWH_FORCE_DIM.';
    
COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_location_id
IS 'ITEM_LOCATION_ID - LOCATION - Identifies the location as CONUS (Continental United States) or OCONUS (Outside the Continental United States).'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_usage
IS 'ITEM_USAGE - CURRENT USAGE QUANTITY - The current reported usage quantity.';
    
COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_usage_type
IS 'ITEM_USAGE_TYPE - USAGE BASIS - A one-character, alphanumeric code that identifies the type of use measurement to be applied to the item usage (e.g., miles, hours, rounds).';
 
COMMENT ON COLUMN pfsawh_item_sn_t_fact.period_hrs
IS 'PERIOD_HRS - The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_mission_capable_code
IS 'ITEM_MISSION_CAPABLE_CODE - MISSION CAPABLE - Rate at which an item is considered mission capable.  Determined by the following formula: MC Rate(%) - (FMC Hours + PMC Hours/Total Hours on Hand) *100'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_nmc_cause_code
IS 'ITEM_NMC_CAUSE_CODE - The reason code for why the item was "Not Mission Capable."'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_most_critical_part_code
IS 'ITEM_MOST_CRITICAL_PART_CODE - The part code of the repair part that most effected the mission capability of the item.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_deferred_maint_items
IS 'ITEM_DEFERRED_MAINT_ITEMS - The item has maintenance actions that effect mission capability that have been deferred.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_project_flag 
IS 'ITEM_PROJECT_FLAG - PROJECT CODE FLAG - No description available at this time.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.item_project_code 
IS 'ITEM_PROJECT_CODE - PROJECT CODE - The DA Master Project Code is a three-position, alphanumeric code used to distinguish requisitions and related documentation and shipments and to accumulate intraservice performance and cost data related to exercises, maneuvers, and other distinct programs, projects, and operations.  The Project Code is used to identify requisitions, related documents, and shipments of materiel for specific projects, programs, or maneuvers.  It identifies specific programs to provide funding and costing at the requisitioner or supplier level, to satisfy program costs and analysis, including an indicator of transactions within or outside of the federal government.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_mc_hrs 
IS 'TRAN_MC_HRS - MC_HRS - The total number of hours in a mission capable status (fully or partially) during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_fmc_hrs 
IS 'TRAN_FMC_HRS - FULLY MISSION CAPABLE (FMC) HOURS - The reported number of hours, during the subject report period, that the particular aircraft (identified by MODEL and SERIAL_NUMBER) is reported to be Fully Mission Capable (FMC).'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmc_hrs 
IS 'TRAN_PMC_HRS - PARTIALLY MISSION CAPABLE (PMC) HOURS - The reported hours that an item of equipment was capable of performing one or more, but not all, assigned missions, due to one or more of its mission-essential subsystems being inoperative for maintenance or supply reasons.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmcm_hrs 
IS 'TRAN_PMCM_HRS - PARTIALLY MISSION CAPABLE (PMC) MAINTENANCE HOURS (AIRCRAFT) - The reported hours that an aircraft was capable of performing one or more, but not all, assigned missions, due to one or more of its mission-essential subsystems being inoperative for maintenance reasons.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmcm_user_hrs 
IS 'TRAN_PMCM_USER_HRS - PMCM_USER_HRS - The total number of hours in a partially mission capability maintenance status at the user level during the indicated period'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmcm_int_hrs 
IS 'TRAN_PMCM_INT_HRS - PMCM_INT_HRS - The total number of hours in a partially mission capability maintenance status at the intermediate level during the indicated period'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmcs_hrs 
IS 'TRAN_PMCS_HRS - PARTIALLY MISSION CAPABLE (PMC) SUPPLY HOURS (AIRCRAFT) - The reported hours that an aircraft was capable of performing one or more, but not all, assigned missions, due to one or more of its mission-essential subsystems being inoperative for supply reasons.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmcs_user_hrs 
IS 'TRAN_PMCS_USER_HRS - PMCS_USER_HRS - The total number of hours in a partially mission capability supply status at the user level during the indicated period'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_pmcs_int_hrs 
IS 'TRAN_PMCS_INT_HRS - PMCS_INT_HRS - The total number of hours in a partially mission capability supply status at the intermediate level during the indicated period'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmc_hrs 
IS 'TRAN_NMC_HRS - NMC_HRS - The total number of hours in a not mission capable status durint the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcm_hrs 
IS 'TRAN_NMCM_HRS - NMCM_HRS - The total number of hours in a not mission capable maintenance status durint the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcm_user_hrs 
IS 'TRAN_NMCM_USER_HRS - NMCM_USER_HRS - The total number of hours in a non mission capable maintenance status at the user level during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcm_int_hrs 
IS 'TRAN_NMCM_INT_HRS - NMCM_INT_HRS - The total number of hours in a non mission capable maintenance status at the intermediate level during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcm_dep_hrs 
IS 'TRAN_NMCM_DEP_HRS - NMCM_DEP_HRS - The total number of hours in a non mission capable maintenance status at the depot level during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcs_hrs 
IS 'TRAN_NMCS_HRS - NUMBER OF HOURS NOT MISSION CAPABLE DUE TO SUPPLY - The number of hours that an item is considered not mission capable due to supply.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcs_user_hrs 
IS 'TRAN_NMCS_USER_HRS - NMCS_USER_HRS - The total number of hours in a non mission capable supply status at the user level during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcs_int_hrs 
IS 'TRAN_NMCS_INT_HRS - NMCS_INT_HRS - The total number of hours in a non mission capable supply status at the intermediate level during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_nmcs_dep_hrs 
IS 'TRAN_NMCS_DEP_HRS - NMCS_DEP_HRS - The total number of hours in a non mission capable supply status at the depot level during the indicated period.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_dep_hrs 
IS 'TRAN_DEP_HRS - DEP_HRS - The total number of hours in a non mission capable status at the depot level.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_maint_action_cnt 
IS 'TRAN_MAINT_ACTION_CNT -  The number of maintenance actions that have been identified during this event';
 
COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_operat_readiness_rate 
IS 'TRAN_OPERAT_READINESS_RATE - '; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_operat_cost_per_hour 
IS 'TRAN_OPERAT_COST_PER_HOUR - '; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_cost_parts 
IS 'TRAN_COST_PARTS - PART COST - Part Cost is the product of Quantity Consumed (QTY_CONSM_MAINT) and Current Unit Price (UNIT_PRICE).  Part Cost = (QTY_CONSM_MAINT) X (UNIT_PRICE)'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_cost_manpower 
IS 'TRAN_COST_MANPOWER - MAN-HOUR COST - The man-hour costs for performing the action.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_deferred_maint_items 
IS 'TRAN_DEFERRED_MAINT_ITEMS - '; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_operat_hrs_since_lst_ovhl 
IS 'TRAN_OPERAT_HRS_SINCE_LST_OVHL - Operational hours since last overhaul.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_maint_hrs_since_lst_ovhl 
IS 'TRAN_MAINT_HRS_SINCE_LST_OVHL - Maintenance hours since last overhaul.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.tran_time_since_lst_ovhl 
IS 'TRAN_TIME_SINCE_LST_OVHL - Time since last overhaul.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.notes 
IS 'NOTES - Processing notes from the ETL process.'; 

COMMENT ON COLUMN pfsawh_item_sn_t_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN pfsawh_item_sn_t_fact.etl_processed_by 
IS 'ETL_PROCESSED_BY - Indicates which ETL process is responsible for inserting and maintainfing this record.  This is critically for dealing with records similar in nature to the freeze records.';

/*----- Check to see if the table comment is present -----*/

SELECT   table_name, comments 
FROM     user_tab_comments 
WHERE    table_name = UPPER('pfsawh_item_sn_t_fact'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_item_sn_t_fact') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_item_sn_t_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%defer%')
ORDER BY a.col_name; 
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 
   

