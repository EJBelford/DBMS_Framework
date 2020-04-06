USE DBMS_Framework;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT name FROM sys.tables WHERE name = N'Sys_Dict')
    BEGIN
        PRINT 'Dropping the Reference.Sys_Dict table';
        DROP TABLE [Reference].[Sys_Dict];
    END;
GO

CREATE TABLE [Reference].[Sys_Dict] (
    [rec_id]                [INT]               IDENTITY(1, 1) NOT NULL,
    [rec_uuid]              [UNIQUEIDENTIFIER]  DEFAULT  NEWID(),
    [sys_dict_name]         [NVARCHAR](50)      NOT NULL,
    [sys_dict_desc]         [NVARCHAR](250),
    [sys_dict_sort_order]   [INT]               DEFAULT  0,
    [sys_dict_abbr]         [NVARCHAR](4),
    [sys_dict_acro]         [NVARCHAR](8),
    [sys_dict_dict]         [NVARCHAR](8),
    CONSTRAINT  [PK_Sys_Dict_rec_id] PRIMARY KEY CLUSTERED 
    (
	    [rec_id] ASC
    ) WITH ( PAD_INDEX = OFF, 
        STATISTICS_NORECOMPUTE = OFF, 
        IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, 
        ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
);
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', 
    @value=N'Primary key for Sys_Dict records.' , 
    @level0type=N'SCHEMA', @level0name=N'Reference', 
    @level1type=N'TABLE', @level1name=N'Sys_Dict', 
    @level2type=N'COLUMN',@level2name=N'rec_id'
GO

