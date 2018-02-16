-- DROP TABLE pfsa_supply_ilap_tmp; 

CREATE TABLE pfsa_supply_ilap_tmp
(
  REC_ID               NUMBER                   NOT NULL,
  DOCNO                VARCHAR2(14 BYTE),
  RIC_STOR             VARCHAR2(3 BYTE),
  IPG                  VARCHAR2(1 BYTE),
  PNIIN                VARCHAR2(11 BYTE),
  ISS_NIIN             VARCHAR2(11 BYTE),
  WH_PERIOD_DATE       DATE,
  WH_PERIOD_DATE_ID    NUMBER                   DEFAULT 0,
  DOCNO_UIC            VARCHAR2(6 BYTE),
  DOCNO_FORCE_UNIT_ID  NUMBER                   DEFAULT 0,
  NIIN                 VARCHAR2(9 BYTE),
  PNIIN_ITEM_ID        NUMBER                   DEFAULT 0,
  PHYSICAL_ITEM_NIIN   VARCHAR2(9 BYTE),
  PHYSICAL_ITEM_ID     NUMBER                   DEFAULT 0,
  PHYSICAL_ITEM_SN     VARCHAR2(48 BYTE),
  PHYSICAL_ITEM_SN_ID  NUMBER                   DEFAULT 0,
  CWT                  NUMBER,
  D_CUST_ISS           DATE,
  RCPT_DOCNO           VARCHAR2(14 BYTE),
  RCPT_DIC             VARCHAR2(3 BYTE),
  D_RCPT               DATE,
  RCPT_RIC_FR          VARCHAR2(3 BYTE),
  PSEUDO               VARCHAR2(1 BYTE),
  SOF                  VARCHAR2(7 BYTE),
  PRICE                NUMBER,
  CAT_SOS              VARCHAR2(3 BYTE),
  SC                   VARCHAR2(2 BYTE),
  SCMC                 VARCHAR2(2 BYTE),
  AMI                  VARCHAR2(1 BYTE),
  DLR                  VARCHAR2(1 BYTE),
  MSC_SPT              VARCHAR2(10 BYTE),
  INSTL                VARCHAR2(20 BYTE),
  CORPS                VARCHAR2(20 BYTE),
  MACOM                VARCHAR2(10 BYTE),
  D_UPD                DATE,
  SSFCOC_FLAG          VARCHAR2(1 BYTE),
  COMPONENT            VARCHAR2(7 BYTE),
  D_DOCNO              DATE,
  D_SARSS1             DATE,
  D_SARSS2B            DATE,
  AGE_DOC_S1           NUMBER,
  AGE_S1_S2B           NUMBER,
  FUND                 VARCHAR2(4 BYTE),
  CONUS                VARCHAR2(1 BYTE),
  QTY                  NUMBER,
  EXT_PRICE            NUMBER,
  PRJ                  VARCHAR2(3 BYTE),
  D_ISS_MONTH          DATE,
  ISS_MON              VARCHAR2(5 BYTE),
  DODAAC               VARCHAR2(6 BYTE),
  AGE_S1_ISS           NUMBER,
  SFX                  VARCHAR2(1 BYTE),
  STATUS               VARCHAR2(1 BYTE)         DEFAULT 'C',
  UPDT_BY              VARCHAR2(30 BYTE)        DEFAULT USER,
  LST_UPDT             DATE                     DEFAULT SYSDATE,
  GRAB_STAMP           DATE,
  PROC_STAMP           DATE,
  ACTIVE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'A',
  ACTIVE_DATE          DATE                     DEFAULT '01-JAN-1900',
  INACTIVE_DATE        DATE                     DEFAULT '31-DEC-2099',
  SOURCE_REC_ID        NUMBER                   DEFAULT 0,
  INSERT_BY            VARCHAR2(40 BYTE)        DEFAULT USER,
  INSERT_DATE          DATE                     DEFAULT SYSDATE,
  LST_UPDATE_REC_ID    NUMBER                   DEFAULT 0,
  UPDATE_BY            VARCHAR2(40 BYTE),
  UPDATE_DATE          DATE                     DEFAULT '01-JAN-1900',
  DELETE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'N',
  DELETE_DATE          DATE                     DEFAULT '01-JAN-1900',
  HIDDEN_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'Y',
  HIDDEN_DATE          DATE                     DEFAULT '01-JAN-1900'
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
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


COMMENT ON TABLE pfsa_supply_ilap_tmp IS 'PFSA_SUPPLY_ILAP_TMP - ';


COMMENT ON COLUMN pfsa_supply_ilap_tmp.REC_ID IS 'REC_ID - Sequence/identity for dimension/fact table.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DOCNO IS 'DOCNO - Document Number - This is a 14-position, alphanumeric code used to identify a requisition document in the supply system. Typically, the first six characters are the Department of Defense Address Activity Code (DODAAC). The next four are the Julian Date when the document was created, and the last four are the serial number assigned by the specific unit generating the requisition. This number is also recognized by the financial systems.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.RIC_STOR IS 'RIC_STOR - ROUTING IDENTIFIER CODE - These codes are assigned for processing interservice, intraservice, or agency logistical transactions. These codes serve multiple purposes. They are source of supply codes, intersystem routing codes, intrasystem routing codes, and consignor (shipper) codes.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.IPG IS 'IPG - ISSUE PRIORITY GROUP - Priorities are grouped by 1 (01-03), 2 (04-08), and 3 (09-15).  ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PNIIN IS 'PNIIN - Part NIIN (with dashes) - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.ISS_NIIN IS 'ISS_NIIN - Part issued NIIN (with dashes) - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DOCNO_UIC IS 'DOCNO_UIC - UNIT IDENTIFICATION CODE (UIC) of the reuqesting unit - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a "unit."  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UICs assigned parent unit is defined by HQDA and may be recognized by "AA" in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DOCNO_FORCE_UNIT_ID IS 'DOCNO_FORCE_UNIT_ID - FORCE_UNIT_ID of the requesting unit - Primary, blind key of the pfsawh_force_unit_dim table.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.NIIN IS 'NIIN - Part NIIN (without dashes)  - NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PNIIN_ITEM_ID IS 'PNIIN_ITEM_ID - Part item - PHYSICAL_ITEM_ID - Foreign key to the PFSAWH_ITEM_DIM table.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PHYSICAL_ITEM_NIIN IS 'PHYSICAL_ITEM_NIIN - The NIIN of the item the part is associated like.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PHYSICAL_ITEM_ID IS 'PHYSICAL_ITEM_ID - Foreign key to the PFSAWH_ITEM_DIM table.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PHYSICAL_ITEM_SN IS 'PHYSICAL_ITEM_SN - ITEM_SERIAL_NUMBER - Serial number of the item.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PHYSICAL_ITEM_SN_ID IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number as represented in the PFSAWH_ITEM_SN_DIM.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.CWT IS 'CWT - CUSTOMER WAIT TIME - The average number of days a backorder takes to be filled.  It is determined by subtracting the SHIPMENT_DUE_DATE from the date the final Materiel Release Order (MRO) was prepared (ICP_MRO_DT) for each Materiel Obligation Outstanding (MOO) demand totally released during the period.  Those figures are summed and divided by the number of MOO demands totally released.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_CUST_ISS IS 'D_CUST_ISS - Date of issue by customer';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.RCPT_DOCNO IS 'RCPT_DOCNO - DOCNO - Document Number - This is a 14-position, alphanumeric code used to identify a requisition document in the supply system. Typically, the first six characters are the Department of Defense Address Activity Code (DODAAC). The next four are the Julian Date when the document was created, and the last four are the serial number assigned by the specific unit generating the requisition. This number is also recognized by the financial systems.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.RCPT_DIC IS 'RCPT_DIC - DOCUMENT IDENTIFIER CODE - A three-position, alphanumeric field that identifies the action to be taken on the original transaction.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_RCPT IS 'D_RCPT - Date of receipt by ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.RCPT_RIC_FR IS 'RCPT_RIC_FR - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PSEUDO IS 'PSEUDO - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.SOF IS 'SOF - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PRICE IS 'PRICE - ESTIMATED REPAIR PART COST - The cost of each individual repair part used in a repair action.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.CAT_SOS IS 'CAT_SOS - SOS - Source Of Supply';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.SC IS 'SC - SUPPLY CLASS - A code that indicates the major category of materiel to which an item of supply is assigned.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.SCMC IS 'SCMC - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.AMI IS 'AMI - ARMY MANAGED ITEM -  Identifies the record as Single Stock Fund Non-Army Managed Item that can be filled within the Army.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DLR IS 'DLR - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.MSC_SPT IS 'MSC_SPT - MAJOR SUBORDINATE COMMAND FOR SUPPORT - This is the support element within a larger command of a self-sustained command.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.INSTL IS 'INSTL - INSTALLATION - This field specifies the installation for data aggregation.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.CORPS IS 'CORPS - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.MACOM IS 'MACOM - MAJOR ARMY COMMAND CODE (MACOM) - Identifies the Major Command or Department of the Army Staff Agency.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_UPD IS 'D_UPD - DATE RECORD UPDATED IN INTEGRATED LOGISTICS APPLICATION PROGRAM (ILAP) - This is the date on which the record was updated in the Integrated Logistics Application Program (ILAP).';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.SSFCOC_FLAG IS 'SSFCOC_FLAG - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.COMPONENT IS 'COMPONENT - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_DOCNO IS 'D_DOCNO - Date of the Document Number.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_SARSS1 IS 'D_SARSS1 - Date of the SARSS1.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_SARSS2B IS 'D_SARSS2B - Date of the SARSS2B.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.AGE_DOC_S1 IS 'AGE_DOC_S1 - Age of S1 in ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.AGE_S1_S2B IS 'AGE_S1_S2B - Age of S2B in ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.FUND IS 'FUND - FUND CODE - A code used to prescribe Army appropriations and funds.  Provides data for supply and financial management.  Used by the consumer for stock fund item requisition funding purposes.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.CONUS IS 'CONUS - CONUS INDICATOR - A one-character flag used to indicate a CONUS location.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.QTY IS 'QTY - QUANTITY - Indicates the number of items involved in the transaction.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.EXT_PRICE IS 'EXT_PRICE - ESTIMATED REPAIR PART COST - The cost of each individual repair part used in a repair action.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PRJ IS 'PRJ - PROJECT CODE - The DA Master Project Code is a three-position, alphanumeric code used to distinguish requisitions and related documentation and shipments and to accumulate intraservice performance and cost data related to exercises, maneuvers, and other distinct programs, projects, and operations.  The Project Code is used to identify requisitions, related documents, and shipments of materiel for specific projects, programs, or maneuvers.  It identifies specific programs to provide funding and costing at the requisitioner or supplier level, to satisfy program costs and analysis, including an indicator of transactions within or outside of the federal government.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.D_ISS_MONTH IS 'D_ISS_MONTH - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.ISS_MON IS 'ISS_MON - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DODAAC IS 'DODAAC - DEPARTMENT OF DEFENSE ACTIVITY ADDRESS CODE - A six-position, alphanumeric code that identifies a specific unit or activity authorized to requisition, receive supplies, or receive billing.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.AGE_S1_ISS IS 'AGE_S1_ISS - Age of S1_ISS in ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.SFX IS 'SFX - Suffix Code - This is a one-position, alphanumeric code used to designate partial shipments under the original document number. (The code appears in DD Form 1348-1 and DD Form 1348m. It may be any alphabetic code except I, N, O, P, R, S, Y, or Z, and any number except 1 or 0.)';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.STATUS IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.UPDT_BY IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.LST_UPDT IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.GRAB_STAMP IS 'GRAB_STAMP - The date and time the record entered the PFSA world.  The actual value is the sysdate when the PFSA grab procedure that populated a PFSA table (BLD, POTENTIAL or production) table for the first time in PFSA.  When the record move from "BLD to POTENITAL" or "BLD to production" the grab_date does not change.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.PROC_STAMP IS 'PROC_STAMP - The date timestamp (sysdate) of the promotion action.  ie: "BLD to POTENITAL" or "BLD to production"';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.ACTIVE_DATE IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.INACTIVE_DATE IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.SOURCE_REC_ID IS 'SOURCE_REC_ID - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.INSERT_BY IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.INSERT_DATE IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.LST_UPDATE_REC_ID IS 'LST_UPDATE_REC_ID - ';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.UPDATE_BY IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.UPDATE_DATE IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.DELETE_DATE IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsa_supply_ilap_tmp.HIDDEN_DATE IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';


