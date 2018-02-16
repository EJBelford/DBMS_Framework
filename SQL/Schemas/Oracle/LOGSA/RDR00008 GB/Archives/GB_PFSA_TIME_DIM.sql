SELECT * FROM dba_tables WHERE table_name = UPPER('GB_PFSA_TIME_DIM') 
	AND OWNER = 'PFSAWH';
	
--IF EXISTS (SELECT * FROM dba_tables WHERE table_name = 'GB_PFSA_TIME_DIM') 
	DROP TABLE GB_PFSA_TIME_DIM;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--         NAME: GB_PFSA_TIME_DIM
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: GB_PFSA_TIME_DIM.sql
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
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--
CREATE TABLE pfsawh.GB_PFSA_TIME_DIM 
(
	TIME_ID										NUMBER(5)			not null ,
	TIME_SECONDS_SINCE_MIDNIGHT					NUMBER(5)			not null ,
	TIME_DESC_12HOUR							VARCHAR2(11)			not null ,
	TIME_DESC_24HOUR							VARCHAR2(8)			not null ,
--
	TIME_AM_PM_CODE								VARCHAR2(2)			not null , 
--
	STATUS										varchar2(1)			DEFAULT	'N' ,
	UPDT_BY										varchar2(30)		DEFAULT	user ,
	LST_UPDT									date				DEFAULT	sysdate ,
--
	ACTIVE_FLAG									varchar2(1)			DEFAULT	'I' , 
	ACTIVE_DATE									date				DEFAULT	'01-JAN-1900' , 
	INACTIVE_DATE								date				DEFAULT	'31-DEC-2099' ,
--
	INSERT_BY									varchar2(20)		DEFAULT	user , 
	INSERT_DATE									date				DEFAULT	sysdate , 
	UPDATE_BY									varchar2(20)		DEFAULT	user ,
	UPDATE_DATE									date				DEFAULT	'01-JAN-1900' ,
	DELETE_FLAG									varchar2(1)			DEFAULT	'N' ,
	DELETE_DATE									date				DEFAULT	'01-JAN-1900' ,
	HIDDEN_FLAG									varchar2(1)			DEFAULT	'N' ,
	HIDDEN_DATE									date				DEFAULT	'01-JAN-1900' ,
constraint PK_PFSA_TIME_DIM primary key 
	(
	TIME_ID
	)	
) 
logging 
nocompress 
nocache
noparallel
monitoring;

/*----- Indexs -----*/

DROP INDEX IXU_PFSA_TIME_DIM;

CREATE UNIQUE INDEX IXU_PFSA_TIME_DIM 
	ON pfsawh.GB_PFSA_TIME_DIM(TIME_DESC_24HOUR);

/*----- Constraints -----*/

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  DROP CONSTRAINT CK_TIME_DIM_ACT_FLAG		

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  ADD CONSTRAINT CK_TIME_DIM_ACT_FLAG 
	CHECK (ACTIVE_FLAG='I' OR ACTIVE_FLAG='N' OR ACTIVE_FLAG='Y');

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  DROP CONSTRAINT CK_TIME_DIM_AM_PM_CODE		

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  ADD CONSTRAINT CK_TIME_DIM_AM_PM_CODE 
	CHECK (TIME_AM_PM_CODE='AM' OR TIME_AM_PM_CODE='PM');

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  DROP CONSTRAINT CK_TIME_DIM_HIDE_FLAG		

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  ADD CONSTRAINT CK_TIME_DIM_HIDE_FLAG 
	CHECK (HIDDEN_FLAG='N' OR HIDDEN_FLAG='Y');

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  DROP CONSTRAINT CK_PFSA_TIME_DIM_STATUS		

ALTER TABLE pfsawh.GB_PFSA_TIME_DIM  ADD CONSTRAINT CK_PFSA_TIME_DIM_STATUS 
	CHECK (STATUS='C' OR STATUS='D' OR STATUS='E' OR STATUS='H' 
		OR STATUS='L' OR STATUS='P' OR STATUS='Q' OR STATUS='R'
		OR STATUS='Z' OR STATUS='N'
		);

/*----- Table Meta-Data -----*/ 
comment on table pfsawh.GB_PFSA_TIME_DIM 
is 'n/a'; 

comment on column pfsawh.GB_PFSA_TIME_DIM.TIME_ID 
is 'n/a' 


comment on column pfsawh.GB_PFSA_TIME_DIM.STATUS 
is 'The status of the record in question.'

comment on column pfsawh.GB_PFSA_TIME_DIM.UPDT_BY 
is 'The date/timestamp of when the record was created/updated.'

comment on column pfsawh.GB_PFSA_TIME_DIM.LST_UPDT 
is 'Indicates either the program name or user ID of the person who updated the record.'


comment on column pfsawh.GB_PFSA_TIME_DIM.ACTIVE_FLAG 
is 'Flag indicating if the record is active or not.'

comment on column pfsawh.GB_PFSA_TIME_DIM.ACTIVE_DATE 
is 'Addition control for active_Fl indicating when the record became active.'

comment on column pfsawh.GB_PFSA_TIME_DIM.INACTIVE_DATE 
is 'Addition control for active_Fl indicating when the record went inactive.'

comment on column pfsawh.GB_PFSA_TIME_DIM.INSERT_BY 
is 'Reports who initially created the record.'

comment on column pfsawh.GB_PFSA_TIME_DIM.INSERT_DATE 
is 'Reports when the record was initially created.'

comment on column pfsawh.GB_PFSA_TIME_DIM.UPDATE_BY 
is 'Reports who last updated the record.'

comment on column pfsawh.GB_PFSA_TIME_DIM.UPDATE_DATE 
is 'Reports when the record was last updated.'

comment on column pfsawh.GB_PFSA_TIME_DIM.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'

comment on column pfsawh.GB_PFSA_TIME_DIM.DELETE_DATE 
is 'Addition control for DELETE_FLAG indicating when the record was marked for deletion.'

comment on column pfsawh.GB_PFSA_TIME_DIM.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'

comment on column pfsawh.GB_PFSA_TIME_DIM.HIDDEN_DATE 
is 'Addition control for HIDDEN_FLAG indicating when the record was hidden.'

SELECT	TABLE_NAME, COMMENTS 
FROM	USER_TAB_COMMENTS 
WHERE	Table_Name = UPPER('GB_PFSA_TIME_DIM') 

SELECT	b.COLUMN_ID, 
		a.TABLE_NAME, 
		a.COLUMN_NAME, 
		b.DATA_TYPE, 
		b.DATA_LENGTH, 
		b.NULLABLE, 
		a.COMMENTS 
FROM	USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('pfsawh.GB_PFSA_TIME_DIM') 
	AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE	a.TABLE_NAME = UPPER('GB_PFSA_TIME_DIM') 
ORDER BY b.COLUMN_ID 

/*----- Populate -----*/

DECLARE
	v_row_cnt	NUMBER(4);

BEGIN

	FOR loop_cnt IN 1..86400
	LOOP 
		INSERT 
		INTO	GB_PFSA_TIME_DIM
			(
			TIME_ID , 
			TIME_SECONDS_SINCE_MIDNIGHT ,
			TIME_DESC_12HOUR ,
			TIME_DESC_24HOUR ,
--
			TIME_AM_PM_CODE , 
--
			STATUS ,
			UPDT_BY ,
-- 
			ACTIVE_FLAG 
			)
		VALUES
			(
			loop_cnt ,
			loop_cnt - 1 ,
			SUBSTR(RTRIM(NUMTODSINTERVAL(loop_cnt - 1, 'SECOND')), 12, 8) ,
			SUBSTR(RTRIM(NUMTODSINTERVAL(loop_cnt - 1, 'SECOND')), 12, 8) ,
			'AM' , 
			'C' ,
			'GBelford' ,
			'Y'
			);
	END LOOP;

	UPDATE  GB_PFSA_TIME_DIM
	SET		TIME_DESC_12HOUR = '12' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' AM' 
	WHERE	TIME_ID <= 3600;
	 
/*		WHEN TIME_ID BETWEEN  3601 AND 43200 THEN TIME_DESC_12HOUR || ' AM' 
		WHEN TIME_ID BETWEEN 43201 AND 46800 THEN '12' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 46801 AND 50400 THEN '01' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 50401 AND 54000 THEN '02' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 54001 AND 58600 THEN '03' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 58601 AND 61200 THEN '04' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 61201 AND 64800 THEN '05' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 64801 AND 68400 THEN '06' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 68401 AND 72000 THEN '07' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 72001 AND 75600 THEN '08' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 75601 AND 79200 THEN '09' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		WHEN TIME_ID BETWEEN 79201 AND 82800 THEN '10' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		ELSE '11' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
		END
		FROM GB_PFSA_TIME_DIM;*/

END;

/*

SELECT * FROM GB_PFSA_TIME_DIM ORDER BY TIME_ID;

DELETE GB_PFSA_TIME_DIM; 

SELECT SUBSTR(RTRIM(NUMTODSINTERVAL(TIME_ID, 'SECOND')), 12, 8) FROM GB_PFSA_TIME_DIM ORDER BY TIME_ID

SELECT RTRIM(NUMTODSINTERVAL(3660 - 1, 'SECOND')) FROM GB_PFSA_TIME_DIM

SELECT 
CASE 
	WHEN TIME_ID <= 3600 THEN '12' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' AM' 
	WHEN TIME_ID BETWEEN  3601 AND 43200 THEN TIME_DESC_12HOUR || ' AM' 
	WHEN TIME_ID BETWEEN 43201 AND 46800 THEN '12' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 46801 AND 50400 THEN '01' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 50401 AND 54000 THEN '02' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 54001 AND 58600 THEN '03' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 58601 AND 61200 THEN '04' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 61201 AND 64800 THEN '05' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 64801 AND 68400 THEN '06' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 68401 AND 72000 THEN '07' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 72001 AND 75600 THEN '08' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 75601 AND 79200 THEN '09' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	WHEN TIME_ID BETWEEN 79201 AND 82800 THEN '10' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
	ELSE '11' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
END
FROM GB_PFSA_TIME_DIM ORDER BY TIME_ID;

*/
	
	