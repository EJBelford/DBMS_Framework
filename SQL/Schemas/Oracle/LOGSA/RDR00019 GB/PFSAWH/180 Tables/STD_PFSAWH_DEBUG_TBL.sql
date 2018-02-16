
CREATE TABLE std_pfsawh_debug_tbl
(
  ps_procedure  VARCHAR2(30 BYTE),
  ps_oerr       VARCHAR2(6 BYTE),
  ps_location   VARCHAR2(10 BYTE),
  called_by     VARCHAR2(100 BYTE),
  ps_id_key     VARCHAR2(200 BYTE),
  ps_msg        VARCHAR2(200 BYTE),
  msg_dt        DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
/

COMMENT ON TABLE std_pfsawh_debug_tbl 
IS 'STD_PFSAWH_DEBUG_TBL - PRODUCTION DATE 25 Sep 2004.  Used in PFSA processing to capture unexpected errors in processing as well as general program debugging during development.  Production systems should expect no records to be created.  Creation of a record is considerred a problem';


COMMENT ON COLUMN std_pfsawh_debug_tbl.PS_PROCEDURE 
IS 'PS_PROCEDURE - The actual procedure/function/process in which the error occurred.';

COMMENT ON COLUMN std_pfsawh_debug_tbl.PS_OERR 
IS 'PS_OERR - The actual oracle error number returned when the error is encountered.  Should be null for coder generated debug statements used in development';

COMMENT ON COLUMN std_pfsawh_debug_tbl.PS_LOCATION 
IS 'PS_LOCATION - A coder generated location in the procedure/function/process.  Standard for all code is ''Begin'' as a default';

COMMENT ON COLUMN std_pfsawh_debug_tbl.CALLED_BY 
IS 'CALLED_BY - A heirarchy of the call path for the process.  Standard processing code should pass the concatenated chain of procedures/functions through a process.';

COMMENT ON COLUMN std_pfsawh_debug_tbl.PS_ID_KEY 
IS 'PS_ID_KEY - A coder generated text identification to identify what data was being processed when the error occurred.  Note the limit in size';

COMMENT ON COLUMN std_pfsawh_debug_tbl.PS_MSG 
IS 'PS_MSG - A coder generated descriptive message';

COMMENT ON COLUMN std_pfsawh_debug_tbl.MSG_DT 
IS 'MSG_DT - The date/timestamp of when the debug record was created';


CREATE PUBLIC SYNONYM std_pfsawh_debug_tbl FOR std_pfsawh_debug_tbl;


GRANT DELETE ON  std_pfsawh_debug_tbl TO C_PFSAW_DB_IN;

