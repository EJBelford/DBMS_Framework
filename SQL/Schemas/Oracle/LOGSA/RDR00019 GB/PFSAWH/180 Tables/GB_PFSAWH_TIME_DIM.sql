DROP TABLE gb_pfsawh_time_dim;
	
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: gb_pfsawh_time_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_time_dim.sql
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
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_time_dim 
(
    time_id                       NUMBER(5)           NOT NULL ,
--
    time_seconds_since_midnight   NUMBER(5)           NOT NULL ,
    time_desc_12hour              VARCHAR2(11)        NOT NULL ,
    time_desc_24hour              VARCHAR2(8)         NOT NULL ,
    time_12hour                   VARCHAR2(8)         NOT NULL ,
    time_24hour                   VARCHAR2(5)         NOT NULL ,
    time_12hour_minute            VARCHAR2(8)         NOT NULL ,
    time_24hour_minute            VARCHAR2(5)         NOT NULL ,
--
    time_am_pm_code               VARCHAR2(2)         NOT NULL , 
--
    STATUS                        VARCHAR2(1)         DEFAULT 'I' ,
    LST_UPDT                      DATE                DEFAULT sysdate ,
    UPDT_BY                       VARCHAR2(20)        DEFAULT user ,
--
    ACTIVE_FLAG                   VARCHAR2(1)         DEFAULT 'I' , 
    ACTIVE_DATE                   DATE                DEFAULT '01-JAN-1900' , 
    INACTIVE_DATE                 DATE                DEFAULT '31-DEC-2099' ,
--
    INSERT_BY                     VARCHAR2(20)        DEFAULT user , 
    INSERT_DATE                   DATE                DEFAULT sysdate , 
    UPDATE_BY                     VARCHAR2(20)        NULL ,
    UPDATE_DATE                   DATE                DEFAULT '01-JAN-1900' ,
    DELETE_FLAG                   VARCHAR2(1)         DEFAULT 'N' ,
    DELETE_DATE                   DATE                DEFAULT '01-JAN-1900' ,
    HIDDEN_FLAG                   VARCHAR2(1)         DEFAULT 'Y' ,
    HIDDEN_DATE                   DATE                DEFAULT '01-JAN-1900', 
CONSTRAINt pk_pfsa_time_dim PRIMARY KEY 
    (
    time_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsa_time_dim;

CREATE UNIQUE INDEX ixu_pfsa_time_dim 
    ON gb_pfsawh_time_dim
    (
    time_desc_24hour
    );

/*----- Constraints -----*/

ALTER TABLE gb_pfsawh_time_dim  
    DROP CONSTRAINT ck_time_dim_act_flag;        

ALTER TABLE gb_pfsawh_time_dim  
    ADD CONSTRAINT ck_time_dim_act_flag 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE gb_pfsawh_time_dim  
    DROP CONSTRAINT ck_time_dim_am_pm_code;        

ALTER TABLE gb_pfsawh_time_dim  
    ADD CONSTRAINT ck_time_dim_am_pm_code 
    CHECK (time_am_pm_code='AM' OR time_am_pm_code='PM' OR time_am_pm_code='na');

ALTER TABLE gb_pfsawh_time_dim  
    DROP CONSTRAINT ck_time_dim_hide_flag;        

ALTER TABLE gb_pfsawh_time_dim  
    ADD CONSTRAINT ck_time_dim_hide_flag 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE gb_pfsawh_time_dim  
    DROP CONSTRAINT ck_pfsa_time_dim_status;        

ALTER TABLE gb_pfsawh_time_dim  
    ADD CONSTRAINT ck_pfsa_time_dim_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Table Meta-Data -----*/ 
COMMENT ON TABLE gb_pfsawh_time_dim 
IS 'PFSA time dimension with a granularity of a second.  (Assume that the time is Zulu and that there will be both Zulu and local times in the fact table with the respective offset.)'; 


COMMENT ON COLUMN gb_pfsawh_time_dim.time_id 
IS 'The primary key for the TIME dimension.  There are 86,400 intervals in the dimension.  The first element starts at 10,000.  Is the default and represents 00:00:00'; 

COMMENT ON COLUMN gb_pfsawh_time_dim.time_seconds_since_midnight 
IS 'The number of seconds that has elapsed since midnight.  Format: #####';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_desc_12hour 
IS 'Time expressed using the 12-hour clock.  Format: HH:MM:SS AM';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_desc_24hour 
IS 'Time expressed using the 24-hour clock  Format: HH:MM:SS';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_12hour 
IS 'Description of second to the hour on a 12-hour clock.  Format: HH:00 AM';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_24hour 
IS 'Description of second to the hour on a 24-hour clock.  Format: HH:00';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_12hour_minute 
IS 'Description of second to the hour and minute on a 12-hour clock.  Format: HH:MM AM';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_24hour_minute 
IS 'Description of second to the hour and minute on a 24-hour clock.  Format: HH:MM';

COMMENT ON COLUMN gb_pfsawh_time_dim.time_am_pm_code 
IS 'AM/PM indicator the time.  Format: AM';

COMMENT ON COLUMN gb_pfsawh_time_dim.status 
IS 'The status of the record in question.  (This seems to have more to do with the ETL processing than the data warehouse.) [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_time_dim.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_time_dim.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_time_dim.active_flag 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_time_dim.active_date 
IS 'Addition control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_time_dim.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_time_dim.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_time_dim.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_time_dim.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_time_dim.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_time_dim.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_time_dim.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_time_dim.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_time_dim.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_time_dim'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_time_dim') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('gb_pfsawh_time_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
/*----- Populate -----*/

DECLARE
    v_row_cnt                            NUMBER(4);

    v_time_id                            NUMBER(5);
    v_time_seconds_since_midnight        NUMBER(5);
    v_time_desc_12hour                   VARCHAR2(11);
    v_time_desc_24hour                   VARCHAR2(8);
    v_time_am_pm_code                    VARCHAR2(2);                    

    CURSOR time_cur IS
        SELECT    time_id, time_seconds_since_midnight, time_desc_12hour, time_desc_24hour, time_am_pm_code 
        FROM      gb_pfsawh_time_dim
        ORDER BY  time_id; 
        
BEGIN

-- Clean up

    DELETE gb_pfsawh_time_dim; 

-- All the seconds in a day 

    FOR loop_cnt IN 1..86400
    LOOP 
        INSERT 
        INTO    gb_pfsawh_time_dim
            (
            time_id , 
--
            time_seconds_since_midnight ,
            time_desc_12hour ,
            time_desc_24hour ,
            time_12hour ,
            time_24hour ,
            time_12hour_minute ,
            time_24hour_minute ,
            time_am_pm_code , 
--
            status ,
            updt_by ,
-- 
            active_flag 
            )
        VALUES
            (
            loop_cnt + 10000,
            loop_cnt - 1 ,
            SUBSTR(RTRIM(NUMTODSINTERVAL(loop_cnt - 1, 'SECOND')), 12, 8) ,
            SUBSTR(RTRIM(NUMTODSINTERVAL(loop_cnt - 1, 'SECOND')), 12, 8) ,
            '00:00 AM' ,
            '00:00' ,
            '00:00 AM' ,
            '00:00' ,
            'AM' , 
            'C' ,
            'GBelford' ,
            'Y'
            );
    END LOOP;
    
-- Buld the 12-hour clock description 

    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '12' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' AM' 
    WHERE   TIME_ID <= 3600;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = SUBSTR(TIME_DESC_12HOUR, 1,8) || ' AM' 
    WHERE   TIME_ID BETWEEN 3601 AND 43200;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '12' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 43201 AND 46800;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '01' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 46801 AND 50400;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '02' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 50401 AND 54000;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '03' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 54001 AND 58600;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '04' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 58601 AND 61200;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '05' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 61201 AND 64800;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '06' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 64801 AND 68400;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '07' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 68401 AND 72000;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '08' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 72001 AND 75600;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '09' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 75601 AND 79200;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '10' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID BETWEEN 79201 AND 82800;
     
    UPDATE  gb_pfsawh_time_dim
    SET     TIME_DESC_12HOUR = '11' || SUBSTR(TIME_DESC_12HOUR, 3,6) || ' PM' 
    WHERE   TIME_ID >= 82801;
    
-- Build the hour and minute round ups 

    UPDATE  gb_pfsawh_time_dim 
    SET     time_12hour           = SUBSTR(TIME_DESC_12HOUR, 1, 3) || '00' || SUBSTR(TIME_DESC_12HOUR, 9, 3) ,
            time_24hour           = SUBSTR(TIME_DESC_24HOUR, 1, 3) || '00' ,
            time_12hour_minute    = SUBSTR(TIME_DESC_12HOUR, 1, 5) || SUBSTR(TIME_DESC_12HOUR, 9, 3),
            time_24hour_minute    = SUBSTR(TIME_DESC_24HOUR, 1, 5); 
     
-- Enter for when we do not have a time from the source but the warehouse tablke has a time dimension
    
    INSERT 
    INTO    gb_pfsawh_time_dim
        (
        time_id , 
--
        time_seconds_since_midnight ,
        time_desc_12hour ,
        time_desc_24hour ,
        time_12hour ,
        time_24hour ,
        time_12hour_minute ,
        time_24hour_minute ,
        time_am_pm_code , 
--
        status ,
        updt_by ,
-- 
        active_flag 
        )
    VALUES
        (
        9999 ,
        -1 ,
        'n/a' ,
        'n/a' ,
        'n/a' ,
        'n/a' ,
        'n/a' ,
        'n/a' ,
        'na' , 
        'C' ,
        'GBelford' ,
        'Y'
        );

-- Dump the dimension for validation
/*    
    DBMS_OUTPUT.ENABLE(1000000);
    OPEN time_cur;
    
    LOOP
        FETCH    time_cur 
        INTO    v_TIME_ID,  v_TIME_SECONDS_SINCE_MIDNIGHT, v_TIME_DESC_12HOUR,  
                v_TIME_DESC_24HOUR, v_TIME_AM_PM_CODE;
        
        EXIT WHEN time_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(    v_TIME_ID || ' ' || v_TIME_SECONDS_SINCE_MIDNIGHT || ' ' || v_TIME_DESC_12HOUR || ' ' || 
                                v_TIME_DESC_24HOUR || ' ' || v_TIME_AM_PM_CODE);

    END LOOP;
    
    CLOSE time_cur;
*/

    COMMIT;

END;

/*----- work area -----*/

/*

SELECT * FROM gb_pfsawh_time_dim ORDER BY TIME_ID 

SELECT SUBSTR(RTRIM(NUMTODSINTERVAL(TIME_ID, 'SECOND')), 12, 8) FROM gb_pfsawh_time_dim ORDER BY TIME_ID

SELECT    TIME_DESC_12HOUR, SUBSTR(TIME_DESC_12HOUR, 1, 3) || '00' || SUBSTR(TIME_DESC_12HOUR, 9, 3), 
        TIME_DESC_24HOUR, SUBSTR(TIME_DESC_24HOUR, 1, 3) || '00'
FROM gb_pfsawh_time_dim ORDER BY TIME_ID

SELECT    TIME_DESC_12HOUR, SUBSTR(TIME_DESC_12HOUR, 1, 5) || SUBSTR(TIME_DESC_12HOUR, 9, 3), 
        TIME_DESC_24HOUR, SUBSTR(TIME_DESC_24HOUR, 1, 5)
FROM gb_pfsawh_time_dim ORDER BY TIME_ID

*/
    
    
