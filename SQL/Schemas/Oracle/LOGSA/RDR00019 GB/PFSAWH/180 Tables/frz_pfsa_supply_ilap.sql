/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_supply_ilap 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_supply_ilap.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 15 May 2008 
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
-- 15MAY08 - GB  -          -      - Created 
-- 23JUN08 - GB  -          -      - Convert to frz_pfsa_supply_ilap from 
--                                       pfsa_supply_ilap 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

-- DROP TABLE frz_pfsa_supply_ilap;   

CREATE TABLE frz_pfsa_supply_ilap   
    (
    rec_id               number                   not null,
    pba_id               number                   default 1000000,
    docno                varchar2(14 byte),
    ric_stor             varchar2(3 byte),
    ipg                  varchar2(1 byte),
    pniin                varchar2(11 byte),
    iss_niin             varchar2(11 byte),
    wh_period_date       date,
    wh_period_date_id    number                   default 0,
    docno_uic            varchar2(6 byte),
    docno_force_unit_id  number                   default 0,
    niin                 varchar2(9 byte),
    pniin_item_id        number                   default 0,
    physical_item_niin   varchar2(9 byte),
    physical_item_id     number                   default 0,
    physical_item_sn     varchar2(48 byte),
    physical_item_sn_id  number                   default 0,
    cwt                  number,
    d_cust_iss           date,
    rcpt_docno           varchar2(14 byte),
    rcpt_dic             varchar2(3 byte),
    d_rcpt               date,
    rcpt_ric_fr          varchar2(3 byte),
    pseudo               varchar2(1 byte),
    sof                  varchar2(7 byte),
    price                number,
    cat_sos              varchar2(3 byte),
    sc                   varchar2(2 byte),
    scmc                 varchar2(2 byte),
    ami                  varchar2(1 byte),
    dlr                  varchar2(1 byte),
    msc_spt              varchar2(10 byte),
    instl                varchar2(20 byte),
    corps                varchar2(20 byte),
    macom                varchar2(10 byte),
    d_upd                date,
    ssfcoc_flag          varchar2(1 byte),
    component            varchar2(7 byte),
    d_docno              date,
    d_sarss1             date,
    d_sarss2b            date,
    age_doc_s1           number,
    age_s1_s2b           number,
    fund                 varchar2(4 byte),
    conus                varchar2(1 byte),
    qty                  number,
    ext_price            number,
    prj                  varchar2(3 byte),
    d_iss_month          date,
    iss_mon              varchar2(5 byte),
    dodaac               varchar2(6 byte),
    age_s1_iss           number,
    sfx                  varchar2(1 byte),
    frz_input_date       date,
    frz_input_date_id    number,
    rec_frz_flag         varchar2(1 byte)         default 'N',
    frz_date             date                     default '31-DEC-2099',
    status               varchar2(1 byte)         default 'C',
    updt_by              varchar2(30 byte)        default user,
    lst_updt             date                     default sysdate,
    grab_stamp           date,
    proc_stamp           date,
    active_flag          varchar2(1 byte)         default 'Y',
    active_date          date                     default '01-JAN-1900',
    inactive_date        date                     default '31-DEC-2099',
    source_rec_id        number                   default 0,
    insert_by            varchar2(30 byte)        default user,
    insert_date          date                     default sysdate,
    lst_update_rec_id    number                   default 0,
    update_by            varchar2(30 byte),
    update_date          date                     default '01-JAN-1900',
    delete_flag          varchar2(1 byte)         default 'N',
    delete_date          date                     default '01-JAN-1900',
    delete_by            varchar2(30 byte),
    hidden_flag          varchar2(1 byte)         default 'N',
    hidden_date          date                     default '01-JAN-1900',
    hidden_by            varchar2(30 byte)
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

COMMENT ON TABLE frz_pfsa_supply_ilap 
IS 'frz_pfsa_supply_ilap - '; 


COMMENT ON COLUMN frz_pfsa_supply_ilap.rec_id 
IS 'REC_ID - Sequence/identity for dimension/fact table.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.docno
IS 'DOCNO - Document Number - This is a 14-position, alphanumeric code used to identify a requisition document in the supply system. Typically, the first six characters are the Department of Defense Address Activity Code (DODAAC). The next four are the Julian Date when the document was created, and the last four are the serial number assigned by the specific unit generating the requisition. This number is also recognized by the financial systems.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.ric_stor 
IS 'RIC_STOR - ROUTING IDENTIFIER CODE - These codes are assigned for processing interservice, intraservice, or agency logistical transactions. These codes serve multiple purposes. They are source of supply codes, intersystem routing codes, intrasystem routing codes, and consignor (shipper) codes.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.ipg 
IS 'IPG - ISSUE PRIORITY GROUP - Priorities are grouped by 1 (01-03), 2 (04-08), and 3 (09-15).  '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.pniin 
IS 'PNIIN - Part NIIN (with dashes) - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.iss_niin 
IS 'ISS_NIIN - Part issued NIIN (with dashes) - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.niin 
IS 'NIIN - Part NIIN (without dashes)  - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.pniin_item_id 
IS 'PNIIN_ITEM_ID - Part item - PHYSICAL_ITEM_ID - Foreign key to the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.physical_item_niin 
IS 'PHYSICAL_ITEM_NIIN - The NIIN of the item the part is associated like.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.physical_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key to the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.physical_item_sn 
IS 'PHYSICAL_ITEM_SN - ITEM_SERIAL_NUMBER - Serial number of the item.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number as represented in the PFSAWH_ITEM_SN_DIM.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.cwt 
IS 'CWT - CUSTOMER WAIT TIME - The average number of days a backorder takes to be filled.  It is determined by subtracting the SHIPMENT_DUE_DATE from the date the final Materiel Release Order (MRO) was prepared (ICP_MRO_DT) for each Materiel Obligation Outstanding (MOO) demand totally released during the period.  Those figures are summed and divided by the number of MOO demands totally released.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_cust_iss 
IS 'D_CUST_ISS - Date of issue by customer'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.rcpt_docno 
IS 'RCPT_DOCNO - DOCNO - Document Number - This is a 14-position, alphanumeric code used to identify a requisition document in the supply system. Typically, the first six characters are the Department of Defense Address Activity Code (DODAAC). The next four are the Julian Date when the document was created, and the last four are the serial number assigned by the specific unit generating the requisition. This number is also recognized by the financial systems.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.rcpt_dic 
IS 'RCPT_DIC - DOCUMENT IDENTIFIER CODE - A three-position, alphanumeric field that identifies the action to be taken on the original transaction.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_rcpt 
IS 'D_RCPT - Date of receipt by '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.rcpt_ric_fr 
IS 'RCPT_RIC_FR - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.pseudo 
IS 'PSEUDO - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.sof 
IS 'SOF - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.price 
IS 'PRICE - ESTIMATED REPAIR PART COST - The cost of each individual repair part used in a repair action.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.cat_sos 
IS 'CAT_SOS - SOS - Source Of Supply'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.sc 
IS 'SC - SUPPLY CLASS - A code that indicates the major category of materiel to which an item of supply is assigned.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.scmc 
IS 'SCMC - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.ami 
IS 'AMI - ARMY MANAGED ITEM -  Identifies the record as Single Stock Fund Non-Army Managed Item that can be filled within the Army.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.dlr 
IS 'DLR - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.msc_spt 
IS 'MSC_SPT - MAJOR SUBORDINATE COMMAND FOR SUPPORT - This is the support element within a larger command of a self-sustained command.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.instl 
IS 'INSTL - INSTALLATION - This field specifies the installation for data aggregation.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.corps 
IS 'CORPS - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.macom 
IS 'MACOM - MAJOR ARMY COMMAND CODE (MACOM) - Identifies the Major Command or Department of the Army Staff Agency.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_upd 
IS 'D_UPD - DATE RECORD UPDATED IN INTEGRATED LOGISTICS APPLICATION PROGRAM (ILAP) - This is the date on which the record was updated in the Integrated Logistics Application Program (ILAP).'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.ssfcoc_flag 
IS 'SSFCOC_FLAG - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.component 
IS 'COMPONENT - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_docno 
IS 'D_DOCNO - Date of the Document Number.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_sarss1 
IS 'D_SARSS1 - Date of the SARSS1.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_sarss2b 
IS 'D_SARSS2B - Date of the SARSS2B.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.age_doc_s1 
IS 'AGE_DOC_S1 - Age of S1 in '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.age_s1_s2b 
IS 'AGE_S1_S2B - Age of S2B in '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.fund 
IS 'FUND - FUND CODE - A code used to prescribe Army appropriations and funds.  Provides data for supply and financial management.  Used by the consumer for stock fund item requisition funding purposes.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.conus 
IS 'CONUS - CONUS INDICATOR - A one-character flag used to indicate a CONUS location.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.qty 
IS 'QTY - QUANTITY - Indicates the number of items involved in the transaction.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.ext_price 
IS 'EXT_PRICE - ESTIMATED REPAIR PART COST - The cost of each individual repair part used in a repair action.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.prj 
IS 'PRJ - PROJECT CODE - The DA Master Project Code is a three-position, alphanumeric code used to distinguish requisitions and related documentation and shipments and to accumulate intraservice performance and cost data related to exercises, maneuvers, and other distinct programs, projects, and operations.  The Project Code is used to identify requisitions, related documents, and shipments of materiel for specific projects, programs, or maneuvers.  It identifies specific programs to provide funding and costing at the requisitioner or supplier level, to satisfy program costs and analysis, including an indicator of transactions within or outside of the federal government.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.d_iss_month 
IS 'D_ISS_MONTH - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.iss_mon 
IS 'ISS_MON - '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.dodaac 
IS 'DODAAC - DEPARTMENT OF DEFENSE ACTIVITY ADDRESS CODE - A six-position, alphanumeric code that identifies a specific unit or activity authorized to requisition, receive supplies, or receive billing.'; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.age_s1_iss 
IS 'AGE_S1_ISS - Age of S1_ISS in '; 

COMMENT ON COLUMN frz_pfsa_supply_ilap.sfx 
IS 'SFX - Suffix Code - This is a one-position, alphanumeric code used to designate partial shipments under the original document number. (The code appears in DD Form 1348-1 and DD Form 1348m. It may be any alphabetic code except I, N, O, P, R, S, Y, or Z, and any number except 1 or 0.)';

COMMENT ON COLUMN frz_pfsa_supply_ilap.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN frz_pfsa_supply_ilap.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.grab_stamp 
IS 'GRAB_STAMP - The date and time the record entered the PFSA world.  The actual value is the sysdate when the PFSA grab procedure that populated a PFSA table (BLD, POTENTIAL or production) table for the first time in PFSA.  When the record move from "BLD to POTENITAL" or "BLD to production" the grab_date does not change.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.proc_stamp 
IS 'PROC_STAMP - The date timestamp (sysdate) of the promotion action.  ie: "BLD to POTENITAL" or "BLD to production"';       

COMMENT ON COLUMN frz_pfsa_supply_ilap.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.source_rec_id
IS 'SOURCE_REC_ID - ';

COMMENT ON COLUMN frz_pfsa_supply_ilap.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.lst_update_rec_id
IS 'LST_UPDATE_REC_ID - ';

COMMENT ON COLUMN frz_pfsa_supply_ilap.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN frz_pfsa_supply_ilap.docno_uic
IS 'DOCNO_UIC - UNIT IDENTIFICATION CODE (UIC) of the reuqesting unit - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a "unit."  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UICs assigned parent unit is defined by HQDA and may be recognized by "AA" in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)';

COMMENT ON COLUMN frz_pfsa_supply_ilap.docno_force_unit_id
IS 'DOCNO_FORCE_UNIT_ID - FORCE_UNIT_ID of the requesting unit - Primary, blind key of the pfsawh_force_unit_dim table.';


/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_pfsa_supply_ilap'); 
*/
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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_supply_ilap') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_supply_ilap') 
ORDER BY b.column_id; 
*/
/*----- Look-up field description from master LIDB table -----*/
/*
SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%RIC_STOR%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%RIC_STOR%'); 
*/
