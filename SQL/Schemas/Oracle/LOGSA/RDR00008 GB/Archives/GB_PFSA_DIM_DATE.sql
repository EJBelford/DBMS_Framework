-- Verify that the stored procedure does not already exist.

SELECT * FROM dba_tables WHERE table_name = UPPER('GB_PFSA_DIM_DATE') 
	AND OWNER = 'PFSAWH';

--IF EXISTS (SELECT * FROM dba_tables WHERE table_name = 'PFSA_DIM_DATE') 
	DROP TABLE GB_PFSA_DIM_DATE;

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--         NAME: PFSA_DIM_DATE
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: PFSA_DIM_DATE.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 30 October 2007
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
CREATE TABLE PFSAWH.GB_PFSA_DIM_DATE
	(
	DATE_ID							INTEGER				not null ,	-- RESETWH DATE_DIM	 
	ORACLE_DATE						DATE				not null ,	-- RESETWH DATE_DIM	
	DAY_OF_WEEK						VARCHAR2(20)		not null ,	-- RESETWH DATE_DIM	
	DAY_NUM_IN_MONTH				INTEGER				not null ,	-- RESETWH DATE_DIM	
	DAY_NUM_OVERALL					INTEGER				not null ,	-- RESETWH DATE_DIM	
	WEEK_NUMBER_IN_YEAR				INTEGER				not null ,	-- RESETWH DATE_DIM
	WEEK_NUMBER_OVERALL				INTEGER				not null ,	-- RESETWH DATE_DIM
	MONTH_NUMBER_IN_YEAR			INTEGER				not null ,	-- RESETWH DATE_DIM	
	MONTH_NUMBER_OVERALL			INTEGER				not null ,	-- RESETWH DATE_DIM	
	CALENDAR_QUARTER				INTEGER				not null ,	-- RESETWH DATE_DIM	
	FISCAL_QUARTER					varchar2(10)		not null ,	-- RESETWH DATE_DIM	
	HOLIDAY_FLAG					varchar2(11)		not null ,	-- RESETWH DATE_DIM	
	WEEKDAY_FLAG					varchar2(7)			not null ,	-- RESETWH DATE_DIM	
	SEASON							varchar2(50)		not null ,	-- RESETWH DATE_DIM		
	EVENT							varchar2(50)		not null ,	-- RESETWH DATE_DIM		
--	
	FULL_DATE_DESC					varchar2(30)		not null ,
-- PFSA Dates 
	DAY_DATE						date				not null ,  
	DAY_THRU						date				not null ,  
	DAY_FROM_TIME					date				not null , 
	DAY_TO_TIME						date				not null , 
	MONTH_DATE						date				not null , 
	MONTH_FROM_TIME					date				not null , 
	MONTH_TO_TIME					date				not null ,  
	READY_DATE						date				not null , 
	READY_FROM_TIME					date				not null , 
	READY_TO_TIME					date				not null , 
	USAGE_DATE						date				not null , 
	USAGE_FROM_TIME					date				not null , 
	USAGE_TO_TIME 					date				not null , 		
	USAGE_DAYS_IN_PERIOD			number(2)			not null ,		
--	
	DAY_NUM_IN_EPOCH				number				not null ,
	WEEK_NUM_IN_EPOCH				number				not null ,
	MONTH_NUM_IN_EPOCH				number				not null ,
--
	DAY_NUM_IN_CALENDAR_YEAR		number(3)			not null ,
	DAY_NUM_IN_FISCAL_MONTH			number(2)			not null , 
	DAY_NUM_IN_FISCAL_YEAR			number(3)			not null ,
--
	LAST_DAY_IN_WEEK_INDICATOR		varchar2(20)		not null ,
	LAST_DAY_IN_MONTH_INDICATOR		varchar2(20)		not null ,
--
	CALENDAR_WEEK_ENDING_DATE		varchar2(20)		not null ,	
	CALENDAR_MONTH_NAME				varchar2(20)		not null ,
	CALENDAR_YEAR_MONTH_YYYYMM		varchar2(7)			not null ,
	CALENDAR_YEAR_QUARTER_YYYYQQ	varchar2(7)			not null ,
	CALENDAR_HALFYEAR				varchar2(20)		not null ,
	CALENDAR_YEAR					number(4)			not null ,
--
	FISCAL_WEEK_ENDING_DATE			varchar2(20)		not null ,
	FISCAL_WEEK_NUMBER_IN_YEAR		number(2)			not null ,
	FISCAL_MONTH_NAME				varchar2(20)		not null ,
	FISCAL_MONTH_IN_YEAR			number(2)			not null ,
	FISCAL_YEAR_MONTH_YYYYMM		varchar2(7)			not null ,
	FISCAL_YEAR_QUARTER_YYYYQQ		varchar2(7)			not null ,
	FISCAL_HALF_YEAR				varchar2(7)			not null ,
	FISCAL_YEAR						varchar2(5)			not null ,
--
	STATUS							varchar(1)			not null ,
	UPDT_BY							varchar2(30)		null ,
	LST_UPDT						date				null ,
--
	INSERT_BY						varchar2(20)		DEFAULT	user , 
	INSERT_DT						date				DEFAULT	sysdate , 
	UPDATE_BY						varchar2(20)		null ,
	UPDATE_DT						date				null ,
	DELETE_FL						varchar2(1)			null ,
	DELETE_DT						date				null ,
	HIDDEN_FL						varchar2(1)			null ,
	HIDDEN_DT						date				null ,
 constraint PK_DIM_DATE primary key 
	(
	DATE_ID
	)	
) 
logging 
nocompress 
nocache
noparallel
monitoring;

alter table PFSAWH.GB_PFSA_DIM_DATE add constraint CK_DIM_DT_CALENDAR_MONTH_NM 
	check  (CALENDAR_MONTH_NAME='DECEMBER' or CALENDAR_MONTH_NAME='NOVEMBER' 
		or CALENDAR_MONTH_NAME='OCTOBER' or CALENDAR_MONTH_NAME='SEPTEMBER' 
		or CALENDAR_MONTH_NAME='AUGUST' or CALENDAR_MONTH_NAME='JULY' 
		or CALENDAR_MONTH_NAME='JUNE' or CALENDAR_MONTH_NAME='MAY' 
		or CALENDAR_MONTH_NAME='APRIL' or CALENDAR_MONTH_NAME='MARCH' 
		or CALENDAR_MONTH_NAME='FEBRUARY' or CALENDAR_MONTH_NAME='JANUARY' 
		or CALENDAR_MONTH_NAME='NOT APPLICABLE')
logging
noparallel;

-- ALTER TABLE PFSAWH.GB_PFSA_DIM_DATE constraint CK_DIM_DT_CALENDAR_MONTH_NM

alter table PFSAWH.GB_PFSA_DIM_DATE  add constraint CK_DIM_DT_DAYOFWEEK 
	check (DAY_OF_WEEK='SATURDAY' or DAY_OF_WEEK='FRIDAY' or DAY_OF_WEEK='THURSDAY' 
		or DAY_OF_WEEK='WEDNESDAY' or DAY_OF_WEEK='TUESDAY' or DAY_OF_WEEK='MONDAY' 
		or DAY_OF_WEEK='SUNDAY' or DAY_OF_WEEK='NOT APPLICABLE')
logging
noparallel;

-- ALTER TABLE DBO.DIM_DATE CHECK constraint CK_DIM_DATE_DAYOFWEEK

alter table PFSAWH.GB_PFSA_DIM_DATE add constraint CK_DIM_DT_HOLIDAYFLAG
	check (HOLIDAY_FLAG='NON-HOLIDAY' or HOLIDAY_FLAG='HOLIDAY' 
		or HOLIDAY_FLAG='NOT APPLICABLE')
logging
noparallel;

-- ALTER TABLE DBO.DIM_DATE CHECK constraint CK_DIM_DATE_HOLIDAYINDICATOR

alter table PFSAWH.GB_PFSA_DIM_DATE add constraint CK_DIM_DT_WEEKDAYFLAG 
	check (WEEKDAY_FLAG='WEEKEND DAY' or WEEKDAY_FLAG='WEEKDAY' 
		or WEEKDAY_FLAG='NOT APPLICABLE')
logging
noparallel;

-- ALTER TABLE DBO.DIM_DATE CHECK constraint CK_DIM_DATE_WEEKDAY

alter table PFSAWH.GB_PFSA_DIM_DATE add constraint CK_DIM_DT_SEASON 
	check (SEASON='SPRING' or SEASON='SUMMER' 
		or SEASON='FALL' or SEASON='WINTER' or SEASON='NOT APPLICABLE')

-- ALTER TABLE DBO.DIM_DATE CHECK constraint CK_DIM_DATE_SELLINGSEASON

alter table PFSAWH.GB_PFSA_DIM_DATE add constraint CK_DIM_DT_EVENT 
	check (EVENT='NON-EVENT' or EVENT='NOT APPLICABLE')
logging
noparallel;

-- ALTER TABLE DBO.DIM_DATE CHECK constraint CK_DIM_DATE_MAJOREVENT

comment on table GB_PFSA_DIM_DATE is 'PFSA_DIM_Date  description'; 

comment on column GB_PFSA_DIM_DATE.DATE_ID is 'Identity for PFSA_DIM_xxx records.' 

comment on column GB_PFSA_DIM_DATE.ORACLE_DATE is 'A truncated date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level.  Other dates are made up of a set of distinct consecutive values of day_date.  Values are constrained procedurally to lie within the mindate and maxdate in table.  Dates in this table can be future based and generally are based upon automatic maintenance.'   

comment on column GB_PFSA_DIM_DATE.DAY_FROM_TIME is 'The minimum point in time considered to be part of the day date.' 

comment on column GB_PFSA_DIM_DATE.DAY_TO_TIME is 'The maximum point in time considered to be part of the day date.' 

comment on column GB_PFSA_DIM_DATE.MONTH_DATE is 'The value of the first day of the month for a given day_date, reflecting group by month cases.  MONTH_DATE is a forward based date value constrained at the month level.' 

comment on column GB_PFSA_DIM_DATE.MONTH_FROM_TIME is 'The minimum point in time considered to be part of the month date.' 

comment on column GB_PFSA_DIM_DATE.MONTH_TO_TIME is 'The maximum point in time considered to be part of the month date.' 

comment on column GB_PFSA_DIM_DATE.READY_DATE is 'A specific snap shot of time, midnight of the indicated day.  READY_DATE is a backward looking time component, comprised of all time since midnight of the previous month thru the indicated date.' 

comment on column GB_PFSA_DIM_DATE.READY_FROM_TIME is 'The minimum point in time considered to be part of the ready date.' 

comment on column GB_PFSA_DIM_DATE.READY_TO_TIME is 'The maximum point in time considered to be part of the ready date.' 

comment on column GB_PFSA_DIM_DATE.USAGE_DATE is 'Usage dates are a PFSA created attribute used to break usage data into time periods condusive to being used both in month periods and ready periods.  USAGE_DATE is a backward  looking time component.' 

comment on column GB_PFSA_DIM_DATE.USAGE_FROM_TIME is 'The minimum point in time considered to be part of the usage date.' 

comment on column GB_PFSA_DIM_DATE.USAGE_TO_TIME is 'The maximum point in time considered to be part of the usage date.' 	

comment on column GB_PFSA_DIM_DATE.USAGE_DAYS_IN_PERIOD is 'This field represents the number of days in the usage period.  Used in averaging monthly reported data into synchronized time frames corresponding to month dates.' 	


comment on column GB_PFSA_DIM_DATE.active_Fl is 'Flag indicating if the record is active or not.'
comment on column GB_PFSA_DIM_DATE.active_Dt is 'Addition control for active_Fl indicating when the record became active.'
comment on column GB_PFSA_DIM_DATE.inactive_Dt is 'Addition control for active_Fl indicating when the record went inactive.'

comment on column GB_PFSA_DIM_DATE.insert_By is ''
comment on column GB_PFSA_DIM_DATE.insert_Dt is ''
comment on column GB_PFSA_DIM_DATE.update_By is ''
comment on column GB_PFSA_DIM_DATE.update_Dt is ''

comment on column GB_PFSA_DIM_DATE.delete_Fl is 'Flag indicating if the record can be deleted.'

comment on column GB_PFSA_DIM_DATE.delete_Dt is 'Addition control for delete_Fl indicating when the record was marked for deletion.'

comment on column GB_PFSA_DIM_DATE.HIDDEN_Fl is ''
comment on column GB_PFSA_DIM_DATE.HIDDEN_Dt is ''

SELECT	TABLE_NAME, COMMENTS 
FROM	USER_TAB_COMMENTS 
WHERE	Table_Name = UPPER('GB_PFSA_DIM_DATE') 

SELECT	b.COLUMN_ID, 
		a.TABLE_NAME, 
		a.COLUMN_NAME, 
		b.DATA_TYPE, 
		b.DATA_LENGTH, 
		b.NULLABLE, 
		a.COMMENTS 
FROM	USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('GB_PFSA_DIM_DATE') 
	AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE	a.TABLE_NAME = UPPER('GB_PFSA_DIM_DATE') 
ORDER BY b.COLUMN_ID 

