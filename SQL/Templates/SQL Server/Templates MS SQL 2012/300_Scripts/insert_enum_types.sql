/*
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  Copyright, Lockheed Martin Corporation, 2017
                        Unpublished, All Rights Reserved
================================================================================
*/

/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/* src File: insert_enum_type_ref.sql                                         */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_type_ref                                                    */
/*      Author: Gene Belford                                                  */
/* Description: The overarching data object that represents whole             */
/*              enumerations in the database by their names.                  */
/*        Date: 2017-06-01                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-01             Gene Belford          Created                       */
/* 2017-10-04             Gene Belford          Updated for production        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

/*----- 300_Scripts -----*/

/*

SELECT * FROM dbo.enum_type_ref ORDER BY enum_type;

SELECT NEWID();
SELECT NEWID();
SELECT NEWID();

*/

USE generic
GO

-- DELETE FROM dbo.enum_type_ref_audit WHERE rec_id > 0;
GO

DELETE FROM dbo.enum_type_ref WHERE rec_id > 0;
GO

SET IDENTITY_INSERT dbo.enum_type_ref ON;
GO

DECLARE @smallDateTime smallDateTime = CONVERT(smalldatetime, GETDATE());

INSERT
INTO dbo.enum_type_ref (
    rec_id, rec_uuid, enum_type, enum_type_desc, insert_date, classification, constant_flag 
    )
VALUES 
(  1, '23E18032-3635-42C3-B640-BEDD758F8D18', 'ACTION',                 'Action required enumerations', 
  @smallDateTime, 'U', 'N'),
(  5, '036800F9-3170-4503-96C7-50D2D2972933', 'APPROVER',               'List of Approvers', 
  @smallDateTime, 'U', 'N'),
( 10, '6A88A0D6-2D2D-4C7B-ACC8-A84D06FD805E', 'BOOLEAN_FLAG',           'Boolean Flag enumerations', 
  @smallDateTime, 'U', 'N'),
( 15, '9CA3397B-5ECD-4EF8-AED1-AB9DA6EB91C4', 'CLASSIFICATION',         'Classification enumerations', 
  @smallDateTime, 'U', 'N'),
( 20, 'F9A2F9A1-59AA-4D15-B4C7-7E52E9A1FA2F', 'DELETE_FLAG',            'Indicates whether the record has been locigally deleted', 
  @smallDateTime, 'U', 'N'),
( 25, '3E72FA1D-5CCC-4CF0-896C-94F964993820', 'HIDDEN_FLAG',            'Indicates whether the record should be excluded from selection list', 
  @smallDateTime, 'U', 'N'),
( 30, 'F158569A-B57E-464B-8C78-011740C11EA8', 'RESOLUTION_STATUS',                   'User role enumerations', 
  @smallDateTime, 'U', 'N'),
( 35, 'F158569A-B57E-464B-8C78-011740C11EA8', 'ROLE',                   'User role enumerations', 
  @smallDateTime, 'U', 'N'),
( 40, '7CA48DD5-06A8-4873-B92C-610382DB789C', 'STATUS',                 'The status of the record', 
  @smallDateTime, 'U', 'N'),
( 45, 'BABDA170-9AB5-4EB5-968E-E5CF3EE7AC8A', 'USER',                   'User enumerations', 
  @smallDateTime, 'U', 'N'),
( 50, 'BABDA170-9AB5-4EB5-968E-E5CF3EE7AC8A', 'USER_RESOLUTION_STATUS',                   'User enumerations', 
  @smallDateTime, 'U', 'N') 
;
-- GO

-- Create a temporary table variable to hold the output actions.  
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));  

MERGE INTO dbo.enum_type_ref AS tar  
USING (VALUES  
(  1, '23E18032-3635-42C3-B640-BEDD758F8D18', 'ACTION',                 'Action required enumerations', 
  @smallDateTime, 'U', 'N'),
(  5, '036800F9-3170-4503-96C7-50D2D2972933', 'APPROVER',               'List of Approvers', 
  @smallDateTime, 'U', 'N'),
( 10, '6A88A0D6-2D2D-4C7B-ACC8-A84D06FD805E', 'BOOLEAN_FLAG',           'Boolean Flag enumerations', 
  @smallDateTime, 'U', 'N'),
( 15, '9CA3397B-5ECD-4EF8-AED1-AB9DA6EB91C4', 'CLASSIFICATION',         'Classification enumerations', 
  @smallDateTime, 'U', 'N'),
( 20, 'F9A2F9A1-59AA-4D15-B4C7-7E52E9A1FA2F', 'DELETE_FLAG',            'Indicates whether the record has been locigally deleted', 
  @smallDateTime, 'U', 'N'),
( 25, '3E72FA1D-5CCC-4CF0-896C-94F964993820', 'HIDDEN_FLAG',            'Indicates whether the record should be excluded from selection list', 
  @smallDateTime, 'U', 'N'),
( 30, 'F158569A-B57E-464B-8C78-011740C11EA8', 'ROLE',                   'User role enumerations', 
  @smallDateTime, 'U', 'N'),
( 35, '7CA48DD5-06A8-4873-B92C-610382DB789C', 'STATUS',                 'The status of the record', 
  @smallDateTime, 'U', 'N'),
( 40, 'BABDA170-9AB5-4EB5-968E-E5CF3EE7AC8A', 'USER',                   'User enumerations', 
  @smallDateTime, 'U', 'N'), 
( 99, 'AAAAAAAA-9AB5-4EB5-968E-E5CF3EE7AC8A', 'test',                   'User enumerations', 
  @smallDateTime, 'U', 'N') 
)  
       AS src (rec_id, rec_uuid, enum_type, enum_type_desc, insert_date, classification, constant_flag)  
ON tar.enum_type = src.enum_type  
WHEN MATCHED THEN  
    UPDATE SET enum_type_desc = src.enum_type_desc, 
        classification = src.classification, 
        constant_flag = src.constant_flag, 
        update_by = SUBSTRING(USER, 1, 50), 
        update_date = GETDATE()  
WHEN NOT MATCHED THEN  
    INSERT (rec_id, rec_uuid, enum_type, enum_type_desc, insert_date, classification, constant_flag) 
    VALUES (src.rec_id, src.rec_uuid, src.enum_type, src.enum_type_desc, src.insert_date, src.classification, src.constant_flag)  
OUTPUT $action INTO @SummaryOfChanges;  

-- Query the results of the table variable.  
SELECT Change, COUNT(*) AS CountPerChange  
FROM @SummaryOfChanges  
GROUP BY Change;  

SET IDENTITY_INSERT dbo.enum_type_ref OFF;
GO

