-- DROP TABLE pfsa_maint_event_tmp;  

CREATE TABLE pfsa_maint_event_tmp
(
  MAINT_EV_ID              VARCHAR2(40 BYTE)    NOT NULL,
  MAINT_ORG                VARCHAR2(32 BYTE),
  MAINT_UIC                VARCHAR2(6 BYTE),
  MAINT_LVL_CD             VARCHAR2(1 BYTE),
  MAINT_ITEM               VARCHAR2(37 BYTE),
  MAINT_ITEM_NIIN          VARCHAR2(9 BYTE),
  MAINT_ITEM_SN            VARCHAR2(32 BYTE),
  NUM_MAINT_ITEM           NUMBER,
  SYS_EI_NIIN              VARCHAR2(9 BYTE),
  SYS_EI_SN                VARCHAR2(32 BYTE),
  NUM_MI_NRTS              NUMBER,
  NUM_MI_RPRD              NUMBER,
  NUM_MI_CNDMD             NUMBER,
  NUM_MI_NEOF              NUMBER,
  DT_MAINT_EV_EST          DATE,
  DT_MAINT_EV_CMPL         DATE,
  SYS_EI_NMCM              VARCHAR2(1 BYTE),
  PHASE_EV                 VARCHAR2(1 BYTE),
  SOF_EV                   VARCHAR2(1 BYTE),
  ASAM_EV                  VARCHAR2(1 BYTE),
  MWO_EV                   VARCHAR2(1 BYTE),
  ELAPSED_ME_WK_TM         NUMBER,
  SOURCE_ID                VARCHAR2(20 BYTE),
  STATUS                   VARCHAR2(1 BYTE),
  LST_UPDT                 DATE,
  UPDT_BY                  VARCHAR2(30 BYTE),
  HEIR_ID                  VARCHAR2(20 BYTE),
  PRIORITY                 NUMBER,
  CUST_ORG                 VARCHAR2(32 BYTE),
  CUST_UIC                 VARCHAR2(6 BYTE),
  FAULT_MALFUNCTION_DESCR  VARCHAR2(80 BYTE),
  WON                      VARCHAR2(12 BYTE),
  LAST_WO_STATUS           VARCHAR2(1 BYTE),
  LAST_WO_STATUS_DATE      DATE,
  ACTIVE_FLAG              VARCHAR2(1 BYTE)     DEFAULT 'Y',
  ACTIVE_DATE              DATE                 DEFAULT sysdate,
  INACTIVE_DATE            DATE                 DEFAULT '01-JAN-1900',
  INSERT_BY                VARCHAR2(30 BYTE)    DEFAULT user,
  INSERT_DATE              DATE                 DEFAULT sysdate,
  UPDATE_BY                VARCHAR2(30 BYTE),
  UPDATE_DATE              DATE                 DEFAULT '01-JAN-1900',
  DELETE_FLAG              VARCHAR2(1 BYTE)     DEFAULT 'N',
  DELETE_DATE              DATE                 DEFAULT '01-JAN-1900',
  DELETE_BY                VARCHAR2(30 BYTE),
  HIDDEN_FLAG              VARCHAR2(1 BYTE)     DEFAULT 'N',
  HIDDEN_DATE              DATE                 DEFAULT '01-JAN-1900',
  HIDDEN_BY                VARCHAR2(30 BYTE),
  FRZ_INPUT_DATE           DATE,
  FRZ_INPUT_DATE_ID        NUMBER,
  RIDB_ON_TIME_FLAG        VARCHAR2(1 BYTE),
  REPORT_DATE              DATE,
  MAINT_EVENT_ID_PART1     VARCHAR2(25 BYTE),
  MAINT_EVENT_ID_PART2     VARCHAR2(30 BYTE)
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2M 
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


COMMENT ON TABLE pfsa_maint_event_tmp IS 'PFSA_MAINT_EVENT_TMP - All maintenance data in the PFSA World is tied to a specific maintenance event.  This table documents all maintenance events.  Maintenance events are assumed to be tied to a specific instance of a system/end item.';


COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_EVENT_ID_PART2 IS 'The second part ot the concatenated key MAINT_EV_ID';

COMMENT ON COLUMN pfsa_maint_event_tmp.HIDDEN_DATE IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN pfsa_maint_event_tmp.HIDDEN_BY IS 'HIDDEN_BY - Reports who initially hid the record.';

COMMENT ON COLUMN pfsa_maint_event_tmp.FRZ_INPUT_DATE IS 'This date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN pfsa_maint_event_tmp.FRZ_INPUT_DATE_ID IS 'This date_dim id of the date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN pfsa_maint_event_tmp.REPORT_DATE IS 'REPORT_DATE - The date the information was actually reported to LOGSA.';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_EVENT_ID_PART1 IS 'The first part of the concatenated key MAINT_EV_ID';

COMMENT ON COLUMN pfsa_maint_event_tmp.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists. Values are Y and N';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_EV_ID IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_ORG IS 'MAINT_ORG - The organization accomplishing the maintenance event.  If a UIC, the value will match the maint_uic.  Field used to identify manufacturer/non-UIC identified contractor maintenance';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_UIC IS 'MAINT_UIC - The UIC provided by the STAMIS system for the Maintenance Event';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_LVL_CD IS 'MAINT_LVL_CD - MAINTENANCE LEVEL CODE - A code assigned to support items to indicate the lowest maintenance level authorized to remove and replace the support item and the lowest maintenance level authorized to completely repair the support item.  The following codes are valid:  O - Organizational maintenance (AVUM); F - Direct support maintenance (AVIM); H - General support maintenance; D - Depot maintenance; C - Crew; L - Special repair activity.  Publications: [(MIL-STD-1388-2B 28 MARCH 1991) C -- Operator/Crew/Unit-Crew.  O -- Organizational/On Equipment/Unit-Organizational.  F -- Intermediate/Direct Support/Afloat/Third Echelon/Off Equipment/Intermediate-Forward.  H -- Intermediate/General Support/Ashore\Fourth Echelon/Intermediate-Rear.  G -- Intermediate/Ashore and Afloat.  D -- Depot/Shipyards.  L -- Specialized Repair Activity.]  [(DA PAM 731-751 15 MARCH 1999) O -- Aviation Unit Maintenance (AVUM), F -- Aviation Intermediate Maintenance (AVIM), D -- Depot, K -- Contractor, L -- Special Repair Activity.] Codes that are assigned to indicate the maintenance levels authorized to perform the required maintenance function (see DED 277 for definitions of the individual O/M Levels).  C -- Operator/Crew/Unit-Crew.  O -- Organizational/On Equipment/Unit-Organizational.  F -- Intermediate/Direct Support/Afloat/Third Echelon/Off quipment/Intermediate-Forward.  H -- Intermediate/General Support/Ashore\Fourth Echelon/Intermediate-Rear.  G -- Intermediate/Ashore and Afloat.  D -- Depot/Shipyards.  L -- Specialized Repair Activity';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_ITEM IS 'MAINT_ITEM - The item maintenance is being performed on';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_ITEM_NIIN IS 'MAINT_ITEM_NIIN - The niin of the item maintenance is being performed on.';

COMMENT ON COLUMN pfsa_maint_event_tmp.MAINT_ITEM_SN IS 'MAINT_ITEM_SN - The serial number of the specific item maintenance is being performed on.';

COMMENT ON COLUMN pfsa_maint_event_tmp.NUM_MAINT_ITEM IS 'NUM_MAINT_ITEM - The number of items identified for the maintenance action.  Frequently 1.';

COMMENT ON COLUMN pfsa_maint_event_tmp.SYS_EI_NIIN IS 'SYS_EI_NIIN - The system\end item niin to which the maintenance event is tied to.  All maintenance events in the PFSA world are tied to a specific system end item type.';

COMMENT ON COLUMN pfsa_maint_event_tmp.SYS_EI_SN IS 'SYS_EI_SN - The serial number of the system end item which the maintenance event is tied to.  Can be aggregated.';

COMMENT ON COLUMN pfsa_maint_event_tmp.NUM_MI_NRTS IS 'NUM_MI_NRTS - The number of maintenance items which were not repairable this station.';

COMMENT ON COLUMN pfsa_maint_event_tmp.NUM_MI_RPRD IS 'NUM_MI_RPRD - The number of maintenance items which were repaired in the maintenance event.';

COMMENT ON COLUMN pfsa_maint_event_tmp.NUM_MI_CNDMD IS 'NUM_MI_CNDMD - The number of maintenance items which were condemned during the maintenance event.';

COMMENT ON COLUMN pfsa_maint_event_tmp.NUM_MI_NEOF IS 'NUM_MI_NEOF - The number of maintenance items where no evidence of failure could be found.';

COMMENT ON COLUMN pfsa_maint_event_tmp.DT_MAINT_EV_EST IS 'DT_MAINT_EV_EST - The date/time stamp of when the maintenance event was established.';

COMMENT ON COLUMN pfsa_maint_event_tmp.DT_MAINT_EV_CMPL IS 'DT_MAINT_EV_CMPL - The date/time stamp of when the maintenance event was completed/closed.';

COMMENT ON COLUMN pfsa_maint_event_tmp.SYS_EI_NMCM IS 'SYS_EI_NMCM - A flag identifying the system/end item was not mission capabile for some portion of the mainteannce event.  Values are Y or N.';

COMMENT ON COLUMN pfsa_maint_event_tmp.PHASE_EV IS 'PHASE_EV - A flag used in PFSA to identify phased maintenance events for aircraft.  values are Y, N, U (unknown, but aircraft) and null, for not applicable.';

COMMENT ON COLUMN pfsa_maint_event_tmp.SOF_EV IS 'SOF_EV - A flag indicating a Safety of Flight (SOF) event.  Values of Y or N';

COMMENT ON COLUMN pfsa_maint_event_tmp.ASAM_EV IS 'ASAM_EV - A flag indicating an Aviation safety Action Message (ASAM) event.  Used to quickly alert field to potential/pending safety issues with aircraft and/or components.  Values are Y or N';

COMMENT ON COLUMN pfsa_maint_event_tmp.MWO_EV IS 'MWO_EV - A flag indicating an Modification Work Order(MWO) event.  Values are Y or N';

COMMENT ON COLUMN pfsa_maint_event_tmp.ELAPSED_ME_WK_TM IS 'ELAPSED_ME_WK_TM - The total elapsed time during the maintenance event when work was being performed, when available from the data source.';

COMMENT ON COLUMN pfsa_maint_event_tmp.SOURCE_ID IS 'SOURCE_ID - The PFSA maintained identification for the source of the data';

COMMENT ON COLUMN pfsa_maint_event_tmp.STATUS IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN pfsa_maint_event_tmp.LST_UPDT IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN pfsa_maint_event_tmp.UPDT_BY IS 'UPDT_BY - Who/what updated the record.';

COMMENT ON COLUMN pfsa_maint_event_tmp.HEIR_ID IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN pfsa_maint_event_tmp.PRIORITY IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN pfsa_maint_event_tmp.CUST_ORG IS 'CUST_ORG - The customer organization orginating the maintenance event.';

COMMENT ON COLUMN pfsa_maint_event_tmp.FAULT_MALFUNCTION_DESCR IS 'FAULT_MALFUNCTION_DESCR - The text description of the fault/problem/malfunction entered on the work order by the maintainer';

COMMENT ON COLUMN pfsa_maint_event_tmp.WON IS 'WON - A unique number assigned to a job order for the purpose of identifying work through materiel maintenance operations.  It is a data chain that consists of the following data elements (listed in order):  Maintenance Activity Designator, Intra-Shop Code, Year Within Decade, and Sequence Number.';

COMMENT ON COLUMN pfsa_maint_event_tmp.LAST_WO_STATUS IS 'LAST_WO_STATUS - The last known status of a work order';

COMMENT ON COLUMN pfsa_maint_event_tmp.LAST_WO_STATUS_DATE IS 'LAST_WO_STATUS_DATE - The date of the last known status of a work order';

COMMENT ON COLUMN pfsa_maint_event_tmp.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.  Values are Y and N';

COMMENT ON COLUMN pfsa_maint_event_tmp.ACTIVE_DATE IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_maint_event_tmp.INACTIVE_DATE IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_maint_event_tmp.INSERT_BY IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsa_maint_event_tmp.INSERT_DATE IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_maint_event_tmp.UPDATE_BY IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsa_maint_event_tmp.UPDATE_DATE IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_maint_event_tmp.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.  Values are Y and N';

COMMENT ON COLUMN pfsa_maint_event_tmp.DELETE_DATE IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_maint_event_tmp.DELETE_BY IS 'DELETE_BY - Reports who initially deleted the record.';

COMMENT ON COLUMN pfsa_maint_event_tmp.CUST_UIC IS 'CUST_UIC - The uic which owns the equipment.';


