--USE [Data_Dictionary] 
--
-- Verify that the trigger does not already exist.
/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[trig_upd_PFSA_DIM_xxx]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[trig_upd_PFSA_DIM_xxx]
--
*/
-- Verify that the stored procedure does not already exist.

SELECT * FROM dba_tables WHERE table_name = UPPER('PFSA_DIM_xxx') 
	AND OWNER = 'PFSAWH'
	
IF EXISTS (SELECT * FROM dba_tables WHERE table_name = 'PFSA_DIM_XXX') 
	DROP TABLE PFSA_DIM_XXX 
	
/*
SET ANSI_NULLS OFF

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING OFF

*/
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*----|----*---*/
--
--         NAME: %YourObjectName%
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: %YourObjectName%.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 
--
--   PARAMETERS:
--
--        INPUT:
--
--       OUTPUT:
--
--  ASSUMPTIONS:
--
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--
CREATE TABLE JJ_EQUIP_AVAIL_FACT
(
  SYSTEM_END_ITEM_ID  INTEGER				NOT NULL,
  SERIAL_NUMBER_ID    INTEGER				NOT NULL ,
  ORG_ID              INTEGER,
  GEO_ID              INTEGER,
  FROM_DATE_ID        INTEGER				NOT NULL ,
  TO_DATE_ID          INTEGER,
  READY_DATE_ID       INTEGER,
  RECORD_TYPE         VARCHAR2(1 BYTE)		NOT NULL ,
  ITEM_DAYS           NUMBER,
  PERIOD_HOURS        NUMBER,
  NMCM_HOURS          NUMBER,
  NMCS_HOURS          NUMBER,
  NMC_HOURS           NUMBER,
  FMC_HOURS           NUMBER,
  PMC_HOURS           NUMBER,
  MC_HOURS            NUMBER,
  DEPOT_HOURS         NUMBER,
  PROJECT_CODE_ID     INTEGER				NOT NULL ,
  PFSA_ITEM_ID        VARCHAR2(20 BYTE),
  LAST_UPDATE         DATE,
  UPDATE_BY           VARCHAR2(20 BYTE),
  CL_OF_SUPPLY_CD     VARCHAR2(1 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX PK_JJ_EQUIP_AVAIL_FACT ON JJ_EQUIP_AVAIL_FACT
(SYSTEM_END_ITEM_ID, SERIAL_NUMBER_ID, PROJECT_CODE_ID, RECORD_TYPE, FROM_DATE_ID)
LOGGING
NOPARALLEL;


ALTER TABLE JJ_EQUIP_AVAIL_FACT ADD (
  CONSTRAINT PK_JJ_EQUIP_AVAIL_FACT
 PRIMARY KEY
 (SYSTEM_END_ITEM_ID, SERIAL_NUMBER_ID, PROJECT_CODE_ID, RECORD_TYPE, FROM_DATE_ID));

 
CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_SYSTEM ON JJ_EQUIP_AVAIL_FACT
(SYSTEM_END_ITEM_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_SERIAL_NUM ON JJ_EQUIP_AVAIL_FACT
(SERIAL_NUMBER_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_ORG ON JJ_EQUIP_AVAIL_FACT
(ORG_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_GEO ON JJ_EQUIP_AVAIL_FACT
(GEO_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_FROM_DATE ON JJ_EQUIP_AVAIL_FACT
(FROM_DATE_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_TO_DATE ON JJ_EQUIP_AVAIL_FACT
(TO_DATE_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_EQUIP_AVAIL_FACT_READY_DATE ON JJ_EQUIP_AVAIL_FACT
(READY_DATE_ID)
LOGGING
NOPARALLEL;


CREATE BITMAP INDEX BM_JJ_EQUIP_AVAIL_FACT_PROJECT ON JJ_EQUIP_AVAIL_FACT
(PROJECT_CODE_ID)
LOGGING
NOPARALLEL;


--
/*
ALTER TABLE [dbo].[PFSA_DIM_xxx]  WITH CHECK ADD  CONSTRAINT [FK_PFSA_DIM_xxx_dim_yyy] FOREIGN KEY([dim_Key])
REFERENCES [dbo].[PFSA_DIM_xxx_yyy] ([dim_Key])
--
*/
ALTER TABLE pfsawh.PFSA_DIM_xxx /*WITH NOCHECK*/ ADD 
	CONSTRAINT DF_PFSA_DIM_xxx_active_Fl	DEFAULT (0) FOR [active_Fl] ,
	CONSTRAINT DF_PFSA_DIM_xxx_active_Dt	DEFAULT ('1/1/1900') FOR [active_Dt] , 
	CONSTRAINT DF_PFSA_DIM_xxx_inactive_Dt	DEFAULT ('1/1/1900') FOR [inactive_Dt] , 
	CONSTRAINT DF_PFSA_DIM_xxx_insert_By	DEFAULT (user_name()) FOR [insert_By] , 
	CONSTRAINT DF_PFSA_DIM_xxx_insert_Dt	DEFAULT (getdate()) FOR [insert_Dt] , 
	CONSTRAINT DF_PFSA_DIM_xxx_update_Dt	DEFAULT ('1/1/1900') FOR [update_Dt] , 
	CONSTRAINT DF_PFSA_DIM_xxx_delete_Fl	DEFAULT (0) FOR [delete_Fl] ,
	CONSTRAINT DF_PFSA_DIM_xxx_delete_Dt	DEFAULT ('1/1/1900') FOR [delete_Dt] ,  
	CONSTRAINT DF_PFSA_DIM_xxx_hidden_Fl	DEFAULT (0) FOR [hidden_Fl] ,
	CONSTRAINT DF_PFSA_DIM_xxx_hidden_Dt	DEFAULT ('1/1/1900') FOR [hidden_Dt]  

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PFSA_DIM_xxx]  TO [public]

SET QUOTED_IDENTIFIER ON 

SET ANSI_NULLS ON 

CREATE TRIGGER [TR_U_PFSA_DIM_xxx] ON dbo.PFSA_DIM_xxx 
FOR UPDATE 
AS
DECLARE	@recId	INT
SELECT	@recId = dim_RecId 
FROM	inserted
UPDATE	PFSA_DIM_xxx 
SET	UPDT_BY = USER_NAME(),
	LST_UPDT = GETDATE()
WHERE	dim_RecId = @recId

SET QUOTED_IDENTIFIER OFF 

SET ANSI_NULLS ON 

/*
EXEC sp_dropextendedproperty 
	@name = 'CMIS_Description',  
	@level0type = 'SCHEMA',
	@level0name = 'dbo', 
	@level1type = 'TABLE', 
	@level1name = 'PFSA_DIM_xxx'

*/

comment on table JJ_EQUIP_AVAIL_FACT is 'JJ_EQUIP_AVAIL_FACT description' 

comment on column JJ_EQUIP_AVAIL_FACT.SYSTEM_END_ITEM_ID is '' 
comment on column JJ_EQUIP_AVAIL_FACT.SERIAL_NUMBER_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.ORG_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.GEO_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.FROM_DATE_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.TO_DATE_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.READY_DATE_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.PROJECT_CODE_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.PFSA_ITEM_ID is ''
comment on column JJ_EQUIP_AVAIL_FACT.RECORD_TYPE is ''
comment on column JJ_EQUIP_AVAIL_FACT.CL_OF_SUPPLY_CD is ''
--
comment on column JJ_EQUIP_AVAIL_FACT.ITEM_DAYS is ''
comment on column JJ_EQUIP_AVAIL_FACT.PERIOD_HOURS is ''
comment on column JJ_EQUIP_AVAIL_FACT.NMCM_HOURS is 'Hours Not Mission Capable Maintenance (?since fielding/what?) - An inoperable end item for which a repair part exists at the maintenance unit, and is awaiting the completion of the maintenance action that will replace the broken part.'
comment on column JJ_EQUIP_AVAIL_FACT.NMCS_HOURS is 'Hours Not Mission Capable Supply (?since fielding/what?) - An inoperable end item which needs one or more repair parts in order to affect the repair to make it fully mission capable.'
comment on column JJ_EQUIP_AVAIL_FACT.NMC_HOURS is 'Hours Not Mission Capable - An inoperable end item.'
comment on column JJ_EQUIP_AVAIL_FACT.FMC_HOURS is 'Hours Fully Mission Capable - '
comment on column JJ_EQUIP_AVAIL_FACT.PMC_HOURS is 'Hours Partially Mission Capable - The end item has suffered a failed component.  However, the component is not so essential as to render the end item completely inoperable.  It is judged to still be capable of fulfilling some missions.'
comment on column JJ_EQUIP_AVAIL_FACT.MC_HOURS is 'Hours Mission Capable - '
comment on column JJ_EQUIP_AVAIL_FACT.DEPOT_HOURS is ''

comment on column JJ_EQUIP_AVAIL_FACT.LAST_UPDATE is ''
comment on column JJ_EQUIP_AVAIL_FACT.UPDATE_BY is ''

select Table_Name, Comments from USER_TAB_COMMENTS where Table_Name = UPPER('JJ_EQUIP_AVAIL_FACT') 

select b.COLUMN_ID, a.Table_Name, a.Column_Name, b.DATA_TYPE, b.DATA_LENGTH, b.NULLABLE, a.Comments 
from USER_COL_COMMENTS a
left outer join USER_TAB_COLUMNS b on b.TABLE_NAME = UPPER('JJ_EQUIP_AVAIL_FACT') AND a.COLUMN_NAME = b.COLUMN_NAME
where a.TABLE_NAME = UPPER('JJ_EQUIP_AVAIL_FACT') 
order by b.COLUMN_ID 

/*
---------------------------------------
------- PFSA_DIM_xxx                  ------- 
---------------------------------------
PRINT	'*** PFSA_DIM_xxx ***'
PRINT	'* Insert test *' 
INSERT 
INTO	dim_yyy (CatCd, CodeNm) 
VALUES	(-100, 'Unit test case 1')
INSERT 
INTO	PFSA_DIM_xxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 1')
--- Default Review ---
PRINT	'* Default Review *' 
SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	PFSA_DIM_xxx 
WHERE	CatCd < 0
----- PRIMARY KEY constraint -----
PRINT	'* PRIMARY KEY constraint *' 
INSERT 
INTO	PFSA_DIM_xxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 2')
----- FOREIGN KEY constraint -----
PRINT	'* FOREIGN KEY constraint *' 
INSERT 
INTO	PFSA_DIM_xxx (catCd, itmCd, itmTxt) 
VALUES	(-200, -100, 'Unit test case 4')
--- Trigger Review ---
PRINT	'* Trigger Review *' 
UPDATE	PFSA_DIM_xxx 
SET		itmTxt = 'Unit test case 3' 
WHERE	catCd = -100 
	AND	itmCd = -100 
SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	PFSA_DIM_xxx 
WHERE	CatCd < 0 
----- NOT NULL constraint -----
PRINT	'* NOT NULL constraint *' 
INSERT 
INTO	PFSA_DIM_xxx (catCd) 
VALUES	(NULL)
INSERT 
INTO	PFSA_DIM_xxx (itmCd) 
VALUES	(NULL)
-----Cleanup -----
PRINT	'* Cleanup *' 
DELETE	PFSA_DIM_xxx WHERE CatCd < 0
DELETE	PFSA_DIM_xxx_yyy WHERE CatCd < 0
*/

