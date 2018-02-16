
CREATE TABLE ITEM_DATA_HIST
(
  NIIN                        VARCHAR2(9 BYTE),
  TO_DT                       DATE,
  FROM_DT                     DATE,
  ACQ_AD_CD                   CHAR(1 BYTE),
  ACQ_METH_CD                 CHAR(1 BYTE),
  ACQ_METH_SFX_CD             CHAR(1 BYTE),
  ACTNG_RQMT_CD               CHAR(1 BYTE),
  ADPE_ID_CD                  CHAR(1 BYTE),
  CIIC                        CHAR(1 BYTE),
  CRIT_CD                     CHAR(1 BYTE),
  DEL_REASON_CD               CHAR(1 BYTE),
  EFF_DT                      DATE,
  ELECTROSTATIC_DISCHARGE_ID  CHAR(1 BYTE),
  FUND_CD                     CHAR(1 BYTE),
  HAZ_MAT_ID_CD               CHAR(1 BYTE),
  ID_NUM_CD                   CHAR(1 BYTE),
  INTER_SUB_ID                CHAR(1 BYTE),
  INV_CAT_CD                  CHAR(1 BYTE),
  ITEM_DPTH                   NUMBER,
  ITEM_LGTH                   NUMBER,
  ITEM_WDTH                   NUMBER,
  ITEM_MGMT_CODING_ACT        CHAR(1 BYTE),
  ITEM_NAME_CD                NUMBER,
  LC_CD                       VARCHAR2(1 BYTE),
  LIFE_EXPECTANCY             NUMBER,
  MOE_RULE_ID                 VARCHAR2(4 BYTE),
  NIIN_STATUS_CD              CHAR(1 BYTE),
  NIMSC                       CHAR(1 BYTE),
  PHRS_CD                     CHAR(1 BYTE),
  PRECIOUS_METALS_CD          CHAR(1 BYTE),
  PRICE_SGNL_CD               CHAR(1 BYTE),
  REG_NUM_REQ                 CHAR(1 BYTE),
  REL_NIIN                    VARCHAR2(9 BYTE),
  SCIC                        CHAR(1 BYTE),
  SHLF_LIFE_CD                CHAR(1 BYTE),
  SPEC_RQMT_CD                CHAR(1 BYTE),
  FULL_NOMEN                  VARCHAR2(105 BYTE),
  TECH_DOC_NUM                VARCHAR2(16 BYTE),
  UI_CD                       VARCHAR2(2 BYTE),
  UI_CONV_DEC_LOC             CHAR(1 BYTE),
  UI_CONV_MULTIPLIER          NUMBER,
  UM_CD                       VARCHAR2(2 BYTE),
  UM_DEC_LOC                  CHAR(1 BYTE),
  UM_QTY                      NUMBER,
  UNIT_PRICE                  NUMBER,
  UNPKGD_ITEM_WT              VARCHAR2(5 BYTE),
  STATUS                      CHAR(1 BYTE),
  LST_UPDT                    DATE,
  UPDT_BY                     VARCHAR2(20 BYTE)
)
PARTITION BY RANGE (TO_DT) 
(  
  PARTITION P_I_C_D_OLD VALUES LESS THAN (TO_DATE(' 2006-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_D_2002 VALUES LESS THAN (TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_D_2003 VALUES LESS THAN (TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_D_2004 VALUES LESS THAN (TO_DATE(' 2009-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_D_2005 VALUES LESS THAN (TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_D_CURR VALUES LESS THAN (MAXVALUE)
    LOGGING
    NOCOMPRESS
)
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

COMMENT ON COLUMN ITEM_DATA_HIST.TO_DT IS 'TO DATE - The ending date for a historical record.';

COMMENT ON COLUMN ITEM_DATA_HIST.FROM_DT IS 'FROM DATE - The beginning date for a historical record.';

COMMENT ON COLUMN ITEM_DATA_HIST.ACQ_AD_CD IS 'ACQUISITION ADVICE CODE - The Acquisition Advice Code (AAC) is a one-position, alphabetic code that informs the requisitioner how, and under what conditions, an item will be acquired. It does not specify the source of supply for the item.';

COMMENT ON COLUMN ITEM_DATA_HIST.ACQ_METH_CD IS 'ACQUISITION METHOD CODE - The code that represents the acquisition technique for a materiel item as a result of planned procurement review.';

COMMENT ON COLUMN ITEM_DATA_HIST.ACQ_METH_SFX_CD IS 'ACQUISITION METHOD SUFFIX CODE - The code that represents the primary reason for the acquisition method assigned by the applied MOE rule.';

COMMENT ON COLUMN ITEM_DATA_HIST.ACTNG_RQMT_CD IS 'ACCOUNTING REQUIREMENTS CODE - This field labels an item as nonexpendable, expendable, or durable.';

COMMENT ON COLUMN ITEM_DATA_HIST.ADPE_ID_CD IS 'AUTOMATIC DATA PROCESSING EQUIPMENT IDENTIFICATION CODE - Identifies an item of ADPE or an item containing ADPE equipment.';

COMMENT ON COLUMN ITEM_DATA_HIST.CIIC IS 'CONTROLLED ITEM INVENTORY CODE - Identifies the Controlled Inventory Item Code (CIIC) and explanation. Indicates the security classification security risk or pilferage controls required for storage and transportation of assets.';

COMMENT ON COLUMN ITEM_DATA_HIST.CRIT_CD IS 'CRITICALITY CODE - This code indicates that an item is technically critical by reason of tolerance, fit restrictions, application, nuclear hardness properties, or other characteristics that affect identification of the item.';

COMMENT ON COLUMN ITEM_DATA_HIST.DEL_REASON_CD IS 'INTERCHANGE AND SUBSTITUTE DELETION REASON CODE - The Interchange and Substitute (I) Deletion Reason Code is a one-position, alphabetic code that explains the reason for deleting I data from Part 1 of Sections I and II of the I segment. I data deleted by reason code C will be placed in the history segment of the AMDF by LOGSA. I data deleted by reason codes A, B, or D will not be placed in the history segment.';

COMMENT ON COLUMN ITEM_DATA_HIST.EFF_DT IS 'EFFECTIVE DATE - The date on which a change in the status of a person, place, or thing becomes effective or official.';

COMMENT ON COLUMN ITEM_DATA_HIST.ELECTROSTATIC_DISCHARGE_ID IS 'ELECTROSTATIC DISCHARGE INDICATOR - The Electrostatic Discharge (ESDC) field indicates whether an item is susceptible to electrostatic discharge or electromagnetic interference damage.';

COMMENT ON COLUMN ITEM_DATA_HIST.FUND_CD IS 'FUND CODE - Prescribed for Army appropriations and funds. Provides data for supply and financial management. Used by the consumer for requisitions funding of stock fund items.';

COMMENT ON COLUMN ITEM_DATA_HIST.HAZ_MAT_ID_CD IS 'HAZARDOUS MATERIAL INDICATOR CODE - Defense Logistics Information Service (DLIS) input that identifies an item determined to be hazardous.';

COMMENT ON COLUMN ITEM_DATA_HIST.ID_NUM_CD IS 'IDENTIFYING NUMBER CODE - This field indicates the kind of number that is in the NIIN field (for example, MCN, ACVC, Manufacturing Part Number, etc.).';

COMMENT ON COLUMN ITEM_DATA_HIST.INTER_SUB_ID IS 'INTERCHANGE AND SUBSTITUTE INDICATOR - A single-character code that indicates the existence of Interchange and Substitute (I) data.';

COMMENT ON COLUMN ITEM_DATA_HIST.INV_CAT_CD IS 'INVENTORY CATEGORY CODE - A code used to group items of supply into lots or segments of similar items for inventory and research purposes.';

COMMENT ON COLUMN ITEM_DATA_HIST.ITEM_DPTH IS 'ITEM DEPTH - Depth of an item to the nearest one-tenth inch.';

COMMENT ON COLUMN ITEM_DATA_HIST.ITEM_LGTH IS 'ITEM LENGTH - Length of an item to the nearest one-tenth inch.';

COMMENT ON COLUMN ITEM_DATA_HIST.ITEM_WDTH IS 'ITEM WIDTH - Width of an item to the nearest one-tenth inch.';

COMMENT ON COLUMN ITEM_DATA_HIST.ITEM_MGMT_CODING_ACT IS 'ITEM MANAGEMENT CODING ACTIVITY - The Item Management Coding Activity (IMCA) code is a one-digit code that indicates whether items of supply shall be subjected to integrated management under the Defense Logistics Agency/General Services Administration or retained by the individual military service.';

COMMENT ON COLUMN ITEM_DATA_HIST.ITEM_NAME_CD IS 'ITEM NAME CODE - A code assigned by the Defense Logistics Information Service (DLIS). It is used to group like items.';

COMMENT ON COLUMN ITEM_DATA_HIST.LC_CD IS 'LOGISTICS CONTROL CODE - The Logistics Control Code (LCC) is assigned to items of materiel authorized for use. It is used to assist in determining and providing logistic support decisions (i.e., procurement, overhaul, provisioning).';

COMMENT ON COLUMN ITEM_DATA_HIST.LIFE_EXPECTANCY IS 'LIFE EXPECTANCY - The number of years this item can reasonably be expected to last.';

COMMENT ON COLUMN ITEM_DATA_HIST.MOE_RULE_ID IS 'MAJOR ORGANIZATIONAL ENTITY RULE IDENTIFIER - The identifier of a materiel management relationship.';

COMMENT ON COLUMN ITEM_DATA_HIST.NIIN_STATUS_CD IS 'NATIONAL ITEM IDENTIFICATION NUMBER STATUS CODE - This code indicates the status of the National Item Identification Number (NIIN).';

COMMENT ON COLUMN ITEM_DATA_HIST.NIMSC IS 'NON-CONSUMABLE ITEM MATERIEL SUPPORT CODE - This code determines the degree of support received by an individual Secondary Inventory Control Activity (SICA) or identifies the service performing depot maintenance for a Primary Inventory Control Activity (PICA).';

COMMENT ON COLUMN ITEM_DATA_HIST.PHRS_CD IS 'PHRASE CODE - The code that represents the phrase statement delineating the relationship between the materiel item and the related materiel item or supply item control technical document identifier.';

COMMENT ON COLUMN ITEM_DATA_HIST.PRECIOUS_METALS_CD IS 'PRECIOUS METALS INDICATOR CODE - The Precious Metals Indicator Code (PMIC) identifies items that have precious metals as part of their content. Precious metals are those metals considered uncommon and highly valuable.';

COMMENT ON COLUMN ITEM_DATA_HIST.PRICE_SGNL_CD IS 'PRICE SIGNAL CODE - This field denotes how the price is expressed.';

COMMENT ON COLUMN ITEM_DATA_HIST.REG_NUM_REQ IS 'REGISTRATION NUMBER REQUIRED - This field indicates if a registration number is required for this NIIN. Valid values are Y and N. The default value is N. Maintained through TEDB.';

COMMENT ON COLUMN ITEM_DATA_HIST.REL_NIIN IS 'RELATED NATIONAL ITEM IDENTIFICATION NUMBER - The related NIIN, or medical or technical document number. Can be blank, zero-filled, or contain the appropriate entry, as defined by the Phrase Code of the NIIN.';

COMMENT ON COLUMN ITEM_DATA_HIST.SCIC IS 'SPECIAL CONTROL ITEM CODE - A code that represents different hazardous items. All codes other than zero (0) will have an associated record in the Hazard table.';

COMMENT ON COLUMN ITEM_DATA_HIST.SHLF_LIFE_CD IS 'SHELF LIFE CODE - The Shelf Life Code (SLC) represents the period of time during which a materiel item remains usable.';

COMMENT ON COLUMN ITEM_DATA_HIST.SPEC_RQMT_CD IS 'SPECIAL REQUIREMENTS CODE - The identification of supply functions that must be performed in accordance with specified documents.';

COMMENT ON COLUMN ITEM_DATA_HIST.FULL_NOMEN IS 'NOMENCLATURE - The name of an item. Usually the name describes or identifies characteristics of the item.';

COMMENT ON COLUMN ITEM_DATA_HIST.TECH_DOC_NUM IS 'TECHNICAL DOCUMENT NUMBER - Any identifying number assigned to this item.';

COMMENT ON COLUMN ITEM_DATA_HIST.UI_CONV_DEC_LOC IS 'UNIT OF ISSUE CONVERSION DECIMAL LOCATOR - The decimal locator indicates the number of places from the right that the decimal is located.';

COMMENT ON COLUMN ITEM_DATA_HIST.UI_CONV_MULTIPLIER IS 'UNIT OF ISSUE CONVERSION MULTIPLIER - The factor used to convert the unit of issue to another unit of issue (i.e., FT to RO; EA to PG).';

COMMENT ON COLUMN ITEM_DATA_HIST.UM_CD IS 'UNIT OF MEASURE (UNIT OF ISSUE) CODE - The Unit of Measure (UM) code identifies a known physical measurement or count of an item, issued to satisfy a single requisition. For example, it may be a single item, a dozen, a box, a gross, a set, etc.';

COMMENT ON COLUMN ITEM_DATA_HIST.UM_DEC_LOC IS 'UNIT OF MEASURE DECIMAL LOCATOR - The decimal locator indicates the number of places from the right of the decimal. Valid values for this field are zero through four (0-4).';

COMMENT ON COLUMN ITEM_DATA_HIST.UM_QTY IS 'UNIT OF MEASURE QUANTITY - The quantitative expression of the number of items in the unit of measure. (i.e., 10 ea. in 1 pg.).';

COMMENT ON COLUMN ITEM_DATA_HIST.UNPKGD_ITEM_WT IS 'UNPACKAGED ITEM WEIGHT - A five-position, alphanumeric field that indicates the actual weight of the bare (unpackaged) item. The actual, net weight of item is measured to the nearest one-tenth of a pound (e.g., 9,999.9).';

COMMENT ON COLUMN ITEM_DATA_HIST.STATUS IS 'STATUS - Indicates the status of the record.';

COMMENT ON COLUMN ITEM_DATA_HIST.LST_UPDT IS 'LAST UPDATE - Indicates when the record was last updated.';

COMMENT ON COLUMN ITEM_DATA_HIST.UPDT_BY IS 'UPDATED BY - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN ITEM_DATA_HIST.NIIN IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program. The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number. These nine digits are the latter part of the 13-digit National Stock Number (NSN).';


CREATE INDEX IE_NIIN_LST_UPDT_IDHIST_IDX ON ITEM_DATA_HIST
(NIIN, LST_UPDT)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX PK_ITEMDTAH ON ITEM_DATA_HIST
(NIIN, TO_DT)
LOGGING
NOPARALLEL;


CREATE INDEX IE_ITMDTA_HIST_LST_UPDT_IDX ON ITEM_DATA_HIST
(LST_UPDT)
LOGGING
NOPARALLEL;


CREATE PUBLIC SYNONYM ITEM_DATA_HIST FOR ITEM_DATA_HIST;


ALTER TABLE ITEM_DATA_HIST ADD (
  CONSTRAINT PK_ITEMDTAH
 PRIMARY KEY
 (NIIN, TO_DT));


GRANT SELECT ON  ITEM_DATA_HIST TO DISCOV_VIEWS WITH GRANT OPTION;

GRANT SELECT ON  ITEM_DATA_HIST TO S_ITEM1;

