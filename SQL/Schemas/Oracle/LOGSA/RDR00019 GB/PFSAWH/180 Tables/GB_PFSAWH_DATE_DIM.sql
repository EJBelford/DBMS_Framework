DROP TABLE gb_pfsawh_date_dim;
    
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: pfsawh_date_dim
--      PURPOSE: PFSA_DIM_Date - Contain a truncated date value representing an
--               individual day that LOGAS has used or expects to use. 
--
-- TABLE SOURCE: pfsawh_date_dim.sql
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
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 30OCT07 - GB  -          -      - Created 
-- 18JAN08 - GB  -          -      - Renamed and updated 
--                 from pfsa_date_dim
--
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--
CREATE TABLE PFSAWH.gb_pfsawh_date_dim
    (
    date_id                         INTEGER             NOT NULL ,      
    oracle_date                     DATE                NOT NULL ,       
    day_of_week                     VARCHAR2(20)        NOT NULL ,   
    day_num_in_month                INTEGER             NOT NULL ,  
    day_num_overall                 INTEGER             NOT NULL ,   
    week_number_in_year             INTEGER             NOT NULL ,  
    week_number_overall             INTEGER             NOT NULL ,  
    month_number_in_year            INTEGER             NOT NULL ,  
    month_number_overall            INTEGER             NOT NULL ,  
    calendar_quarter                INTEGER             NOT NULL , 
    fiscal_quarter                  VARCHAR2(10)        NOT NULL , 
    holiday_flag                    VARCHAR2(11)        NOT NULL , 
    weekday_flag                    VARCHAR2(11)        NOT NULL ,   
    season                          VARCHAR2(50)        NOT NULL ,        
    event                           VARCHAR2(50)        NOT NULL ,      
--    
    full_date_description           VARCHAR2(30)        NOT NULL ,
-- PFSA Dates 
--  day_date                        DATE                NOT NULL ,    --
--  day_thru                        DATE                NOT NULL ,  
    oracle_date_from_time           DATE                NOT NULL , 
    oracle_date_to_time             DATE                NOT NULL , 
--  month_date                      DATE                NOT NULL ,    -- 
--  month_from_time                 DATE                NOT NULL , 
--  month_to_time                   DATE                NOT NULL ,  
    ready_date                      DATE                NOT NULL ,    --  
--  ready_from_time                 DATE                NOT NULL , 
--  ready_to_time                   DATE                NOT NULL , 
    usage_date                      DATE                NOT NULL ,    --  
--  usage_from_time                 DATE                NOT NULL , 
--  usage_to_time                   DATE                NOT NULL ,         
    usage_days_in_period            NUMBER(2)           NOT NULL ,        
--    
    day_of_week_char1               VARCHAR2(1)         NOT NULL ,    
    day_of_week_char3               VARCHAR2(3)         NOT NULL ,    
    julian_date_yddd                VARCHAR2(4)         NOT NULL , 
    julian_date_yyddd               VARCHAR2(5)         NOT NULL , 
    julian_date_ccyyddd             VARCHAR2(7)         NOT NULL , 
--
    day_number_in_calendar_year     NUMBER(3)           NOT NULL ,
    day_number_in_fiscal_month      NUMBER(2)           NOT NULL , 
    day_number_in_fiscal_year       NUMBER(3)           NOT NULL ,
--
    first_day_in_week_indicator     VARCHAR2(1)         NOT NULL ,
    first_day_in_month_indicator    VARCHAR2(1)         NOT NULL ,
    last_day_in_week_indicator      VARCHAR2(1)         NOT NULL ,
    last_day_in_month_indicator     VARCHAR2(1)         NOT NULL ,
--
    calendar_week_ending_date       VARCHAR2(20)        NOT NULL ,    
    calendar_month_name             VARCHAR2(20)        NOT NULL ,
    calendar_month_name_char3       VARCHAR2(3)         NOT NULL ,
    calendar_year_month_yyyymm      VARCHAR2(7)         NOT NULL ,
    calendar_year_quarter_yyyyqq    VARCHAR2(7)         NOT NULL ,
    calendar_year                   NUMBER(4)           NOT NULL ,
--
    fiscal_week_ending_date         VARCHAR2(20)        NOT NULL ,
    fiscal_week_number_in_year      NUMBER(2)           NOT NULL ,
    fiscal_month_name               VARCHAR2(20)        NOT NULL ,
    fiscal_month_name_char3         VARCHAR2(3)         NOT NULL ,
    fiscal_month_in_year            NUMBER(2)           NOT NULL ,
    fiscal_year_month_yyyymm        VARCHAR2(7)         NOT NULL ,
    fiscal_year_quarter_yyyyqq      VARCHAR2(7)         NOT NULL ,
    fiscal_year                     VARCHAR2(5)         NOT NULL ,
--
    status                          VARCHAR(1)          NOT NULL ,
    updt_by                         VARCHAR2(30)        NULL ,
    lst_updt                        DATE                NULL ,
--
    active_flag                     VARCHAR2(1)         DEFAULT 'Y' , 
    active_date                     DATE                DEFAULT '01-JAN-1950' , 
    inactive_date                   DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                       VARCHAR2(20)        DEFAULT  USER , 
    insert_date                     DATE                DEFAULT  SYSDATE , 
    update_by                       VARCHAR2(20)        NULL ,
    update_date                     DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                     VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                     DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                     VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                     DATE                DEFAULT '01-JAN-1900' ,
 CONSTRAINT pk_date_dim PRIMARY KEY 
    (
    date_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsa_date_dim;

CREATE UNIQUE INDEX ixu_pfsa_date_dim 
    ON gb_pfsawh_date_dim(oracle_date);
    
/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_cal_mnth_full_nm;    
    
ALTER TABLE gb_pfsawh_date_dim 
    ADD CONSTRAINT ck_dim_dt_cal_mnth_full_nm 
    CHECK  (calendar_month_name='DECEMBER' OR calendar_month_name='NOVEMBER' 
        OR calendar_month_name='OCTOBER'   OR calendar_month_name='SEPTEMBER' 
        OR calendar_month_name='AUGUST'    OR calendar_month_name='JULY' 
        OR calendar_month_name='JUNE'      OR calendar_month_name='MAY' 
        OR calendar_month_name='APRIL'     OR calendar_month_name='MARCH' 
        OR calendar_month_name='FEBRUARY'  OR calendar_month_name='JANUARY' 
        OR calendar_month_name='NOT APPLICABLE');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_cal_mnth_chr3_nm;    
    
ALTER TABLE gb_pfsawh_date_dim 
    ADD CONSTRAINT ck_dim_dt_cal_mnth_chr3_nm 
    CHECK  (calendar_month_name_char3='DEC' OR calendar_month_name_char3='NOV' 
        OR calendar_month_name_char3='OCT'  OR calendar_month_name_char3='SEP' 
        OR calendar_month_name_char3='AUG'  OR calendar_month_name_char3='JUL' 
        OR calendar_month_name_char3='JUN'  OR calendar_month_name_char3='MAY' 
        OR calendar_month_name_char3='APR'  OR calendar_month_name_char3='MAR' 
        OR calendar_month_name_char3='FEB'  OR calendar_month_name_char3='JAN' 
        OR calendar_month_name_char3='N/A');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_dayofweek;   
    
ALTER TABLE gb_pfsawh_date_dim  
    ADD CONSTRAINT ck_dim_dt_dayofweek 
    CHECK (day_of_week='SATURDAY' OR day_of_week='FRIDAY' 
        OR day_of_week='THURSDAY' OR day_of_week='WEDNESDAY' 
        OR day_of_week='TUESDAY'  OR day_of_week='MONDAY' 
        OR day_of_week='SUNDAY'   OR day_of_week='NOT APPLICABLE');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_dayofwk_chr3;    
    
ALTER TABLE gb_pfsawh_date_dim  
    ADD CONSTRAINT ck_dim_dt_dayofwk_chr3 
    CHECK (day_of_week_char3='SAT' OR day_of_week_char3='FRI' 
        OR day_of_week_char3='THU' OR day_of_week_char3='WED' 
        OR day_of_week_char3='TUE' OR day_of_week_char3='MON' 
        OR day_of_week_char3='SUN' OR day_of_week_char3='N/A');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_dayofwk_chr1;    
    
ALTER TABLE gb_pfsawh_date_dim  
    ADD CONSTRAINT ck_dim_dt_dayofwk_chr1 
    CHECK (day_of_week_char1='S' OR day_of_week_char1='F' 
        OR day_of_week_char1='R' OR day_of_week_char1='W' 
        OR day_of_week_char1='T' OR day_of_week_char1='M' 
        OR day_of_week_char1='N');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_holidayflag;    
    
ALTER TABLE gb_pfsawh_date_dim 
    ADD CONSTRAINT ck_dim_dt_holidayflag
    check (holiday_flag='NON-HOLIDAY' OR holiday_flag='HOLIDAY' 
        OR holiday_flag='NOT APPLICABLE');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_weekdayflag;    
    
ALTER TABLE gb_pfsawh_date_dim 
    ADD CONSTRAINT ck_dim_dt_weekdayflag 
    CHECK (weekday_flag='WEEKEND DAY' OR weekday_flag='WEEKDAY' 
        OR weekday_flag='NOT APPLICABLE');

ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_season ;   
    
ALTER TABLE gb_pfsawh_date_dim 
    ADD CONSTRAINT ck_dim_dt_season 
    CHECK (season='SPRING' OR season='SUMMER' 
        OR season='FALL'   OR season='WINTER' OR season='NOT APPLICABLE');
        
ALTER TABLE gb_pfsawh_date_dim  
    DROP CONSTRAINT ck_dim_dt_event;    
    
ALTER TABLE gb_pfsawh_date_dim 
    ADD CONSTRAINT ck_dim_dt_event 
    CHECK (event='EVENT' OR event='NON-EVENT' OR event='NOT APPLICABLE');

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_date_dim 
IS 'PFSA_DIM_DATE - Contain a truncated date value representing an individual day that LOGAS has used OR expects to use.  '; 


COMMENT ON COLUMN gb_pfsawh_date_dim.date_id 
IS 'DATE_ID - Identity for PFSA_DATE_DIM records.'; 

COMMENT ON COLUMN gb_pfsawh_date_dim.oracle_date 
IS 'ORACLE_DATE - A truncated date value representing an individual day in the PFSA World.  Represents all time from midnight of a day thru 23:59:59 of the same day.  It is a forward based date value constrained at the day level.  Other dates are made up of a set of distinct consecutive values of day_date.  Values are constrained procedurally to lie within the mindate and maxdate in table.  Dates in this table can be future based and generally are based upon automatic maintenance.';   

COMMENT ON COLUMN gb_pfsawh_date_dim.day_of_week 
IS 'DAY_OF_WEEK - RESETWH DATE_DIM - Full day of week description, Monday, Tuesday, etc.';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_num_in_month 
IS 'DAY_NUM_IN_MONTH - RESETWH DATE_DIM - Integer value between 1-31.';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_num_overall 
IS 'DAY_NUM_OVERALL - RESETWH DATE_DIM - The number of days since 01-Jan-1950. ';

COMMENT ON COLUMN gb_pfsawh_date_dim.week_number_in_year 
IS 'WEEK_NUMBER_IN_YEAR - RESETWH DATE_DIM - Integer value between 1-52 OR 53.  Calculation: DAY_NUM_OVERALL / 7 ';

COMMENT ON COLUMN gb_pfsawh_date_dim.week_number_overall 
IS 'WEEK_NUMBER_OVERALL - RESETWH DATE_DIM - The number of weeks since 01-Jan-1950. ';

COMMENT ON COLUMN gb_pfsawh_date_dim.month_number_in_year 
IS 'MONTH_NUMBER_IN_YEAR - RESETWH DATE_DIM - Calendar year. Integer value between 1-12.';

COMMENT ON COLUMN gb_pfsawh_date_dim.month_number_overall 
IS 'MONTH_NUMBER_OVERALL - RESETWH DATE_DIM - The number of months since 01-Jan-1950';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_quarter 
IS 'CALENDAR_QUARTER - RESETWH DATE_DIM - Calendar year. Integer value between 1-4.';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_quarter 
IS 'FISCAL_QUARTER - RESETWH DATE_DIM - Fiscal year starting in October, 1st. Integer value between 1-4.';

COMMENT ON COLUMN gb_pfsawh_date_dim.holiday_flag 
IS 'HOLIDAY_FLAG - RESETWH DATE_DIM - HOLIDAY OR NON-HOLIDAY';

COMMENT ON COLUMN gb_pfsawh_date_dim.weekday_flag 
IS 'WEEKDAY_FLAG - RESETWH DATE_DIM - WEEKDAY OR WEEKEND DAY';

COMMENT ON COLUMN gb_pfsawh_date_dim.season 
IS 'SEASON - RESETWH DATE_DIM - Do we need this? No, but we will keep it for now until reviewed with LIW. ';    

COMMENT ON COLUMN gb_pfsawh_date_dim.event 
IS 'EVENT - RESETWH DATE_DIM - What do we define as an event?  yes, but we need to work out the definition.';

COMMENT ON COLUMN gb_pfsawh_date_dim.full_date_description 
IS 'FULL_DATE_DESCRIPTION - Full date description.  "Sunday, January 01, 1950"';
   
COMMENT ON COLUMN gb_pfsawh_date_dim.oracle_date_from_time 
IS 'ORACLE_DATE_FROM_TIME - The minimum point in time considered to be part of the day date.  "DD-MMM-YYYY 00:00:00"'; 

COMMENT ON COLUMN gb_pfsawh_date_dim.oracle_date_to_time 
IS 'ORACLE_DATE_TO_TIME - The maximum point in time considered to be part of the day date.  "DD-MMM-YYYY 23:59:59"';

COMMENT ON COLUMN gb_pfsawh_date_dim.ready_date 
IS 'READY_DATE - A specific snap shot of time, midnight of the indicated day.  READY_DATE is a backward looking time component, comprised of all time since midnight of the previous month thru the indicated date.'; 

COMMENT ON COLUMN gb_pfsawh_date_dim.usage_date 
IS 'USAGE_DATE - Usage dates are a PFSA created attribute used to break usage data into time periods condusive to being used both in month periods and ready periods.  USAGE_DATE is a backward  looking time component.'; 

COMMENT ON COLUMN gb_pfsawh_date_dim.usage_days_in_period 
IS 'USAGE_DAYS_IN_PERIOD - This field represents the number of days in the usage period.  Used in averaging monthly reported data into synchronized time frames corresponding to month dates.';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_of_week_char1 
IS 'DAY_OF_WEEK_CHAR1 - 1-character day of week description, Mon - M, Tue - T, Wed - W, Thu - R, Fri - F, Sat - S, Sun - N';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_of_week_char3 
IS 'DAY_OF_WEEK_CHAR3 - 3-character day of week description, Mon, Tue, etc.';

COMMENT ON COLUMN gb_pfsawh_date_dim.julian_date_yddd 
IS 'JULIAN_DATE_YDDD - Julian date - Format: YDDD';

COMMENT ON COLUMN gb_pfsawh_date_dim.julian_date_yyddd 
IS 'JULIAN_DATE_YYDDD - Julian date - Format: YYDDD';

COMMENT ON COLUMN gb_pfsawh_date_dim.julian_date_ccyyddd 
IS 'JULIAN_DATE_CCYYDDD - Julian date - Format: CCYYDDD';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_number_in_calendar_year 
IS 'DAY_NUMBER_IN_CALENDAR_YEAR - The number of days since 01-January';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_number_in_fiscal_month 
IS 'DAY_NUMBER_IN_FISCAL_MONTH - Integer value between 1-31.';

COMMENT ON COLUMN gb_pfsawh_date_dim.day_number_in_fiscal_year 
IS 'DAY_NUMBER_IN_FISCAL_YEAR - The number of days since 01-October';

COMMENT ON COLUMN gb_pfsawh_date_dim.first_day_in_week_indicator 
IS 'FIRST_DAY_IN_WEEK_INDICATOR - ???? Indicates if this is the first day of the week.  Sunday is the first day of the with value of 1';

COMMENT ON COLUMN gb_pfsawh_date_dim.first_day_in_month_indicator 
IS 'FIRST_DAY_IN_MONTH_INDICATOR - Indicates if this is the first day of the month.';

COMMENT ON COLUMN gb_pfsawh_date_dim.last_day_in_week_indicator 
IS 'LAST_DAY_IN_WEEK_INDICATOR - ???? Indicates if this is the last day of the week.';

COMMENT ON COLUMN gb_pfsawh_date_dim.last_day_in_month_indicator 
IS 'LAST_DAY_IN_MONTH_INDICATOR - Indicates if this is the last day of the month.';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_week_ending_date 
IS 'CALENDAR_WEEK_ENDING_DATE - The date that the calendar week ends on.';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_month_name 
IS 'CALENDAR_MONTH_NAME - Full month name';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_month_name_char3 
IS 'CALENDAR_MONTH_NAME_CHAR3 - 3-character month name';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_year_month_yyyymm 
IS 'CALENDAR_YEAR_MONTH_YYYYMM - Aids in sorting by year and month.';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_year_quarter_yyyyqq 
IS 'CALENDAR_YEAR_QUARTER_YYYYQQ - Aids in sorting by calendar year and calendar quarter.';

COMMENT ON COLUMN gb_pfsawh_date_dim.calendar_year 
IS 'CALENDAR_YEAR - Year number';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_week_ending_date 
IS 'FISCAL_WEEK_ENDING_DATE - The date that the fiscal week ends on.';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_week_number_in_year 
IS 'FISCAL_WEEK_NUMBER_IN_YEAR - CALCULATE - The week number in the fiscal year since 01-Oct.';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_month_name 
IS 'FISCAL_MONTH_NAME - Full month name';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_month_name_char3 
IS 'FISCAL_MONTH_NAME_CHAR3 - 3-character month name';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_month_in_year 
IS 'FISCAL_MONTH_IN_YEAR - The number number in the fiscal year since October.';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_year_month_yyyymm 
IS 'FISCAL_YEAR_MONTH_YYYYMM  - Aids in sorting by fiscal year and fiscal month.';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_year_quarter_yyyyqq 
IS 'FISCAL_YEAR_QUARTER_YYYYQQ - Aids in sorting by fiscal year and fiscal quarter.';

COMMENT ON COLUMN gb_pfsawh_date_dim.fiscal_year 
IS 'FISCAL_YEAR - Fiscal year number';

COMMENT ON COLUMN gb_pfsawh_date_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_date_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_date_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name OR user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_date_dim.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active OR not.';

COMMENT ON COLUMN gb_pfsawh_date_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_date_dim.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_date_dim.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_date_dim.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_date_dim.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_date_dim.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated';

COMMENT ON COLUMN gb_pfsawh_date_dim.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_date_dim.delete_date 
IS 'DELETE_DATE - Additional control for delete_Fl indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_date_dim.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_date_dim.hidden_date 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT  table_name, comments 
FROM    user_tab_comments 
WHERE   table_name = UPPER('gb_pfsawh_date_dim'); 

/*----- Check to see if the table column comments are present -----*/

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_date_dim') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_date_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
/*----- Populate -----*/

---------------------------------------
------- PFSA_DATE_DIM           ------- 
---------------------------------------

DECLARE 

-- standard variables 
    
    ps_procedure_name                VARCHAR2(30)       := 'pfsa_date_dim';
    ps_location                      VARCHAR2(10)       := '0 - Begin';
    ps_id_key                        VARCHAR2(200)      := NULL;
    
    v_ErrorCode                      VARCHAR2(6)        := NULL;
    v_ErrorText                      VARCHAR2(200)      := '';

-- loop variables
    v_loop_cnt                       INTEGER;     

-- proces specific variables 

    v_date_id                        NUMBER; 
    v_oracle_date                    DATE; 
    v_day_of_week                    VARCHAR2(20); 
    v_DAY_NUM_IN_MONTH               INTEGER;        
    v_DAY_NUM_OVERALL                INTEGER;    
    v_WEEK_NUMBER_IN_YEAR            INTEGER;    
    v_WEEK_NUMBER_OVERALL            INTEGER;    
    v_MONTH_NUMBER_IN_YEAR           INTEGER;        
    v_MONTH_NUMBER_OVERALL           INTEGER;        
    v_CALENDAR_QUARTER               INTEGER;        
    v_FISCAL_QUARTER                 varchar2(10);    
    v_HOLIDAY_FLAG                   varchar2(11);        
    v_WEEKDAY_FLAG                   varchar2(7);    
    v_SEASON                         varchar2(50);        
    v_EVENT                          varchar2(50);        
--    
    v_FULL_DATE_DESCRIPTION          varchar2(30);
-- PFSA Dates 
    v_ORACLE_DATE_FROM_TIME          date; 
    v_ORACLE_DATE_TO_TIME            date; 
    v_READY_DATE                     date; 
    v_USAGE_DATE                     date; 
    v_USAGE_DAYS_IN_PERIOD           number(2);        
--    
    v_day_of_week_char1              varchar2(1);
    v_day_of_week_char3              varchar2(3);
    v_JULIAN_DATE_YDDD               varchar2(4);
    v_JULIAN_DATE_YYDDD              varchar2(5);
    v_JULIAN_DATE_CCYYDDD            varchar2(7);
--
    v_DAY_NUMBER_IN_EPOCH            number;
    v_WEEK_NUMBER_IN_EPOCH           number;
    v_MONTH_NUMBER_IN_EPOCH          number;
--
    v_DAY_NUMBER_IN_CALENDAR_YEAR    number(3);
    v_DAY_NUMBER_IN_FISCAL_MONTH     number(2); 
    v_DAY_NUMBER_IN_FISCAL_YEAR      number(3);
--
    v_FIRST_DAY_IN_WEEK_INDICATOR    varchar2(20);    
    v_FIRST_DAY_IN_MONTH_INDICATOR   varchar2(20);
    v_LAST_DAY_IN_WEEK_INDICATOR     varchar2(20);
    v_LAST_DAY_IN_MONTH_INDICATOR    varchar2(20);
--
    v_CALENDAR_WEEK_ENDING_DATE      varchar2(20);    
    v_CALENDAR_MONTH_NAME            varchar2(20);
    v_calendar_month_name_char3      varchar2(3);
    v_CALENDAR_YEAR_MONTH_YYYYMM     varchar2(7);
    v_CALENDAR_YEAR_QUARTER_YYYYQQ   varchar2(7);
    v_CALENDAR_YEAR                  number(4);
--
    v_FISCAL_WEEK_ENDING_DATE        varchar2(20);
    v_FISCAL_WEEK_NUMBER_IN_YEAR     number(2);
    v_FISCAL_MONTH_NAME              varchar2(20);
    v_FISCAL_MONTH_NAME_CHAR3        varchar2(3);
    v_FISCAL_MONTH_IN_YEAR           number(2);
    v_FISCAL_YEAR_MONTH_YYYYMM       varchar2(7);
    v_FISCAL_YEAR_QUARTER_YYYYQQ     varchar2(7);
    v_FISCAL_YEAR                    varchar2(5);
--
    v_STATUS                         varchar(1);
    v_UPDT_BY                        varchar2(30);
    v_LST_UPDT                       date;
--
    v_ACTIVE_FLAG                    varchar2(1); 
    v_ACTIVE_DATE                    date; 
    v_INACTIVE_DATE                  date;
--
    v_INSERT_BY                      varchar2(20); 
    v_INSERT_DATE                    date; 
    v_UPDATE_BY                      varchar2(20);
    v_UPDATE_DATE                    date;
    v_DELETE_FLAG                    varchar2(1);
    v_DELETE_DATE                    date;
    v_HIDDEN_FLAG                    varchar2(1);
    v_HIDDEN_DATE                    date;
     
    r_date_dim        gb_pfsawh_date_dim%ROWTYPE; 
    
    CURSOR date_dim_cur IS
        SELECT    * --date_id, ORACLE_DATE,    day_of_week lin  
        FROM      gb_pfsawh_date_dim
        ORDER BY  ORACLE_DATE; 
        
BEGIN 
--    DBMS_OUTPUT.ENABLE(1000000);
--    DBMS_OUTPUT.NEW_LINE;
--    DBMS_OUTPUT.NEW_LINE;
    
    DELETE gb_pfsawh_date_dim;
    
--    DBMS_OUTPUT.PUT_LINE    ('*** PFSA_DATE_DIM ***');
--    DBMS_OUTPUT.PUT_LINE    ('* Insert test *'); 
--    DBMS_OUTPUT.NEW_LINE;
    
----------------------------------------- 
----- Start of the epoch 1-Jan-1950 ----- 
-----------------------------------------     
    
    INSERT 
    INTO    gb_pfsawh_date_dim 
    (
    DATE_ID, ORACLE_DATE, day_of_week, DAY_NUM_IN_MONTH, DAY_NUM_OVERALL, WEEK_NUMBER_IN_YEAR, WEEK_NUMBER_OVERALL,    
    MONTH_NUMBER_IN_YEAR, MONTH_NUMBER_OVERALL, CALENDAR_QUARTER, FISCAL_QUARTER, HOLIDAY_FLAG, WEEKDAY_FLAG, SEASON, EVENT,    
--    
    FULL_DATE_DESCRIPTION,
-- PFSA Dates 
    ORACLE_DATE_FROM_TIME, ORACLE_DATE_TO_TIME, READY_DATE, USAGE_DATE, USAGE_DAYS_IN_PERIOD, 
--
    day_of_week_char1, day_of_week_char3, JULIAN_DATE_YDDD, JULIAN_DATE_YYDDD, JULIAN_DATE_CCYYDDD, 
--
    DAY_NUMBER_IN_CALENDAR_YEAR, DAY_NUMBER_IN_FISCAL_MONTH, DAY_NUMBER_IN_FISCAL_YEAR,
--
    FIRST_DAY_IN_WEEK_INDICATOR, FIRST_DAY_IN_MONTH_INDICATOR,
    LAST_DAY_IN_WEEK_INDICATOR, LAST_DAY_IN_MONTH_INDICATOR,
--
    CALENDAR_WEEK_ENDING_DATE, CALENDAR_MONTH_NAME, calendar_month_name_char3, CALENDAR_YEAR_MONTH_YYYYMM, 
    CALENDAR_YEAR_QUARTER_YYYYQQ, CALENDAR_YEAR,
--
    FISCAL_WEEK_ENDING_DATE, FISCAL_WEEK_NUMBER_IN_YEAR, FISCAL_MONTH_NAME, FISCAL_MONTH_NAME_CHAR3, FISCAL_MONTH_IN_YEAR,
    FISCAL_YEAR_MONTH_YYYYMM, FISCAL_YEAR_QUARTER_YYYYQQ, FISCAL_YEAR,
--
    STATUS, UPDT_BY, LST_UPDT,
--
--    ACTIVE_FLAG, ACTIVE_DATE, INACTIVE_DATE,
--
    INSERT_BY, INSERT_DATE, UPDATE_BY, UPDATE_DATE, DELETE_FLAG, DELETE_DATE, HIDDEN_FLAG, HIDDEN_DATE
    )
VALUES    
    (    
    10000, 
    '01-JAN-1950', 
    TRIM(TO_CHAR(TO_DATE('01-JAN-1950'), 'DAY')), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'DD'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'DDD'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'IW'), 
    -1, 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'MM'), 
    -1, 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'Q'), 
    -1, 
    'HOLIDAY', 
    'WEEKEND DAY', 
    'FALL', 
    'NON-EVENT', 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'DL'),
--  PFSA Dates     
    '01-JAN-1900', 
    '01-JAN-1900', 
    '01-JAN-1900', 
    '01-JAN-1900', 
    0,        
--    
    CASE TO_CHAR(TO_DATE('01-JAN-1950'), 'D') 
        WHEN '1' THEN 'N'  
        WHEN '2' THEN 'M'  
        WHEN '3' THEN 'T'   
        WHEN '4' THEN 'W'  
        WHEN '5' THEN 'R'  
        WHEN '6' THEN 'F'  
        WHEN '7' THEN 'S'  
    END, 
    SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950'), 'DAY'), 1, 3), 
    SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950'), 'RR'), 2, 1) || TO_CHAR(TO_DATE('01-JAN-1950'), 'DDD'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'RR') || TO_CHAR(TO_DATE('01-JAN-1950'), 'DDD'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'YYYY') || TO_CHAR(TO_DATE('01-JAN-1950'), 'DDD'), 
--
    TO_CHAR(TO_DATE('01-JAN-1950'), 'DDD'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'DD'), 
    -1,
--
    0, 0, 0, 0,
--
    'WW', 
    TRIM(TO_CHAR(TO_DATE('01-JAN-1950'), 'MONTH')), 
    SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950'), 'MONTH'), 1, 3), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'YYYY') || TO_CHAR(TO_DATE('01-JAN-1950'), 'MM'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'YYYY') || TO_CHAR(TO_DATE('01-JAN-1950'), 'Q'), 
    TO_CHAR(TO_DATE('01-JAN-1950'), 'YYYY'), 
--
    'n', 
    -1, 
    TRIM(TO_CHAR(TO_DATE('01-JAN-1950'), 'MONTH')), 
    SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950'), 'MONTH'), 1, 3), 
    -1, 
    'yyyymm', 
    '-1', 
    '-1',
--
    'T', user, sysdate,
--
    user, sysdate, NULL, NULL, NULL, NULL, NULL, NULL  
    );

---------------------
----- Load loop ----- 
---------------------

    FOR v_loop_cnt IN 1..TO_DATE('31-DEC-2049') - TO_DATE('01-JAN-1950') 
    LOOP

--        DBMS_OUTPUT.PUT_LINE(TO_DATE('01-JAN-1950') + v_loop_cnt);
--        DBMS_OUTPUT.NEW_LINE;
    
        ps_id_key        := v_loop_cnt; 

        INSERT 
        INTO    gb_pfsawh_date_dim 
        (
        DATE_ID, ORACLE_DATE, day_of_week, DAY_NUM_IN_MONTH, DAY_NUM_OVERALL, 
        WEEK_NUMBER_IN_YEAR, WEEK_NUMBER_OVERALL,    
        MONTH_NUMBER_IN_YEAR, MONTH_NUMBER_OVERALL, CALENDAR_QUARTER, 
        FISCAL_QUARTER, HOLIDAY_FLAG, WEEKDAY_FLAG, SEASON, EVENT,    
--    
        FULL_DATE_DESCRIPTION,
-- PFSA Dates 
        ORACLE_DATE_FROM_TIME, ORACLE_DATE_TO_TIME, READY_DATE, USAGE_DATE, USAGE_DAYS_IN_PERIOD, 
--
        day_of_week_char1, day_of_week_char3, JULIAN_DATE_YDDD, JULIAN_DATE_YYDDD, JULIAN_DATE_CCYYDDD, 
--
        DAY_NUMBER_IN_CALENDAR_YEAR, DAY_NUMBER_IN_FISCAL_MONTH, DAY_NUMBER_IN_FISCAL_YEAR,
--
        FIRST_DAY_IN_WEEK_INDICATOR, FIRST_DAY_IN_MONTH_INDICATOR,
        LAST_DAY_IN_WEEK_INDICATOR, LAST_DAY_IN_MONTH_INDICATOR,
--
        CALENDAR_WEEK_ENDING_DATE, CALENDAR_MONTH_NAME, calendar_month_name_char3, CALENDAR_YEAR_MONTH_YYYYMM, 
        CALENDAR_YEAR_QUARTER_YYYYQQ, CALENDAR_YEAR,
--
        FISCAL_WEEK_ENDING_DATE, FISCAL_WEEK_NUMBER_IN_YEAR, FISCAL_MONTH_NAME, FISCAL_MONTH_NAME_CHAR3, FISCAL_MONTH_IN_YEAR,
        FISCAL_YEAR_MONTH_YYYYMM, FISCAL_YEAR_QUARTER_YYYYQQ, FISCAL_YEAR,
--
        STATUS, UPDT_BY, LST_UPDT,
--
--    ACTIVE_FLAG, ACTIVE_DATE, INACTIVE_DATE,
--
        INSERT_BY, INSERT_DATE, UPDATE_BY, UPDATE_DATE, DELETE_FLAG, DELETE_DATE, HIDDEN_FLAG, HIDDEN_DATE
        )
    VALUES    
        (
        v_loop_cnt + 10000, 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DD-MON-YYYY'), 
        TRIM(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DAY')), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DD'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DDD'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'IW'), 
        -1, 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'MM'), 
        -1, 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'Q'), 
        -1, 
        'HOLIDAY', 
        'WEEKEND DAY', 
        'FALL', 
        'NON-EVENT', 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DL'),
--  PFSA Dates     
        '01-JAN-1900', '01-JAN-1900', '01-JAN-1900', '01-JAN-1900', 0,        
--    
        CASE TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'D') 
            WHEN '1' THEN 'N'  
            WHEN '2' THEN 'M'  
            WHEN '3' THEN 'T'   
            WHEN '4' THEN 'W'  
            WHEN '5' THEN 'R'  
            WHEN '6' THEN 'F'  
            WHEN '7' THEN 'S'  
        END, 
        SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DAY'), 1, 3), 
        SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'RR'), 2, 1) || TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DDD'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'RR') || TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DDD'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'YYYY') || TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DDD'), 
--
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DDD'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'DD'), 
        -1,
--
        0, 0, 0, 0,
--
        'WW', 
        TRIM(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'MONTH')), 
        SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'MONTH'), 1, 3), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'YYYY') || TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'MM'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'YYYY') || TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'Q'), 
        TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'YYYY'), 
--
        'n', 
        -1, 
        TRIM(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'MONTH')), 
        SUBSTR(TO_CHAR(TO_DATE('01-JAN-1950')+v_loop_cnt, 'MONTH'), 1, 3), 
        -1, 
        'yyyymm', 
        '-1', 
        '-1',
--
        'T', user, sysdate,
--
        user, sysdate, NULL, NULL, NULL, NULL, NULL, NULL  
        );

    END LOOP; 
    
--    DBMS_OUTPUT.NEW_LINE;
    
    OPEN date_dim_cur;
    
    LOOP
        FETCH    date_dim_cur 
        INTO    v_date_id, v_oracle_date, v_day_of_week, v_DAY_NUM_IN_MONTH, v_DAY_NUM_OVERALL, v_WEEK_NUMBER_IN_YEAR, 
                v_WEEK_NUMBER_OVERALL, v_MONTH_NUMBER_IN_YEAR, v_MONTH_NUMBER_OVERALL, v_CALENDAR_QUARTER, v_FISCAL_QUARTER, 
                v_HOLIDAY_FLAG, v_WEEKDAY_FLAG, v_SEASON, v_EVENT,         
--    
                v_FULL_DATE_DESCRIPTION, 
-- PFSA Dates 
                v_ORACLE_DATE_FROM_TIME, v_ORACLE_DATE_TO_TIME, v_READY_DATE, v_USAGE_DATE, v_USAGE_DAYS_IN_PERIOD,         
--    
                v_day_of_week_char1, v_day_of_week_char3, v_JULIAN_DATE_YDDD, v_JULIAN_DATE_YYDDD, v_JULIAN_DATE_CCYYDDD,
--
                v_DAY_NUMBER_IN_CALENDAR_YEAR, v_DAY_NUMBER_IN_FISCAL_MONTH, v_DAY_NUMBER_IN_FISCAL_YEAR, 
--
                v_FIRST_DAY_IN_WEEK_INDICATOR, v_FIRST_DAY_IN_MONTH_INDICATOR, 
                v_LAST_DAY_IN_WEEK_INDICATOR, v_LAST_DAY_IN_MONTH_INDICATOR, 
--                
                v_CALENDAR_WEEK_ENDING_DATE, v_CALENDAR_MONTH_NAME, v_calendar_month_name_char3, 
                v_CALENDAR_YEAR_MONTH_YYYYMM, v_CALENDAR_YEAR_QUARTER_YYYYQQ, v_CALENDAR_YEAR, 
--
                v_FISCAL_WEEK_ENDING_DATE, v_FISCAL_WEEK_NUMBER_IN_YEAR, v_FISCAL_MONTH_NAME, v_FISCAL_MONTH_NAME_CHAR3, 
                v_FISCAL_MONTH_IN_YEAR, v_FISCAL_YEAR_MONTH_YYYYMM, v_FISCAL_YEAR_QUARTER_YYYYQQ, v_FISCAL_YEAR, 
--
                v_STATUS, v_UPDT_BY, v_LST_UPDT, 
--
                v_ACTIVE_FLAG, v_ACTIVE_DATE, v_INACTIVE_DATE, 
--
                v_INSERT_BY, v_INSERT_DATE, v_UPDATE_BY, v_UPDATE_DATE, v_DELETE_FLAG, v_DELETE_DATE, v_HIDDEN_FLAG, v_HIDDEN_DATE;
        
        EXIT WHEN date_dim_cur%NOTFOUND;
        
--        DBMS_OUTPUT.PUT_LINE(v_date_id || ' ' || v_oracle_date || ' ' || v_day_of_week);
        
--        DBMS_OUTPUT.PUT_LINE('default values'); 
--        DBMS_OUTPUT.PUT_LINE(v_date_id || ' ' || v_active_flag || ' ' || TO_CHAR(v_active_date, 'DD-MON-YYYY') || ' ' || TO_CHAR(v_inactive_date, 'DD-MON-YYYY'));
--        DBMS_OUTPUT.PUT_LINE(v_date_id || ' ' || v_insert_by || ' ' || TO_CHAR(v_insert_date, 'DD-MON-YYYY'));
        
    END LOOP;
    
    CLOSE date_dim_cur;

EXCEPTION 
    WHEN OTHERS THEN 
        v_ErrorCode      := sqlcode;
        v_ErrorText      := SUBSTR(SQLERRM, 1, 200);
        
        INSERT 
        INTO    std_pfsa_debug_tbl 
            (
            ps_procedure, ps_oerr, ps_location, called_by, ps_id_key, ps_msg, msg_dt
            )
        VALUES
            (
            ps_procedure_name, v_ErrorCode, ps_location, user, ps_id_key, v_ErrorText, sysdate 
            );
    
END;

-- COMMIT;

/*

SELECT * FROM gb_pfsawh_date_dim ORDER BY oracle_date  

SELECT * FROM gb_pfsawh_date_dim ORDER BY oracle_date DESC 

*/

/*

SELECT    '01-JAN-1950', TO_DATE('01-JAN-1950'), TO_CHAR(TO_DATE('01-JAN-1950'), 'DL'), TO_DATE('01-JAN-1950') + 1, 
    '|', d.* FROM    gb_pfsawh_date_dim d

*/

            
