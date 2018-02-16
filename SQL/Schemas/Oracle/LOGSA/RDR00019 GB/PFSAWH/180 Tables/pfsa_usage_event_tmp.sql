--
-- PFSA_USAGE_EVENT_tmp  (Table) 
--

DROP TABLE pfsa_usage_event_tmp;

CREATE TABLE pfsa_usage_event_tmp
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
  HIDDEN_BY             VARCHAR2(30 BYTE), 
  FORCE_UNIT_ID         NUMBER, 
  PBA_ID                NUMBER                  DEFAULT 1000000
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

COMMENT ON TABLE pfsa_usage_event_tmp IS 'PFSA_USAGE_EVENT_TMP - This is a temp table for development only to load production into development. ';



