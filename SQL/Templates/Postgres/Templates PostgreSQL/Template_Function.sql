-- DROP FUNCTION IF EXISTS f_<funcName>();

CREATE OR REPLACE FUNCTION f_<funcName>() 
    RETURNS <return> 

AS 
    
$BODY$ 
    
/* Source File: f_<funcName>.sql                                              */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_<funcname>                                                  */
/*      Author: <author>                                                      */
/* Description: This function <description>                                   */
/*        Date: <yyyy-mm-dd>                                                  */
/* Source File: f_<funcName>.sql                                              */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>           Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

SELECT pg_sleep (1.1); 

-- DELETE FROM omega_std_debug; 
-- DELETE FROM omega_func_warn_log; 

SELECT f_<funcName>('Unit Test', 'EJB', 'Unit level test: '); 

SELECT * FROM omega_std_debug ORDER BY insert_date DESC;

SELECT * FROM omega_func_warn_log ORDER BY warning_status, warning_timestamp DESC;

*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 260 Function 

DECLARE 

f_return                       INTEGER; 

v_null                         INTEGER      = NULL; 

v_rec_id                       INTEGER;
v_rec_uuid                     UUID;
v_pg_version                   INTEGER; 
v_process_start                TIMESTAMP    WITH TIME ZONE;

vrow_ofwl                      omega_func_warn_log%ROWTYPE; 
--    rec_id                  INTEGER
--    rec_uuid                UUID
--    warning_type            VARCHAR(50)
--    warning_from            VARCHAR(100)
--    warning_msg             VARCHAR(2000)
--    warning_status          CHAR(1)
--    warning_timestamp       TIMESTAMP
--    warning_action          VARCHAR(2000)
--    update_date             TIMESTAMP
--    update_by               VARCHAR(50)

vrow_opl                       omega_process_log%ROWTYPE; 
--    rec_id                  INTEGER
--    rec_uuid                UUID 
--    batch_id                INTEGER 
--    process_id              INTEGER
--    process_module          INTEGER 
--    process_step            INTEGER,
--    process_start           TIMESTAMP 
--    process_stop            TIMESTAMP 
--    process_status          CHAR(1)
--    process_status_date     TIMESTAMP 
--    sql_error_code          CHAR(5)
--    rec_read                INTEGER 
--    rec_valid               INTEGER 
--    rec_load                INTEGER 
--    rec_insert              INTEGER
--    rec_merge               INTEGER
--    rec_select              INTEGER 
--    rec_update              INTEGER 
--    rec_delete              INTEGER
--    process_run_id          VARCHAR(50) 
--    process_message         VARCHAR(254)
--    process_message_err     VARCHAR(254)

vrow_osd                       omega_std_debug%ROWTYPE; 
--    insert_date             TIMESTAMP,
--    process_name            VARCHAR(50)
--    module_name             VARCHAR(50)
--    error_code              VARCHAR(10)
--    error_message           VARCHAR(200) 
--    parameters              VARCHAR(200)
--    insert_by               VARCHAR(50)

v_num_rows                     INTEGER;

v_debug                        INTEGER      = 0;  -- 0 = Off  1 = On
    
BEGIN 
--    RAISE NOTICE 'v_debug: %', v_debug;

    vrow_osd.process_name      = 'Unit Test';
    vrow_osd.module_name       = '<funcName>'; 
    vrow_osd.parameters        = NULL;

    vrow_opl.batch_id          = NULL;
    vrow_opl.process_id        = <process_id>; 
    vrow_opl.process_status    = NULL; 
    vrow_opl.process_step      = 0;
    vrow_opl.process_start     = NOW(); 
    vrow_opl.process_message   = NULL;
    
    v_rec_id                   = NULL;
    v_rec_uuid                 = NULL;
    v_num_rows                 = NULL;
    v_process_start            = NOW(); 

    SELECT uuid_generate_v4() INTO v_rec_uuid;

    SELECT pg_version_num()   INTO v_pg_version; 
    
    IF v_debug > 0 THEN 
        RAISE NOTICE 'pg_version:   %', v_pg_version; 
        RAISE NOTICE 'process_step: %', vrow_opl.process_step; 
    END IF; 
    
    IF (TG_OP='INSERT') THEN 
        
        vrow_opl.process_step = 10;

        IF v_debug > 0 THEN 
            RAISE NOTICE 'process_step: %', vrow_opl.process_step;
        END IF; 
    
        INSERT INTO <funcName>_audit 
            (rec_id, cmd, update_date, update_by) --, o_<funcName>_nm)  
        SELECT NEW.rec_id, 'I', NOW(), USER;      --, OLD.<funcName>_nm;
    
        IF FOUND THEN 
            GET DIAGNOSTICS v_num_rows = ROW_COUNT;
            RAISE NOTICE 'Number of rows effected is: %', v_num_rows;
        END IF;
        
        UPDATE omega_process_log 
        SET    rec_read            = v_rec_id,
               process_status_date = NOW()
        WHERE  rec_uuid = v_rec_uuid; 
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO <funcName>_audit 
            (rec_id, cmd, update_date, update_by, n_<funcName>_nm, o_<funcName>_nm)  
        SELECT NEW.rec_id, 'U', NOW(), USER, NEW.<funcName>_nm, OLD.<funcName>_nm;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO <funcName>_audit 
            (rec_id, cmd, update_date, update_by, o_<funcName>_nm)  
        SELECT OLD.rec_id, 'D', NOW(), USER, OLD.<funcName>_nm;
    
    END IF;

    
    
    vrow_opl.process_step = 999;

    IF v_debug > 0 THEN 
        RAISE NOTICE 'process_step: %', vrow_opl.process_step;
        RAISE NOTICE 'v_rec_uuid: %', v_rec_uuid;
    END IF; 
    
    RETURN NULL;
    
EXCEPTION
    WHEN others THEN 
        RAISE NOTICE 'EXCEPTION';
        
	IF v_pg_version >= 90200 THEN 
            GET STACKED DIAGNOSTICS vrow_osd.error_code    = RETURNED_SQLSTATE;
	    GET STACKED DIAGNOSTICS vrow_osd.error_message = MESSAGE_TEXT;
	ELSE 
            vrow_osd.error_code    = 'Not supported';
            vrow_osd.error_message = 'Not supported';
        END IF; 
        
        SELECT f_omega_std_debug (
            NOW(), 
            CAST(vrow_osd.module_name   AS CHAR(50)),  
            CAST(vrow_opl.process_id    AS CHAR(50)),
            CAST(vrow_osd.error_code    AS CHAR(10)),  
            CAST(vrow_osd.error_message AS CHAR(200)), 
            CAST(vrow_osd.parameters    AS CHAR(200)),
            USER
            ) INTO f_return;
        
        RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION f_<funcName>() 
IS 'f_<funcName>() - This function <description>';


ALTER FUNCTION f_<funcName>() 
    OWNER TO enterprisedb; 
    

