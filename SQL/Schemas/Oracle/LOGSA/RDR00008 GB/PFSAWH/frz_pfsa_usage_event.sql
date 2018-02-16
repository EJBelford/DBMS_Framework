/*----- Sequence  -----*/

DROP SEQUENCE frz_pfsa_usage_event_seq;

CREATE SEQUENCE frz_pfsa_usage_event_seq
    START WITH 1
    MINVALUE   1
--    MAXVALUE   9999999
    NOCYCLE
    NOCACHE
    NOORDER; 

/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_usage_event 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: FRZ_PFSA_USAGE_EVENT.sql 
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

DROP TABLE frz_pfsa_maint_work;
    
CREATE TABLE frz_pfsa_usage_event
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
    INSERT_BY                        VARCHAR2(20)   DEFAULT user,
    INSERT_DATE                      DATE           DEFAULT sysdate,
    UPDATE_BY                        VARCHAR2(20),
    UPDATE_DATE                      DATE           DEFAULT '01-JAN-1900',
    DELETE_FLAG                      VARCHAR2(1)    DEFAULT 'N',
    DELETE_DATE                      DATE           DEFAULT '01-JAN-1900',
    HIDDEN_FLAG                      VARCHAR2(1)    DEFAULT 'Y',
    HIDDEN_DATE                      DATE           DEFAULT '01-JAN-1900'
)
TABLESPACE ECPTBS
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

COMMENT ON TABLE FRZ_PFSA_USAGE_EVENT 
IS 'FRZ_PFSA_USAGE_EVENT - This table contains the frozen usage data for the Peformanace Based Agreement (PBA).';


COMMENT ON COLUMN frz_pfsa_usage_event.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_usage_event.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_usage_event.phyiscal_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event.phyiscal_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_usage_event.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.SYS_EI_NIIN 
IS 'SYS_EI_NIIN - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.PFSA_ITEM_ID 
IS 'PFSA_ITEM_ID - A PFSA generated item.  Will contain the serial number of the item if reported by serial number or will contain the uic of the unit reporting the item if reported by uic total.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.RECORD_TYPE 
IS 'RECORD_TYPE - A PFSA generated code to indicate whether the record contains summary information for a readiness period (S) or detailed information (D).  Used to accomodate readiness reportable information which is not captured in some non-standard systems (i.e., PMCS not in AMAC).';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.USAGE_MB 
IS 'USAGE_MB - The measurement base of the associated usage.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.FROM_DT 
IS 'FROM_DT - The beginning date for a historical record.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.USAGE 
IS 'USAGE - The actual usage of the system/end item accumulated during the period.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.TYPE_USAGE 
IS 'TYPE_USAGE - An indicator of the type of usage captured.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.TO_DT 
IS 'TO_DT - The ending date for a historical record.  This is actually the date that the USAGE would be reported on.  It is equal to the corrisponding EVENT_DT_TIME column in the BLD_PFSA_SN_EI_HIST table.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.USAGE_DATE 
IS 'USAGE_DATE - An internally generated PFSA date to group the usage period into the readiness reporting 16th of a month thru the 15th of the next month time periods (next month named).';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.READY_DATE 
IS 'READY_DATE - A specific snap shot of time, midnight of the indicated day.  READY_DATE is a backward looking time component, comprised of all time since midnight of the previous month thru the indicated date.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.DAY_DATE 
IS 'DAY_DATE - A truncated date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.MONTH_DATE 
IS 'MONTH_DATE - A truncated date value representing the entire month forward.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.PFSA_ORG 
IS 'PFSA_ORG - A generic identification of an organization.  Used to both accomodate non-DOD entities as well as ensuring invalid FORCE data is accomodated in joins to gather location/other force information.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.UIC 
IS 'UIC - UNIT IDENTIFICATION CODE (UIC) - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a unit.  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UIC''''s assigned parent unit is defined by HQDA and may be recognized by ''''AA'''' in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive  Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.SYS_EI_SN 
IS 'SYS_EI_SN - A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.ITEM_DAYS 
IS 'ITEM_DAYS - A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.DATA_SRC 
IS 'DATA_SRC - A description of the data source for the record.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.GENIND 
IS 'GENIND - A PFSA internal field used to indicate the number of records generated to develop average monthly usage records aligned to calendar month.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.READING 
IS 'READING - This is the new reading base on the new measurement base factor calculated by the pfsa_usage_mb_conversion procedure based on the origenal measurement base.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.REPORTED_USAGE 
IS 'REPORTED_USAGE - This is the entire usage of the true reporting date.  It is not spread accross the generated records.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.ACTUAL_MB 
IS 'ACTUAL_MB - This is the origenal measurement base.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.ACTUAL_READING 
IS 'ACTUAL_READING - The actual cumulative measurement of usage for the system/end item.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.ACTUAL_USAGE 
IS 'ACTUAL_USAGE - The actual usage of the system/end item.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.ACTUAL_DATA_REC_FLAG 
IS 'ACTUAL_DATA_REC_FLAG - This value will only be T or F.  If the record comes from a "system" then it is true.  If the record is created by a PFSA process then it is false.  Values: T - true, F - false, ? - default.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.PHYSICAL_ITEM_ID 
IS 'ACTUAL_DATA_REC_FLAG - LIW/PFSAWH identitier for the item/part.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.PHYSICAL_ITEM_SN_ID 
IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.FRZ_INPUT_DATE 
IS 'FRZ_INPUT_DATE - This date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.FRZ_INPUT_DATE_ID 
IS 'FRZ_INPUT_DATE_ID - This date_dim id of the date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.rec_frz_flag 
IS 'REC_FRZ_FLAG - Flag indicating if the record is frozen or not.  Values: N - Not frozen, Y - Frozen';

--COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.active_date 
--IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.frz_date 
IS 'FRZ_DATE - Additional control for REC_FRZ_FLAG indicating when the record was frozen.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_PFSA_USAGE_EVENT.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_PFSA_USAGE_EVENT'); 

/*----- Check to see if the table column comments are present -----*/

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_PFSA_USAGE_EVENT') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_PFSA_USAGE_EVENT') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%UIC%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%UIC%'); 
   

/*----- Constraints - Primary Key -----*/ 

ALTER TABLE frz_pfsa_usage_event  
    DROP CONSTRAINT pk_frz_pfsa_usage_event;        

ALTER TABLE frz_pfsa_usage_event 
    ADD (
        CONSTRAINT pk_frz_pfsa_usage_event
        PRIMARY KEY
            (
            pba_id, 
            SYS_EI_NIIN, 
            PFSA_ITEM_ID, 
            RECORD_TYPE, 
            USAGE_MB, 
            FROM_DT
            )
        USING INDEX 
        TABLESPACE ECPTBS
        PCTFREE    10
        INITRANS   2
        MAXTRANS   255
        STORAGE    (
                   INITIAL          512K
                   NEXT             256K
                   MINEXTENTS       1
                   MAXEXTENTS       UNLIMITED
                   PCTINCREASE      0
                   )
       ); 
               
               
/*----- Non Foreign Key Constraints -----*/ 

ALTER TABLE frz_pfsa_usage_event  
    DROP CONSTRAINT idu_frz_pfsa_usage_event;        

ALTER TABLE frz_pfsa_usage_event  
    ADD CONSTRAINT idu_frz_pfsa_usage_event 
    UNIQUE 
        (
        rec_id
        );    


-- 
-- Foreign Key Constraints for Table frz_pfsa_maint_work 
-- 


/*----- Constraints -----*/

ALTER TABLE frz_pfsa_usage_event  
    DROP CONSTRAINT ck_frz_pfsa_usage_event_act_fl;        

ALTER TABLE frz_pfsa_usage_event  
    ADD CONSTRAINT ck_frz_pfsa_usage_event_act_fl 
    CHECK (rec_frz_flag='N' OR rec_frz_flag='Y');

ALTER TABLE frz_pfsa_usage_event  
    DROP CONSTRAINT ck_frz_pfsa_usage_event_del_fl;        

ALTER TABLE frz_pfsa_usage_event  
    ADD CONSTRAINT ck_frz_pfsa_usage_event_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE frz_pfsa_usage_event  
    DROP CONSTRAINT ck_frz_pfsa_usage_event_hd_fl;       

ALTER TABLE frz_pfsa_usage_event  
    ADD CONSTRAINT ck_frz_pfsa_usage_event_hd_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE frz_pfsa_usage_event  
    DROP CONSTRAINT ck_frz_pfsa_usage_event_status;        

ALTER TABLE frz_pfsa_usage_event  
    ADD CONSTRAINT ck_frz_pfsa_usage_event_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Indexs -----*/

/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM frz_pfsa_usage_event FOR pfsaw.frz_pfsa_usage_event; 

/*----- Grants-----*/

GRANT SELECT ON frz_pfsa_usage_event TO LIW_BASIC; 

GRANT SELECT ON frz_pfsa_usage_event TO LIW_RESTRICTED; 

GRANT SELECT ON frz_pfsa_usage_event TO S_PFSAW; 

-- GRANT SELECT ON frz_pfsa_usage_event TO MD2L043; 

-- GRANT SELECT ON frz_pfsa_usage_event TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON frz_pfsa_usage_event TO S_PBUSE; 

-- GRANT SELECT ON frz_pfsa_usage_event TO S_WEBPROP; 

GRANT SELECT ON frz_pfsa_usage_event TO C_PFSAW; 


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM xx_pfsawh_blank_dim a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    SELECT 
    DISTINCT fue.sys_ei_niin 
    FROM   frz_pfsa_usage_event fue; 
    
    SELECT fue.* 
    FROM   frz_pfsa_usage_event fue; 
    
    SELECT ir.pba_id, 
           pme.sys_ei_niin, pme.maint_ev_id AS pme_maint_ev_id, 
           pmt.maint_task_id AS pmt_maint_task_id, 
           pmi.*   
    FROM   pfsa_maint_work pmi, 
           pfsa_maint_event pme, 
           pfsa_maint_task pmt, 
           pfsa_pba_items_ref ir 
    WHERE  pme.sys_ei_niin = ir.item_type_value
        AND pme.maint_ev_id = pmt.maint_ev_id 
        AND pmt.maint_ev_id = pmi.maint_ev_id 
        AND pmt.maint_task_id = pmi.maint_task_id;
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.xx_ID || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT * FROM frz_pfsa_usage_event; 

*/
