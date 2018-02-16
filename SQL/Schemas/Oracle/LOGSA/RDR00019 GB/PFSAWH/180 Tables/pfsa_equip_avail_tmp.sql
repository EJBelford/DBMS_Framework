-- DROP TABLE pfsa_equip_avail_tmp; 

CREATE TABLE pfsa_equip_avail_tmp
(
  SYS_EI_NIIN        VARCHAR2(9 BYTE)           NOT NULL,
  PFSA_ITEM_ID       VARCHAR2(20 BYTE)          NOT NULL,
  RECORD_TYPE        VARCHAR2(1 BYTE)           NOT NULL,
  FROM_DT            DATE                       NOT NULL,
  TO_DT              DATE,
  READY_DATE         DATE                       NOT NULL,
  DAY_DATE           DATE,
  MONTH_DATE         DATE,
  PFSA_ORG           VARCHAR2(32 BYTE),
  SYS_EI_SN          VARCHAR2(32 BYTE),
  ITEM_DAYS          NUMBER,
  PERIOD_HRS         NUMBER,
  NMCM_HRS           NUMBER,
  NMCS_HRS           NUMBER,
  NMC_HRS            NUMBER,
  FMC_HRS            NUMBER,
  PMC_HRS            NUMBER,
  MC_HRS             NUMBER,
  NMCM_USER_HRS      NUMBER,
  NMCM_INT_HRS       NUMBER,
  NMCM_DEP_HRS       NUMBER,
  NMCS_USER_HRS      NUMBER,
  NMCS_INT_HRS       NUMBER,
  NMCS_DEP_HRS       NUMBER,
  PMCM_HRS           NUMBER,
  PMCS_HRS           NUMBER,
  SOURCE_ID          VARCHAR2(20 BYTE),
  LST_UPDT           DATE,
  UPDT_BY            VARCHAR2(30 BYTE),
  PMCS_USER_HRS      NUMBER,
  PMCS_INT_HRS       NUMBER,
  PMCM_USER_HRS      NUMBER,
  PMCM_INT_HRS       NUMBER,
  DEP_HRS            NUMBER,
  HEIR_ID            VARCHAR2(20 BYTE),
  PRIORITY           NUMBER,
  UIC                VARCHAR2(6 BYTE),
  ACTIVE_FLAG        VARCHAR2(1 BYTE)           DEFAULT 'Y',
  ACTIVE_DATE        DATE                       DEFAULT sysdate,
  INACTIVE_DATE      DATE                       DEFAULT '01-JAN-1900',
  INSERT_BY          VARCHAR2(30 BYTE)          DEFAULT user,
  INSERT_DATE        DATE                       DEFAULT sysdate,
  UPDATE_BY          VARCHAR2(30 BYTE),
  UPDATE_DATE        DATE                       DEFAULT '01-JAN-1900',
  DELETE_FLAG        VARCHAR2(1 BYTE)           DEFAULT 'N',
  DELETE_DATE        DATE                       DEFAULT '01-JAN-1900',
  DELETE_BY          VARCHAR2(30 BYTE),
  HIDDEN_FLAG        VARCHAR2(1 BYTE)           DEFAULT 'N',
  HIDDEN_DATE        DATE                       DEFAULT '01-JAN-1900',
  HIDDEN_BY          VARCHAR2(30 BYTE),
  FRZ_INPUT_DATE     DATE,
  FRZ_INPUT_DATE_ID  NUMBER,
  RIDB_ON_TIME_FLAG  VARCHAR2(1 BYTE),
  STATUS             VARCHAR2(1 BYTE),
  GRAB_STAMP         DATE,
  PROC_STAMP         DATE,
  SYS_EI_UID         VARCHAR2(78 BYTE)
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


COMMENT ON TABLE pfsa_equip_avail_tmp IS 'PFSA_EQUIP_AVAIL_TMP - This table serves as the staging point for processing equip avail data.  Data is placed into the table from production amac, readiness as well as legacy (wolf) maintenance data processing';


COMMENT ON COLUMN pfsa_equip_avail_tmp.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.  Values are Y and N';

COMMENT ON COLUMN pfsa_equip_avail_tmp.ACTIVE_DATE IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.INACTIVE_DATE IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.INSERT_BY IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.INSERT_DATE IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.UPDATE_BY IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.UPDATE_DATE IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.DELETE_DATE IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.DELETE_BY IS 'DELETE_BY - Reports who initially deleted the record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists. Values are Y and N';

COMMENT ON COLUMN pfsa_equip_avail_tmp.HIDDEN_DATE IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.HIDDEN_BY IS 'HIDDEN_BY - Reports who initially hid the record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.FRZ_INPUT_DATE IS 'This date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.FRZ_INPUT_DATE_ID IS 'This date_dim id of the date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.RIDB_ON_TIME_FLAG IS 'A flag used by the RIDB processing system to identify if the unit reported readiness on time according to existing regulations at the time of the processing.  PFSA uses the field in calculating the frz_input_date for PBA processing';

COMMENT ON COLUMN pfsa_equip_avail_tmp.STATUS IS 'The status of this record';

COMMENT ON COLUMN pfsa_equip_avail_tmp.GRAB_STAMP IS 'GRAB_STAMP - The sysdate of the time the grab procedure that populated the table was executed.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PROC_STAMP IS 'PROC_STAMP - The sysdate of the time the process procedure was executed.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.SYS_EI_UID IS 'SYS_EI_UID - The Department of Defense unique identifier for the system end item.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.SYS_EI_NIIN IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PFSA_ITEM_ID IS 'A PFSA generated item.  Will contain the serial number of the item if reported by serial number or will contain the uic of the unit reporting the item if reported by uic total.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.RECORD_TYPE IS 'A PFSA generated code to indicate whether the record contains summary information for a readiness period (''S'') or detailed information (''D'').  Used to accomodate readiness reportable information which is not captured in some non-standard systems (i.e., PMCS not in AMAC)';

COMMENT ON COLUMN pfsa_equip_avail_tmp.FROM_DT IS 'FROM DATE - The beginning date for a historical record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.TO_DT IS 'TO DATE - The ending date for a historical record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.READY_DATE IS 'A internally generated PFSA date to group the usage period into the readiness reporting 16th of a month thru the 15th of the next month time periods (next month named)';

COMMENT ON COLUMN pfsa_equip_avail_tmp.DAY_DATE IS 'A trunced date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level. ';

COMMENT ON COLUMN pfsa_equip_avail_tmp.MONTH_DATE IS 'A truncated date value representing the entire month forward';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PFSA_ORG IS 'A generic identification of an organization.  Used to both accomodate non-DOD entities as well as ensuring invalid FORCE data is accomodated in joins to gather location/other force information.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.SYS_EI_SN IS 'SERIAL NUMBER - A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.ITEM_DAYS IS 'A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PERIOD_HRS IS 'The total number of hours included in the period indicate from the from_dt through the to_dt.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCM_HRS IS 'The total number of hours in a not mission capable maintenance status durint the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCS_HRS IS 'The total number of hours in a not mission capable supply status durint the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMC_HRS IS 'The total number of hours in a not mission capable status during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.FMC_HRS IS 'The total number of hours in a fully mission capable status during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMC_HRS IS 'The total number of hours in a partially mission capable status during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.MC_HRS IS 'The total number of hours in a mission capable status (fully or partially) during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCM_USER_HRS IS 'The total number of hours in a non mission capable maintenance status at the user level during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCM_INT_HRS IS 'The total number of hours in a non mission capable maintenance status at the intermediate level during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCM_DEP_HRS IS 'The total number of hours in a non mission capable maintenance status at the depot level during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCS_USER_HRS IS 'The total number of hours in a non mission capable supply status at the user level during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCS_INT_HRS IS 'The total number of hours in a non mission capable supply status at the intermediate level during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.NMCS_DEP_HRS IS 'The total number of hours in a non mission capable supply status at the depot level during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMCM_HRS IS 'The total number of hours in a partial mission capable maintenance status during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMCS_HRS IS 'The total number of hours in a partial mission capable supply status during the indicated period.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.SOURCE_ID IS 'A description of the data source for the record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.LST_UPDT IS 'LAST UPDATE - Indicates when the record was last updated.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.UPDT_BY IS 'UPDATED BY - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMCS_USER_HRS IS 'The total number of hours in a partially mission capability supply status at the user level during the indicated period';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMCS_INT_HRS IS 'The total number of hours in a partially mission capability supply status at the intermediate level during the indicated period';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMCM_USER_HRS IS 'The total number of hours in a partially mission capability maintenance status at the user level during the indicated period';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PMCM_INT_HRS IS 'The total number of hours in a partially mission capability maintenance status at the intermediate level during the indicated period';

COMMENT ON COLUMN pfsa_equip_avail_tmp.DEP_HRS IS 'The total number of hours in a non mission capable status at the depot level.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.HEIR_ID IS 'A PFSA team generated identifier of the data source.  It is similar to the SOURCE_ID and is the same except in cases where more specific source identifiers are used, e.g., the identification of a specific box as in the CPME and AMAC data.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.PRIORITY IS 'The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN pfsa_equip_avail_tmp.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.  Values are Y and N';


