/*
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  Copyright, Lockheed Martin Corporation, 2017
                        Unpublished, All Rights Reserved
================================================================================
*/

/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/* src File:  .sql                                         */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: enum_value_ref                                                */
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

SELECT * FROM dbo.enum_value_ref ORDER BY enum_type, order_by, enum_value;

SELECT NEWID();
SELECT NEWID();
SELECT NEWID();

*/

USE generic
GO

-- DELETE FROM dbo.enum_value_ref_audit WHERE rec_id > 0;
GO

DELETE FROM dbo.enum_value_ref WHERE rec_id > 0;
GO

SET IDENTITY_INSERT dbo.enum_value_ref ON;
GO

DECLARE @smallDateTime smallDateTime = CONVERT(smalldatetime, GETDATE());

INSERT
INTO dbo.enum_value_ref (
    rec_id, rec_uuid, parent_rec_id, enum_type, enum_value, order_by, enum_display_name, description 
    )
VALUES 
( 100, 'fe42c83e-ee6f-4038-971b-4f75c1f8db7d',   1, 'ACTION', 'UNKNOWN',     0, 'Unknown',  'Status not assigned at this time'),
( 101, 'bb0451c5-67cb-4cbf-afb5-11ab20f46fc5',   1, 'ACTION', 'APPROVED',    5, 'Approved', 'The BOM has been approved'),

( 110, '1F69762E-DE05-41D4-9757-BC09511DF5D2',   5, 'APPROVER', 'UNKNOWN',   0, 'Unknown',  'Status not assigned at this time'),
( 111, '8CD042B4-D384-4DAE-8B19-C9F8BED20942',   5, 'APPROVER', 'TBD',       5, 'Approved', 'The BOM has been approved'),

( 120, 'e2e37c4c-c4d2-4142-9cf7-6339a1a8fe9e',  10, 'BOOLEAN_FLAG', 'N',     0, 'No', '0 : No : False'),
( 121, 'd353b209-0033-41da-8ef0-eae495dd2ca7',  10, 'BOOLEAN_FLAG', 'Y',     5, 'Yes', '1 : Yes : True'),

( 130, '6fc42cb1-9029-4911-bd65-4abcc52ff9bb',  20, 'DELETE_FLAG', 'N',      0, 'False', '0 : No : False'),
( 131, '7710d00d-ab12-4b28-ba74-e73682dad8a0',  20, 'DELETE_FLAG', 'Y',      5, 'True', '1 : Yes : True'),

( 140, '6b742367-6ea4-45c0-8ed1-bf036f26eeb4',  25, 'HIDDEN_FLAG', '0',      0, 'False', '0 : No : False'),
( 141, 'a0ea5d21-eee9-4054-8b7d-932c1321a621',  25, 'HIDDEN_FLAG', '1',      5, 'True', '1 : Yes : True'),

( 150, 'AB2F72A7-B950-4691-81C0-2E550FC357C8',  20, 'RESOLUTION_STATUS', '',          0, 'Unknown', 'Status not assigned at this time'),
( 151, 'B22A119E-F862-4393-8A43-4014B9369196',  20, 'RESOLUTION_STATUS', 'WAITING',   5, 'Waiting', 'Feedback item waiting for review'),
( 152, '5775C13E-A095-46F3-BC56-CFE1C2CC3C9D',  20, 'RESOLUTION_STATUS', 'REVIEW',   10, 'Being reviewed', 'Feedback item is under review'),
( 153, 'C6409959-91AF-40E0-8FD1-9ED6F7E859F1',  20, 'RESOLUTION_STATUS', 'FIXING',   15, 'Being fixed', 'Feedback item is being fixed'),
( 154, 'DD5BD988-D534-4889-97D8-D8FB139CEA9D',  20, 'RESOLUTION_STATUS', 'SIGNOFF',  20, 'User signoff', 'Feedback item is out for user review and signoff'),
( 155, '1FDDD97D-9840-433A-86F8-C0B1C876A44C',  20, 'RESOLUTION_STATUS', 'CLOSED',   25, 'Closed', 'Feedback item has be closed'),

( 160, '47F61775-2215-43A3-AE50-DA8A6F34BBCE',  40, 'STATUS', 'C',   0, 'Current', 'Current'),
( 161, '688035DC-B1D2-4FBB-8508-8089D0CB7259',  40, 'STATUS', 'D',   5, 'Duplicate', 'Duplicate'),
( 162, '1F48C773-8A16-4D51-AF16-06C3035DCC79',  40, 'STATUS', 'H',  10, 'Historical', 'Historical'),
( 163, '11247A03-2184-4C51-B08F-EF2342E89CE8',  40, 'STATUS', 'L',  15, 'Logical', 'Logical'),
( 164, 'BCD461CE-56C8-4610-879B-F74A2428B38E',  40, 'STATUS', 'N',  20, 'New', 'New'),
( 165, 'DF8D54A2-16FE-441A-82C3-B9FA99857923',  40, 'STATUS', 'P',  25, 'Processing', 'Processing'),
( 166, 'E3AB2AF7-AE80-4C79-837F-25F502D78C3D',  40, 'STATUS', 'Q',  30, 'Questionable', 'Questionable'),
( 167, '5545DD59-3183-4864-9E8D-23F4E4124B95',  40, 'STATUS', 'R',  35, 'Ready to process', 'Ready to process'),
( 168, '4979B2CF-BD0F-4A33-BAD7-736D54F530DE',  40, 'STATUS', 'W',  40, 'Waiting', 'Waiting'),

( 180, '3a0843bf-a4a1-49b9-8f0c-6bee2dc0a0f8',  50, 'USER_RESOLUTION_STATUS', '', '0', 'Unknown', 'User status not assignened at this time'),
( 181, '3eca676e-48cc-428c-a44a-35b3321b596d',  50, 'USER_RESOLUTION_STATUS', 'CLOSED', '25', 'True', 'User accepts resolution')
;
-- GO

-- Create a temporary table variable to hold the output actions.  
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));  

MERGE INTO dbo.enum_value_ref AS tar  
USING (VALUES  
(   1, 'AAAAAAAA-9AB5-4EB5-968E-E5CF3EE7AC8A',   1, 'ACTION', 'test',       -1, 'Test', 'Test'),  
( 100, 'fe42c83e-ee6f-4038-971b-4f75c1f8db7d',   1, 'ACTION', 'UNKNOWN',     0, 'Unknown',  'Status not assigned at this time'),
( 101, 'bb0451c5-67cb-4cbf-afb5-11ab20f46fc5',   1, 'ACTION', 'APPROVED',    5, 'Approved', 'The BOM has been approved'),

( 110, '1F69762E-DE05-41D4-9757-BC09511DF5D2',   5, 'APPROVER', 'UNKNOWN',   0, 'Unknown',  'Status not assigned at this time'),
( 111, '8CD042B4-D384-4DAE-8B19-C9F8BED20942',   5, 'APPROVER', 'TBD',       5, 'Approved', 'The BOM has been approved'),

( 120, 'e2e37c4c-c4d2-4142-9cf7-6339a1a8fe9e',  10, 'BOOLEAN_FLAG', 'N',     0, 'No', '0 : No : False'),
( 121, 'd353b209-0033-41da-8ef0-eae495dd2ca7',  10, 'BOOLEAN_FLAG', 'Y',     5, 'Yes', '1 : Yes : True'),

( 130, '6fc42cb1-9029-4911-bd65-4abcc52ff9bb',  20, 'DELETE_FLAG', 'N',      0, 'False', '0 : No : False'),
( 131, '7710d00d-ab12-4b28-ba74-e73682dad8a0',  20, 'DELETE_FLAG', 'Y',      5, 'True', '1 : Yes : True'),

( 140, '6b742367-6ea4-45c0-8ed1-bf036f26eeb4',  25, 'HIDDEN_FLAG', '0',      0, 'False', '0 : No : False'),
( 141, 'a0ea5d21-eee9-4054-8b7d-932c1321a621',  25, 'HIDDEN_FLAG', '1',      5, 'True', '1 : Yes : True'),

( 150, 'AB2F72A7-B950-4691-81C0-2E550FC357C8',  20, 'RESOLUTION_STATUS', '',          0, 'Unknown', 'Status not assigned at this time'),
( 151, 'B22A119E-F862-4393-8A43-4014B9369196',  20, 'RESOLUTION_STATUS', 'WAITING',   5, 'Waiting', 'Feedback item waiting for review'),
( 152, '5775C13E-A095-46F3-BC56-CFE1C2CC3C9D',  20, 'RESOLUTION_STATUS', 'REVIEW',   10, 'Being reviewed', 'Feedback item is under review'),
( 153, 'C6409959-91AF-40E0-8FD1-9ED6F7E859F1',  20, 'RESOLUTION_STATUS', 'FIXING',   15, 'Being fixed', 'Feedback item is being fixed'),
( 154, 'DD5BD988-D534-4889-97D8-D8FB139CEA9D',  20, 'RESOLUTION_STATUS', 'SIGNOFF',  20, 'User signoff', 'Feedback item is out for user review and signoff'),
( 155, '1FDDD97D-9840-433A-86F8-C0B1C876A44C',  20, 'RESOLUTION_STATUS', 'CLOSED',   25, 'Closed', 'Feedback item has be closed'),

( 160, '47F61775-2215-43A3-AE50-DA8A6F34BBCE',  40, 'STATUS', 'C',   0, 'Current', 'Current'),
( 161, '688035DC-B1D2-4FBB-8508-8089D0CB7259',  40, 'STATUS', 'D',   5, 'Duplicate', 'Duplicate'),
( 162, '1F48C773-8A16-4D51-AF16-06C3035DCC79',  40, 'STATUS', 'H',  10, 'Historical', 'Historical'),
( 163, '11247A03-2184-4C51-B08F-EF2342E89CE8',  40, 'STATUS', 'L',  15, 'Logical', 'Logical'),
( 164, 'BCD461CE-56C8-4610-879B-F74A2428B38E',  40, 'STATUS', 'N',  20, 'New', 'New'),
( 165, 'DF8D54A2-16FE-441A-82C3-B9FA99857923',  40, 'STATUS', 'P',  25, 'Processing', 'Processing'),
( 166, 'E3AB2AF7-AE80-4C79-837F-25F502D78C3D',  40, 'STATUS', 'Q',  30, 'Questionable', 'Questionable'),
( 167, '5545DD59-3183-4864-9E8D-23F4E4124B95',  40, 'STATUS', 'R',  35, 'Ready to process', 'Ready to process'),
( 168, '4979B2CF-BD0F-4A33-BAD7-736D54F530DE',  40, 'STATUS', 'W',  40, 'Waiting', 'Waiting'),

( 180, '3a0843bf-a4a1-49b9-8f0c-6bee2dc0a0f8',  50, 'USER_RESOLUTION_STATUS', '', '0', 'Unknown', 'User status not assignened at this time'),
( 181, '3eca676e-48cc-428c-a44a-35b3321b596d',  50, 'USER_RESOLUTION_STATUS', 'CLOSED', '25', 'True', 'User accepts resolution')
)  
       AS src (rec_id, rec_uuid, parent_rec_id, enum_type, enum_value, order_by, enum_display_name, description)  
ON tar.enum_type = src.enum_type  
    AND tar.enum_value = src.enum_value
WHEN MATCHED THEN  
    UPDATE SET order_by = src.order_by, 
        enum_display_name = src.enum_display_name, 
        description = src.description, 
        -- classification = src.classification, 
        -- constant_flag = src.constant_flag, 
        update_by = SUBSTRING(USER, 1, 50), 
        update_date = GETDATE()  
WHEN NOT MATCHED THEN  
    INSERT (rec_id, rec_uuid, parent_rec_id, enum_type, enum_value, order_by, enum_display_name, description) 
    VALUES (src.rec_id, src.rec_uuid, src.parent_rec_id, src.enum_type, src.enum_value, src.order_by, src.enum_display_name, src.description)  
OUTPUT $action INTO @SummaryOfChanges;  

-- Query the results of the table variable.  
SELECT Change, COUNT(*) AS CountPerChange  
FROM @SummaryOfChanges  
GROUP BY Change;  

SET IDENTITY_INSERT dbo.enum_value_ref OFF;
GO

UPDATE dbo.enum_value_ref  
SET parent_rec_uuid = etr.rec_uuid 
FROM dbo.enum_value_ref evr  
INNER JOIN dbo.enum_type_ref AS etr ON etr.rec_id = evr.parent_rec_id
WHERE evr.parent_rec_uuid IS NULL;
GO
