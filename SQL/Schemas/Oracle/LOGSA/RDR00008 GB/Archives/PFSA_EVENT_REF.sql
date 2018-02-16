
CREATE TABLE PFSA_EVENT_REF
(
  PFSA_EVENT       VARCHAR2(20 BYTE),
  PFSA_EVENT_DEFN  VARCHAR2(1000 BYTE),
  STATUS           VARCHAR2(1 BYTE),
  LST_UPDT         DATE,
  UPDT_BY          VARCHAR2(30 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE PFSA_EVENT_REF IS 'This table contains known events which are tracked in the PFSA World';

COMMENT ON COLUMN PFSA_EVENT_REF.PFSA_EVENT IS 'A specific type of event, typically affecting a system end item';

COMMENT ON COLUMN PFSA_EVENT_REF.PFSA_EVENT_DEFN IS 'The definition of the pfsa_event';

COMMENT ON COLUMN PFSA_EVENT_REF.STATUS IS 'The status of this record';

COMMENT ON COLUMN PFSA_EVENT_REF.LST_UPDT IS 'THE SYSTEM DATE OF WHEN THIS RECORD WAS CREATED/CHANGED';

COMMENT ON COLUMN PFSA_EVENT_REF.UPDT_BY IS 'AN IDENTIFIER OF WHAT CHANGED/CREATED THE RECORD';


CREATE UNIQUE INDEX PK1_PFSA_EVENT_REF ON PFSA_EVENT_REF
(PFSA_EVENT)
LOGGING
NOPARALLEL;


ALTER TABLE PFSA_EVENT_REF ADD (
  CONSTRAINT PK1_PFSA_EVENT_REF
 PRIMARY KEY
 (PFSA_EVENT));
