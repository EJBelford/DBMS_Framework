USE Provenance 
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'dbo.xxx_std_debug') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE dbo.xxx_std_debug
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO

/* Source File: xxx_std_debug.sql                                             */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: xxx_std_debug                                                 */
/*      Author: Gene Belford                                                  */
/* Description: This table is intended to capture exceptions throw by the     */
/*              SQL code.  In theory this should only happen in development.  */
/*        Date: 2013-11-20                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Notes: So do you use a UUID or INT value as a record identifier?  This is  */
/*        a design design you have to make.  The template covers both         */
/*        methods.  The URL below points a good article discussing the topic. */
/* http://blogs.msdn.com/b/sqlserverfaq/archive/2010/05/27/guid-vs-int-debate.aspx?Redirected=true */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-11-20             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

CREATE TABLE xxx_std_debug 
(
rec_id                         INTEGER            IDENTITY (1000000, 1) NOT NULL,
rec_uuid                       UNIQUEIDENTIFIER   DEFAULT NEWID(), 
rec_seq_uuid                   UNIQUEIDENTIFIER   DEFAULT NEWSEQUENTIALID(), 
--
insert_date                    DATETIMEOFFSET(7),
process_name                   VARCHAR(50),
module_name                    VARCHAR(50),
dbms_ver                       VARCHAR(50),
--
error_number                   VARCHAR(10),
error_severity                 INT,
error_state                    INT,
error_procedure                NVARCHAR(128),
error_line                     INT,
error_message                  NVARCHAR(4000),
--
error_parameters               VARCHAR(200),
insert_by                      VARCHAR(50)    NOT NULL,
--
PRIMARY KEY (rec_id) 
) 
GO



EXEC sp_addextendedproperty 
@name=N'Table_Desc', @value=N'xxx_std_debug - This table is intended to capture exceptions throw by the SQL code.  In theory this should only happen in development.' , 
@level0type=N'SCHEMA',@level0name=N'dbo', 
@level1type=N'TABLE',@level1name=N'xxx_std_debug'


EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'rec_id - The unquie durable single field key assigned to the record.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = rec_id;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'insert_date - Timestamp of when the issue occured.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = insert_date;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'process_name - ',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = process_name;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'module_name - ',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = module_name;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'dbms_ver - The version of the DBMS that is installed.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = dbms_ver;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'error_number - The error value as defined by the DBMS.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = error_number;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'error_message - Any error message that the DBMS generated.  The actual code might appended addition information.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = error_message;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'error_parameters - Any specific parameters that might help defined the issue.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = error_parameters;
EXEC sp_addextendedproperty 
@name = N'Col_Desc', @value = 'insert_by - This might be either the USER() or an actual user depending on what is passed in.',
@level0type = N'Schema', @level0name = dbo, 
@level1type = N'Table',  @level1name = xxx_std_debug, 
@level2type = N'Column', @level2name = insert_by;

/*

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', NULL, NULL, NULL, NULL);

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', 'xxx_std_debug', NULL, NULL);

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', 'xxx_std_debug', 'column', default);

*/