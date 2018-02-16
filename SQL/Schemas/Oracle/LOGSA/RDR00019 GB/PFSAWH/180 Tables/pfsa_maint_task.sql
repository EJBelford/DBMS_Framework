-- DROP TABLE pfsa_maint_task; 

CREATE TABLE pfsa_maint_task
(
  MAINT_EV_ID         VARCHAR2(40 BYTE)         NOT NULL,
  MAINT_TASK_ID       VARCHAR2(50 BYTE)         NOT NULL,
  ELAPSED_TSK_WK_TM   NUMBER,
  ELAPSED_PART_WT_TM  NUMBER,
  TSK_BEGIN           DATE,
  TSK_END             DATE,
  INSPECT_TSK         VARCHAR2(1 BYTE),
  TSK_WAS_DEF         VARCHAR2(1 BYTE),
  SCHED_UNSCHED       VARCHAR2(1 BYTE),
  ESSENTIAL           VARCHAR2(1 BYTE),
  STATUS              VARCHAR2(1 BYTE),
  LST_UPDT            DATE,
  UPDT_BY             VARCHAR2(30 BYTE),
  HEIR_ID             VARCHAR2(20 BYTE),
  PRIORITY            NUMBER
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


COMMENT ON TABLE pfsa_maint_task IS 'PFSA_MAINT_TASK - This table documents the tasks which occur during a maintenance event.  Work not attributable to a task is aggregated';


COMMENT ON COLUMN pfsa_maint_task.MAINT_EV_ID IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN pfsa_maint_task.MAINT_TASK_ID IS 'MAINT_TASK_ID - The identifier that when combined with the MAINT_EV_ID creates a unique maintenance task id.';

COMMENT ON COLUMN pfsa_maint_task.ELAPSED_TSK_WK_TM IS 'ELAPSED_TSK_WK_TM - The elapsed task work time.';

COMMENT ON COLUMN pfsa_maint_task.ELAPSED_PART_WT_TM IS 'ELAPSED_PART_WT_TM - The elapsed task wait time.';

COMMENT ON COLUMN pfsa_maint_task.TSK_BEGIN IS 'TSK_BEGIN - The actual or estimated task start date\time.';

COMMENT ON COLUMN pfsa_maint_task.TSK_END IS 'TSK_END - The actual or estimated task completion date\time.';

COMMENT ON COLUMN pfsa_maint_task.INSPECT_TSK IS 'INSPECT_TSK - Flag indicating if this was an inspection task. Values are F\T\U';

COMMENT ON COLUMN pfsa_maint_task.TSK_WAS_DEF IS 'TSK_WAS_DEF - Flag indicating if this task was the result of a defect. Values are F\T\U';

COMMENT ON COLUMN pfsa_maint_task.SCHED_UNSCHED IS 'SCHED_UNSCHED - Flag indicating if this task was a scheduled or un-scheduled. Values are ?\S\U';

COMMENT ON COLUMN pfsa_maint_task.ESSENTIAL IS 'ESSENTIAL RECORD FLAG - A flag for indicating that essential maintenance was required. Values are F\T\U';

COMMENT ON COLUMN pfsa_maint_task.STATUS IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN pfsa_maint_task.LST_UPDT IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN pfsa_maint_task.UPDT_BY IS 'UPDT_BY - Who/what updated the record.';

COMMENT ON COLUMN pfsa_maint_task.HEIR_ID IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN pfsa_maint_task.PRIORITY IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';


--
-- PK_PFSA_MAINT_TASK  (Index) 
--
CREATE UNIQUE INDEX PK_PFSA_MAINT_TASK ON PFSA_MAINT_TASK
(MAINT_EV_ID, MAINT_TASK_ID)
LOGGING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          6M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSA_MAINT_TASK 
-- 
ALTER TABLE PFSA_MAINT_TASK ADD (
  CONSTRAINT PK_PFSA_MAINT_TASK
 PRIMARY KEY
 (MAINT_EV_ID, MAINT_TASK_ID)
    USING INDEX 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          6M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

-- 
-- Foreign Key Constraints for Table PFSA_MAINT_TASK 
-- 
ALTER TABLE PFSA_MAINT_TASK ADD (
  CONSTRAINT FK_MAINT_EV_TO_TSK 
 FOREIGN KEY (MAINT_EV_ID) 
 REFERENCES PFSA_MAINT_EVENT (MAINT_EV_ID));
