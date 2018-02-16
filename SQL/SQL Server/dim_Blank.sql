USE [Data_Dictionary] 
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[trig_update_dimxxx]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[trig_upd_dimxxx]
GO

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

CREATE TABLE [dbo].[dimxxx] 
(
	[timestamp]			[TIMESTAMP]			NULL ,
	[xxx_recId]			[INT]				IDENTITY (1000000, 1)	NOT NULL ,
	[dimKey]			[INT]				NOT NULL ,
	[dimDesc]			[VARCHAR](20)		NOT NULL ,
	
	[activeFl]			[BIT]				NULL ,
	[activeDt]			[SMALLDATETIME]		NOT NULL ,
	[inactiveDt]		[SMALLDATETIME]		NOT NULL ,

	[insertBy]			[VARCHAR](20)		NOT NULL ,
	[insertDt]			[SMALLDATETIME]		NOT NULL ,
	[updateBy]			[VARCHAR](20)		NULL ,
	[updateDt]			[SMALLDATETIME]		NOT NULL ,
	[deleteFl]			[BIT]				NULL ,
	[deleteDt]			[SMALLDATETIME]		NULL  ,
	[hiddenFl]			[BIT]				NULL ,
	[hiddenDt]			[SMALLDATETIME]		NULL 
) ON [Data_Dictionary_Data]
GO

ALTER TABLE dbo.dimxxx ADD CONSTRAINT
	PK_dimxxx PRIMARY KEY CLUSTERED 
	(
	[xxx_recId] 
	) ON [Data_Dictionary_Data]

GO
/*
ALTER TABLE [dbo].[dimxxx]  WITH CHECK ADD  CONSTRAINT [FK_dimxxx_dim_yyy] FOREIGN KEY([dimKey])
REFERENCES [dbo].[dim_xxx_yyy] ([dimKey])
--GO
*/
ALTER TABLE [dbo].[dimxxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_dimxxx_activeFl]	DEFAULT (0) FOR [activeFl] ,
	CONSTRAINT [DF_dimxxx_activeDt]	DEFAULT ('1/1/1900')	FOR [activeDt] , 
	CONSTRAINT [DF_dimxxx_inactiveDt]	DEFAULT ('1/1/1900')	FOR [inactiveDt] , 
	CONSTRAINT [DF_dimxxx_insertBy]	DEFAULT (user_name())	FOR [insertBy] , 
	CONSTRAINT [DF_dimxxx_insertDt]	DEFAULT (getdate())		FOR [insertDt] , 
	CONSTRAINT [DF_dimxxx_updateDt]	DEFAULT ('1/1/1900')	FOR [updateDt] , 
	CONSTRAINT [DF_dimxxx_deleteFl]	DEFAULT (0)				FOR [deleteFl] ,
	CONSTRAINT [DF_dimxxx_deleteDt]	DEFAULT ('1/1/1900')	FOR [deleteDt] , 
	CONSTRAINT [DF_dimxxx_hiddenFl]	DEFAULT (0)				FOR [hiddenFl] ,
	CONSTRAINT [DF_dimxxx_hiddenDt]	DEFAULT ('1/1/1900')	FOR [hiddenDt] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dimxxx]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_dim_xxx] ON dbo.dimxxx 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = xxx_recId 
FROM	inserted

UPDATE	dim_xxx 
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
	@level2name=N'xxx_RecId'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Primary key for dimxxx records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'dimKey'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record is active or not.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'activeFl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record became active.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'activeDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for active_Fl indicating when the record went inactive.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'inactiveDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was inserted.  Populated using "DF_dimxxx_insert_By."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insertBy'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was inserted.  Populated using "DF_dimxxx_insert_Dt."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'insertDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the USERNAME() captured when the record was last updated.  Populated by the trigger "trig_upd_dimxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'updateBy'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Contains the GETDATE() captured when the record was last updated.  Populated by the trigger "trig_upd_dimxxx."' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'updateDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record can be deleted.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'deleteFl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for delete_Fl indicating when the record was marked for deletion.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'deleteDt'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Flag indicating if the record can be hidden.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'hiddenFl'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 
	@value=N'Addition control for hidden_Fl indicating when the record was marked as hidden.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'dimxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'hiddenDt'
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

SELECT	itmTxt, activeFl, activeDt, inactiveDt, insertBy, insertDt, 
		updateBy, updateDt, deleteFl, deleteDt, hiddenFl, hiddenDt 
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

SELECT	itmTxt, activeFl, activeDt, inactiveDt, insertBy, insertDt, 
		updateBy, updateDt, deleteFl, deleteDt, hiddenFl, hiddenDt 
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
