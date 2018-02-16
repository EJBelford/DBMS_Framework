--
-- CBMWH_FUNCTIONAL_WARNINGS  (Table) 
--

CREATE TABLE cbmwh_functional_warnings
    (
    warning_type    VARCHAR2(32 BYTE),
    warning_from    VARCHAR2(100 BYTE),
    warning_msg     VARCHAR2(2000 BYTE),
    warning_status  VARCHAR2(1 BYTE),
    warning_time    DATE,
    updt_by         VARCHAR2(30 BYTE),
    lst_updt        DATE,
    action_taken    VARCHAR2(2000 BYTE)
    )
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             32K
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


COMMENT ON TABLE cbmwh_functional_warnings 
IS 'cbmwh_FUNCTIONAL_WARNINGS - PRODUCTION DATE 25 Sep 2004.  This table is used to post warnings for the PFSA functional team.  Warnings are generally reported as exceptions to processing as well as to data integrity issues';


COMMENT ON COLUMN cbmwh_functional_warnings.WARNING_TYPE 
IS 'WARNING_TYPE - PROCESSING/DATA INTEGRITY/REVIEW REQUIRED/tbd as indicated by raising object';

COMMENT ON COLUMN cbmwh_functional_warnings.WARNING_FROM 
IS 'WARNING_FROM - Should contain the raising object name with the entire called by string';

COMMENT ON COLUMN cbmwh_functional_warnings.WARNING_STATUS 
IS 'WARNING_STATUS - C for current and H for historical';

COMMENT ON COLUMN cbmwh_functional_warnings.WARNING_TIME 
IS 'WARNING_TIME - The date/time stamp of when the warning was generate';

COMMENT ON COLUMN cbmwh_functional_warnings.UPDT_BY 
IS 'UPDT_BY - User that last updated this record';

COMMENT ON COLUMN cbmwh_functional_warnings.LST_UPDT 
IS 'LST_UPDT - Date of last update';

COMMENT ON COLUMN cbmwh_functional_warnings.ACTION_TAKEN 
IS 'ACTION_TAKEN - Action taken by user';

