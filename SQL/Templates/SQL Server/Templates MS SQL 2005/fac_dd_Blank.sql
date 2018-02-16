USE [Data_Dictionary] 
GO

-- Verify that the trigger does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[facxxx_Upd]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[facxxx_Upd]
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM  dbo.sysobjects WHERE id = object_id(N'[dbo].[facxxx]') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[facxxx]
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
--         Table Name: facxxx 
--         Table Desc: 
-- 
--   Table Created By: Gene Belford
-- Table Created Date: DD MMM YYYY
-- 
--       Table Source: *.sql
-- 
------*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- ddmmmyy - GB  - 00000000 - 0000 - Created
-- 
------*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--</code></remarks>

CREATE TABLE [dbo].[facxxx] 
(
	[timestamp]				[TIMESTAMP]			NULL ,
	[xxx_recId]				[INT]				IDENTITY (1000000, 1) NOT NULL ,
	[fac_Key]				[INT]				NOT NULL ,
	[fac_Desc]				[VARCHAR](20)		NULL ,
	
	[active_Fl]				[BIT]				NULL ,
	[active_Dt]				[SMALLDATETIME]		NOT NULL ,
	[inactive_Dt]			[SMALLDATETIME]		NOT NULL ,

	[insert_By]				[VARCHAR](20)		NOT NULL ,
	[insert_Dt]				[SMALLDATETIME]		NOT NULL ,
	[update_By]				[VARCHAR](20)		NULL ,
	[update_Dt]				[SMALLDATETIME]		NOT NULL ,
	[delete_Fl]				[BIT]				NULL ,
	[delete_Dt]				[SMALLDATETIME]		NOT NULL 
) ON [Data_Dictionary_Data]
GO

ALTER TABLE dbo.facxxx ADD CONSTRAINT
	PK_facxxx PRIMARY KEY CLUSTERED 
	(
	[xxx_recId] 
	) ON [Data_Dictionary_Data]
GO
/*
ALTER TABLE [dbo].[facxxx]  WITH CHECK ADD  CONSTRAINT [FK_facxxx_facyyy] FOREIGN KEY([rec_id])
REFERENCES [dbo].[facyyy] ([rec_id])
--GO
*/
ALTER TABLE [dbo].[facxxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_facxxx_active_Fl]	DEFAULT (0) FOR [active_Fl] ,
	CONSTRAINT [DF_facxxx_active_Dt]	DEFAULT ('1/1/1900') FOR [active_Dt] , 
	CONSTRAINT [DF_facxxx_inactive_Dt]	DEFAULT ('1/1/1900') FOR [inactive_Dt] , 
	CONSTRAINT [DF_facxxx_insert_By]	DEFAULT (user_name()) FOR [insert_By] , 
	CONSTRAINT [DF_facxxx_insert_Dt]	DEFAULT (getdate()) FOR [insert_Dt] , 
	CONSTRAINT [DF_facxxx_update_Dt]	DEFAULT ('1/1/1900') FOR [update_Dt] , 
	CONSTRAINT [DF_facxxx_delete_Fl]	DEFAULT (0) FOR [delete_Fl] ,
	CONSTRAINT [DF_facxxx_delete_Dt]	DEFAULT ('1/1/1900') FOR [delete_Dt]  
GO

GRANT  REFERENCES, SELECT, UPDATE, INSERT, DELETE ON [dbo].[facxxx]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_upd_facxxx] ON dbo.facxxx 
FOR UPDATE 
AS

DECLARE	@recId	INT

SELECT	@recId = xxx_recId 
FROM	inserted

UPDATE	facxxx 
SET	update_By = USER_NAME(),
	update_Dt = GETDATE()
WHERE	xxx_recId = @recId
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
	@level1name = 'facxxx'
GO
*/
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'facxxx description', 
	@level0type=N'SCHEMA',
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Identity for facxxx records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'xxx_recId'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Primary key for facxxx records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'fac_Key'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record is active or not.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'active_Fl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record became active.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'active_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record went inactive.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'inactive_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was inserted.  Populated using "DF_facxxx_insert_By."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insert_By'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was inserted.  Populated using "DF_facxxx_insert_Dt."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insert_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was last updated.  Populated by the trigger "trig_upd_facxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'update_By'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was last updated.  Populated by the trigger "trig_upd_facxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'update_Dt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record can be deleted.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'delete_Fl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for delete_Fl indicating when the record was marked for deletion.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'delete_Dt'
GO

/*
---------------------------------------
------- facxxx                  ------- 
---------------------------------------

PRINT	'*** facxxx ***'
PRINT	'* Insert test *' 

INSERT 
INTO	fac_yyy (CatCd, CodeNm) 
VALUES	(-100, 'Unit test case 1')

INSERT 
INTO	facxxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 1')

--- Default Review ---

PRINT	'* Default Review *' 

SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	facxxx 
WHERE	CatCd < 0

----- PRIMARY KEY constraint -----

PRINT	'* PRIMARY KEY constraint *' 

INSERT 
INTO	facxxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 2')

----- FOREIGN KEY constraint -----

PRINT	'* FOREIGN KEY constraint *' 

INSERT 
INTO	facxxx (catCd, itmCd, itmTxt) 
VALUES	(-200, -100, 'Unit test case 4')

--- Trigger Review ---

PRINT	'* Trigger Review *' 

UPDATE	facxxx 
SET		itmTxt = 'Unit test case 3' 
WHERE	catCd = -100 
	AND	itmCd = -100 

SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	facxxx 
WHERE	CatCd < 0 

----- NOT NULL constraint -----

PRINT	'* NOT NULL constraint *' 

INSERT 
INTO	facxxx (catCd) 
VALUES	(NULL)

INSERT 
INTO	facxxx (itmCd) 
VALUES	(NULL)

-----Cleanup -----

PRINT	'* Cleanup *' 

DELETE	facxxx WHERE CatCd < 0
DELETE	facxxx_yyy WHERE CatCd < 0

*/
