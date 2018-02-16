USE Data_Architect 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_fac_ETL_Staging_Table_Record_Count]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_fac_ETL_Staging_Table_Record_Count]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fac_ETL_Staging_Table_Record_Count]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[fac_ETL_Staging_Table_Record_Count]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*         Table Name: fac_ETL_Staging_Table_Record_Count                                                                        */
/*         Table Desc:                                                                                */
/*                                                                                                    */
/*   Table Created By:                                                                                */
/* Table Created Date:                                                                                */
/*                                                                                                    */
/*       Table Source:                                                                                */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*     Change History:                                                                                */
/* DDMMMYY - Who - Ticket # - CR # - Details                                                          */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

CREATE TABLE [dbo].[fac_ETL_Staging_Table_Record_Count] (
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL ,
	[fac_ETL_Date_key] [int] NOT NULL ,
	[fac_Source_key] [int] NOT NULL ,
	[fac_Table_key] [int] NOT NULL ,
	[fac_Batch_key] [int] NOT NULL ,
	[fac_ETL_ErrEve_desc] [varchar] (20) NULL ,
	
	[Number_of_Records] [int] NOT NULL ,
	[Sigma_Test] [int] NOT NULL ,
	[Sum_Test] [int] NOT NULL ,
	[Sum_Test_Squared] [int] NOT NULL ,
	
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

ALTER TABLE [dbo].[fac_ETL_Staging_Table_Record_Count] WITH NOCHECK ADD 
	CONSTRAINT [DF_fac_ETL_Staging_Table_Record_Count_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_fac_ETL_Staging_Table_Record_Count_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[fac_ETL_Staging_Table_Record_Count]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_fac_ETL_Staging_Table_Record_Count] ON dbo.fac_ETL_Staging_Table_Record_Count 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	fac_ETL_Staging_Table_Record_Count 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

