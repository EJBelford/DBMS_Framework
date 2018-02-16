
CREATE TABLE ITEM_CONTROL_HIST
(
  NIIN                   VARCHAR2(9 BYTE),
  TO_DT                  DATE,
  FROM_DT                DATE,
  ACT_ORIGN_CD           VARCHAR2(3 BYTE),
  AEC_CD                 CHAR(1 BYTE),
  ARI_CD                 CHAR(1 BYTE),
  CL_OF_SUPPLY_CD        CHAR(1 BYTE),
  DEMIL_CD               CHAR(1 BYTE),
  DODIC                  VARCHAR2(4 BYTE),
  ECC                    VARCHAR2(3 BYTE),
  EIC                    VARCHAR2(3 BYTE),
  ESNTL_CD               CHAR(1 BYTE),
  FSC                    VARCHAR2(4 BYTE),
  FSG                    NUMBER,
  MAINT_RPR_CD           CHAR(1 BYTE),
  MAT_CAT_CD_1           CHAR(1 BYTE),
  MAT_CAT_CD_2           CHAR(1 BYTE),
  MAT_CAT_CD_3           CHAR(1 BYTE),
  MAT_CAT_CD_4           CHAR(1 BYTE),
  MAT_CAT_CD_4_5         VARCHAR2(2 BYTE),
  NOMEN_35               VARCHAR2(35 BYTE),
  RECOV_CD               CHAR(1 BYTE),
  RICC                   CHAR(1 BYTE),
  SOS                    VARCHAR2(3 BYTE),
  SOS_MOD_CD             VARCHAR2(3 BYTE),
  SUBCLASS_OF_SUPPLY_CD  CHAR(1 BYTE),
  UI                     VARCHAR2(20 BYTE),
  UM                     VARCHAR2(20 BYTE),
  UNIT_PRICE             NUMBER,
  EST_UP_IND             CHAR(1 BYTE),
  EFF_DATE               DATE,
  STATUS                 CHAR(1 BYTE),
  LST_UPDT               DATE,
  UPDT_BY                VARCHAR2(20 BYTE)
)
PARTITION BY RANGE (TO_DT) 
(  
  PARTITION P_I_C_H_OLD VALUES LESS THAN (TO_DATE(' 2002-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002 VALUES LESS THAN (TO_DATE(' 2003-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003 VALUES LESS THAN (TO_DATE(' 2004-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004 VALUES LESS THAN (TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005 VALUES LESS THAN (TO_DATE(' 2006-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006 VALUES LESS THAN (TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007 VALUES LESS THAN (TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008 VALUES LESS THAN (TO_DATE(' 2009-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR VALUES LESS THAN (MAXVALUE)
    LOGGING
    NOCOMPRESS
)
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

COMMENT ON COLUMN ITEM_CONTROL_HIST.NIIN IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program. The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number. These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN ITEM_CONTROL_HIST.TO_DT IS 'TO DATE - The ending date for a historical record.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.FROM_DT IS 'FROM DATE - The beginning date for a historical record.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.ACT_ORIGN_CD IS 'ACTIVITY ORIGINATOR CODE - This code designates the organization.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.AEC_CD IS 'AIR ELIGIBLE CATEGORY CODE - The code that represents the eligibility of a materiel item for air shipment. Identifies items that are qualified or provisionally qualified for air shipment, or provides the reason an item is disqualified for air shipment.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.ARI_CD IS 'AUTOMATIC RETURN ITEM (ARI) CODE - A one-position, alphabetic code that indicates a supply item is in a critical stock position and may be returned to CONUS depots without disposition instructions (i.e., indicates that an item of supply is authorized to be returned for depot-level maintenance without the prior approval of the materiel manager). (AR 708-1, P. 7-152.)';

COMMENT ON COLUMN ITEM_CONTROL_HIST.CL_OF_SUPPLY_CD IS 'CLASS OF SUPPLY - The code that represents the category of use for which an item of equipment is authorized in support of logistics decisions.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.DEMIL_CD IS 'DEMILITARIZATION CODE - A one-character, alphabetic code that identifies the method and degree of demilitarization to be applied to an item prior to disposal. "Demilitarize" means to make unfit for the intended military use.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.DODIC IS 'DEPARTMENT OF DEFENSE IDENTIFICATION CODE (DODIC) - A four-position, alphanumeric code assigned to a generic description of an item in federal supply groups 13 (Ammunition and Explosives) and 14 (Guided Missiles). A DODIC can also be applied to modified or improved items that are functionally interchangeable with the item first assigned the code.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.ECC IS 'EQUIPMENT CATEGORY CODE - The Equipment Category Code (ECC) is a two-character, alphabetic code that identifies categories of equipment by primary and secondary similarities. It is used to consolidate different stock numbers or weapon systems.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.EIC IS 'END ITEM CODE - The End Item Code (EIC) is a three-position, alphanumeric code used to identify a specific Class VII end item. The EIC uses the full alphabet and the numbers 2-9. (The numbers 1 and 0 are not used.) The EIC is structured so that each position of the code has specific meaning: (1) The first position identifies the National Inventory Control Point (NICP) manager and is a broad categorization, generally descriptive of the item but not identifying specific items. (2) The second position provides for a further subdivision of the broad category established by the first position. By using the first position as a base, the two-position combination identifies a broad generic family of end items. (3) The third position is used in combination with the first two positions to identify a specific end item, i.e., National Item Identification Number (NIIN), within a generic classification. This three-position identification is unique to a single Class VII end item. An EIC is assigned to each end item managed or used by the Army that meets all of the following criteria: (1) The NSN is recorded in the AMDF. (2) The end item is classified as standard, low-rate production, or limited procurement-urgent per AR 70-1. (3) The end item is assigned an appropriation/budget activity account code of A - Q (inclusive).';

COMMENT ON COLUMN ITEM_CONTROL_HIST.ESNTL_CD IS 'ESSENTIALITY CODE - The code that represents the military worth of a materiel item and how its failure, if a replacement is not readily available, would affect the ability of the weapons system, end item, or organization to perform its intended missions and functions.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.FSC IS 'FEDERAL SUPPLY CLASSIFICATION - The first four digits of the National Stock Number (NSN). The Federal Supply Classification (FSC) is a four-character, numeric code identifying the group and class of an item of supply. This code separates items into common groups. The first two digits of the FSC are known as the Federal Group (FG). The FG is used to group items in broad categories by commodity. The second two digits of the FSC further define the items into similar groups of related items.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.FSG IS 'FEDERAL SUPPLY GROUP - The first two digits of the Federal Supply Class (FSC). Used to categorize items by commodity.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.MAINT_RPR_CD IS 'MAINTENANCE REPAIR CODE - Indicates whether the item is to be repaired and identifies the lowest maintenance level capable of performing all authorized maintenance functions (i.e., remove, replace, repair, assemble, and test). (AR 708-1, pp. 7-159)';

COMMENT ON COLUMN ITEM_CONTROL_HIST.MAT_CAT_CD_1 IS 'MATERIEL CATEGORY INVENTORY MANAGER - The first position (alphabetic) of the five-position, alphanumeric Materiel Category Structure Code (MATCAT). Position 1 is the Materiel Category and Inventory Manager or National Inventory Control Point (NICP) Service Item Control Center. It is used to show the materiel category structure detail for management of Army inventories. It identifies the materiel categories of principal and secondary items to the CONUS inventory manager, National Inventory Control Point (NICP), or, in the case of Defense Logistics Agency (DLS)/General Services Administration (GSA) managed items, the Army Class Manager Activity (ACMA) that exercises managerial responsibility. (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN ITEM_CONTROL_HIST.MAT_CAT_CD_2 IS 'APPROPRIATION BUDGET ACTIVITY ACCOUNTING CODE - The second position of the Army Materiel Category Structure Code (MATCAT). Identifies the appropriation category, appropriation, and budget project. Used to identify investment or expense-type items.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.MAT_CAT_CD_3 IS 'MANAGEMENT INVENTORY SEGMENT CODE - The third position of the Army Materiel Category Structure Code (MATCAT). Provides a further subdivision of those categories identified by positions 1 and 2.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.MAT_CAT_CD_4 IS 'MATERIEL CATEGORY CODE POSITION 4 - The fourth position of the Army Materiel Category Structure Code (MATCAT). This is the specific group or generic code. Fourth position codes are either alphabetic or numeric, excluding the letter O and the numeral 1. This code provides further subdivision of those items identified by positions 1 through 3. For Army-managed items, these codes, along with the codes assigned to position 5, identify a generic category of weapons systems, end items, or a homogeneous group of items. For DLA or GSA-managed items and medical or dental items, this position is numeric 0, except for those DLA or GSA items that apply to an Army weapon system or end item and carry the appropriate generic code.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.MAT_CAT_CD_4_5 IS 'MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT). Position 4 is the specific group/generic code. It is alphanumeric, excluding the letter O and the numeral 1. This code provides further subdivision of those items identified by Positions 1 - 3. Position 5 is the generic category code. It is alphanumeric, excluding the letters I and O. This code identifies items to weapons systems/end items or other applications. (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN ITEM_CONTROL_HIST.NOMEN_35 IS 'NOMENCLATURE - The descriptive name of an item, usually identifying some characteristics of the item.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.RECOV_CD IS 'RECOVERABILITY CODE - The code that represents the lowest level of maintenance authorized to determine that a materiel item is not economically repairable and should be sent to property disposal.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.RICC IS 'REPORTABLE ITEM CONTROL CODE - The Reportable Item Control Code (RICC) is a one-digit, alphanumeric code assigned to an item to identify the type of reporting the asset requires under the provisions of AR 710-3. The RICC identifies items of supply that are to be reported to higher authority and the type of reporting required.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.SOS IS 'SOURCE OF SUPPLY (SOS) CODE - Identifies a specific supply and distribution organization by its military service / governmental ownership and geographical location. The Source of Supply (SOS) code is used to identify the activity that is to receive requisitions for a given item of supply. The activity can be an Army wholesale supply organization or another federal agency.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.SOS_MOD_CD IS 'SOURCE OF SUPPLY MODIFIER CODE - A code that represents routing information for requisitions that cannot be addressed to a single MILSTRIP routing identifier or for requisitions to which a single routing identifier cannot be assigned.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.SUBCLASS_OF_SUPPLY_CD IS 'SUBCLASSIFICATION OF SUPPLY CODE - The code that represents a subdivision of the supply category of materiel code. The further identification of an item of supply to a specific commodity.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.UM IS 'UNIT OF MEASURE - The Unit of Measure (UM) code is a two-position, alphabetic code that indicates a known physical measurement (length, volume, or weight) or count of an item (foot, gallon, pound, each, dozen, or gross).';

COMMENT ON COLUMN ITEM_CONTROL_HIST.EST_UP_IND IS 'ESTIMATED UNIT PRICE INDICATOR - An LIDB internal field used to identify National Item Identification Numbers (NIINs) that have an estimated price. After the official price is published, the Estimated Unit Price Indicator (together with cross-reference tables) is used to identify and update the tagged historical prices (in Demands and Maintenance) with the correct price.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.EFF_DATE IS 'EFFECTIVE DATE - The date ACSP processes the transaction.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.STATUS IS 'STATUS - Indicates the status of the record.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.LST_UPDT IS 'LAST UPDATE - Indicates when the record was last updated.';

COMMENT ON COLUMN ITEM_CONTROL_HIST.UPDT_BY IS 'UPDATED BY - Indicates either the program name or user ID of the person who updated the record.';


CREATE INDEX ICH_LOCAL_MTCTCD45_COS_NDX ON ITEM_CONTROL_HIST
(MAT_CAT_CD_4_5, CL_OF_SUPPLY_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_NIIN_LST_UPDT_NDX ON ITEM_CONTROL_HIST
(NIIN, LST_UPDT)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_NIIN_SOS_NDX ON ITEM_CONTROL_HIST
(NIIN, SOS)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_RECOV_CD_NDX ON ITEM_CONTROL_HIST
(RECOV_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_RICC_NDX ON ITEM_CONTROL_HIST
(RICC)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_SOS_CD_NDX ON ITEM_CONTROL_HIST
(SUBCLASS_OF_SUPPLY_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_SOS_MOD_CD_NDX ON ITEM_CONTROL_HIST
(SOS_MOD_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE UNIQUE INDEX PK_ITEMCTRH ON ITEM_CONTROL_HIST
(NIIN, TO_DT)
LOGGING
NOPARALLEL;


CREATE INDEX ICH_LOCAL_ACT_ORIGN_CD_NDX ON ITEM_CONTROL_HIST
(ACT_ORIGN_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_AEC_CD_NDX ON ITEM_CONTROL_HIST
(AEC_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_ARI_CD_NDX ON ITEM_CONTROL_HIST
(ARI_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_CL_OF_SUPPLY_CD_NDX ON ITEM_CONTROL_HIST
(CL_OF_SUPPLY_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX IE_ITM_HIST_NIIN_IDX ON ITEM_CONTROL_HIST
(NIIN)
LOGGING
NOPARALLEL;


CREATE INDEX ICH_LOCAL_MAT_CAT_CD_4_5_NDX ON ITEM_CONTROL_HIST
(MAT_CAT_CD_4_5)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_MAT_CAT_CD_4_NDX ON ITEM_CONTROL_HIST
(MAT_CAT_CD_4)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_MAINT_RPR_CD_NDX ON ITEM_CONTROL_HIST
(MAINT_RPR_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_MAT_CAT_CD_1_NDX ON ITEM_CONTROL_HIST
(MAT_CAT_CD_1)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_MAT_CAT_CD_2_NDX ON ITEM_CONTROL_HIST
(MAT_CAT_CD_2)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_MAT_CAT_CD_3_NDX ON ITEM_CONTROL_HIST
(MAT_CAT_CD_3)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_DEMIL_CD_NDX ON ITEM_CONTROL_HIST
(DEMIL_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_DODIC_NDX ON ITEM_CONTROL_HIST
(DODIC)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_ECC_NDX ON ITEM_CONTROL_HIST
(ECC)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_ESNTL_CD_NDX ON ITEM_CONTROL_HIST
(ESNTL_CD)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_FSC_NDX ON ITEM_CONTROL_HIST
(FSC)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE INDEX ICH_LOCAL_FSG_NDX ON ITEM_CONTROL_HIST
(FSG)
  LOCAL (  
  PARTITION P_I_C_H_OLD
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2002
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2003
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2004
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2005
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2006
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2007
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_2008
    LOGGING
    NOCOMPRESS,  
  PARTITION P_I_C_H_CURR
    LOGGING
    NOCOMPRESS
)
NOPARALLEL;


CREATE PUBLIC SYNONYM ITEM_CONTROL_HIST FOR ITEM_CONTROL_HIST;


ALTER TABLE ITEM_CONTROL_HIST ADD (
  CONSTRAINT PK_ITEMCTRH
 PRIMARY KEY
 (NIIN, TO_DT));


GRANT SELECT ON  ITEM_CONTROL_HIST TO DISCOV_VIEWS WITH GRANT OPTION;

GRANT SELECT ON  ITEM_CONTROL_HIST TO LIW_BASIC;

GRANT SELECT ON  ITEM_CONTROL_HIST TO LIW_RESTRICTED;

GRANT SELECT ON  ITEM_CONTROL_HIST TO S_ITEM1;


