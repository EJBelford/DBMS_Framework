USE [CMIS]
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[spr_xxx]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spr_xxx]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--<summary> Short Description </summary>

--<remarks><code>
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- 
--            SP Name: spr_xxx 
--            SP Desc: Brief meaningful description 
-- 
--      SP Created By: Gene Belford  
--    SP Created Date: DD MMM YYYY  
-- 
--          SP Source: 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--      SP Parameters: 
--              Input:
-- 
--             Output:
--
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- Used in the following:
--
--         
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- DDMMMYY - GB  - 00000000 - 0000 - Created 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--</code></remarks>

-- EXEC spr_xxx NULL 

CREATE PROCEDURE spr_xxx 
	@recId					INT		OUTPUT

AS 

DECLARE	@processKey			INT,
	@processStartDt			DATETIME,
	@processEndDt			DATETIME,
	@processStatusCd		INT,
	@sqlErrorCode			INT,
	@recReadInt				INT,
	@recValidInt			INT,
	@recLoadInt				INT,
	@recInsertedInt			INT,
	@recSelectedInt			INT,
	@recUpdatedInt			INT,
	@recDeletedInt			INT,
	@userLoginId			VARCHAR(30),
	@message				VARCHAR(255), 

	@sub01ProcessKey		INT,
	@sub01ProcessStartDt	DATETIME,
	@sub01ProcessEndDt		DATETIME,
	@sub01ProcessStatusCd	INT,
	@sub01SqlErrorCode		INT,
	@sub01RecReadInt		INT,
	@sub01RecValidInt		INT,
	@sub01RecLoadInt		INT,
	@sub01RecInsertedInt	INT,
	@sub01RecSelectedInt	INT,
	@sub01RecUpdatedInt		INT,
	@sub01RecDeletedInt		INT,
	@sub01UserLoginId		VARCHAR(30),
	@sub01Message			VARCHAR(255), 

/*----- Controls -----*/ 

	@debug				INT,
	@processRecId		INT, 
	@serverName			VARCHAR(50) 

SELECT	@debug		= 0, 
	@processRecId	= NULL 
 
SELECT	@processKey = 0, 
	@processStartDt = GETDATE(), 
	@serverName		= @@ServerName 
 
IF @debug > 0	SELECT	@processKey, @processStartDt, @serverName 

-- Make initial process log entry for stored procedure call

IF @serverName <> 'cmisProd' 
	EXEC	spr_InsUpd_RptToCourt_ProcessLog 
			@processRecId OUTPUT, 0, @processKey, @processStartDt 
--			, @processEndDt, @processStatusCd, @sqlErrorCode,
--			@recReadInt, @recValidInt, @recLoadInt, 
--			@recInsertedInt, @recSelectedInt, @recUpdatedInt, @recDeletedInt,
--			@userLoginId, @message 

IF @debug > 0	SELECT	@RecId

IF @RecId IS NULL
BEGIN 
	IF @debug > 0 SELECT 'Insert' 

	BEGIN TRANSACTION 

	BEGIN TRY 
-- Generate divide-by-zero error.
		SELECT 1/0 
	END TRY 

	BEGIN CATCH 
-- Execute error retrieval routine.
		EXECUTE spr_GetErrorInfo NULL 

			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION 
	END CATCH 

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION
END
ELSE
BEGIN 
	IF @debug > 0 SELECT 'Update' 

END

-- Save the @@ERROR and @@ROWCOUNT values in local 
-- variables before they are cleared. 

SELECT	@sqlErrorCode = @@ERROR, @processStatusCd = @@ROWCOUNT, @recSelectedInt = @@ROWCOUNT 

IF @debug > 0 
BEGIN 
	WAITFOR DELAY '00:00:01'
END 

SELECT	@processEndDt = GETDATE() 

IF @debug > 0 SELECT @processRecId, @processEndDt, @processStatusCd, @sqlErrorCode

-- Make final update to process log entry for stored procedure call

IF @serverName <> 'cmisProd' 
	EXEC	spr_InsUpd_RptToCourt_ProcessLog 
			@processRecId, 0, @processKey, @processStartDt, 
			@processEndDt, @processStatusCd, @sqlErrorCode,
			@recReadInt, @recValidInt, @recLoadInt, 
			@recInsertedInt, @recSelectedInt, @recUpdatedInt, @recDeletedInt,
			@userLoginId, @message 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[spr_xxx]  TO [public]
GO

