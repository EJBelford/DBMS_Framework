SELECT * FROM dba_tables WHERE table_name = UPPER('GB_PFSA_ITEM_PART_BLD') 
	AND OWNER = 'PFSAWH';
	
--IF EXISTS (SELECT * FROM dba_tables WHERE table_name = 'GB_PFSA_ITEM_PART_BLD') 
	DROP TABLE GB_PFSA_ITEM_PART_BLD;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: PFSA_ITEM_PART_BLD
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: PFSA_ITEM_PART_BLD.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: December 17, 2007
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----*/
--
--
CREATE TABLE GB_PFSA_ITEM_PART_BLD
(
  niin                    VARCHAR2(9)                NOT NULL,
--
  nsn                     VARCHAR2(13),  
  mcn                     VARCHAR2(13),  
  fsc                     VARCHAR2(4),  
  ecc                     VARCHAR2(2),
  mat_cat_cd_4_5          VARCHAR2(2), 
  cl_of_supply_cd         VARCHAR2(2),
--  
  lin                     VARCHAR2(6),  
-- 
  auth_item_SHRT_NOMEN    VARCHAR2(30),  
  item_ctrl_NOMEN_35      VARCHAR2(35), 
  item_data_FULL_NOMEN    VARCHAR2(110), 
  lin_GEN_NOMEN           VARCHAR2(70),  
-- 
  part_CAGE_CD            VARCHAR2(5), 
  part_MFG_PART_NUM       VARCHAR2(32), 
  part_ACT_MEAS           VARCHAR2(11),
  part_DAC                CHAR(1),
  part_RADIONUCLIDE       VARCHAR2(5),
  part_RNAAC              VARCHAR2(2),
  part_RNCC               CHAR(1),
  part_RNJC               CHAR(1),
  part_RNVC               CHAR(1),
  part_SADC               VARCHAR2(2),
--  
  part_LST_UPDT           DATE,
  part_STATUS             CHAR(1),
  part_UPDT_BY            VARCHAR2(30),
  record_source           VARCHAR2(30)
)
LOGGING 
NOCOMPRESS 
NOCACHE
PARALLEL ( DEGREE 1 INSTANCES DEFAULT )
MONITORING;

/*----- Indexs -----*/

DROP INDEX IXU_PFSA_ITEM_PART_NIIN_BLD;

CREATE INDEX IXU_PFSA_ITEM_PART_NIIN_BLD 
    ON GB_PFSA_ITEM_PART_BLD (niin);


CREATE UNIQUE INDEX PKMANUFACTURER_PART ON MANUFACTURER_PART
(NIIN, CAGE_CD, MFG_PART_NUM)
LOGGING
NOPARALLEL;


CREATE INDEX FK_MANUFACTURER_PART_NIIN ON MANUFACTURER_PART
(NIIN)
LOGGING
NOPARALLEL;


CREATE INDEX MFG_PART_NUM_IX ON MANUFACTURER_PART
(MFG_PART_NUM)
LOGGING
NOPARALLEL;


CREATE INDEX IF_NIIN_MFG_PART_2_NUM ON MANUFACTURER_PART
(NIIN, MFG_PART_NUM)
LOGGING
NOPARALLEL;


CREATE PUBLIC SYNONYM MANUFACTURER_PART FOR MANUFACTURER_PART;


ALTER TABLE MANUFACTURER_PART ADD (
  CONSTRAINT PKMANUFACTURER_PART
 PRIMARY KEY
 (NIIN, CAGE_CD, MFG_PART_NUM));


/*----- Table Meta-Data -----*/ 

comment on table GB_PFSA_ITEM_PART_BLD 
is 'n/a'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.lin IS 'LINE ITEM NUMBER - The LIN is a six-character alphanumeric identification of the generic nomenclature assigned to identify nonexpendable and type-classified expendable or durable items of equipment during their life cycle 20 AR 71–32 authorization and supply management.';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.auth_item_SHRT_NOMEN IS 'NOMENCLATURE - The name of an item. Usually the name describes or identifies characteristics of the item.';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.item_ctrl_NOMEN_35 IS 'NOMENCLATURE - The descriptive name of an item, usually identifying some characteristics of the item.'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.item_data_FULL_NOMEN IS 'NOMENCLATURE - The name of an item. Usually the name describes or identifies characteristics of the item.'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.lin_GEN_NOMEN IS 'NOMENCLATURE - The descriptive name of an item, usually identifying some characteristics of the item.'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_ACT_MEAS IS ''; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_CAGE_CD IS 'COMMERCIAL AND GOVERNMENT ENTITY - '; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_DAC IS ''; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.nsn IS 'NATIONAL STOCK NUMBER - ';  

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.mcn IS '';  

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.fsc IS 'FEDERAL SUPPLY CLASSIFICATION - The first four digits of the National Stock Number (NSN). The Federal Supply Classification (FSC) is a four-character, numeric code identifying the group and class of an item of supply. This code separates items into common groups. The first two digits of the FSC are known as the Federal Group (FG). The FG is used to group items in broad categories by commodity. The second two digits of the FSC further define the items into similar groups of related items.';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ecc IS 'EQUIPMENT CATEGORY CODE - A two-position alphabetical code. The first letter identifies the primary category of equipment. The two-position ECC is used in ADP systems to produce the complete description of an item of equipment by make, model, noun nomenclature, line number, and national stock number if desired or required. It is also entered in specified blocks or positions on manually produced data source documents.';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.mat_cat_cd_4_5 IS 'MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT). Position 4 is the specific group/generic code. It is alphanumeric, excluding the letter O and the numeral 1. This code provides further subdivision of those items identified by Positions 1 - 3. Position 5 is the generic category code. It is alphanumeric, excluding the letters I and O. This code identifies items to weapons systems/end items or other applications. (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.cl_of_supply_cd IS 'CLASS OF SUPPLY - The code that represents the category of use for which an item of equipment is authorized in support of logistics decisions.';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_LST_UPDT IS 'LAST UPDATE - Indicates when the record was last updated.'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_MFG_PART_NUM IS 'MANUFACTURER PART NUMBER (PMR) - '; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.niin IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program. The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number. These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_RADIONUCLIDE IS ''; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_RNAAC IS ''; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_RNCC IS 'Reference Number Category Code - '; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_RNJC IS ''; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_RNVC IS 'Reference Number Variation Code - '; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_SADC IS ''; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_STATUS IS 'STATUS - Indicates the status of the record.'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.part_UPDT_BY IS 'UPDATED BY - Indicates either the program name or user ID of the person who updated the record.'; 

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.record_source IS '';

COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ACQ_AD_CD IS 'ACQUISITION ADVICE CODE - The Acquisition Advice Code (AAC) is a one-position, alphabetic code that informs the requisitioner how, and under what conditions, an item will be acquired. It does not specify the source of supply for the item.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ACQ_METH_CD IS 'ACQUISITION METHOD CODE - The code that represents the acquisition technique for a materiel item as a result of planned procurement review.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ACQ_METH_SFX_CD IS 'ACQUISITION METHOD SUFFIX CODE - The code that represents the primary reason for the acquisition method assigned by the applied MOE rule.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ACT_ORIGN_CD IS 'ACTIVITY ORIGINATOR CODE - This code designates the organization.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ACTNG_RQMT_CD IS 'ACCOUNTING REQUIREMENTS CODE - This field labels an item as nonexpendable, expendable, or durable.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ADPE_ID_CD IS 'AUTOMATIC DATA PROCESSING EQUIPMENT IDENTIFICATION CODE - Identifies an item of ADPE or an item containing ADPE equipment.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.AEC_CD IS 'AIR ELIGIBLE CATEGORY CODE - The code that represents the eligibility of a materiel item for air shipment. Identifies items that are qualified or provisionally qualified for air shipment, or provides the reason an item is disqualified for air shipment.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ARI_CD IS 'AUTOMATIC RETURN ITEM (ARI) CODE - A one-position, alphabetic code that indicates a supply item is in a critical stock position and may be returned to CONUS depots without disposition instructions (i.e., indicates that an item of supply is authorized to be returned for depot-level maintenance without the prior approval of the materiel manager). (AR 708-1, P. 7-152.)';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.CIIC IS 'CONTROLLED ITEM INVENTORY CODE - Identifies the Controlled Inventory Item Code (CIIC) and explanation. Indicates the security classification security risk or pilferage controls required for storage and transportation of assets.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.CRIT_CD IS 'CRITICALITY CODE - This code indicates that an item is technically critical by reason of tolerance, fit restrictions, application, nuclear hardness properties, or other characteristics that affect identification of the item.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.DEL_REASON_CD IS 'INTERCHANGE AND SUBSTITUTE DELETION REASON CODE - The Interchange and Substitute (I) Deletion Reason Code is a one-position, alphabetic code that explains the reason for deleting I data from Part 1 of Sections I and II of the I segment. I data deleted by reason code C will be placed in the history segment of the AMDF by LOGSA. I data deleted by reason codes A, B, or D will not be placed in the history segment.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.DEMIL_CD IS 'DEMILITARIZATION CODE - A one-character, alphabetic code that identifies the method and degree of demilitarization to be applied to an item prior to disposal. "Demilitarize" means to make unfit for the intended military use.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.DODIC IS 'DEPARTMENT OF DEFENSE IDENTIFICATION CODE (DODIC) - A four-position, alphanumeric code assigned to a generic description of an item in federal supply groups 13 (Ammunition and Explosives) and 14 (Guided Missiles). A DODIC can also be applied to modified or improved items that are functionally interchangeable with the item first assigned the code.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ECC IS 'EQUIPMENT CATEGORY CODE - The Equipment Category Code (ECC) is a two-character, alphabetic code that identifies categories of equipment by primary and secondary similarities. It is used to consolidate different stock numbers or weapon systems.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.EFF_DATE IS 'EFFECTIVE DATE - The date ACSP processes the transaction.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.EFF_DT IS 'EFFECTIVE DATE - The date on which a change in the status of a person, place, or thing becomes effective or official.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.EIC IS 'END ITEM CODE - The End Item Code (EIC) is a three-position, alphanumeric code used to identify a specific Class VII end item. The EIC uses the full alphabet and the numbers 2-9. (The numbers 1 and 0 are not used.) The EIC is structured so that each position of the code has specific meaning: (1) The first position identifies the National Inventory Control Point (NICP) manager and is a broad categorization, generally descriptive of the item but not identifying specific items. (2) The second position provides for a further subdivision of the broad category established by the first position. By using the first position as a base, the two-position combination identifies a broad generic family of end items. (3) The third position is used in combination with the first two positions to identify a specific end item, i.e., National Item Identification Number (NIIN), within a generic classification. This three-position identification is unique to a single Class VII end item. An EIC is assigned to each end item managed or used by the Army that meets all of the following criteria: (1) The NSN is recorded in the AMDF. (2) The end item is classified as standard, low-rate production, or limited procurement-urgent per AR 70-1. (3) The end item is assigned an appropriation/budget activity account code of A - Q (inclusive).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ELECTROSTATIC_DISCHARGE_ID IS 'ELECTROSTATIC DISCHARGE INDICATOR - The Electrostatic Discharge (ESDC) field indicates whether an item is susceptible to electrostatic discharge or electromagnetic interference damage.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ESNTL_CD IS 'ESSENTIALITY CODE - The code that represents the military worth of a materiel item and how its failure, if a replacement is not readily available, would affect the ability of the weapons system, end item, or organization to perform its intended missions and functions.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.EST_UP_IND IS 'ESTIMATED UNIT PRICE INDICATOR - An LIDB internal field used to identify National Item Identification Numbers (NIINs) that have an estimated price. After the official price is published, the Estimated Unit Price Indicator (together with cross-reference tables) is used to identify and update the tagged historical prices (in Demands and Maintenance) with the correct price.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.FROM_DT IS 'FROM DATE - The beginning date for a historical record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.FROM_DT IS 'FROM DATE - The beginning date for a historical record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.FSG IS 'FEDERAL SUPPLY GROUP - The first two digits of the Federal Supply Class (FSC). Used to categorize items by commodity.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.FULL_NOMEN IS 'NOMENCLATURE - The name of an item. Usually the name describes or identifies characteristics of the item.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.FUND_CD IS 'FUND CODE - Prescribed for Army appropriations and funds. Provides data for supply and financial management. Used by the consumer for requisitions funding of stock fund items.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.HAZ_MAT_ID_CD IS 'HAZARDOUS MATERIAL INDICATOR CODE - Defense Logistics Information Service (DLIS) input that identifies an item determined to be hazardous.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ID_NUM_CD IS 'IDENTIFYING NUMBER CODE - This field indicates the kind of number that is in the NIIN field (for example, MCN, ACVC, Manufacturing Part Number, etc.).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.INTER_SUB_ID IS 'INTERCHANGE AND SUBSTITUTE INDICATOR - A single-character code that indicates the existence of Interchange and Substitute (I) data.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.INV_CAT_CD IS 'INVENTORY CATEGORY CODE - A code used to group items of supply into lots or segments of similar items for inventory and research purposes.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ITEM_DPTH IS 'ITEM DEPTH - Depth of an item to the nearest one-tenth inch.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ITEM_LGTH IS 'ITEM LENGTH - Length of an item to the nearest one-tenth inch.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ITEM_MGMT_CODING_ACT IS 'ITEM MANAGEMENT CODING ACTIVITY - The Item Management Coding Activity (IMCA) code is a one-digit code that indicates whether items of supply shall be subjected to integrated management under the Defense Logistics Agency/General Services Administration or retained by the individual military service.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ITEM_NAME_CD IS 'ITEM NAME CODE - A code assigned by the Defense Logistics Information Service (DLIS). It is used to group like items.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.ITEM_WDTH IS 'ITEM WIDTH - Width of an item to the nearest one-tenth inch.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.LC_CD IS 'LOGISTICS CONTROL CODE - The Logistics Control Code (LCC) is assigned to items of materiel authorized for use. It is used to assist in determining and providing logistic support decisions (i.e., procurement, overhaul, provisioning).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.LIFE_EXPECTANCY IS 'LIFE EXPECTANCY - The number of years this item can reasonably be expected to last.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.LST_UPDT IS 'LAST UPDATE - Indicates when the record was last updated.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.LST_UPDT IS 'LAST UPDATE - Indicates when the record was last updated.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MAINT_RPR_CD IS 'MAINTENANCE REPAIR CODE - Indicates whether the item is to be repaired and identifies the lowest maintenance level capable of performing all authorized maintenance functions (i.e., remove, replace, repair, assemble, and test). (AR 708-1, pp. 7-159)';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MAT_CAT_CD_1 IS 'MATERIEL CATEGORY INVENTORY MANAGER - The first position (alphabetic) of the five-position, alphanumeric Materiel Category Structure Code (MATCAT). Position 1 is the Materiel Category and Inventory Manager or National Inventory Control Point (NICP) Service Item Control Center. It is used to show the materiel category structure detail for management of Army inventories. It identifies the materiel categories of principal and secondary items to the CONUS inventory manager, National Inventory Control Point (NICP), or, in the case of Defense Logistics Agency (DLS)/General Services Administration (GSA) managed items, the Army Class Manager Activity (ACMA) that exercises managerial responsibility. (Ref. CDA PAM NO. 18-1.)';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MAT_CAT_CD_2 IS 'APPROPRIATION BUDGET ACTIVITY ACCOUNTING CODE - The second position of the Army Materiel Category Structure Code (MATCAT). Identifies the appropriation category, appropriation, and budget project. Used to identify investment or expense-type items.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MAT_CAT_CD_3 IS 'MANAGEMENT INVENTORY SEGMENT CODE - The third position of the Army Materiel Category Structure Code (MATCAT). Provides a further subdivision of those categories identified by positions 1 and 2.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MAT_CAT_CD_4 IS 'MATERIEL CATEGORY CODE POSITION 4 - The fourth position of the Army Materiel Category Structure Code (MATCAT). This is the specific group or generic code. Fourth position codes are either alphabetic or numeric, excluding the letter O and the numeral 1. This code provides further subdivision of those items identified by positions 1 through 3. For Army-managed items, these codes, along with the codes assigned to position 5, identify a generic category of weapons systems, end items, or a homogeneous group of items. For DLA or GSA-managed items and medical or dental items, this position is numeric 0, except for those DLA or GSA items that apply to an Army weapon system or end item and carry the appropriate generic code.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MAT_CAT_CD_4_5 IS 'MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT). Position 4 is the specific group/generic code. It is alphanumeric, excluding the letter O and the numeral 1. This code provides further subdivision of those items identified by Positions 1 - 3. Position 5 is the generic category code. It is alphanumeric, excluding the letters I and O. This code identifies items to weapons systems/end items or other applications. (Ref. CDA PAM NO. 18-1.)';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.MOE_RULE_ID IS 'MAJOR ORGANIZATIONAL ENTITY RULE IDENTIFIER - The identifier of a materiel management relationship.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.NIIN IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program. The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number. These nine digits are the latter part of the 13-digit National Stock Number (NSN).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.NIIN IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program. The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number. These nine digits are the latter part of the 13-digit National Stock Number (NSN).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.NIIN_STATUS_CD IS 'NATIONAL ITEM IDENTIFICATION NUMBER STATUS CODE - This code indicates the status of the National Item Identification Number (NIIN).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.NIMSC IS 'NON-CONSUMABLE ITEM MATERIEL SUPPORT CODE - This code determines the degree of support received by an individual Secondary Inventory Control Activity (SICA) or identifies the service performing depot maintenance for a Primary Inventory Control Activity (PICA).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.NOMEN_35 IS 'NOMENCLATURE - The descriptive name of an item, usually identifying some characteristics of the item.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.PHRS_CD IS 'PHRASE CODE - The code that represents the phrase statement delineating the relationship between the materiel item and the related materiel item or supply item control technical document identifier.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.PRECIOUS_METALS_CD IS 'PRECIOUS METALS INDICATOR CODE - The Precious Metals Indicator Code (PMIC) identifies items that have precious metals as part of their content. Precious metals are those metals considered uncommon and highly valuable.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.PRICE_SGNL_CD IS 'PRICE SIGNAL CODE - This field denotes how the price is expressed.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.RECOV_CD IS 'RECOVERABILITY CODE - The code that represents the lowest level of maintenance authorized to determine that a materiel item is not economically repairable and should be sent to property disposal.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.REG_NUM_REQ IS 'REGISTRATION NUMBER REQUIRED - This field indicates if a registration number is required for this NIIN. Valid values are Y and N. The default value is N. Maintained through TEDB.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.REL_NIIN IS 'RELATED NATIONAL ITEM IDENTIFICATION NUMBER - The related NIIN, or medical or technical document number. Can be blank, zero-filled, or contain the appropriate entry, as defined by the Phrase Code of the NIIN.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.RICC IS 'REPORTABLE ITEM CONTROL CODE - The Reportable Item Control Code (RICC) is a one-digit, alphanumeric code assigned to an item to identify the type of reporting the asset requires under the provisions of AR 710-3. The RICC identifies items of supply that are to be reported to higher authority and the type of reporting required.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.SCIC IS 'SPECIAL CONTROL ITEM CODE - A code that represents different hazardous items. All codes other than zero (0) will have an associated record in the Hazard table.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.SHLF_LIFE_CD IS 'SHELF LIFE CODE - The Shelf Life Code (SLC) represents the period of time during which a materiel item remains usable.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.SOS IS 'SOURCE OF SUPPLY (SOS) CODE - Identifies a specific supply and distribution organization by its military service / governmental ownership and geographical location. The Source of Supply (SOS) code is used to identify the activity that is to receive requisitions for a given item of supply. The activity can be an Army wholesale supply organization or another federal agency.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.SOS_MOD_CD IS 'SOURCE OF SUPPLY MODIFIER CODE - A code that represents routing information for requisitions that cannot be addressed to a single MILSTRIP routing identifier or for requisitions to which a single routing identifier cannot be assigned.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.SPEC_RQMT_CD IS 'SPECIAL REQUIREMENTS CODE - The identification of supply functions that must be performed in accordance with specified documents.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.STATUS IS 'STATUS - Indicates the status of the record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.STATUS IS 'STATUS - Indicates the status of the record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.SUBCLASS_OF_SUPPLY_CD IS 'SUBCLASSIFICATION OF SUPPLY CODE - The code that represents a subdivision of the supply category of materiel code. The further identification of an item of supply to a specific commodity.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.TECH_DOC_NUM IS 'TECHNICAL DOCUMENT NUMBER - Any identifying number assigned to this item.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.TO_DT IS 'TO DATE - The ending date for a historical record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.TO_DT IS 'TO DATE - The ending date for a historical record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UI_CONV_DEC_LOC IS 'UNIT OF ISSUE CONVERSION DECIMAL LOCATOR - The decimal locator indicates the number of places from the right that the decimal is located.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UI_CONV_MULTIPLIER IS 'UNIT OF ISSUE CONVERSION MULTIPLIER - The factor used to convert the unit of issue to another unit of issue (i.e., FT to RO; EA to PG).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UM IS 'UNIT OF MEASURE - The Unit of Measure (UM) code is a two-position, alphabetic code that indicates a known physical measurement (length, volume, or weight) or count of an item (foot, gallon, pound, each, dozen, or gross).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UM_CD IS 'UNIT OF MEASURE (UNIT OF ISSUE) CODE - The Unit of Measure (UM) code identifies a known physical measurement or count of an item, issued to satisfy a single requisition. For example, it may be a single item, a dozen, a box, a gross, a set, etc.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UM_DEC_LOC IS 'UNIT OF MEASURE DECIMAL LOCATOR - The decimal locator indicates the number of places from the right of the decimal. Valid values for this field are zero through four (0-4).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UM_QTY IS 'UNIT OF MEASURE QUANTITY - The quantitative expression of the number of items in the unit of measure. (i.e., 10 ea. in 1 pg.).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UNPKGD_ITEM_WT IS 'UNPACKAGED ITEM WEIGHT - A five-position, alphanumeric field that indicates the actual weight of the bare (unpackaged) item. The actual, net weight of item is measured to the nearest one-tenth of a pound (e.g., 9,999.9).';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UPDT_BY IS 'UPDATED BY - Indicates either the program name or user ID of the person who updated the record.';
COMMENT ON COLUMN GB_PFSA_ITEM_PART_BLD.UPDT_BY IS 'UPDATED BY - Indicates either the program name or user ID of the person who updated the record.';

/*----- Check to see if the table comment is present -----*/

SELECT  TABLE_NAME, COMMENTS 
FROM    USER_TAB_COMMENTS 
WHERE   Table_Name = UPPER('GB_PFSA_ITEM_PART_BLD') 

/*----- Check to see if the table column comments are present -----*/

SELECT    b.COLUMN_ID, 
        a.TABLE_NAME, 
        a.COLUMN_NAME, 
        b.DATA_TYPE, 
        b.DATA_LENGTH, 
        b.NULLABLE, 
        a.COMMENTS 
FROM    USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('GB_PFSA_ITEM_PART_BLD') 
    AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE    a.TABLE_NAME = UPPER('GB_PFSA_ITEM_PART_BLD') 
ORDER BY b.COLUMN_ID 

