USE Provenance
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[p_xxx_std_debug]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[p_xxx_std_debug]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE p_xxx_std_debug (
    @v_insert_date        DATETIMEOFFSET , 
	@v_process_name       TEXT ,  
	@v_module_name        TEXT ,
    @v_error_number       VARCHAR(10) ,     
	@v_error_severity     INT,
    @v_error_state        INT,
    @v_error_procedure    NVARCHAR(128) ,
    @v_error_line         INT,
    @v_error_message	  NVARCHAR(4000) ,
    @v_parameters         VARCHAR(200) ,
    @v_inserted_by        VARCHAR(50)
    )
	
AS 
    
/* Source File: p_xxx_std_debug.sql                                           */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: p_xxx_std_debug                                               */
/*      Author: Gene Belford                                                  */
/* Description: This function captures any SQL exceptions throw by a process. */
/*              It is designed as a debugging tool to provide more detailed   */
/*              information about the exception than the user might get.  It  */
/*              should be incorporated into every function.                   */
/*        Date: 2014-01-01                                                    */
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
/* 2014-01-01             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

DECLARE	
    @return_value        INT, 
    @v_insert_date       DATETIMEOFFSET,
    @sys_user            VARCHAR(50),

    @v_error_number      VARCHAR(10),
    @v_error_severity    INT,
    @v_error_state       INT,
    @v_error_procedure   NVARCHAR(128),
    @v_error_line        INT,

    @v_error_message     NVARCHAR(4000),

    @v_error_parameters  NVARCHAR(200)

BEGIN
	SELECT SYSDATETIMEOFFSET() AS 'sys_utc', 
        @@VERSION AS 'version', 
        @@SPID AS 'ID', SYSTEM_USER AS 'Login Name', USER AS 'User Name';

    SELECT @sys_user = SYSTEM_USER;
     
    DELETE FROM xxx_std_debug WHERE insert_date IS NULL OR insert_date < DATEADD(DAY, -1, SYSDATETIMEOFFSET()); 
--    DELETE FROM xxx_func_warn_log; 

    SELECT @v_insert_date = SYSDATETIMEOFFSET(); 

    EXEC @return_value = p_xxx_std_debug 
        @v_insert_date, 
	    'unit_test',          -- @v_process_name,  
        'p_xxx_std_debug',    -- @v_module_name,
        @v_error_number,
        @v_error_severity,
        @v_error_state,
        @v_error_procedure, 
        @v_error_line,
        @v_error_message,
        'parameters test',    -- @v_parameters, 
        @sys_user;            -- @v_inserted_by

--    SELECT pg_sleep (0.1); 
	WAITFOR DELAY '00:00:00.1';   
    SELECT @v_insert_date = SYSDATETIMEOFFSET(); 

    BEGIN TRY
        -- Generate divide-by-zero error.
        SELECT @return_value = 1/0;
    END TRY
    BEGIN CATCH
        SELECT @v_error_number  = ERROR_NUMBER(), 
            @v_error_severity   = ERROR_SEVERITY(), 
            @v_error_state      = ERROR_STATE(), 
            @v_error_procedure  = ISNULL(ERROR_PROCEDURE(), 'p_xxx_std_debug'), 
            @v_error_line       = ERROR_LINE(), 
            @v_error_message    = SUBSTRING(ERROR_MESSAGE(), 1, 200),
            @v_error_parameters = SUBSTRING('SELECT I/0', 1, 200);

        EXEC @return_value = p_xxx_std_debug 
            @v_insert_date, 
	        'unit_test',          -- @v_process_name,  
            'p_xxx_std_debug',    -- @v_module_name,
            @v_error_number,
            @v_error_severity,
            @v_error_state,
            @v_error_procedure, 
            @v_error_line,
            @v_error_message,
            'parameters test',    -- @v_parameters, 
            @sys_user;            -- @v_inserted_by

    END CATCH;

	SELECT SYSDATETIMEOFFSET() AS 'sys_utc';

    SELECT * FROM xxx_std_debug ORDER BY insert_date DESC, rec_id DESC;

--    SELECT * FROM xxx_func_warn_log ORDER BY warning_status, warning_timestamp DESC;

END;

*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DECLARE 

@f_return                       INT, 
@v_pg_version                   INT, 
@v_process_step                 INT, 
@v_num_rows                     INT,

@v_error_msg                    VARCHAR(200),

@v_debug                        INT      = 0;  -- 0 = Off  1 = On
    
SELECT @v_process_step   = 0,  
    @f_return            = NULL  

    EXEC @v_pg_version   = f_dbms_version; 
    
    IF @v_debug > 0 
	BEGIN 
        SELECT 'dbms_version: ' & @v_pg_version  
        SELECT 'process_step: ' & @v_process_step  
    END  
    
    INSERT INTO xxx_std_debug (
        insert_date
        , process_name
        , module_name
        , dbms_ver
        , error_number
        , error_message
        , error_parameters
        , insert_by 
        )  
    VALUES (  
	    @v_insert_date, 
	    SUBSTRING(@v_process_name,  1, 50),  
	    SUBSTRING(@v_module_name,   1, 50),
        @v_pg_version,  
	    SUBSTRING(@v_error_number,  1, 10),     
	    SUBSTRING(@v_error_message, 1, 200),
        SUBSTRING(@v_parameters,    1, 200),
		SUBSTRING(@v_inserted_by,   1, 50) ); 
GO
    

EXEC sp_addextendedproperty 
@name=N'Proc_Desc', @value=N'p_xxx_std_debug - This function captures any SQL exceptions throw by a process.  It is designed as a debugging tool to provide more detailed information about the exception than the user might get.  It should be incorporated into every function. ' , 
@level0type=N'SCHEMA',@level0name=N'dbo', 
@level1type=N'PROCEDURE',@level1name=N'p_xxx_std_debug'


/*
ALTER FUNCTION p_xxx_std_debug (
            IN TIMESTAMP WITH TIME ZONE, IN TEXT,  IN TEXT,
            IN TEXT,     IN TEXT,  IN TEXT,
            IN TEXT
            ) 
    OWNER TO postgres;
*/    

