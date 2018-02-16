USE [Data_Dictionary] 
GO

-- Verify that the trigger does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[trig_upd_dimxxx]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[trig_upd_dimxxx]
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[dimxxx]') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[dimxxx]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO

--<summary> Short Description </summary>

--<remarks><code>
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- 
--         Table Name: dimxxx
--         Table Desc: 
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 
-- 
--       Table Source: *.sql
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- ddmmmyy - GB  - 00000000 - 0000 - Created 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--</code></remarks>

CREATE TABLE [dbo].[dimxxx] 
(
	[timestamp]			[TIMESTAMP]			NULL ,
	[dim_RecId]			[INT]				IDENTITY (1000000, 1)	NOT NULL ,
	[dim_Key]			[INT]				NOT NULL ,
	[dim_Desc]			[VARCHAR](20)		NOT NULL ,
	
	[active_Fl]			[BIT]				NULL ,
	[active_Dt]			[SMALLDATETIME]		NOT NULL ,
	[inactive_Dt]		[SMALLDATETIME]		NOT NULL ,

	[insert_By]			[VARCHAR](20)		NOT NULL ,
	[insert_Dt]			[SMALLDATETIME]		NOT NULL ,
	[update_By]			[VARCHAR](20)		NULL ,
	[update_Dt]			[SMALLDATETIME]		NOT NULL ,
	[delete_Fl]			[BIT]				NULL ,
	[delete_Dt]			[SMALLDATETIME]		NULL 
) ON [Data_Dictionary_Data]
GO

ALTER TABLE dbo.dimxxx ADD CONSTRAINT
	PK_dimxxx PRIMARY KEY CLUSTERED 
	(
	[dim_Key] 
	) ON [Data_Dictionary_Data]

GO
/*
ALTER TABLE [dbo].[dimxxx]  WITH CHECK ADD  CONSTRAINT [FK_dimxxx_dim_yyy] FOREIGN KEY([dim_Key])
REFERENCES [dbo].[dimxxx_yyy] ([dim_Key])
--GO
*/
ALTER TABLE [dbo].[dimxxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_dimxxx_active_Fl]	DEFAULT (0) FOR [active_Fl] ,
	CONSTRAINT [DF_dimxxx_active_Dt]	DEFAULT ('1/1/1900') FOR [active_Dt] , 
	CONSTRAINT [DF_dimxxx_inactive_Dt]	DEFAULT ('1/1/1900') FOR [inactive_Dt] , 
	CONSTRAINT [DF_dimxxx_insert_By]	DEFAULT (user_name()) FOR [insert_By] , 
	CONSTRAINT [DF_dimxxx_insert_Dt]	DEFAULT (getdate()) FOR [insert_Dt] , 
	CONSTRAINT [DF_dimxxx_update_Dt]	DEFAULT ('1/1/1900') FOR [update_Dt] , 
	CONSTRAINT [DF_dimxxx_delete_Fl]	DEFAULT (0) FOR [delete_Fl] ,
	CONSTRAINT [DF_dimxxx_delete_Dt]	DEFAULT ('1/1/1900') FOR [delete_Dt]  
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dimxxx]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_upd_dimxxx] ON dbo.dimxxx 
FOR UPDATE 
AS

DECLARE	@recId	INT

SELECT	@recId = dim_RecId 
FROM	inserted

UPDATE	dimxxx 
SET	update_By = USER_NAME(),
	update_Dt = GETDATE()
WHERE	dim_RecId = @recId
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
	@level1name = 'dimxxx'
GO
*/
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'dimxxx description', 
	@level0type=N'SCHEMA',
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Identity for dimxxx records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'dim_RecId'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Primary key for dimxxx records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'dim_Key'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record is active or not.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'active_Fl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record became active.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'active_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record went inactive.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'inactive_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was inserted.  Populated using "DF_dimxxx_insert_By."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insert_By'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was inserted.  Populated using "DF_dimxxx_insert_Dt."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insert_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was last updated.  Populated by the trigger "trig_upd_dimxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'update_By'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was last updated.  Populated by the trigger "trig_upd_dimxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'update_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record can be deleted.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'delete_Fl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for delete_Fl indicating when the record was marked for deletion.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'delete_Dt'
GO

/*
---------------------------------------
------- dimxxx           ------- 
---------------------------------------

PRINT	'*** dimxxx ***'
PRINT	'* Insert test *' 

INSERT 
INTO	dim_yyy (CatCd, CodeNm) 
VALUES	(-100, 'Unit test case 1')

INSERT 
INTO	dimxxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 1')

--- Default Review ---

PRINT	'* Default Review *' 

SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	dimxxx 
WHERE	CatCd < 0

----- PRIMARY KEY constraint -----

PRINT	'* PRIMARY KEY constraint *' 

INSERT 
INTO	dimxxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 2')

----- FOREIGN KEY constraint -----

PRINT	'* FOREIGN KEY constraint *' 

INSERT 
INTO	dimxxx (catCd, itmCd, itmTxt) 
VALUES	(-200, -100, 'Unit test case 4')

--- Trigger Review ---

PRINT	'* Trigger Review *' 

UPDATE	dimxxx 
SET		itmTxt = 'Unit test case 3' 
WHERE	catCd = -100 
	AND	itmCd = -100 

SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	dimxxx 
WHERE	CatCd < 0 

----- NOT NULL constraint -----

PRINT	'* NOT NULL constraint *' 

INSERT 
INTO	dimxxx (catCd) 
VALUES	(NULL)

INSERT 
INTO	dimxxx (itmCd) 
VALUES	(NULL)

-----Cleanup -----

PRINT	'* Cleanup *' 

DELETE	dimxxx WHERE CatCd < 0
DELETE	dimxxx_yyy WHERE CatCd < 0

*/
