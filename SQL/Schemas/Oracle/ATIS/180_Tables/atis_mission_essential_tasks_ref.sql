/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref_seq
--      PURPOSE: REC_ID sequence for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: mission_essential_tasks_ref_seq.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- Sequence  -----*/

-- DROP SEQUENCE mission_essential_tasks_ref_seq;

CREATE SEQUENCE mission_essential_tasks_ref_seq
--    START WITH 1000000 
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: <Descripton>
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: mission_essential_tasks_ref.sql
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
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Create Table  -----*/

-- DROP TABLE mission_essential_tasks_ref;
	
CREATE TABLE mission_essential_tasks_ref 
(
    rec_id                           NUMBER              NOT NULL ,
    rec_uuid                         VARCHAR2(40)        NOT NULL ,
--
    met_code                         VARCHAR2(12)        NOT NULL ,
    met_desc                         VARCHAR2(200)       NOT NULL ,
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

COMMENT ON TABLE mission_essential_tasks_ref 
IS 'mission_essential_tasks_ref - <Descripton>'; 


/*----- Column Meta-Data -----*/ 

COMMENT ON COLUMN mission_essential_tasks_ref.rec_id 
IS 'REC_ID - Primary, blind key of the mission_essential_tasks_ref table.'; 

COMMENT ON COLUMN mission_essential_tasks_ref.rec_uuid 
IS 'REC_UUID - Blind uuid key of the mission_essential_tasks_ref table.'; 

COMMENT ON COLUMN mission_essential_tasks_ref.xx_code 
IS 'xx_CODE - '; 

COMMENT ON COLUMN mission_essential_tasks_ref.xx_desc 
IS 'xx_DESC - '; 

COMMENT ON COLUMN mission_essential_tasks_ref.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN mission_essential_tasks_ref.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN mission_essential_tasks_ref.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN mission_essential_tasks_ref.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN mission_essential_tasks_ref.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN mission_essential_tasks_ref.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN mission_essential_tasks_ref.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from a outside source.';       

COMMENT ON COLUMN mission_essential_tasks_ref.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN mission_essential_tasks_ref.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN mission_essential_tasks_ref.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN mission_essential_tasks_ref.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN mission_essential_tasks_ref.delete_by 
IS 'DELETE_BY - Reports who last deleted the record.';       

COMMENT ON COLUMN mission_essential_tasks_ref.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN mission_essential_tasks_ref.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN mission_essential_tasks_ref.hidden_by 
IS 'HIDDEN_BY - Reports who last hide the record.';       

COMMENT ON COLUMN mission_essential_tasks_ref.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN mission_essential_tasks_ref.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/
/*
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('mission_essential_tasks_ref'); 
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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('mission_essential_tasks_ref') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('mission_essential_tasks_ref') 
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
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Primary key for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: pk_mission_essential_tasks_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Primary Key -----*/

ALTER TABLE mission_essential_tasks_ref  
    ADD CONSTRAINT pk_mission_essential_tasks_ref 
    PRIMARY KEY 
    (
    rec_id
    );
    
   
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Unique index for ixu_mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: ixu_mission_essential_tasks_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Indexs -----*/

-- DROP INDEX ixu_mission_essential_tasks_ref;

CREATE UNIQUE INDEX ixu_mission_essential_tasks_ref 
    ON mission_essential_tasks_ref
        (
        xx_code
        );

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Foreign key for fk_mission_essential_tasks_ref_xx_id..
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: fk_mission_essential_tasks_ref_xx_id.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Foreign Key -----*/

-- ALTER TABLE mission_essential_tasks_ref  DROP CONSTRAINT fk_mission_essential_tasks_ref_xx_id;        

ALTER TABLE mission_essential_tasks_ref  
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
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Create the active_flag constraint for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: ck_mission_essential_tasks_ref_act_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE mission_essential_tasks_ref  DROP CONSTRAINT ck_mission_essential_tasks_ref_act_fl; 

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE mission_essential_tasks_ref  
    ADD CONSTRAINT ck_mission_essential_tasks_ref_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Create the delete_flag constraint for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: ck_mission_essential_tasks_ref_del_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE mission_essential_tasks_ref  DROP CONSTRAINT ck_mission_essential_tasks_ref_del_fl;    

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE mission_essential_tasks_ref  
    ADD CONSTRAINT ck_mission_essential_tasks_ref_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Create the hidden_flag constraint for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: ck_mission_essential_tasks_ref_hid_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE mission_essential_tasks_ref  DROP CONSTRAINT ck_mission_essential_tasks_ref_hid_fl;  

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE mission_essential_tasks_ref  
    ADD CONSTRAINT ck_mission_essential_tasks_ref_hid_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Create the status constraint for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: ck_mission_essential_tasks_ref_stat_fl.sql
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Constraints -----*/

-- ALTER TABLE mission_essential_tasks_ref  
--     DROP CONSTRAINT ck_mission_essential_tasks_ref_stat_fl;        

--                          1         2         3..
--                 123456789012345678901234567890..    

ALTER TABLE mission_essential_tasks_ref  
    ADD CONSTRAINT ck_mission_essential_tasks_ref_stat_fl 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: tr_i_mission_essential_tasks_ref
--      PURPOSE: Insert trigger for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: tr_i_mission_essential_tasks_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Create the Trigger now -----*/

CREATE OR REPLACE TRIGGER tr_i_mission_essential_tasks_ref_seq
BEFORE INSERT
ON mission_essential_tasks_ref
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

    SELECT mission_essential_tasks_ref_seq.nextval 
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
       
END mission_essential_tasks_ref_seq;
 
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_grant_mission_essential_tasks_ref
--      PURPOSE: Create grants for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: xxxTSK00xxx_grant_mission_essential_tasks_ref.sql
--
--        NOTES:
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Grants-----*/

GRANT SELECT, INSERT, UPDATE         ON mission_essential_tasks_ref TO c_pfsaw_db_in;
GRANT SELECT                         ON mission_essential_tasks_ref TO liw_basic;
GRANT SELECT                         ON mission_essential_tasks_ref TO liw_restricted;
GRANT SELECT                         ON mission_essential_tasks_ref TO s_pfsaw;

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_synonym_mission_essential_tasks_ref
--      PURPOSE: Create synonyn for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: xxxTSK00xxx_synonym_mission_essential_tasks_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     mission_essential_tasks_ref
--    Sysdate:         2017-12-04
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM mission_essential_tasks_ref FOR pfsawh.mission_essential_tasks_ref; 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: xxxTSK00xxx_merge_mission_essential_tasks_ref
--      PURPOSE: Inital load script for mission_essential_tasks_ref
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: xxxTSK00xxxx_merge_mission_essential_tasks_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     mission_essential_tasks_ref
--    Sysdate:         2017-12-04
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        Gene Belford (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - xxxTSK00xxx - Created.. 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

DECLARE

BEGIN 

    MERGE INTO  mission_essential_tasks_ref tar 
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

SELECT * FROM mission_essential_tasks_ref; 
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
        FROM mission_essential_tasks_ref 
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
