DROP TABLE PFSAWH.GB_PFSA_PLATFORM_FACT

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--         NAME: GB_PFSA_PLATFORM_FACT
--      PURPOSE:  
--
-- TABLE SOURCE: GB_PFSA_PLATFORM_FACT.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 9 NOVEMBER 2007
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--
CREATE TABLE PFSAWH.GB_PFSA_PLATFORM_FACT
(
	PLATFORM_ID				INTEGER				NOT NULL,
 	SYSTEM_ID				INTEGER				NOT NULL,
	PLATFORM_SERIAL_NUM		VARCHAR2(35 BYTE)	NOT NULL,
--
	STATUS					VARCHAR2(1 BYTE),
	LST_UPDT				DATE				DEFAULT	sysdate ,
	UPDT_BY					VARCHAR2(20 BYTE)	DEFAULT	user ,
--
	active_Fl				CHAR(1)				DEFAULT	'N' ,
	active_Dt				DATE				DEFAULT	'01-JAN-1900' ,
	inactive_Dt				DATE				DEFAULT	'31-DEC-2100'  ,
--
	insert_By				VARCHAR2(30)		DEFAULT	user ,
	insert_Dt				DATE				DEFAULT	sysdate ,
	delete_Fl				CHAR(1)				NULL ,
	delete_Dt				DATE				NULL ,
	hidden_Fl				CHAR(1)				NULL ,
	hidden_Dt				DATE				NULL 
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX PFSAWH.PK_GB_PFSA_SYSTEM_DIM ON PFSAWH.GB_PFSA_PLATFORM_FACT
(SYSTEM_ID, PLATFORM_SERIAL_NUM)
LOGGING
NOPARALLEL;

/*----- comments -----*/

COMMENT ON COLUMN PFSAWH.GB_PFSA_PLATFORM_FACT.PLATFORM_ID IS '';

COMMENT ON COLUMN PFSAWH.GB_PFSA_PLATFORM_FACT.SYSTEM_ID IS 'A major grouping End Items.';

COMMENT ON COLUMN PFSAWH.GB_PFSA_PLATFORM_FACT.PLATFORM_SERIAL_NUM IS 'Unquiely indentifies the platform within the system.'; 

/*---- Populate the fact -----*/

INSERT INTO PFSAWH.GB_PFSA_PLATFORM_FACT (	PLATFORM_ID, SYSTEM_ID, PLATFORM_SERIAL_NUM, STATUS) 
	VALUES (1, 1, 'acb123cde098', 'U') 
	
SELECT * 
FROM	PFSAWH.GB_PFSA_PLATFORM_FACT

