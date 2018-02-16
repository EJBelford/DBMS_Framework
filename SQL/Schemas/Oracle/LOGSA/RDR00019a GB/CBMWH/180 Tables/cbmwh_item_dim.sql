/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: cbmwh_item_dim
--      PURPOSE: A major grouping End Items. 
--
-- TABLE SOURCE: cbmwh_item_dim.sql
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

/*----- Sequence  -----*/

SELECT MAX(rec_id) FROM cbmwh_item_dim;

DROP SEQUENCE cbmwh_item_seq;

CREATE SEQUENCE cbmwh_item_seq
    START WITH 164000
--    MAXVALUE 99999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/*----- Create trigger -----*/ 

/*----- Create table -----*/ 

DROP TABLE cbmwh_item_dim;

CREATE TABLE cbmwh_item_dim 
(
    rec_id                        NUMBER              NOT NULL,
    ITEM_DIM_ID                   NUMBER              DEFAULT 0,
    physical_item_id              NUMBER              DEFAULT 0,
    niin                          VARCHAR2(9)         DEFAULT 'unk',    
    nsn                           VARCHAR2(13)        DEFAULT 'unk',    
    mcn                           VARCHAR2(13 BYTE)   DEFAULT 'unk',
    NIIN_UNIQUE                   VARCHAR2(13 BYTE),
    STANDARD_NIIN_FLAG            VARCHAR2(12 BYTE),
    STANDARD_ARMY_ITEM            VARCHAR2(1 BYTE),
    fsc                           VARCHAR2(4)         DEFAULT 'unk',     
    lin                           VARCHAR2(6),                          
    army_type_designator          VARCHAR2(30)        DEFAULT 'unk',    
    NIIN_NOMEN                    VARCHAR2(35 BYTE),
    item_nomen_short              VARCHAR2(35)        DEFAULT 'unk',
    item_nomen_standard           VARCHAR2(35)        DEFAULT 'unk',
    item_nomen_long               VARCHAR2(105)       DEFAULT 'unk',
    LIN_NOMEN                     VARCHAR2(255 BYTE),
    NEWEST_NIIN_FOR_LIN_FLAG      VARCHAR2(1 BYTE),
    lin_active_date               DATE                DEFAULT '01-JAN-1900',
    lin_inactive_date             DATE                DEFAULT '31-DEC-2099',
    lin_inactive_statement        VARCHAR2(35)        DEFAULT 'not applicable',
    unit_price                    NUMBER(12, 2)       DEFAULT 0.00,
    UI                            VARCHAR2(2 BYTE)    DEFAULT '-1',
    UM                            VARCHAR2(20 BYTE),
    EIC                           VARCHAR2(3 BYTE)    DEFAULT '-1',
    eic_model                     VARCHAR2(100)       DEFAULT 'unk',    
    ECC                           VARCHAR2(3 BYTE)    DEFAULT '-1',
    ecc_desc                      VARCHAR2(100)       DEFAULT 'unk',     
    MAT_CAT_CD_1                  VARCHAR2(2 BYTE),
    MAT_CAT_1_NAME                VARCHAR2(30 BYTE),
    MAT_CAT_1_RIC                 VARCHAR2(3 BYTE),
    mat_cat_cd_1_desc             VARCHAR2(20),
    MAT_CAT_CD_2                  VARCHAR2(2 BYTE),
    mat_cat_cd_2_desc             VARCHAR2(250),
    MAT_CAT_CD_3                  VARCHAR2(2 BYTE),
    mat_cat_cd_3_desc             VARCHAR2(20),    
    MAT_CAT_3_NAME                VARCHAR2(70 BYTE),
    mat_cat_cd_4                  VARCHAR2(2),    
    mat_cat_cd_4_desc             VARCHAR2(100),    
    MAT_CAT_CD_4_5                VARCHAR2(2 BYTE),
    mat_cat_cd_4_5_desc           VARCHAR2(200),    
    cage_code                     VARCHAR2(5)         DEFAULT '-1',       
    cage_desc                     VARCHAR2(20)        DEFAULT 'unk',       
    chap                          VARCHAR2(1), 
    mscr                          VARCHAR2(8), 
    uid1_desc                     VARCHAR2(15),                         
    uid2_desc                     VARCHAR2(19),   
    type_class_cd                 VARCHAR2(2),                          
    type_class_cd_desc            VARCHAR2(20),    
    SB_PUB_DT                     DATE,
    RICC                          VARCHAR2(2 BYTE),
    aba                           VARCHAR2(2),
    sos                           VARCHAR2(3),
    ciic                          VARCHAR2(2), 
    supply_class                  VARCHAR2(2),
    supply_class_desc             VARCHAR2(20),
    cl_of_supply_cd               VARCHAR2(2),
    cl_of_supply_cd_desc          VARCHAR2(20),
--    
    status                        VARCHAR2(1)         DEFAULT 'I' ,
    lst_updt                      DATE                DEFAULT sysdate ,
    updt_by                       VARCHAR2(20)        DEFAULT user ,
    active_flag                   VARCHAR2(1)         DEFAULT 'I' , 
    active_date                   DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT '31-DEC-2099' ,
    insert_by                     VARCHAR2(20)        DEFAULT user , 
    insert_date                   DATE                DEFAULT sysdate , 
    update_by                     VARCHAR2(20)        NULL ,
    update_date                   DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                   DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                   VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                   DATE                DEFAULT '01-JAN-1900' , 
    WH_DATE_SOURCE                VARCHAR2(25 BYTE),
    WH_EFFECTIVE_DATE             DATE,
    WH_EXPIRATION_DATE            DATE,
    WH_LAST_UPDATE_DATE           DATE                DEFAULT '01-JAN-1900',
    WH_RECORD_STATUS              VARCHAR2(10 BYTE),
--
    ACT_ORIGN_CD                  VARCHAR2(3 BYTE),
    ACT_ORIGN_RIC                 VARCHAR2(3 BYTE),
    ACTNG_RQMT_CD                 VARCHAR2(1 BYTE),
    ACTNG_RQMT_CLASS              VARCHAR2(400 BYTE),
    ACTNG_RQMT_DESC               VARCHAR2(400 BYTE),
    AEC_CD                        VARCHAR2(1 BYTE),
    AEC_DESC                      VARCHAR2(50 BYTE),
    AERC                          VARCHAR2(25 BYTE),
    ANAL_CD                       VARCHAR2(5 BYTE),
    ANALYST_CMD                   VARCHAR2(15 BYTE),
    ANALYST_DSN_NUMBER            VARCHAR2(15 BYTE),
    ANALYST_EMAIL                 VARCHAR2(50 BYTE),
    ANALYST_OFFICE_SYMBOL         VARCHAR2(20 BYTE),
    ANALYST_PHONE                 VARCHAR2(15 BYTE),
    ANALYST_WHOLE_NAME            VARCHAR2(35 BYTE),
    ARI_CD                        VARCHAR2(1 BYTE),
    ARMY_TYPE_CL_CD               VARCHAR2(1 BYTE),
    ARMY_TYPE_CL_DESC             VARCHAR2(25 BYTE),
    ARMY_TYPE_DESIGN              VARCHAR2(30 BYTE)   DEFAULT 'unk',
    CIIC_DESC                     VARCHAR2(400 BYTE),
    CIIC_NAME                     VARCHAR2(60 BYTE),
    COMMODITY                     VARCHAR2(15 BYTE),
    CURRENT_ARI_FLAG              VARCHAR2(7 BYTE),
    DEMIL_CD                      VARCHAR2(1 BYTE),
    DEMIL_DESC                    VARCHAR2(500 BYTE),
    DEMIL_NAME                    VARCHAR2(30 BYTE),
    DODIC                         VARCHAR2(4 BYTE),
    EFF_DATE                      DATE,
    ESNTL_CD                      VARCHAR2(1 BYTE),
    ESNTL_DESC                    VARCHAR2(600 BYTE),
    ESNTL_NAME                    VARCHAR2(15 BYTE),
    EST_UP_IND                    VARCHAR2(1 BYTE),
    FSG                           NUMBER,
    LC_CD                         VARCHAR2(1 BYTE),
    LC_DESC                       VARCHAR2(100 BYTE),
    MAINT_RPR_CD                  VARCHAR2(1 BYTE),
    MAINT_RPR_DESC                VARCHAR2(200 BYTE),
    PARENT_MCN                    VARCHAR2(13 BYTE),
    RECOV_CD                      VARCHAR2(1 BYTE),
    RECOV_DESC                    VARCHAR2(300 BYTE),
    RICC_DESC                     VARCHAR2(650 BYTE),
    SLAMIS_RQST_ID                VARCHAR2(20 BYTE),
    SOS_DESCRIPTION               VARCHAR2(35 BYTE),
    SOS_MOD_CD                    VARCHAR2(3 BYTE),
    SOS_MOD_DESC                  VARCHAR2(75 BYTE),
    SOS_MOD_NAME                  VARCHAR2(75 BYTE),
    SOS_NAME                      VARCHAR2(50 BYTE),
    SRRC                          VARCHAR2(1 BYTE),
    SRRC_DESC                     VARCHAR2(255 BYTE),
    SUBCLASS_OF_SUPPLY_CD         VARCHAR2(2 BYTE),
    SUBCLASS_OF_SUPPLY_NAME       VARCHAR2(55 BYTE),
    SUBCLASS_OF_SUPPLY_DESC       VARCHAR2(500 BYTE),
    TRANS_SOURCE                  VARCHAR2(20 BYTE) 
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

ALTER TABLE cbmwh_item_dim  
    DROP CONSTRAINT pk_cbmwh_item_dim_niin_mcn;        

ALTER TABLE cbmwh_item_dim 
	ADD CONSTRAINT pk_cbmwh_item_dim_niin_mcn 
    PRIMARY KEY 
        (
        niin, 
        mcn
        );

/*----- Indexs -----*/

DROP INDEX idx_cbmwh_item_dim_item_id;        

CREATE INDEX idx_cbmwh_item_dim_item_id 
    ON cbmwh_item_dim 
    (
    physical_item_id
    );

DROP INDEX idx_cbmwh_item_dim_mcn;        

CREATE INDEX idx_cbmwh_item_dim_mcn 
    ON cbmwh_item_dim 
    (
    mcn
    );

DROP INDEX idx_cbmwh_item_dim_niin;        

CREATE INDEX idx_cbmwh_item_dim_niin 
    ON cbmwh_item_dim
        (
        niin
        );

/*----- Constraints -----*/

/*
ALTER TABLE cbmwh_item_dim  
    DROP CONSTRAINT ck_item_dim_flt_typ_dsc        

ALTER TABLE cbmwh_item_dim  
    ADD CONSTRAINT ck_item_dim_flt_typ_dsc 
    CHECK (fleet_type_desc='AVIATION'    OR fleet_type_desc='COMMUNICATIONS' 
        OR fleet_type_desc='ELECTRONICS' OR fleet_type_desc='GROUND' 
        OR fleet_type_desc='WATER'       OR fleet_type_desc='NOT APPLICABLE'
        );
*/
/*----- Table Meta-Data -----*/  
    
COMMENT ON TABLE cbmwh_item_dim 
IS 'CBMWH_ITEM_DIM - This table documents system and/or end items by NIIN or MCN.  It is used as the definitive item description, by validation in the load processes and selection criteria for reports.';
    
    
COMMENT ON COLUMN cbmwh_item_dim.rec_id 
IS 'REC_ID - Sequence/identity for dimension.'; 

COMMENT ON COLUMN cbmwh_item_dim.item_dim_id 
IS 'ITEM_DIM_ID - LIW/CBMWH identitier for the item/part.'; 

COMMENT ON COLUMN cbmwh_item_dim.physical_item_id 
IS 'PHYSICAL_ITEM_ID - LIW/CBMWH identitier for the item/part.'; 

COMMENT ON COLUMN cbmwh_item_dim.lin 
IS 'LIN - Line Iten Number';

COMMENT ON COLUMN cbmwh_item_dim.army_type_designator 
IS 'ARMY_TYPE_DESIGNATOR - Model number';

COMMENT ON COLUMN cbmwh_item_dim.item_nomen_short 
IS 'ITEM_NOMEN_SHORT - Description of the item.  On initial load it was taken from gcssa_lin.item_nomen.';

COMMENT ON COLUMN cbmwh_item_dim.item_nomen_standard 
IS 'ITEM_NOMEN_STANDARD - Description of the item.  ';

COMMENT ON COLUMN cbmwh_item_dim.item_nomen_long 
IS 'ITEM_NOMEN_LONG - Description of the item.  On initial load it was taken from gcssa_lin.gen_nomen.';

COMMENT ON COLUMN cbmwh_item_dim.lin_active_date 
IS 'LIN_ACTIVE_DATE - SUPPLY BULLETIN 700-20 ASSIGNED DATE - The date the National Item Identification Number (NIIN) was assigned to a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN cbmwh_item_dim.lin_inactive_date 
IS 'LIN_INACTIVE_DATE - SUPPLY BULLETIN 700-20 INACTIVE DATE - The date the National Item Identification Number (NIIN) was inactivated from a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN cbmwh_item_dim.lin_inactive_statement 
IS 'LIN_INACTIVE_STATEMENT - ';

COMMENT ON COLUMN cbmwh_item_dim.unit_price 
IS 'UNIT_PRICE - Cost per unit of the item.  On initial load it was taken from gcssa_lin.unit_price.';

COMMENT ON COLUMN cbmwh_item_dim.ui 
IS 'UI - Cost per unit of the item.  On initial load it was taken from gcssa_lin.ui.';

COMMENT ON COLUMN cbmwh_item_dim.fsc 
IS 'FSC - Federal Supply Classification';            

COMMENT ON COLUMN cbmwh_item_dim.nsn 
IS 'NSN - National Stock Number';

COMMENT ON COLUMN cbmwh_item_dim.niin 
IS 'NIIN - National Item Identification Number';

COMMENT ON COLUMN cbmwh_item_dim.eic 
IS 'EIC - End Item Code';
 
COMMENT ON COLUMN cbmwh_item_dim.eic_model
IS 'EIC_MODEL - End Item Code Desc';
 
COMMENT ON COLUMN cbmwh_item_dim.ecc 
IS 'ECC - Equipment Category Code';

COMMENT ON COLUMN cbmwh_item_dim.ecc_desc 
IS 'ECC_DESC - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_1 
IS 'MAT_CAT_CD_1 - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_1_desc 
IS 'MAT_CAT_CD_1_DESC - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_2
IS 'MAT_CAT_CD_2 - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_2_desc 
IS 'MAT_CAT_CD_2_DESC - APPROPRIATION AND BUDGET ACTIVITY ACCOUNT CODE DESCRIPTION - A description of the Appropriation and Budget Activity Account Code (MAT_CAT_CD_2).';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_3 
IS 'MAT_CAT_CD_3 - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_3_desc 
IS 'MAT_CAT_CD_3_DESC - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_4
IS 'MAT_CAT_CD_4 - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_4_desc 
IS 'MAT_CAT_CD_4_DESC - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_4_5
IS 'MAT_CAT_CD_4_5 - ';

COMMENT ON COLUMN cbmwh_item_dim.mat_cat_cd_4_5_desc 
IS 'MAT_CAT_CD_4_5_DESC - MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT).  Position 4 is the specific group/generic code.  It is alphanumeric, excluding the letter O and the numeral 1.  This code provides further subdivision of those items identified by Positions 1 - 3.  Position 5 is the generic category code.  It is alphanumeric, excluding the letters I and O.  This code identifies items to weapons systems/end items or other applications.  (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN cbmwh_item_dim.cage_code 
IS 'CAGE - Commercial And Government Entity';

COMMENT ON COLUMN cbmwh_item_dim.cage_desc 
IS 'CAGE_DESC - Commercial And Government Entity';

COMMENT ON COLUMN cbmwh_item_dim.chap 
IS 'CHAP - CHAPTER - Identifies the chapter or appendix of SB 700-20 in which an instance of the materiel item is published.';

COMMENT ON COLUMN cbmwh_item_dim.mscr 
IS 'MSCR - Materiel Status Committee Record identifier - The identifier assigned by the materiel status office to the record of the decisions and actions reported by materiel developers.';

COMMENT ON COLUMN cbmwh_item_dim.uid1_desc 
IS 'UID1 - Unique IDentification Construct 1';

COMMENT ON COLUMN cbmwh_item_dim.uid2_desc 
IS 'UID2 - Unique IDentification Construct 2';

COMMENT ON COLUMN cbmwh_item_dim.type_class_cd 
IS 'TYPE_CLASS_CD - ';

COMMENT ON COLUMN cbmwh_item_dim.type_class_cd_desc 
IS 'TYPE_CLASS_CD_DESC - ';

COMMENT ON COLUMN cbmwh_item_dim.sb_pub_dt 
IS 'SB_PUB_DT - SUPPLY BULLETIN 700-20 PUBLICATION DATE - The next date the information is to be published.';

COMMENT ON COLUMN cbmwh_item_dim.ricc 
IS 'RICC - Reportable Item Control Code - On initial load it was taken from gcssa_lin.ricc.';

COMMENT ON COLUMN cbmwh_item_dim.aba 
IS 'ABA - Appropriation And Budget Activity - On initial load it was taken from gcssa_lin.aba.';

COMMENT ON COLUMN cbmwh_item_dim.sos 
IS 'SOS - Source Of Supply - On initial load it was taken from gcssa_lin.sos.';

COMMENT ON COLUMN cbmwh_item_dim.ciic 
IS 'CIIC - Controlled Inventory Item Code - On initial load it was taken from gcssa_lin.ciic.';

COMMENT ON COLUMN cbmwh_item_dim.supply_class 
IS 'SUPPLY CLASS - A code that indicates the major category of materiel to which an item of supply is assigned.';

COMMENT ON COLUMN cbmwh_item_dim.supply_class_desc 
IS 'SUPPLY_CLASS_DESC - ';


COMMENT ON COLUMN cbmwh_item_dim.cl_of_supply_cd 
IS 'CL_OF_SUPPLY_CD - CLASS OF SUPPLY - The code that represents the category of use for which an item of equipment is authorized in support of logistics decisions.';

COMMENT ON COLUMN cbmwh_item_dim.cl_of_supply_cd_desc 
IS 'CL_OF_SUPPLY_CD_DESC - CLASS OF SUPPLY CODE DESCRIPTION - A description of the Class of Supply Code (CL_OF_SUPPLY_CD).';

/*
COMMENT ON COLUMN cbmwh_item_dim.subclass_of_supply_cd 
IS 'SUBCLASS_OF_SUPPLY_CD - SUBCLASSIFICATION OF SUPPLY CODE - The code that represents a subdivision of the supply category of materiel code.  The further identification of an item of supply to a specific commodity.';

COMMENT ON COLUMN cbmwh_item_dim.subclass_of_supply_cd_desc 
IS 'SUBCLASS_OF_SUPPLY_DESC - SUBCLASSIFICATION OF SUPPLY CODE DESCRIPTION - A description of the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';

COMMENT ON COLUMN cbmwh_item_dim.subclass_of_supply_name 
IS 'SUBCLASS_OF_SUPPLY_NAME - SUBCLASSIFICATION OF SUPPLY CODE NAME - A short name for the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';
*/

COMMENT ON COLUMN cbmwh_item_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN cbmwh_item_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';
    
COMMENT ON COLUMN cbmwh_item_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';
    
COMMENT ON COLUMN cbmwh_item_dim.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';
   
COMMENT ON COLUMN cbmwh_item_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Flag indicating when the record became active.';
    
COMMENT ON COLUMN cbmwh_item_dim.INACTIVE_DATE 
IS 'INACTIVE_DATE - Additional control for active_Flag indicating when the record went inactive.';
    
COMMENT ON COLUMN cbmwh_item_dim.INSERT_BY 
IS 'INSERT_BY - Reports who initially created the record.';
    
COMMENT ON COLUMN cbmwh_item_dim.INSERT_DATE 
IS 'INSERT_DATE - Reports when the record was initially created.';
    
COMMENT ON COLUMN cbmwh_item_dim.UPDATE_BY 
IS 'UPDATE_BY - Reports who last updated the record.';
    
COMMENT ON COLUMN cbmwh_item_dim.UPDATE_DATE 
IS 'UPDATE_DATE - Reports when the record was last updated.';
    
COMMENT ON COLUMN cbmwh_item_dim.DELETE_FLAG 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';
    
COMMENT ON COLUMN cbmwh_item_dim.DELETE_DATE 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';
    
COMMENT ON COLUMN cbmwh_item_dim.HIDDEN_FLAG 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';
    
COMMENT ON COLUMN cbmwh_item_dim.HIDDEN_DATE 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';
    
/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('cbmwh_item_dim'); 
    
/*----- Check to see if the table column comments are present -----*/
    
SELECT b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('cbmwh_item_dim') 
    AND a.column_name = b.column_name
WHERE a.table_name = UPPER('cbmwh_item_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@cbmwh.lidbdev a
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

in_rec_Id                        gb_cbmwh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_cbmwh_process_log.process_RecId%TYPE   
    := 103;                  /* NUMBER */
s0_processKey                    gb_cbmwh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_processStartDt                gb_cbmwh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  gb_cbmwh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               gb_cbmwh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  gb_cbmwh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    gb_cbmwh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   gb_cbmwh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    gb_cbmwh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                gb_cbmwh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                gb_cbmwh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 gb_cbmwh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 gb_cbmwh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   gb_cbmwh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       gb_cbmwh_process_log.message%TYPE 
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

    pr_CBMWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
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

    DELETE cbmwh_item_dim;
    s0_recDeletedInt  := SQL%ROWCOUNT;
        
    INSERT 
    INTO	cbmwh_item_dim 
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
    fn_cbmwh_get_dim_identity('CBMWH_ITEM_DIM'),
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
    FROM	lin@cbmwh.lidbdev lin 
    WHERE	status = 'C';  
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT;
    
    UPDATE cbmwh_item_dim 
    SET    (niin) = 
               ( SELECT MAX(auth.niin)  
                 FROM   auth_item@cbmwh.lidbdev auth
                 WHERE  lin = auth.lin 
                     AND auth.status = 'C' 
               ); 
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    COMMIT;

    INSERT 
    INTO	cbmwh_item_dim 
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
    fn_cbmwh_get_dim_identity('CBMWH_ITEM_DIM'),
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
    FROM	auth_item@cbmwh.lidbdev lin 
    WHERE	status = 'C'; 
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT; 
    
    
    INSERT 
    INTO	cbmwh_item_dim 
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
        fn_cbmwh_get_dim_identity('CBMWH_ITEM_DIM'),
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
                     FROM cbmwh_item_dim b 
                     WHERE a.item_niin = b.niin
                     ); 

    
    UPDATE cbmwh_item_dim a
    SET    (fsc, nsn) = 
               ( SELECT fsc, NVL(nsn, fsc || niin)  
                 FROM   item_control@cbmwh.lidbdev ctrl
                 WHERE  a.niin = ctrl.niin  
               )
    WHERE  UPPER(a.fsc) = 'UNK';        
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    UPDATE cbmwh_item_dim 
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
    
    pr_CBMWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
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
FROM   cbmwh_item_dim item 
--ORDER BY item.fsc, item.niin; 
ORDER BY item.lin, item.niin; 

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   cbmwh_item_dim item 
WHERE  pfsa_subject_flag = 'Y' 
ORDER BY item.fsc, item.niin; 

DELETE cbmwh_item_dim  
WHERE  pfsa_subject_flag = 'Y';

-- COMMIT;

SELECT item.fsc, item.niin, item.nsn, 
    '|', auth.*, 
    '|', item.* 
FROM   cbmwh_item_dim item, 
       auth_item@cbmwh.lidbdev auth
WHERE  fsc = '2355' 
    AND item.lin = auth.lin 
    AND auth.status = 'C' 
ORDER BY item.fsc, auth.niin; 

SELECT * 
FROM	lin@cbmwh.lidbdev lin 
WHERE  gen_nomen LIKE '%ICV%'
ORDER BY lin; 

*/
    
