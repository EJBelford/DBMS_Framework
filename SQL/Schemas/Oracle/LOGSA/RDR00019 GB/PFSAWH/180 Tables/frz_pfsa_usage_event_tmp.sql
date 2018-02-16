/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_usage_event_tmp 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_usage_event_tmp.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 22 April 2008 
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
-- 22APR08 - GB  - RDR00008 -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Create Table  -----*/

-- DROP TABLE frz_pfsa_usage_event_tmp;
    
CREATE TABLE frz_pfsa_usage_event_tmp
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
    SYS_EI_NIIN                      VARCHAR2(9)    NOT NULL,
    PFSA_ITEM_ID                     VARCHAR2(20)   NOT NULL,
    RECORD_TYPE                      VARCHAR2(1)    NOT NULL,
    USAGE_MB                         VARCHAR2(2)    NOT NULL,
    FROM_DT                          DATE           NOT NULL,
    USAGE                            NUMBER,
    TYPE_USAGE                       VARCHAR2(12),
    TO_DT                            DATE,
    USAGE_DATE                       DATE,
    READY_DATE                       DATE,
    DAY_DATE                         DATE,
    MONTH_DATE                       DATE,
    PFSA_ORG                         VARCHAR2(32),
    UIC                              VARCHAR2(6),
    SYS_EI_SN                        VARCHAR2(32),
    ITEM_DAYS                        NUMBER,
    DATA_SRC                         VARCHAR2(20),
    GENIND                           NUMBER, 
--    
    LST_UPDT                         DATE,
    UPDT_BY                          VARCHAR2(30),
    STATUS                           VARCHAR2(1), 
--     
    READING                          NUMBER,
    REPORTED_USAGE                   NUMBER,
    ACTUAL_MB                        VARCHAR2(2),
    ACTUAL_READING                   NUMBER,
    ACTUAL_USAGE                     NUMBER,
    ACTUAL_DATA_REC_FLAG             VARCHAR2(1)    DEFAULT '?',
    PHYSICAL_ITEM_ID                 NUMBER,
    PHYSICAL_ITEM_SN_ID              NUMBER,
    FRZ_INPUT_DATE                   DATE,
    FRZ_INPUT_DATE_ID                NUMBER, 
--     
    rec_frz_flag                     VARCHAR2(1)    DEFAULT 'N' , 
--    active_date                      DATE           DEFAULT '01-JAN-1900' , 
    frz_date                         DATE           DEFAULT '31-DEC-2099' ,
--    
    INSERT_BY                        VARCHAR2(30)   DEFAULT user,
    INSERT_DATE                      DATE           DEFAULT sysdate,
    UPDATE_BY                        VARCHAR2(30),
    UPDATE_DATE                      DATE           DEFAULT '01-JAN-1900',
    DELETE_FLAG                      VARCHAR2(1)    DEFAULT 'N',
    DELETE_DATE                      DATE           DEFAULT '01-JAN-1900',
    HIDDEN_FLAG                      VARCHAR2(1)    DEFAULT 'Y',
    HIDDEN_DATE                      DATE           DEFAULT '01-JAN-1900',
    DELETE_BY                        VARCHAR2(30 BYTE),
    HIDDEN_BY                        VARCHAR2(30 BYTE)
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

COMMENT ON TABLE frz_pfsa_usage_event_tmp 
IS 'frz_pfsa_usage_event_tmp - This table contains the frozen usage data for the Peformanace Based Agreement (PBA).';


COMMENT ON COLUMN frz_pfsa_usage_event_tmp.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_usage_event_tmp.phyiscal_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.phyiscal_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.SYS_EI_NIIN 
IS 'SYS_EI_NIIN - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.PFSA_ITEM_ID 
IS 'PFSA_ITEM_ID - A PFSA generated item.  Will contain the serial number of the item if reported by serial number or will contain the uic of the unit reporting the item if reported by uic total.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.RECORD_TYPE 
IS 'RECORD_TYPE - A PFSA generated code to indicate whether the record contains summary information for a readiness period (S) or detailed information (D).  Used to accomodate readiness reportable information which is not captured in some non-standard systems (i.e., PMCS not in AMAC).';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.USAGE_MB 
IS 'USAGE_MB - The measurement base of the associated usage.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.FROM_DT 
IS 'FROM_DT - The beginning date for a historical record.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.USAGE 
IS 'USAGE - The actual usage of the system/end item accumulated during the period.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.TYPE_USAGE 
IS 'TYPE_USAGE - An indicator of the type of usage captured.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.TO_DT 
IS 'TO_DT - The ending date for a historical record.  This is actually the date that the USAGE would be reported on.  It is equal to the corrisponding EVENT_DT_TIME column in the BLD_PFSA_SN_EI_HIST table.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.USAGE_DATE 
IS 'USAGE_DATE - An internally generated PFSA date to group the usage period into the readiness reporting 16th of a month thru the 15th of the next month time periods (next month named).';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.READY_DATE 
IS 'READY_DATE - A specific snap shot of time, midnight of the indicated day.  READY_DATE is a backward looking time component, comprised of all time since midnight of the previous month thru the indicated date.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.DAY_DATE 
IS 'DAY_DATE - A truncated date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.MONTH_DATE 
IS 'MONTH_DATE - A truncated date value representing the entire month forward.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.PFSA_ORG 
IS 'PFSA_ORG - A generic identification of an organization.  Used to both accomodate non-DOD entities as well as ensuring invalid FORCE data is accomodated in joins to gather location/other force information.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.UIC 
IS 'UIC - UNIT IDENTIFICATION CODE (UIC) - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a unit.  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UIC''''s assigned parent unit is defined by HQDA and may be recognized by ''''AA'''' in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive  Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.SYS_EI_SN 
IS 'SYS_EI_SN - A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.ITEM_DAYS 
IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.DATA_SRC 
IS 'DATA_SRC - A description of the data source for the record.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.GENIND 
IS 'GENIND - A PFSA internal field used to indicate the number of records generated to develop average monthly usage records aligned to calendar month.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.READING 
IS 'READING - This is the new reading base on the new measurement base factor calculated by the pfsa_usage_mb_conversion procedure based on the origenal measurement base.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.REPORTED_USAGE 
IS 'REPORTED_USAGE - This is the entire usage of the true reporting date.  It is not spread accross the generated records.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.ACTUAL_MB 
IS 'ACTUAL_MB - This is the origenal measurement base.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.ACTUAL_READING 
IS 'ACTUAL_READING - The actual cumulative measurement of usage for the system/end item.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.ACTUAL_USAGE 
IS 'ACTUAL_USAGE - The actual usage of the system/end item.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.ACTUAL_DATA_REC_FLAG 
IS 'ACTUAL_DATA_REC_FLAG - This value will only be T or F.  If the record comes from a "system" then it is true.  If the record is created by a PFSA process then it is false.  Values: T - true, F - false, ? - default.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.PHYSICAL_ITEM_ID 
IS 'ACTUAL_DATA_REC_FLAG - LIW/PFSAWH identitier for the item/part.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.PHYSICAL_ITEM_SN_ID 
IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.FRZ_INPUT_DATE 
IS 'FRZ_INPUT_DATE - This date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.FRZ_INPUT_DATE_ID 
IS 'FRZ_INPUT_DATE_ID - This date_dim id of the date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.rec_frz_flag 
IS 'REC_FRZ_FLAG - Flag indicating if the record is frozen or not.  Values: N - Not frozen, Y - Frozen';

--COMMENT ON COLUMN frz_pfsa_usage_event_tmp.active_date 
--IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.frz_date 
IS 'FRZ_DATE - Additional control for REC_FRZ_FLAG indicating when the record was frozen.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.delete_by 
IS 'DELETE_BY - Addition information for DELETE_FLAG indicating who deleted the record.';

COMMENT ON COLUMN frz_pfsa_usage_event_tmp.hidden_by  
IS 'HIDDEN_BY - Addition information for HIDDEN_FLAG indicating who hidden the record.';

/*----- Check to see if the table comment is present -----*/

--SELECT table_name, comments 
--FROM   user_tab_comments 
--WHERE  table_name = UPPER('frz_pfsa_usage_event_tmp'); 

/*----- Check to see if the table column comments are present -----*/

--SELECT  b.column_id, 
--        a.table_name, 
--        a.column_name, 
--        b.data_type, 
--        b.data_length, 
--        b.nullable, 
--        b.data_default,  
--        a.comments 
----        , '|', b.*  
--FROM    user_col_comments a
--LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_usage_event_tmp') 
--    AND  a.column_name = b.column_name
--WHERE    a.table_name = UPPER('frz_pfsa_usage_event_tmp') 
--ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

--SELECT a.* 
--FROM   lidb_cmnt@pfsawh.lidbdev a
--WHERE  a.col_name LIKE UPPER('%UIC%')
--ORDER BY a.col_name;  
--   
--SELECT a.* 
--FROM   user_col_comments a
--WHERE  a.column_name LIKE UPPER('%UIC%'); 
   

