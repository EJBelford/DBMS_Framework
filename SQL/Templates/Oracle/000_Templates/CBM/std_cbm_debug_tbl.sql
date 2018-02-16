/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: std_cbm_debug_tbl..
--      PURPOSE: Used in MIMOSA_BL processing to capture unexpected errors in 
--               processing as well as general program debugging during 
--               development.  Production systems should expect no records to 
--               be created.  Creation of a record is considerred a problem.. 
--               The design was taken from PFSA.. 
--
--   CREATED BY: G. Belford..
-- CREATED DATE: 18-Nov-2009..
--
--       SOURCE: std_cbm_debug_tbl.sql..
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     std_cbm_debug_tbl
--    Sysdate:         01-Sep-2009
--    Date and Time:   01-Sep-2009, 10:02:59, and 01-Sep-2009 10:02:59
--    Username:        G. Belford (set in TOAD Options, Procedure Editor)
--    Table Name:       (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DD-MMM-YYYY - Who         - RDP / ECP # - Details..
-- 18-Nov-2009 - G. Belford  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Create Table  -----*/

-- DROP TABLE std_cbm_debug_tbl;
	
CREATE TABLE std_cbm_debug_tbl 
(
    rec_id                           NUMBER              NOT NULL ,
--
    ps_procedure                     VARCHAR2(30),
    ps_oerr                          VARCHAR2(6),
    ps_location                      VARCHAR2(10),
    called_by                        VARCHAR2(100),
    ps_id_key                        VARCHAR2(200),
    ps_msg                           VARCHAR2(200),
    msg_dt                           DATE
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             32K
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

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE std_cbm_debug_tbl 
IS 'STD_CBM_DEBUG_TBL - Used in MIMOSA_BL processing to capture unexpected errors in processing as well as general program debugging during development.  Production systems should expect no records to be created.  Creation of a record is considerred a problem...'; 


/*----- Column Meta-Data -----*/ 

COMMENT ON COLUMN std_cbm_debug_tbl.rec_id 
IS 'REC_ID - Primary, blind key of the std_cbm_debug_tbl table.'; 

COMMENT ON COLUMN std_cbm_debug_tbl.ps_procedure 
IS 'PS_PROCEDURE - The actual procedure/function/process in which the error occurred.';

COMMENT ON COLUMN std_cbm_debug_tbl.ps_oerr 
IS 'PS_OERR - The actual oracle error number returned when the error is encountered.  Should be null for coder generated debug statements used in development';

COMMENT ON COLUMN std_cbm_debug_tbl.ps_location 
IS 'PS_LOCATION - A coder generated location in the procedure/function/process.  Standard for all code is ''Begin'' as a default';

COMMENT ON COLUMN std_cbm_debug_tbl.called_by 
IS 'CALLED_BY - A heirarchy of the call path for the process.  Standard processing code should pass the concatenated chain of procedures/functions through a process.';

COMMENT ON COLUMN std_cbm_debug_tbl.ps_id_key 
IS 'PS_ID_KEY - A coder generated text identification to identify what data was being processed when the error occurred.  Note the limit in size';

COMMENT ON COLUMN std_cbm_debug_tbl.ps_msg 
IS 'PS_MSG - A coder generated descriptive message';

COMMENT ON COLUMN std_cbm_debug_tbl.msg_dt 
IS 'MSG_DT - The date/timestamp of when the debug record was created';

/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('std_cbm_debug_tbl'); 
*/
/*----- Check to see if the table column comments are present -----*/
/*
SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        b.data_default,  
        a.comments 
--        , '|', b.*  
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('std_cbm_debug_tbl') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('std_cbm_debug_tbl') 
ORDER BY b.column_id; 
*/
/*----- Look-up field description from master LIDB table -----*/
/*
SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name; 
/ 
*/
/*   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%rec_id%'); 
/ 
*/

