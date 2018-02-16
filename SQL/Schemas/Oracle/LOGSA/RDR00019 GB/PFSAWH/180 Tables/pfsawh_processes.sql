-
-- PFSA_PROCESSES  (Table) 
--
CREATE TABLE pfsawh_processes
    (
    pfsa_process          VARCHAR2(32 BYTE),
    last_run              DATE,
    who_ran               VARCHAR2(32 BYTE),
    last_run_status       VARCHAR2(10 BYTE),
    last_run_status_time  DATE,
    last_run_compl        DATE
    )
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512K
            NEXT             256K
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

COMMENT ON TABLE pfsawh_processes 
IS 'PFSAWH_PROCESSES - PRODUCTION DATE 25 Sep 2004.  This table contains all top level processes used to maintain the PFSA world, as well as individual load and maintenance procedures.  Individual load and maintenance procedures are called by one of these processes.  This processes should be initiated via unix scheduler for production cases.  Once called, controlling processes will trigger the appropriate processes to be ran.';

COMMENT ON COLUMN pfsawh_processes.PFSA_PROCESS 
IS 'PFSA_PROCESS - A unique PFSA controlling ORACLE based process';

COMMENT ON COLUMN pfsawh_processes.LAST_RUN 
IS 'LAST_RUN - The specific sysdate value of the time the process was last ran';

COMMENT ON COLUMN pfsawh_processes.WHO_RAN 
IS 'WHO_RAN - Indicates the calling process if called via some structured and ordered process';

COMMENT ON COLUMN pfsawh_processes.LAST_RUN_STATUS 
IS 'LAST_RUN_STATUS - Indicates the status of the process being ran';

COMMENT ON COLUMN pfsawh_processes.LAST_RUN_STATUS_TIME 
IS 'LAST_RUN_STATUS_TIME - The time stamp of the last_run_status';

COMMENT ON COLUMN pfsawh_processes.LAST_RUN_COMPL 
IS 'LAST_RUN_COMPL - Indicates the sysdate value of the time the process last successfully completed';


--
-- PK1_PFSA_PROCESSES  (Index) 
--
CREATE UNIQUE INDEX PK1_PFSA_PROCESSES ON pfsawh_processes
(PFSA_PROCESS)
LOGGING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512K
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSA_PROCESSES 
-- 
ALTER TABLE pfsawh_processes ADD (
  CONSTRAINT PK1_PFSA_PROCESSES
 PRIMARY KEY
 (PFSA_PROCESS)
    USING INDEX 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          4208K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
