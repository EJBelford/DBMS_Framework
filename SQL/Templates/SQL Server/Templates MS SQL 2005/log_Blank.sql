USE appl 
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'dbo.logxxx') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE dbo.logxxx
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO

--<summary> Short Description </summary>

--<remarks><code>
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- 
--         Table Name: logxxx
--         Table Desc: 
-- 
--   Table Created By: Gene Belford
-- Table Created Date: 
-- 
--       Table Source: *.sql
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History: 
-- DDMMMYY - Who - Ticket # - CR # - Details 
-- ddmmmyy - GB  - 00000000 - 0000 - Created 
-- 
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--</code></remarks>

CREATE TABLE dbo.logxxx 
(
	timestamp			TIMESTAMP			NULL ,
	logRecId			INT					IDENTITY (1000000, 1)	NOT NULL ,

/*- Trace   -*/

	logDateTime			DATETIME			NOT NULL ,
	logMessage			VARCHAR(255)		NULL ,
	logCategory			VARCHAR(255)		NULL ,
	logPriority			INT					NULL ,
	logEventId			INT					NULL ,
	logSeverity			VARCHAR(255)		NULL ,
	logTitle			VARCHAR(255)		NULL ,
	logMachine			VARCHAR(50)			NULL ,
	logApplDomain		VARCHAR(255)		NULL ,
	logProcessId		INT					NULL ,
	logProcessNm		VARCHAR(255)		NULL , 
	logWin32ThreadId	INT					NULL ,
	logThreadNm			VARCHAR(255)		NULL , 
	logExtendProp		VARCHAR(4000)		NULL 

/*- Event   -*/

/*- Process -*/

/*- Audit   -*/

) ON appl_Data_d1
GO

ALTER TABLE dbo.logxxx ADD CONSTRAINT
	PK_logxxx PRIMARY KEY CLUSTERED 
	(
	logRecId 
	) ON appl_Data_d1

GO

ALTER TABLE dbo.logxxx WITH NOCHECK ADD 
	CONSTRAINT DF_logxxx_logDateTime	DEFAULT (getdate()) FOR logDateTime  
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON dbo.logxxx  TO public
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
EXEC sp_dropextendedproperty 
	@name = 'appl_Description',  
	@level0type = 'SCHEMA',
	@level0name = 'dbo', 
	@level1type = 'TABLE', 
	@level1name = 'logxxx'
GO
*/
EXEC sys.sp_addextendedproperty 
	@name=N'appl_Description', 
	@value=N'logxxx description', 
	@level0type=N'SCHEMA',
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'logxxx'
GO

/*- Trace   -*/

EXEC sys.sp_addextendedproperty 
	@name=N'appl_Description', 
	@value=N'Identity for logxxx records.' , 
	@level0type=N'SCHEMA', 
	@level0name=N'dbo', 
	@level1type=N'TABLE', 
	@level1name=N'logxxx', 
	@level2type=N'COLUMN', 
	@level2name=N'logRecId'
GO

/*- Event   -*/

/*- Process -*/

/*- Audit   -*/

/*
---------------------------------------
------- logxxx           ------- 
---------------------------------------

PRINT	'*** logxxx ***'
PRINT	'* Insert test *' 

INSERT 
INTO	log_yyy (CatCd, CodeNm) 
VALUES	(-100, 'Unit test case 1')

INSERT 
INTO	logxxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 1')

--- Default Review ---

PRINT	'* Default Review *' 

SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	logxxx 
WHERE	CatCd < 0

----- PRIMARY KEY constraint -----

PRINT	'* PRIMARY KEY constraint *' 

INSERT 
INTO	logxxx (catCd, itmCd, itmTxt) 
VALUES	(-100, -100, 'Unit test case 2')

----- FOREIGN KEY constraint -----

PRINT	'* FOREIGN KEY constraint *' 

INSERT 
INTO	logxxx (catCd, itmCd, itmTxt) 
VALUES	(-200, -100, 'Unit test case 4')

--- Trigger Review ---

PRINT	'* Trigger Review *' 

UPDATE	logxxx 
SET		itmTxt = 'Unit test case 3' 
WHERE	catCd = -100 
	AND	itmCd = -100 

SELECT	itmTxt, active_Fl, active_Dt, inactive_Dt, insert_By, insert_Dt, 
		update_By, update_Dt, delete_Fl, delete_Dt 
FROM	logxxx 
WHERE	CatCd < 0 

----- NOT NULL constraint -----

PRINT	'* NOT NULL constraint *' 

INSERT 
INTO	logxxx (catCd) 
VALUES	(NULL)

INSERT 
INTO	logxxx (itmCd) 
VALUES	(NULL)

-----Cleanup -----

PRINT	'* Cleanup *' 

DELETE	logxxx WHERE CatCd < 0
DELETE	logxxx_yyy WHERE CatCd < 0

*/
