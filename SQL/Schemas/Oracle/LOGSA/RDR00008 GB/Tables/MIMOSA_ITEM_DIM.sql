DROP TABLE PFSAWH.mimosa_item_dim;

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: mimosa_item_dim
--      PURPOSE: A major grouping End Items. 
--
-- TABLE SOURCE: mimosa_item_dim.sql
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
CREATE TABLE mimosa_item_dim
(
    REC_ID                        NUMBER              NOT NULL,
    ITEM_ID                       NUMBER              DEFAULT 0,
    PFSA_SUBJECT_FLAG             VARCHAR2(1)         DEFAULT 'N',                          
-- National Item Identification Number    
    NIIN                          VARCHAR2(9)         DEFAULT 'unk',    
-- Line Item Number    
    LIN                           VARCHAR2(6),                          
-- 'Model number'    
    ARMY_TYPE_DESIGNATOR          VARCHAR2(30)        DEFAULT 'unk',    
    ITEM_NOMEN_SHORT              VARCHAR2(35)        DEFAULT 'unk',
    ITEM_NOMEN_STANDARD           VARCHAR2(35)        DEFAULT 'unk',
    ITEM_NOMEN_LONG               VARCHAR2(105)       DEFAULT 'unk',
    LIN_ACTIVE_DATE               DATE                DEFAULT '01-JAN-1900',
    LIN_INACTIVE_DATE             DATE                DEFAULT '31-DEC-2099',
    LIN_INACTIVE_STATEMENT        VARCHAR2(35)        DEFAULT 'not applicable',
    UNIT_PRICE                    NUMBER(12, 2)       DEFAULT 0.00,
    UNIT_INDICATOR                VARCHAR2(2)         DEFAULT '-1',
--    
-- Federal Supply Classification 
    FSC                           VARCHAR2(4)         DEFAULT 'unk',     
-- National Stock Number    
    NSN                           VARCHAR2(13)        DEFAULT 'unk',    
-- End Item Code     
    EIC_CODE                      VARCHAR2(3)         DEFAULT '-1',    
-- End Item Model    
    EIC_model                     VARCHAR2(100)       DEFAULT 'unk',    
-- Equipment Category Code    
    ECC_CODE                      VARCHAR2(3)         DEFAULT '-1',                          
-- Equipment Category Code Description    
    ECC_DESC                      VARCHAR2(100)       DEFAULT 'unk',     
-- Materiel Category Structure Code    
    MAT_CAT_CD_1_CODE             VARCHAR2(2),
    MAT_CAT_CD_1_DESC             VARCHAR2(20),
    MAT_CAT_CD_2_CODE             VARCHAR2(2),
    MAT_CAT_CD_2_DESC             VARCHAR2(250),
    MAT_CAT_CD_3_CODE             VARCHAR2(2),    
    MAT_CAT_CD_3_DESC             VARCHAR2(20),    
    MAT_CAT_CD_4_CODE             VARCHAR2(2),    
    MAT_CAT_CD_4_DESC             VARCHAR2(20),    
    MAT_CAT_CD_4_5_CODE           VARCHAR2(2),    
    MAT_CAT_CD_4_5_DESC           VARCHAR2(20),    
-- Commercial And Government Entity
    CAGE_CODE                     VARCHAR2(5)         DEFAULT '-1',       
    CAGE_DESC                     VARCHAR2(20)        DEFAULT 'unk',       
    CHAP                          VARCHAR2(2), 
-- Materiel Status Committee Record 
    MSCR                          VARCHAR2(8), 
-- Unique IDentification Construct 1    
    UID1_DESC                     VARCHAR2(15),                         
-- Unique IDentification Construct 2    
    UID2_DESC                     VARCHAR2(19),   
-- Army Type Class Code                      
    TYPE_CLASS_CD                 VARCHAR2(2),                          
    TYPE_CLASS_CD_DESC            VARCHAR2(20),    
    SB_700_20_PUBLICATION_DATE    DATE,                   
--
--    ANAL_VIEW                     VARCHAR2(40),
--    TYPE_ANAL_VIEW                VARCHAR2(20),    
--    SLXN_GROUPING                 VARCHAR2(24),
--    SLXN_SUB_GROUPING             VARCHAR2(35),
--    
--    FLEET_TYPE_DESC               VARCHAR2(40),
--    FLEET_SUBTYPE_DESC            VARCHAR2(40),
--    FLEET_CAPABILITY_DESC         VARCHAR2(40),
--
-- Reportable Item Control Code
    RICC_ITEM_CODE                VARCHAR2(2),                          
    ABA                           VARCHAR2(2),
    SOS                           VARCHAR2(3),
    CIIC                          VARCHAR2(2), 
-- Condition Based Maintenance Flag     
    CBM_SENSOR_FL                 VARCHAR2(1)         DEFAULT 'N' ,     
--
    AIRCRAFT                      VARCHAR2(1),
    SUPPLY_CLASS                  VARCHAR2(2),
    SUPPLY_CLASS_DESC             VARCHAR2(2),
    CL_OF_SUPPLY_CD               VARCHAR2(2),
    CL_OF_SUPPLY_CD_DESC          VARCHAR2(20),
    SUBCLASS_OF_SUPPLY_CD_DESC    VARCHAR2(1),
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
    HIDDEN_DATE                   DATE                DEFAULT '01-JAN-1900' 
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE mimosa_item_dim  
    DROP CONSTRAINT pk_mimosa_item_dim;        

CREATE UNIQUE INDEX pk_mimosa_item_dim ON mimosa_item_dim
    (rec_id)
    LOGGING
    NOPARALLEL;

ALTER TABLE mimosa_item_dim  
    DROP CONSTRAINT ixu_mimosa_item_dim;        

ALTER TABLE mimosa_item_dim 
	 ADD CONSTRAINT ixu_mimosa_item_dim 
    PRIMARY KEY 
        (
        item_id
        );

-- Constraints 

ALTER TABLE mimosa_item_dim  
    DROP CONSTRAINT ck_mimosa_item_dim_subj_flg        

ALTER TABLE mimosa_item_dim  
    ADD CONSTRAINT ck_mimosa_item_dim_subj_flg 
    CHECK (pfsa_subject_flag='Y'    OR pfsa_subject_flag='N');
    
/*----- Sequence  -----*/

DROP SEQUENCE mimosa_item_seq;

CREATE SEQUENCE mimosa_item_seq
    START WITH 1
    MAXVALUE 99999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- Trigger 

DROP TRIGGER tr_i_mimosa_item_seq;

CREATE OR REPLACE TRIGGER tr_i_mimosa_item_seq
BEFORE INSERT
ON mimosa_item_dim
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    tr_i_mimosa_item_seq

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

BEGIN
    v_rec_dim_id := 0;
    
    SELECT pfsawh_item_seq.nextval 
    INTO  v_rec_dim_id 
    FROM dual;
    
    :new.rec_id   := v_rec_dim_id;
    :new.status   := 'Z';
    :new.lst_updt := SYSDATE;
    :new.updt_by  := USER;
    
    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        
        RAISE;
       
END tr_i_mimosa_item_seq;

/*----- Table Meta-Data -----*/ 
    
COMMENT ON TABLE mimosa_item_dim 
IS 'Copy of PFSAWH_ITEM_DIM is keep working copy of data for MIMOSA CBM CRIS schema.';
    
    
COMMENT ON COLUMN mimosa_item_dim.rec_id 
IS 'Sequence/identity for dimension.'; 

COMMENT ON COLUMN mimosa_item_dim.item_id 
IS 'Identitier for item/part.'; 

COMMENT ON COLUMN mimosa_item_dim.pfsa_subject_flag
IS 'Indicates if the item has been. is or will be the subject of PFSA analysis.';

COMMENT ON COLUMN mimosa_item_dim.lin 
IS 'LIN - Line Iten Number';

COMMENT ON COLUMN mimosa_item_dim.army_type_designator 
IS 'Model number';

COMMENT ON COLUMN mimosa_item_dim.item_nomen 
IS 'Description of the item.  On initial load it was taken from gcssa_lin.item_nomen.';

COMMENT ON COLUMN mimosa_item_dim.end_item_nomen 
IS 'Description of the item.  ';

COMMENT ON COLUMN mimosa_item_dim.gen_nomen 
IS 'Description of the item.  On initial load it was taken from gcssa_lin.gen_nomen.';

COMMENT ON COLUMN mimosa_item_dim.lin_active_date 
IS 'SUPPLY BULLETIN 700-20 ASSIGNED DATE - The date the National Item Identification Number (NIIN) was assigned to a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN mimosa_item_dim.lin_inactive_date 
IS 'SUPPLY BULLETIN 700-20 INACTIVE DATE - The date the National Item Identification Number (NIIN) was inactivated from a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN mimosa_item_dim.lin_inactive_statement 
IS '';

COMMENT ON COLUMN mimosa_item_dim.unit_price 
IS 'Cost per unit of the item.  On initial load it was taken from gcssa_lin.unit_price.';

COMMENT ON COLUMN mimosa_item_dim.unit_indicator 
IS 'Cost per unit of the item.  On initial load it was taken from gcssa_lin.ui.';

COMMENT ON COLUMN mimosa_item_dim.fsc 
IS 'Federal Supply Classification';            

COMMENT ON COLUMN mimosa_item_dim.nsn 
IS 'National Stock Number';

COMMENT ON COLUMN mimosa_item_dim.niin 
IS 'National Item Identification Number';

COMMENT ON COLUMN mimosa_item_dim.eic_code 
IS 'End Item Code';
 
COMMENT ON COLUMN mimosa_item_dim.eic_desc 
IS 'End Item Code Desc';
 
COMMENT ON COLUMN mimosa_item_dim.ecc_code 
IS 'Equipment Category Code';

COMMENT ON COLUMN mimosa_item_dim.ecc_desc 
IS '';

COMMENT ON COLUMN mimosa_item_dim.mat_cat_cd_2_desc 
IS 'APPROPRIATION AND BUDGET ACTIVITY ACCOUNT CODE DESCRIPTION - A description of the Appropriation and Budget Activity Account Code (MAT_CAT_CD_2).';

COMMENT ON COLUMN mimosa_item_dim.mat_cat_cd_4_5_desc 
IS 'MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT).  Position 4 is the specific group/generic code.  It is alphanumeric, excluding the letter O and the numeral 1.  This code provides further subdivision of those items identified by Positions 1 - 3.  Position 5 is the generic category code.  It is alphanumeric, excluding the letters I and O.  This code identifies items to weapons systems/end items or other applications.  (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN mimosa_item_dim.cage_desc 
IS 'Commercial And Government Entity';

COMMENT ON COLUMN mimosa_item_dim.chap 
IS 'CHAPTER - Identifies the chapter or appendix of SB 700-20 in which an instance of the materiel item is published.';

COMMENT ON COLUMN mimosa_item_dim.mscr 
IS 'Materiel Status Committee Record identifier - The identifier assigned by the materiel status office to the record of the decisions and actions reported by materiel developers.'

COMMENT ON COLUMN mimosa_item_dim.uid1_desc 
IS 'Unique IDentification Construct 1';

COMMENT ON COLUMN mimosa_item_dim.uid2_desc 
IS 'Unique IDentification Construct 2';

COMMENT ON COLUMN mimosa_item_dim.type_class_cd 
IS '';

COMMENT ON COLUMN mimosa_item_dim.type_class_cd_desc 
IS '';

COMMENT ON COLUMN mimosa_item_dim.sb_700_20_publication_date 
IS 'SUPPLY BULLETIN 700-20 PUBLICATION DATE - The next date the information is to be published.';

COMMENT ON COLUMN mimosa_item_dim.ricc_item_code 
IS 'Reportable Item Control Code - On initial load it was taken from gcssa_lin.ricc.';

COMMENT ON COLUMN mimosa_item_dim.aba 
IS 'Appropriation And Budget Activity - On initial load it was taken from gcssa_lin.aba.';

COMMENT ON COLUMN mimosa_item_dim.sos 
IS 'Source Of Supply - On initial load it was taken from gcssa_lin.sos.';

COMMENT ON COLUMN mimosa_item_dim.ciic 
IS 'Controlled Inventory Item Code - On initial load it was taken from gcssa_lin.ciic.';

COMMENT ON COLUMN mimosa_item_dim.cbm_sensor_fl 
IS 'Condition Based Maintenance Flag'; 

COMMENT ON COLUMN mimosa_item_dim.aircraft  
IS '';

COMMENT ON COLUMN mimosa_item_dim.supply_class 
IS 'SUPPLY CLASS - A code that indicates the major category of materiel to which an item of supply is assigned.';

COMMENT ON COLUMN mimosa_item_dim.supply_class_desc 
IS '';

/*
COMMENT ON COLUMN mimosa_item_dim.cl_of_supply_cd 
IS 'CLASS OF SUPPLY - The code that represents the category of use for which an item of equipment is authorized in support of logistics decisions.';
*/

COMMENT ON COLUMN mimosa_item_dim.cl_of_supply_cd_desc 
IS 'CLASS OF SUPPLY CODE DESCRIPTION - A description of the Class of Supply Code (CL_OF_SUPPLY_CD).';

/*
COMMENT ON COLUMN mimosa_item_dim.subclass_of_supply_cd 
IS 'SUBCLASSIFICATION OF SUPPLY CODE - The code that represents a subdivision of the supply category of materiel code.  The further identification of an item of supply to a specific commodity.';

COMMENT ON COLUMN mimosa_item_dim.subclass_of_supply_desc 
IS 'SUBCLASSIFICATION OF SUPPLY CODE DESCRIPTION - A description of the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';

COMMENT ON COLUMN mimosa_item_dim.subclass_of_supply_name 
IS 'SUBCLASSIFICATION OF SUPPLY CODE NAME - A short name for the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';
*/

comment on column mimosa_item_dim.status 
is 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]'

comment on column mimosa_item_dim.updt_by 
is 'The date/timestamp of when the record was created/updated.'
    
comment on column mimosa_item_dim.lst_updt 
is 'Indicates either the program name or user ID of the person who updated the record.'
    
comment on column mimosa_item_dim.active_flag 
is 'Flag indicating if the record is active or not.'
   
comment on column mimosa_item_dim.active_date 
is 'Additional control for active_Flag indicating when the record became active.'
    
comment on column mimosa_item_dim.INACTIVE_DATE 
is 'Additional control for active_Flag indicating when the record went inactive.'
    
comment on column mimosa_item_dim.INSERT_BY 
is 'Reports who initially created the record.'
    
comment on column mimosa_item_dim.INSERT_DATE 
is 'Reports when the record was initially created.'
    
comment on column mimosa_item_dim.UPDATE_BY 
is 'Reports who last updated the record.'
    
comment on column mimosa_item_dim.UPDATE_DATE 
is 'Reports when the record was last updated.'
    
comment on column mimosa_item_dim.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'
    
comment on column mimosa_item_dim.DELETE_DATE 
is 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.'
    
comment on column mimosa_item_dim.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'
    
comment on column mimosa_item_dim.HIDDEN_DATE 
is 'Additional control for HIDDEN_FLAG indicating when the record was hidden.'
    
/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('mimosa_item_dim') 
    
/*----- Check to see if the table column comments are present -----*/
    
SELECT b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('mimosa_item_dim') 
    AND a.column_name = b.column_name
WHERE a.table_name = UPPER('mimosa_item_dim') 
ORDER BY b.column_id 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
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
    := 'mimosa_item_dim';    /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

in_rec_Id                        gb_pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_pfsawh_process_log.process_RecId%TYPE   
    := 999;                  /* NUMBER */
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

--    DELETE mimosa_item_dim;
    s0_recDeletedInt  := SQL%ROWCOUNT;
        
    INSERT 
    INTO	mimosa_item_dim 
    ( 
    item_id,
    pfsa_subject_flag,                          
    lin,                          
    army_type_designator,    
    item_nomen,
    end_item_nomen,
    gen_nomen,
    lin_active_date,
    lin_inactive_date,
    lin_inactive_statement,
    unit_price,
    unit_indicator,
    fsc,     
    nsn,    
    niin,    
    eic_code,    
    eic_desc,    
    ecc_code,                          
    ecc_desc,     
    mat_cat_cd_1_code,
    mat_cat_cd_1_desc,
    mat_cat_cd_2_desc,
    mat_cat_cd_4_5_desc,    
    cage_code,       
    cage_desc,       
    chap, 
    mscr, 
    uid1_desc,                         
    uid2_desc,   
    type_class_cd,                          
    type_class_cd_desc,    
    sb_700_20_publication_date,                   
    ricc_item_code,                          
    aba,
    sos,
    ciic, 
    cbm_sensor_fl,     
    aircraft,
    supply_class,
    supply_class_desc,
    cl_of_supply_cd,
    cl_of_supply_cd_desc,
    subclass_of_supply_cd_desc
    ) 
    SELECT	
    item_id,
    pfsa_subject_flag,                          
    lin,                          
    army_type_designator,    
    item_nomen,
    end_item_nomen,
    gen_nomen,
    lin_active_date,
    lin_inactive_date,
    lin_inactive_statement,
    unit_price,
    unit_indicator,
    fsc,     
    nsn,    
    niin,    
    eic_code,    
    eic_desc,    
    ecc_code,                          
    ecc_desc,     
    mat_cat_cd_1,
    mat_cat_cd_1_desc,
    mat_cat_cd_2_desc,
    mat_cat_cd_4_5_desc,    
    cage_code,       
    cage_desc,       
    chap, 
    mscr, 
    uid1_desc,                         
    uid2_desc,   
    type_class_cd,                          
    type_class_cd_desc,    
    sb_700_20_publication_date,                   
    ricc_item_code,                          
    aba,
    sos,
    ciic, 
    cbm_sensor_fl,     
    aircraft,
    supply_class,
    supply_class_desc,
    cl_of_supply_cd,
    cl_of_supply_cd_desc,
    subclass_of_supply_cd_desc
    FROM	gb_pfsawh_item_dim 
    WHERE	PFSA_SUBJECT_FLAG = 'Y';  
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT; 
    
    COMMIT;
    
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (2, 'N', 'C15172', 'HELICOPTER CARGO-TR', 'CH-47F IMPROVED CARGO HELICOPTER:', 'CH-47 CRASHWORTHY EXTENDED RANGE FUEL: S', '1520', '1520014575179', '014575179');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (4, 'N', 'E20380', 'EXTENDED RANGE (ERFS)', 'ERFS: CH-47 HELICOPTER ', 'CH-47F: TPFS', '1560', '1560012217600', '012217600');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (6, 'N', 'F86821', 'LGHT ARMOR VEHIC FS3', '', 'FIRE SUPPORT: VEHICLE (FSV)(ICV)', '2355', '2355015281274', '015281274');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (9, 'N', 'H46344', 'HELCTR OX SY CH47-FWD ', 'HELICOPTER OXYGEN SYSTEM: CH-47', '', '1660', '1660012246943', '012246943');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (10, 'N', 'H46344', 'HELCTR OX SY CH47-AFT ', 'HELICOPTER OXYGEN SYSTEM: CH-47', '', '1660', '1660012246944', '012246944');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (31, 'N', 'YF2074', '', '', '', '2355', '2355014936058', '014936058');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (32, 'N', 'YF552B', '', '', '', '2355', '235501C033921', '01C033921');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (33, 'N', 'YF5538', '', '', '', '2355', '2355200019926', '200019926');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (34, 'N', 'YF554S', '', '', '', '2355', '235501C043157', '01C043157');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (35, 'N', 'YF5551', '', '', '', '2355', '235501C043158', '01C043158');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (36, 'N', 'YF5552', '', '', '', '2355', '235501C043156', '01C043156');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (37, 'N', 'YF5574', '', '', '', '2355', '235501C043159', '01C043159');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (38, 'N', 'YF557N', '', '', '', '2355', '235501D025555', '01D025555');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (39, 'N', 'YF5588', '', '', '', '2355', '2355200019922', '200019922');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (40, 'N', 'YF558D', '', '', '', '2355', '2355200019922', '200019922');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (41, 'N', 'YF558D', '', '', '', '2355', '2355200019932', '200019932');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (42, 'N', 'YF558G', '', '', '', '2355', '2355015292246', '015292246');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (43, 'N', 'YF558G', '', '', '', '2355', '235501C040355', '01C040355');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (44, 'N', 'YF558G', '', '', '', '2355', '235501C040387', '01C040387');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (45, 'N', 'Z00689', '', '', '', '2355', '2355200019922', '200019922');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (46, 'N', 'Z00689', '', '', '', '2355', '2355200019932', '200019932');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (47, 'N', 'Z00689', '', '', '', '2355', '2355200030065', '200030065');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (49, 'N', 'Z22485', '', '', 'CH-47F IMPROVED CARGO HELICOPTER:', '1520', '1520014575179', '014575179');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (50, 'N', 'Z26403', '', 'ENGINEER SQUAD VEHICLE: (ESV)ICV', '', '2355', '2355014818570', '014818570');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (52, 'N', 'Z36523', '', 'COMMANDER VEHICLE: (CV) (ICV)', '', '2355', '2355014818573', '014818573');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (53, 'N', 'Z43601', '', 'INFANTRY CARRIER VEHICLE: (ICV)', '', '2355', '2355014818575', '014818575');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (54, 'N', 'Z43686', '', 'MOBILE GUN SYSTEM: (MGS) (ICV)', '', '2355', '2355014818577', '014818577');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (55, 'N', 'Z44642', '', 'MORTAR CARRIER: (ICV)', '', '2355', '2355014818578', '014818578');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (56, 'N', 'Z46828', '', 'NBC RECONNAISSANCE VEHICLE: ICV', '', '2355', '2355014818579', '014818579');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (57, 'N', 'Z63190', '', 'FIRE SUPPORT VEHICLE: (FSV)(ICV)', '', '2355', '2355014818574', '014818574');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (58, 'N', 'Z64438', '', 'MEDICAL EVACUATION VEHICLE: ICV', '', '2355', '2355014818580', '014818580');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (59, 'N', 'Z93260', '', 'RECONNAISSANCE VEHICLE: (ICV)', '', '2355', '2355014818572', '014818572');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (60, 'N', 'Z99100', '', 'ANTITNK GUID MISSIL VEH:(ATGM)(ICV)', '', '2355', '2355014818576', '014818576');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (61, 'N', '', '', '', '', '2355', '2355015292246', '015292246');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (62, 'N', '', '', '', '', '2355', '2355015427908', '015427908');
    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (63, 'N', '', '', '', '', '2355', '2355015429996', '015429996');

--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (1, 'N', 'A83852', 'LIGHT ARMORED V M1134', '', 'ANTITANK: GUIDED MISSILE VEHICLE (ATGM) (ICV)', '2355', '2355014818576', '014818576');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (3, 'N', 'C41314', 'LIGHT ARMORED V M1130', '', 'COMMANDER: VEHICLE CV ICV', '2355', '2355014818573', '014818573');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (5, 'N', 'F86821', 'LIGHT ARMORED V M1131', '', 'FIRE SUPPORT: VEHICLE (FSV)(ICV)', '2355', '2355014818574', '014818574');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (7, 'N', 'H31079', 'HEL INT HDLG SYS CH47 ', 'HEL INT HDLG SYS: CH-47 (HICHS)', 'HELICOPTER CARGO: MH-47E', '3910', '3910011971689', '011971689');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (8, 'N', 'H46150', 'HELICPTR CARGO MH-47E', 'HELICOPTER CARGO: MH-47E', 'HELICOPTER CARGO TRANSPORT: CH-47D', '1520', '1520012823747', '012823747');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (11, 'N', 'J22626', 'LIGHT ARMORED V M1126', '', 'INFANTRY CARRIER: VEHICLE (ICV)', '2355', '2355014818575', '014818575');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (12, 'N', 'J97621', 'LIGHT ARMORED V M1132', '', 'INTERIM ARMORED: VEHICLE FAMILY IAV', '2355', '2355014818570', '014818570');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (13, 'N', 'K30383', 'HCPTR CGO TRANS CH47B ', 'HELICOPTER CARGO TRANSPORT: CH-47B ', 'EXTENDED RANGE FUEL SYSTEM: CH-47 HELICOPTER', '1520', '1520009902941', '009902941');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (14, 'N', 'K30449', 'HCPTR CGO TRANS CH47C ', 'HELICOPTER CARGO TRANSPORT: CH-47C ', 'HELICOPTER CARGO TRANSPORT: CH-47B', '1520', '1520008717308', '008717308');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (15, 'N', 'M30567', 'LIGHT ARMORED V M1133', '', 'MEDICAL EVACUATION: VEHICLE ICV', '2355', '2355014818580', '014818580');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (16, 'N', 'M53369', 'LIGHT ARMORED V M1129', '', 'STRYKER MOUNTED MORTAR CARRIER:', '2355', '2355014818578', '014818578');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (17, 'N', 'M53369', 'LGHT AR VARIA M1129E1', '', 'STRYKER MOUNTED MORTAR CARRIER:', '2355', '2355015050871', '015050871');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (18, 'N', 'M57720', 'LIGHT ARMORED V M1128', '', 'MOBILE GUN: SYSTEM (MGS) (ICV)', '2355', '2355014818577', '014818577');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (19, 'N', 'N96543', 'LIGHT ARMORED V M1135', '', 'NBC: RECONNAIS VEH ICV', '2355', '2355014818579', '014818579');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (20, 'N', 'R62673', 'LIGHT ARMORED V M1127', '', 'RECONNAISSANCE: VEHICLE (ICV)', '2355', '2355014818572', '014818572');

--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (21, 'N', 'T00079', '', '', 'TEST SET LINE: ADVANCED FLIGHT CONTROL SYSTEM CH-47D', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (22, 'N', 'T00535', '', '', 'TRAINER FLIGHT SIMULATOR: CH-47C', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (23, 'N', 'T03095', '', '', 'TRAINER: ELECTRICAL SYSTEMS CH-47C', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (24, 'N', 'T03299', '', '', 'TRAINER: HYDRAULIC BOARD CH-47 SERIES', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (25, 'N', 'T03537', '', '', 'TRAINER: COMPOSITE CH-47C', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (26, 'N', 'T04304', '', '', 'TRAINER: FLIGHT CONTROL SYSTEM CH-47', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (27, 'N', 'T04389', '', '', 'TRAINER STABILITY: CH-47A AUGMENTATION ANDFLIGHT CONTROL ASW-12', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (28, 'N', 'T69889', '', '', 'HELICOPTER SKIS: FOR CH-47C/D', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (29, 'N', 'T69894', '', '', 'TEST SET BENCH: ADVANCED FLIGHT CONTROL SYSTEM CH-47D', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (30, 'N', 'T81985', '', '', 'TEST SET BENCH: INTEGRATED LOWER CONTROL ACTUATOR CH-47D', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (48, 'N', 'Z00911', '', '', '', '', '', '');
--    INSERT INTO mimosa_item_dim (item_id, pfsa_subject_flag, lin, item_nomen, end_item_nomen, gen_nomen, fsc, nsn, niin) VALUES (51, 'N', 'Z33530', '', '', 'HELICOPTER OXYGEN SYSTEM: CH-47', '', '', '');
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT; 
    
    UPDATE mimosa_item_dim 
    SET    ecc_code = -1; 
    
    UPDATE mimosa_item_dim 
    SET    nsn = fsc || niin 
    WHERE  nsn = 'unk'; 
    
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

SELECT nsn,    
    fsc,     
    fn_pfsawh_get_code_ref_desc (1011, fsc) AS fsc_desc,    
    niin,    
    lin,                          
    army_type_designator,    
    item_nomen,
    end_item_nomen,
    gen_nomen,
    lin_active_date,
    lin_inactive_date,
    lin_inactive_statement,
    unit_price,
    unit_indicator,
    eic_code,    
    eic_model,    
    ecc_code,                          
    ecc_desc,     
    mat_cat_cd_1_code,
    fn_pfsawh_get_code_ref_desc (1018, mat_cat_cd_1_code) AS mat_cat_cd_1_desc,
    mat_cat_cd_2_code,
    mat_cat_cd_2_desc,
    mat_cat_cd_3_code,
    mat_cat_cd_3_desc,
    mat_cat_cd_4_code,    
    fn_pfsawh_get_code_ref_desc (1016, mat_cat_cd_4_code) AS mat_cat_cd_4_desc,    
    mat_cat_cd_4_5_code,    
    fn_pfsawh_get_code_ref_desc (1014, mat_cat_cd_4_5_code) AS mat_cat_cd_4_5_desc,    
    cage_code,       
    cage_desc,       
    chap, 
    mscr, 
    uid1_desc,                         
    uid2_desc,   
    type_class_cd,                          
    type_class_cd_desc,    
    sb_700_20_publication_date,                   
    ricc_item_code,                          
    fn_pfsawh_get_code_ref_desc (1017, ricc_item_code) AS ricc_item_desc,    
    aba,
    sos,
    ciic, 
    cl_of_supply_cd,
    cl_of_supply_cd_desc,
    subclass_of_supply_cd_desc 
FROM   mimosa_item_dim item 
ORDER BY item.lin, item.niin; 

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   mimosa_item_dim item 
--ORDER BY item.fsc, item.niin; 
ORDER BY item.lin, item.niin; 

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   mimosa_item_dim item 
WHERE  pfsa_subject_flag = 'Y' 
ORDER BY item.fsc, item.niin; 

*/
    
/*

    UPDATE mimosa_item_dim item 
    SET (chap, 
        lin_active_date, 
        lin_inactive_date, 
        gen_nomen, 
        lin_inactive_statement, 
        ricc_item_code, 
        mat_cat_cd_1_code, 
        sb_700_20_publication_date ) = 
        (
        SELECT	
        lin.chap, 
        lin.dt_assigned, 
        lin.dt_inact,  
        NVL(lin.gen_nomen, 'unk'),  
        NVL(lin.inactive_statement, 'not applicable'), 
        lin.lin_ricc, 
        lin.mat_cat_cd_1, 
        lin.pub_dt_sb_700_20  
        FROM	lin@pfsawh.lidbdev lin
        WHERE	lin.status = 'C' 
        	AND lin.lin = item.lin );  
    
    SELECT	
    item.rec_id, 
    item.item_id, 
    item.nsn, 
    item.lin, 
    lin.lin, 
    lin.chap, 
    lin.dt_assigned, 
    lin.dt_inact,  
    NVL(lin.gen_nomen, 'unk'),  
    lin.inactive_statement, 
    lin.lin_ricc, 
    lin.mat_cat_cd_1, 
    lin.pub_dt_sb_700_20 
    , ' | ', lin.*   
    FROM	lin@pfsawh.lidbdev lin, 
           mimosa_item_dim item 
    WHERE	lin.lin = item.lin 
--    	AND lin.status = 'C'
    ORDER BY item.nsn, 
        lin.lin;  
    
*/ 

/*

    UPDATE	mimosa_item_dim item
    SET ( 
        army_type_designator,
        lin, 
        mscr, 
        gen_nomen, 
        sb_700_20_publication_date  
        ) = 
        (
        SELECT	
        NVL(lin.army_type_design, 'unk'),
        lin.lin, 
        NVL(lin.mscr, '-1'), 
        NVL(lin.shrt_nomen, 'unk'),  
        lin.sb_pub_dt
        FROM	auth_item@pfsawh.lidbdev lin 
        WHERE	lin.status = 'C'
            AND lin.niin = item.niin )
    WHERE item.lin = 'unk';
    
    SELECT	
    lin.niin, 
    NVL(lin.army_type_design, 'unk'),
    lin.lin, 
    NVL(lin.mscr, '-1'), 
    NVL(lin.shrt_nomen, 'unk'),  
    lin.sb_pub_dt
    FROM	auth_item@pfsawh.lidbdev lin,  
           mimosa_item_dim item
    WHERE	lin.status = 'C'
        AND lin.niin = item.niin; 

*/ 

/* 

    UPDATE mimosa_item_dim item 
    SET    ( eic_code, eic_model, 
             mat_cat_cd_4_code, mat_cat_cd_4_5_code
           ) = 
           (
           SELECT  eic.eic, eic.eic_model, 
               eic.mat_cat_cd_4, eic.mat_cat_cd_4_5
           FROM    eic_master@pfsawh.lidbdev eic 
           WHERE	eic.niin = item.niin 
           )
    WHERE  item.eic_code = '-1';  

SELECT	item.rec_id, item.eic_code, item.niin, ' | ', eic.* 
FROM	eic_master@pfsawh.lidbdev eic,  
       mimosa_item_dim item 
WHERE	item.eic_code = '-1' 
    AND eic.niin = item.niin 
ORDER BY eic.eic;

    UPDATE mimosa_item_dim item 
    SET    ( eic_model, mat_cat_cd_4_code, mat_cat_cd_4_5_code 
           ) = 
           (
           SELECT eic.eic_model, 
               eic.mat_cat_cd_4, eic.mat_cat_cd_4_5 
           FROM   eic_master@pfsawh.lidbdev eic 
           WHERE	eic.eic = item.eic_code 
               AND eic.niin = item.niin
           )
    WHERE item.eic_code IS NOT NULL; 

SELECT	item.eic_code, item.niin, ' |', eic.* 
FROM	eic_master@pfsawh.lidbdev eic,  
       mimosa_item_dim item 
WHERE	eic.eic = item.eic_code 
    AND eic.niin = item.niin
ORDER BY eic.eic;

*/

/* 

    UPDATE  mimosa_item_dim item 
    SET ( army_type_designator, 
        ricc_item_code, 
        aba, 
        sos, 
        ciic, 
        supply_class, 
        ecc_code, 
        unit_price,
        unit_indicator,
        item_nomen--, 
--        gen_nomen
        ) = 
        (
        SELECT	NVL(lin.army_type_designator, 'unk'), 
        lin.ricc, 
        lin.aba, 
        lin.sos, 
        lin.ciic, 
        lin.supply_class, 
        lin.ecc, 
        NVL(lin.unit_price, -1), 
        lin.ui, 
        NVL(lin.item_nomen, 'unk')--, 
--        NVL(lin.gen_nomen, 'unk')
        FROM	gcssa_lin@pfsawh.lidbdev lin   
        WHERE	lin.lin = item.lin 
           AND lin.nsn = item.nsn
        )

SELECT	lin.lin, 
    NVL(lin.army_type_designator, 'unk'), 
    lin.nsn, 
    lin.ricc, 
    lin.aba, 
    lin.sos, 
    lin.ciic, 
    lin.supply_class, 
    lin.ecc, 
    NVL(lin.unit_price, -1), 
    lin.ui, 
    NVL(lin.item_nomen, 'unk'), 
    NVL(lin.gen_nomen, 'unk')
FROM	gcssa_lin@pfsawh.lidbdev lin,  
    mimosa_item_dim item 
WHERE	lin.lin = item.lin 
   AND lin.nsn = item.nsn
ORDER BY lin;
   
*/
