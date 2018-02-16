/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_force_unit_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: PFSAWH_FORCE_UNIT_DIM.sql 
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

-- DROP SEQUENCE pfsawh_force_unit_dim_seq;

CREATE SEQUENCE pfsawh_force_unit_dim_seq
    START WITH 1000000
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create table -----*/

-- DROP TABLE pfsawh_force_unit_dim;

CREATE TABLE pfsawh_force_unit_dim 
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
    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
    wh_record_status                 VARCHAR2(10),
    wh_effective_date                DATE,
    wh_expiration_date               DATE,
--
    insert_by                        VARCHAR2(30)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(30)        NULL ,
    wh_last_update_date              DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_by                        VARCHAR2(30)        NULL ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_by                        VARCHAR2(30)        NULL 
) 
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             32K
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

COMMENT ON TABLE pfsawh_force_unit_dim 
IS 'PFSAWH_FORCE_UNIT_DIM - The force_unit_dim table contains one row for every UIC (Current or Historical) that has been transmitted to LOGSA via the asorts data feed from FORSCOM.  Each row contains various descriptive information about the UIC.';   

COMMENT ON COLUMN pfsawh_force_unit_dim.rec_id 
IS 'REC_ID - Sequence/identity for dimension.'; 

COMMENT ON COLUMN pfsawh_force_unit_dim.force_unit_id 
IS 'FORCE_UNIT_ID - Primary, blind key of the pfsawh_force_unit_dim table.'; 

COMMENT ON COLUMN pfsawh_force_unit_dim.uic 
IS 'UIC - UNIT IDENTIFICATION CODE (UIC) - A six-position, alphanumeric code that uniquely identifies a Department of Defense (DOD) organization as a "unit."  Each unit of the Active Army, Army Reserve, and Army National Guard is identified by a UIC.  The UIC is issued by the HQDA DCSOPS.  The UICs assigned parent unit is defined by HQDA and may be recognized by "AA" in the last two characters of the UIC.  UICs are constructed as follows:  Position 1 = Service Designator (all Army UICs start with a W); Positions 2 - 4 = Parent Organization Designator; Positions 5 - 6 = Descriptive Designator.  (UIC codes are prescribed by JCS Publication 6, AR 310-49, and AR 525-10.)'; 

COMMENT ON COLUMN pfsawh_force_unit_dim.unit_description 
IS 'unit_description - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.force_parent_unit_id 
IS 'FORCE_PARENT_UNIT_ID - .'; 

COMMENT ON COLUMN pfsawh_force_unit_dim.component_code 
IS 'component_code - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.component_description 
IS 'component_description - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.homestation_state_or_country 
IS 'homestation_state_or_country - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.d_date 
IS 'd_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.r_date 
IS 'r_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.s_date 
IS 's_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.edd1_date 
IS 'edd1_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.edd2_date 
IS 'edd2_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.mre_date 
IS 'mre_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.dodaac 
IS 'dodaac - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.ari_list_ref_date 
IS 'ari_list_ref_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.unit_in_reset 
IS 'unit_in_reset - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.sorts_uic_status 
IS 'sorts_uic_status - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.macom 
IS 'macom - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_force_unit_dim_id 
IS 'bct_force_unit_dim_id - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct 
IS 'bct - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_description 
IS 'bct_description - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_icon 
IS 'bct_icon - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_levels 
IS 'bct_levels - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_tree_level 
IS 'bct_tree_level - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_uic_is_leaf 
IS 'bct_uic_is_leaf - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_d_date 
IS 'bct_d_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_r_date 
IS 'bct_r_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_s_date 
IS 'bct_s_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_edd1_date 
IS 'bct_edd1_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_edd2_date 
IS 'bct_edd2_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.bct_mre_date 
IS 'bct_mre_date - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.uto_force_unit_dim_id 
IS 'uto_force_unit_dim_id - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.uto_unit_description 
IS 'uto_unit_description - '; 

COMMENT ON COLUMN pfsawh_force_unit_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsawh_force_unit_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_force_unit_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_force_unit_dim.active_flag  
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_force_unit_dim.wh_record_status 
IS 'WH_RECORD_STATUS - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_force_unit_dim.wh_effective_date 
IS 'WH_EFFECTIVE_DATE - Additional control for ACTIVE_FL indicating when the record became active.';

COMMENT ON COLUMN pfsawh_force_unit_dim.wh_expiration_date 
IS 'WH_EXPIRATION_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_force_unit_dim.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_force_unit_dim.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_force_unit_dim.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_force_unit_dim.wh_last_update_date 
IS 'WH_LAST_UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_force_unit_dim.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_force_unit_dim.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_force_unit_dim.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_force_unit_dim.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_force_unit_dim'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_force_unit_dim') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_force_unit_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%d_date%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%unit_desc%'); 
   
/*----- Constraints - Primary Key -----*/ 

ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT pk_pfsawh_force_unit_dim;        

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT pk_pfsawh_force_unit_dim 
    PRIMARY KEY 
    (
    rec_id
    );    

/*----- Constraints - Unique Key -----*/ 

ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT pk_pfsawh_force_unit_dim;        

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT pk_pfsawh_force_unit_dim 
    UNIQUE 
    (
    rec_id
    );    

/*----- Constraints -----*/ 

ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT ck_pfsawh_force_unt_dim_act_fl;        

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT ck_pfsawh_force_unt_dim_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT ck_pfsawh_force_unt_dim_del_fl;        

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT ck_pfsawh_force_unt_dim_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT ck_pfsawh_force_unt_dim_hid_fl;       

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT ck_pfsawh_force_unt_dim_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT ck_pfsawh_force_unt_dim_status;        

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT ck_pfsawh_force_unt_dim_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Constraints - Foreign Key -----*/
/*
ALTER TABLE pfsawh_force_unit_dim  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE pfsawh_force_unit_dim  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);
*/
/*----- Indexs -----*/

DROP INDEX ixu_pfsawh_force_unit_dim;

CREATE UNIQUE INDEX ixu_pfsawh_force_unit_dim 
    ON pfsawh_force_unit_dim
    (
    uic, 
    wh_effective_date
    );

DROP INDEX ix_pfsawh_force_unt_dim_unt_id;

CREATE INDEX ix_pfsawh_force_unt_dim_unt_id 
    ON pfsawh_force_unit_dim
    (
    force_unit_id
    );

/*----- Create the Trigger now -----*/

/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM pfsawh_force_unit_dim FOR pfsawh.pfsawh_force_unit_dim; 

/*----- Grants-----*/

GRANT SELECT ON pfsawh_force_unit_dim TO LIW_BASIC; 

GRANT SELECT ON pfsawh_force_unit_dim TO LIW_RESTRICTED; 

GRANT SELECT ON pfsawh_force_unit_dim TO S_PFSAW; 

-- GRANT SELECT ON pfsawh_force_unit_dim TO MD2L043; 

-- GRANT SELECT ON pfsawh_force_unit_dim TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON pfsawh_force_unit_dim TO S_PBUSE; 

-- GRANT SELECT ON pfsawh_force_unit_dim TO S_WEBPROP; 

GRANT SELECT ON pfsawh_force_unit_dim TO C_PFSAW; 

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DROP TABLE tmp_uic;

CREATE GLOBAL TEMPORARY TABLE tmp_uic 
    (
    uic     VARCHAR2(6) 
    )
ON COMMIT PRESERVE ROWS;
    
DECLARE

    CURSOR code_cur IS
        SELECT a.rec_id, a.uic
        FROM pfsawh_force_unit_dim a
        ORDER BY a.uic;
        
    code_rec    code_cur%ROWTYPE; 
    
    v_LoopCnt   NUMBER; 
    v_force_id  pfsawh_identities.last_dimension_identity%TYPE; 
    v_uic       pfsawh_force_unit_dim.uic%TYPE; 
        
BEGIN 

    DELETE tmp_uic;  
    
--    DELETE pfsawh_force_unit_dim;  
    
    COMMIT; 
    
--    INSERT 
--    INTO pfsawh_force_unit_dim 
--        (
----        rec_id,
----        force_unit_id,
--        uic, 
--        unit_description, 
--        component_code,
--        component_description,
--        homestation_state_or_country,
--        d_date,
--        r_date,
--        s_date,
--        edd1_date,
--        edd2_date,
--        mre_date,
--        dodaac,
--        ari_list_ref_date,
--        unit_in_reset,
--        sorts_uic_status,
--        macom,
---- 
--        bct_force_unit_dim_id,
--        bct,
--        bct_description,
--        bct_icon,
--        bct_levels,
--        bct_tree_level, 
--        bct_uic_is_leaf,
--        bct_d_date,
--        bct_r_date,
--        bct_s_date,
--        bct_edd1_date,
--        bct_edd2_date,
--        bct_mre_date,
----    
--        wh_effective_date
--        ) 
--    SELECT 
--        fd.uic, 
--        fd.unit_description, 
--        fd.component_code,
--        fd.component_description,
--        fd.homestation_state_or_country,
--        fd.d_date,
--        fd.r_date,
--        fd.s_date,
--        fd.edd1_date,
--        fd.edd2_date,
--        fd.mre_date,
--        fd.dodaac,
--        fd.ari_list_ref_date,
--        fd.unit_in_reset,
--        fd.sorts_uic_status,
--        fd.macom,
----         
--        fd.bct_force_dim_id,
--        fd.bct,
--        fd.bct_description,
--        fd.bct_icon,
--        fd.bct_levels,
--        fd.tree_level, 
--        fd.uic_is_leaf,
--        fd.bct_d_date,
--        fd.bct_r_date,
--        fd.bct_s_date,
--        fd.bct_edd1_date,
--        fd.bct_edd2_date,
--        fd.bct_mre_date,
----    
--        fd.wh_effective_date 
--    FROM   forcewh.bct_force_dim fd; 
    
    COMMIT; 
    
--    MERGE 
--    INTO  pfsawh_force_unit_dim fu
--    USING ( 
--          SELECT uto_force_dim_id, 
--              uic, 
--              unit_description, 
--              wh_effective_date, 
--              wh_expiration_date, 
--              wh_record_status, 
--              wh_last_update_date
--          FROM forcewh.uto_force_dim 
--          WHERE UPPER(wh_record_status) = 'CURRENT'
--          ) uto 
--    ON (fu.uic = uto.uic) 
--    WHEN MATCHED THEN 
--        UPDATE 
--        SET    uto_force_unit_dim_id = uto.uto_force_dim_id, 
--               uto_unit_description  = uto.unit_description
--    WHEN NOT MATCHED THEN 
--        INSERT 
--            (
--            fu.uto_force_unit_dim_id, 
--            fu.uic, 
--            fu.unit_description, 
--            fu.wh_effective_date, 
--            fu.wh_expiration_date, 
--            fu.wh_record_status, 
--            fu.wh_last_update_date
--            )
--        VALUES 
--            (
--            uto.uto_force_dim_id, 
--            uto.uic, 
--            uto.unit_description, 
--            uto.wh_effective_date, 
--            uto.wh_expiration_date, 
--            uto.wh_record_status, 
--            uto.wh_last_update_date
--            ); 
            
    COMMIT;
    
    INSERT 
    INTO     tmp_uic 
        (
        uic
        )
    SELECT 
    DISTINCT uic
    FROM   pfsawh_force_unit_dim 
    WHERE  force_unit_id < 1
    ORDER BY uic; 
    
    SELECT COUNT(uic)
    INTO   v_LoopCnt  
    FROM   tmp_uic; 
    
    WHILE v_LoopCnt > 0 
    LOOP 
    
        SELECT uic 
        INTO   v_uic 
        FROM   tmp_uic 
        WHERE  ROWNUM = 1; 
            
        v_force_id := fn_pfsawh_get_dim_identity('pfsawh_force_unit_dim');
            
        UPDATE pfsawh_force_unit_dim 
        SET    force_unit_id = v_force_id 
        WHERE  uic = v_uic; 
        
        DELETE tmp_uic 
        WHERE  uic = v_uic; 
        
        COMMIT; 
    
        SELECT COUNT(uic)
        INTO   v_LoopCnt  
        FROM   tmp_uic; 
    
    END LOOP; -- v_LoopCnt 
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND
           OR code_cur%ROWCOUNT > 1000;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.rec_id || ', ' || code_rec.uic  
--            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  

/*

    MERGE 
    INTO  pfsawh_force_unit_dim fu 
    USING ( 
          SELECT    pfsa_org,
                    day_date_from,
                    day_date_thru,
                    uic,
                    derived_unt_desc,
                    macom,
                    tpsn,
                    branch,
                    parent_org ,
                    cmd_uic,
                    parent_uic,
                    geo_cd,
                    comp_cd,
                    lst_updt,
                    updt_by,
                    goof_uic_ind 
          FROM pfsa_org_hist@pfsaw.lidb  
          WHERE day_date_thru = TO_DATE('31-Dec-4712', 'dd-mon-yyyy') 
              AND LENGTH(pfsa_org) = 6 
              AND UIC IS NOT NULL 
              AND UIC <> 'UNKNWN' 
          ) poh 
    ON (fu.uic = poh.uic 
        AND fu.wh_effective_date = poh.day_date_from ) 
    WHEN MATCHED THEN 
        UPDATE 
        SET fu.pfsa_org = poh.pfsa_org ,
--            fu.wh_effective_date = poh.day_date_from ,
            fu.wh_expiration_date = poh.day_date_thru ,
--            fu.uic = poh.uic ,
            fu.unit_description = poh.derived_unt_desc ,
            fu.macom = poh.macom ,
            fu.pfsa_tpsn = poh.tpsn ,
            fu.pfsa_branch = poh.branch ,
            fu.pfsa_parent_org = poh.parent_org ,
            fu.pfsa_cmd_uic = poh.cmd_uic ,
            fu.pfsa_parent_uic = poh.parent_uic ,
            fu.pfsa_geo_cd = poh.geo_cd ,
            fu.pfsa_comp_cd = poh.comp_cd ,
            fu.lst_updt = poh.lst_updt ,
            fu.updt_by = poh.updt_by ,
            fu.pfsa_goof_uic_ind = poh.goof_uic_ind  
    WHEN NOT MATCHED THEN 
        INSERT 
            ( 
            fu.pfsa_org,
            fu.wh_effective_date,
            fu.wh_expiration_date,
            fu.uic,
            fu.unit_description,
            fu.macom,
            fu.pfsa_tpsn,
            fu.pfsa_branch,
            fu.pfsa_parent_org,
            fu.pfsa_cmd_uic,
            fu.pfsa_parent_uic,
            fu.pfsa_geo_cd,
            fu.pfsa_comp_cd,
            fu.lst_updt,
            fu.updt_by,
            fu.pfsa_goof_uic_ind 
            ) 
        VALUES 
            (
            poh.pfsa_org ,
            poh.day_date_from ,
            poh.day_date_thru ,
            poh.uic ,
            poh.derived_unt_desc ,
            poh.macom ,
            poh.tpsn ,
            poh.branch ,
            poh.parent_org ,
            poh.cmd_uic ,
            poh.parent_uic ,
            poh.geo_cd ,
            poh.comp_cd ,
            poh.lst_updt ,
            poh.updt_by ,
            poh.goof_uic_ind  
            ); 

*/

/*

SELECT   
--        pfsa_org,
        day_date_from,
--        day_date_thru,
        uic,
--        derived_unt_desc,
 --       macom,
--        tpsn,
--        branch,
--        parent_org ,
--        cmd_uic,
--        parent_uic,
--        geo_cd,
--        comp_cd,
--        lst_updt,
--        updt_by,
--        goof_uic_ind,
          COUNT(uic) 
FROM pfsa_org_hist@pfsaw.lidb  
WHERE day_date_thru = TO_DATE('31-Dec-4712', 'dd-mon-yyyy') 
      AND LENGTH(pfsa_org) = 6 
      AND UIC IS NOT NULL  
GROUP BY uic, day_date_from
ORDER BY COUNT(uic) DESC; 
*/ 
    
/*

SELECT fu.status, fu.* 
FROM   pfsawh_force_unit_dim fu 
WHERE  fu.WH_EXPIRATION_DATE = TO_DATE('31-DEC-4712', 'dd-mon-yyyy')
ORDER BY fu.rec_id DESC, fu.uic, fu.wh_effective_date; 

UPDATE pfsawh_force_unit_dim  
SET    status = 'C'  
WHERE  WH_EXPIRATION_DATE = TO_DATE('31-DEC-4712', 'dd-mon-yyyy'); 

COMMIT;

ROLLBACK;

*/ 


/*

SELECT sn.item_niin, sn.physical_item_id,  
    sn.item_serial_number, sn.physical_item_sn_id, 
    sn.mimosa_item_sn_id, 
    sn.item_force_id
FROM pfsawh_item_sn_dim sn
WHERE sn.item_serial_number NOT IN ('AGGREGATE') 
    AND sn.item_niin IN ('013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' )
ORDER BY sn.item_niin, sn.item_serial_number;


UPDATE pfsawh_item_sn_bld_fact b
SET    physical_item_sn_id = 
        (
        SELECT 
        DISTINCT d.physical_item_sn_id 
        FROM   pfsawh_item_sn_dim d
        WHERE  b.s_pfsa_item_id = d.item_serial_number 
            AND b.s_sys_ei_niin = d.item_niin 
            AND d.status = 'C'
        )
WHERE b.s_sys_ei_sn NOT IN ('AGGREGATE')  
    AND s_sys_ei_niin IN ('013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' ); 

COMMIT; 

UPDATE pfsawh_item_sn_bld_fact sn 
SET    item_force_unit_id = 
           (
           SELECT 
           DISTINCT force_unit_id 
           FROM   pfsawh_force_unit_dim  
           WHERE  sn.s_uic = uic 
           )  
WHERE sn.s_sys_ei_sn NOT IN ('AGGREGATE')  
    AND sn.s_sys_ei_niin IN ('013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' ); 
        
COMMIT;         


SELECT sn.s_sys_ei_niin , sn.s_sys_ei_sn, sn.physical_item_sn_id, 
    sn.s_uic, sn.s_pfsa_org, sn.item_force_unit_id, 
    sn.ITEM_BCT_FORCE_ID, sn.ITEM_UTO_FORCE_ID, sn.ITEM_TFB_FORCE_ID
    , sn.*    
FROM   pfsawh_item_sn_bld_fact sn 
WHERE sn.s_sys_ei_sn NOT IN ('AGGREGATE') 
    AND sn.s_sys_ei_niin IN ('013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' )
ORDER BY sn.s_sys_ei_niin, sn.s_sys_ei_sn;

SELECT item_force_id, p.status, p.*
FROM pfsawh_item_sn_p_fact p;  


SELECT * 
FROM   pfsa_org_hist@pfsaw.lidb; 



*/