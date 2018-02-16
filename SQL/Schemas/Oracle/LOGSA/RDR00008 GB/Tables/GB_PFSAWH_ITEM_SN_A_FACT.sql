DROP TABLE gb_pfsawh_item_sn_a_fact;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: pfsawh_item_sn_a_fact
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: pfsawh_item_sn_a_fact.sql
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
CREATE TABLE gb_pfsawh_item_sn_a_fact
    (
    rec_id                           NUMBER           NOT NULL ,
-- 
    rec_year                         NUMBER           NOT NULL ,
    year_type                        VARCHAR2(2)      DEFAULT    'CY' ,
    date_id                          NUMBER           NOT NULL , 
    physical_item_id                 NUMBER           NOT NULL ,        
    physical_item_sn_id              NUMBER           NOT NULL ,        
    mimosa_item_sn_id                VARCHAR2(8)      DEFAULT    '00000000' ,        
--    item_date_from_id                NUMBER           NOT NULL ,
--    item_time_from_id                NUMBER           DEFAULT    10001 ,
--    item_date_to_id                  NUMBER           NOT NULL ,
--    item_time_to_id                  NUMBER           DEFAULT    86401 ,
    item_force_id                    NUMBER           DEFAULT    0 , 
    item_location_id                 NUMBER           DEFAULT    0 , 
--
    manufactured_date                DATE ,
--
    item_usage                       NUMBER , 
    item_usage_type                  VARCHAR2(12) ,
-- 
    year_mc_hrs                      NUMBER ,
    year_fmc_hrs                     NUMBER , 
-- 
    year_pmc_hrs                     NUMBER , 
    year_pmcm_hrs                    NUMBER ,
    year_pmcm_user_hrs               NUMBER ,
    year_pmcm_int_hrs                NUMBER ,
    year_pmcs_hrs                    NUMBER ,
    year_pmcs_user_hrs               NUMBER ,
    year_pmcs_int_hrs                NUMBER ,
--
    year_nmc_hrs                     NUMBER ,
    year_nmcm_hrs                    NUMBER ,
    year_nmcm_user_hrs               NUMBER ,
    year_nmcm_int_hrs                NUMBER ,
    year_nmcs_hrs                    NUMBER ,
    year_nmcs_user_hrs               NUMBER ,
    year_nmcs_int_hrs                NUMBER ,
--     
    year_dep_hrs                     NUMBER ,
    year_nmcm_dep_hrs                NUMBER ,
    year_nmcs_dep_hrs                NUMBER , 
--
    year_operat_readiness_rate       NUMBER , 
--
    year_operat_cost_per_hour        NUMBER , 
    year_cost_parts                  NUMBER , 
    year_cost_manpower               NUMBER , 
    year_deferred_maint_items        NUMBER , 
    year_operat_hrs_since_lst_ovhl   NUMBER , 
    year_maint_hrs_since_lst_ovhl    NUMBER , 
    year_time_since_lst_ovhl         NUMBER , 
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
CONSTRAINT pk_item_sn_a_fact PRIMARY KEY 
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

DROP INDEX ixu_pfsawh_item_sn_a_fact;

CREATE UNIQUE INDEX ixu_pfsawh_item_sn_a_fact 
    ON gb_pfsawh_item_sn_a_fact
    (    
    year_type, 
    rec_year,
    physical_item_id, 
    physical_item_sn_id
    );

/*----- Foreign Key -----*/
 
ALTER TABLE gb_pfsawh_item_sn_a_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_a_fact_itm;        

ALTER TABLE gb_pfsawh_item_sn_a_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_a_fact_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);
 
ALTER TABLE gb_pfsawh_item_sn_a_fact  
    DROP CONSTRAINT fk_pfsawh_item_sn_a_fact_itmsn;        

ALTER TABLE gb_pfsawh_item_sn_a_fact  
    ADD CONSTRAINT fk_pfsawh_item_sn_a_fact_itmsn
    FOREIGN KEY (physical_item_id, physical_item_sn_id) 
    REFERENCES gb_pfsawh_item_sn_dim(physical_item_id, physical_item_sn_id);
 
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_item_sn_a_fact  
    DROP CONSTRAINT ck_item_sn_a_fact_ann_typ;        

ALTER TABLE gb_pfsawh_item_sn_a_fact  
    ADD CONSTRAINT ck_item_sn_a_fact_ann_typ 
    CHECK (year_type='CY' OR year_type='FY' OR year_type='OT'  
        );

ALTER TABLE gb_pfsawh_item_sn_a_fact  
    DROP CONSTRAINT ck_item_sn_a_fact_status;        

ALTER TABLE gb_pfsawh_item_sn_a_fact  
    ADD CONSTRAINT ck_item_sn_a_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_sn_a_fact_seq;

CREATE SEQUENCE pfsawh_item_sn_a_fact_seq
    START WITH 1
    MAXVALUE 999999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create the trigger -----*/     

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_item_sn_a_fact 
IS 'PFSAWH_ITEM_SN_A_FACT - This table serves as the annual fact for a particular item/serial number combination.'; 


COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.rec_year 
IS 'REC_YEAR - The year this annual or fiscal record is for.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_type 
IS 'YEAR_TYPE - Allows for different rollups (annual, fiscal, etc.).'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.date_id 
IS 'DATE_ID - Foreign key of the PFSAWH_DATE_DIM table.'; 

--COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_date_from_id 
--IS 'ITEM_DATE_FROM_ID - Start date of the availability report period.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_time_from_id 
--IS 'ITEM_TIME_FROM_ID - Start time of the availability report period.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_date_to_id 
--IS 'ITEM_DATE_TO_ID - End date of the availability report period.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_time_to_id 
--IS 'ITEM_TIME_TO_ID - End time of the availability report period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.';
   
COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 
    
COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_location_id 
IS 'ITEM_LOCATION_ID - Foreign key of the PFSAWH_LOCATION_DIM table.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_force_id 
IS 'ITEM_FORCE_ID - Foreign key of the PFSAWH_FORCE_DIM table.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.manufactured_date 
IS 'MANUFACTURED_DATE  - The date the item was manufactuerd.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_usage 
IS 'ITEM_USAGE - The actual usage of the system/end item accumulated during the period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_usage_type 
IS 'ITEM_USAGE_TYPE - An indicator of the type of usage captured.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.item_days 
--IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

--COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.period_hrs 
--IS 'PERIOD_HRS - The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcm_hrs 
IS 'YEAR_NMCM_HRS - The total number of hours in a not mission capable maintenance status durint the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcm_user_hrs 
IS 'YEAR_NMCM_USER_HRS - The total number of hours in a non mission capable maintenance status at the user level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcm_int_hrs 
IS 'YEAR_NMCM_INT_HRS - The total number of hours in a non mission capable maintenance status at the intermediate level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcm_dep_hrs 
IS 'YEAR_NMCM_DEP_HRS - The total number of hours in a non mission capable maintenance status at the depot level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_fmc_hrs 
IS 'YEAR_FMC_HRS - The total number of hours in a fully mission capable status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcs_hrs 
IS 'YEAR_NMCS_HRS - The total number of hours in a not mission capable supply status durint the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmc_hrs 
IS 'YEAR_PMC_HRS - The total number of hours in a partially mission capable status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmc_hrs 
IS 'YEAR_NMC_HRS - The total number of hours in a not mission capable status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_mc_hrs 
IS 'YEAR_MC_HRS - The total number of hours in a mission capable status (fully or partially) during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcs_user_hrs 
IS 'YEAR_NMCS_USER_HRS - The total number of hours in a non mission capable supply status at the user level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcs_int_hrs 
IS 'YEAR_NMCS_INT_HRS - The total number of hours in a non mission capable supply status at the intermediate level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_nmcs_dep_hrs 
IS 'YEAR_NMCS_DEP_HRS - The total number of hours in a non mission capable supply status at the depot level during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmcm_hrs 
IS 'YEAR_PMCM_HRS - The total number of hours in a partial mission capable maintenance status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmcm_user_hrs 
IS 'YEAR_PMCM_USER_HRS - The total number of hours in a partially mission capability maintenance status at the user level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmcm_int_hrs 
IS 'YEAR_PMCM_INT_HRS - The total number of hours in a partially mission capability maintenance status at the intermediate level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_dep_hrs 
IS 'YEAR_DEP_HRS - The total number of hours in a non mission capable status at the depot level.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmcs_hrs 
IS 'YEAR_PMCS_HRS - The total number of hours in a partial mission capable supply status during the indicated period.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmcs_user_hrs 
IS 'YEAR_PMCS_USER_HRS - The total number of hours in a partially mission capability supply status at the user level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_pmcs_int_hrs 
IS 'YEAR_PMCS_INT_HRS - The total number of hours in a partially mission capability supply status at the intermediate level during the indicated period';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_operat_readiness_rate 
IS 'YEAR_OPERAT_READINESS_RATE - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_operat_cost_per_hour 
IS 'YEAR_OPERAT_COST_PER_HOUR - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_cost_parts 
IS 'YEAR_COST_PARTS - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_cost_manpower 
IS 'YEAR_COST_MANPOWER - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_deferred_maint_items 
IS 'YEAR_DEFERRED_MAINT_ITEMS - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_operat_hrs_since_lst_ovhl 
IS 'YEAR_OPERAT_HRS_SINCE_LST_OVHL - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_maint_hrs_since_lst_ovhl
IS 'YEAR_MAINT_HRS_SINCE_LST_OVHL - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.year_time_since_lst_ovhl 
IS 'YEAR_TIME_SINCE_LST_OVHL - ';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.notes 
IS 'NOTES - Processing notes from the ETL process.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.active_date 
IS 'ACTIVE_DATE - Addition control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.inactive_date 
IS 'INACTIVE_DATE - Addition control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.delete_date 
IS 'DELETE_DATE - Addition control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_item_sn_a_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_item_sn_a_fact'); 

/*----- Check to see if the table column comments are present -----*/

SELECT b.column_id, 
       a.table_name, 
       a.column_name, 
       b.data_type, 
       b.data_length, 
       b.nullable, 
       a.comments 
FROM   user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('GB_pfsawh_item_sn_a_fact') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('GB_pfsawh_item_sn_a_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%manu%')
ORDER BY a.col_name; 
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%manu%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/


BEGIN 

    DELETE gb_pfsawh_item_sn_a_fact;  
   
----- Calendar Year 2000   
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2000' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2000'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2001   
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2001' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2001'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2002   
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2002' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2002'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2003   
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2003' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2003'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2004    
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2004' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2004'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2005    
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2005' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2005'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2006   
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2006' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2006'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, 
        pf.physical_item_id, 
        pf.physical_item_sn_id, 
        pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2007    
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2007' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2007'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Calendar Year 2008     
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'CY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-JAN-2008' )), 
        dd.calendar_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.calendar_year = '2008'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.calendar_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2000     
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-1999' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2000'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2001      
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2000' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2001'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2002     
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2001' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2002'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2003      
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2002' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2003'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2004      
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2003' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2004'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2005      
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2004' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2005'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2006      
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2005' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2006'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2007     
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2006' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2007'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

----- Fiscal Year 2008      
    
    INSERT 
    INTO   gb_pfsawh_item_sn_a_fact 
        (
        year_type,
        date_id, 
        rec_year,
        physical_item_id, 
        physical_item_sn_id,
        mimosa_item_sn_id,
        year_mc_hrs,
        year_fmc_hrs,
        year_pmc_hrs,
        year_pmcm_hrs, 
        year_pmcm_user_hrs, 
        year_pmcm_int_hrs, 
        year_pmcs_hrs, 
        year_pmcs_user_hrs, 
        year_pmcs_int_hrs,  
        year_nmc_hrs,
        year_nmcm_hrs, 
        year_nmcm_user_hrs, 
        year_nmcm_int_hrs, 
        year_nmcs_hrs, 
        year_nmcs_user_hrs, 
        year_nmcs_int_hrs,   
        year_dep_hrs,
        year_nmcm_dep_hrs,
        year_nmcs_dep_hrs  
        )
    SELECT 'FY', 
        (SELECT date_id 
        FROM   gb_pfsawh_date_dim 
        WHERE  oracle_date = TO_CHAR( '01-OCT-2007' )), 
        dd.fiscal_year, 
        pf.physical_item_id, 
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
    FROM   gb_pfsawh_item_sn_p_fact pf, 
           gb_pfsawh_date_dim dd 
    WHERE  dd.fiscal_year = '2008'
        AND pf.item_date_from_id = dd.date_id  
    GROUP BY dd.fiscal_year, pf.physical_item_id, 
        pf.physical_item_sn_id, pf.mimosa_item_sn_id; 
    
    COMMIT;

END; 

/* 

SELECT ft.physical_item_id, ft.physical_item_sn_id, ft.year_type, ft.rec_year 
    , ' | ', ft.* 
FROM   gb_pfsawh_item_sn_a_fact ft
ORDER BY ft.physical_item_id, ft.physical_item_sn_id, ft.year_type, ft.rec_year 

SELECT * 
FROM   gb_pfsawh_item_sn_p_fact
WHERE  physical_item_sn_id = 80763 
ORDER BY item_date_from_id; 

*/ 

/* 

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2000 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-1999') AND TO_DATE('30-SEP-2000')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2001 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2000') AND TO_DATE('30-SEP-2001')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2002 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2001') AND TO_DATE('30-SEP-2002')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2003 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2002') AND TO_DATE('30-SEP-2003')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2004  
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2003') AND TO_DATE('30-SEP-2004')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2005 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2004') AND TO_DATE('30-SEP-2005')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2006 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2005') AND TO_DATE('30-SEP-2006')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2007 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2006') AND TO_DATE('30-SEP-2007')  

UPDATE gb_pfsawh_date_dim 
SET    fiscal_year = 2008 
WHERE  oracle_date BETWEEN TO_DATE('01-OCT-2007') AND TO_DATE('30-SEP-2008')  

COMMIT; 

SELECT fiscal_year 
FROM   gb_pfsawh_date_dim 

*/ 


