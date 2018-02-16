DROP TABLE gb_pfsawh_item_sn_l_fact;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: pfsawh_item_sn_a_fact
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: pfsawh_item_sn_a_fact.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 12 February 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES: 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
CREATE TABLE gb_pfsawh_item_sn_l_fact
    (
    rec_id                           NUMBER           NOT NULL ,
-- 
    physical_item_id                 NUMBER           NOT NULL ,        
    physical_item_sn_id              NUMBER           NOT NULL ,        
    mimosa_item_sn_id                VARCHAR2(8)      DEFAULT    '00000000' ,        
--    item_date_from_id                NUMBER           NOT NULL ,
--    item_time_from_id                NUMBER           DEFAULT    10001 ,
--    item_date_to_id                  NUMBER           NOT NULL ,
--    item_time_to_id                  NUMBER           DEFAULT    86401 ,
    item_force_id                    NUMBER           DEFAULT    -3 , 
    item_location_id                 NUMBER           DEFAULT    -3 , 
--
    manufactured_date                DATE             DEFAULT    '01-JAN-1900' ,
--
    item_usage                       NUMBER           DEFAULT    -3  , 
    item_usage_type                  VARCHAR2(12)     DEFAULT    '-3'  ,
-- 
    life_mc_hrs                      NUMBER ,
    life_fmc_hrs                     NUMBER , 
-- 
    life_pmc_hrs                     NUMBER , 
    life_pmcm_hrs                    NUMBER ,
    life_pmcm_user_hrs               NUMBER ,
    life_pmcm_int_hrs                NUMBER ,
    life_pmcs_hrs                    NUMBER ,
    life_pmcs_user_hrs               NUMBER ,
    life_pmcs_int_hrs                NUMBER ,
-- 
    life_nmc_hrs                     NUMBER ,
    life_nmcm_hrs                    NUMBER ,
    life_nmcm_user_hrs               NUMBER ,
    life_nmcm_int_hrs                NUMBER ,
    life_nmcs_hrs                    NUMBER ,
    life_nmcs_user_hrs               NUMBER ,
    life_nmcs_int_hrs                NUMBER , 
--
    life_dep_hrs                     NUMBER ,
    life_nmcm_dep_hrs                NUMBER ,
    life_nmcs_dep_hrs                NUMBER ,
--
    life_operat_readiness_rate       NUMBER , 
--
    life_operat_cost_per_hour        NUMBER , 
    life_cost_parts                  NUMBER , 
    life_cost_manpower               NUMBER , 
    life_deferred_maint_items        NUMBER , 
    life_operat_hrs_since_lst_ovhl   NUMBER , 
    life_maint_hrs_since_lst_ovhl    NUMBER , 
    life_time_since_lst_ovhl         NUMBER , 
--
    status                           VARCHAR2(1)    DEFAULT    'C' ,
    updt_by                          VARCHAR2(30)   DEFAULT    USER ,
    lst_updt                         DATE           DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)    DEFAULT    'Y' , 
    active_date                      DATE           DEFAULT    '01-JAN-1900' , 
    inactive_date                    DATE           DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)   DEFAULT    USER , 
    insert_date                      DATE           DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)   NULL ,
    update_date                      DATE           DEFAULT    '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)    DEFAULT    'N' ,
    delete_date                      DATE           DEFAULT    '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)    DEFAULT    'Y' ,
    hidden_date                      DATE           DEFAULT    '01-JAN-1900' ,
    notes                            VARCHAR2(255)  DEFAULT    '' ,
CONSTRAINT pk_item_sn_l_fact PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_item_sn_l_fact;

CREATE UNIQUE INDEX ixu_pfsawh_item_sn_l_fact 
    ON gb_pfsawh_item_sn_l_fact
    (    
    physical_item_id, 
    physical_item_sn_id
    );

/*----- Foreign Key -----*/
 
ALTER TABLE gb_pfsawh_item_sn_l_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_l_fact_itm;        

ALTER TABLE gb_pfsawh_item_sn_l_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_l_fact_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);
 
ALTER TABLE gb_pfsawh_item_sn_l_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_l_fact_itmsn;        

ALTER TABLE gb_pfsawh_item_sn_l_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_l_fact_itmsn
    FOREIGN KEY (physical_item_id, physical_item_sn_id) 
    REFERENCES gb_pfsawh_item_sn_dim(physical_item_id, physical_item_sn_id);
 
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_item_sn_l_fact  
    DROP CONSTRAINT ck_item_sn_a_fact_status;        

ALTER TABLE gb_pfsawh_item_sn_l_fact  
    ADD CONSTRAINT ck_item_sn_l_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_sn_l_fact_seq;

CREATE SEQUENCE pfsawh_item_sn_l_fact_seq
    START WITH 1
    MAXVALUE 999999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_item_sn_l_fact 
IS 'PFSAWH_ITEM_SN_L_FACT - This table serves as the lifetime fact for a particular item/serial number combination.'; 


COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

--COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_date_from_id 
--IS 'ITEM_DATE_FROM_ID - Start date of the availability report period.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_time_from_id 
--IS 'ITEM_TIME_FROM_ID - Start time of the availability report period.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_date_to_id 
--IS 'ITEM_DATE_TO_ID - End date of the availability report period.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_time_to_id 
--IS 'ITEM_TIME_TO_ID - End time of the availability report period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.';
   
COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 
    
COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_location_id 
IS 'ITEM_LOCATION_ID - Foreign key of the PFSAWH_LOCATION_DIM table.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_force_id 
IS 'ITEM_FORCE_ID - Foreign key of the PFSAWH_FORCE_DIM table.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.manufactured_date 
IS 'MANUFACTURED_DATE  - The date the item was manufactuerd.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_usage 
IS 'ITEM_USAGE - The actual usage of the system/end item accumulated during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_usage_type 
IS 'ITEM_USAGE_TYPE - An indicator of the type of usage captured.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.item_days 
--IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.period_hrs 
--IS 'PERIOD_HRS - The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcm_hrs 
IS 'LIFE_NMCM_HRS - The total number of hours in a not mission capable maintenance status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcm_user_hrs 
IS 'LIFE_NMCM_USER_HRS - The total number of hours in a non mission capable maintenance status at the user level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcm_int_hrs 
IS 'LIFE_NMCM_INT_HRS - The total number of hours in a non mission capable maintenance status at the intermediate level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcm_dep_hrs 
IS 'LIFE_NMCM_DEP_HRS - The total number of hours in a non mission capable maintenance status at the depot level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_fmc_hrs 
IS 'LIFE_FMC_HRS - The total number of hours in a fully mission capable status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcs_hrs 
IS 'LIFE_NMCS_HRS - The total number of hours in a not mission capable supply status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmc_hrs 
IS 'LIFE_PMC_HRS - The total number of hours in a partially mission capable status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmc_hrs 
IS 'LIFE_NMC_HRS - The total number of hours in a not mission capable status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_mc_hrs 
IS 'LIFE_MC_HRS - The total number of hours in a mission capable status (fully or partially) during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcs_user_hrs 
IS 'LIFE_NMCS_USER_HRS - The total number of hours in a non mission capable supply status at the user level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcs_int_hrs 
IS 'LIFE_NMCS_INT_HRS - The total number of hours in a non mission capable supply status at the intermediate level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_nmcs_dep_hrs 
IS 'LIFE_NMCS_DEP_HRS - The total number of hours in a non mission capable supply status at the depot level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmcm_hrs 
IS 'LIFE_PMCM_HRS - The total number of hours in a partial mission capable maintenance status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmcm_user_hrs 
IS 'LIFE_PMCM_USER_HRS - The total number of hours in a partially mission capability maintenance status at the user level during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmcm_int_hrs 
IS 'LIFE_PMCM_INT_HRS - The total number of hours in a partially mission capability maintenance status at the intermediate level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_dep_hrs 
IS 'LIFE_PMCM_INT_HRS - The total number of hours in a non mission capable status at the depot level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmcs_hrs 
IS 'LIFE_PMCS_HRS - The total number of hours in a partial mission capable supply status during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmcs_user_hrs 
IS 'LIFE_PMCS_USER_HRS - The total number of hours in a partially mission capability supply status at the user level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_pmcs_int_hrs 
IS 'LIFE_PMCS_INT_HRS - The total number of hours in a partially mission capability supply status at the intermediate level during its lifetime.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_operat_readiness_rate 
IS 'LIFE_OPERAT_READINESS_RATE -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_operat_cost_per_hour 
IS 'LIFE_OPERAT_COST_PER_HOUR -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_cost_parts 
IS 'LIFE_COST_PARTS -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_cost_manpower 
IS 'LIFE_COST_PARTS -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_deferred_maint_items 
IS 'LIFE_DEFERRED_MAINT_ITEMS -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_operat_hrs_since_lst_ovhl 
IS 'LIFE_OPERAT_HRS_SINCE_LST_OVHL -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_maint_hrs_since_lst_ovhl
IS 'LIFE_MAINT_HRS_SINCE_LST_OVHL -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.life_time_since_lst_ovhl 
IS 'LIFE_TIME_SINCE_LST_OVHL -  during its lifetime';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.notes 
IS 'NOTES - Processing notes from the ETL process.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.active_date 
IS 'ACTIVE_DATE - Addition control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.inactive_date 
IS 'INACTIVE_DATE - Addition control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.delete_date 
IS 'DELETE_DATE - Addition control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_item_sn_l_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_item_sn_l_fact'); 

/*----- Check to see if the table column comments are present -----*/

SELECT b.column_id, 
       a.table_name, 
       a.column_name, 
       b.data_type, 
       b.data_length, 
       b.nullable, 
       a.comments 
FROM   user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_item_sn_l_fact') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_item_sn_l_fact');  
ORDER BY b.column_id 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%defer%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

BEGIN 

    DELETE gb_pfsawh_item_sn_l_fact;  
    
    INSERT 
    INTO   gb_pfsawh_item_sn_l_fact 
        (
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        life_mc_hrs,
        life_fmc_hrs,
        life_pmc_hrs,
        life_pmcm_hrs, 
        life_pmcm_user_hrs, 
        life_pmcm_int_hrs, 
        life_pmcs_hrs, 
        life_pmcs_user_hrs, 
        life_pmcs_int_hrs,  
        life_nmc_hrs,
        life_nmcm_hrs, 
        life_nmcm_user_hrs, 
        life_nmcm_int_hrs, 
        life_nmcs_hrs, 
        life_nmcs_user_hrs, 
        life_nmcs_int_hrs,   
        life_dep_hrs,
        life_nmcm_dep_hrs,
        life_nmcs_dep_hrs  
        )
    SELECT pf.physical_item_id, 
        pf.physical_item_sn_id, 
        pf.mimosa_item_sn_id, 
        SUM(NVL(pf.mc_hrs, 0)) , 
        SUM(NVL(pf.fmc_hrs, 0)) , 
        SUM(NVL(pf.pmc_hrs, 0)) , 
        SUM(NVL(pf.pmcm_hrs, 0)) , 
        SUM(NVL(pf.pmcm_user_hrs, 0)) , 
        SUM(NVL(pf.pmcm_int_hrs, 0)) , 
        SUM(NVL(pf.pmcs_hrs, 0)) , 
        SUM(NVL(pf.pmcs_user_hrs, 0)) , 
        SUM(NVL(pf.pmcs_int_hrs, 0)) , 
        SUM(NVL(pf.nmc_hrs, 0)) ,
        SUM(NVL(pf.nmcm_hrs, 0)) , 
        SUM(NVL(pf.nmcm_user_hrs, 0)) , 
        SUM(NVL(pf.nmcm_int_hrs, 0)) , 
        SUM(NVL(pf.nmcs_hrs, 0)) , 
        SUM(NVL(pf.nmcs_user_hrs, 0)) , 
        SUM(NVL(pf.nmcs_int_hrs, 0)) ,   
        SUM(NVL(pf.dep_hrs, 0)) ,
        SUM(NVL(pf.nmcm_dep_hrs, 0)) ,
        SUM(NVL(pf.nmcs_dep_hrs, 0)) 
    FROM   gb_pfsawh_item_sn_p_fact pf
    GROUP BY pf.physical_item_id, 
        pf.physical_item_sn_id, 
        pf.mimosa_item_sn_id; 
    
    COMMIT;

END; 

/* 

SELECT * 
FROM   gb_pfsawh_item_sn_l_fact
ORDER BY physical_item_id, physical_item_sn_id; 

SELECT * 
FROM   gb_pfsawh_item_sn_p_fact; 

*/
