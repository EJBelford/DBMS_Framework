DROP TABLE cbmwh_processes_hist; 

--
-- cbm_PROCESSES_HIST  (Table) 
-- 

CREATE TABLE cbmwh_processes_hist
    (
    cbmwh_process          VARCHAR2(32 BYTE),
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

COMMENT ON TABLE cbmwh_processes_hist 
IS 'CBMWH_PROCESSES_HIST - PRODUCTION DATE 25 Sep 2004.  This table contains a history of the cbm_PROCESSES table.  It contains every changed record via update trigger TR_cbm_PROCESSES';

COMMENT ON COLUMN cbmwh_processes_hist.CBMWH_PROCESS 
IS 'CBMWH_PROCESS - A unique cbm controlling ORACLE based process';

COMMENT ON COLUMN cbmwh_processes_hist.LAST_RUN 
IS 'LAST_RUN - The specific sysdate value of the time the process was last ran';

COMMENT ON COLUMN cbmwh_processes_hist.WHO_RAN 
IS 'WHO_RAN - Indicates the calling process if called via some structured and ordered process';

COMMENT ON COLUMN cbmwh_processes_hist.LAST_RUN_STATUS 
IS 'LAST_RUN_STATUS - Indicates the status of the process being ran';

COMMENT ON COLUMN cbmwh_processes_hist.LAST_RUN_STATUS_TIME 
IS 'LAST_RUN_STATUS_TIME - The time stamp of the last_run_status';

COMMENT ON COLUMN cbmwh_processes_hist.LAST_RUN_COMPL 
IS 'LAST_RUN_COMPL - Indicates the sysdate value of the time the process last successfully completed';

COMMENT ON COLUMN cbmwh_processes_hist.LST_UPDT 
IS 'LST_UPDT - The timestamp of when the record was created';

