USE %DATABASE% 
GO


-- Verify that the trigger does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'%DATABASE%.[trig_upd_%YourObjectName%]') 
	AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
	DROP TRIGGER %DATABASE%.[trig_upd_%YourObjectName%]
GO

-- Verify that the stored procedure does not already exist.

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'%DATABASE%.%YourObjectName%') 
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE %DATABASE%.%YourObjectName%
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
--         NAME: %YourObjectName%_seq
--      PURPOSE: REC_ID sequence for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: %YourObjectName%_seq.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         %SYSDATE%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/
--</code></remarks>

/*----- 170_Sequence  -----*/

-- DROP SEQUENCE %YourObjectName%_seq;

/*CREATE SEQUENCE %YourObjectName%_seq
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
--         NAME: %YourObjectName%
--      PURPOSE: <Descripton>
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: %YourObjectName%.sql
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
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 180_Create Table  -----*/

-- DROP TABLE %YourObjectName%;
	
CREATE TABLE %YourObjectName% 
(
    [rec_id]                           [INT]              IDENTITY (1000000, 1)	NOT NULL ,
    [rec_uuid]                         UNIQUEIDENTIFIER   DEFAULT  NEWID() ,
--
-- Do a replace of the xx to create base table.. 
    [xx_code]                          [INT]              DEFAULT 0 ,
    [xx_desc]                          [VARCHAR](20)      DEFAULT 'unk' ,
--
    [status]                           [CHAR](1)          DEFAULT 'N' ,
    [updt_by]                          [VARCHAR](50)      DEFAULT SUBSTRING(USER, 1, 50) ,
    [lst_updt]                         [SMALLDATETIME]    DEFAULT GETDATE() ,
--
    [active_flag]                      [CHAR](1)          DEFAULT 'Y' , 
    [active_date]                      [SMALLDATETIME]    DEFAULT '01-JAN-1900' , 
    [inactive_date]                    [SMALLDATETIME]    DEFAULT '31-DEC-2099' ,
--
    [insert_by]                        [VARCHAR](50)      DEFAULT SUBSTRING(USER, 1, 50) , 
    [insert_date]                      [SMALLDATETIME]    DEFAULT GETDATE() , 
    [update_by]                        [VARCHAR](50)      NULL ,
    [update_date]                      [SMALLDATETIME]    DEFAULT '01-JAN-1900' ,
    [delete_by]                        [VARCHAR](50)      NULL ,
    [delete_flag]                      [CHAR](1)          DEFAULT 'N' ,
    [delete_date]                      [SMALLDATETIME]    DEFAULT '01-JAN-1900' ,
    [hidden_by]                        [VARCHAR](50)      NULL ,
    [hidden_flag]                      [CHAR](1)          DEFAULT 'N' ,
    [hidden_date]                      [SMALLDATETIME]    DEFAULT '01-JAN-1900' 
) ON [Data_Dictionary_Data]
GO

/*----- Table Meta-Data -----*/ 

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/* EXEC sp_dropextendedproperty 
	@name = 'CMIS_Description',  
	@level0type = 'SCHEMA',	@level0name = 'dbo', 
	@level1type = 'TABLE', @level1name = '%YourObjectName%'
GO */

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'<Descripton>', 
	@level0type=N'SCHEMA',	@level0name=N'dbo', 
	@level1type=N'TABLE', 	@level1name=N'%YourObjectName%'
GO

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', '%YourObjectName%', NULL, NULL);
GO

/*----- Column Meta-Data -----*/ 

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'REC_ID - Primary, blind key of the %YourObjectName% table.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'%YourObjectName%', 
	@level2type=N'COLUMN', @level2name=N'rec_id'
GO

EXEC sys.sp_addextendedproperty 
	@name=N'CMIS_Description', @value=N'REC_ID - ' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'%YourObjectName%', 
	@level2type=N'COLUMN', @level2name=N'rec_id'
GO

EXEC sys.sp_updateextendedproperty 
	@name=N'CMIS_Description', @value=N'REC_ID - Primary, blind key of the enum_type_ref table.' , 
	@level0type=N'SCHEMA', @level0name=N'dbo', 
	@level1type=N'TABLE', @level1name=N'%YourObjectName%', 
	@level2type=N'COLUMN', @level2name=N'rec_id'
GO

SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', 'enum_type_ref', 'column', default);
GO

COMMENT ON COLUMN %YourObjectName%.rec_id 
IS 'REC_ID - Primary, blind key of the %YourObjectName% table.'; 
COMMENT ON COLUMN %YourObjectName%.rec_uuid 
IS 'REC_UUID - Blind uuid key of the %YourObjectName% table.'; 

COMMENT ON COLUMN %YourObjectName%.xx_code 
IS 'xx_CODE - '; 
COMMENT ON COLUMN %YourObjectName%.xx_desc 
IS 'xx_DESC - '; 

COMMENT ON COLUMN %YourObjectName%.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';
COMMENT ON COLUMN %YourObjectName%.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';
COMMENT ON COLUMN %YourObjectName%.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';
COMMENT ON COLUMN %YourObjectName%.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';
COMMENT ON COLUMN %YourObjectName%.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';
COMMENT ON COLUMN %YourObjectName%.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';
COMMENT ON COLUMN %YourObjectName%.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from a outside source.';       
COMMENT ON COLUMN %YourObjectName%.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';
COMMENT ON COLUMN %YourObjectName%.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';
COMMENT ON COLUMN %YourObjectName%.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';
COMMENT ON COLUMN %YourObjectName%.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';
COMMENT ON COLUMN %YourObjectName%.delete_by 
IS 'DELETE_BY - Reports who last deleted the record.';       
COMMENT ON COLUMN %YourObjectName%.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';
COMMENT ON COLUMN %YourObjectName%.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';
COMMENT ON COLUMN %YourObjectName%.hidden_by 
IS 'HIDDEN_BY - Reports who last hide the record.';       
COMMENT ON COLUMN %YourObjectName%.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';
COMMENT ON COLUMN %YourObjectName%.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('%YourObjectName%'); 
*/
/*----- Check to see if the table column comments are present -----*/
/*
SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        b.data_default,  
        a.comments 
--        , '|', b.*  
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('%YourObjectName%') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('%YourObjectName%') 
ORDER BY b.column_id; 
*/

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: %YourObjectName%
--      PURPOSE: Primary key for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: pk_%YourObjectName%.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 213_Primary Key -----*/

-- ALTER TABLE %YourObjectName% DROP CONSTRAINT %YourObjectName% 

ALTER TABLE %YourObjectName%  
    ADD CONSTRAINT pk_%YourObjectName% 
    PRIMARY KEY 
    (
    xx_code
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
--         NAME: %YourObjectName%
--      PURPOSE: Unique index for ixu_%YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ixu_%YourObjectName%.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 220_Indexs -----*/

-- DROP INDEX ixu_%YourObjectName%_recid;

CREATE UNIQUE INDEX ixu_%YourObjectName%_recid 
    ON %YourObjectName%
        (
        rec_id 
        );

-- DROP INDEX ixu_enum_type_ref_recuuid;

CREATE UNIQUE INDEX ixu_%YourObjectName%_recuuid 
    ON %YourObjectName%
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
--         NAME: %YourObjectName%
--      PURPOSE: Foreign key for fk_%YourObjectName%_xx_id..
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: fk_%YourObjectName%_xx_id.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 215_Foreign Key -----*/

-- ALTER TABLE %YourObjectName%  DROP CONSTRAINT fk_%YourObjectName%_xx_id;        

ALTER TABLE %YourObjectName%  
    ADD CONSTRAINT fk_%YourObjectName%_code_xx_id 
    FOREIGN KEY 
        (
        xx_code
        ) 
    REFERENCES xx_%YourObjectName%_yyyyy_dim
        (
        xx_code
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
--         NAME: %YourObjectName%
--      PURPOSE: Create the active_flag constraint for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_%YourObjectName%_act_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE %YourObjectName%  DROP CONSTRAINT ck_%YourObjectName%_act_fl; 

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE %YourObjectName%  
    ADD CONSTRAINT ck_%YourObjectName%_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: %YourObjectName%
--      PURPOSE: Create the delete_flag constraint for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_%YourObjectName%_del_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE %YourObjectName%  DROP CONSTRAINT ck_%YourObjectName%_del_fl;    

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE %YourObjectName%  
    ADD CONSTRAINT ck_%YourObjectName%_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: %YourObjectName%
--      PURPOSE: Create the hidden_flag constraint for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_%YourObjectName%_hid_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE %YourObjectName%  DROP CONSTRAINT ck_%YourObjectName%_hid_fl;  

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE %YourObjectName%  
    ADD CONSTRAINT ck_%YourObjectName%_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: %YourObjectName%
--      PURPOSE: Create the status constraint for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_%YourObjectName%_stat_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 217_Constraints -----*/

-- ALTER TABLE %YourObjectName%  
--     DROP CONSTRAINT ck_%YourObjectName%_stat_fl;        

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE %YourObjectName%  
    ADD CONSTRAINT ck_%YourObjectName%_stat_fl 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
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
--         NAME: tr_i_%YourObjectName%
--      PURPOSE: Insert trigger for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: tr_i_%YourObjectName%.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 270_Trigger -----*/

CREATE OR REPLACE TRIGGER tr_i_%YourObjectName%_seq
BEFORE INSERT
ON %YourObjectName%
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW

DECLARE

    v_rec_id NUMBER;

	FUNCTION raw_to_guid( raw_guid IN RAW ) RETURN VARCHAR2
	IS
	hex VARCHAR2(32);
  
	BEGIN

		hex := RAWTOHEX(raw_guid);

		RETURN SUBSTR(hex, 7, 2) 
			|| SUBSTR(hex, 5, 2) 
			|| SUBSTR(hex, 3, 2) 
			|| SUBSTR(hex, 1, 2) 
			|| '-'
			|| SUBSTR(hex, 11, 2) 
			|| SUBSTR(hex, 9, 2) 
			|| '-'
			|| SUBSTR(hex, 15, 2) 
			|| SUBSTR(hex, 13, 2) 
			|| '-'
			|| SUBSTR(hex, 17, 4) 
			|| '-'
			|| SUBSTR(hex, 21, 12);

	END;

BEGIN
    v_rec_id := 0;

    SELECT %YourObjectName%_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id   := v_rec_id;
    :new.rec_uuid := raw_to_guid(SYS_GUID());
    :new.status   := 'C';
    :new.lst_updt := sysdate;
    :new.updt_by  := user;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise..
        RAISE;
       
END tr_i_%YourObjectName%;
 
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_grant_%YourObjectName%
--      PURPOSE: Create grants for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: xxxTSK00xxx_grant_%YourObjectName%.sql
--
--        NOTES:
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 290_Grants-----*/

GRANT SELECT, INSERT, UPDATE         ON %YourObjectName% TO c_%schema%_db_in;
GRANT SELECT                         ON %YourObjectName% TO liw_basic;
GRANT SELECT                         ON %YourObjectName% TO liw_restricted;
GRANT SELECT                         ON %YourObjectName% TO s_%schema%;

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_synonym_%YourObjectName%
--      PURPOSE: Create synonyn for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: xxxTSK00xxx_synonym_%YourObjectName%.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         %SYSDATE%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- 320_Synonyms -----*/   

CREATE PUBLIC SYNONYM %YourObjectName% FOR %schema%.%YourObjectName%; 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_merge_%YourObjectName%
--      PURPOSE: Inital load script for %YourObjectName%
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: xxxTSK00xxxx_merge_%YourObjectName%.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         %SYSDATE%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

DECLARE

BEGIN 

    MERGE INTO  %YourObjectName% tar 
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
/ 
    
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Validate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*

SELECT * FROM %YourObjectName%; 
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
        FROM %YourObjectName% 
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
