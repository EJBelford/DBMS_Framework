USE [Data_Dictionary] 
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[trig_update_facxxx]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[trig_update_facxxx]
GO

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

CREATE TABLE [dbo].[facxxx] 
(
	[timestamp]			[TIMESTAMP]			NULL ,
	[xxx_recId]			[INT]				IDENTITY (1000000, 1) NOT NULL ,
	[facKey]			[INT]				NOT NULL ,
	[facDesc]			[VARCHAR](20)		NULL ,
	
	[activeFl]			[BIT]				NULL ,
	[activeDt]			[SMALLDATETIME]		NOT NULL ,
	[inactiveDt]		[SMALLDATETIME]		NOT NULL ,

	[insertBy]			[VARCHAR](20)		NOT NULL ,
	[insertDt]			[SMALLDATETIME]		NOT NULL ,
	[updateBy]			[VARCHAR](20)		NULL ,
	[updateDt]			[SMALLDATETIME]		NOT NULL ,
	[deletefl]			[BIT]				NULL ,
	[deleteDt]			[SMALLDATETIME]		NOT NULL ,
	[hiddenFl]			[BIT]				NULL ,
	[hiddenDt]			[SMALLDATETIME]		NOT NULL 
) ON [Data_Dictionary_Data]
GO

ALTER TABLE dbo.facxxx ADD CONSTRAINT
	PK_dim_facxxx PRIMARY KEY CLUSTERED 
	(
	[xxx_recId] 
	) ON [Data_Dictionary_Data]
GO
/*
ALTER TABLE [dbo].[facxxx]  WITH CHECK ADD  CONSTRAINT [FK_dim_xxx_dim_yyy] FOREIGN KEY([xxx_recId])
REFERENCES [dbo].[fac_yyy] ([yyy_recId])
--GO
*/
ALTER TABLE [dbo].[facxxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_facxxx_activeFl]	DEFAULT (0) FOR [activeFl] ,
	CONSTRAINT [DF_facxxx_activeDt]	DEFAULT ('1/1/1900') FOR [activeDt] , 
	CONSTRAINT [DF_facxxx_inactiveDt]	DEFAULT ('1/1/1900') FOR [inactiveDt] , 
	CONSTRAINT [DF_facxxx_insertBy]	DEFAULT (user_name()) FOR [insertBy] , 
	CONSTRAINT [DF_facxxx_insertDt]	DEFAULT (getdate()) FOR [insertDt] , 
	CONSTRAINT [DF_facxxx_updateDt]	DEFAULT ('1/1/1900') FOR [updateDt] , 
	CONSTRAINT [DF_facxxx_deleteFl]	DEFAULT (0) FOR [deleteFl] ,
	CONSTRAINT [DF_facxxx_deleteDt]	DEFAULT ('1/1/1900') FOR [deleteDt] , 
	CONSTRAINT [DF_facxxx_hiddenFl]	DEFAULT (0) FOR [hiddenFl] ,
	CONSTRAINT [DF_facxxx_hiddendt]	DEFAULT ('1/1/1900') FOR [hiddenDt]  
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

DECLARE	@RecId	INT

SELECT	@RecId = xxx_recId 
FROM	inserted

UPDATE	facxxx 
SET	updateBy = USER_NAME(),
	updateDt = GETDATE()
WHERE	xxx_recId = @RecId


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
	@level2name=N'facKey'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record is active or not.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'activeFl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record became active.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'activeDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record went inactive.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'inactiveDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was inserted.  Populated using "DF_facxxx_insert_By."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insertBy'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was inserted.  Populated using "DF_facxxx_insert_Dt."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insertDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was last updated.  Populated by the trigger "trig_upd_facxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'updateBy'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was last updated.  Populated by the trigger "trig_upd_facxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'updateDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record can be deleted.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'deleteFl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for delete_Fl indicating when the record was marked for deletion.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'facxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'deleteDt'
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

SELECT	itmTxt, activeFl, activeDt, inactiveDt, insertBy, insertDt, 
		updateBy, updateDt, deleteFl, deleteDt, hiddenFl, hiddenDt 
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

SELECT	itmTxt, activeFl, activeDt, inactiveDt, insertBy, insertDt, 
		updateBy, updateDt, deleteFl, deleteDt, hiddenFl, hiddenDt 
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
