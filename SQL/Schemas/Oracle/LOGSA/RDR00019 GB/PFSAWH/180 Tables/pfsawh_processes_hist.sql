--
-- PFSA_PROCESSES_HIST  (Table) 
--
CREATE TABLE pfsawh_processes_hist
    (
    pfsa_process          VARCHAR2(32 BYTE),
    last_run              DATE,
    who_ran               VARCHAR2(32 BYTE),
    last_run_status       VARCHAR2(10 BYTE),
    last_run_status_time  DATE,
    last_run_compl        DATE,
    lst_updt              DATE
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

COMMENT ON TABLE pfsawh_processes_hist 
IS 'PFSAWH_PROCESSES_HIST - PRODUCTION DATE 25 Sep 2004.  This table contains a history of the PFSA_PROCESSES table.  It contains every changed record via update trigger TR_PFSA_PROCESSES';

COMMENT ON COLUMN pfsawh_processes_hist.PFSA_PROCESS 
IS 'PFSA_PROCESS - A unique PFSA controlling ORACLE based process';

COMMENT ON COLUMN pfsawh_processes_hist.LAST_RUN 
IS 'LAST_RUN - The specific sysdate value of the time the process was last ran';

COMMENT ON COLUMN pfsawh_processes_hist.WHO_RAN 
IS 'WHO_RAN - Indicates the calling process if called via some structured and ordered process';

COMMENT ON COLUMN pfsawh_processes_hist.LAST_RUN_STATUS 
IS 'LAST_RUN_STATUS - Indicates the status of the process being ran';

COMMENT ON COLUMN pfsawh_processes_hist.LAST_RUN_STATUS_TIME 
IS 'LAST_RUN_STATUS_TIME - The time stamp of the last_run_status';

COMMENT ON COLUMN pfsawh_processes_hist.LAST_RUN_COMPL 
IS 'LAST_RUN_COMPL - Indicates the sysdate value of the time the process last successfully completed';

COMMENT ON COLUMN pfsawh_processes_hist.LST_UPDT 
IS 'LST_UPDT - The timestamp of when the record was created';

