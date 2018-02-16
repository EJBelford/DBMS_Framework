DROP TABLE PFSAWH.pfsawh_item_dim;

/*
-- Added 06Mar08 to populate physical_item_id  

UPDATE pfsawh_item_dim 
SET    physical_item_id = item_id; 

COMMIT; 
*/ 

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: pfsawh_item_dim
--      PURPOSE: A major grouping End Items. 
--
-- TABLE SOURCE: pfsawh_item_dim.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 9 NOVEMBER 2007
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--	
--
CREATE TABLE pfsawh_item_dim
(
    rec_id                        NUMBER              NOT NULL,
    physical_item_id              NUMBER              DEFAULT 0,
    pfsa_subject_flag             VARCHAR2(1)         DEFAULT 'N',                          
-- National Item Identification Number    
    niin                          VARCHAR2(9)         DEFAULT 'unk',    
-- Line Item Number    
    lin                           VARCHAR2(6),                          
-- 'Model number'    
    army_type_designator          VARCHAR2(30)        DEFAULT 'unk',    
    item_nomen_short              VARCHAR2(35)        DEFAULT 'unk',
    item_nomen_standard           VARCHAR2(35)        DEFAULT 'unk',
    item_nomen_long               VARCHAR2(105)       DEFAULT 'unk',
    lin_active_date               DATE                DEFAULT '01-JAN-1900',
    lin_inactive_date             DATE                DEFAULT '31-DEC-2099',
    lin_inactive_statement        VARCHAR2(35)        DEFAULT 'not applicable',
    unit_price                    NUMBER(12, 2)       DEFAULT 0.00,
    unit_indicator                VARCHAR2(2)         DEFAULT '-1',
-- Federal Supply Classification 
    fsc                           VARCHAR2(4)         DEFAULT 'unk',     
-- National Stock Number    
    nsn                           VARCHAR2(13)        DEFAULT 'unk',    
-- End Item Code     
    eic_code                      VARCHAR2(3)         DEFAULT '-1',    
-- End Item Code     
    eic_model                     VARCHAR2(100)       DEFAULT 'unk',    
-- Equipment Category Code    
    ecc_code                      VARCHAR2(3)         DEFAULT '-1',                          
-- Equipment Category Code Description    
    ecc_desc                      VARCHAR2(100)       DEFAULT 'unk',     
-- Materiel Category Structure Code    
    mat_cat_cd_1_code             VARCHAR2(2),
    mat_cat_cd_1_desc             VARCHAR2(20),
    mat_cat_cd_2_code             VARCHAR2(2),
    mat_cat_cd_2_desc             VARCHAR2(250),
    mat_cat_cd_3_code             VARCHAR2(2),    
    mat_cat_cd_3_desc             VARCHAR2(20),    
    mat_cat_cd_4_code             VARCHAR2(2),    
    mat_cat_cd_4_desc             VARCHAR2(100),    
    mat_cat_cd_4_5_code           VARCHAR2(2),    
    mat_cat_cd_4_5_desc           VARCHAR2(200),    
-- Commercial And Government Entity
    cage_code                     VARCHAR2(5)         DEFAULT '-1',       
    cage_desc                     VARCHAR2(20)        DEFAULT 'unk',       
    chap                          VARCHAR2(1), 
-- Materiel Status Committee Record 
    mscr                          VARCHAR2(8), 
-- Unique IDentification Construct 1    
    uid1_desc                     VARCHAR2(15),                         
-- Unique IDentification Construct 2    
    uid2_desc                     VARCHAR2(19),   
-- Army Type Class Code                      
    type_class_cd                 VARCHAR2(2),                          
    type_class_cd_desc            VARCHAR2(20),    
    sb_700_20_publication_date    DATE,                   
--
--    anal_view                     VARCHAR2(40),
--    type_anal_view                VARCHAR2(20),    
--    slxn_grouping                 VARCHAR2(24),
--    slxn_sub_grouping             VARCHAR2(35),
--    
--    fleet_type_desc               VARCHAR2(40),
--    fleet_subtype_desc            VARCHAR2(40),
--    fleet_capability_desc         VARCHAR2(40),
--
-- Reportable Item Control Code
    ricc_item_code                VARCHAR2(2),                          
    aba                           VARCHAR2(2),
    sos                           VARCHAR2(3),
    ciic                          VARCHAR2(2), 
-- Condition Based Maintenance Flag     
    cbm_sensor_fl                 VARCHAR2(1)         DEFAULT 'N' ,     
--
    aircraft                      VARCHAR2(1),
    supply_class                  VARCHAR2(2),
    supply_class_desc             VARCHAR2(20),
    cl_of_supply_cd               VARCHAR2(2),
    cl_of_supply_cd_desc          VARCHAR2(20),
    subclass_of_supply_cd_desc    VARCHAR2(2),
--
    status                        VARCHAR2(1)         DEFAULT 'I' ,
    lst_updt                      DATE                DEFAULT sysdate ,
    updt_by                       VARCHAR2(20)        DEFAULT user ,
--
    active_flag                   VARCHAR2(1)         DEFAULT 'I' , 
    active_date                   DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                     VARCHAR2(20)        DEFAULT user , 
    insert_date                   DATE                DEFAULT sysdate , 
    update_by                     VARCHAR2(20)        NULL ,
    update_date                   DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                   DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                   VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                   DATE                DEFAULT '01-JAN-1900' 
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1G
            NEXT             256M
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

/*----- Primary Key -----*/

ALTER TABLE pfsawh_item_dim  
    DROP CONSTRAINT pk_pfsawh_item_dim_phy_itm_id;        

ALTER TABLE pfsawh_item_dim 
	ADD CONSTRAINT pk_pfsawh_item_dim_phy_itm_id 
    PRIMARY KEY 
        (
        physical_item_id
        );

/*----- Indexs -----*/

DROP INDEX idx_pfsawh_item_dim_item_id;        

CREATE INDEX idx_pfsawh_item_dim_item_id 
    ON pfsawh_item_dim 
    (
    item_id
    );

DROP INDEX idx_pfsawh_item_dim_rec_id;        

CREATE UNIQUE INDEX idx_pfsawh_item_dim_rec_id 
    ON pfsawh_item_dim
    (rec_id)
    LOGGING
    NOPARALLEL;

DROP INDEX idx_pfsawh_item_dim_niin;        

CREATE INDEX idx_pfsawh_item_dim_niin 
    ON pfsawh_item_dim
    (niin)
    LOGGING
    NOPARALLEL;

/*----- Foreign Key -----*/
/*
ALTER TABLE xx_pfsawh_blank_dim  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE xx_pfsawh_blank_dim  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);
*/
/*----- Constraints -----*/

ALTER TABLE pfsawh_item_dim  
    DROP CONSTRAINT ck_item_dim_subj_flg;       

ALTER TABLE pfsawh_item_dim  
    ADD CONSTRAINT ck_item_dim_subj_flg 
    CHECK (pfsa_subject_flag='Y'    OR pfsa_subject_flag='N');
    
/*
ALTER TABLE pfsawh_item_dim  
    DROP CONSTRAINT ck_item_dim_flt_typ_dsc        

ALTER TABLE pfsawh_item_dim  
    ADD CONSTRAINT ck_item_dim_flt_typ_dsc 
    CHECK (fleet_type_desc='AVIATION'    OR fleet_type_desc='COMMUNICATIONS' 
        OR fleet_type_desc='ELECTRONICS' OR fleet_type_desc='GROUND' 
        OR fleet_type_desc='WATER'       OR fleet_type_desc='NOT APPLICABLE'
        );

ALTER TABLE pfsawh_item_dim  
    DROP CONSTRAINT ck_item_dim_flt_sbtyp_dsc        

ALTER TABLE pfsawh_item_dim  
    ADD CONSTRAINT ck_item_dim_flt_sbtyp_dsc 
    CHECK (fleet_subtype_desc='AIRCRAFT' OR fleet_subtype_desc='HELICOPTER' 
        OR fleet_subtype_desc='TRACKED'  OR fleet_subtype_desc='WHEELED' 
        OR fleet_subtype_desc='NOT APPLICABLE'
        );
        
ALTER TABLE pfsawh_item_dim  
    DROP CONSTRAINT CK_item_DIM_FLT_CAPAB_DSC        

ALTER TABLE pfsawh_item_dim  
    ADD CONSTRAINT CK_item_DIM_FLT_CAPAB_DSC 
    CHECK (FLEET_CAPABILITY_DESC='CARGO'    OR FLEET_CAPABILITY_DESC='UTILITY' 
        OR FLEET_CAPABILITY_DESC='ATTACK'   OR FLEET_CAPABILITY_DESC='CAVALRY' 
        OR FLEET_CAPABILITY_DESC='INFANTRY' OR FLEET_CAPABILITY_DESC='FIRE SUPPORT'
        OR FLEET_CAPABILITY_DESC='SCOUT'    OR FLEET_CAPABILITY_DESC='NOT APPLICABLE'
        );
*/
/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_seq;

CREATE SEQUENCE pfsawh_item_seq
    START WITH 1
    MAXVALUE 99999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create trigger -----*/ 

/*----- Table Meta-Data -----*/  
    
COMMENT ON TABLE pfsawh_item_dim 
IS 'PFSAWH_ITEM_DIM - This table documents system and/or end items by NIIN or MCN.  It is used as the definitive item description, by validation in the load processes and selection criteria for reports.';
    
    
COMMENT ON COLUMN pfsawh_item_dim.rec_id 
IS 'REC_ID - Sequence/identity for dimension.'; 

COMMENT ON COLUMN pfsawh_item_dim.item_id 
IS 'ITEM_ID - LIW/PFSAWH identitier for the item/part.'; 

COMMENT ON COLUMN pfsawh_item_dim.physical_item_id 
IS 'PHYSICAL_ITEM_ID - LIW/PFSAWH identitier for the item/part.'; 

COMMENT ON COLUMN pfsawh_item_dim.pfsa_subject_flag
IS 'PFSA_SUBJECT_FLAG - Indicates if the item has been. is or will be the subject of PFSA analysis.';

COMMENT ON COLUMN pfsawh_item_dim.lin 
IS 'LIN - Line Iten Number';

COMMENT ON COLUMN pfsawh_item_dim.army_type_designator 
IS 'ARMY_TYPE_DESIGNATOR - Model number';

COMMENT ON COLUMN pfsawh_item_dim.item_nomen_short 
IS 'ITEM_NOMEN_SHORT - Description of the item.  On initial load it was taken from gcssa_lin.item_nomen.';

COMMENT ON COLUMN pfsawh_item_dim.item_nomen_standard 
IS 'ITEM_NOMEN_STANDARD - Description of the item.  ';

COMMENT ON COLUMN pfsawh_item_dim.item_nomen_long 
IS 'ITEM_NOMEN_LONG - Description of the item.  On initial load it was taken from gcssa_lin.gen_nomen.';

COMMENT ON COLUMN pfsawh_item_dim.lin_active_date 
IS 'LIN_ACTIVE_DATE - SUPPLY BULLETIN 700-20 ASSIGNED DATE - The date the National Item Identification Number (NIIN) was assigned to a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN pfsawh_item_dim.lin_inactive_date 
IS 'LIN_INACTIVE_DATE - SUPPLY BULLETIN 700-20 INACTIVE DATE - The date the National Item Identification Number (NIIN) was inactivated from a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN pfsawh_item_dim.lin_inactive_statement 
IS 'LIN_INACTIVE_STATEMENT - ';

COMMENT ON COLUMN pfsawh_item_dim.unit_price 
IS 'UNIT_PRICE - Cost per unit of the item.  On initial load it was taken from gcssa_lin.unit_price.';

COMMENT ON COLUMN pfsawh_item_dim.unit_indicator 
IS 'UNIT_INDICATOR - Cost per unit of the item.  On initial load it was taken from gcssa_lin.ui.';

COMMENT ON COLUMN pfsawh_item_dim.fsc 
IS 'FSC - Federal Supply Classification';            

COMMENT ON COLUMN pfsawh_item_dim.nsn 
IS 'NSN - National Stock Number';

COMMENT ON COLUMN pfsawh_item_dim.niin 
IS 'NIIN - National Item Identification Number';

COMMENT ON COLUMN pfsawh_item_dim.eic_code 
IS 'EIC - End Item Code';
 
COMMENT ON COLUMN pfsawh_item_dim.eic_model
IS 'EIC_MODEL - End Item Code Desc';
 
COMMENT ON COLUMN pfsawh_item_dim.ecc_code 
IS 'ECC - Equipment Category Code';

COMMENT ON COLUMN pfsawh_item_dim.ecc_desc 
IS 'ECC_DESC - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_1_code 
IS 'MAT_CAT_CD_1 - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_1_desc 
IS 'MAT_CAT_CD_1_DESC - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_2_code 
IS 'MAT_CAT_CD_2 - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_2_desc 
IS 'MAT_CAT_CD_2_DESC - APPROPRIATION AND BUDGET ACTIVITY ACCOUNT CODE DESCRIPTION - A description of the Appropriation and Budget Activity Account Code (MAT_CAT_CD_2).';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_3_code 
IS 'MAT_CAT_CD_3 - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_3_desc 
IS 'MAT_CAT_CD_3_DESC - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_4_code 
IS 'MAT_CAT_CD_4 - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_4_desc 
IS 'MAT_CAT_CD_4_DESC - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_4_5_code 
IS 'MAT_CAT_CD_4_5 - ';

COMMENT ON COLUMN pfsawh_item_dim.mat_cat_cd_4_5_desc 
IS 'MAT_CAT_CD_4_5_DESC - MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT).  Position 4 is the specific group/generic code.  It is alphanumeric, excluding the letter O and the numeral 1.  This code provides further subdivision of those items identified by Positions 1 - 3.  Position 5 is the generic category code.  It is alphanumeric, excluding the letters I and O.  This code identifies items to weapons systems/end items or other applications.  (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN pfsawh_item_dim.cage_code 
IS 'CAGE - Commercial And Government Entity';

COMMENT ON COLUMN pfsawh_item_dim.cage_desc 
IS 'CAGE_DESC - Commercial And Government Entity';

COMMENT ON COLUMN pfsawh_item_dim.chap 
IS 'CHAP - CHAPTER - Identifies the chapter or appendix of SB 700-20 in which an instance of the materiel item is published.';

COMMENT ON COLUMN pfsawh_item_dim.mscr 
IS 'MSCR - Materiel Status Committee Record identifier - The identifier assigned by the materiel status office to the record of the decisions and actions reported by materiel developers.';

COMMENT ON COLUMN pfsawh_item_dim.uid1_desc 
IS 'UID1 - Unique IDentification Construct 1';

COMMENT ON COLUMN pfsawh_item_dim.uid2_desc 
IS 'UID2 - Unique IDentification Construct 2';

COMMENT ON COLUMN pfsawh_item_dim.type_class_cd 
IS 'TYPE_CLASS_CD - ';

COMMENT ON COLUMN pfsawh_item_dim.type_class_cd_desc 
IS 'TYPE_CLASS_CD_DESC - ';

COMMENT ON COLUMN pfsawh_item_dim.sb_700_20_publication_date 
IS 'SB_700_20_PUBLICATION_DATE - SUPPLY BULLETIN 700-20 PUBLICATION DATE - The next date the information is to be published.';

COMMENT ON COLUMN pfsawh_item_dim.ricc_item_code 
IS 'RICC_ITEM_CODE - Reportable Item Control Code - On initial load it was taken from gcssa_lin.ricc.';

COMMENT ON COLUMN pfsawh_item_dim.aba 
IS 'ABA - Appropriation And Budget Activity - On initial load it was taken from gcssa_lin.aba.';

COMMENT ON COLUMN pfsawh_item_dim.sos 
IS 'SOS - Source Of Supply - On initial load it was taken from gcssa_lin.sos.';

COMMENT ON COLUMN pfsawh_item_dim.ciic 
IS 'CIIC - Controlled Inventory Item Code - On initial load it was taken from gcssa_lin.ciic.';

COMMENT ON COLUMN pfsawh_item_dim.cbm_sensor_fl 
IS 'CBM_SENSOR_FL - Condition Based Maintenance Flag'; 

COMMENT ON COLUMN pfsawh_item_dim.aircraft  
IS 'AIRCRAFT - ';

COMMENT ON COLUMN pfsawh_item_dim.supply_class 
IS 'SUPPLY CLASS - A code that indicates the major category of materiel to which an item of supply is assigned.';

COMMENT ON COLUMN pfsawh_item_dim.supply_class_desc 
IS 'SUPPLY_CLASS_DESC - ';


COMMENT ON COLUMN pfsawh_item_dim.cl_of_supply_cd 
IS 'CL_OF_SUPPLY_CD - CLASS OF SUPPLY - The code that represents the category of use for which an item of equipment is authorized in support of logistics decisions.';

COMMENT ON COLUMN pfsawh_item_dim.cl_of_supply_cd_desc 
IS 'CL_OF_SUPPLY_CD_DESC - CLASS OF SUPPLY CODE DESCRIPTION - A description of the Class of Supply Code (CL_OF_SUPPLY_CD).';

/*
COMMENT ON COLUMN pfsawh_item_dim.subclass_of_supply_cd 
IS 'SUBCLASS_OF_SUPPLY_CD - SUBCLASSIFICATION OF SUPPLY CODE - The code that represents a subdivision of the supply category of materiel code.  The further identification of an item of supply to a specific commodity.';
*/

COMMENT ON COLUMN pfsawh_item_dim.subclass_of_supply_cd_desc 
IS 'SUBCLASS_OF_SUPPLY_DESC - SUBCLASSIFICATION OF SUPPLY CODE DESCRIPTION - A description of the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';

/*
COMMENT ON COLUMN pfsawh_item_dim.subclass_of_supply_name 
IS 'SUBCLASS_OF_SUPPLY_NAME - SUBCLASSIFICATION OF SUPPLY CODE NAME - A short name for the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';
*/

COMMENT ON COLUMN pfsawh_item_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN pfsawh_item_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';
    
COMMENT ON COLUMN pfsawh_item_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';
    
COMMENT ON COLUMN pfsawh_item_dim.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';
   
COMMENT ON COLUMN pfsawh_item_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Flag indicating when the record became active.';
    
COMMENT ON COLUMN pfsawh_item_dim.INACTIVE_DATE 
IS 'INACTIVE_DATE - Additional control for active_Flag indicating when the record went inactive.';
    
COMMENT ON COLUMN pfsawh_item_dim.INSERT_BY 
IS 'INSERT_BY - Reports who initially created the record.';
    
COMMENT ON COLUMN pfsawh_item_dim.INSERT_DATE 
IS 'INSERT_DATE - Reports when the record was initially created.';
    
COMMENT ON COLUMN pfsawh_item_dim.UPDATE_BY 
IS 'UPDATE_BY - Reports who last updated the record.';
    
COMMENT ON COLUMN pfsawh_item_dim.UPDATE_DATE 
IS 'UPDATE_DATE - Reports when the record was last updated.';
    
COMMENT ON COLUMN pfsawh_item_dim.DELETE_FLAG 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';
    
COMMENT ON COLUMN pfsawh_item_dim.DELETE_DATE 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';
    
COMMENT ON COLUMN pfsawh_item_dim.HIDDEN_FLAG 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';
    
COMMENT ON COLUMN pfsawh_item_dim.HIDDEN_DATE 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';
    
/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_item_dim'); 
    
/*----- Check to see if the table column comments are present -----*/
    
SELECT b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_item_dim') 
    AND a.column_name = b.column_name
WHERE a.table_name = UPPER('pfsawh_item_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name; 
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%MANUFACTURER%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/


/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_PHSAWH_blank
--            SP Desc: 
--
--      SP Created By: Gene Belford 
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_PHSAWH_blank.sql
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--      SP Parameters: 
--              Input: 
-- 
--             Output:   
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

DECLARE

-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_phsawh_item';     /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

in_rec_Id                        gb_pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_pfsawh_process_log.process_RecId%TYPE   
    := 103;                  /* NUMBER */
s0_processKey                    gb_pfsawh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_processStartDt                gb_pfsawh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  gb_pfsawh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               gb_pfsawh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  gb_pfsawh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    gb_pfsawh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   gb_pfsawh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    gb_pfsawh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                gb_pfsawh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                gb_pfsawh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 gb_pfsawh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 gb_pfsawh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   gb_pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       gb_pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

----------------------------------- START --------------------------------------

BEGIN 

    s0_recInsertedInt := 0;
    s0_recUpdatedInt  := 0;
    s0_recDeletedInt  := 0;
    
    ps_location := '00-Start';

    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, in_rec_id);

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || s0_processRecId || ', ' || s0_processKey);
    END IF;  

    DELETE pfsawh_item_dim;
    s0_recDeletedInt  := SQL%ROWCOUNT;
        
    INSERT 
    INTO	pfsawh_item_dim 
    ( 
    item_id, 
    lin, 
    chap,  
    lin_active_date,
    lin_inactive_date,
    item_nomen_long, 
    lin_inactive_statement, 
    ricc_item_code, 
    mat_cat_cd_1, 
    sb_700_20_publication_date, 
    status, 
    lst_updt, 
    updt_by, 
    active_flag, 
    active_date
    ) 
    SELECT	
    fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'),
    lin, 
    chap, 
    dt_assigned, 
    dt_inact,  
    NVL(gen_nomen, 'unk'),  
    inactive_statement, 
    lin_ricc, 
    mat_cat_cd_1, 
    pub_dt_sb_700_20, 
    status, 
    lst_updt, 
    updt_by, 
    'Y', 
    dt_assigned 
    FROM	lin@pfsawh.lidbdev lin 
    WHERE	status = 'C';  
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT;
    
    UPDATE pfsawh_item_dim 
    SET    (niin) = 
               ( SELECT MAX(auth.niin)  
                 FROM   auth_item@pfsawh.lidbdev auth
                 WHERE  lin = auth.lin 
                     AND auth.status = 'C' 
               ); 
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    COMMIT;

    INSERT 
    INTO	pfsawh_item_dim 
    ( 
    item_id, 
    niin, 
    army_type_designator,
    lin, 
    mscr, 
    lin_active_date,
    lin_inactive_date,
    gen_nomen, 
    --lin_inactive_statement, 
    --ricc_item_code, 
    --mat_cat_cd_1, 
    sb_700_20_publication_date, 
    status, 
    lst_updt, 
    updt_by, 
    active_flag, 
    active_date
    ) 
    SELECT	
    fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'),
    niin, 
    NVL(army_type_design, 'unk'),
    lin, 
    mscr, 
    '01-JAN-1990', 
    dt_inact,  
    NVL(shrt_nomen, 'unk'),  
    --inactive_statement, 
    --lin_ricc, 
    --mat_cat_cd_1, 
    sb_pub_dt, 
    status, 
    lst_updt, 
    updt_by, 
    'Y', 
    dt_assigned 
    FROM	auth_item@pfsawh.lidbdev lin 
    WHERE	status = 'C'; 
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT; 
    
    
    INSERT 
    INTO	pfsawh_item_dim 
        ( 
        item_id, 
        niin, 
        lin, 
        item_nomen_standard, 
        fsc, 
        item_nomen_long, 
        eic_code,  
        cl_of_supply_cd, 
        mat_cat_cd_2_code,
        mat_cat_cd_4_5_code,
        ecc_code 
        ) 
    SELECT 
        fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'),
        a.item_niin,
        a.lin,
        a.nomen_35,
        a.item_fsc,
        a.item_nomen,
        a.eic,
        a.cl_of_supply_cd,
--        a.SUBCLASS_OF_SUPPLY_CD,
        a.mat_cat_cd_2,
        a.mat_cat_cd_4_5,
        a.ecc 
    FROM rdr00008.potential_pfsa_item@LINKHOLDER_LIWWH.CS7 a
    WHERE NOT EXISTS (
                     SELECT b.niin 
                     FROM pfsawh_item_dim b 
                     WHERE a.item_niin = b.niin
                     ); 

    
    UPDATE pfsawh_item_dim a
    SET    (fsc, nsn) = 
               ( SELECT fsc, NVL(nsn, fsc || niin)  
                 FROM   item_control@pfsawh.lidbdev ctrl
                 WHERE  a.niin = ctrl.niin  
               )
    WHERE  UPPER(a.fsc) = 'UNK';        
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    UPDATE pfsawh_item_dim 
    SET    nsn = fsc || niin
    WHERE  UPPER(nsn) = 'UNK' 
        AND fsc IS NOT NULL 
        AND niin IS NOT NULL;

    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    ps_location := '99 - Close';

    --    s0_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, in_rec_id); 
        
    COMMIT;

END; 

/*

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   pfsawh_item_dim item 
--ORDER BY item.fsc, item.niin; 
ORDER BY item.lin, item.niin; 

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   pfsawh_item_dim item 
WHERE  pfsa_subject_flag = 'Y' 
ORDER BY item.fsc, item.niin; 

DELETE pfsawh_item_dim  
WHERE  pfsa_subject_flag = 'Y';

-- COMMIT;

SELECT item.fsc, item.niin, item.nsn, 
    '|', auth.*, 
    '|', item.* 
FROM   pfsawh_item_dim item, 
       auth_item@pfsawh.lidbdev auth
WHERE  fsc = '2355' 
    AND item.lin = auth.lin 
    AND auth.status = 'C' 
ORDER BY item.fsc, auth.niin; 

SELECT * 
FROM	lin@pfsawh.lidbdev lin 
WHERE  gen_nomen LIKE '%ICV%'
ORDER BY lin; 

*/
    
