DROP TABLE STD_PFSA_DEBUG_TBL;

CREATE TABLE STD_PFSA_DEBUG_TBL
(
  PS_PROCEDURE  VARCHAR2(30 BYTE),
  PS_OERR       VARCHAR2(6 BYTE),
  PS_LOCATION   VARCHAR2(10 BYTE),
  CALLED_BY     VARCHAR2(100 BYTE),
  PS_ID_KEY     VARCHAR2(200 BYTE),
  PS_MSG        VARCHAR2(200 BYTE),
  MSG_DT        DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE std_pfsa_debug_tbl 
IS 'PRODUCTION DATE 25 Sep 2004.  Used in PFSA processing to capture unexpected errors in processing as well as general program debugging during development.  Production systems should expect no records to be created.  Creation of a record is considerred a problem';


COMMENT ON COLUMN std_pfsa_debug_tbl.ps_procedure 
IS 'The actual procedure/function/process in which the error occurred.';

COMMENT ON COLUMN std_pfsa_debug_tbl.ps_oerr 
IS 'The actual oracle error number returned when the error is encountered.  Should be null for coder generated debug statements used in development';

COMMENT ON COLUMN std_pfsa_debug_tbl.ps_location 
IS 'A coder generated location in the procedure/function/process.  Standard for all code is ''Begin'' as a default';

COMMENT ON COLUMN std_pfsa_debug_tbl.called_by 
IS 'A heirarchy of the call path for the process.  Standard processing code should pass the concatenated chain of procedures/functions through a process.';

COMMENT ON COLUMN std_pfsa_debug_tbl.ps_id_key 
IS 'A coder generated text identification to identify what data was being processed when the error occurred.  Note the limit in size';

COMMENT ON COLUMN std_pfsa_debug_tbl.ps_msg 
IS 'A coder generated descriptive message';

COMMENT ON COLUMN std_pfsa_debug_tbl.msg_dt 
IS 'The date/timestamp of when the debug record was created';


CREATE PUBLIC SYNONYM STD_PFSA_DEBUG_TBL FOR STD_PFSA_DEBUG_TBL;


GRANT DELETE ON STD_PFSA_DEBUG_TBL TO C_PFSAW_DB_IN;

