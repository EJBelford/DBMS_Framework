-- Verify that the stored procedure does not already exist.
SELECT * FROM dba_tables WHERE table_name = UPPER('GB_PFSA_DATE_DIM') 
	AND OWNER = 'PFSAWH';
--IF EXISTS (SELECT * FROM dba_tables WHERE table_name = 'GB_PFSA_DATE_DIM') 
	DROP TABLE GB_PFSA_DATE_DIM;
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--         NAME: PFSA_DIM_DATE
--      PURPOSE: PFSA_DIM_Date - Contain a truncated date value representing an individual day 
--               that LOGAS has used or expects to use. 
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
CREATE TABLE PFSAWH.GB_PFSA_DATE_DIM
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
	FULL_DATE_DESCRIPTION			varchar2(30)		not null ,
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
	DAY_NUMBER_IN_EPOCH				number				not null ,
	WEEK_NUMBER_IN_EPOCH			number				not null ,
	MONTH_NUMBER_IN_EPOCH			number				not null ,
--
	DAY_NUMBER_IN_CALENDAR_YEAR		number(3)			not null ,
	DAY_NUMBER_IN_FISCAL_MONTH		number(2)			not null , 
	DAY_NUMBER_IN_FISCAL_YEAR		number(3)			not null ,
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
	ACTIVE_FLAG						varchar2(1)			DEFAULT	'I' , 
	ACTIVE_DATE						date				DEFAULT	'31-DEC-2099' , 
	INACTIVE_DATE					date				DEFAULT	'31-DEC-2099' ,
--
	INSERT_BY						varchar2(20)		DEFAULT	user , 
	INSERT_DATE						date				DEFAULT	sysdate , 
	UPDATE_BY						varchar2(20)		null ,
	UPDATE_DATE						date				null ,
	DELETE_FLAG						varchar2(1)			null ,
	DELETE_DATE						date				null ,
	HIDDEN_FLAG						varchar2(1)			null ,
	HIDDEN_DATE						date				null ,
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
/*----- Indexs -----*/
DROP INDEX IXU_PFSA_DATE_DIM;
CREATE UNIQUE INDEX IXU_PFSA_DATE_DIM 
	ON PFSAWH.GB_PFSA_DATE_DIM(ORACLE_DATE);
/*----- Constraints -----*/
alter table PFSAWH.GB_PFSA_DATE_DIM add constraint CK_DIM_DT_CALENDAR_MONTH_NM 
	check  (CALENDAR_MONTH_NAME='DECEMBER' or CALENDAR_MONTH_NAME='NOVEMBER' 
		or CALENDAR_MONTH_NAME='OCTOBER' or CALENDAR_MONTH_NAME='SEPTEMBER' 
		or CALENDAR_MONTH_NAME='AUGUST' or CALENDAR_MONTH_NAME='JULY' 
		or CALENDAR_MONTH_NAME='JUNE' or CALENDAR_MONTH_NAME='MAY' 
		or CALENDAR_MONTH_NAME='APRIL' or CALENDAR_MONTH_NAME='MARCH' 
		or CALENDAR_MONTH_NAME='FEBRUARY' or CALENDAR_MONTH_NAME='JANUARY' 
		or CALENDAR_MONTH_NAME='NOT APPLICABLE')
logging
noparallel;
alter table PFSAWH.GB_PFSA_DATE_DIM  add constraint CK_DIM_DT_DAYOFWEEK 
	check (DAY_OF_WEEK='SATURDAY' or DAY_OF_WEEK='FRIDAY' or DAY_OF_WEEK='THURSDAY' 
		or DAY_OF_WEEK='WEDNESDAY' or DAY_OF_WEEK='TUESDAY' or DAY_OF_WEEK='MONDAY' 
		or DAY_OF_WEEK='SUNDAY' or DAY_OF_WEEK='NOT APPLICABLE')
logging
noparallel;
alter table PFSAWH.GB_PFSA_DATE_DIM add constraint CK_DIM_DT_HOLIDAYFLAG
	check (HOLIDAY_FLAG='NON-HOLIDAY' or HOLIDAY_FLAG='HOLIDAY' 
		or HOLIDAY_FLAG='NOT APPLICABLE')
logging
noparallel;
alter table PFSAWH.GB_PFSA_DATE_DIM add constraint CK_DIM_DT_WEEKDAYFLAG 
	check (WEEKDAY_FLAG='WEEKEND DAY' or WEEKDAY_FLAG='WEEKDAY' 
		or WEEKDAY_FLAG='NOT APPLICABLE')
logging
noparallel;
alter table PFSAWH.GB_PFSA_DATE_DIM add constraint CK_DIM_DT_SEASON 
	check (SEASON='SPRING' or SEASON='SUMMER' 
		or SEASON='FALL' or SEASON='WINTER' or SEASON='NOT APPLICABLE')
ALTER TABLE PFSAWH.GB_PFSA_DATE_DIM  DROP CONSTRAINT CK_DIM_DT_EVENT		
alter table PFSAWH.GB_PFSA_DATE_DIM add constraint CK_DIM_DT_EVENT 
	check (EVENT='EVENT' or EVENT='NON-EVENT' or EVENT='NOT APPLICABLE')
logging
noparallel;

/*----- Table Meta-Data -----*/ 
comment on table GB_PFSA_DATE_DIM 
is 'PFSA_DIM_Date - Contain a truncated date value representing an individual day that LOGAS has used or expects to use.  '; 

comment on column GB_PFSA_DATE_DIM.DATE_ID 
is 'Identity for PFSA_DIM_xxx records.' 
comment on column GB_PFSA_DATE_DIM.ORACLE_DATE 
is 'A truncated date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level.  Other dates are made up of a set of distinct consecutive values of day_date.  Values are constrained procedurally to lie within the mindate and maxdate in table.  Dates in this table can be future based and generally are based upon automatic maintenance.'   
comment on column GB_PFSA_DATE_DIM.DAY_FROM_TIME 
is 'The minimum point in time considered to be part of the day date.' 
comment on column GB_PFSA_DATE_DIM.DAY_TO_TIME 
is 'The maximum point in time considered to be part of the day date.' 
comment on column GB_PFSA_DATE_DIM.MONTH_DATE 
is 'The value of the first day of the month for a given day_date, reflecting group by month cases.  MONTH_DATE is a forward based date value constrained at the month level.' 
comment on column GB_PFSA_DATE_DIM.MONTH_FROM_TIME 
is 'The minimum point in time considered to be part of the month date.' 
comment on column GB_PFSA_DATE_DIM.MONTH_TO_TIME 
is 'The maximum point in time considered to be part of the month date.' 
comment on column GB_PFSA_DATE_DIM.READY_DATE 
is 'A specific snap shot of time, midnight of the indicated day.  READY_DATE is a backward looking time component, comprised of all time since midnight of the previous month thru the indicated date.' 
comment on column GB_PFSA_DATE_DIM.READY_FROM_TIME 
is 'The minimum point in time considered to be part of the ready date.' 
comment on column GB_PFSA_DATE_DIM.READY_TO_TIME 
is 'The maximum point in time considered to be part of the ready date.' 
comment on column GB_PFSA_DATE_DIM.USAGE_DATE 
is 'Usage dates are a PFSA created attribute used to break usage data into time periods condusive to being used both in month periods and ready periods.  USAGE_DATE is a backward  looking time component.' 
comment on column GB_PFSA_DATE_DIM.USAGE_FROM_TIME 
is 'The minimum point in time considered to be part of the usage date.' 
comment on column GB_PFSA_DATE_DIM.USAGE_TO_TIME 
is 'The maximum point in time considered to be part of the usage date.' 	
comment on column GB_PFSA_DATE_DIM.USAGE_DAYS_IN_PERIOD 
is 'This field represents the number of days in the usage period.  Used in averaging monthly reported data into synchronized time frames corresponding to month dates.' 	
comment on column GB_PFSA_DATE_DIM.ACTIVE_FLAG 
is 'Flag indicating if the record is active or not.'
comment on column GB_PFSA_DATE_DIM.ACTIVE_DATE 
is 'Addition control for active_Fl indicating when the record became active.'
comment on column GB_PFSA_DATE_DIM.INACTIVE_DATE 
is 'Addition control for active_Fl indicating when the record went inactive.'
comment on column GB_PFSA_DATE_DIM.INSERT_BY 
is ''
comment on column GB_PFSA_DATE_DIM.INSERT_DATE 
is ''
comment on column GB_PFSA_DATE_DIM.UPDATE_BY 
is ''
comment on column GB_PFSA_DATE_DIM.UPDATE_DATE 
is ''
comment on column GB_PFSA_DATE_DIM.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'
comment on column GB_PFSA_DATE_DIM.DELETE_DATE 
is 'Addition control for delete_Fl indicating when the record was marked for deletion.'
comment on column GB_PFSA_DATE_DIM.HIDDEN_FLAG 
is ''
comment on column GB_PFSA_DATE_DIM.HIDDEN_DATE 
is ''
SELECT	TABLE_NAME, COMMENTS 
FROM	USER_TAB_COMMENTS 
WHERE	Table_Name = UPPER('GB_PFSA_DATE_DIM') 
SELECT	b.COLUMN_ID, 
		a.TABLE_NAME, 
		a.COLUMN_NAME, 
		b.DATA_TYPE, 
		b.DATA_LENGTH, 
		b.NULLABLE, 
		a.COMMENTS 
FROM	USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('GB_PFSA_DATE_DIM') 
	AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE	a.TABLE_NAME = UPPER('GB_PFSA_DATE_DIM') 
ORDER BY b.COLUMN_ID 

---------------------------------------
------- PFSA_DATE_DIM           ------- 
---------------------------------------

DECLARE 

-- standard variables 
	
	v_ErrorCode						VARCHAR2(6)		:= NULL;
	ps_location						VARCHAR2(10)	:= 'BEGIN';
	ps_procedure_name				VARCHAR2(30)	:= 'PFSA_DATE_DIM';
	v_ErrorText						VARCHAR2(200)	:= '';
	ps_id_key						VARCHAR2(200)	:= NULL;

-- proces specific variables 

	v_date_id						NUMBER; 
	v_oracle_date					DATE; 
	v_day_of_week					VARCHAR2(20); 
	v_DAY_NUM_IN_MONTH				INTEGER;		
	v_DAY_NUM_OVERALL				INTEGER;	
	v_WEEK_NUMBER_IN_YEAR			INTEGER;	
	v_WEEK_NUMBER_OVERALL			INTEGER;	
	v_MONTH_NUMBER_IN_YEAR			INTEGER;		
	v_MONTH_NUMBER_OVERALL			INTEGER;		
	v_CALENDAR_QUARTER				INTEGER;		
	v_FISCAL_QUARTER				varchar2(10);	
	v_HOLIDAY_FLAG					varchar2(11);		
	v_WEEKDAY_FLAG					varchar2(7);	
	v_SEASON						varchar2(50);		
	v_EVENT							varchar2(50);		
--	
	v_FULL_DATE_DESCRIPTION			varchar2(30);
-- PFSA Dates 
	v_DAY_DATE						date;  
	v_DAY_THRU						date;  
	v_DAY_FROM_TIME					date; 
	v_DAY_TO_TIME					date; 
	v_MONTH_DATE					date; 
	v_MONTH_FROM_TIME				date; 
	v_MONTH_TO_TIME					date;  
	v_READY_DATE					date; 
	v_READY_FROM_TIME				date; 
	v_READY_TO_TIME					date; 
	v_USAGE_DATE					date; 
	v_USAGE_FROM_TIME				date; 
	v_USAGE_TO_TIME 				date; 		
	v_USAGE_DAYS_IN_PERIOD			number(2);		
--	
	v_DAY_NUMBER_IN_EPOCH			number;
	v_WEEK_NUMBER_IN_EPOCH			number;
	v_MONTH_NUMBER_IN_EPOCH			number;
--
	v_DAY_NUMBER_IN_CALENDAR_YEAR	number(3);
	v_DAY_NUMBER_IN_FISCAL_MONTH	number(2); 
	v_DAY_NUMBER_IN_FISCAL_YEAR		number(3);
--
	v_LAST_DAY_IN_WEEK_INDICATOR	varchar2(20);
	v_LAST_DAY_IN_MONTH_INDICATOR	varchar2(20);
--
	v_CALENDAR_WEEK_ENDING_DATE		varchar2(20);	
	v_CALENDAR_MONTH_NAME			varchar2(20);
	v_CALENDAR_YEAR_MONTH_YYYYMM	varchar2(7);
	v_CALENDAR_YEAR_QUARTER_YYYYQQ	varchar2(7);
	v_CALENDAR_HALFYEAR				varchar2(20);
	v_CALENDAR_YEAR					number(4);
--
	v_FISCAL_WEEK_ENDING_DATE		varchar2(20);
	v_FISCAL_WEEK_NUMBER_IN_YEAR	number(2);
	v_FISCAL_MONTH_NAME				varchar2(20);
	v_FISCAL_MONTH_IN_YEAR			number(2);
	v_FISCAL_YEAR_MONTH_YYYYMM		varchar2(7);
	v_FISCAL_YEAR_QUARTER_YYYYQQ	varchar2(7);
	v_FISCAL_HALF_YEAR				varchar2(7);
	v_FISCAL_YEAR					varchar2(5);
--
	v_STATUS						varchar(1);
	v_UPDT_BY						varchar2(30);
	v_LST_UPDT						date;
--
	v_ACTIVE_FLAG					varchar2(1); 
	v_ACTIVE_DATE					date; 
	v_INACTIVE_DATE					date;
--
	v_INSERT_BY						varchar2(20); 
	v_INSERT_DATE					date; 
	v_UPDATE_BY						varchar2(20);
	v_UPDATE_DATE					date;
	v_DELETE_FLAG					varchar2(1);
	v_DELETE_DATE					date;
	v_HIDDEN_FLAG					varchar2(1);
	v_HIDDEN_DATE					date;
 	
	r_date_dim		pfsawh.gb_pfsa_date_dim%ROWTYPE; 
	
	CURSOR date_dim_cur IS
		SELECT	* --date_id, ORACLE_DATE,	DAY_OF_WEEK lin  
		FROM	pfsawh.gb_pfsa_date_dim
		ORDER BY  ORACLE_DATE; 
BEGIN 
	DBMS_OUTPUT.ENABLE(1000000);
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.NEW_LINE;
	
	
	DELETE	GB_PFSA_DATE_DIM;
	
	DBMS_OUTPUT.PUT_LINE	('*** PFSA_DATE_DIM ***');
	DBMS_OUTPUT.PUT_LINE	('* Insert test *'); 
	DBMS_OUTPUT.NEW_LINE;
	INSERT 
	INTO	GB_PFSA_DATE_DIM 
	(
	DATE_ID, ORACLE_DATE, DAY_OF_WEEK, DAY_NUM_IN_MONTH, DAY_NUM_OVERALL, WEEK_NUMBER_IN_YEAR, WEEK_NUMBER_OVERALL,	
	MONTH_NUMBER_IN_YEAR, MONTH_NUMBER_OVERALL, CALENDAR_QUARTER, FISCAL_QUARTER, HOLIDAY_FLAG, WEEKDAY_FLAG, SEASON, EVENT,	
--	
	FULL_DATE_DESCRIPTION,
-- PFSA Dates 
	DAY_DATE, DAY_THRU, DAY_FROM_TIME, DAY_TO_TIME, MONTH_DATE, MONTH_FROM_TIME, MONTH_TO_TIME, READY_DATE, 
	READY_FROM_TIME, READY_TO_TIME, USAGE_DATE, USAGE_FROM_TIME, USAGE_TO_TIME, USAGE_DAYS_IN_PERIOD, 
--	
	DAY_NUMBER_IN_EPOCH, WEEK_NUMBER_IN_EPOCH, MONTH_NUMBER_IN_EPOCH,
--
	DAY_NUMBER_IN_CALENDAR_YEAR, DAY_NUMBER_IN_FISCAL_MONTH, DAY_NUMBER_IN_FISCAL_YEAR,
--
	LAST_DAY_IN_WEEK_INDICATOR, LAST_DAY_IN_MONTH_INDICATOR,
--
	CALENDAR_WEEK_ENDING_DATE, CALENDAR_MONTH_NAME, CALENDAR_YEAR_MONTH_YYYYMM, 
	CALENDAR_YEAR_QUARTER_YYYYQQ, CALENDAR_HALFYEAR, CALENDAR_YEAR,
--
	FISCAL_WEEK_ENDING_DATE, FISCAL_WEEK_NUMBER_IN_YEAR, FISCAL_MONTH_NAME, FISCAL_MONTH_IN_YEAR,
	FISCAL_YEAR_MONTH_YYYYMM, FISCAL_YEAR_QUARTER_YYYYQQ, FISCAL_HALF_YEAR, FISCAL_YEAR,
--
	STATUS, UPDT_BY, LST_UPDT,
--
--	ACTIVE_FLAG, ACTIVE_DATE, INACTIVE_DATE,
--
	INSERT_BY, INSERT_DATE, UPDATE_BY, UPDATE_DATE, DELETE_FLAG, DELETE_DATE, HIDDEN_FLAG, HIDDEN_DATE
	)
VALUES	
	(
	1, '15-NOV-2007', 'THURSDAY', 15, 325, 43, 143, 
	11, 121, 3, 1, 'NON-HOLIDAY', 'WEEKDAY', 'FALL', 'NON-EVENT', 'Thursday, November 15th, 2007',
--  PFSA Dates 	
	'01-JAN-2000', '02-JAN-2000', '03-JAN-2000', '04-JAN-2000', '05-JAN-2000', '06-JAN-2000', '07-JAN-2000', 
	'08-JAN-2000', '09-JAN-2000', '10-JAN-2000', '11-JAN-2000', '12-JAN-2000', '13-JAN-2000', 0,		
--	
	0, 0, 0,
--
	1, 2, 3,
--
	0, 0,
--
	'WW', 'MARCH', 'YYYYMM', 'YYYYQ', '2', 2008, 
--
	'n', 0, 'nov', 1, 'yyyymm', '3', '2', '2007',
--
	'x', user, sysdate,
--
--	'y', '14-NOV-2006', '17-NOV-2008',
--
	user, sysdate, NULL, NULL, NULL, NULL, NULL, NULL  
	);
	INSERT 
	INTO	GB_PFSA_DATE_DIM 
	(
	DATE_ID, ORACLE_DATE, DAY_OF_WEEK, DAY_NUM_IN_MONTH, DAY_NUM_OVERALL, WEEK_NUMBER_IN_YEAR, WEEK_NUMBER_OVERALL,	
	MONTH_NUMBER_IN_YEAR, MONTH_NUMBER_OVERALL, CALENDAR_QUARTER, FISCAL_QUARTER, HOLIDAY_FLAG, WEEKDAY_FLAG, SEASON, EVENT,	
--	
	FULL_DATE_DESCRIPTION,
-- PFSA Dates 
	DAY_DATE, DAY_THRU, DAY_FROM_TIME, DAY_TO_TIME, MONTH_DATE, MONTH_FROM_TIME, MONTH_TO_TIME, READY_DATE, 
	READY_FROM_TIME, READY_TO_TIME, USAGE_DATE, USAGE_FROM_TIME, USAGE_TO_TIME, USAGE_DAYS_IN_PERIOD, 
--	
	DAY_NUMBER_IN_EPOCH, WEEK_NUMBER_IN_EPOCH, MONTH_NUMBER_IN_EPOCH,
--
	DAY_NUMBER_IN_CALENDAR_YEAR, DAY_NUMBER_IN_FISCAL_MONTH, DAY_NUMBER_IN_FISCAL_YEAR,
--
	LAST_DAY_IN_WEEK_INDICATOR, LAST_DAY_IN_MONTH_INDICATOR,
--
	CALENDAR_WEEK_ENDING_DATE, CALENDAR_MONTH_NAME, CALENDAR_YEAR_MONTH_YYYYMM, 
	CALENDAR_YEAR_QUARTER_YYYYQQ, CALENDAR_HALFYEAR, CALENDAR_YEAR,
--
	FISCAL_WEEK_ENDING_DATE, FISCAL_WEEK_NUMBER_IN_YEAR, FISCAL_MONTH_NAME, FISCAL_MONTH_IN_YEAR,
	FISCAL_YEAR_MONTH_YYYYMM, FISCAL_YEAR_QUARTER_YYYYQQ, FISCAL_HALF_YEAR, FISCAL_YEAR,
--
	STATUS, UPDT_BY, LST_UPDT,
--
--	ACTIVE_FLAG, ACTIVE_DATE, INACTIVE_DATE,
--
	INSERT_BY, INSERT_DATE, UPDATE_BY, UPDATE_DATE, DELETE_FLAG, DELETE_DATE, HIDDEN_FLAG, HIDDEN_DATE
	)
VALUES	
	(
	2, '15-NOV-2007', 'THURSDAY', 15, 325, 43, 143, 
	11, 121, 3, 1, 'NON-HOLIDAY', 'WEEKDAY', 'FALL', 'NON-EVENT', 'Thursday, November 15th, 2007',
--  PFSA Dates 	
	'01-JAN-2000', '02-JAN-2000', '03-JAN-2000', '04-JAN-2000', '05-JAN-2000', '06-JAN-2000', '07-JAN-2000', 
	'08-JAN-2000', '09-JAN-2000', '10-JAN-2000', '11-JAN-2000', '12-JAN-2000', '13-JAN-2000', 0,		
--	
	0, 0, 0,
--
	1, 2, 3,
--
	0, 0,
--
	'WW', 'MARCH', 'YYYYMM', 'YYYYQ', '2', 2008, 
--
	'n', 0, 'nov', 1, 'yyyymm', '3', '2', '2007',
--
	'x', user, sysdate,
--
--	'y', '14-NOV-2006', '17-NOV-2008',
--
	user, sysdate, NULL, NULL, NULL, NULL, NULL, NULL  
	);
	
	DBMS_OUTPUT.NEW_LINE;
	
	OPEN date_dim_cur;
	
	LOOP
		FETCH	date_dim_cur 
		INTO	v_date_id, v_oracle_date, v_day_of_week, v_DAY_NUM_IN_MONTH, v_DAY_NUM_OVERALL, v_WEEK_NUMBER_IN_YEAR, 
				v_WEEK_NUMBER_OVERALL, v_MONTH_NUMBER_IN_YEAR, v_MONTH_NUMBER_OVERALL, v_CALENDAR_QUARTER, v_FISCAL_QUARTER, 
				v_HOLIDAY_FLAG, v_WEEKDAY_FLAG, v_SEASON, v_EVENT, 		
--	
				v_FULL_DATE_DESCRIPTION, 
-- PFSA Dates 
				v_DAY_DATE, v_DAY_THRU, v_DAY_FROM_TIME, v_DAY_TO_TIME, v_MONTH_DATE, v_MONTH_FROM_TIME, v_MONTH_TO_TIME, 
				v_READY_DATE, v_READY_FROM_TIME, v_READY_TO_TIME, v_USAGE_DATE, v_USAGE_FROM_TIME, v_USAGE_TO_TIME, v_USAGE_DAYS_IN_PERIOD, 		
--	
				v_DAY_NUMBER_IN_EPOCH, v_WEEK_NUMBER_IN_EPOCH, v_MONTH_NUMBER_IN_EPOCH, 
--
				v_DAY_NUMBER_IN_CALENDAR_YEAR, v_DAY_NUMBER_IN_FISCAL_MONTH, v_DAY_NUMBER_IN_FISCAL_YEAR, 
--
				v_LAST_DAY_IN_WEEK_INDICATOR, v_LAST_DAY_IN_MONTH_INDICATOR, v_CALENDAR_WEEK_ENDING_DATE, v_CALENDAR_MONTH_NAME, 
				v_CALENDAR_YEAR_MONTH_YYYYMM, v_CALENDAR_YEAR_QUARTER_YYYYQQ, v_CALENDAR_HALFYEAR, v_CALENDAR_YEAR, 
--
				v_FISCAL_WEEK_ENDING_DATE, v_FISCAL_WEEK_NUMBER_IN_YEAR, v_FISCAL_MONTH_NAME, v_FISCAL_MONTH_IN_YEAR, 
				v_FISCAL_YEAR_MONTH_YYYYMM, v_FISCAL_YEAR_QUARTER_YYYYQQ, v_FISCAL_HALF_YEAR, v_FISCAL_YEAR, 
--
				v_STATUS, v_UPDT_BY, v_LST_UPDT, 
--
				v_ACTIVE_FLAG, v_ACTIVE_DATE, v_INACTIVE_DATE, 
--
				v_INSERT_BY, v_INSERT_DATE, v_UPDATE_BY, v_UPDATE_DATE, v_DELETE_FLAG, v_DELETE_DATE, v_HIDDEN_FLAG, v_HIDDEN_DATE;
		
		EXIT WHEN date_dim_cur%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(v_date_id || ' ' || v_oracle_date || ' ' || v_day_of_week);
		
		DBMS_OUTPUT.PUT_LINE('default values'); 
		DBMS_OUTPUT.PUT_LINE(v_date_id || ' ' || v_active_flag || ' ' || TO_CHAR(v_active_date, 'DD-MON-YYYY') || ' ' || TO_CHAR(v_inactive_date, 'DD-MON-YYYY'));
		DBMS_OUTPUT.PUT_LINE(v_date_id || ' ' || v_insert_by || ' ' || TO_CHAR(v_insert_date, 'DD-MON-YYYY'));
		
	END LOOP;
	
	CLOSE date_dim_cur;

EXCEPTION 
	WHEN OTHERS THEN 
		v_ErrorCode		:= sqlcode;
		ps_id_key		:= sysdate; 
		v_ErrorText		:= SUBSTR(SQLERRM, 1, 200);
		
		INSERT 
		INTO	std_pfsa_debug_tbl 
			(
			ps_procedure, ps_oerr, ps_location, called_by, ps_id_key, ps_msg, msg_dt
			)
		VALUES
			(
			ps_procedure_name, v_ErrorCode, ps_location, user, ps_id_key, v_ErrorText, sysdate 
			);
	
END;

SELECT	* 
FROM	std_pfsa_debug_tbl 
ORDER BY msg_dt DESC;

/*
INSERT 
INTO	PFSA_DIM_xxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 1')
--- Default Review ---
PRINT	'* Default Review *' 
SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	PFSA_DIM_xxx 
WHERE	CatCd < 0 
----- PRIMARY KEY constraint -----
PRINT	'* PRIMARY KEY constraint *' 
INSERT 
INTO	PFSA_DIM_xxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 2') 
----- FOREIGN KEY constraint ----- 
PRINT	'* FOREIGN KEY constraint *' 
INSERT 
INTO	PFSA_DIM_xxx (catCd, itmCd, itmTxt) 
VALUES	(-200, -100, 'Unit test case 4') 
--- Trigger Review --- 
PRINT	'* Trigger Review *' 
UPDATE	PFSA_DIM_xxx 
SET		itmTxt = 'Unit test case 3' 
WHERE	catCd = -100 
	AND	itmCd = -100 
SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	PFSA_DIM_xxx 
WHERE	CatCd < 0 
----- NOT NULL constraint ----- 
PRINT	'* NOT NULL constraint *' 
INSERT 
INTO	PFSA_DIM_xxx (catCd) 
VALUES	(NULL)
INSERT 
INTO	PFSA_DIM_xxx (itmCd) 
VALUES	(NULL) 
-----Cleanup ----- 
PRINT	'* Cleanup *' 
DELETE	PFSA_DIM_xxx WHERE CatCd < 0
DELETE	PFSA_DIM_xxx_yyy WHERE CatCd < 0
*/

			
