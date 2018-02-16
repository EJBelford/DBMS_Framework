CREATE TABLE pfsa_sn_ei
(
  SYS_EI_NIIN          VARCHAR2(9 BYTE),
  SYS_EI_SN            VARCHAR2(32 BYTE),
  SN_ITEM_STATE        VARCHAR2(16 BYTE),
  READY_STATE          VARCHAR2(6 BYTE),
  SYS_EI_STATE         VARCHAR2(24 BYTE),
  STATUS               VARCHAR2(1 BYTE),
  LST_UPDT             DATE,
  UPDT_BY              VARCHAR2(30 BYTE),
  POSSESSOR            VARCHAR2(32 BYTE),
  ACTIVE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'Y',
  ACTIVE_DATE          DATE                     DEFAULT sysdate,
  INACTIVE_DATE        DATE                     DEFAULT '01-JAN-1900',
  INSERT_BY            VARCHAR2(30 BYTE)        DEFAULT user,
  INSERT_DATE          DATE                     DEFAULT sysdate,
  UPDATE_BY            VARCHAR2(30 BYTE),
  UPDATE_DATE          DATE                     DEFAULT '01-JAN-1900',
  DELETE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'N',
  DELETE_DATE          DATE                     DEFAULT '01-JAN-1900',
  DELETE_BY            VARCHAR2(30 BYTE),
  HIDDEN_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'N',
  HIDDEN_DATE          DATE                     DEFAULT '01-JAN-1900',
  HIDDEN_BY            VARCHAR2(30 BYTE),
  SENSORED_ITEM        VARCHAR2(1 BYTE)         DEFAULT 'N',
  OWNING_ORG           VARCHAR2(32 BYTE),
  SYS_EI_UID           VARCHAR2(78 BYTE),
  PHYSICAL_ITEM_ID     NUMBER,
  PHYSICAL_ITEM_SN_ID  NUMBER,
  MIMOSA_ITEM_SN_ID    VARCHAR2(8 BYTE),
  AS_OF_DATE           DATE
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
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


COMMENT ON TABLE pfsa_sn_ei IS 'This table contains the last known state of a serial numbered end items in the PFSA world.  It therefore reflects the current information from the PFSA_SN_EI_HIST table. It is populated and controlled by TBD process.';


COMMENT ON COLUMN pfsa_sn_ei.ACTIVE_DATE IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsa_sn_ei.INACTIVE_DATE IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsa_sn_ei.INSERT_BY IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsa_sn_ei.INSERT_DATE IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsa_sn_ei.UPDATE_BY IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsa_sn_ei.UPDATE_DATE IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsa_sn_ei.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.  Values are Y and N';

COMMENT ON COLUMN pfsa_sn_ei.DELETE_DATE IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsa_sn_ei.DELETE_BY IS 'DELETE_BY - Reports who initially deleted the record.';

COMMENT ON COLUMN pfsa_sn_ei.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists. Values are Y and N';

COMMENT ON COLUMN pfsa_sn_ei.HIDDEN_DATE IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN pfsa_sn_ei.HIDDEN_BY IS 'HIDDEN_BY - Reports who initially hid the record.';

COMMENT ON COLUMN pfsa_sn_ei.SENSORED_ITEM IS 'SENSORED_ITEM - A PFSA internal indicator for identifying CBM Sensored platforms.  Values are ''Y'' and ''N''.';

COMMENT ON COLUMN pfsa_sn_ei.OWNING_ORG IS 'The current owner of the serial-numbered system/end item';

COMMENT ON COLUMN pfsa_sn_ei.SYS_EI_UID IS 'SYS_EI_UID - The Department of Defense unique identifier for the system end item.';

COMMENT ON COLUMN pfsa_sn_ei.PHYSICAL_ITEM_ID IS 'LIW/PFSAWH identitier for the item/part.';

COMMENT ON COLUMN pfsa_sn_ei.PHYSICAL_ITEM_SN_ID IS 'PFSAWH identitier for item/part for a particular serial number/tail number.';

COMMENT ON COLUMN pfsa_sn_ei.MIMOSA_ITEM_SN_ID IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.';

COMMENT ON COLUMN pfsa_sn_ei.AS_OF_DATE IS 'AS_OF_DATE - The date reflecting the currency of data for the serial numbered end item';

COMMENT ON COLUMN pfsa_sn_ei.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.  Values are Y and N';

COMMENT ON COLUMN pfsa_sn_ei.SYS_EI_NIIN IS 'The niin of the system and/or end item';

COMMENT ON COLUMN pfsa_sn_ei.SYS_EI_SN IS 'SERIAL NUMBER - A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN pfsa_sn_ei.SN_ITEM_STATE IS 'The state of the specific sn item';

COMMENT ON COLUMN pfsa_sn_ei.READY_STATE IS 'An abbreviated identifier of the readiness state of a system/end item';

COMMENT ON COLUMN pfsa_sn_ei.SYS_EI_STATE IS 'The actual state of a system / end item in the PFSA world';

COMMENT ON COLUMN pfsa_sn_ei.STATUS IS 'THE STATUS OF THE RECORD';

COMMENT ON COLUMN pfsa_sn_ei.LST_UPDT IS 'THE SYSTEM DATE OF WHEN THIS RECORD WAS CREATED/CHANGED';

COMMENT ON COLUMN pfsa_sn_ei.UPDT_BY IS 'AN IDENTIFIER OF WHAT CHANGED/CREATED THE RECORD';

COMMENT ON COLUMN pfsa_sn_ei.POSSESSOR IS 'The physical possessor of the specific system end item.  The possessor is constrained by procedures to the PFSA_ORG_HIST table (it is a PFSA_ORG)';


--
-- PK1_PFSA_SN_EI  (Index) 
--

CREATE UNIQUE INDEX PK1_PFSA_SN_EI ON pfsa_sn_ei
(SYS_EI_NIIN, SYS_EI_SN)
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
-- Non Foreign Key Constraints for Table PFSA_SN_EI 
-- 

ALTER TABLE pfsa_sn_ei ADD (
  CONSTRAINT PK1_PFSA_SN_EI
 PRIMARY KEY
 (SYS_EI_NIIN, SYS_EI_SN)
    USING INDEX 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512K
                NEXT             256K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

-- 
-- Foreign Key Constraints for Table PFSA_SN_EI 
-- 

/* 

ALTER TABLE pfsa_sn_ei ADD (
  CONSTRAINT FK1_PFSA_SN_EI_SYS_EI 
 FOREIGN KEY (SYS_EI_NIIN) 
 REFERENCES PFSAW.PFSA_SYS_EI (SYS_EI_NIIN) DISABLE); 
 
*/