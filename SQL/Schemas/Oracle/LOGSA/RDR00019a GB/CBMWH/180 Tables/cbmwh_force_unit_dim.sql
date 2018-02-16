/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: cbmwh_force_unit_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_force_unit_dim.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 07 April 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 07APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE cbmwh_force_unit_dim_seq;

CREATE SEQUENCE cbmwh_force_unit_dim_seq
    START WITH 1000000
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create table -----*/

-- DROP TABLE cbmwh_force_unit_dim;

CREATE TABLE cbmwh_force_unit_dim 
(
    rec_id                           NUMBER              NOT NULL ,
--
    force_unit_id                    NUMBER              DEFAULT 0 ,
    uic                              VARCHAR2(6)         NOT NULL ,
    unit_description                 VARCHAR2(55),
    force_parent_unit_id             NUMBER              DEFAULT 0 ,
    geo_id                           NUMBER              DEFAULT 0 ,
    component_code                   VARCHAR2(1),
    component_description            VARCHAR2(50),
    homestation_state_or_country     VARCHAR2(20),
    d_date                           DATE,
    r_date                           DATE,
    s_date                           DATE,
    edd1_date                        DATE,
    edd2_date                        DATE,
    mre_date                         DATE,
    dodaac                           VARCHAR2(6),
    ari_list_ref_date                DATE,
    unit_in_reset                    VARCHAR2(12),
    sorts_uic_status                 VARCHAR2(1),
    macom                            VARCHAR2(10),
-- PFSA 
    pfsa_org                         VARCHAR2(32),
    pfsa_tpsn                        VARCHAR2(5),
    pfsa_branch                      VARCHAR2(2),
    pfsa_parent_org                  VARCHAR2(32),
    pfsa_cmd_uic                     VARCHAR2(6),
    pfsa_parent_uic                  VARCHAR2(6),
    pfsa_geo_cd                      VARCHAR2(4),
    pfsa_comp_cd                     VARCHAR2(1),
    pfsa_goof_uic_ind                VARCHAR2(1),    
-- BCT     
    bct_force_unit_dim_id            NUMBER,
    bct                              VARCHAR2(6),
    bct_description                  VARCHAR2(55),
    bct_icon                         VARCHAR2(30),
    bct_levels                       NUMBER,
    bct_tree_level                   VARCHAR2(6), 
    bct_uic_is_leaf                  VARCHAR2(3),
    bct_d_date                       DATE,
    bct_r_date                       DATE,
    bct_s_date                       DATE,
    bct_edd1_date                    DATE,
    bct_edd2_date                    DATE,
    bct_mre_date                     DATE,
-- UTO 
    uto_force_unit_dim_id            NUMBER,
    uto_unit_description             VARCHAR2(55),
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    grab_stamp                       VARCHAR2(30)        NULL ,
    proc_stamp                       VARCHAR2(30)        NULL ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'Y' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--    
    wh_data_source                   VARCHAR2(25),
    wh_effective_date                DATE,
    wh_expiration_date               DATE,
    wh_last_update_date              DATE                DEFAULT '01-JAN-1900' ,
    wh_record_status                 VARCHAR2(10),
--
    source_rec_id                    NUMBER              NOT NULL ,
    insert_by                        VARCHAR2(50)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    lst_update_rec_id                NUMBER              NOT NULL ,
    update_by                        VARCHAR2(50)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_by                        VARCHAR2(50)        NULL ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_by                        VARCHAR2(50)        NULL , 
    hidden_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900'  
) 
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             128K
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

COMMENT ON TABLE cbmwh_force_unit_dim 
IS 'CBMWH_FORCE_UNIT_DIM - The force_unit_dim table contains one row for every UIC (Current or Historical) that has been transmitted to LOGSA via the asorts data feed from FORSCOM.  Each row contains various descriptive information about the UIC.';   


COMMENT ON COLUMN cbmwh_force_unit_dim.rec_id 
IS 'REC_ID - Primary, blind key of the XX_PFSAWH_BLANK_DIM table.'; 

COMMENT ON COLUMN cbmwh_force_unit_dim.force_unit_id 
IS 'FORCE_UNIT_ID - Primary, blind key of the cbmwh_force_unit_dim table.'; 

COMMENT ON COLUMN cbmwh_force_unit_dim.uic 
IS 'UIC - UNIT IDENTIFICATION CODE (UIC) - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a "unit."  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UICs assigned parent unit is defined by HQDA and may be recognized by "AA" in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)'; 

COMMENT ON COLUMN cbmwh_force_unit_dim.unit_description 
IS 'unit_description - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.force_parent_unit_id 
IS 'FORCE_PARENT_UNIT_ID - .'; 

COMMENT ON COLUMN cbmwh_force_unit_dim.geo_id 
IS 'GEO_ID - .'; 

COMMENT ON COLUMN cbmwh_force_unit_dim.component_code 
IS 'component_code - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.component_description 
IS 'component_description - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.homestation_state_or_country 
IS 'homestation_state_or_country - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.d_date 
IS 'd_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.r_date 
IS 'r_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.s_date 
IS 's_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.edd1_date 
IS 'edd1_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.edd2_date 
IS 'edd2_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.mre_date 
IS 'mre_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.dodaac 
IS 'dodaac - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.ari_list_ref_date 
IS 'ari_list_ref_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.unit_in_reset 
IS 'unit_in_reset - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.sorts_uic_status 
IS 'sorts_uic_status - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.macom 
IS 'MACOM - MAJOR ARMY COMMAND CODE (MACOM) - Identifies the Major Command or Department of the Army Staff Agency.'; 

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_ORG 
IS 'PFSA_ORG - A generic identification of an organization.  Used to both accomodate non-DOD entities as well as ensuring invalid FORCE data is accomodated in joins to gather location/other force information.';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_TPSN 
IS 'PFSA_TPSN - TROOP PROGRAM SEQUENCE NUMBER (TPSN) - The Troop Program Sequence Number (TPSN) is a seven-character, numeric field with five basic positions and two positions for element sequence.  The TPSN is used to group units into an organizational structure.  For example, the TPSN identifies all units belonging to a division or brigade.';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_BRANCH 
IS 'PFSA_BRANCH - BRANCH UNIT CODE - Identifies the branch of the unit or claimant (for example, Aviation, Armored, Infantry, etc.).';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_PARENT_ORG 
IS 'PFSA_PARENT_ORG - The PFSA_ORG the organization is subordinate to.';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_CMD_UIC 
IS 'PFSA_CMD_UIC - The ''AA'' level uic to which derivative UICs belong.  The command UIC is generatlly a battalion.  Includes parent augmentees (''99'') level';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_PARENT_UIC 
IS 'PFSA_PARENT_UIC - The uic to which the pfsa_org is subordinate to.';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_GEO_CD 
IS 'PFSA_GEO_CD - GEOGRAPHIC CODE - A code that represents a specific geographical location.';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_COMP_CD 
IS 'PFSA_COMP_CD - COMPONENT CODE - ASORTS uses the following codes:  1 (Active Army), 3 (USAR), 2 (ARNG), and 6 (AWRP).  The component does not change if the unit is called to active duty from the Reserve or National Guard.';

COMMENT ON COLUMN cbmwh_force_unit_dim.PFSA_GOOF_UIC_IND 
IS 'PFSA_GOOF_UIC_IND - GOOF UIC INDICATOR - Determines if a UIC in the UIC table is a "goof" UIC.  It is either "Y" or null.';

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_force_unit_dim_id 
IS 'bct_force_unit_dim_id - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct 
IS 'bct - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_description 
IS 'bct_description - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_icon 
IS 'bct_icon - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_levels 
IS 'bct_levels - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_tree_level 
IS 'bct_tree_level - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_uic_is_leaf 
IS 'bct_uic_is_leaf - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_d_date 
IS 'bct_d_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_r_date 
IS 'bct_r_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_s_date 
IS 'bct_s_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_edd1_date 
IS 'bct_edd1_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_edd2_date 
IS 'bct_edd2_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.bct_mre_date 
IS 'bct_mre_date - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.uto_force_unit_dim_id 
IS 'uto_force_unit_dim_id - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.uto_unit_description 
IS 'uto_unit_description - '; 

COMMENT ON COLUMN cbmwh_force_unit_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN cbmwh_force_unit_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN cbmwh_force_unit_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN cbmwh_force_unit_dim.grab_stamp 
IS 'GRAB_STAMP - The date and time the record entered the PFSA world.  The actual value is the sysdate when the PFSA grab procedure that populated a PFSA table (BLD, POTENTIAL or production) table for the first time in PFSA.  When the record move from "BLD to POTENITAL" or "BLD to production" the grab_date does not change.';

COMMENT ON COLUMN cbmwh_force_unit_dim.proc_stamp 
IS 'PROC_STAMP - The date timestamp (sysdate) of the promotion action.  ie: "BLD to POTENITAL" or "BLD to production"';       

COMMENT ON COLUMN cbmwh_force_unit_dim.active_flag  
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN cbmwh_force_unit_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN cbmwh_force_unit_dim.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN cbmwh_force_unit_dim.wh_record_status 
IS 'WH_RECORD_STATUS - Flag indicating if the record is active or not.';

COMMENT ON COLUMN cbmwh_force_unit_dim.wh_last_update_date 
IS 'WH_LAST_UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN cbmwh_force_unit_dim.wh_effective_date 
IS 'WH_EFFECTIVE_DATE - Additional control for WH_RECORD_STATUS indicating when the record became active.';

COMMENT ON COLUMN cbmwh_force_unit_dim.wh_expiration_date 
IS 'WH_EXPIRATION_DATE - Additional control for WH_RECORD_STATUS indicating when the record went inactive.';

COMMENT ON COLUMN cbmwh_force_unit_dim.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN cbmwh_force_unit_dim.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN xx_pfsawh_blank_dim.lst_update_rec_id 
IS 'LST_UPDATE_REC_ID - Identifier to the last update record received from an outside source.';       

COMMENT ON COLUMN cbmwh_force_unit_dim.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN cbmwh_force_unit_dim.delete_by 
IS 'DELETE_BY - Reports who last deleted the record.';

COMMENT ON COLUMN cbmwh_force_unit_dim.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN cbmwh_force_unit_dim.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN cbmwh_force_unit_dim.hidden_by 
IS 'HIDDEN_BY - Reports who last hide the record.';       

COMMENT ON COLUMN cbmwh_force_unit_dim.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN cbmwh_force_unit_dim.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('cbmwh_force_unit_dim'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('cbmwh_force_unit_dim') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('cbmwh_force_unit_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@cbmwh.lidbdev a
WHERE  a.col_name LIKE UPPER('%d_date%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%unit_desc%'); 
   
/*----- Constraints - Primary Key -----*/ 

ALTER TABLE cbmwh_force_unit_dim  
    DROP CONSTRAINT pk_cbmwh_force_unit_dim;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT pk_cbmwh_force_unit_dim 
    PRIMARY KEY 
    (
    rec_id
    );    

/*----- Constraints - Unique Key -----*/ 

-- ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT pk_cbmwh_force_unit_dim;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT pk_cbmwh_force_unit_dim 
    UNIQUE 
    (
    rec_id
    );    

/*----- Constraints -----*/ 

-- ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT ck_cbmwh_force_unt_dim_act_fl;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT ck_cbmwh_force_unt_dim_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

-- ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT ck_cbmwh_force_unt_dim_del_fl;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT ck_cbmwh_force_unt_dim_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

-- ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT ck_cbmwh_force_unt_dim_hid_fl;       

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT ck_cbmwh_force_unt_dim_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

-- ALTER TABLE cbmwh_force_unit_dim  
--    DROP CONSTRAINT ck_cbmwh_force_unt_dim_status;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT ck_cbmwh_force_unt_dim_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Constraints - Foreign Key -----*/
/*
ALTER TABLE cbmwh_force_unit_dim  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE cbmwh_force_unit_dim  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);
*/
/*----- Indexs -----*/

-- DROP INDEX ixu_cbmwh_force_unit_dim;

CREATE UNIQUE INDEX ixu_cbmwh_force_unit_dim 
    ON cbmwh_force_unit_dim
    (
    uic, 
    wh_effective_date
    );

-- DROP INDEX ix_cbmwh_force_unt_dim_unt_id;

CREATE INDEX ix_cbmwh_force_unt_dim_unt_id 
    ON cbmwh_force_unit_dim
    (
    force_unit_id
    );

/*----- Create the Trigger now -----*/

/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM cbmwh_force_unit_dim FOR cbmwh.cbmwh_force_unit_dim; 

/*----- Grants-----*/

GRANT SELECT ON cbmwh_force_unit_dim TO LIW_BASIC; 

GRANT SELECT ON cbmwh_force_unit_dim TO LIW_RESTRICTED; 

GRANT SELECT ON cbmwh_force_unit_dim TO S_PFSAW; 

-- GRANT SELECT ON cbmwh_force_unit_dim TO MD2L043; 

-- GRANT SELECT ON cbmwh_force_unit_dim TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON cbmwh_force_unit_dim TO S_PBUSE; 

-- GRANT SELECT ON cbmwh_force_unit_dim TO S_WEBPROP; 

GRANT SELECT ON cbmwh_force_unit_dim TO C_PFSAW; 

