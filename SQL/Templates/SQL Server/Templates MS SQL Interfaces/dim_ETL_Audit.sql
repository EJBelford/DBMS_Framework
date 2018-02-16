USE Data_Architect
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_dim_ETL_Audit]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_dim_ETL_Audit]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dim_ETL_Audit]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[dim_ETL_Audit]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

CREATE TABLE [dbo].[dim_ETL_Audit] 
(
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL ,
	[dim_ETL_Audit_key] [int] NOT NULL ,
	[dim_ETL_Audit_desc] [varchar] (20) NOT NULL ,

	[Overall_Quality_Category] [varchar] (20) NOT NULL, 
	[Overall_Quality_Score] [int] NOT NULL, 
	[Completeness_Category] [varchar] (20) NOT NULL, 
	[Completeness_Score] [int] NOT NULL, 
	[Validation_Category] [varchar] (20) NOT NULL, 
	[Validation_Score] [int] NOT NULL, 
	[Out_of_Bounds_Category] [varchar] (20) NOT NULL, 
	[Out_of_Bounds_Score] [int] NOT NULL, 
	[Number_Screens_Failed] [int] NOT NULL, 
	[Max_Severity_Score] [int] NOT NULL, 
	[Extract_Timestamp]	[smalldatetime] NOT NULL, 
	[Clean_Timestamp]	[smalldatetime] NOT NULL, 
	[Confom_Timestamp]	[smalldatetime] NOT NULL, 
	[FTL_System_Version] [varchar] (20) NOT NULL, 
	[Allocation_Version] [varchar] (20) NOT NULL, 
	[Currency_Conversion_Version] [varchar] (20) NOT NULL, 
	[Other_Audit_Attributes] [varchar] (20) NOT NULL, 
	
	[insert_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[insert_dt] [datetime] NOT NULL ,
	[update_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[update_dt] [datetime] NULL ,
	[delete_fl] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[delete_dt] [datetime] NULL 
) ON [Application]
GO

ALTER TABLE [dbo].[dim_ETL_Audit] WITH NOCHECK ADD 
	CONSTRAINT [DF_dim_ETL_Audit_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_dim_ETL_Audit_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dim_ETL_Audit]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_dim_ETL_Audit] ON dbo.dim_ETL_Audit 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	dim_ETL_Audit 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

