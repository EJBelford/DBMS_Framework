/*
SELECT	* 
FROM	POTENTIAL_PFSA_ITEM@pfsawh.lidbdev
WHERE	LIN is not null 
ORDER BY  LIN, ITEM_NIIN 
*/

DECLARE
	v_lin			VARCHAR2(6);
	v_item_niin		VARCHAR2(9);
	v_item_nomen	VARCHAR2(35);
	v_eic			VARCHAR2(3);

	v_cmn_int		NUMBER;
	v_cyr_int		NUMBER;
	v_fmn_int		NUMBER;
	v_fyr_int		NUMBER;
	v_julian_date	NUMBER;
	v_loopCount		NUMBER;
	
BEGIN
	DBMS_OUTPUT.ENABLE(1000000);
	
	v_loopCount := sysdate - TO_DATE('01-JAN-2000');
	
	FOR loopCnt IN 1..v_loopCount
	LOOP 
		v_julian_date := loopCnt + 2451544;

		v_cmn_int := TO_CHAR(TO_DATE(v_julian_date, 'J'), 'MM');
		v_cyr_int := TO_CHAR(TO_DATE(v_julian_date, 'J'), 'YYYY');

		IF v_cmn_int < 10 THEN
			v_fmn_int := TO_CHAR(TO_DATE(v_julian_date, 'J'), 'MM') + 3;
			v_fyr_int := TO_CHAR(TO_DATE(v_julian_date, 'J'), 'YYYY');
		ELSE
			v_fmn_int := TO_CHAR(TO_DATE(v_julian_date, 'J'), 'MM') - 9;
			v_fyr_int := TO_CHAR(TO_DATE(v_julian_date, 'J'), 'YYYY') + 1;
		END IF;
		
		INSERT 
		INTO	GB_PFSA_DIM_DATE 
		(
		DATE_ID, 
		ORACLE_DATE, 
		DAY_OF_WEEK,
		DAY_NUM_IN_MONTH,				-- DAY_NUM_IN_CALENDAR_MONTH,
--		
		FULL_DATE_DESC, 
-- PFSA Dates 
		DAY_DATE,
		DAY_THRU,
		DAY_FROM_TIME,
		DAY_TO_TIME, 
		MONTH_DATE, 
		MONTH_FROM_TIME, 
		MONTH_TO_TIME,  
		READY_DATE, 
		READY_FROM_TIME, 
		READY_TO_TIME, 
		USAGE_DATE, 
		USAGE_FROM_TIME, 
		USAGE_TO_TIME, 		
		USAGE_DAYS_IN_PERIOD,		
--	
		DAY_NUM_IN_EPOCH,
		WEEK_NUM_IN_EPOCH,
		MONTH_NUM_IN_EPOCH,
--
		DAY_NUM_IN_CALENDAR_YEAR,
		DAY_NUM_IN_FISCAL_MONTH,
		DAY_NUM_IN_FISCAL_YEAR,
--
		LAST_DAY_IN_WEEK_INDICATOR,
		LAST_DAY_IN_MONTH_INDICATOR,
--
		CALENDAR_WEEK_ENDING_DATE,
		CALENDAR_WEEK_NUMBER_IN_YEAR,
		CALENDAR_MONTH_NAME,
		CALENDAR_MONTH_NUMBER_IN_YEAR,
		CALENDAR_YEAR_MONTH_YYYYMM,
		CALENDAR_QUARTER,
		CALENDAR_YEAR_QUARTER_YYYYQQ,
		CALENDAR_HALFYEAR,
		CALENDAR_YEAR,
--
		FISCAL_WEEK,
		FISCAL_WEEK_NUMBER_IN_YEAR,
		FISCAL_MONTH,
		FISCAL_MONTH_IN_YEAR,
		FISCAL_YEAR_MONTH_YYYYMM,
		FISCAL_QUARTER,
		FISCAL_YEAR_QUARTER_YYYYQQ,
		FISCAL_HALF_YEAR,
		FISCAL_YEAR,
--
	HOLIDAY_INDICATOR,
	WEEKDAY_INDICATOR,
	SELLING_SEASON,
	MAJOR_EVENT,
--
	STATUS,
	UPDT_BY,
	LST_UPDT,
--
	INSERT_BY, 
	INSERT_DT, 
	UPDATE_BY,
	UPDATE_DT,
	DELETE_FL,
	DELETE_DT,
	HIDDEN_FL,
	HIDDEN_DT
	)
VALUES	
	(
	loopCnt,
	TO_DATE(v_julian_date, 'J'),						-- DATE_CALENDAR
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'DL'),			-- FULL_DATE_DESC 
	RTRIM(TO_CHAR(TO_DATE(v_julian_date, 'J'), 'DAY')),	-- DAY_OF_WEEK 
--  PFSA Dates 	
	TO_DATE(v_julian_date, 'J'),						-- DAY_DATE
	ADD_MONTHS(TO_DATE(v_julian_date, 'J'), 1),			-- DAY_THRU 
	'01-JAN-2000',										-- DAY_FROM_TIME
	'01-JAN-2000', 
	'01-JAN-2000', 
	'01-JAN-2000', 
	'01-JAN-2000',  
	'01-JAN-2000', 
	'01-JAN-2000', 
	'01-JAN-2000', 
	'01-JAN-2000', 
	'01-JAN-2000', 
	'01-JAN-2000', 		
	0,		
--	
	0,
	0,
	0,
--
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'DD'),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'DDD'),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'DD'),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'DDD'),
--
	0,
	0,
--
	'x',
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'WW'),
	RTRIM(TO_CHAR(TO_DATE(v_julian_date, 'J'), 'MONTH')),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'MM'),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'YYYYMM'),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'Q'),
	TO_CHAR(TO_DATE(v_julian_date, 'J'), 'YYYYQ'),
	CASE TO_CHAR(TO_DATE(v_julian_date, 'J'), 'Q') 
		WHEN '1' THEN '1'
		WHEN '2' THEN '1'
		WHEN '3' THEN '2'
		WHEN '4' THEN '2'
	END,
	v_cyr_int,
--
	0,
	0,
	0,
	v_fmn_int,
	CASE TO_CHAR(TO_DATE(v_julian_date, 'J'), 'MM') 
		WHEN '1'  THEN v_fyr_int || '04'
		WHEN '2'  THEN v_fyr_int || '05'
		WHEN '3'  THEN v_fyr_int || '06'
		WHEN '4'  THEN v_fyr_int || '07'
		WHEN '5'  THEN v_fyr_int || '08'
		WHEN '6'  THEN v_fyr_int || '09'
		WHEN '7'  THEN v_fyr_int || '10'
		WHEN '8'  THEN v_fyr_int || '11'
		WHEN '9'  THEN v_fyr_int || '12'
		WHEN '10' THEN v_fyr_int || '01'
		WHEN '11' THEN v_fyr_int || '02'
		WHEN '12' THEN v_fyr_int || '03'
		ELSE 'yyyymm'
	END,
	CASE TO_CHAR(TO_DATE(v_julian_date, 'J'), 'Q') 
		WHEN '1' THEN '2'
		WHEN '2' THEN '3'
		WHEN '3' THEN '4'
		WHEN '4' THEN '1'
	END,
	CASE TO_CHAR(TO_DATE(v_julian_date, 'J'), 'Q') 
		WHEN '1' THEN v_fyr_int || '2'
		WHEN '2' THEN v_fyr_int || '3'
		WHEN '3' THEN v_fyr_int || '4'
		WHEN '4' THEN v_fyr_int || '1'
	END,
	CASE TO_CHAR(TO_DATE(v_julian_date, 'J'), 'Q') 
		WHEN '1' THEN '1'
		WHEN '2' THEN '2'
		WHEN '3' THEN '2'
		WHEN '4' THEN '1'
	END,
	v_fyr_int,
--
	'NOT APPLICABLE',
	'NOT APPLICABLE',
	'NOT APPLICABLE',
	'NOT APPLICABLE', 
--
	'x',
	user,
	sysdate,
--
	user , 
	sysdate , 
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL 
	);
	
	END LOOP;
	
	DBMS_OUTPUT.NEW_LINE;
	
	OPEN pot_item_cur;
	
	LOOP
		FETCH pot_item_cur 
		INTO	v_lin, v_item_niin, v_item_nomen, v_eic;
		
		EXIT WHEN pot_item_cur%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(v_lin || ' ' || v_item_niin || ' ' || v_item_nomen || ' ' || v_eic);
		
	END LOOP;
	
	CLOSE pot_item_cur;
END; 

/*
SELECT	* 
FROM	PFSA_SYSTEM_DIM

SELECT	
DISTINCT	LIN, SYS_EI_NOMEN 
FROM	PFSA_SYSTEM_DIM
ORDER BY LIN

SELECT	* 
FROM	PFSA_SYSTEM_DIM
WHERE	LIN IN ('H30517')

*/
/*
SELECT	* 
FROM	GB_PFSA_DIM_DATE 
*/
/*
DELETE	GB_PFSA_DIM_DATE
*/
