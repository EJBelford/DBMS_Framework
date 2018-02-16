/* Source File: omega_sys_dict_ref_seq.sql                                    */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_sys_dict_ref_seq                                        */
/*      Author: Gene Belford                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
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

-- DROP SEQUENCE IF EXISTS omega_sys_dict_ref_seq;

CREATE SEQUENCE omega_sys_dict_ref_seq 
    INCREMENT   1
    MINVALUE    1
    MAXVALUE    9223372036854775807
    START       1
    CACHE       1;
    

COMMENT ON SEQUENCE omega_sys_dict_ref_seq 
    IS 'omega_sys_dict_ref_seq - Creates a sequence number for omega_sys_dict_ref that is assigned to the rec_id each new record is created.';


ALTER TABLE omega_sys_dict_ref_seq 
    OWNER TO postgres; 


/* Source File: omega_sys_dict_ref.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_sys_dict_ref                                            */
/*      Author: Gene Belford                                                  */
/* Description: <description>                                                 */
/*        Date: 2013-12-18                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2013-12-18             Gene Belford           Created                      */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- DROP TABLE IF EXISTS omega_sys_dict_ref;

CREATE TABLE omega_sys_dict_ref 
(
rec_id              INTEGER      NOT NULL DEFAULT nextval('omega_sys_dict_ref_seq'::regclass),
--
rec_uuid            UUID         UNIQUE NOT NULL, 
--
omega_sys_dict_fk   UUID         REFERENCES omega_sys_dict (rec_uuid), -- NOT NULL,
--
term                VARCHAR(50)  NOT NULL,
term_status         CHAR(1)      NOT NULL DEFAULT 'A', 
term_cat_1          VARCHAR(25), 
term_acro_1         VARCHAR(10), 
term_sort_ordr      INTEGER      DEFAULT 0, 
term_def            TEXT         NOT NULL,
term_source         VARCHAR(100),
term_example_1      TEXT,
term_note_1         TEXT,
--
status              CHAR(1)      NOT NULL DEFAULT 'C', 
status_by           VARCHAR(50)  DEFAULT USER,
status_date         TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT NOW(), 
--
insert_date         TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT NOW(),
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


COMMENT ON TABLE omega_sys_dict_ref 
IS 'omega_sys_dict_ref - <description>';


COMMENT ON COLUMN omega_sys_dict_ref.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN omega_process_log.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term - ';
COMMENT ON COLUMN omega_sys_dict_ref.term_status 
IS 'term_status - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_cat_1 - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_acro_1 - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_sort_ordr - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_def - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_source - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_example_1 - ';
COMMENT ON COLUMN omega_sys_dict_ref.term 
IS 'term_note_1 - ';

COMMENT ON COLUMN omega_sys_dict_ref.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)'; 
COMMENT ON COLUMN omega_sys_dict_ref.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN omega_sys_dict_ref.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN omega_sys_dict_ref.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN omega_sys_dict_ref.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN omega_sys_dict_ref.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN omega_sys_dict_ref.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN omega_sys_dict_ref.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN omega_sys_dict_ref.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN omega_sys_dict_ref.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN omega_sys_dict_ref.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN omega_sys_dict_ref.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN omega_sys_dict_ref.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';

/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('omega_sys_dict_ref') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/


/* Source File: omega_sys_dict_ref_status.sql                                 */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_sys_dict_ref_status                                     */
/*      Author: Gene Belford                                                  */
/* Description: Defines the "status" constraint foromega_sys_dict_ref         */
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

-- ALTER TABLE omega_sys_dict_ref DROP CONSTRAINT omega_sys_dict_ref_status; 

ALTER TABLE omega_sys_dict_ref 
   ADD CONSTRAINT omega_sys_dict_ref_status CHECK (status IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- INSERT 
-- INTO omega_sys_dict_ref (
--     omega_sys_dict_fk, term, term_status, term_def, status
--     )
-- VALUES (
--     '00000000-0000-0000-0000-000000000000', 'test_' || NOW(), 'A', 
--     'test line for developemnt', 'C'
--     );
    
-- CREATE EXTENSION "uuid-ossp";
    
-- INSERT 
-- INTO omega_sys_dict_ref (
--     rec_uuid, 
--     omega_sys_dict_fk, 
--     term, term_status, term_def, status
--     )
-- VALUES (
--     uuid_generate_v4(), 
--     '00000000-0000-0000-0000-000000000000',
--     'test_' || NOW(), 'A', 
--     'test line for developemnt', 'C'
--     );
    
-- SELECT a.* 
-- FROM   omega_sys_dict_ref a 
-- ORDER BY rec_id DESC; 


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: omega_sys_dict_ref_audit.sql                                  */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_sys_dict_ref_audit                                      */
/*      Author: Gene Belford                                                  */
/* Description: Creates an audit table for omega_sys_dict_ref that tracks     */
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

-- DROP TABLE IF EXISTS omega_sys_dict_ref_audit;

CREATE TABLE omega_sys_dict_ref_audit 
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


COMMENT ON TABLE omega_sys_dict_ref_audit 
    IS 'omega_sys_dict_ref_audit - Creates an audit table for omega_sys_dict_ref that tracks changes to the parent table as they are made.';


-- DROP FUNCTION IF EXISTS f_omega_sys_dict_ref_audit;

CREATE OR REPLACE FUNCTION f_omega_sys_dict_ref_audit() 
    RETURNS TRIGGER AS 
    
$BODY$ 
    
/* Source File: f_omega_sys_dict_ref_audit.sql                                */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_omega_sys_dict_ref_audit                                    */
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
        
        INSERT INTO omega_sys_dict_ref_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_term
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
            NOW(), USER, 
            NEW.term;
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO omega_sys_dict_ref_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_term, o_term
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
            NOW(), USER, 
            NEW.term, OLD.term;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO omega_sys_dict_ref_audit 
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


COMMENT ON FUNCTION f_omega_sys_dict_ref_audit() 
    IS 'f_omega_sys_dict_ref_audit() - This function ';


ALTER FUNCTION f_omega_sys_dict_ref_audit() 
    OWNER TO postgres; 
    

/* Source File:                                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: omega_sys_dict_ref                                            */
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

-- DROP TRIGGER IF EXISTS t_omega_sys_dict_ref_audit ON omega_sys_dict_ref;

CREATE TRIGGER t_omega_sys_dict_ref_audit 
    AFTER INSERT OR UPDATE OR DELETE 
    ON omega_sys_dict_ref 
    FOR EACH ROW 
    EXECUTE PROCEDURE f_omega_sys_dict_ref_audit(); 

    
COMMENT ON TRIGGER t_omega_sys_dict_ref_audit 
    ON omega_sys_dict_ref 
    IS 't_omega_sys_dict_ref_audit - This trigger '; 
    
