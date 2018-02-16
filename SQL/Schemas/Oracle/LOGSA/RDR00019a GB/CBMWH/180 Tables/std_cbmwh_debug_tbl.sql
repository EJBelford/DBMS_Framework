/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: std_cbmwh_debug_tbl
--      PURPOSE: Holds error as defined for PFSA.  The design was taken from 
--               PFSAW.  
--
-- TABLE SOURCE: std_cbmwh_debug_tbl.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 08 June 2008
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 06JUN08 - GB  - RDR00xxx -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

-- DROP TABLE std_cbmwh_debug_tbl;

CREATE TABLE std_cbmwh_debug_tbl
(
    ps_procedure  VARCHAR2(30),
    ps_oerr       VARCHAR2(6),
    ps_location   VARCHAR2(10),
    called_by     VARCHAR2(100),
    ps_id_key     VARCHAR2(200),
    ps_msg        VARCHAR2(200),
    msg_dt        DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE std_cbmwh_debug_tbl 
IS 'STD_CBMWH_DEBUG_TBL - PRODUCTION DATE 25 Sep 2004 - Used in PFSA processing to capture unexpected errors in processing as well as general program debugging during development.  Production systems should expect no records to be created.  Creation of a record is considerred a problem';


COMMENT ON COLUMN std_cbmwh_debug_tbl.ps_procedure 
IS 'PS_PROCEDURE - The actual procedure/function/process in which the error occurred.';

COMMENT ON COLUMN std_cbmwh_debug_tbl.ps_oerr 
IS 'PS_OERR - The actual oracle error number returned when the error is encountered.  Should be null for coder generated debug statements used in development';

COMMENT ON COLUMN std_cbmwh_debug_tbl.ps_location 
IS 'PS_LOCATION - A coder generated location in the procedure/function/process.  Standard for all code is ''Begin'' as a default';

COMMENT ON COLUMN std_cbmwh_debug_tbl.called_by 
IS 'CALLED_BY - A heirarchy of the call path for the process.  Standard processing code should pass the concatenated chain of procedures/functions through a process.';

COMMENT ON COLUMN std_cbmwh_debug_tbl.ps_id_key 
IS 'PS_ID_KEY - A coder generated text identification to identify what data was being processed when the error occurred.  Note the limit in size';

COMMENT ON COLUMN std_cbmwh_debug_tbl.ps_msg 
IS 'PS_MSG - A coder generated descriptive message';

COMMENT ON COLUMN std_cbmwh_debug_tbl.msg_dt 
IS 'MSG_DT - The date/timestamp of when the debug record was created';

