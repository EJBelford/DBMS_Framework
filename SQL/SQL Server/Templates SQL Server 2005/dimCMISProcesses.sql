USE [CMIS] 
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[trig_upd_dimCMISProcesses]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[trig_upd_dimCMISProcesses]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[dimCMISProcesses]') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[dimCMISProcesses]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO

--<summary> Contains a mapping to the name of the stored procedure or function </summary>

--<remarks><code>
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- 
--         Table Name: dimCMISProcesses
--         Table Desc: Contains a mapping to the name of the stored procedure or function
-- 
--   Table Created By: Gene Belford 
-- Table Created Date: 02 July 2007
-- 
--       Table Source: dimCMISProcesses.sql
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 02Jul07 - GB  - 00000000 - 0000 - Created 
-- 11Jul07 - GB  -          -      - Created under CMIS 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--</code></remarks>

CREATE TABLE [dbo].[dimCMISProcesses] 
(
	[timestamp]			[TIMESTAMP]			NULL ,
	[process_RecId]		[INT]				IDENTITY (1000, 1)	NOT NULL ,
	[process_Key]		[SMALLINT]			NOT NULL ,
	[process_Desc]		[VARCHAR](50)		NOT NULL ,
	
	[active_Fl]			[BIT]				NULL ,
	[active_Dt]			[SMALLDATETIME]		NOT NULL ,
	[inactive_Dt]		[SMALLDATETIME]		NOT NULL ,

	[insert_By]			[VARCHAR](20)		NOT NULL ,
	[insert_Dt]			[SMALLDATETIME]		NOT NULL ,
	[update_By]			[VARCHAR](20)		NULL ,
	[update_Dt]			[SMALLDATETIME]		NOT NULL ,
	[delete_Fl]			[BIT]				NULL ,
	[delete_Dt]			[SMALLDATETIME]		NOT NULL 
) ON [CMIS_CoreData]
GO

ALTER TABLE dbo.dimCMISProcesses ADD CONSTRAINT
	PK_dimCMISProcesses_process_Key PRIMARY KEY CLUSTERED 
	(
	[process_Key] 
	) ON [CMIS_CoreData]
GO
/*
ALTER TABLE [dbo].[dimCMISProcesses]  WITH CHECK ADD  CONSTRAINT [FK_dimCMISProcesses_dim_yyy] FOREIGN KEY([dim_key])
REFERENCES [dbo].[dimCMISProcesses_yyy] ([dim_key])
GO
*/
ALTER TABLE [dbo].[dimCMISProcesses] WITH NOCHECK ADD 
	CONSTRAINT [DF_dimCMISProcesses_active_Fl] DEFAULT (0) FOR [active_Fl] ,
	CONSTRAINT [DF_dimCMISProcesses_active_Dt] DEFAULT (0) FOR [active_Dt] ,
	CONSTRAINT [DF_dimCMISProcesses_inactive_Dt] DEFAULT (0) FOR [inactive_Dt] ,
	CONSTRAINT [DF_dimCMISProcesses_insert_By] DEFAULT (user_name()) FOR [insert_By] , 
	CONSTRAINT [DF_dimCMISProcesses_insert_Dt] DEFAULT (getdate()) FOR [insert_Dt] , 
	CONSTRAINT [DF_dimCMISProcesses_update_Dt] DEFAULT (0) FOR [update_Dt] ,
	CONSTRAINT [DF_dimCMISProcesses_delete_Fl] DEFAULT (0) FOR [delete_Fl] ,
	CONSTRAINT [DF_dimCMISProcesses_delete_Dt] DEFAULT (0) FOR [delete_Dt] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dimCMISProcesses]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_upd_dimCMISProcesses] ON dbo.dimCMISProcesses 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = process_RecId 
FROM	inserted

UPDATE	dimCMISProcesses 
SET	update_By = USER_NAME(),
	update_Dt = GETDATE()
WHERE	process_RecId = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
EXEC sp_dropextendedproperty 
	@name = 'CMIS_Description',  
	@level0type = 'SCHEMA',
	@level0name = 'dbo', 
	@level1type = 'TABLE', 
	@level1name = 'dimCMISProcesses'
GO
*/
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains a mapping to the name of the stored procedure or function', 
	@level0type=N'SCHEMA',
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Identity for dimCMISProcesses records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'process_RecId'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Primary key for dimCMISProcesses records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'process_Key'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record is active or not.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'active_Fl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record became active.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'active_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record went inactive.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'inactive_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was inserted.  Populated using "DF_dimCMISProcesses_insert_By."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'insert_By'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was inserted.  Populated using "DF_dimCMISProcesses_insert_Dt."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'insert_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was last updated.  Populated by the trigger "trig_upd_dimCMISProcesses."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'update_By'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was last updated.  Populated by the trigger "trig_upd_dimCMISProcesses."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'update_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record can be deleted.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'delete_Fl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for delete_Fl indicating when the record was marked for deletion.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimCMISProcesses', 
	@level2type=N'COLUMN', 
	@level2name=N'delete_Dt'
GO

/*
---------------------------------------
------- dimCMISProcesses        ------- 
---------------------------------------

PRINT	'*** dimCMISProcesses ***'
PRINT	'* Insert test *' 

INSERT 
INTO	dimCMISProcesses (process_Key, process_Desc) 
VALUES	(-100, 'Unit test case 1')

--- Default Review ---

PRINT	'* Default Review *' 

SELECT	process_Key, process_Desc, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	dimCMISProcesses 
WHERE	process_Key < -1

----- PRIMARY KEY constraint -----

PRINT	'* PRIMARY KEY constraint *' 

INSERT 
INTO	dimCMISProcesses (process_Key, process_Desc) 
VALUES	(-100, 'Unit test case 1')

----- FOREIGN KEY constraint -----

--PRINT	'* FOREIGN KEY constraint *' 

--INSERT 
--INTO	dimCMISProcesses (process_Key, process_Desc) 
--VALUES	(-100, 'Unit test case 4')

--- Trigger Review ---

PRINT	'* Trigger Review *' 

UPDATE	dimCMISProcesses 
SET		process_Desc = 'Unit test case 3' 
WHERE	process_Key = -100  

SELECT	process_Key, process_Desc, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	dimCMISProcesses 
WHERE	process_Key = -100 

----- NOT NULL constraint -----

PRINT	'* NOT NULL constraint *' 

INSERT 
INTO	dimCMISProcesses (process_Key) 
VALUES	(NULL)

INSERT 
INTO	dimCMISProcesses (process_Desc) 
VALUES	(NULL)

-----Cleanup -----

PRINT	'* Cleanup *' 

DELETE	dimCMISProcesses WHERE process_Key < -1
--DELETE	dimCMISProcesses_yyy WHERE CatCd < 0

*/

-- DELETE dimCMISProcesses

INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( -1, 'unknown')
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES (  0, 'Generic low level')
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 12, 'spr_Ins_RptToCourt')
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 13, 'spr_Sel_RptToCourt')
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 14, 'spr_Upd_RptToCourt')
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 19, 'spr_Sel_RptToCourt_Status')
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 30, 'spr_Ins_CourtCase_ContHist') 
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 91, 'spr_Sel_CTDojProd_IntakeHist') 
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 92, 'spr_Sel_CTDojProd_Code_List') 
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 93, 'spr_Sel_CTDojProd_SResource') 
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 94, 'spr_Sel_CTDojProd_UserSystemProfile') 
INSERT INTO dimCMISProcesses (process_key, process_desc) VALUES ( 95, 'spr_Sel_CTDojProd_Docket') 

/*
SELECT	process_RecId, 
	process_key, 
	process_desc, 
	'|'	/* , 
	active_fl, 
	active_dt, 
	inactive_dt, 
	insert_by, 
	insert_dt, 
	update_by, 
	update_dt, 
	delete_fl, 
	delete_dt */
FROM	dimCMISProcesses
*/