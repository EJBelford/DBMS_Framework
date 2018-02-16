-- DROP TABLE pfsa_maint_work_tmp; 

CREATE TABLE pfsa_maint_work_tmp
(
  MAINT_EV_ID    VARCHAR2(40 BYTE)              NOT NULL,
  MAINT_TASK_ID  VARCHAR2(50 BYTE)              NOT NULL,
  MAINT_WORK_ID  VARCHAR2(12 BYTE)              NOT NULL,
  MAINT_WORK_MH  NUMBER,
  MIL_CIV_KON    VARCHAR2(1 BYTE),
  MOS            VARCHAR2(10 BYTE),
  SPEC_PERSON    VARCHAR2(20 BYTE),
  REPAIR         VARCHAR2(1 BYTE),
  STATUS         VARCHAR2(1 BYTE),
  LST_UPDT       DATE,
  UPDT_BY        VARCHAR2(30 BYTE),
  MOS_SENT       VARCHAR2(10 BYTE),
  HEIR_ID        VARCHAR2(20 BYTE),
  PRIORITY       NUMBER
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          3M
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


COMMENT ON TABLE pfsa_maint_work_tmp IS 'PFSA_MAINT_WORK_TMP - This table documents all work performed by maintanenace personnel during a maintenance event.  Work not attributable to a specific person is aggregated';


COMMENT ON COLUMN pfsa_maint_work_tmp.MAINT_EV_ID IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN pfsa_maint_work_tmp.MAINT_TASK_ID IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN pfsa_maint_work_tmp.MAINT_WORK_ID IS 'MAINT_WORK_ID - The identifier that when combined with the MAINT_EV_ID and MAINT_TASK_ID creates a unique maintenance task work id.';

COMMENT ON COLUMN pfsa_maint_work_tmp.MAINT_WORK_MH IS 'MAINT_WORK_MH - The number of hours the maintenance work took to complete.';

COMMENT ON COLUMN pfsa_maint_work_tmp.MIL_CIV_KON IS 'MIL_CIV_KON - The code for the type of person doing the maintenance, Civilian, Kontractor, Military or Unknown.  Values are C\K\M\U';

COMMENT ON COLUMN pfsa_maint_work_tmp.MOS IS 'MOS - OCCUPATIONAL SPECIALTY CODE - The code that represents the Military Occupational Specialty (MOS) of the person performing the maintenance action.';

COMMENT ON COLUMN pfsa_maint_work_tmp.SPEC_PERSON IS 'SPEC_PERSON ? Specific person who performed the work.';

COMMENT ON COLUMN pfsa_maint_work_tmp.REPAIR IS 'REPAIR - Item was repaired.  Values should be Y - Yes, N - No, ? - Unknown';

COMMENT ON COLUMN pfsa_maint_work_tmp.STATUS IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN pfsa_maint_work_tmp.LST_UPDT IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN pfsa_maint_work_tmp.UPDT_BY IS 'UPDT_BY - Who/what updated the record.';

COMMENT ON COLUMN pfsa_maint_work_tmp.MOS_SENT IS 'MOS_SENT - The value of provided in the source data for the MOS.  This value is used to derive the MOS used.  The derived values generally remove the skill level code, and standardize terms used for Contractor and Civilian personnel.';

COMMENT ON COLUMN pfsa_maint_work_tmp.HEIR_ID IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN pfsa_maint_work_tmp.PRIORITY IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';


