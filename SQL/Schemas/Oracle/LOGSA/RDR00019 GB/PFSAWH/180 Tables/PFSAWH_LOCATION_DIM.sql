DROP TABLE gb_pfsawh_location_dim;

/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: gb_pfsawh_location_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: gb_pfsawh_location_dim.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 27 November 2007
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
-- 27NOV07 - GB  -          -      - Created 
-- 18JAN08 - GB  -          -      - Rename from pfsa_geo_dim 
--                 to pfsawh_location_dim.  
--
/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--
CREATE TABLE gb_pfsawh_location_dim
(
rec_id                          NUMBER              NOT NULL , 
--
geo_id                          NUMBER              NOT NULL ,
geo_cd                          VARCHAR2(5)         NOT NULL ,
st_cntry_name                   VARCHAR2(20),
geo_cd_desc                     VARCHAR2(200), 
--
installation_name               VARCHAR2(70),
city_name                       VARCHAR2(60),
county_name                     VARCHAR2(20),
state_code                      VARCHAR2(2),
state_name                      VARCHAR2(20),
province_name                   VARCHAR2(20),
iso_3166_2_numeric              NUMBER,
country_name                    VARCHAR2(50),
iso_3166_1_alpha_2              VARCHAR2(2),
iso_3166_1_alpha_3              VARCHAR2(3),
iso_3166_1_numeric              NUMBER,
zip_code                        VARCHAR2(10),
theater_name                    VARCHAR2(20), 
time_zone_region_code           VARCHAR(3)          DEFAULT 'UNK', 
time_zone_region_zulu_offset    NUMBER(3)           DEFAULT '0', 
time_zone_region_desc           VARCHAR2(20)        DEFAULT 'UNKNOWN', 
installation_type_code          VARCHAR(3)          DEFAULT 'UNK',
-- 
cipher_st_cntry_name            VARCHAR2(20),
cipher_geo_cd_desc              VARCHAR2(200), 
cipher_installation_name        VARCHAR2(70),
cipher_city_name                VARCHAR2(60),
cipher_province_name            VARCHAR2(20),
cipher_iso_3166_2_numeric       NUMBER,
cipher_country_name             VARCHAR2(50),
cipher_iso_3166_1_alpha_2       VARCHAR2(2),
cipher_iso_3166_1_alpha_3       VARCHAR2(3),
cipher_iso_3166_1_numeric       NUMBER,
-- 
status                          VARCHAR2(1)         DEFAULT 'Z' ,
lst_updt                        DATE,
updt_by                         VARCHAR2(30),
--
active_flag                     VARCHAR2(1)         DEFAULT 'I' , 
active_date                     DATE                DEFAULT '01-JAN-1900' , 
inactive_date                   DATE                DEFAULT '31-DEC-2099' ,
--
insert_by                       VARCHAR2(20)        DEFAULT USER , 
insert_date                     DATE                DEFAULT SYSDATE , 
update_by                       VARCHAR2(20)        NULL ,
update_date                     DATE                DEFAULT '01-JAN-1900' ,
delete_flag                     VARCHAR2(1)         DEFAULT 'N' ,
delete_date                     DATE                DEFAULT '01-JAN-1900' ,
hidden_flag                     VARCHAR2(1)         DEFAULT 'Y' ,
hidden_date                     DATE                DEFAULT '01-JAN-1900' ,
CONSTRAINT pk_pfsawh_location_dim PRIMARY KEY 
    (
    rec_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_location_seq;

CREATE SEQUENCE pfsawh_location_seq
START WITH 10000
MAXVALUE 999999
MINVALUE 1
NOCYCLE
NOCACHE
NOORDER;

/*----- Indexs -----*/

DROP INDEX ix_location_geo_cd_dim;

CREATE UNIQUE INDEX ix_location_geo_cd_dim ON gb_pfsawh_location_dim
    (
    geo_cd
    )
LOGGING
NOPARALLEL;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_location_dim 
IS 'This table is used in the PFSA world to normalize the station code based geographical data in the LIDB STN_REF table to geographical codes (GEO_CD).  It is maintained by a nightly process to remove duplicate geographical codes.  Duplicate geographical codes are created by changes in countries, i.e., the re-unification of Germany.  Station Codes are based upon the state/country code of the country, plus a 3 digit sequence number.  Station codes can also change/relate to the same geographical location based upon the type of station (i.e., an airfield on a fort will have a separate station code from the fort itself.  The geographical code is the same for both.';


COMMENT ON COLUMN gb_pfsawh_location_dim.rec_id 
IS 'Identity for PFSAWH_LOCATION_DIM';

COMMENT ON COLUMN gb_pfsawh_location_dim.geo_id 
IS 'Location code for PFSAWH_LOCATION_DIM';

COMMENT ON COLUMN gb_pfsawh_location_dim.geo_cd 
IS 'GEOGRAPHIC CODE - A code that represents a specific geographical location.';

COMMENT ON COLUMN gb_pfsawh_location_dim.st_cntry_name 
IS 'STATE OR COUNTRY NAME - The name of a specific U.S. state or the name of a specific, recognized country.';

COMMENT ON COLUMN gb_pfsawh_location_dim.geo_cd_desc 
IS 'The PFSA selected station code description used to describe the GEO_CD';

COMMENT ON COLUMN gb_pfsawh_location_dim.installation_name 
IS 'Name of installation if there is one associated with the location.';

COMMENT ON COLUMN gb_pfsawh_location_dim.city_name 
IS 'Name of city or town covered by this location.';

COMMENT ON COLUMN gb_pfsawh_location_dim.county_name 
IS 'Name of US county covered by this location.';

COMMENT ON COLUMN gb_pfsawh_location_dim.state_code 
IS '2-character US state code that this location is found in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.state_name 
IS 'Name of US state that this location is found in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.province_name 
IS 'If applicable, name of foreign country province this location in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.country_name 
IS 'Name of country this location is in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.iso_3166_2_numeric
IS 'ISO 3166-2 is the second part of the ISO 3166 standard published by the International Organization for Standardization (ISO). It is a geocode system created for coding the names of country subdivisions and dependent areas. The purpose of the standard is to establish a worldwide series of short abbreviations for places, for use on package labels, containers, and such; anywhere where a short alphanumeric code can serve to clearly indicate a location in a more convenient and less ambiguous form than the full place name.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.iso_3166_1_alpha_2
IS 'ISO 3166-1, as part of the ISO 3166 standard, provides codes for the names of countries and dependent territories, and is published by the International Organization for Standardization (ISO).  ISO 3166-1 alpha-2, a two-letter system, used in many applications, most prominently for country code top-level domains (ccTLDs), with some exceptions.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.iso_3166_1_alpha_3
IS 'ISO 3166-1, as part of the ISO 3166 standard, provides codes for the names of countries and dependent territories, and is published by the International Organization for Standardization (ISO).  ISO 3166-1 alpha-3, a three-letter system, which allows a better visual association between country name and code element than the alpha-2 code.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.iso_3166_1_numeric
IS 'ISO 3166-1, as part of the ISO 3166 standard, provides codes for the names of countries and dependent territories, and is published by the International Organization for Standardization (ISO).  ISO 3166-1 numeric, a three-digit numerical system, with the advantage of script (writing system) independence, and hence useful for people or systems which uses a non-Latin script. This is identical to codes defined by the United Nations Statistics Division.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.zip_code 
IS 'Postal zip code.';

COMMENT ON COLUMN gb_pfsawh_location_dim.theater_name 
IS 'Name of theater this location is in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.time_zone_region_code 
IS '3-charter time zone region code.';

COMMENT ON COLUMN gb_pfsawh_location_dim.time_zone_region_zulu_offset
IS 'Numeric offset from Zulu/Greenwiche mean time.';

COMMENT ON COLUMN gb_pfsawh_location_dim.time_zone_region_desc 
IS 'Time zone region description.';

COMMENT ON COLUMN gb_pfsawh_location_dim.installation_type_code 
IS 'Installation type code.';

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_st_cntry_name 
IS 'STATE OR COUNTRY NAME - The name of a specific U.S. state or the name of a specific, recognized country.';

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_geo_cd_desc 
IS 'The PFSA selected station code description used to describe the GEO_CD';
 
COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_installation_name 
IS 'Name of installation if there is one associated with the location.';

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_city_name 
IS 'Name of city or town covered by this location.';

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_province_name 
IS 'If applicable, name of foreign country province this location in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_country_name 
IS 'Name of country this location is in.';

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_iso_3166_2_numeric
IS 'ISO 3166-2 is the second part of the ISO 3166 standard published by the International Organization for Standardization (ISO). It is a geocode system created for coding the names of country subdivisions and dependent areas. The purpose of the standard is to establish a worldwide series of short abbreviations for places, for use on package labels, containers, and such; anywhere where a short alphanumeric code can serve to clearly indicate a location in a more convenient and less ambiguous form than the full place name.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_iso_3166_1_alpha_2
IS 'ISO 3166-1, as part of the ISO 3166 standard, provides codes for the names of countries and dependent territories, and is published by the International Organization for Standardization (ISO).  ISO 3166-1 alpha-2, a two-letter system, used in many applications, most prominently for country code top-level domains (ccTLDs), with some exceptions.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_iso_3166_1_alpha_3
IS 'ISO 3166-1, as part of the ISO 3166 standard, provides codes for the names of countries and dependent territories, and is published by the International Organization for Standardization (ISO).  ISO 3166-1 alpha-3, a three-letter system, which allows a better visual association between country name and code element than the alpha-2 code.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.cipher_iso_3166_1_numeric
IS 'ISO 3166-1, as part of the ISO 3166 standard, provides codes for the names of countries and dependent territories, and is published by the International Organization for Standardization (ISO).  ISO 3166-1 numeric, a three-digit numerical system, with the advantage of script (writing system) independence, and hence useful for people or systems which uses a non-Latin script. This is identical to codes defined by the United Nations Statistics Division.'; 

COMMENT ON COLUMN gb_pfsawh_location_dim.status 
IS 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_location_dim.updt_by 
IS 'The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsawh_location_dim.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsawh_location_dim.active_flag 
IS 'Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsawh_location_dim.active_date 
IS 'Additional control for active_Flag indicating when the record became active.';

COMMENT ON COLUMN gb_pfsawh_location_dim.inactive_date 
IS 'Additional control for active_Flag indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsawh_location_dim.insert_by 
IS 'Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsawh_location_dim.insert_date 
IS 'Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsawh_location_dim.update_by 
IS 'Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsawh_location_dim.update_date 
IS 'Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsawh_location_dim.delete_flag 
IS 'Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsawh_location_dim.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsawh_location_dim.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsawh_location_dim.hidden_date 
IS 'Additional control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_location_dim'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM   user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_location_dim') 
    AND a.column_name = b.column_name
WHERE   a.table_name = UPPER('gb_pfsawh_location_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
/*--------------------------------- Populate ---------------------------------*/

DECLARE

CURSOR code_cur IS
SELECT a.geo_ID, a.geo_cd, a.geo_cd_DESC
FROM gb_pfsawh_location_dim a
ORDER BY a.geo_cd;

code_rec    code_cur%ROWTYPE;

BEGIN 

    DELETE gb_pfsawh_location_dim;

    INSERT 
    INTO   gb_pfsawh_location_dim 
        (
        geo_id,
        geo_cd,
        st_cntry_name,
        geo_cd_desc, 
        lst_updt,
        updt_by
        )
    SELECT 
        fn_pfsawh_get_dim_identity('gb_pfsawh_location_dim'),
        geo_cd,
        st_cntry_name,
        geo_cd_desc, 
        lst_updt,
        updt_by
    FROM    pfsa_geo_dim
    ORDER BY geo_id;

    UPDATE gb_pfsawh_location_dim geo
    SET ( state_code, state_name, country_name ) = 
        (
        SELECT l.loc_cd, l.loc_cd_desc, 'UNITED STATES' 
        FROM   loc_ref@pfsawh.lidbdev l
        WHERE  l.loc_cd_desc = geo.st_cntry_name 
            AND UPPER(l.loc_cd) IN ('AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
                                    'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 
                                    'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 
                                    'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                                    'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY') 
        );

    UPDATE gb_pfsawh_location_dim 
    SET    city_name = SUBSTR(geo_cd_desc, 1, INSTR(geo_cd_desc, ',')-1)
    WHERE  ( geo_cd_desc LIKE '%, CTY' )
    AND country_name = 'UNITED STATES';

    UPDATE gb_pfsawh_location_dim  
    SET    INSTALLATION_NAME = SUBSTR(geo_cd_desc, 1, INSTR(geo_cd_desc, ',')-1)
    WHERE  ( geo_cd_desc LIKE '%TRAINING CENTER%' OR geo_cd_desc LIKE '%, CAP' OR geo_cd_desc LIKE '%INSTALLATION%' 
        OR geo_cd_desc LIKE '%AIRPORT%' OR geo_cd_desc LIKE '%AIR FIELD%' OR geo_cd_desc LIKE '%NAVAL AIR%' 
        OR geo_cd_desc LIKE '%STORAGE%' OR geo_cd_desc LIKE '%ENGINEERS%' OR geo_cd_desc LIKE '%ANNEX%' 
        OR geo_cd_desc LIKE '%COMMUNICATION%' OR geo_cd_desc LIKE '%ACADEMY%'OR geo_cd_desc LIKE '%DEPOT%' 
        OR geo_cd_desc LIKE '%ADMINISTRAT%' OR geo_cd_desc LIKE '%HOSPITAL%' OR geo_cd_desc LIKE '%AFS%' 
        OR geo_cd_desc LIKE '%RADIO RELAY%' OR geo_cd_desc LIKE '%CEMETERY%' OR geo_cd_desc LIKE '%FACILITY%' )
        AND country_name = 'UNITED STATES';

    UPDATE gb_pfsawh_location_dim 
    SET    city_name = SUBSTR(geo_cd_desc, 1, INSTR(geo_cd_desc, ',')-1), 
           country_name = SUBSTR(geo_cd_desc, INSTR(geo_cd_desc, ',')+2, INSTR(geo_cd_desc, ',', 1, 2) - INSTR(geo_cd_desc, ',')-2) 
    WHERE  geo_cd_desc LIKE '%, CTY'
        AND country_name IS NULL;

    UPDATE gb_pfsawh_location_dim 
    SET    installation_name = SUBSTR(geo_cd_desc, 1, INSTR(geo_cd_desc, ',')-1), 
           country_name = st_cntry_name  
    WHERE  ( geo_cd_desc LIKE '%OPERATING AREA%' OR geo_cd_desc LIKE '%OPERATING AREA' ); 

    UPDATE gb_pfsawh_location_dim 
    SET    installation_name = SUBSTR(geo_cd_desc, 1, INSTR(geo_cd_desc, ',')-1), 
           country_name = SUBSTR(geo_cd_desc, INSTR(geo_cd_desc, ',')+2, INSTR(geo_cd_desc, ',', 1, 2) - INSTR(geo_cd_desc, ',')-2) 
    WHERE  ( geo_cd_desc LIKE '%, APT' OR geo_cd_desc LIKE '%, IAP' OR geo_cd_desc LIKE '%INSTALLATION%' 
          OR geo_cd_desc LIKE '%AIRPORT%' OR geo_cd_desc LIKE '%AIR BASE%' OR geo_cd_desc LIKE '%AIR FIELD%' 
          OR geo_cd_desc LIKE '%AIRBASE%' OR geo_cd_desc LIKE '%PRT%'  OR geo_cd_desc LIKE '%EXCHANGE%' 
          OR geo_cd_desc LIKE '%HELIPORT%' OR geo_cd_desc LIKE '%SERVICE CENTER%' OR geo_cd_desc LIKE '%HOSPITAL%' 
          OR geo_cd_desc LIKE '%POL RETAIL DIST%' OR geo_cd_desc LIKE '%, APS%' OR geo_cd_desc LIKE '%FAMILY HOUSING%' 
          OR geo_cd_desc LIKE '% HOTEL%' OR geo_cd_desc LIKE '%COMPLEX%' OR geo_cd_desc LIKE '%STORAGE%' 
          OR geo_cd_desc LIKE '%PUMP STATION%' OR geo_cd_desc LIKE '%ADMINISTRATION%' OR geo_cd_desc LIKE '%DEPOT%' 
          OR geo_cd_desc LIKE '%, AFS' OR geo_cd_desc LIKE '%APO%' OR geo_cd_desc LIKE '%FACILITY%' 
          OR geo_cd_desc LIKE '% ANNEX%' OR geo_cd_desc LIKE '%AMMUNITION%' OR geo_cd_desc LIKE '%SUPPLY%' 
          OR geo_cd_desc LIKE '%TRAINING%' OR geo_cd_desc LIKE '%RADIO RELAY%' OR geo_cd_desc LIKE '%BARRACKS%' 
          OR geo_cd_desc LIKE '%COMMUNICATION%' OR geo_cd_desc LIKE '%SCHOOL%' OR geo_cd_desc LIKE '%MISSILE STATION%' 
          OR geo_cd_desc LIKE '%OFFICERS%' OR geo_cd_desc LIKE '%NAVAL AIR%' OR geo_cd_desc LIKE '%AIR FORCE%' 
          OR geo_cd_desc LIKE 'CAMP %' )
          AND country_name IS NULL;

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
    
        FETCH code_cur 
        INTO    code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE(code_rec.geo_ID || ', ' || code_rec.geo_cd || ', ' || code_rec.geo_cd_DESC);
    
    END LOOP;
    
    CLOSE code_cur;

END;  

-- COMMIT    

/*

SELECT  geo.* 
FROM    gb_pfsawh_location_dim geo
--    WHERE     country IS NULL AND    installation IS NULL 
--    WHERE     country = 'UNITED STATES' 
ORDER BY geo.geo_cd; 

*/

/* 

SELECT    * 
FROM    loc_ref@pfsawh.lidbdev 

SELECT geo.geo_id, geo_cd, st_cntry_name, geo_cd_desc, 
    l.loc_cd, loc_cd_desc, geo.* 
FROM   gb_pfsawh_location_dim geo, 
       loc_ref@pfsawh.lidbdev l
WHERE    geo.st_cntry_name = l.loc_cd_desc 

SELECT  geo_cd_desc, 
        INSTR(geo_cd_desc, ','), 
        SUBSTR(geo_cd_desc, 1, INSTR(geo_cd_desc, ',')-1), 
        INSTR(geo_cd_desc, ',', 1, 2),
        SUBSTR(geo_cd_desc, INSTR(geo_cd_desc, ',')+2, INSTR(geo_cd_desc, ',', 1, 2) - INSTR(geo_cd_desc, ',')-2) 
FROM    gb_pfsawh_location_dim geo 
WHERE   geo_cd_desc LIKE '%, CTY'

*/

