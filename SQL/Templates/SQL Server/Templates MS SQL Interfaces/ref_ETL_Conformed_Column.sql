USE Data_Architect 
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_ref_ETL_Conformed_Column]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_ref_ETL_Conformed_Column]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ref_ETL_Conformed_Column]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ref_ETL_Conformed_Column]
GO

CREATE TABLE [dbo].[ref_ETL_Conformed_Column] (
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL ,
	[ref_ETL_Source_key] [int] NOT NULL ,
	[ref_ETL_Column_key] [int] NOT NULL ,
	[ref_Conformed_Column_desc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[Conformed_Value] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[active_fl] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[active_dt] [datetime] NULL ,
	[inactive_dt] [datetime] NULL ,
	[insert_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[insert_dt] [datetime] NOT NULL ,
	[update_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[update_dt] [datetime] NULL ,
	[delete_fl] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[delete_dt] [datetime] NULL 
) ON [Application]
GO

ALTER TABLE [dbo].[ref_ETL_Conformed_Column] WITH NOCHECK ADD 
	CONSTRAINT [DF_ref_ETL_Conformed_Column_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_ref_ETL_Conformed_Column_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ref_ETL_Conformed_Column]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_ref_ETL_Conformed_Column] ON dbo.ref_ETL_Conformed_Column 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	ref_ETL_Conformed_Column 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

