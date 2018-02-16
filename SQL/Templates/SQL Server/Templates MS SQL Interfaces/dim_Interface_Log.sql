if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_dim_Interface_log]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_dim_Interface_log]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dim_Interface_Log]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[dim_Interface_Log]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*         Table Name: dim_Interface_Log                                                              */
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

CREATE TABLE [dbo].[dim_Interface_Log] 
(
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL ,
	[interface_key] [int] NOT NULL ,
	[interface_start_dt] [datetime] NULL ,
	[interface_end_dt] [datetime] NULL ,
	[interface_status_cd] [int] NULL ,
	[sql_error_code] [int] NULL ,
	[rec_read_int] [int] NULL ,
	[rec_valid_int] [int] NULL ,
	[rec_load_int] [char] (10) NULL ,
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

ALTER TABLE [dbo].[dim_Interface_Log] WITH NOCHECK ADD 
	CONSTRAINT [DF_dim_Interface_Log_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_dim_Interface_Log_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dim_Interface_Log]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trig_update_dim_Interface_log] ON dbo.dim_Interface_Log 
FOR UPDATE 
AS

DECLARE	@RecId	INT

SELECT	@RecId = Rec_Id 
FROM	inserted

UPDATE	dim_Interface_Log 
SET	update_by = USER_NAME(),
	update_dt = GETDATE()
WHERE	Rec_Id = @RecId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

