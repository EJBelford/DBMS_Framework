USE Data_Architect 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Process_Log_Entry_sp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Process_Log_Entry_sp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*                                                                                                    */
/*            SP Name: Process_Log_Entry_sp                                                              */
/*            SP Desc: Captures SQL processing information for debugging and monitoring               */
/*                                                                                                    */
/*      SP Created By: Gene Belford                                                                   */
/*    SP Created Date: 29 Nov 2006                                                                    */
/*                                                                                                    */
/*          SP Source:                                                                                */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*      SP Parameters:                                                                                */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/
/*     Change History:                                                                                */
/* DDMMMYY - Who - Ticket # - CR # - Details                                                          */
/* 29Nov06 - GB  - 00000000 - 0000 - Created                                                          */
/*                                                                                                    */
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*-----*/

-- EXEC Process_Log_Entry_sp NULL, NULL 

CREATE PROCEDURE Process_Log_Entry_sp 
	@rec_id			INT	OUTPUT, 
	@ProcessKey		INT,
	@ProcessStartDt		SMALLDATETIME	= NULL,
	@ProcessEndDt		SMALLDATETIME	= NULL,
	@ProcessStatusCd	INT		= NULL,
	@SqlErrorCode		INT		= NULL,
	@RecReadInt		INT		= NULL,
	@RecValidInt		INT		= NULL,
	@RecLoadInt		INT		= NULL,
	@RecInsertedInt		INT		= NULL,
	@RecSelectedInt		INT		= NULL,
	@RecUpdatedInt		INT		= NULL,
	@RecDeletedInt		INT		= NULL,
	@UserLoginId		VARCHAR(30)	= NULL,
	@Message		VARCHAR(255)	= NULL

AS 

DECLARE	@Debug		INT 

SET	@Debug = 0 

IF @rec_id IS NULL
BEGIN 
	IF @Debug > 0 SELECT 'Insert' 

	INSERT 
	INTO	fac_Process_Log 
		(
		process_key,
		process_start_dt
		)
	SELECT	1, 
		@ProcessStartDt 

	SELECT	@rec_id = MAX(rec_id) 
	FROM	fac_Process_Log

END
ELSE
BEGIN 
	IF @Debug > 0 SELECT 'Update' 

	UPDATE	fac_Process_Log 
	SET	process_end_dt = @ProcessEndDt,
		process_status_cd = @ProcessStatusCd,
		sql_error_code = @SqlErrorCode,
		rec_read_int = @RecReadInt,
		rec_valid_int = @RecValidInt,
		rec_load_int = @RecLoadInt,
		rec_inserted_int = @RecInsertedInt,
		rec_selected_int = @RecSelectedInt,
		rec_updated_int = @RecUpdatedInt,
		rec_deleted_int = @RecDeletedInt,
		message = @Message 
	WHERE	rec_id = @rec_id
END

SELECT	@rec_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
