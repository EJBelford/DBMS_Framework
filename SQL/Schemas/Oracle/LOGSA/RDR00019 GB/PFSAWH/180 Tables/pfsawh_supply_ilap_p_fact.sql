/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsawh_supply_ilap_p_fact
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: PFSAWH_supply_ilap_p_fact.sql 
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 20 May 2008 
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
-- 20MAY08 - GB  -          -      - Created 
-- 14AUG08 - GB  -          -      - Added SOF field types to get the SSA count 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_supply_ilap_p_fact_seq;

CREATE SEQUENCE pfsawh_supply_ilap_p_fact_seq
    START WITH 1
--    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create Table  -----*/

DROP TABLE pfsawh_supply_ilap_p_fact;
	
CREATE TABLE pfsawh_supply_ilap_p_fact 
(
  REC_ID               NUMBER                   NOT NULL,
  PNIIN                VARCHAR2(11 BYTE),
  ISS_NIIN             VARCHAR2(11 BYTE),
  DOCNO_UIC            VARCHAR2(6 BYTE),
  DOCNO_FORCE_UNIT_ID  NUMBER                   DEFAULT 0,
  NIIN                 VARCHAR2(9 BYTE),
  PNIIN_ITEM_ID        NUMBER                   DEFAULT 0,
  PHYSICAL_ITEM_NIIN   VARCHAR2(9 BYTE),
  PHYSICAL_ITEM_ID     NUMBER                   DEFAULT 0,
  PHYSICAL_ITEM_SN     VARCHAR2(48 BYTE),
  PHYSICAL_ITEM_SN_ID  NUMBER                   DEFAULT 0,
  WH_PERIOD_DATE       DATE,
  WH_PERIOD_DATE_ID    NUMBER                   DEFAULT 0,
  CWT                  NUMBER,
  QTY                  NUMBER,
  D_CUST_ISS           DATE,
  CWT_CNT              NUMBER,
  CWT_MIN              NUMBER,
  CWT_MAX              NUMBER,
  CWT_SUM              NUMBER,
  CWT_AVG              NUMBER,
  CWT_MEAN             NUMBER,
  CWT_50               NUMBER,
  CWT_85               NUMBER,
  STATUS               VARCHAR2(1 BYTE)         DEFAULT 'N',
  UPDT_BY              VARCHAR2(30 BYTE)        DEFAULT USER,
  LST_UPDT             DATE                     DEFAULT SYSDATE,
  ACTIVE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'I',
  ACTIVE_DATE          DATE                     DEFAULT '01-JAN-1900',
  INACTIVE_DATE        DATE                     DEFAULT '31-DEC-2099',
  INSERT_BY            VARCHAR2(30 BYTE)        DEFAULT USER,
  INSERT_DATE          DATE                     DEFAULT SYSDATE,
  UPDATE_BY            VARCHAR2(30 BYTE),
  UPDATE_DATE          DATE                     DEFAULT '01-JAN-1900',
  DELETE_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'N',
  DELETE_DATE          DATE                     DEFAULT '01-JAN-1900',
  HIDDEN_FLAG          VARCHAR2(1 BYTE)         DEFAULT 'Y',
  HIDDEN_DATE          DATE                     DEFAULT '01-JAN-1900',
  DODAAC               VARCHAR2(6 BYTE),
  D_DOCNO              DATE,
  D_SARSS1             DATE,
  PBA_ID               NUMBER                   DEFAULT 1000000,
  ETL_PROCESSED_BY     VARCHAR2(50 BYTE),
  SOF_DVD_CNT          NUMBER                   DEFAULT 0,
  SOF_DVD_BO_CNT       NUMBER                   DEFAULT 0,
  SOF_LAT_OFF_CNT      NUMBER                   DEFAULT 0,
  SOF_LAT_ON_CNT       NUMBER                   DEFAULT 0,
  SOF_LP_CNT           NUMBER                   DEFAULT 0,
  SOF_MAINT_CNT        NUMBER                   DEFAULT 0,
  SOF_REF_OFF_CNT      NUMBER                   DEFAULT 0,
  SOF_REF_ON_CNT       NUMBER                   DEFAULT 0,
  SOF_SSA_CNT          NUMBER                   DEFAULT 0,
  SOF_TI_CNT           NUMBER                   DEFAULT 0,
  SOF_UNK_CNT          NUMBER                   DEFAULT 0,
  SOF_WHSL_BO_CNT      NUMBER                   DEFAULT 0,
  SOF_WHSL_GE_CNT      NUMBER                   DEFAULT 0,
  SOF_WHSL_KO_CNT      NUMBER                   DEFAULT 0,
  SOF_WHSL_KU_CNT      NUMBER                   DEFAULT 0,
  SOF_WHSL_CNT         NUMBER                   DEFAULT 0
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

COMMENT ON TABLE PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT IS 'PFSAWH_supply_ilap_p_fact - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.REC_ID IS 'REC_ID - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.PNIIN IS 'PNIIN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.ISS_NIIN IS 'ISS_NIIN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.DOCNO_UIC IS 'DOCNO_UIC - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.DOCNO_FORCE_UNIT_ID IS 'DOCNO_FORCE_UNIT_ID - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.NIIN IS 'NIIN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.PNIIN_ITEM_ID IS 'PNIIN_ITEM_ID - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.PHYSICAL_ITEM_NIIN IS 'PHYSICAL_ITEM_NIIN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.PHYSICAL_ITEM_ID IS 'PHYSICAL_ITEM_ID - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.PHYSICAL_ITEM_SN IS 'PHYSICAL_ITEM_SN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.PHYSICAL_ITEM_SN_ID IS 'PHYSICAL_ITEM_SN_ID - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.WH_PERIOD_DATE IS 'WH_PERIOD_DATE - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.WH_PERIOD_DATE_ID IS 'WH_PERIOD_DATE_ID - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT IS 'CWT - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.QTY IS 'QTY - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.D_CUST_ISS IS 'D_CUST_ISS - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_CNT IS 'CWT_CNT - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_MIN IS 'CWT_MIN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_MAX IS 'CWT_MAX - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_SUM IS 'CWT_SUM - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_AVG IS 'CWT_AVG - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_MEAN IS 'CWT_MEAN - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_50 IS 'CWT_50 - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.CWT_85 IS 'CWT_85 - ';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.STATUS IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.UPDT_BY IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.LST_UPDT IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.ACTIVE_FLAG IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.ACTIVE_DATE IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.INACTIVE_DATE IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.INSERT_BY IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.INSERT_DATE IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.UPDATE_BY IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.UPDATE_DATE IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.DELETE_FLAG IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.DELETE_DATE IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.HIDDEN_FLAG IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.HIDDEN_DATE IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT.ETL_PROCESSED_BY IS 'ETL_PROCESSED_BY - Indicates which ETL process is responsible for inserting and maintainfing this record.  This is critically for dealing with records similar in nature to the freeze records.';

--
-- PK_PFSAWH_SUPPLY_ILAP_P_FACT  (Index) 
--
CREATE UNIQUE INDEX PFSAWH.PK_PFSAWH_SUPPLY_ILAP_P_FACT ON PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT
(REC_ID)
LOGGING
TABLESPACE PFSA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table PFSAWH_SUPPLY_ILAP_P_FACT 
-- 
ALTER TABLE PFSAWH.PFSAWH_SUPPLY_ILAP_P_FACT ADD (
  CONSTRAINT CK_PFSAWH_SPLY_ILAP_P_FCT_STAT
 CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        ),
  CONSTRAINT CK_PFSAWH_SPLY_ILAP_P_FT_ACTFL
 CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y'),
  CONSTRAINT CK_PFSAWH_SPLY_ILAP_P_FT_DELFL
 CHECK (delete_flag='N' OR delete_flag='Y'),
  CONSTRAINT CK_PFSAWH_SPLY_ILAP_P_FCT_HDFL
 CHECK (hidden_flag='N' OR hidden_flag='Y'),
  CONSTRAINT PK_PFSAWH_SUPPLY_ILAP_P_FACT
 PRIMARY KEY
 (REC_ID)
    USING INDEX 
    TABLESPACE PFSA
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
CONSTRAINT pk_pfsawh_supply_ilap_p_fact PRIMARY KEY 
    (
    rec_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsawh_supply_ilap_p_fact;

CREATE UNIQUE INDEX ixu_pfsawh_supply_ilap_p_fact 
    ON pfsawh_supply_ilap_p_fact
        (
        xx_id
        );

/*----- Foreign Key -----*/

ALTER TABLE pfsawh_supply_ilap_p_fact  
    DROP CONSTRAINT fk_pfsa_code_xx_id;        

ALTER TABLE pfsawh_supply_ilap_p_fact  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY (xx_id) 
    REFERENCES xx_pfsa_yyyyy_dim(xx_id);

/*----- Constraints -----*/

ALTER TABLE pfsawh_supply_ilap_p_fact  
    DROP CONSTRAINT ck_pfsawh_sply_ilap_p_ft_actfl ;        

ALTER TABLE pfsawh_supply_ilap_p_fact  
    ADD CONSTRAINT ck_pfsawh_sply_ilap_p_ft_actfl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE pfsawh_supply_ilap_p_fact  
    DROP CONSTRAINT ck_pfsawh_sply_ilap_p_ft_delfl;        

ALTER TABLE pfsawh_supply_ilap_p_fact  
    ADD CONSTRAINT ck_pfsawh_sply_ilap_p_ft_delfl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE pfsawh_supply_ilap_p_fact  
    DROP CONSTRAINT ck_pfsawh_sply_ilap_p_fct_hdfl;       

ALTER TABLE pfsawh_supply_ilap_p_fact  
    ADD CONSTRAINT ck_pfsawh_sply_ilap_p_fct_hdfl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE pfsawh_supply_ilap_p_fact  
    DROP CONSTRAINT ck_pfsawh_sply_ilap_p_fct_stat;        

ALTER TABLE pfsawh_supply_ilap_p_fact  
    ADD CONSTRAINT ck_pfsawh_sply_ilap_p_fct_stat 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Create the Trigger now -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE pfsawh_supply_ilap_p_fact 
IS 'PFSAWH_supply_ilap_p_fact - '; 


COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.rec_id 
IS 'REC_ID - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.pniin 
IS 'PNIIN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.iss_niin 
IS 'ISS_NIIN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.docno_uic 
IS 'DOCNO_UIC - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.docno_force_unit_id 
IS 'DOCNO_FORCE_UNIT_ID - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.niin 
IS 'NIIN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.pniin_item_id 
IS 'PNIIN_ITEM_ID - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.physical_item_niin 
IS 'PHYSICAL_ITEM_NIIN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.physical_item_id 
IS 'PHYSICAL_ITEM_ID - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.physical_item_sn 
IS 'PHYSICAL_ITEM_SN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.wh_period_date 
IS 'WH_PERIOD_DATE - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.wh_period_date_id 
IS 'WH_PERIOD_DATE_ID - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.qty 
IS 'QTY - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.d_cust_iss 
IS 'D_CUST_ISS - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_cnt 
IS 'CWT_CNT - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_min 
IS 'CWT_MIN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_max 
IS 'CWT_MAX - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_sum 
IS 'CWT_SUM - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_avg 
IS 'CWT_AVG - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_mean 
IS 'CWT_MEAN - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_50 
IS 'CWT_50 - '; 

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.cwt_85 
IS 'CWT_85 - '; 
    
COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN pfsawh_supply_ilap_p_fact.etl_processed_by 
IS 'ETL_PROCESSED_BY - Indicates which ETL process is responsible for inserting and maintainfing this record.  This is critically for dealing with records similar in nature to the freeze records.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('pfsawh_supply_ilap_p_fact'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('pfsawh_supply_ilap_p_fact') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('pfsawh_supply_ilap_p_fact') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%ITEM_SYS_EI_ID%'); 
   
