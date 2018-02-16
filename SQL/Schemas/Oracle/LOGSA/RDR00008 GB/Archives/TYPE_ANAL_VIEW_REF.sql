
CREATE TABLE TYPE_ANAL_VIEW_REF
(
  TYPE_ANAL_VIEW       VARCHAR2(12 BYTE),
  TYPE_ANAL_VIEW_DESC  VARCHAR2(200 BYTE),
  ANAL_VIEW_KEY        VARCHAR2(16 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TYPE_ANAL_VIEW_REF IS 'Logical control of the types of views in the PFSA World';

COMMENT ON COLUMN TYPE_ANAL_VIEW_REF.TYPE_ANAL_VIEW IS 'The type of analytical view';

COMMENT ON COLUMN TYPE_ANAL_VIEW_REF.TYPE_ANAL_VIEW_DESC IS 'A description of the analytical view type';

COMMENT ON COLUMN TYPE_ANAL_VIEW_REF.ANAL_VIEW_KEY IS 'The parameter used as the key attribute in accessing metric data via the analytical view';


CREATE UNIQUE INDEX PK1_TYPE_ANAL_VIEW_REF ON TYPE_ANAL_VIEW_REF
(TYPE_ANAL_VIEW)
LOGGING
NOPARALLEL;


CREATE PUBLIC SYNONYM TYPE_ANAL_VIEW_REF FOR TYPE_ANAL_VIEW_REF;


ALTER TABLE TYPE_ANAL_VIEW_REF ADD (
  CONSTRAINT PK1_TYPE_ANAL_VIEW_REF
 PRIMARY KEY
 (TYPE_ANAL_VIEW));

