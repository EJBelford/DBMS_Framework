/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_equip_avail 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_equip_avail.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 10 April 2008 
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
-- 10APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Create table  -----*/

-- DROP TABLE frz_pfsa_equip_avail;
    
CREATE TABLE frz_pfsa_equip_avail
(
    rec_id                           NUMBER         NOT NULL, 
    source_rec_id                    NUMBER         DEFAULT  0, 
---    
    pba_id                           NUMBER         DEFAULT '1000000', 
    physical_item_id                 NUMBER         DEFAULT  0,
    physical_item_sn_id              NUMBER         DEFAULT  0,
    force_unit_id                    NUMBER         DEFAULT  0,
    mimosa_item_sn_id                VARCHAR2(8)    DEFAULT '00000000',
--    
    SYS_EI_NIIN    VARCHAR2(9)                      NOT NULL,
    PFSA_ITEM_ID   VARCHAR2(20)                     NOT NULL,
    RECORD_TYPE    VARCHAR2(1)                      NOT NULL,
    FROM_DT        DATE                             NOT NULL,
    TO_DT          DATE,
    READY_DATE     DATE                             NOT NULL,
    DAY_DATE       DATE,
    MONTH_DATE     DATE,
    PFSA_ORG       VARCHAR2(32),
    SYS_EI_SN      VARCHAR2(32),
    ITEM_DAYS      NUMBER,
    PERIOD_HRS     NUMBER,
    NMCM_HRS       NUMBER,
    NMCS_HRS       NUMBER,
    NMC_HRS        NUMBER,
    FMC_HRS        NUMBER,
    PMC_HRS        NUMBER,
    MC_HRS         NUMBER,
    NMCM_USER_HRS  NUMBER,
    NMCM_INT_HRS   NUMBER,
    NMCM_DEP_HRS   NUMBER,
    NMCS_USER_HRS  NUMBER,
    NMCS_INT_HRS   NUMBER,
    NMCS_DEP_HRS   NUMBER,
    PMCM_HRS       NUMBER,
    PMCS_HRS       NUMBER,
    SOURCE_ID      VARCHAR2(20 BYTE),
    PMCS_USER_HRS  NUMBER,
    PMCS_INT_HRS   NUMBER,
    PMCM_USER_HRS  NUMBER,
    PMCM_INT_HRS   NUMBER,
    DEP_HRS        NUMBER,
    HEIR_ID        VARCHAR2(20 BYTE),
    PRIORITY       NUMBER,
    UIC            VARCHAR2(6 BYTE),
    GRAB_STAMP     DATE,
    PROC_STAMP     DATE,
    SYS_EI_UID     VARCHAR2(78 BYTE), 
--    
    STATUS         VARCHAR2(1 BYTE),
    LST_UPDT       DATE,
    UPDT_BY        VARCHAR2(30 BYTE), 
--
    frz_input_date                   DATE,
    frz_input_date_id                NUMBER,
    rec_frz_flag                     VARCHAR2(1)         DEFAULT 'N',
    frz_date                         DATE                DEFAULT '31-DEC-2099',
--
    insert_by                        VARCHAR2(30)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(30)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_by                        VARCHAR2(30)        NULL ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' , 
    hidden_by                        VARCHAR2(30)        NULL  
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512K
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

COMMENT ON TABLE frz_pfsa_equip_avail 
IS 'FRZ_PFSA_EQUIP_AVAIL - This table serves as the staging point for processing equip avail data.  Data is placed into the table from production amac, readiness as well as legacy (wolf) maintenance data processing';


COMMENT ON COLUMN frz_pfsa_equip_avail.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_equip_avail.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_equip_avail.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_equip_avail.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_equip_avail.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_equip_avail.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_equip_avail.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_equip_avail.GRAB_STAMP 
IS 'GRAB_STAMP - The sysdate of the time the grab procedure that populated the table was executed.';

COMMENT ON COLUMN frz_pfsa_equip_avail.PROC_STAMP 
IS 'PROC_STAMP - The sysdate of the time the process procedure was executed.';

COMMENT ON COLUMN frz_pfsa_equip_avail.SYS_EI_UID 
IS 'SYS_EI_UID - The Department of Defense unique identifier for the system end item.';

COMMENT ON COLUMN frz_pfsa_equip_avail.SYS_EI_NIIN 
IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN frz_pfsa_equip_avail.PFSA_ITEM_ID 
IS 'PFSA_ITEM_ID - A PFSA generated item.  Will contain the serial number of the item if reported by serial number or will contain the uic of the unit reporting the item if reported by uic total.';

COMMENT ON COLUMN frz_pfsa_equip_avail.RECORD_TYPE 
IS 'RECORD_TYPE - A PFSA generated code to indicate whether the record contains summary information for a readiness period (''S'') or detailed information (''D'').  Used to accomodate readiness reportable information which is not captured in some non-standard systems (i.e., PMCS not in AMAC)';

COMMENT ON COLUMN frz_pfsa_equip_avail.FROM_DT 
IS 'FROM DATE - The beginning date for a historical record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.TO_DT 
IS 'TO DATE - The ending date for a historical record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.READY_DATE 
IS 'READY_DATE - A internally generated PFSA date to group the usage period into the readiness reporting 16th of a month thru the 15th of the next month time periods (next month named)';

COMMENT ON COLUMN frz_pfsa_equip_avail.DAY_DATE 
IS 'DAY_DATE - A trunced date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level. ';

COMMENT ON COLUMN frz_pfsa_equip_avail.MONTH_DATE 
IS 'MONTH_DATE - A truncated date value representing the entire month forward';

COMMENT ON COLUMN frz_pfsa_equip_avail.PFSA_ORG 
IS 'PFSA_ORG - A generic identification of an organization.  Used to both accomodate non-DOD entities as well as ensuring invalid FORCE data is accomodated in joins to gather location/other force information.';

COMMENT ON COLUMN frz_pfsa_equip_avail.SYS_EI_SN 
IS 'SERIAL NUMBER - A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN frz_pfsa_equip_avail.ITEM_DAYS 
IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data';

COMMENT ON COLUMN frz_pfsa_equip_avail.PERIOD_HRS 
IS 'PERIOD_HRS - The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCM_HRS 
IS 'NMCM_HRS - The total number of hours in a not mission capable maintenance status durint the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCS_HRS 
IS 'NMCS_HRS - The total number of hours in a not mission capable supply status durint the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMC_HRS 
IS 'NMC_HRS - The total number of hours in a not mission capable status during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.FMC_HRS 
IS 'FMC_HRS - The total number of hours in a fully mission capable status during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMC_HRS 
IS 'PMC_HRS - The total number of hours in a partially mission capable status during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.MC_HRS 
IS 'MC_HRS - The total number of hours in a mission capable status (fully or partially) during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCM_USER_HRS 
IS 'NMCM_USER_HRS - The total number of hours in a non mission capable maintenance status at the user level during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCM_INT_HRS 
IS 'NMCM_INT_HRS - The total number of hours in a non mission capable maintenance status at the intermediate level during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCM_DEP_HRS 
IS 'NMCM_DEP_HRS - The total number of hours in a non mission capable maintenance status at the depot level during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCS_USER_HRS 
IS 'NMCS_USER_HRS - The total number of hours in a non mission capable supply status at the user level during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCS_INT_HRS 
IS 'NMCS_INT_HRS - The total number of hours in a non mission capable supply status at the intermediate level during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.NMCS_DEP_HRS 
IS 'NMCS_DEP_HRS - The total number of hours in a non mission capable supply status at the depot level during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMCM_HRS 
IS 'PMCM_HRS - The total number of hours in a partial mission capable maintenance status during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMCS_HRS 
IS 'PMCS_HRS - The total number of hours in a partial mission capable supply status during the indicated period.';

COMMENT ON COLUMN frz_pfsa_equip_avail.SOURCE_ID 
IS 'SOURCE_ID - A description of the data source for the record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMCS_USER_HRS 
IS 'PMCS_USER_HRS - The total number of hours in a partially mission capability supply status at the user level during the indicated period';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMCS_INT_HRS 
IS 'PMCS_INT_HRS - The total number of hours in a partially mission capability supply status at the intermediate level during the indicated period';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMCM_USER_HRS 
IS 'PMCM_USER_HRS - The total number of hours in a partially mission capability maintenance status at the user level during the indicated period';

COMMENT ON COLUMN frz_pfsa_equip_avail.PMCM_INT_HRS 
IS 'PMCM_INT_HRS - The total number of hours in a partially mission capability maintenance status at the intermediate level during the indicated period';

COMMENT ON COLUMN frz_pfsa_equip_avail.DEP_HRS 
IS 'DEP_HRS - The total number of hours in a non mission capable status at the depot level.';

COMMENT ON COLUMN frz_pfsa_equip_avail.HEIR_ID 
IS 'HEIR_ID - A PFSA team generated identifier of the data source.  It is similar to the SOURCE_ID and is the same except in cases where more specific source identifiers are used, e.g., the identification of a specific box as in the CPME and AMAC data.';

COMMENT ON COLUMN frz_pfsa_equip_avail.PRIORITY 
IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN frz_pfsa_equip_avail.uic  
IS 'UNIT IDENTIFICATION CODE - The Unit Identification Code (UIC) is a six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a "unit."  The UIC is issued by the HQDA DCSOPS.  The UICs assigned parent unit is defined by HQDA and may be recognized by "AA" in the last two characters of the UIC.';

COMMENT ON COLUMN frz_pfsa_equip_avail.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN frz_pfsa_equip_avail.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN frz_pfsa_equip_avail.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.FRZ_INPUT_DATE 
IS 'FRZ_INPUT_DATE - ';

COMMENT ON COLUMN frz_pfsa_equip_avail.FRZ_INPUT_DATE_ID 
IS 'FRZ_INPUT_DATE_ID - ';

COMMENT ON COLUMN frz_pfsa_equip_avail.rec_frz_flag 
IS 'REC_FRZ_FLAG - Flag indicating if the record is frozen or not.  Values: N - Not frozen, Y - Frozen';

COMMENT ON COLUMN frz_pfsa_equip_avail.frz_date 
IS 'FRZ_DATE - Additional control for REC_FRZ_FLAG indicating when the record was frozen.';

COMMENT ON COLUMN frz_pfsa_equip_avail.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_equip_avail.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_equip_avail.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_equip_avail.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_equip_avail.DELETE_by 
IS 'DELETE_BY - Reports who deleted the record.';

COMMENT ON COLUMN frz_pfsa_equip_avail.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_equip_avail.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN frz_pfsa_equip_avail.HIDDEN_by 
IS 'HIDDEN_BY - Reports who last hide the record.';

/*----- Check to see if the table comment is present -----*/

-- SELECT table_name, comments 
-- FROM   user_tab_comments 
-- WHERE  table_name = UPPER('frz_pfsa_equip_avail'); 

/*----- Check to see if the table column comments are present -----*/
/*
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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_equip_avail') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_equip_avail') 
ORDER BY b.column_id; 
*/
/*----- Look-up field description from master LIDB table -----*/
/*
SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%UIC%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%UIC%'); 
*/   

