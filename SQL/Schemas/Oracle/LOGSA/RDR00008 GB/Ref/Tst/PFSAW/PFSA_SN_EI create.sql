
ALTER TABLE PFSAW.PFSA_SN_EI
 DROP PRIMARY KEY CASCADE;
DROP TABLE PFSAW.PFSA_SN_EI CASCADE CONSTRAINTS;

--
-- PFSA_SN_EI  (Table) 
--
CREATE TABLE PFSAW.PFSA_SN_EI
(
  SYS_EI_NIIN    VARCHAR2(9 BYTE),
  SYS_EI_SN      VARCHAR2(32 BYTE),
  SN_ITEM_STATE  VARCHAR2(16 BYTE),
  READY_STATE    VARCHAR2(6 BYTE),
  SYS_EI_STATE   VARCHAR2(24 BYTE),
  STATUS         VARCHAR2(1 BYTE),
  LST_UPDT       DATE,
  UPDT_BY        VARCHAR2(30 BYTE),
  POSSESSOR      VARCHAR2(32 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE PFSAW.PFSA_SN_EI IS 'This table contains the last known state of a serial numbered end items in the PFSA world.  It therefore reflects the current information from the PFSA_SN_EI_HIST table. It is populated and controlled by TBD process.';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.SYS_EI_NIIN IS 'The niin of the system and/or end item';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.SYS_EI_SN IS 'SERIAL NUMBER - A character field used to uniquely identify a specific item.';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.SN_ITEM_STATE IS 'The state of the specific sn item';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.READY_STATE IS 'An abbreviated identifier of the readiness state of a system/end item';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.SYS_EI_STATE IS 'The actual state of a system / end item in the PFSA world';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.STATUS IS 'THE STATUS OF THE RECORD';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.LST_UPDT IS 'THE SYSTEM DATE OF WHEN THIS RECORD WAS CREATED/CHANGED';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.UPDT_BY IS 'AN IDENTIFIER OF WHAT CHANGED/CREATED THE RECORD';

COMMENT ON COLUMN PFSAW.PFSA_SN_EI.POSSESSOR IS 'The physical possessor of the specific system end item.  The possessor is constrained by procedures to the PFSA_ORG_HIST table (it is a PFSA_ORG)';


--
-- PK1_PFSA_SN_EI  (Index) 
--
CREATE UNIQUE INDEX PFSAW.PK1_PFSA_SN_EI ON PFSAW.PFSA_SN_EI
(SYS_EI_NIIN, SYS_EI_SN)
LOGGING
NOPARALLEL;


DROP PUBLIC SYNONYM PFSA_SN_EI;

--
-- PFSA_SN_EI  (Synonym) 
--
CREATE PUBLIC SYNONYM PFSA_SN_EI FOR PFSAW.PFSA_SN_EI;


-- 
-- Non Foreign Key Constraints for Table PFSA_SN_EI 
-- 
ALTER TABLE PFSAW.PFSA_SN_EI ADD (
  CONSTRAINT PK1_PFSA_SN_EI
 PRIMARY KEY
 (SYS_EI_NIIN, SYS_EI_SN));


-- 
-- Foreign Key Constraints for Table PFSA_SN_EI 
-- 
ALTER TABLE PFSAW.PFSA_SN_EI ADD (
  CONSTRAINT FK1_PFSA_SN_EI_SYS_EI 
 FOREIGN KEY (SYS_EI_NIIN) 
 REFERENCES PFSAW.PFSA_SYS_EI (SYS_EI_NIIN) DISABLE);


GRANT DELETE, INSERT, UPDATE ON  PFSAW.PFSA_SN_EI TO C_PFSAW_DB_IN;

GRANT SELECT ON  PFSAW.PFSA_SN_EI TO LIW_BASIC;

GRANT SELECT ON  PFSAW.PFSA_SN_EI TO LIW_RESTRICTED;

GRANT SELECT ON  PFSAW.PFSA_SN_EI TO S_PFSAW;

