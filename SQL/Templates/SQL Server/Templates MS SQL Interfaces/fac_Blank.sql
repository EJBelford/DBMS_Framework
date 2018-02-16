USE Data_Architect 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trig_update_fac_xxx]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trig_update_fac_xxx]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fac_xxx]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[fac_xxx]
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*         Table Name: fac_xxx                                                                        */
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

CREATE TABLE [dbo].[fac_xxx] (
	[timestamp] [timestamp] NULL ,
	[rec_id] [int] IDENTITY (1000000, 1) NOT NULL ,
	[fac_key] [int] NOT NULL ,
	[fac_desc] [varchar] (20) NULL ,
	
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

ALTER TABLE [dbo].[fac_xxx] WITH NOCHECK ADD 
	CONSTRAINT [DF_fac_xxx_insert_by] DEFAULT (user_name()) FOR [insert_by],
	CONSTRAINT [DF_fac_xxx_insert_dt] DEFAULT (getdate()) FOR [insert_dt]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[fac_xxx]  TO [public]
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

