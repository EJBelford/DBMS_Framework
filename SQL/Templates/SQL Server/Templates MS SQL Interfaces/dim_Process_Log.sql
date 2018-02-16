if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_fac_Process_Log]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_fac_Process_Log]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fac_Process_Log]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[fac_Process_Log]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*         Table Name: fac_Process_Log                                                                */
/*         Table Desc:                                                                                */
/*                                                                                                    */
/*   Table Created By: Gene Belford                                                                   */
/* Table Created Date: 29 Nov 2006                                                                    */
/*                                                                                                    */
/*       Table Source: dim_Interface_Log                                                              */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*     Change History:                                                                                */
/* DDMMMYY - Who - Ticket # - CR # - Details                                                          */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

CREATE TABLE [dbo].[fac_Process_Log] 
(
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL , 

	[process_key] [int] NOT NULL ,
	[process_start_dt] [datetime] NULL ,
	[process_end_dt] [datetime] NULL ,
	[process_status_cd] [int] NULL ,
	[sql_error_code] [int] NULL ,
	[rec_read_int] [int] NULL ,
	[rec_valid_int] [int] NULL ,
	[rec_load_int] [int] NULL ,
	[rec_inserted_int] [int] NULL ,
	[rec_selected_int] [int] NULL ,
	[rec_updated_int] [int] NULL ,
	[rec_deleted_int] [int] NULL ,
	[user_login_id] [varchar] (30) NULL ,
	[message] [varchar] (255) NULL , 

	[active_fl] [char] (1) NULL ,
	[active_dt] [datetime] NULL ,
	[inactive_dt] [datetime] NULL ,
	[insert_by] [varchar] (20) NOT NULL ,
	[insert_dt] [datetime] NOT NULL ,
	[update_by] [varchar] (20) NULL ,
	[update_dt] [datetime] NULL ,
	[delete_fl] [char] (1) NULL ,
	[delete_dt] [datetime] NULL 
) ON [Application]
GO

ALTER TABLE [dbo].[fac_Process_Log] WITH NOCHECK ADD 
	CONSTRAINT [DF_fac_Process_Log_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_fac_Process_Log_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[fac_Process_Log]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_fac_Process_Log] ON dbo.fac_Process_Log 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	fac_Process_Log 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

