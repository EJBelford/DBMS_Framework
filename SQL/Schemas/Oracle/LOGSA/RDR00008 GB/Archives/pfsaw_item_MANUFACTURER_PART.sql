
CREATE TABLE MANUFACTURER_PART
(
  NIIN          VARCHAR2(9 BYTE)                NOT NULL,
  CAGE_CD       VARCHAR2(5 BYTE)                NOT NULL,
  MFG_PART_NUM  VARCHAR2(32 BYTE)               NOT NULL,
  ACT_MEAS      VARCHAR2(11 BYTE),
  DAC           CHAR(1 BYTE),
  RADIONUCLIDE  VARCHAR2(5 BYTE),
  RNAAC         VARCHAR2(2 BYTE),
  RNCC          CHAR(1 BYTE),
  RNJC          CHAR(1 BYTE),
  RNVC          CHAR(1 BYTE),
  SADC          VARCHAR2(2 BYTE),
  LST_UPDT      DATE,
  STATUS        CHAR(1 BYTE),
  UPDT_BY       VARCHAR2(30 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
PARALLEL ( DEGREE 1 INSTANCES DEFAULT )
MONITORING;


CREATE UNIQUE INDEX PKMANUFACTURER_PART ON MANUFACTURER_PART
(NIIN, CAGE_CD, MFG_PART_NUM)
LOGGING
NOPARALLEL;


CREATE INDEX FK_MANUFACTURER_PART_NIIN ON MANUFACTURER_PART
(NIIN)
LOGGING
NOPARALLEL;


CREATE INDEX MFG_PART_NUM_IX ON MANUFACTURER_PART
(MFG_PART_NUM)
LOGGING
NOPARALLEL;


CREATE INDEX IF_NIIN_MFG_PART_2_NUM ON MANUFACTURER_PART
(NIIN, MFG_PART_NUM)
LOGGING
NOPARALLEL;


CREATE PUBLIC SYNONYM MANUFACTURER_PART FOR MANUFACTURER_PART;


ALTER TABLE MANUFACTURER_PART ADD (
  CONSTRAINT PKMANUFACTURER_PART
 PRIMARY KEY
 (NIIN, CAGE_CD, MFG_PART_NUM));


GRANT SELECT ON  MANUFACTURER_PART TO DISCOV_VIEWS WITH GRANT OPTION;

GRANT SELECT ON  MANUFACTURER_PART TO D_EMIS_PRIVS;

GRANT SELECT ON  MANUFACTURER_PART TO D_EMIS_PRIVS_FN;

GRANT SELECT ON  MANUFACTURER_PART TO G_DOD_CONTRACTOR;

GRANT SELECT ON  MANUFACTURER_PART TO G_PHASE1;

GRANT SELECT ON  MANUFACTURER_PART TO LIW_BASIC;

GRANT SELECT ON  MANUFACTURER_PART TO LIW_RESTRICTED;

GRANT SELECT ON  MANUFACTURER_PART TO PFSA WITH GRANT OPTION;

GRANT SELECT ON  MANUFACTURER_PART TO S_ITEM1;

GRANT SELECT ON  MANUFACTURER_PART TO S_MIL_CIV;

GRANT SELECT ON  MANUFACTURER_PART TO S_PUBS;

