/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_force_unit_mtoe_fact_sq;

CREATE SEQUENCE pfsawh_force_unit_mtoe_fact_sq
    START WITH 1000000
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_force_unit_mtoe_fact
--      PURPOSE:  
--
-- TABLE SOURCE: PFSAWH_FORCE_UNIT_MTOE_FACT.sql 
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 24 April 2008 
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
-- 24APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--

DROP TABLE pfsawh_force_unit_mtoe_fact;
	
CREATE TABLE pfsawh_force_unit_mtoe_fact 
(
    rec_id                           NUMBER              NOT NULL ,
--
    force_unit_id                    NUMBER              DEFAULT 0 ,
--    auth1_owner                            VARCHAR2(6)         NOT NULL ,
    physical_item_id                 NUMBER              DEFAULT 0 ,
--    auth1_lin                              VARCHAR2(6)         NOT NULL ,    
    date_from_id                     NUMBER              DEFAULT    10001 ,
    time_from_id                     NUMBER              DEFAULT    10001 ,
    date_to_id                       NUMBER              DEFAULT    64787,
    time_to_id                       NUMBER              DEFAULT    86401 ,
-- 
    auth1_eff_dt                     DATE                NOT NULL ,
    auth1_eff_dt_id                  NUMBER              DEFAULT 0 ,
    auth1_rqd_qty                    NUMBER ,
    auth1_auth_qty                   NUMBER ,
--    
    hr_asset_lst_updt                DATE ,
    hr_asset_lst_updt_id             NUMBER ,
    hr_asset_qty                     NUMBER , 
    hr_asset_qty_due_in              NUMBER ,
--    
    pfsa_lst_updt                    DATE ,
    pfsa_lst_updt_id                 NUMBER ,
    pfsa_item_count                  NUMBER , 
--    
    auth1_erc                        CHAR(1)             NOT NULL ,
    auth1_rmks                       VARCHAR2(3)         NOT NULL ,
    auth1_s_class                    VARCHAR2(10) ,
    auth1_type_auth_cd               VARCHAR2(2)         NOT NULL ,
    auth1_proj_cd                    VARCHAR2(3) ,
    auth1_para_no                    VARCHAR2(4)         NOT NULL ,
    auth1_comd_con_no                VARCHAR2(6) ,
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    source_rec_id                    NUMBER              DEFAULT 0 ,
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    lst_update_rec_id                NUMBER              DEFAULT 0 ,
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
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
            INITIAL          512K
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE pfsawh_force_unit_mtoe_fact 
IS 'PFSAWH_FORCE_UNIT_MTOE_FACT - '; 


COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.rec_id 
IS 'REC_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.force_unit_id 
IS 'FORCE_UNIT_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.date_from_id 
IS 'DATE_FROM_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.time_from_id 
IS 'TIME_FROM_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.date_to_id 
IS 'DATE_TO_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.time_to_id 
IS 'TIME_TO_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_eff_dt 
IS 'AUTH1_EFF_DT - EFF_DT - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_eff_dt_id 
IS 'AUTH1_EFF_DT_ID - EFF_DT_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_rqd_qty 
IS 'AUTH1_RQD_QTY - RQD_QTY - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_auth_qty 
IS 'AUTH1_AUTH_QTY - AUTH_QTY - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.hr_asset_lst_updt 
IS 'HR_ASSET_LST_UPDT - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.hr_asset_lst_updt_id 
IS 'HR_ASSET_LST_UPDT_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.hr_asset_qty 
IS 'HR_ASSET_QTY - QTY - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.hr_asset_qty_due_in 
IS 'HR_ASSET_QTY_DUE_IN - QTY_DUE_IN - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.pfsa_lst_updt 
IS 'PFSA_LST_UPDT - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.pfsa_lst_updt_id 
IS 'PFSA_LST_UPDT_ID - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.pfsa_item_count 
IS 'PFSA_ITEM_COUNT - ITEM_COUNT - item_days reported divided by days in the reporting period rounded or 1 if any part is missing.'; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_erc 
IS 'AUTH1_ERC - ERC - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_rmks 
IS 'AUTH1_RMKS - RMKS - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_s_class 
IS 'AUTH1_S_CLASS - S_CLASS - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_type_auth_cd 
IS 'AUTH1_TYPE_AUTH_CD - TYPE_AUTH_CD - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_proj_cd 
IS 'AUTH1_PROJ_CD - PROJ_CD - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_para_no 
IS 'AUTH1_PARA_NO - PARA_NO - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.auth1_comd_con_no 
IS 'AUTH1_COMD_CON_NO - COMD_CON_NO - '; 

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';
/*
COMMENT ON COLUMN pfsawh_force_dim.wh_record_status 
IS 'WH_RECORD_STATUS - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_force_dim.wh_effective_date 
IS 'WH_EFFECTIVE_DATE - Additional control for ACTIVE_FL indicating when the record became active.';

COMMENT ON COLUMN pfsawh_force_dim.wh_expiration_date 
IS 'WH_EXPIRATION_DATE - Additional control for active_Fl indicating when the record went inactive.';
*/
COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.source_rec_id
IS 'SOURCE_REC_ID - '; 
                    
COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.lst_update_rec_id
IS 'LST_UPDATE_REC_ID - '; 
                
COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';
/*
COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.wh_last_update_date 
IS 'WH_LAST_UPDATE_DATE - Reports when the record was last updated.';
*/
COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_force_unit_mtoe_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_force_unit_mtoe_fact'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_force_unit_mtoe_fact') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_force_unit_mtoe_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%ITEM_SYS_EI_ID%'); 

/*----- Primary Key -----*/ 

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT pk_pfsawh_force_unit_mtoe_fact;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT pk_pfsawh_force_unit_mtoe_fact 
    PRIMARY KEY 
    (
    force_unit_id, 
    physical_item_id, 
    date_from_id,
    time_from_id,
    auth1_erc, 
    auth1_rmks 
    );    
   
/*----- Unique Index -----*/ 

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT ixu1_pfsawh_force_unt_mtoe_fct;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT ixu1_pfsawh_force_unt_mtoe_fct 
    UNIQUE 
    (
    rec_id
    );    
   
/*----- Indexs -----*/

DROP INDEX ix1_pfsawh_force_unit_mtoe_fct;

CREATE INDEX ix1_pfsawh_force_unit_mtoe_fct 
    ON pfsawh_force_unit_mtoe_fact
    (
    force_unit_id, 
    physical_item_id
    );

DROP INDEX ix2_pfsawh_force_unit_mtoe_fct;

CREATE INDEX ix2_pfsawh_force_unit_mtoe_fct 
    ON pfsawh_force_unit_mtoe_fact
    (
    physical_item_id
    );

/*----- Foreign Key -----*/

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT fk1_pfsawh_futoe_phy_item_id;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT fk1_pfsawh_futoe_phy_item_id 
    FOREIGN KEY (physical_item_id) 
    REFERENCES pfsawh_item_dim(physical_item_id);
/*
ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT fk2_pfsawh_futoe_for_unit_id;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT fk2_pfsawh_futoe_for_unit_id 
    FOREIGN KEY (force_unit_id) 
    REFERENCES pfsawh_force_unit_dim(force_unit_id);
*/ 
/*----- Constraints -----*/

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_act_fl;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_del_fl;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_hide_fl;       

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    DROP CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_status;        

ALTER TABLE pfsawh_force_unit_mtoe_fact  
    ADD CONSTRAINT ck_pfsawh_force_unit_mtoe_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM pfsawh_force_unit_mtoe_fact FOR pfsawh.pfsawh_force_unit_mtoe_fact; 

/*----- Grants-----*/

GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO LIW_BASIC; 

GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO LIW_RESTRICTED; 

GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO S_PFSAW; 

-- GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO MD2L043; 

-- GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO S_PBUSE; 

-- GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO S_WEBPROP; 

GRANT SELECT ON pfsawh_force_unit_mtoe_fact TO C_PFSAW; 


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.rec_id, a.force_unit_id, a.physical_item_id, 
            a.date_from_id, a.time_from_id, 
            a.auth1_eff_dt_id, a.auth1_auth_qty, a.auth1_rqd_qty
        FROM pfsawh_force_unit_mtoe_fact a
        ORDER BY a.force_unit_id, a.physical_item_id, 
            a.date_from_id, a.time_from_id;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

/*    DELETE pfsawh_force_unit_mtoe_fact; 
    
    COMMIT; 

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '700', 'TC3307', 7, 7, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '123', 'U', '1', ' ', '700', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '700', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '000', 'U', '1', ' ', '700', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141148, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '000', 'U', '1', ' ', '700', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141148, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '700', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '123', 'U', '1', ' ', '700', 'TC3307', 5, 5, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141224, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '700', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29433, 141227, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '700', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--    (29433, 141227, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '700', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29443, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '300', 'TC3307', 11, 11, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29443, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '800', 'U', '1', ' ', '300', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29443, 141148, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '300', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29443, 141148, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '000', 'U', '1', ' ', '300', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29443, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '300', 'TC3307', 7, 7, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29523, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3407', 6, 6, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29523, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3407', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29523, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3407', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--    (29523, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3407', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--    (29523, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3407', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--    (29523, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3407', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29523, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3407', 6, 6, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29523, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3407', 6, 6, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29531, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '200', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29531, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '127', 'U', '1', ' ', '200', 'TC3307', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29531, 141143, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '127', 'U', '1', ' ', '200', 'TC3307', 14, 14, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29531, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '200', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29534, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '300', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29534, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '127', 'U', '1', ' ', '300', 'TC3307', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29534, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '300', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29534, 141223, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '300', 'TC3307', 12, 12, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29534, 141223, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '127', 'U', '1', ' ', '300', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29535, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '400', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29535, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '000', 'U', '1', ' ', '400', 'TC3307', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29535, 141143, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '000', 'U', '1', ' ', '400', 'TC3307', 5, 5, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29535, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '400', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29535, 141223, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '000', 'U', '1', ' ', '400', 'TC3307', 5, 5, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29536, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '500', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29536, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '127', 'U', '1', ' ', '500', 'TC3307', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29536, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '500', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29536, 141148, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '127', 'U', '1', ' ', '500', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29536, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '500', 'TC3307', 5, 5, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3307', 22, 22, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 303479, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 10, 10, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--   (29537, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--    (29537, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

--    Insert into pfsawh_force_unit_mtoe_fact
--    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
--    Values
--    (29537, 141132, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3307', 2, 2, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141139, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '000', 'U', '1', ' ', '100', 'TC3307', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141143, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '000', 'U', '1', ' ', '100', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141146, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141147, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '000', 'U', '1', ' ', '100', 'TC3307', 3, 3, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141148, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'B', '000', 'U', '1', ' ', '100', 'TC3307', 4, 4, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '000', 'U', '1', ' ', '100', 'TC3307', 17, 17, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141217, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'A', '127', 'U', '1', ' ', '100', 'TC3307', 5, 5, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    Insert into pfsawh_force_unit_mtoe_fact
    (force_unit_id, physical_item_id, auth1_EFF_DT, auth1_ERC, auth1_RMKS, auth1_S_CLASS, auth1_TYPE_AUTH_CD, auth1_PROJ_CD, auth1_PARA_NO, auth1_COMD_CON_NO, auth1_RQD_QTY, auth1_AUTH_QTY, STATUS, UPDT_BY, LST_UPDT)
    Values
    (29537, 141223, TO_DATE('03/17/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'P', '000', 'U', '1', ' ', '100', 'TC3307', 1, 1, 'C', 'newtaads.ctl', TO_DATE('04/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

    COMMIT; */
    
--    ROLLBACK; 

    UPDATE pfsawh_force_unit_mtoe_fact 
        SET date_from_id    = fn_date_to_date_id(auth1_EFF_DT),
            auth1_eff_dt_id = fn_date_to_date_id(auth1_EFF_DT),
            insert_by       = ''; 

    COMMIT; 
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.rec_id || ', ' || 
            code_rec.force_unit_id || ', ' || code_rec.physical_item_id || ', ' ||  
            code_rec.date_from_id || ', ' || code_rec.time_from_id || ', ' ||  
            code_rec.auth1_eff_dt_id || ', ' || 
            code_rec.auth1_auth_qty || ', ' || 
            code_rec.auth1_rqd_qty
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT pfumf.* 
FROM   pfsawh_force_unit_mtoe_fact pfumf 
WHERE  pfumf.force_unit_id = 29534 
ORDER BY pfumf.force_unit_id, pfumf.physical_item_id; 

*/

SELECT * 
FROM   gcssa_hr_asset@pfsawh.lidbdev gha 
WHERE  gha.uic = 'WJRZC0'
    AND SUBSTR(gha.nsn, 5, 9) = '013285964';  

SELECT gha.uic, gha.lin, gha.nsn, SUBSTR(gha.nsn, 5, 9) AS niin, 
    TO_DATE(gha.lst_updt, 'DD-Mon-YYYY') AS gha_lst_upd, 
    SUM(NVL(gha.qty, 0)) AS qty,  
    SUM(NVL(gha.qty_due_in, 0 )) AS qty_due, 
    SUM(NVL(pfumf.auth1_rqd_qty, 0)) AS auth1_rqd_qty
FROM   pfsawh_force_unit_mtoe_fact pfumf, 
       gcssa_hr_asset@pfsawh.lidbdev gha 
WHERE  gha.uic = 'WJRZC0'     -- pfumf.force_unit_id 
    AND SUBSTR(gha.nsn, 5, 9) = '013285964'   
    AND pfumf.force_unit_id = 29534     
    AND pfumf.physical_item_id = 141223     
    AND FN_PFSAWH_GET_ITEM_DIM_FIELD(pfumf.physical_item_id, 'NIIN') = SUBSTR(gha.nsn, 5, 9)    
    AND gha.uic IN (
        'WJR1T0', 
        'WJRXA0', 'WJRXT0', 
        'WJRYA0', 'WJRYB0', 'WJRYT0', 
        'WJR0F0', 
        'WJR2B0', 
        'WJRZA0', 'WJRZC0', 'WJRZD0', 'WJRZE0', 'WJRZT0', 
        'W6KRT0' )
    AND SUBSTR(gha.nsn, 5, 9) IN ( 
        '013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052', 
        '002234919' ) 
GROUP BY gha.uic, gha.lin, gha.nsn, SUBSTR(gha.nsn, 5, 9), TO_DATE(gha.lst_updt, 'DD-Mon-YYYY') 
ORDER BY gha.uic, gha.lin; 

 
