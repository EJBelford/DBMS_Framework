USE Data_Architect
GO

DECLARE	@ServerNm		VARCHAR(20), 
	@DB_Name		VARCHAR(20), 

	@ProcessKey		INT,
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

	@Debug		INT,
	@RecId		INT 

/*----- Controls -----*/ 

SELECT	@Debug	= 1,
	@RecId	= NULL

/*
SELECT	dbid, LEFT(name, 20) AS db_name --, * 
FROM	master..sysdatabases 

SELECT	c.xtype, LEFT(c.name, 16) AS Type_Name	--, * 
FROM	master..systypes c
*/

SET	@ServerNm = @@ServerName 
SET	@DB_Name = 'Data_Architect' 

SELECT	@ProcessKey = 100, 
	@ProcessStartDt = GETDATE() 

EXEC	Process_Log_Entry_sp 
		@RecId OUTPUT, @ProcessKey, @ProcessStartDt --, @ProcessEndDt, @ProcessStatusCd, @SqlErrorCode,
--		@RecReadInt, @RecValidInt, @RecLoadInt, 
--		@RecInsertedInt, @RecSelectedInt, @RecUpdatedInt, @RecDeletedInt,
--		@UserLoginId, @Message 

IF @Debug > 0	SELECT	@RecId

SELECT	@ServerNm AS ServerName, 
	@DB_Name AS DB_Name, 
	LEFT(a.name, 20) AS obj_name, 
--	a.id, 
	LEFT(b.name, 20) AS col_name, 
--	b.xtype,
	LEFT(c.name, 16) AS Type_Name, 	 
	b.length , 
	CASE b.isnullable WHEN 0 THEN 'NOT NULL' ELSE 'NULL' END AS Null_Fl  
--	, b.*, 	a.* 
FROM	sysobjects a, 
	syscolumns b, 
	master..systypes c
WHERE	a.xtype = 'U' 
	AND a.id = b.id 
	AND b.xtype = c.xtype 
	AND a.name NOT IN ('dtproperties')
ORDER BY a.name, b.colid 

-- Save the @@ERROR and @@ROWCOUNT values in local 
-- variables before they are cleared. 

SELECT	@SqlErrorCode = @@ERROR, @ProcessStatusCd = @@ROWCOUNT, @RecSelectedInt = @@ROWCOUNT 

IF @Debug > 0 
BEGIN 
	WAITFOR DELAY '00:00:01'
END 

SELECT	@ProcessEndDt = GETDATE() 

IF @Debug > 0 SELECT @RecId, @ProcessEndDt, @ProcessStatusCd, @SqlErrorCode

EXEC	Process_Log_Entry_sp 
		@RecId, @ProcessKey, @ProcessStartDt, @ProcessEndDt, @ProcessStatusCd, @SqlErrorCode,
		@RecReadInt, @RecValidInt, @RecLoadInt, 
		@RecInsertedInt, @RecSelectedInt, @RecUpdatedInt, @RecDeletedInt,
		@UserLoginId, @Message 


