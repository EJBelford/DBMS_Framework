SELECT	TableDesc, 
	TableName, 
	TableNameA, 
	ColumnName, 
	ColumnNameA, 
	CodeCatCd, 
	TableCodes, 
	OrdinalPosition, 
	Pos, 
	Nullable, 
	DataType, 
	MaxLength, 
	ColDefault, 
	MatchFlg, 
	DataTypeA, 
	MaxLengthA, 
	MaxValue, 
	DistinctValues, 
	NullCount, 
	MaxCharLength, 
	Comments, 
	FieldDesc 
FROM	TblColProfile 
ORDER BY  TableName, OrdinalPosition

/*
DROP TABLE TblColProfile
GO

CREATE TABLE TblColProfile 
(
	TableDesc			VARCHAR(20), 
	TableName			varchar(40),
	ColumnName			varchar(30),
	FieldDesc			VARCHAR(1000), 
	CodeCatCd			CHAR(4), 
	TableCodes			VARCHAR(50), 
	Comments			VARCHAR(100), 
	OrdinalPosition		int,
	Nullable			CHAR(3), 
	DataType			varchar (20),
	MaxLength			int,
	ColDefault			VARCHAR(50), 
	MatchFlg			CHAR(1), 
	TableNameA			VARCHAR(20), 
	ColumnNameA			VARCHAR(20), 
	Pos					INT, 
	DataTypeA			VARCHAR(20), 
	MaxLengthA			INT, 
--	MinValue			nvarchar(30),
	MaxValue			nvarchar(30),
	DistinctValues		int, 
	NullCount			int,
--	AvgLengthOrValue	int,
	MaxCharLength		int
) 
ON	CMIS_R_dat
*/
/*
DELETE TblColProfile 

INSERT 
INTO	TblColProfile 
(
	TableDesc,		-- 0
	TableName,
	ColumnName,
	FieldDesc, 
	CodeCatCd, 
	TableCodes,		-- 5
	Comments, 
	OrdinalPosition,
	Nullable, 
	DataType,
	MaxLength,		-- 10
	ColDefault, 
	MatchFlg, 
	TableNameA, 
	ColumnNameA, 
	Pos,			-- 15
	DataTypeA , 
	MaxLengthA, 
---	MinValue,
	MaxValue,
	DistinctValues, 
	NullCount,
---	AvgLengthOrValue,
	MaxCharLength 
)
SELECT	RTRIM([Column 0]),
	CASE 
		WHEN RTRIM([Column 1]) = '' THEN RTRIM([Column 13]) 
		ELSE RTRIM([Column 1]) 
	END, 
	CASE 
		WHEN RTRIM([Column 2]) = '' THEN RTRIM([Column 14]) 
		ELSE RTRIM([Column 2]) 
	END, 
	RTRIM([Column 3]),
	RTRIM([Column 4]),
	RTRIM([Column 5]),
	RTRIM([Column 6]),
	RTRIM([Column 7]),
	RTRIM([Column 8]),
	RTRIM([Column 9]),
	CASE 
		WHEN RTRIM([Column 10]) = 'NULL' THEN NULL
		WHEN RTRIM([Column 10]) = 'DEFAULT' THEN NULL
		ELSE CONVERT(INT, [Column 10])
	END,
	RTRIM([Column 11]),
	RTRIM([Column 12]), 
	RTRIM([Column 13]), 
	RTRIM([Column 14]), 
	RTRIM([Column 15]), 
	RTRIM([Column 16]), 
	CASE 
		WHEN RTRIM([Column 17]) = 'NULL' THEN NULL
		ELSE CONVERT(INT, [Column 17])
	END,
	CASE 
		WHEN RTRIM([Column 18]) = 'NULL' THEN NULL
		ELSE [Column 18]
	END,
	CASE 
		WHEN RTRIM([Column 19]) = 'NULL' THEN NULL 
		WHEN RTRIM([Column 19]) = '739"' THEN 739 
		ELSE CONVERT(INT, [Column 19])
	END, 
	CASE 
		WHEN RTRIM([Column 20]) = 'NULL' THEN NULL
		ELSE [Column 20]
	END, 
	CASE 
		WHEN RTRIM([Column 21]) = 'NULL' THEN NULL
		ELSE [Column 21]
	END 
FROM	[CMIS Data Dictionary - org] 
*/

-- SELECT MAX(LEN([Column 18])) FROM [CMIS Data Dictionary - org] 
-- SELECT MAX([Column 18]) FROM [CMIS Data Dictionary - org]
-- SELECT [Column 19] FROM [CMIS Data Dictionary - org] WHERE [Column 19] = '739"'
-- DELETE TblColProfile WHERE TableName = '' 

