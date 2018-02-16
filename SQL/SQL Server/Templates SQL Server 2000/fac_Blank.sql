IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[trig_update_fac_xxx]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER [dbo].[trig_update_fac_xxx]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[fac_xxx]') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[fac_xxx]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
--
--         Table Name: fac_xxx 
--         Table Desc: 
-- 
--   Table Created By: 
-- Table Created Date: 
-- 
--       Table Source: 
-- 
------*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 
------*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

CREATE TABLE [dbo].[fac_xxx] (
	[timestamp]			[timestamp]		NULL ,
	[rec_id]			[int]			IDENTITY (1000000, 1) NOT NULL ,
	[fac_key]			[int]			NOT NULL ,
	[fac_desc]			[varchar](20)	NULL ,
	
	[active_fl]			[char](1)		NULL ,
	[active_dt]			[datetime]		NULL ,
	[inactive_dt]		[datetime]		NULL ,
	[insert_by]			[varchar](20)	NOT NULL ,
	[insert_dt]			[datetime]		NOT NULL ,
	[update_by]			[varchar](20)	NULL ,
	[update_dt]			[datetime]		NULL ,
	[delete_fl]			[char](1)		NULL ,
	[delete_dt]			[datetime]		NULL 
) ON [CMIS-R_Data_d1]
GO

ALTER TABLE dbo.fac_xxx ADD CONSTRAINT
	PK_dim_fac_xxx PRIMARY KEY CLUSTERED 
	(
	[rec_id] 
	) ON [CMIS-R_Data_d1]
GO
/*
ALTER TABLE [dbo].[fac_xxx]  WITH CHECK ADD  CONSTRAINT [FK_dim_xxx_dim_yyy] FOREIGN KEY([rec_id])
REFERENCES [dbo].[fac_yyy] ([rec_id])
GO
*/
ALTER TABLE [dbo].[fac_xxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_fac_xxx_insert_by] DEFAULT (USER_NAME()) FOR [insert_by],
	CONSTRAINT [DF_fac_xxx_insert_dt] DEFAULT (GETDATE()) FOR [insert_dt]
GO

GRANT  REFERENCES, SELECT, UPDATE, INSERT, DELETE ON [dbo].[fac_xxx]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_fac_xxx] ON dbo.fac_xxx 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	fac_xxx 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

