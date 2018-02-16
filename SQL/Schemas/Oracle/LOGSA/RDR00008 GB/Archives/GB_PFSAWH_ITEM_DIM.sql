DROP TABLE PFSAWH.gb_pfsawh_item_dim;

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: gb_pfsawh_item_dim
--      PURPOSE: A major grouping End Items. 
--
-- TABLE SOURCE: gb_pfsawh_item_dim.sql
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
CREATE TABLE gb_pfsawh_item_dim
(
    REC_ID                        NUMBER              NOT NULL,
    ITEM_ID                       NUMBER              DEFAULT 0,
    PFSA_SUBJECT_FLAG             VARCHAR2(1)         DEFAULT 'N',                          
-- Line Item Number    
    LIN                           VARCHAR2(6),                          
-- 'Model number'    
    ARMY_TYPE_DESIGNATOR          VARCHAR2(30)        DEFAULT 'unk',    
    ITEM_NOMEN                    VARCHAR2(35)        DEFAULT 'unk',
    END_ITEM_NOMEN                VARCHAR2(35)        DEFAULT 'unk',
    GEN_NOMEN                     VARCHAR2(64)        DEFAULT 'unk',
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
-- National Item Identification Number    
    NIIN                          VARCHAR2(9)         DEFAULT 'unk',    
-- End Item Code     
    EIC_CODE                      VARCHAR2(3)         DEFAULT '-1',    
-- End Item Code     
    EIC_DESC                      VARCHAR2(20)        DEFAULT 'unk',    
-- Equipment Category Code    
    ECC_CODE                      VARCHAR2(3)         DEFAULT '-1',                          
-- Equipment Category Code Description    
    ECC_DESC                      VARCHAR2(20)        DEFAULT 'unk',     
-- Materiel Category Structure Code    
    MAT_CAT_CD_1                  VARCHAR2(1),
    MAT_CAT_CD_1_DESC             VARCHAR2(20),
    MAT_CAT_CD_2_DESC             VARCHAR2(1),
    MAT_CAT_CD_4_5_DESC           VARCHAR2(2),    
-- Commercial And Government Entity
    CAGE_CODE                     VARCHAR2(5)         DEFAULT '-1',       
    CAGE_DESC                     VARCHAR2(20)        DEFAULT 'unk',       
    CHAP                          VARCHAR2(1), 
-- Materiel Status Committee Record 
    MSCR                          VARCHAR2(8), 
-- Unique IDentification Construct 1    
    UID1_DESC                     VARCHAR2(15),                         
-- Unique IDentification Construct 2    
    UID2_DESC                     VARCHAR2(19),   
-- Army Type Class Code                      
    TYPE_CLASS_CD                 VARCHAR2(1),                          
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
    RICC_ITEM_CODE                VARCHAR2(1),                          
    ABA                           VARCHAR2(1),
    SOS                           VARCHAR2(3),
    CIIC                          VARCHAR2(1), 
-- Condition Based Maintenance Flag     
    CBM_SENSOR_FL                 VARCHAR2(1)         DEFAULT 'N' ,     
--
    AIRCRAFT                      VARCHAR2(1),
    SUPPLY_CLASS                  VARCHAR2(1),
    SUPPLY_CLASS_DESC             VARCHAR2(2),
    CL_OF_SUPPLY_CD               VARCHAR2(1),
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

CREATE UNIQUE INDEX pk_gb_pfsawh_item_dim ON gb_pfsawh_item_dim
    (rec_id)
    LOGGING
    NOPARALLEL;

ALTER TABLE gb_pfsawh_item_dim  
    DROP CONSTRAINT pk_gb_item_dim;        

ALTER TABLE gb_pfsawh_item_dim 
	 ADD CONSTRAINT pk_gb_item_dim 
    PRIMARY KEY 
        (
        item_id
        );

-- Constraints 

ALTER TABLE gb_pfsawh_item_dim  
    DROP CONSTRAINT ck_item_dim_subj_flg        

ALTER TABLE gb_pfsawh_item_dim  
    ADD CONSTRAINT ck_item_dim_subj_flg 
    CHECK (pfsa_subject_flag='Y'    OR pfsa_subject_flag='N');
    
/*
ALTER TABLE gb_pfsawh_item_dim  
    DROP CONSTRAINT ck_item_dim_flt_typ_dsc        

ALTER TABLE gb_pfsawh_item_dim  
    ADD CONSTRAINT ck_item_dim_flt_typ_dsc 
    CHECK (fleet_type_desc='AVIATION'    OR fleet_type_desc='COMMUNICATIONS' 
        OR fleet_type_desc='ELECTRONICS' OR fleet_type_desc='GROUND' 
        OR fleet_type_desc='WATER'       OR fleet_type_desc='NOT APPLICABLE'
        );

ALTER TABLE gb_pfsawh_item_dim  
    DROP CONSTRAINT ck_item_dim_flt_sbtyp_dsc        

ALTER TABLE gb_pfsawh_item_dim  
    ADD CONSTRAINT ck_item_dim_flt_sbtyp_dsc 
    CHECK (fleet_subtype_desc='AIRCRAFT' OR fleet_subtype_desc='HELICOPTER' 
        OR fleet_subtype_desc='TRACKED'  OR fleet_subtype_desc='WHEELED' 
        OR fleet_subtype_desc='NOT APPLICABLE'
        );
        
ALTER TABLE gb_pfsawh_item_dim  
    DROP CONSTRAINT CK_item_DIM_FLT_CAPAB_DSC        

ALTER TABLE gb_pfsawh_item_dim  
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

-- Trigger 

DROP TRIGGER tr_i_gb_pfsa_item_seq;

CREATE OR REPLACE TRIGGER tr_i_gb_pfsa_item_seq
BEFORE INSERT
ON gb_pfsawh_item_dim
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    TR_I_GB_PFSA_ITEM_SEQ

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

begin
   v_rec_dim_id := 0;

   select pfsawh_item_seq.nextval into v_rec_dim_id from dual;
   :new.rec_id := v_rec_dim_id;
   :new.status := 'Z';
   :new.lst_updt := sysdate;
   :new.updt_by  := user;

   exception
     when others then
       -- consider logging the error and then re-raise
       raise;
       
end tr_i_gb_pfsa_item_seq;

/*----- Table Meta-Data -----*/ 
    
COMMENT ON TABLE gb_pfsawh_item_dim 
IS 'PFSA_ITEM_DIM - Primary field is LIN.';
    
    
COMMENT ON COLUMN gb_pfsawh_item_dim.rec_id 
IS 'Sequence/identity for dimension.'; 

COMMENT ON COLUMN gb_pfsawh_item_dim.item_id 
IS 'Identitier for item/part.'; 

COMMENT ON COLUMN gb_pfsawh_item_dim.pfsa_subject_flag
IS 'Indicates if the item has been. is or will be the subject of PFSA analysis.';

COMMENT ON COLUMN gb_pfsawh_item_dim.lin 
IS 'LIN - Line Iten Number';

COMMENT ON COLUMN gb_pfsawh_item_dim.army_type_designator 
IS 'Model number';

COMMENT ON COLUMN gb_pfsawh_item_dim.item_nomen 
IS 'Description of the item.  On initial load it was taken from gcssa_lin.item_nomen.';

COMMENT ON COLUMN gb_pfsawh_item_dim.end_item_nomen 
IS 'Description of the item.  ';

COMMENT ON COLUMN gb_pfsawh_item_dim.gen_nomen 
IS 'Description of the item.  On initial load it was taken from gcssa_lin.gen_nomen.';

COMMENT ON COLUMN gb_pfsawh_item_dim.lin_active_date 
IS 'SUPPLY BULLETIN 700-20 ASSIGNED DATE - The date the National Item Identification Number (NIIN) was assigned to a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN gb_pfsawh_item_dim.lin_inactive_date 
IS 'SUPPLY BULLETIN 700-20 INACTIVE DATE - The date the National Item Identification Number (NIIN) was inactivated from a specific Line Item Number (LIN).  The value of this field can be changed only when it is a future date.';

COMMENT ON COLUMN gb_pfsawh_item_dim.lin_inactive_statement 
IS '';

COMMENT ON COLUMN gb_pfsawh_item_dim.unit_price 
IS 'Cost per unit of the item.  On initial load it was taken from gcssa_lin.unit_price.';

COMMENT ON COLUMN gb_pfsawh_item_dim.unit_indicator 
IS 'Cost per unit of the item.  On initial load it was taken from gcssa_lin.ui.';

COMMENT ON COLUMN gb_pfsawh_item_dim.fsc 
IS 'Federal Supply Classification';            

COMMENT ON COLUMN gb_pfsawh_item_dim.nsn 
IS 'National Stock Number';

COMMENT ON COLUMN gb_pfsawh_item_dim.niin 
IS 'National Item Identification Number';

COMMENT ON COLUMN gb_pfsawh_item_dim.eic_code 
IS 'End Item Code';
 
COMMENT ON COLUMN gb_pfsawh_item_dim.eic_desc 
IS 'End Item Code Desc';
 
COMMENT ON COLUMN gb_pfsawh_item_dim.ecc_code 
IS 'Equipment Category Code';

COMMENT ON COLUMN gb_pfsawh_item_dim.ecc_desc 
IS '';

COMMENT ON COLUMN gb_pfsawh_item_dim.mat_cat_cd_2_desc 
IS 'APPROPRIATION AND BUDGET ACTIVITY ACCOUNT CODE DESCRIPTION - A description of the Appropriation and Budget Activity Account Code (MAT_CAT_CD_2).';

COMMENT ON COLUMN gb_pfsawh_item_dim.mat_cat_cd_4_5_desc 
IS 'MATERIEL CATEGORY CODE - The fourth and fifth positions of the five-position, alphanumeric Materiel Category Structure Code (MATCAT).  Position 4 is the specific group/generic code.  It is alphanumeric, excluding the letter O and the numeral 1.  This code provides further subdivision of those items identified by Positions 1 - 3.  Position 5 is the generic category code.  It is alphanumeric, excluding the letters I and O.  This code identifies items to weapons systems/end items or other applications.  (Ref. CDA PAM NO. 18-1.)';

COMMENT ON COLUMN gb_pfsawh_item_dim.cage_desc 
IS 'Commercial And Government Entity';

COMMENT ON COLUMN gb_pfsawh_item_dim.chap 
IS 'CHAPTER - Identifies the chapter or appendix of SB 700-20 in which an instance of the materiel item is published.';

COMMENT ON COLUMN gb_pfsawh_item_dim.mscr 
IS 'Materiel Status Committee Record identifier - The identifier assigned by the materiel status office to the record of the decisions and actions reported by materiel developers.'

COMMENT ON COLUMN gb_pfsawh_item_dim.uid1_desc 
IS 'Unique IDentification Construct 1';

COMMENT ON COLUMN gb_pfsawh_item_dim.uid2_desc 
IS 'Unique IDentification Construct 2';

COMMENT ON COLUMN gb_pfsawh_item_dim.type_class_cd 
IS '';

COMMENT ON COLUMN gb_pfsawh_item_dim.type_class_cd_desc 
IS '';

COMMENT ON COLUMN gb_pfsawh_item_dim.sb_700_20_publication_date 
IS 'SUPPLY BULLETIN 700-20 PUBLICATION DATE - The next date the information is to be published.';

COMMENT ON COLUMN gb_pfsawh_item_dim.ricc_item_code 
IS 'Reportable Item Control Code - On initial load it was taken from gcssa_lin.ricc.';

COMMENT ON COLUMN gb_pfsawh_item_dim.aba 
IS 'Appropriation And Budget Activity - On initial load it was taken from gcssa_lin.aba.';

COMMENT ON COLUMN gb_pfsawh_item_dim.sos 
IS 'Source Of Supply - On initial load it was taken from gcssa_lin.sos.';

COMMENT ON COLUMN gb_pfsawh_item_dim.ciic 
IS 'Controlled Inventory Item Code - On initial load it was taken from gcssa_lin.ciic.';

COMMENT ON COLUMN gb_pfsawh_item_dim.cbm_sensor_fl 
IS 'Condition Based Maintenance Flag'; 

COMMENT ON COLUMN gb_pfsawh_item_dim.aircraft  
IS '';

COMMENT ON COLUMN gb_pfsawh_item_dim.supply_class 
IS 'SUPPLY CLASS - A code that indicates the major category of materiel to which an item of supply is assigned.';

COMMENT ON COLUMN gb_pfsawh_item_dim.supply_class_desc 
IS '';

/*
COMMENT ON COLUMN gb_pfsawh_item_dim.cl_of_supply_cd 
IS 'CLASS OF SUPPLY - The code that represents the category of use for which an item of equipment is authorized in support of logistics decisions.';
*/

COMMENT ON COLUMN gb_pfsawh_item_dim.cl_of_supply_cd_desc 
IS 'CLASS OF SUPPLY CODE DESCRIPTION - A description of the Class of Supply Code (CL_OF_SUPPLY_CD).';

/*
COMMENT ON COLUMN gb_pfsawh_item_dim.subclass_of_supply_cd 
IS 'SUBCLASSIFICATION OF SUPPLY CODE - The code that represents a subdivision of the supply category of materiel code.  The further identification of an item of supply to a specific commodity.';

COMMENT ON COLUMN gb_pfsawh_item_dim.subclass_of_supply_desc 
IS 'SUBCLASSIFICATION OF SUPPLY CODE DESCRIPTION - A description of the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';

COMMENT ON COLUMN gb_pfsawh_item_dim.subclass_of_supply_name 
IS 'SUBCLASSIFICATION OF SUPPLY CODE NAME - A short name for the Subclassification of Supply Code (SUBCLASS_OF_SUPPLY_CD).';
*/

comment on column gb_pfsawh_item_dim.status 
is 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]'

comment on column gb_pfsawh_item_dim.updt_by 
is 'The date/timestamp of when the record was created/updated.'
    
comment on column gb_pfsawh_item_dim.lst_updt 
is 'Indicates either the program name or user ID of the person who updated the record.'
    
comment on column gb_pfsawh_item_dim.active_flag 
is 'Flag indicating if the record is active or not.'
   
comment on column gb_pfsawh_item_dim.active_date 
is 'Additional control for active_Flag indicating when the record became active.'
    
comment on column gb_pfsawh_item_dim.INACTIVE_DATE 
is 'Additional control for active_Flag indicating when the record went inactive.'
    
comment on column gb_pfsawh_item_dim.INSERT_BY 
is 'Reports who initially created the record.'
    
comment on column gb_pfsawh_item_dim.INSERT_DATE 
is 'Reports when the record was initially created.'
    
comment on column gb_pfsawh_item_dim.UPDATE_BY 
is 'Reports who last updated the record.'
    
comment on column gb_pfsawh_item_dim.UPDATE_DATE 
is 'Reports when the record was last updated.'
    
comment on column gb_pfsawh_item_dim.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'
    
comment on column gb_pfsawh_item_dim.DELETE_DATE 
is 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.'
    
comment on column gb_pfsawh_item_dim.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'
    
comment on column gb_pfsawh_item_dim.HIDDEN_DATE 
is 'Additional control for HIDDEN_FLAG indicating when the record was hidden.'
    
/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_item_dim') 
    
/*----- Check to see if the table column comments are present -----*/
    
SELECT b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_item_dim') 
    AND a.column_name = b.column_name
WHERE a.table_name = UPPER('gb_pfsawh_item_dim') 
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

    DELETE gb_pfsawh_item_dim;
    s0_recDeletedInt  := SQL%ROWCOUNT;
        
    INSERT 
    INTO	gb_pfsawh_item_dim 
    ( 
    item_id, 
    lin, 
    chap,  
    lin_active_date,
    lin_inactive_date,
    gen_nomen, 
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
    
    UPDATE gb_pfsawh_item_dim 
    SET    (niin) = 
               ( SELECT MAX(auth.niin)  
                 FROM   auth_item@pfsawh.lidbdev auth
                 WHERE  lin = auth.lin 
                     AND auth.status = 'C' 
               ); 
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    COMMIT;

    INSERT 
    INTO	gb_pfsawh_item_dim 
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
    
    UPDATE gb_pfsawh_item_dim a
    SET    (fsc, nsn) = 
               ( SELECT fsc, NVL(nsn, fsc || niin)  
                 FROM   item_control@pfsawh.lidbdev ctrl
                 WHERE  a.niin = ctrl.niin  
               )
    WHERE  UPPER(a.fsc) = 'UNK';        
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    UPDATE gb_pfsawh_item_dim 
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
FROM   gb_pfsawh_item_dim item 
--ORDER BY item.fsc, item.niin; 
ORDER BY item.lin, item.niin; 

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   gb_pfsawh_item_dim item 
WHERE  pfsa_subject_flag = 'Y' 
ORDER BY item.fsc, item.niin; 

DELETE gb_pfsawh_item_dim  
WHERE  pfsa_subject_flag = 'Y';

-- COMMIT;

SELECT item.fsc, item.niin, item.nsn, 
    '|', auth.*, 
    '|', item.* 
FROM   gb_pfsawh_item_dim item, 
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
    
