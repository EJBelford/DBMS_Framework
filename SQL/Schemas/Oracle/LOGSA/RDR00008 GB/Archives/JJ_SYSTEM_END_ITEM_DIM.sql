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
CREATE TABLE pfsawh.PFSA_DIM_xxx 
(
	xxx_timestamp		TIMESTAMP			NULL ,
	xxx_RecId			ROWID				NOT NULL ,
	--
	xxx_Key				NUMBER(9)			NOT NULL ,
	xxx_Desc			VARCHAR2(20)		NOT NULL ,
	--
	STATUS				CHAR(1)				NOT NULL ,
	UPDT_BY				VARCHAR2(30)		NULL ,
	LST_UPDT			DATE				NULL ,
	--
	active_Fl			CHAR(1)				NULL ,
	active_Dt			DATE				NOT NULL ,
	inactive_Dt			DATE				NOT NULL ,
	--
	insert_By			VARCHAR2(30)		NOT NULL ,
	insert_Dt			DATE				NOT NULL ,
	delete_Fl			CHAR(1)				NULL ,
	delete_Dt			DATE				NULL ,
	hidden_Fl			CHAR(1)				NULL ,
	hidden_Dt			DATE				NULL 
) --ON [Data_Dictionary_Data]

ALTER TABLE pfsawh.PFSA_DIM_xxx ADD CONSTRAINT
	PK_PFSA_DIM_xxx PRIMARY KEY /*CLUSTERED*/
	(
	xxx_Key 
	) --ON [Data_Dictionary_Data]
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

comment on table JJ_SYSTEM_END_ITEM_DIM is 'JJ_SYSTEM_END_ITEM_DIM description' 

comment on column JJ_SYSTEM_END_ITEM_DIM.SYSTEM_END_ITEM_ID is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.SLXN_GROUPING is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.TYPE_ANAL_VIEW is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.SLXN_SUB_GROUPING is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.ANAL_VIEW is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.END_ITEM_NIIN is 'End Item National Item Identifier Number'
comment on column JJ_SYSTEM_END_ITEM_DIM.END_ITEM_NOMEN is 'End Item National Item Nomenclature'
comment on column JJ_SYSTEM_END_ITEM_DIM.EIC is 'End Item Code'
comment on column JJ_SYSTEM_END_ITEM_DIM.LIN is 'Line Item Number'
comment on column JJ_SYSTEM_END_ITEM_DIM.AIRCARFT is '' 
comment on column JJ_SYSTEM_END_ITEM_DIM.FSC is 'Force Combat System'
comment on column JJ_SYSTEM_END_ITEM_DIM.ECC is 'Equipment Category Code'
comment on column JJ_SYSTEM_END_ITEM_DIM.MAT_CAT_CD_2 is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.MAT_CAT_CD_4_5 is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.CL_OF_SUPPLY_CO is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.SUBCLASS_OF_SUPPLY_CD is ''
comment on column JJ_SYSTEM_END_ITEM_DIM.LAST_UPDATE is 'Date of last update to record.'
comment on column JJ_SYSTEM_END_ITEM_DIM.UPDATE_BY is 'Last person or system to update the record.'

select Table_Name, Comments from USER_TAB_COMMENTS where Table_Name = UPPER('JJ_SYSTEM_END_ITEM_DIM') 

select b.COLUMN_ID, a.Table_Name, a.Column_Name, b.DATA_TYPE, b.DATA_LENGTH, b.NULLABLE, a.Comments 
from USER_COL_COMMENTS a
left outer join USER_TAB_COLUMNS b on b.TABLE_NAME = UPPER('JJ_SYSTEM_END_ITEM_DIM') AND a.COLUMN_NAME = b.COLUMN_NAME
where a.TABLE_NAME = UPPER('JJ_SYSTEM_END_ITEM_DIM') 
order by b.COLUMN_ID 

-- select * from USER_TAB_COLUMNS

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

