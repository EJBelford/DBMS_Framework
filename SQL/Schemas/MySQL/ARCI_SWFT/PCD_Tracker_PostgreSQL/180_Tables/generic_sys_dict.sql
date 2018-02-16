/* Source File: generic_sys_dict_seq.sql                                      */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict_seq                                          */
/*      Author: Gene Belford                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
/*        Date: 2013-12-02                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-02             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP SEQUENCE IF EXISTS infrastructure.generic_sys_dict_seq;

CREATE SEQUENCE infrastructure.generic_sys_dict_seq 
    INCREMENT   1
    MINVALUE    1
    MAXVALUE    9223372036854775807
    START       1
    CACHE       1;

    
COMMENT ON SEQUENCE infrastructure.generic_sys_dict_seq 
    IS 'generic_sys_dict_seq - Creates a sequence number for generic_sys_dict that is assigned to the rec_id each new record is created.';


ALTER TABLE infrastructure.generic_sys_dict_seq 
    OWNER TO postgres; 
    

/* Source File: generic_sys_dict.sql                                          */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict                                              */
/*      Author: Gene Belford                                                  */
/* Description: Dictionary of terms related to system.                        */
/*        Date: 2013-12-02                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-02             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS infrastructure.generic_sys_dict;

CREATE TABLE infrastructure.generic_sys_dict 
(
rec_id              INTEGER      NOT NULL DEFAULT nextval('infrastructure.generic_sys_dict_seq'::regclass),
-- 
rec_uuid            UUID         NOT NULL UNIQUE DEFAULT uuid_generate_v4(), 
--
sys_dict_nm         VARCHAR(50)  NOT NULL, 
sys_dict_def        VARCHAR(50),
sys_dict_sort_ordr  INTEGER      DEFAULT 0, 
sys_dict_abbr_flg   BOOLEAN      DEFAULT 'FALSE', 
sys_dict_acro_flg   BOOLEAN      DEFAULT 'FALSE', 
sys_dict_dict_flg   BOOLEAN      DEFAULT 'FALSE', 
--
status              CHAR(1)      NOT NULL DEFAULT 'C', 
status_by           VARCHAR(50)  DEFAULT USER,
status_date         TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(), 
--
insert_date         TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(),
insert_by           VARCHAR(50)  DEFAULT USER,
update_date         TIMESTAMP    WITH TIME ZONE,
update_by           VARCHAR(50),
delete_flag         BOOLEAN      DEFAULT 'FALSE',   
delete_date         TIMESTAMP    WITH TIME ZONE,
delete_by           VARCHAR(50),
hidden_flag         BOOLEAN      DEFAULT 'FALSE',   
hidden_date         TIMESTAMP    WITH TIME ZONE,
hidden_by           VARCHAR(50),
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE infrastructure.generic_sys_dict 
IS 'generic_sys_dict - Dictionary of terms related to system.'; 


COMMENT ON COLUMN infrastructure.generic_sys_dict.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN infrastructure.generic_sys_dict.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 
COMMENT ON COLUMN infrastructure.generic_sys_dict.sys_dict_nm 
IS 'sys_dict_nm - The full name of the term.';
COMMENT ON COLUMN infrastructure.generic_sys_dict.sys_dict_def 
IS 'sys_dict_def - A brief description od the term.';
COMMENT ON COLUMN infrastructure.generic_sys_dict.sys_dict_sort_ordr 
IS 'sys_dict_sort_ordr - Used to order terms when there are more one defieintion for the same term.';
COMMENT ON COLUMN infrastructure.generic_sys_dict.sys_dict_abbr_flg 
IS 'sys_dict_abbr_flg - Flag indicating if there ia an abbrevation for the term,';
COMMENT ON COLUMN infrastructure.generic_sys_dict.sys_dict_acro_flg 
IS 'sys_dict_acro_flg - Flag indicating if there ia an acronym for the term,';
COMMENT ON COLUMN infrastructure.generic_sys_dict.sys_dict_dict_flg 
IS 'sys_dict_dict_fl - ';

COMMENT ON COLUMN infrastructure.generic_sys_dict.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Error, Historical, New, Processing, Waiting)'; 
COMMENT ON COLUMN infrastructure.generic_sys_dict.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN infrastructure.generic_sys_dict.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN infrastructure.generic_sys_dict.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN infrastructure.generic_sys_dict.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN infrastructure.generic_sys_dict.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN infrastructure.generic_sys_dict.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN infrastructure.generic_sys_dict.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN infrastructure.generic_sys_dict.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN infrastructure.generic_sys_dict.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN infrastructure.generic_sys_dict.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN infrastructure.generic_sys_dict.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN infrastructure.generic_sys_dict.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';

/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('generic_sys_dict') AND pn.nspname = 'public';
*/
/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 16581;
*/


/* Source File: <tableName>_status.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict_status                                         */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint for <tableName>.              */
/*        Date: 2013-12-02                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-02             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- ALTER TABLE infrastructure.generic_sys_dict DROP CONSTRAINT generic_sys_dict_status; 

ALTER TABLE infrastructure.generic_sys_dict 
    ADD CONSTRAINT generic_sys_dict_status CHECK (status IN ('C', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

COMMENT ON CONSTRAINT generic_sys_dict_status 
    ON infrastructure.generic_sys_dict 
    IS 'generic_sys_dict - Defines the "status" constraint for generic_sys_dict.';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

INSERT 
INTO infrastructure.generic_sys_dict (
    sys_dict_nm, sys_dict_def, status
    )
VALUES (
    'test_' || CLOCK_TIMESTAMP(), 'desc', 'C'
    );
    
SELECT gsd.* 
FROM   infrastructure.generic_sys_dict gsd 
ORDER BY rec_id DESC; 

UPDATE infrastructure.generic_sys_dict SET  status = 'H' WHERE rec_id = 4;

DELETE FROM infrastructure.generic_sys_dict WHERE rec_id = 4;

/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: generic_sys_dict_audit.sql                                      */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict_audit                                          */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for generic_sys_dict that tracks changes */
/*              to the parent table as they are made.                         */
/*        Date: 2013-12-02                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-02             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS infrastructure.generic_sys_dict_audit;

CREATE TABLE infrastructure.generic_sys_dict_audit 
(
rec_id          INTEGER      NOT NULL,
--
rec_uuid        UUID         NOT NULL, 
--
cmd             CHAR(1)      NOT NULL,
update_date     TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by       VARCHAR(50),
--
n_rec_uuid      uuid,
o_rec_uuid      uuid,
n_sys_dict_nm   VARCHAR(50),
o_sys_dict_nm   VARCHAR(50),
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE infrastructure.generic_sys_dict_audit 
    IS 'generic_sys_dict_audit - Creates an audit table for generic_sys_dict that tracks changes to the parent table as they are made.';


-- DROP FUNCTION IF EXISTS f_generic_sys_dict_audit;

CREATE OR REPLACE FUNCTION infrastructure.f_generic_sys_dict_audit() 
    RETURNS TRIGGER AS 
    
$BODY$ 
    
/* Source File: f_generic_sys_dict_audit.sql                                  */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_generic_sys_dict_audit                                      */
/*      Author: Gene Belford                                                  */
/* Description: Function called by the aubit trigger to insert a new audit    */
/*              record.                                                       */
/*        Date: 2013-12-02                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-02            Gene Belford           Created                       */
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
        
        INSERT INTO infrastructure.generic_sys_dict_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by
            )   
        SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
        CLOCK_TIMESTAMP(), USER; 
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO infrastructure.generic_sys_dict_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_rec_uuid, o_rec_uuid
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.rec_uuid, OLD.rec_uuid;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO infrastructure.generic_sys_dict_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            o_rec_uuid
            )  
        SELECT OLD.rec_id, OLD.rec_uuid, 'D', 
            CLOCK_TIMESTAMP(), USER, 
            OLD.rec_uuid;
    
    END IF;
    
    RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION infrastructure.f_generic_sys_dict_audit() 
    IS 'f_generic_sys_dict_audit() - Function called by the aubit trigger to insert a new audit record.';


ALTER FUNCTION infrastructure.f_generic_sys_dict_audit() 
    OWNER TO postgres; 
    
    
/* Source File:                                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: generic_sys_dict                                              */
/*      Author: Gene Belford                                                  */
/* Description: Trigger to update the audit log on the table.                 */
/*        Date: 2013-12-02                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-02             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TRIGGER IF EXISTS t_generic_sys_dict_audit ON infrastructure.generic_sys_dict;

CREATE TRIGGER t_generic_sys_dict_audit 
    AFTER INSERT OR UPDATE OR DELETE 
    ON infrastructure.generic_sys_dict 
    FOR EACH ROW 
    EXECUTE PROCEDURE infrastructure.f_generic_sys_dict_audit(); 


COMMENT ON TRIGGER t_generic_sys_dict_audit 
    ON infrastructure.generic_sys_dict
    IS 't_generic_sys_dict_audit - Trigger to update the audit log on the table.';    
    
