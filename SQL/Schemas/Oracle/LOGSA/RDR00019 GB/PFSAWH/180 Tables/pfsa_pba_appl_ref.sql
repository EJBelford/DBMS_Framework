-- DROP TABLE pfsa_pba_appl_ref;

CREATE TABLE pfsa_pba_appl_ref
(
  REC_ID               NUMBER,
  PBA_MENU_ID          VARCHAR2(10 BYTE),
  PBA_MENU_DESC        VARCHAR2(50 BYTE),
  PBA_MENU_SORT_ORDER  NUMBER,
  STATUS               VARCHAR2(1 BYTE)         DEFAULT 'C',
  UPDT_BY              VARCHAR2(30 BYTE)        DEFAULT USER,
  LST_UPDT             DATE                     DEFAULT SYSDATE,
  ACTIVE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'Y',
  ACTIVE_DATE          DATE                     DEFAULT '01-JAN-1900',
  INACTIVE_DATE        DATE                     DEFAULT '31-DEC-2099',
  INSERT_BY            VARCHAR2(30 BYTE)        DEFAULT USER,
  INSERT_DATE          DATE                     DEFAULT SYSDATE,
  UPDATE_BY            VARCHAR2(30 BYTE),
  UPDATE_DATE          DATE                     DEFAULT '01-JAN-1900',
  DELETE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'N',
  DELETE_DATE          DATE                     DEFAULT '01-JAN-1900',
  HIDDEN_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'Y',
  HIDDEN_DATE          DATE                     DEFAULT '01-JAN-1900'
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

COMMENT ON TABLE pfsa_pba_appl_ref IS 'PFSA_PBA_APPL_REF - ';


COMMENT ON COLUMN pfsa_pba_appl_ref.REC_ID IS 'REC_ID - ';

COMMENT ON COLUMN pfsa_pba_appl_ref.PBA_MENU_ID IS 'PBA_MENU_ID - ';

COMMENT ON COLUMN pfsa_pba_appl_ref.PBA_MENU_DESC IS 'PBA_MENU_DESC - ';

COMMENT ON COLUMN pfsa_pba_appl_ref.PBA_MENU_SORT_ORDER IS 'PBA_MENU_SORT_ORDER - ';

COMMENT ON COLUMN pfsa_pba_appl_ref.STATUS IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsa_pba_appl_ref.UPDT_BY IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsa_pba_appl_ref.LST_UPDT IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsa_pba_appl_ref.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsa_pba_appl_ref.ACTIVE_DATE IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_pba_appl_ref.INACTIVE_DATE IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_pba_appl_ref.INSERT_BY IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsa_pba_appl_ref.INSERT_DATE IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_pba_appl_ref.UPDATE_BY IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsa_pba_appl_ref.UPDATE_DATE IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_pba_appl_ref.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsa_pba_appl_ref.DELETE_DATE IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_pba_appl_ref.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsa_pba_appl_ref.HIDDEN_DATE IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';


