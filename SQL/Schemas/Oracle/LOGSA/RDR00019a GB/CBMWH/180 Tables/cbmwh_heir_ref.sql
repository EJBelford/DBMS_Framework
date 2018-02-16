--
-- CBMWH_HEIR_REF  (Table) 
--

DROP TABLE cbmwh_heir_ref; 

CREATE TABLE cbmwh_heir_ref
(
  heir_id                         VARCHAR2(30),       
  source_schema                   VARCHAR2(30),
  build_area                      VARCHAR2(30),
  priority                        NUMBER,
  description                     VARCHAR2(200),
  status                          VARCHAR2(1),
  updt_by                         VARCHAR2(30)        DEFAULT user,
  lst_updt                        DATE                DEFAULT sysdate
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          32K
            NEXT             16K
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


COMMENT ON TABLE cbmwh_heir_ref IS 'CBMWH_HEIR_REF - This table is used in the PFSA promotion processes for metric data. to ensure higher priority data/system of record data sources are used when the same data is received from multiple sources.  The individual promotion processes need to handle any special considerations where the same key set is not generated.';


COMMENT ON COLUMN cbmwh_heir_ref.HEIR_ID IS 'HEIR_ID - A PFSA team generated identifier of the data source.  It is similar to the SOURCE_ID and is the same except in cases where more specific source identifiers are used, e.g., the identification of a specific box as in the CPME and AMAC data.';

COMMENT ON COLUMN cbmwh_heir_ref.SOURCE_SCHEMA IS 'SOURCE_SCHEMA - ';

COMMENT ON COLUMN cbmwh_heir_ref.BUILD_AREA IS 'BUILD_AREA - The specific build table that is being promoted.';

COMMENT ON COLUMN cbmwh_heir_ref.PRIORITY IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priorityh';

COMMENT ON COLUMN cbmwh_heir_ref.DESCRIPTION IS 'DESCRIPTION - A desciption of the data source';

COMMENT ON COLUMN cbmwh_heir_ref.STATUS IS 'STATUS - The status of this record';

COMMENT ON COLUMN cbmwh_heir_ref.UPDT_BY IS 'UPDT_BY - The source of the data or who changed the data';

COMMENT ON COLUMN cbmwh_heir_ref.LST_UPDT IS 'LST_UPDT - The system date of when this record was created/changed';


--
-- pk1_cbmwh_heir_ref  (Index) 
--

CREATE UNIQUE INDEX pk1_cbmwh_heir_ref 
ON cbmwh_heir_ref
    (
    heir_id, 
    build_area
    )
LOGGING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          16K
            NEXT             16K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table cbmwh_heir_ref 
-- 

ALTER TABLE cbmwh_heir_ref 
ADD ( CONSTRAINT pk1_cbmwh_heir_ref
 PRIMARY KEY
 (
 heir_id, 
 build_area
 )
    USING INDEX 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             16K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
               
/*

INSERT 
INTO   cbmwh_heir_ref 
    (
    heir_id, 
    build_area, 
    priority, 
    description, 
    status, 
    updt_by, 
    lst_updt
    )
SELECT   heir_id, 
    build_area, 
    priority, 
    description, 
    status, 
    updt_by, 
    lst_updt 
FROM   pfsa_heir_ref@pfsaw.lidb; 

COMMIT; 

*/

/*

SELECT * 
FROM   pfsa_heir_ref@pfsaw.lidb
ORDER BY build_area, priority; 

*/
