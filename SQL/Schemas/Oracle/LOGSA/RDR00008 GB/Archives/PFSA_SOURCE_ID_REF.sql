
CREATE TABLE PFSA_SOURCE_ID_REF
(
  SOURCE_ID           VARCHAR2(20 BYTE),
  SOURCE_DESCRIPTION  VARCHAR2(240 BYTE),
  STATUS              VARCHAR2(1 BYTE),
  LST_UPDT            DATE,
  UPDT_BY             VARCHAR2(30 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE PFSA_SOURCE_ID_REF IS 'This table containes a list of all sources of data in the PFSA World  It is maintained by PFSA data base personnel.  The source_ids are assigned via data grab procedures and are assigned to link the source data tables and may include fidelity to individual collection points.';

COMMENT ON COLUMN PFSA_SOURCE_ID_REF.SOURCE_ID IS 'A PFSA team generated identification of the source of data.  Values used should be short to allow for concatenation of a more specific source, such as a site using a specific reporting system.';

COMMENT ON COLUMN PFSA_SOURCE_ID_REF.SOURCE_DESCRIPTION IS 'A description of the source id, to include a general idea of the uses of the data in the world.';

COMMENT ON COLUMN PFSA_SOURCE_ID_REF.STATUS IS 'THE STATUS OF THIS RECORD';

COMMENT ON COLUMN PFSA_SOURCE_ID_REF.LST_UPDT IS 'THE SYSTEM DATE OF WHEN THIS RECORD WAS CREATED/CHANGED';

COMMENT ON COLUMN PFSA_SOURCE_ID_REF.UPDT_BY IS 'AN IDENTIFIER OF WHAT CHANGED/CREATED THE RECORD';


CREATE UNIQUE INDEX PK1_PFSA_SOURCE_ID_REF ON PFSA_SOURCE_ID_REF
(SOURCE_ID)
LOGGING
NOPARALLEL;


CREATE OR REPLACE TRIGGER tr_pfsa_source_id_ref
-- this trigger sets the values for the standard variables in this table
--
-- PRODUCTION DATE 25 SEP 2004
--
BEFORE INSERT OR UPDATE on PFSA_SOURCE_ID_REF
FOR EACH ROW
DECLARE
  ps_oerr 			VARCHAR2(6) := null;
  ps_location			VARCHAR2(10) := 'BEGIN'; 
  ps_procedure_name		VARCHAR2(30) := 'TR_pfsa_source_id_ref';
  ps_msg			VARCHAR2(200) := 'trigger_failed';
  ps_id_key			VARCHAR2(200) := null; -- set in cases

BEGIN
  :new.lst_updt := sysdate;
  IF :new.updt_by IS NULL THEN
     :new.updt_by := substr(user, 1, 20);
  END IF;
  IF :new.source_description IS NULL THEN
       :new.status := 'Q';
  ELSE
     IF :new.status NOT IN ('C','H') THEN
	    :new.status := 'Q';
	 END IF;
  END IF;


-- unexpected exception 
EXCEPTION WHEN OTHERS THEN
		  ps_oerr := sqlcode;
                  ps_msg := 'Unknown error';
				  ps_id_key := :new.source_id;
		  insert into std_pfsa_debug_tbl (ps_procedure, ps_oerr, ps_location, called_by, ps_id_key, ps_msg, msg_dt)
		         values (ps_procedure_name, ps_oerr, ps_location, null, ps_id_key, ps_msg, sysdate);

END; -- end of trigger
/
SHOW ERRORS;



ALTER TABLE PFSA_SOURCE_ID_REF ADD (
  CONSTRAINT PK1_PFSA_SOURCE_ID_REF
 PRIMARY KEY
 (SOURCE_ID));


GRANT INSERT, SELECT, UPDATE ON  PFSA_SOURCE_ID_REF TO C_PFSAW_DB_IN;

GRANT SELECT ON  PFSA_SOURCE_ID_REF TO LIW_BASIC;

GRANT SELECT ON  PFSA_SOURCE_ID_REF TO LIW_RESTRICTED;

GRANT SELECT ON  PFSA_SOURCE_ID_REF TO S_PFSAW;

