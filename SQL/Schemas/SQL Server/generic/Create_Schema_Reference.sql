USE DBMS_Framework;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'Reference')
    BEGIN
        PRINT 'Dropping the Reference schema';
        DROP SCHEMA [Reference];
    END;
GO

CREATE SCHEMA [Reference] AUTHORIZATION [dbo];
GO

