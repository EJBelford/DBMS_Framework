USE Data_Architect
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_dim_ETL_Table]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_dim_ETL_Table]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dim_ETL_Table]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[dim_ETL_Table]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

CREATE TABLE [dbo].[dim_ETL_Table] 
(
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL ,
	[dim_ETL_Table_key] [int] NOT NULL ,
	[dim_ETL_Table_desc] [varchar] (20) NOT NULL ,
	
	[insert_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[insert_dt] [datetime] NOT NULL ,
	[update_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[update_dt] [datetime] NULL ,
	[delete_fl] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[delete_dt] [datetime] NULL 
) ON [Application]
GO

ALTER TABLE [dbo].[dim_ETL_Table] WITH NOCHECK ADD 
	CONSTRAINT [DF_dim_ETL_Table_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_dim_ETL_Table_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dim_ETL_Table]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_dim_ETL_Table] ON dbo.dim_ETL_Table 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	dim_ETL_Table 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

