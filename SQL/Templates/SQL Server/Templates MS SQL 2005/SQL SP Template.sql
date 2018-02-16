if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[xxx_sp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[xxx_sp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*            SP Name: xxx_sp                                                                         */
/*            SP Desc: Brief meaningful description                                                   */
/*                                                                                                    */
/*      SP Created By: Your name                                                                      */
/*    SP Created Date: DD MMM YYYY                                                                    */
/*                                                                                                    */
/*          SP Source:                                                                                */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*      SP Parameters:                                                                                */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*     Change History:                                                                                */
/* DDMMMYY - Who - Ticket # - CR # - Details                                                          */
/* DDMMMYY - GB  - 00000000 - 0000 - Created                                                          */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

-- EXEC xxx_sp NULL 

CREATE PROCEDURE xxx_sp 
	@RecId		INT	OUTPUT

AS 

DECLARE	@ProcessKey		INT,
	@ProcessStartDt		DATETIME,
	@ProcessEndDt		DATETIME,
	@ProcessStatusCd	INT,
	@SqlErrorCode		INT,
	@RecReadInt		INT,
	@RecValidInt		INT,
	@RecLoadInt		INT,
	@RecInsertedInt		INT,
	@RecSelectedInt		INT,
	@RecUpdatedInt		INT,
	@RecDeletedInt		INT,
	@UserLoginId		VARCHAR(30),
	@Message		VARCHAR(255), 

	@Sub01ProcessKey	INT,
	@Sub01ProcessStartDt	DATETIME,
	@Sub01ProcessEndDt	DATETIME,
	@Sub01ProcessStatusCd	INT,
	@Sub01SqlErrorCode	INT,
	@Sub01RecReadInt	INT,
	@Sub01RecValidInt	INT,
	@Sub01RecLoadInt	INT,
	@Sub01RecInsertedInt	INT,
	@Sub01RecSelectedInt	INT,
	@Sub01RecUpdatedInt	INT,
	@Sub01RecDeletedInt	INT,
	@Sub01UserLoginId	VARCHAR(30),
	@Sub01Message		VARCHAR(255), 

/*----- Controls -----*/ 

	@Debug			INT,
	@ProcessRecId		INT 

SELECT	@Debug = 0, 
	@ProcessRecId = NULL 

SELECT	@ProcessKey = 100, 
	@ProcessStartDt = GETDATE() 

EXEC	Process_Log_Entry_sp 
		@ProcessRecId OUTPUT, @ProcessKey, @ProcessStartDt --, @ProcessEndDt, @ProcessStatusCd, @SqlErrorCode,
--		@RecReadInt, @RecValidInt, @RecLoadInt, 
--		@RecInsertedInt, @RecSelectedInt, @RecUpdatedInt, @RecDeletedInt,
--		@UserLoginId, @Message 

IF @Debug > 0	SELECT	@RecId

IF @ProcessRecId IS NULL
BEGIN 
	IF @Debug > 0 SELECT 'Insert' 

END
ELSE
BEGIN 
	IF @Debug > 0 SELECT 'Update' 

END

SELECT	@RecId

-- Save the @@ERROR and @@ROWCOUNT values in local 
-- variables before they are cleared. 

SELECT	@SqlErrorCode = @@ERROR, @ProcessStatusCd = @@ROWCOUNT, @RecSelectedInt = @@ROWCOUNT 

IF @Debug > 0 
BEGIN 
	WAITFOR DELAY '00:00:01'
END 

SELECT	@ProcessEndDt = GETDATE() 

IF @Debug > 0 SELECT @ProcessRecId, @ProcessEndDt, @ProcessStatusCd, @SqlErrorCode

EXEC	Process_Log_Entry_sp 
		@ProcessRecId, @ProcessKey, @ProcessStartDt, @ProcessEndDt, @ProcessStatusCd, @SqlErrorCode,
		@RecReadInt, @RecValidInt, @RecLoadInt, 
		@RecInsertedInt, @RecSelectedInt, @RecUpdatedInt, @RecDeletedInt,
		@UserLoginId, @Message 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[xxx_sp]  TO [public]
GO

