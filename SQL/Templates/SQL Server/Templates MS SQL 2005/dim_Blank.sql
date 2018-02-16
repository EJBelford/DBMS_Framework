USE [Data_Dictionary]
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trig_update_dim_xxx]'))
	DROP TRIGGER [dbo].[trig_update_dim_xxx] 
GO

IF	EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_xxx]') 
	AND OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[dim_xxx]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
-- 
--         Table Name: 
--         Table Desc: 
-- 
--   Table Created By: 
-- Table Created Date: 
-- 
--       Table Source: 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

CREATE TABLE [dbo].[dim_xxx] 
(
	[timestamp]		[timestamp]		NULL ,
	[rec_id]		[int]			IDENTITY (1000000, 1)	NOT NULL ,
	[dim_key]		[int]			NOT NULL ,
	[dim_desc]		[varchar](20)	NOT NULL ,
	
	[active_fl]		[char](1)		NULL ,
	[active_dt]		[datetime]		NULL ,
	[inactive_dt]	[datetime]		NULL ,

	[insert_by]		[varchar](20)	NOT NULL ,
	[insert_dt]		[datetime]		NOT NULL ,
	[update_by]		[varchar](20)	NULL ,
	[update_dt]		[datetime]		NULL ,
	[delete_fl]		[char](1)		NULL ,
	[delete_dt]		[datetime]		NULL 
) ON [Data_Dictionary_Data]
GO

ALTER TABLE dbo.dim_xxx ADD CONSTRAINT
	PK_dim_xxx PRIMARY KEY CLUSTERED 
	(
	[dim_key] 
	) ON [Data_Dictionary_Data]

GO
/*
ALTER TABLE [dbo].[dim_xxx]  WITH CHECK ADD  CONSTRAINT [FK_dim_xxx_dim_yyy] FOREIGN KEY([dim_key])
REFERENCES [dbo].[dim_xxx_yyy] ([dim_key])
GO
*/
ALTER TABLE [dbo].[dim_xxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_dim_xxx_active_fl] DEFAULT (0) FOR [active_fl] ,
	CONSTRAINT [DF_dim_xxx_insert_by] DEFAULT (user_name()) FOR [insert_by] , 
	CONSTRAINT [DF_dim_xxx_insert_dt] DEFAULT (getdate()) FOR [insert_dt] , 
	CONSTRAINT [DF_dim_xxx_delete_fl] DEFAULT (0) FOR [delete_fl] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dim_xxx]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_dim_xxx] ON dbo.dim_xxx 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	dim_xxx 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

