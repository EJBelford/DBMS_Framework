-- DROP TABLE pfsa_maint_items_tmp; 

CREATE TABLE pfsa_maint_items_tmp
(
  MAINT_EV_ID    VARCHAR2(40 BYTE)              NOT NULL,
  MAINT_TASK_ID  VARCHAR2(50 BYTE)              NOT NULL,
  MAINT_ITEM_ID  VARCHAR2(37 BYTE)              NOT NULL,
  CAGE_CD        VARCHAR2(5 BYTE),
  PART_NUM       VARCHAR2(32 BYTE),
  NIIN           VARCHAR2(9 BYTE),
  PART_SN        VARCHAR2(32 BYTE),
  NUM_ITEMS      NUMBER,
  CNTLD_EXCHNG   VARCHAR2(1 BYTE),
  REMOVED        VARCHAR2(1 BYTE),
  FAILURE        VARCHAR2(1 BYTE),
  LST_UPDT       DATE,
  UPDT_BY        VARCHAR2(30 BYTE),
  HEIR_ID        VARCHAR2(20 BYTE),
  PRIORITY       NUMBER,
  DOC_NO         VARCHAR2(14 BYTE),
  DOC_NO_EXPAND  VARCHAR2(18 BYTE),
  PART_UID       VARCHAR2(78 BYTE)
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          8M
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


COMMENT ON TABLE pfsa_maint_items_tmp IS 'PFSA_MAINT_ITEMS_TMP - This table documents all items used/consumed during a maintenance event';


COMMENT ON COLUMN pfsa_maint_items_tmp.HEIR_ID IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN pfsa_maint_items_tmp.PRIORITY IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN pfsa_maint_items_tmp.DOC_NO IS 'DOC_NO - A unique number used to identify a requisition.  Consists of 1 4 alphanumeric positions.  This number is comprised of three elements.  For MILSTRIP transactions, the following three elements are used:  (1) Requisitioner (DODAAC).  (2) Julian Date - A four-digit code that represents the date.  The first position shows the last numeric position of the calendar year and the last three positions of the numeric consecutive day.  (3) Serial Number - A four-position, alphanumeric code assigned by the PBO.  Serial numbers are assigned daily at the discretion of the PBO.  For Property Book transactions, the following three elements are used:  (1) Unit Identification Code (UIC); (2) Julian Date; and (3)Serial Number.  (DOD 4000.25-1.M, MILSTRIP, Appendix B7, page B7-1)';

COMMENT ON COLUMN pfsa_maint_items_tmp.DOC_NO_EXPAND IS 'A LOGSA generated data element which expands the julian date embedded in the document number to a four character year.  This allows the unique identification of document numbers which are re-generated every 10 years';

COMMENT ON COLUMN pfsa_maint_items_tmp.PART_UID IS 'The Department of Defense unique identifier for the maintenance part.';

COMMENT ON COLUMN pfsa_maint_items_tmp.MAINT_EV_ID IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN pfsa_maint_items_tmp.MAINT_TASK_ID IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN pfsa_maint_items_tmp.MAINT_ITEM_ID IS 'MAINT_ITEM_ID - The identifier that when combined with the MAINT_EV_ID and MAINT_TASK_ID creates a unique maintenance task part id.';

COMMENT ON COLUMN pfsa_maint_items_tmp.CAGE_CD IS 'COMMERCIAL AND GOVERNMENT ENTITY (CAGE) CODE - The Commercial and Government Entity (CAGE) Code is a five-character code assigned by the Defense Logistics Information Service (DLIS) to the design control activity or actual manufacturer of an item.';

COMMENT ON COLUMN pfsa_maint_items_tmp.PART_NUM IS 'PART_NUM - PART NUMBER - This field may contain a 13-digit FSC/NIIN, ACVC, Manufacturers Control Number, or a part number of variable length.';

COMMENT ON COLUMN pfsa_maint_items_tmp.NIIN IS 'NIIN - The NIIN of the repair part installed/consumable used during the maintenance event.';

COMMENT ON COLUMN pfsa_maint_items_tmp.PART_SN IS 'PART_SN - The serial number of the repair part installed during the maintenance event.';

COMMENT ON COLUMN pfsa_maint_items_tmp.NUM_ITEMS IS 'NUM_ITEMS - The number items with this NIIN used as part of the maintenance event and task.';

COMMENT ON COLUMN pfsa_maint_items_tmp.CNTLD_EXCHNG IS 'CNTLD_EXCHNG - A flag indicating is controlled exchange item. Values are F\T\U';

COMMENT ON COLUMN pfsa_maint_items_tmp.REMOVED IS 'REMOVED - A flag indicating that the item was removed. Values are F\T\U';

COMMENT ON COLUMN pfsa_maint_items_tmp.FAILURE IS 'FAILURE - A flag indicating that the item failed. Values are F\T\U';

COMMENT ON COLUMN pfsa_maint_items_tmp.LST_UPDT IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN pfsa_maint_items_tmp.UPDT_BY IS 'UPDT_BY - Who/what updated the record.';


