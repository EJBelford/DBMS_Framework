/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_force_unit_dim_seq;

CREATE SEQUENCE pfsawh_force_unit_dim_seq
    START WITH 1000000
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

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

DROP TABLE pfsawh_force_unit_dim;

CREATE TABLE pfsawh_force_unit_dim 
(
    rec_id                           NUMBER              NOT NULL ,
--
    force_unit_id                    NUMBER              DEFAULT 0 ,
    uic                              VARCHAR2(6)         NOT NULL ,
    unit_description                 VARCHAR2(55),
    force_parent_unit_id             NUMBER              DEFAULT 0 ,
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
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    wh_last_update_date              DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' 
) 
TABLESPACE PFSA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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
    
    DELETE pfsawh_force_unit_dim;  
    
    COMMIT; 
    
    INSERT 
    INTO pfsawh_force_unit_dim 
        (
--        rec_id,
--        force_unit_id,
        uic, 
        unit_description, 
        component_code,
        component_description,
        homestation_state_or_country,
        d_date,
        r_date,
        s_date,
        edd1_date,
        edd2_date,
        mre_date,
        dodaac,
        ari_list_ref_date,
        unit_in_reset,
        sorts_uic_status,
        macom,
-- 
        bct_force_unit_dim_id,
        bct,
        bct_description,
        bct_icon,
        bct_levels,
        bct_tree_level, 
        bct_uic_is_leaf,
        bct_d_date,
        bct_r_date,
        bct_s_date,
        bct_edd1_date,
        bct_edd2_date,
        bct_mre_date,
--    
        wh_effective_date
        ) 
    SELECT 
        fd.uic, 
        fd.unit_description, 
        fd.component_code,
        fd.component_description,
        fd.homestation_state_or_country,
        fd.d_date,
        fd.r_date,
        fd.s_date,
        fd.edd1_date,
        fd.edd2_date,
        fd.mre_date,
        fd.dodaac,
        fd.ari_list_ref_date,
        fd.unit_in_reset,
        fd.sorts_uic_status,
        fd.macom,
--         
        fd.bct_force_dim_id,
        fd.bct,
        fd.bct_description,
        fd.bct_icon,
        fd.bct_levels,
        fd.tree_level, 
        fd.uic_is_leaf,
        fd.bct_d_date,
        fd.bct_r_date,
        fd.bct_s_date,
        fd.bct_edd1_date,
        fd.bct_edd2_date,
        fd.bct_mre_date,
--    
        fd.wh_effective_date 
    FROM   forcewh.bct_force_dim fd; 
    
    COMMIT; 
    
    MERGE 
    INTO  pfsawh_force_unit_dim fu
    USING ( 
          SELECT uto_force_dim_id, 
              uic, 
              unit_description, 
              wh_effective_date, 
              wh_expiration_date, 
              wh_record_status, 
              wh_last_update_date
          FROM forcewh.uto_force_dim 
          WHERE UPPER(wh_record_status) = 'CURRENT'
          ) uto 
    ON (fu.uic = uto.uic) 
    WHEN MATCHED THEN 
        UPDATE 
        SET    uto_force_unit_dim_id = uto.uto_force_dim_id, 
               uto_unit_description  = uto.unit_description
    WHEN NOT MATCHED THEN 
        INSERT 
            (
            fu.uto_force_unit_dim_id, 
            fu.uic, 
            fu.unit_description, 
            fu.wh_effective_date, 
            fu.wh_expiration_date, 
            fu.wh_record_status, 
            fu.wh_last_update_date
            )
        VALUES 
            (
            uto.uto_force_dim_id, 
            uto.uic, 
            uto.unit_description, 
            uto.wh_effective_date, 
            uto.wh_expiration_date, 
            uto.wh_record_status, 
            uto.wh_last_update_date
            ); 
            
    COMMIT;
    
    INSERT 
    INTO     tmp_uic 
        (
        uic
        )
    SELECT 
    DISTINCT uic
    FROM   pfsawh_force_unit_dim
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

SELECT * 
FROM   pfsawh_force_unit_dim 
ORDER BY uic, wh_effective_date; 

ROLLBACK;

*/ 
