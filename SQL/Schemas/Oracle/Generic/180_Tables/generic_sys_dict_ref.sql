/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: generic_sys_dict_ref_seq
--      PURPOSE: REC_ID sequence for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: generic_sys_dict_ref_seq.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     generic_sys_dict_ref
--    Sysdate:         %SYSDATE%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE generic_sys_dict_ref_seq;

CREATE SEQUENCE generic_sys_dict_ref_seq
--    START WITH 1000000 
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: generic_sys_dict_ref
--      PURPOSE: <Descripton>
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: generic_sys_dict_ref.sql
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

/*----- Create Table  -----*/

-- DROP TABLE generic_sys_dict_ref;
	
CREATE TABLE generic_sys_dict_ref 
(
    rec_id                           NUMBER              NOT NULL ,
    rec_uuid                         VARCHAR2(40)        NOT NULL ,
--
--    generic_sys_dict_fk   UUID       REFERENCES generic_sys_dict (rec_uuid), -- NOT NULL,
--
    term                             VARCHAR2(50)        NOT NULL,
    term_status                      CHAR(1)             DEFAULT 'A', 
    term_cat_1                       VARCHAR2(25), 
    term_acro_1                      VARCHAR2(10), 
    term_sort_ordr                   INTEGER             DEFAULT 0, 
    term_def                         VARCHAR2(4000)      NOT NULL,
    term_source                      VARCHAR2(200),
    term_date                        VARCHAR2(15),
    term_example_1                   NCLOB,
    term_note_1                      NCLOB,
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(50)        DEFAULT SUBSTR(USER, 1, 50) ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'Y' , 
    active_date                      DATE                DEFAULT TO_DATE('01-JAN-1900', 'DD-MON-YYYY') , 
    inactive_date                    DATE                DEFAULT TO_DATE('31-DEC-2099', 'DD-MON-YYYY') ,
--
    insert_by                        VARCHAR2(50)        DEFAULT SUBSTR(USER, 1, 50) , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(50)        NULL ,
    update_date                      DATE                DEFAULT TO_DATE('01-JAN-1900', 'DD-MON-YYYY') ,
    delete_by                        VARCHAR2(50)        NULL ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT TO_DATE('01-JAN-1900', 'DD-MON-YYYY') ,
    hidden_by                        VARCHAR2(50)        NULL ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                      DATE                DEFAULT TO_DATE('01-JAN-1900', 'DD-MON-YYYY') 
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             32K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE generic_sys_dict_ref 
IS 'generic_sys_dict_ref - <Descripton>'; 


/*----- Column Meta-Data -----*/ 

COMMENT ON COLUMN generic_sys_dict_ref.rec_id 
IS 'REC_ID - Primary, blind key of the generic_sys_dict_ref table.'; 

COMMENT ON COLUMN generic_sys_dict_ref.rec_uuid 
IS 'REC_UUID - Blind uuid key of the generic_sys_dict_ref table.'; 


COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term - ';
COMMENT ON COLUMN generic_sys_dict_ref.term_status 
IS 'term_status - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_cat_1 - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_acro_1 - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_sort_ordr - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_def - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_source - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_example_1 - ';
COMMENT ON COLUMN generic_sys_dict_ref.term 
IS 'term_note_1 - ';


COMMENT ON COLUMN generic_sys_dict_ref.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN generic_sys_dict_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN generic_sys_dict_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN generic_sys_dict_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN generic_sys_dict_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN generic_sys_dict_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN generic_sys_dict_ref.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from a outside source.';       

COMMENT ON COLUMN generic_sys_dict_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN generic_sys_dict_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN generic_sys_dict_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN generic_sys_dict_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN generic_sys_dict_ref.delete_by 
IS 'DELETE_BY - Reports who last deleted the record.';       

COMMENT ON COLUMN generic_sys_dict_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN generic_sys_dict_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN generic_sys_dict_ref.hidden_by 
IS 'HIDDEN_BY - Reports who last hide the record.';       

COMMENT ON COLUMN generic_sys_dict_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN generic_sys_dict_ref.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('generic_sys_dict_ref'); 
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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('generic_sys_dict_ref') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('generic_sys_dict_ref') 
ORDER BY b.column_id; 
*/
/*----- Look-up field description from master LIDB table -----*/
/*
SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name; 
/ 
*/
/*   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%rec_id%'); 
/ 
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Primary key for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: pk_generic_sys_dict_ref.sql
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

/*----- Primary Key -----*/

ALTER TABLE generic_sys_dict_ref  
    ADD CONSTRAINT pk_generic_sys_dict_ref 
    PRIMARY KEY 
    (
    rec_id
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Unique index for ixu_generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ixu_generic_sys_dict_ref.sql
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

/*----- Indexs -----*/

-- DROP INDEX ixu_generic_sys_dict_ref;

CREATE UNIQUE INDEX ixu_generic_sys_dict_ref 
    ON generic_sys_dict_ref
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Foreign key for fk_generic_sys_dict_ref_xx_id..
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: fk_generic_sys_dict_ref_xx_id.sql
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

/*----- Foreign Key -----*/

-- ALTER TABLE generic_sys_dict_ref  DROP CONSTRAINT fk_generic_sys_dict_ref_xx_id;        

ALTER TABLE generic_sys_dict_ref  
    ADD CONSTRAINT fk_pfsa_code_xx_id 
    FOREIGN KEY 
        (
        xx_code
        ) 
    REFERENCES xx_pfsa_yyyyy_dim
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Create the active_flag constraint for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_generic_sys_dict_ref_act_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE generic_sys_dict_ref  DROP CONSTRAINT ck_generic_sys_dict_ref_act_fl; 

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE generic_sys_dict_ref  
    ADD CONSTRAINT ck_generic_sys_dict_ref_act_fl 
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Create the delete_flag constraint for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_generic_sys_dict_ref_del_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE generic_sys_dict_ref  DROP CONSTRAINT ck_generic_sys_dict_ref_del_fl;    

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE generic_sys_dict_ref  
    ADD CONSTRAINT ck_generic_sys_dict_ref_del_fl 
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Create the hidden_flag constraint for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_generic_sys_dict_ref_hid_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE generic_sys_dict_ref  DROP CONSTRAINT ck_generic_sys_dict_ref_hid_fl;  

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE generic_sys_dict_ref  
    ADD CONSTRAINT ck_generic_sys_dict_ref_hid_fl 
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
--         NAME: generic_sys_dict_ref
--      PURPOSE: Create the status constraint for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: ck_generic_sys_dict_ref_stat_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE generic_sys_dict_ref  
--     DROP CONSTRAINT ck_generic_sys_dict_ref_stat_fl;        

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE generic_sys_dict_ref  
    ADD CONSTRAINT ck_generic_sys_dict_ref_stat_fl 
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
--         NAME: tr_i_generic_sys_dict_ref
--      PURPOSE: Insert trigger for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: tr_i_generic_sys_dict_ref.sql
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

/*----- Create the Trigger now -----*/

CREATE OR REPLACE TRIGGER tr_i_generic_sys_dict_ref_seq
BEFORE INSERT
ON generic_sys_dict_ref
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

    SELECT generic_sys_dict_ref_seq.nextval 
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
       
END tr_i_generic_sys_dict_ref;
 
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_grant_generic_sys_dict_ref
--      PURPOSE: Create grants for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: xxxTSK00xxx_grant_generic_sys_dict_ref.sql
--
--        NOTES:
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Grants-----*/

GRANT SELECT, INSERT, UPDATE         ON generic_sys_dict_ref TO c_pfsaw_db_in;
GRANT SELECT                         ON generic_sys_dict_ref TO liw_basic;
GRANT SELECT                         ON generic_sys_dict_ref TO liw_restricted;
GRANT SELECT                         ON generic_sys_dict_ref TO s_pfsaw;

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_synonym_generic_sys_dict_ref
--      PURPOSE: Create synonyn for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: xxxTSK00xxx_synonym_generic_sys_dict_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     generic_sys_dict_ref
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

/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM generic_sys_dict_ref FOR pfsawh.generic_sys_dict_ref; 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_merge_generic_sys_dict_ref
--      PURPOSE: Inital load script for generic_sys_dict_ref
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: xxxTSK00xxxx_merge_generic_sys_dict_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     generic_sys_dict_ref
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

    MERGE INTO  generic_sys_dict_ref tar 
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

SELECT * FROM generic_sys_dict_ref; 
/  


DECLARE

BEGIN 

    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.NEW_LINE;
    
    FOR table_load 
    IN  (
        SELECT rec_id, 
            xx_code,
            xx_desc
        FROM generic_sys_dict_ref 
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

/* Source File: generic_sys_dict_ref_audit.sql                                  */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict_ref_audit                                      */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for generic_sys_dict_ref that tracks     */
/*              changes to the parent table as they are made.                 */
/*        Date: 2013-12-18                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-18             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS generic_sys_dict_ref_audit;

CREATE TABLE generic_sys_dict_ref_audit 
(
rec_id                INTEGER      NOT NULL,
--
rec_uuid              UUID         NOT NULL, 
--
cmd                   CHAR(1)      NOT NULL,
update_date           TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by             VARCHAR(50),
--
n_term                VARCHAR(50),
o_term                VARCHAR(50),
n_term_status         VARCHAR(50),
o_term_status         VARCHAR(50),
n_term_cat_1          VARCHAR(25), 
o_term_cat_1          VARCHAR(25), 
n_term_acro_1         VARCHAR(10), 
o_term_acro_1         VARCHAR(10), 
n_term_def            TEXT,
o_term_def            TEXT,
n_term_source         VARCHAR(100),
o_term_source         VARCHAR(100),
n_term_example_1      TEXT,
o_term_example_1      TEXT,
n_term_note_1         TEXT,
o_term_note_1         TEXT,
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE generic_sys_dict_ref_audit 
    IS 'generic_sys_dict_ref_audit - Creates an audit table for generic_sys_dict_ref that tracks changes to the parent table as they are made.';


-- DROP FUNCTION IF EXISTS f_generic_sys_dict_ref_audit;

CREATE OR REPLACE FUNCTION f_generic_sys_dict_ref_audit() 
    RETURNS TRIGGER AS 
    
$BODY$ 
    
/* Source File: f_generic_sys_dict_ref_audit.sql                                */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_generic_sys_dict_ref_audit                                    */
/*      Author: Gene Belford                                                  */
/* Description:                                                               */
/*        Date: 2013-12-18                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-18             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*


*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

BEGIN 

    IF (TG_OP='INSERT') THEN 
        
        INSERT INTO generic_sys_dict_ref_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_term
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
            NOW(), USER, 
            NEW.term;
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO generic_sys_dict_ref_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_term, o_term
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
            NOW(), USER, 
            NEW.term, OLD.term;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO generic_sys_dict_ref_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            o_term
            )  
        SELECT OLD.rec_id, OLD.rec_uuid, 'D', 
            NOW(), USER, 
            OLD.term;
    
    END IF;
    
    RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION f_generic_sys_dict_ref_audit() 
    IS 'f_generic_sys_dict_ref_audit() - This function ';


ALTER FUNCTION f_generic_sys_dict_ref_audit() 
    OWNER TO postgres; 
    

/* Source File:                                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict_ref                                            */
/*      Author: Gene Belford                                                  */
/* Description:                                                               */
/*        Date: 2013-12-18                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-18             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TRIGGER IF EXISTS t_generic_sys_dict_ref_audit ON generic_sys_dict_ref;

CREATE TRIGGER t_generic_sys_dict_ref_audit 
    AFTER INSERT OR UPDATE OR DELETE 
    ON generic_sys_dict_ref 
    FOR EACH ROW 
    EXECUTE PROCEDURE f_generic_sys_dict_ref_audit(); 

    
COMMENT ON TRIGGER t_generic_sys_dict_ref_audit 
    ON generic_sys_dict_ref 
    IS 't_generic_sys_dict_ref_audit - This trigger '; 
    
