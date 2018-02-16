USE generic
GO

-- Verify that the trigger does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'generic.[trig_upd_enum_type_ref]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER generic.[trig_upd_enum_type_ref]
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'generic.enum_type_ref') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE generic.enum_type_ref
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO

--<summary> Short Description </summary>

--<remarks><code>
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref_seq
--      PURPOSE: REC_ID sequence for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: enum_type_ref_seq.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     enum_type_ref
--    GETDATE():         %GETDATE()%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/
--</code></remarks>

/*----- 170_Sequence  -----*/

-- DROP SEQUENCE enum_type_ref_seq;

/*CREATE SEQUENCE enum_type_ref_seq
--    START WITH 1000000 
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; */

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: <Descripton>
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: enum_type_ref.sql
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 180_Create Table  -----*/

DROP TABLE enum_type_ref;
	
CREATE TABLE enum_type_ref 
(
    [rec_id]                           [INT]              IDENTITY (1000, 1)	NOT NULL ,
    [rec_uuid]                         UNIQUEIDENTIFIER   DEFAULT  NEWID() ,
--
    enum_type                          VARCHAR(25)        NOT NULL ,
    enum_type_desc                     VARCHAR(3000)      NOT NULL ,
    classification                     VARCHAR(100) ,
    constant_flag                      CHAR(1)            DEFAULT 'N' , 
--
    [status]                           [CHAR](1)          DEFAULT 'N' ,
    [updt_by]                          [VARCHAR](50)      DEFAULT SUBSTRING(USER, 1, 50) ,
    [lst_updt]                         [SMALLDATETIME]    DEFAULT CONVERT(SMALLDATETIME, GETDATE(), 101) ,
--
    [active_flag]                      [CHAR](1)          DEFAULT 'Y' , 
    [active_date]                      [SMALLDATETIME]    DEFAULT CONVERT(SMALLDATETIME, '01-JAN-1900', 101) , 
    [inactive_date]                    [SMALLDATETIME]    DEFAULT CONVERT(SMALLDATETIME, '31-DEC-2078', 101) ,
--
    [insert_by]                        [VARCHAR](50)      DEFAULT SUBSTRING(USER, 1, 50) , 
    [insert_date]                      [SMALLDATETIME]    DEFAULT CONVERT(SMALLDATETIME, GETDATE(), 101) , 
    [update_by]                        [VARCHAR](50)      DEFAULT NULL ,
    [update_date]                      [SMALLDATETIME]    DEFAULT NULL ,
    [delete_by]                        [VARCHAR](50)      DEFAULT NULL ,
    [delete_flag]                      [CHAR](1)          DEFAULT 'N' ,
    [delete_date]                      [SMALLDATETIME]    DEFAULT NULL ,
    [hidden_by]                        [VARCHAR](50)      DEFAULT NULL ,
    [hidden_flag]                      [CHAR](1)          DEFAULT 'N' ,
    [hidden_date]                      [SMALLDATETIME]    DEFAULT NULL  
) -- ON [Data_Dictionary_Data]
GO

/*----- Table Meta-Data -----*/ 

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

EXEC sp_dropextendedproperty 
	@name =N'CMIS_Description',  
	@level0type =N'SCHEMA', @level0name = 'dbo', 
	@level1type =N'TABLE', @level1name = 'enum_type_ref'
GO 

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', 	@value=N'<Descripton>', 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref'
GO

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', 'enum_type_ref', NULL, NULL);
GO

/*----- Column Meta-Data -----*/ 

EXEC sp_dropextendedproperty 
	@name=N'CMIS_Description',  
	@level0type=N'SCHEMA', @level0name =N'dbo', 
	@level1type=N'TABLE', @level1name =N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'rec_id'
GO 

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'REC_ID - ' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'rec_id'
GO

EXEC sp_updateextendedproperty 
	@name=N'CMIS_Description', @value=N'REC_ID - Primary, blind key of the enum_type_ref table.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'rec_id'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'REC_UUID - Blind uuid key of the enum_type_ref table.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'rec_uuid'
GO


EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'ENUM_TYPE - Name/identifier of the overarching enumeration type that this value belongs to.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'enum_type'
GO
EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'ENUM_TYPE_DESC - ' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'enum_type_desc'
GO
EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'CLASSIFICATION - ' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'classification'
GO
EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'CONSTANT_FLAG - Whether or not enumeration value is unchangeable or dynamic.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'constant_flag'
GO


EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'status'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'UPDT_BY - The date/timestamp of when the record was created/updated.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'updt_by'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'lst_updt'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'ACTIVE_FLAG - Flag indicating if the record is active or not.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'active_flag'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'active_date'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'inactive_date'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'INSERT_BY - Reports who initially created the record.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'insert_by'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'INSERT_DATE - Reports when the record was initially created.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'insert_date'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'UPDATE_BY - Reports who last updated the record.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'update_by'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'UPDATE_DATE - Reports when the record was last updated.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'update_date'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'DELETE_BY - Reports who last deleted the record.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'delete_by'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'DELETE_FLAG - Flag indicating if the record can be deleted.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'delete_flag'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'delete_date'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'HIDDEN_BY - Reports who last hide the record.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'hidden_by'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'hidden_flag'
GO

EXEC sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'enum_type_ref', 
	@level2type=N'COLUMN', @level2name=N'hidden_date'
GO

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', 'enum_type_ref', 'column', default);
GO


/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Primary key for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: pk_enum_type_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 213_Primary Key -----*/

-- ALTER TABLE enum_type_ref DROP CONSTRAINT pk_enum_type_ref 

ALTER TABLE enum_type_ref  
    ADD CONSTRAINT pk_enum_type_ref 
    PRIMARY KEY 
    (
    enum_type
    );
    
   
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Unique index for ixu_enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: ixu_enum_type_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 220_Indexs -----*/

-- DROP INDEX ixu_enum_type_ref_recid;

CREATE UNIQUE INDEX ixu_enum_type_ref_recid 
    ON enum_type_ref
        (
        rec_id
        );

-- DROP INDEX ixu_enum_type_ref_recuuid;

CREATE UNIQUE INDEX ixu_enum_type_ref_recuuid 
    ON enum_type_ref
        (
        rec_uuid
        );

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Foreign key for fk_enum_type_ref_xx_id..
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: fk_enum_type_ref_xx_id.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 215_Foreign Key -----*/

-- ALTER TABLE enum_type_ref  DROP CONSTRAINT fk_enum_type_ref_xx_id;        

--ALTER TABLE enum_type_ref  
--    ADD CONSTRAINT fk_enum_type_ref_code_xx_id 
--    FOREIGN KEY 
--        (
--        xx_code
--        ) 
--    REFERENCES xx_enum_type_ref_yyyyy_dim
--        (
--        xx_code
--        );
--GO


/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Create the active_flag constraint for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: ck_enum_type_ref_act_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE enum_type_ref  DROP CONSTRAINT ck_enum_type_ref_act_fl; 

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE enum_type_ref  
    ADD CONSTRAINT ck_enum_type_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');
GO 


/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Create the delete_flag constraint for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: ck_enum_type_ref_del_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE enum_type_ref  DROP CONSTRAINT ck_enum_type_ref_del_fl;    

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE enum_type_ref  
    ADD CONSTRAINT ck_enum_type_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');
GO


/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Create the hidden_flag constraint for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: ck_enum_type_ref_hid_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE enum_type_ref  DROP CONSTRAINT ck_enum_type_ref_hid_fl;  

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE enum_type_ref  
    ADD CONSTRAINT ck_enum_type_ref_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');
GO


/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: enum_type_ref
--      PURPOSE: Create the status constraint for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: ck_enum_type_ref_stat_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE enum_type_ref  
--     DROP CONSTRAINT ck_enum_type_ref_stat_fl;        

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE enum_type_ref  
    ADD CONSTRAINT ck_enum_type_ref_stat_fl 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );
GO

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: tr_i_enum_type_ref
--      PURPOSE: Insert trigger for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: tr_i_enum_type_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 270_Trigger -----*/

/* IF OBJECT_ID ('tr_i_enum_type_ref_seq', 'TR') IS NOT NULL
    DROP TRIGGER tr_i_enum_type_ref_seq;
GO

CREATE TRIGGER tr_i_enum_type_ref_seq
BEFORE INSERT
ON enum_type_ref
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW

DECLARE

BEGIN
    :new.status   := 'C';
    :new.lst_updt := GETDATE();
    :new.updt_by  := user;

EXCEPTION
    WHEN others THEN
    -- consider logging the error and then re-raise..
    RAISE;
       
END tr_i_enum_type_ref; */
 
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_grant_enum_type_ref
--      PURPOSE: Create grants for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: xxxTSK00xxx_grant_enum_type_ref.sql
--
--        NOTES:
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 290_Grants-----*/

GRANT SELECT, INSERT, UPDATE         ON enum_type_ref TO c_%schema%_db_in;
GRANT SELECT                         ON enum_type_ref TO liw_basic;
GRANT SELECT                         ON enum_type_ref TO liw_restricted;
GRANT SELECT                         ON enum_type_ref TO s_%schema%;

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_synonym_enum_type_ref
--      PURPOSE: Create synonyn for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: xxxTSK00xxx_synonym_enum_type_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     enum_type_ref
--    GETDATE():         %GETDATE()%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 320_Synonyms -----*/   

CREATE PUBLIC SYNONYM enum_type_ref FOR %schema%.enum_type_ref; 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_merge_enum_type_ref
--      PURPOSE: Inital load script for enum_type_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %GETDATE()%
--
--       SOURCE: xxxTSK00xxxx_merge_enum_type_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     enum_type_ref
--    GETDATE():         %GETDATE()%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %GETDATE()% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

DECLARE

BEGIN 

    MERGE INTO  enum_type_ref tar 
    USING (
        SELECT
            1                   AS xx_code , 
            'Test code desc. '  AS xx_desc ,
            0                   AS source_rec_id ,
            0                   AS lst_update_rec_id
            FROM dual
        ) src
    ON (tar.xx_code = src.xx_code)
    WHEN NOT MATCHED THEN 
        INSERT (     xx_code,     xx_desc,     source_rec_id,     lst_update_rec_id )
        VALUES ( src.xx_code, src.xx_desc, src.source_rec_id, src.lst_update_rec_id )
    WHEN MATCHED THEN
        UPDATE SET 
            tar.xx_desc = src.xx_desc;

    COMMIT;    

END;  
GO 
    
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Validate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*

SELECT * FROM enum_type_ref; 
/  


SET SERVEROUTPUT ON

DECLARE

BEGIN 

    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.NEW_LINE;
    
    FOR table_load 
    IN  (
        SELECT rec_id, 
            xx_code,
            xx_desc
        FROM enum_type_ref 
        ORDER BY rec_id
        )
    LOOP
        DBMS_OUTPUT.PUT_LINE
            (          table_load.rec_id 
            || ', ' || table_load.xx_code 
            || ', ' || table_load.xx_desc
            );
    END LOOP;    -- table_load.. 
    
END;  
/ 

*/
