-- Verify that the stored procedure does not already exist.
SELECT * FROM dba_tables WHERE table_name = UPPER('GB_PFSA_AVAILABILITY_P_FACT') 
	AND OWNER = 'PFSAWH';
	
--IF EXISTS (SELECT * FROM dba_tables WHERE table_name = 'GB_PFSA_AVAILABILITY_P_FACT') 
	DROP TABLE GB_PFSA_AVAILABILITY_P_FACT;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--         NAME: PFSA_AVAILABILITY_P_FACT
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: PFSA_AVAILABILITY_P_FACT.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 19 November 2007
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
CREATE TABLE PFSAWH.GB_PFSA_AVAILABILITY_P_FACT
	(
	DATE_ID										number				not null , 
	AVAILABILITY_DATE_FROM						number				not null ,
	AVAILABILITY_DATE_TO						number				not null ,
	AVAILABILITY_FLEET_ID						number				not null ,
	AVAILABILITY_MACOM_ID						number				not null ,
	AVAILABILITY_UIC_ID							number				not null ,
	AVAILABILITY_GEO_ID							number				not null , 
--
	AVAILABILITY_SERIAL_NUMBER					varchar2(32) ,		-- sys_identifier_id
	AVAILABILITY_LIN_CODE						varchar2(1)			not null ,	-- sys_identifier_id
	AVAILABILITY_NIN_CODE						varchar2(1) ,		-- sys_identifier_id
	AVAILABILITY_NSN_CODE						varchar2(1) ,		-- sys_identifier_id
	AVAILABILITY_EIC_CODE						varchar2(1) ,		-- sys_identifier_id
	AVAILABILITY_UID_CODE						varchar2(1) ,		-- sys_identifier_id
--
	ITEM_DAYS 									number , 
	PERIOD_HRS 									number , 
	NMCM_HRS 									number , 
	NMCM_USER_HRS 								number , 
	NMCM_INT_HRS 								number , 
	NMCM_DEP_HRS 								number , 
	FMC_HRS 									number , 
	NMCS_HRS 									number , 
	PMC_HRS 									number , 
	NMC_HRS 									number , 
	MC_HRS 										number , 
	NMCS_USER_HRS								number , 
	NMCS_INT_HRS 								number , 
	NMCS_DEP_HRS 								number , 
	PMCM_HRS 									number , 
	PMCM_USER_HRS 								number , 
	PMCM_INT_HRS 								number , 
	DEP_HRS 									number , 
	PMCS_HRS 									number , 
	PMCS_USER_HRS 								number , 
	PMCS_INT_HRS 								number , 
--
	Operational_Readiness_Rate					number , 
--
	Operating_Cost_Per_Hour						number , 
	Cost_Parts									number , 
	Cost_Manpower								number , 
	Deferred_Maint_Items						number , 
	Operat_Hrs_since_last_overhaul				number , 
	Maint_Hrs_since_last_overhaul				number , 
	Time_since_last_overhaul					number , 
--
	STATUS										varchar2(1)			not null ,
	UPDT_BY										varchar2(30)		null ,
	LST_UPDT									date				null ,
--
	ACTIVE_FLAG									varchar2(1)			DEFAULT	'I' , 
	ACTIVE_DATE									date				DEFAULT	'31-DEC-2099' , 
	INACTIVE_DATE								date				DEFAULT	'31-DEC-2099' ,
--
	INSERT_BY									varchar2(20)		DEFAULT	user , 
	INSERT_DATE									date				DEFAULT	sysdate , 
	UPDATE_BY									varchar2(20)		null ,
	UPDATE_DATE									date				null ,
	DELETE_FLAG									varchar2(1)			null ,
	DELETE_DATE									date				null ,
	HIDDEN_FLAG									varchar2(1)			null ,
	HIDDEN_DATE									date				null ,
 constraint PK_AVAILABILITY_P_FACT primary key 
	(
	DATE_ID, 
	AVAILABILITY_DATE_FROM,
	AVAILABILITY_DATE_TO,
	AVAILABILITY_LIN_CODE, 
	AVAILABILITY_SERIAL_NUMBER
	)	
) 
logging 
nocompress 
nocache
noparallel
monitoring;

/*----- Indexs -----*/

DROP INDEX IXU_PFSA_AVAILABILITY_P_FACT;

CREATE UNIQUE INDEX IXU_PFSA_AVAILABILITY_P_FACT 
	ON PFSAWH.GB_PFSA_AVAILABILITY_P_FACT(AVAILABILITY_LIN_CODE);

/*----- Constraints -----*/

ALTER TABLE PFSAWH.GB_PFSA_AVAILABILITY_P_FACT  DROP CONSTRAINT CK_AVAILABILITY_P_FACT_STATUS		

ALTER TABLE PFSAWH.GB_PFSA_AVAILABILITY_P_FACT  ADD CONSTRAINT CK_AVAILABILITY_P_FACT_STATUS 
	CHECK (STATUS='C' OR STATUS='D' OR STATUS='E' OR STATUS='H' 
		OR STATUS='L' OR STATUS='P' OR STATUS='Q' OR STATUS='R'
		OR STATUS='Z' OR STATUS='N'
		);

/*----- Table Meta-Data -----*/ 
comment on table GB_PFSA_AVAILABILITY_P_FACT 
is 'n/a'; 

comment on column GB_PFSA_AVAILABILITY_P_FACT.DATE_ID 
is 'n/a' 


comment on column GB_PFSA_AVAILABILITY_P_FACT.STATUS 
is 'The status of the record in question.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.UPDT_BY 
is 'The date/timestamp of when the record was created/updated.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.LST_UPDT 
is 'Indicates either the program name or user ID of the person who updated the record.'


comment on column GB_PFSA_AVAILABILITY_P_FACT.ACTIVE_FLAG 
is 'Flag indicating if the record is active or not.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.ACTIVE_DATE 
is 'Addition control for active_Fl indicating when the record became active.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.INACTIVE_DATE 
is 'Addition control for active_Fl indicating when the record went inactive.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.INSERT_BY 
is 'Reports who initially created the record.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.INSERT_DATE 
is 'Reports when the record was initially created.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.UPDATE_BY 
is 'Reports who last updated the record.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.UPDATE_DATE 
is 'Reports when the record was last updated.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.DELETE_DATE 
is 'Addition control for DELETE_FLAG indicating when the record was marked for deletion.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'

comment on column GB_PFSA_AVAILABILITY_P_FACT.HIDDEN_DATE 
is 'Addition control for HIDDEN_FLAG indicating when the record was hidden.'

SELECT	TABLE_NAME, COMMENTS 
FROM	USER_TAB_COMMENTS 
WHERE	Table_Name = UPPER('GB_PFSA_AVAILABILITY_P_FACT') 

SELECT	b.COLUMN_ID, 
		a.TABLE_NAME, 
		a.COLUMN_NAME, 
		b.DATA_TYPE, 
		b.DATA_LENGTH, 
		b.NULLABLE, 
		a.COMMENTS 
FROM	USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('GB_PFSA_AVAILABILITY_P_FACT') 
	AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE	a.TABLE_NAME = UPPER('GB_PFSA_AVAILABILITY_P_FACT') 
ORDER BY b.COLUMN_ID 

