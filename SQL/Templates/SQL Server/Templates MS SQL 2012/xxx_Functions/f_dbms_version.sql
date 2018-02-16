USE Provenance
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[f_dbms_version]') 
	AND OBJECTPROPERTY(id, N'IsScalarFunction') = 1)
	DROP FUNCTION [dbo].[f_dbms_version]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE FUNCTION f_dbms_version ()
	RETURNS INT

AS 

BEGIN
    
/* Source File: f_dbms_version.sql                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_dbms_version()                                              */
/*      Author: Gene Belford                                                  */
/* Description: This function returns the version of PostgreSQL installed     */
/*              as an integer value.  This allows the developer program for   */
/*              featurse not available in the current installed version, but  */
/*              are available newer releases.                                 */
/*              This function was adapted from the following discusion thread */
/* http://postgresql.1045698.n5.nabble.com/Version-Number-Function-td1992392.html */
/*        Date: 2014-03-12                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2014-03-12             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

DECLARE

@return_int int

BEGIN 

    SELECT SERVERPROPERTY('productversion') AS productversion, 
        SERVERPROPERTY ('productlevel') AS productlevel, 
        SERVERPROPERTY ('edition') AS edition    
        
    EXEC @return_int = f_dbms_version;

    WAITFOR DELAY '00:00:01'

    SELECT @return_int AS return_int;
    PRINT  'return_int: ' + CONVERT(CHAR, @return_int);

END; 

*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DECLARE

@f_return                       INT, 
@v_process_step                 INT, 
@v_num_rows                     INT,

@v_inserted_by                  VARCHAR(50),
@v_error_msg                    VARCHAR(200),

@v_productversion               VARCHAR(20),

@v_dbms_ver_num                 INT,
@v_pos01                        INT,
@v_pos02                        INT,
@v_pos03                        INT,

@v_debug                        INT      = 0;  -- 0 = Off  1 = On

/*--- BEGIN ---*/
    
    SELECT @v_process_step   = 0,  
--	      @v_process_name      = 'Unit Test',  
--        @v_module_name       = 'f_xxx_std_debug', 
	@v_inserted_by       = USER 
    
    SELECT @v_dbms_ver_num = 0
    
    SELECT @v_productversion = CONVERT(VARCHAR, SERVERPROPERTY('productversion')) 

    SELECT @v_pos01 = CHARINDEX('.', @v_productversion, 0) 
    SELECT @v_pos02 = CHARINDEX('.', @v_productversion, @v_pos01+1) 
    SELECT @v_pos03 = CHARINDEX('.', @v_productversion, @v_pos02+1) 

    --SELECT @v_pos01, @v_pos02, @v_pos03

    SELECT @v_dbms_ver_num = 100000000 * SUBSTRING(@v_productversion, 1, (@v_pos01-1)) 
        + 1000000 * SUBSTRING(@v_productversion, (@v_pos01+1), (@v_pos02-@v_pos01-1))
        + 100 * SUBSTRING(@v_productversion, (@v_pos02+1), (@v_pos03-@v_pos02-1))
        + SUBSTRING(@v_productversion, (@v_pos03+1), 2)

    SELECT @v_dbms_ver_num = ISNULL(@v_dbms_ver_num, 0)
    
    RETURN @v_dbms_ver_num 

END;
GO

EXEC sp_addextendedproperty 
@name=N'Func_Desc', @value=N'f_dbms_version - This function returns the version of PostgreSQL installed as an integer value.  This allows the developer program for featurse not available in the current installed version, but are available newer releases.  This function was adapted from the following discusion thread http://postgresql.1045698.n5.nabble.com/Version-Number-Function-td1992392.html ' , 
@level0type=N'SCHEMA',@level0name=N'dbo', 
@level1type=N'FUNCTION',@level1name=N'f_dbms_version'
GO
