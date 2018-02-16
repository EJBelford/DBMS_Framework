USE [CMISLog]
GO 

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[spr_RptToCourt_InsUpd_ProcessLog]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spr_RptToCourt_InsUpd_ProcessLog]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--<summary> Captures SQL processing information for debugging and monitoring </summary>

--<remarks><code>
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
--
--            SP Name: spr_RptToCourt_InsUpd_ProcessLog
--            SP Desc: Captures SQL processing information for debugging and monitoring
--
--      SP Created By: Gene Belford
--    SP Created Date: 25 May 2007 
--
--          SP Source: spr_RptToCourt_InsUpd_ProcessLog.sql
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--      SP Parameters: 
--              Input: For INSERT:
--                         @rec_Id - NULL will create a new record 
--               @rptToCourt_RecId -  
--                     @processKey - Code value for which process is logging activity 
-- 
--             Output:     @rec_Id - The IDENTITY of the log record
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- Used in the following:
--
--         
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 25May07 - GB  -          -      - Created 
-- 02Jul07 - GB  -          -      - Added RptToCourt_RecId to parameters 
-- 10Jul07 - GB  -          -      - Broad update to meet JIS best practices standards 
-- 16Jul07 - GB  -          -      - Updated table names 
-- 26Jul07 - GB  -          -      - Change @@Identity to SCOPE_IDENTITY() 
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
--</code></remarks>

-- EXEC spr_RptToCourt_InsUpd_ProcessLog NULL, 100002, 100003 
-- EXEC spr_RptToCourt_InsUpd_ProcessLog 100003, 100002, 100003 

CREATE PROCEDURE spr_RptToCourt_InsUpd_ProcessLog 
	@rec_Id				INT		OUTPUT, 
	@rptToCourt_RecId	INT, 
	@processKey			INT,
	@processStartDt		DATETIME	= NULL,
	@processEndDt		DATETIME	= NULL,
	@processStatusCd	INT		= NULL,
	@sqlErrorCode		INT		= NULL,
	@recReadInt			INT		= NULL,
	@recValidInt		INT		= NULL,
	@recLoadInt			INT		= NULL,
	@recInsertedInt		INT		= NULL,
	@recSelectedInt		INT		= NULL,
	@recUpdatedInt		INT		= NULL,
	@recDeletedInt		INT		= NULL,
	@userLoginId		VARCHAR(30)		= NULL,
	@message			VARCHAR(255)	= NULL

AS 

DECLARE	@debug		INT 

SET	@debug = 0

IF @debug > 0 
	BEGIN 
		SELECT	@rec_Id, @rptToCourt_RecId, @processKey
	END  

-- If the @rec_Id is NULL then we assume that a new log record is required

IF @rec_Id IS NULL
BEGIN 
	IF @debug > 0 SELECT 'Insert' 

	INSERT 
	INTO	facRptToCourtProcessLog				-- 16Jul07 - GB 
		(
		process_Key,
		process_Start_Dt, 
		rptToCourt_RecId 		
		)
	SELECT	@ProcessKey, 
		@processStartDt, 
		@rptToCourt_RecId  

-- Get the IDENTITY of the new record to pass back out for updates to the log entry

	SELECT	@rec_id = SCOPE_IDENTITY()	-- 26Jul07 - GB - Change @@Identity to SCOPE_IDENTITY()

--	SELECT	@rec_id = MAX(processLog_RecId) 
--	FROM	facRptToCourtProcessLog				-- 16Jul07 - GB

END
ELSE
BEGIN 
	IF @debug > 0 SELECT 'Update' 

	UPDATE	facRptToCourtProcessLog				-- 16Jul07 - GB
	SET	process_End_Dt = @processEndDt,
		process_Status_Cd = @processStatusCd,
		sql_Error_Code = @sqlErrorCode,
		rec_Read_Int = @recReadInt,
		rec_Valid_Int = @recValidInt,
		rec_Load_Int = @recLoadInt,
		rec_Inserted_Int = @recInsertedInt,
		rec_Selected_Int = @recSelectedInt,
		rec_Updated_Int = @recUpdatedInt,
		rec_Deleted_Int = @recDeletedInt,
		message = @message 
	WHERE	processLog_RecId = @rec_Id
END 

IF @debug > 0 
BEGIN 
	SELECT	* 
	FROM	facRptToCourtProcessLog				-- 16Jul07 - GB
	ORDER BY processLog_RecId DESC 
END 

SELECT	@rec_Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[spr_RptToCourt_InsUpd_ProcessLog]  TO [public]
GO
