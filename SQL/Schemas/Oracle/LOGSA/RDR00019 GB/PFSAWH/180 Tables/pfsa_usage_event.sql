-- DROP TABLE pfsa_usage_event; 

CREATE TABLE pfsa_usage_event
(
  SYS_EI_NIIN           VARCHAR2(9 BYTE)        NOT NULL,
  PFSA_ITEM_ID          VARCHAR2(20 BYTE)       NOT NULL,
  RECORD_TYPE           VARCHAR2(1 BYTE)        NOT NULL,
  USAGE_MB              VARCHAR2(2 BYTE)        NOT NULL,
  FROM_DT               DATE                    NOT NULL,
  USAGE                 NUMBER,
  TYPE_USAGE            VARCHAR2(12 BYTE),
  TO_DT                 DATE,
  USAGE_DATE            DATE,
  READY_DATE            DATE,
  DAY_DATE              DATE,
  MONTH_DATE            DATE,
  PFSA_ORG              VARCHAR2(32 BYTE),
  UIC                   VARCHAR2(6 BYTE),
  SYS_EI_SN             VARCHAR2(32 BYTE),
  ITEM_DAYS             NUMBER,
  DATA_SRC              VARCHAR2(20 BYTE),
  GENIND                NUMBER,
  LST_UPDT              DATE,
  UPDT_BY               VARCHAR2(30 BYTE),
  STATUS                VARCHAR2(1 BYTE),
  READING               NUMBER,
  REPORTED_USAGE        NUMBER,
  ACTUAL_MB             VARCHAR2(2 BYTE),
  ACTUAL_READING        NUMBER,
  ACTUAL_USAGE          NUMBER,
  ACTUAL_DATA_REC_FLAG  VARCHAR2(1 BYTE)        DEFAULT '?',
  PHYSICAL_ITEM_ID      NUMBER,
  PHYSICAL_ITEM_SN_ID   NUMBER,
  FRZ_INPUT_DATE        DATE,
  FRZ_INPUT_DATE_ID     NUMBER,
  ACTIVE_FLAG           VARCHAR2(1 BYTE)        DEFAULT 'Y',
  ACTIVE_DATE           DATE                    DEFAULT sysdate,
  INACTIVE_DATE         DATE                    DEFAULT '1-JAN-1990',
  INSERT_BY             VARCHAR2(30 BYTE)       DEFAULT user,
  INSERT_DATE           DATE                    DEFAULT sysdate,
  UPDATE_BY             VARCHAR2(30 BYTE),
  UPDATE_DATE           DATE                    DEFAULT to_date('01-01-1900', 'MM-DD-YYYY'),
  DELETE_FLAG           VARCHAR2(1 BYTE)        DEFAULT 'N',
  DELETE_DATE           DATE                    DEFAULT to_date('01-01-1900', 'MM-DD-YYYY'),
  HIDDEN_FLAG           VARCHAR2(1 BYTE)        DEFAULT 'N',
  HIDDEN_DATE           DATE                    DEFAULT to_date('01-01-1900', 'MM-DD-YYYY'),
  DELETE_BY             VARCHAR2(30 BYTE),
  HIDDEN_BY             VARCHAR2(30 BYTE)
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


COMMENT ON TABLE pfsa_usage_event IS 'PFSA_USAGE_EVENT IS ''This table contains the usage data.';


COMMENT ON COLUMN pfsa_usage_event.ACTUAL_USAGE IS 'The actual usage of the system/end item.';

COMMENT ON COLUMN pfsa_usage_event.ACTUAL_DATA_REC_FLAG IS 'This value will only be T or F.  If the record comes from a "system" then it is true.  If the record is created by a PFSA process then it is false.  Values: T - true, F - false, ? - default.';

COMMENT ON COLUMN pfsa_usage_event.PHYSICAL_ITEM_ID IS 'LIW/PFSAWH identitier for the item/part.';

COMMENT ON COLUMN pfsa_usage_event.PHYSICAL_ITEM_SN_ID IS 'PFSAWH identitier for item/part for a particular serial number/tail number.';

COMMENT ON COLUMN pfsa_usage_event.FRZ_INPUT_DATE IS 'This date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN pfsa_usage_event.FRZ_INPUT_DATE_ID IS 'This date_dim id of the date is used as input to the PFSA PBA Freeze process to prevent additional changes to the "frozen" records after a given date.  Specific business rules for a given record source control the calculation.';

COMMENT ON COLUMN pfsa_usage_event.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.  Values are Y and N';

COMMENT ON COLUMN pfsa_usage_event.ACTIVE_DATE IS 'Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_usage_event.INACTIVE_DATE IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_usage_event.INSERT_BY IS 'Reports who initially created the record.';

COMMENT ON COLUMN pfsa_usage_event.INSERT_DATE IS 'Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_usage_event.UPDATE_BY IS 'Reports who last updated the record.';

COMMENT ON COLUMN pfsa_usage_event.UPDATE_DATE IS 'Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_usage_event.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.  Values are Y and N';

COMMENT ON COLUMN pfsa_usage_event.DELETE_DATE IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_usage_event.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists. Values are Y and N';

COMMENT ON COLUMN pfsa_usage_event.HIDDEN_DATE IS 'Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN pfsa_usage_event.DELETE_BY IS 'DELETE_BY - Reports who initially deleted the record.';

COMMENT ON COLUMN pfsa_usage_event.HIDDEN_BY IS 'HIDDEN_BY - Reports who initially hid the record.';

COMMENT ON COLUMN pfsa_usage_event.SYS_EI_NIIN IS 'NATIONAL ITEM IDENTIFICATION NUMBER - A nine-digit number sequentially assigned to each approved item identification number under the federal cataloging program.  The first two digits are the NATO code and the remaining seven are what was formerly the federal item identification number.  These nine digits are the latter part of the 13-digit National Stock Number (NSN).';

COMMENT ON COLUMN pfsa_usage_event.PFSA_ITEM_ID IS 'A PFSA generated item.  Will contain the serial number of the item if reported by serial number or will contain the uic of the unit reporting the item if reported by uic total.';

COMMENT ON COLUMN pfsa_usage_event.RECORD_TYPE IS 'A PFSA generated code to indicate whether the record contains summary information for a readiness period (S) or detailed information (D).  Used to accomodate readiness reportable information which is not captured in some non-standard systems (i.e., PMCS not in AMAC).';

COMMENT ON COLUMN pfsa_usage_event.USAGE_MB IS 'The measurement base of the associated usage.';

COMMENT ON COLUMN pfsa_usage_event.FROM_DT IS 'The beginning date for a historical record.';

COMMENT ON COLUMN pfsa_usage_event.USAGE IS 'The actual usage of the system/end item accumulated during the period.';

COMMENT ON COLUMN pfsa_usage_event.TYPE_USAGE IS 'An indicator of the type of usage captured.';

COMMENT ON COLUMN pfsa_usage_event.TO_DT IS 'The ending date for a historical record.  This is actually the date that the USAGE would be reported on.  It is equal to the corrisponding EVENT_DT_TIME column in the BLD_PFSA_SN_EI_HIST table.';

COMMENT ON COLUMN pfsa_usage_event.USAGE_DATE IS '''An internally generated PFSA date to group the usage period into the readiness reporting 16th of a month thru the 15th of the next month time periods (next month named).';

COMMENT ON COLUMN pfsa_usage_event.READY_DATE IS 'A specific snap shot of time, midnight of the indicated day.  READY_DATE is a backward looking time component, comprised of all time since midnight of the previous month thru the indicated date.';

COMMENT ON COLUMN pfsa_usage_event.DAY_DATE IS 'A truncated date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level.';

COMMENT ON COLUMN pfsa_usage_event.MONTH_DATE IS 'A truncated date value representing the entire month forward.';

COMMENT ON COLUMN pfsa_usage_event.PFSA_ORG IS 'A generic identification of an organization.  Used to both accomodate non-DOD entities as well as ensuring invalid FORCE data is accomodated in joins to gather location/other force information.';

COMMENT ON COLUMN pfsa_usage_event.UIC IS 'UNIT IDENTIFICATION CODE (UIC) - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a unit.  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UIC''''s assigned parent unit is defined by HQDA and may be recognized by ''''AA'''' in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive  Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)';

COMMENT ON COLUMN pfsa_usage_event.SYS_EI_SN IS 'A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN pfsa_usage_event.ITEM_DAYS IS 'A PFSA generated representation of the number of complete item days represented by the data.  A value of zero is used to accommodate the roll-up of data.';

COMMENT ON COLUMN pfsa_usage_event.DATA_SRC IS 'A description of the data source for the record.';

COMMENT ON COLUMN pfsa_usage_event.GENIND IS 'A PFSA internal field used to indicate the number of records generated to develop average monthly usage records aligned to calendar month.';

COMMENT ON COLUMN pfsa_usage_event.LST_UPDT IS 'Indicates when the record was last updated.';

COMMENT ON COLUMN pfsa_usage_event.UPDT_BY IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsa_usage_event.STATUS IS 'Indicating the overal status of the record.';

COMMENT ON COLUMN pfsa_usage_event.READING IS 'This is the new reading base on the new measurement base factor calculated by the pfsa_usage_mb_conversion procedure based on the origenal measurement base.';

COMMENT ON COLUMN pfsa_usage_event.REPORTED_USAGE IS 'This is the entire usage of the true reporting date.  It is not spread accross the generated records.';

COMMENT ON COLUMN pfsa_usage_event.ACTUAL_MB IS 'This is the origenal measurement base.';

COMMENT ON COLUMN pfsa_usage_event.ACTUAL_READING IS 'The actual cumulative measurement of usage for the system/end item.';


DROP INDEX idx_pfsa_usage_event_sn;        

CREATE INDEX idx_pfsa_usage_event_sn 
    ON pfsa_usage_event
        (
        physical_item_sn_id
        )
    LOGGING
    NOPARALLEL;

DROP INDEX idx_pfsa_usage_event_itm;        

CREATE INDEX idx_pfsa_usage_event_itm 
    ON pfsa_usage_event
        (
        physical_item_id, 
        physical_item_sn_id
        )
    LOGGING
    NOPARALLEL;

