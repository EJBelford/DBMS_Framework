-- DROP FUNCTION IF EXISTS f_<funcName>();

CREATE OR REPLACE FUNCTION f_<funcName>() 
    RETURNS INT 

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

DELETE FROM omega_process_ref;

SELECT  f_<funcName>(); 

SELECT tn.* 
FROM <tableName> tn 
ORDER BY tn.rec_id;

SELECT * FROM omega_process_log ORDER BY process_start DESC;

SELECT * FROM omega_std_debug ORDER BY insert_date DESC;

SELECT * FROM omega_func_warn_log ORDER BY warning_status, warning_timestamp DESC;

*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DECLARE 

f_return                       INTEGER; 
v_return                       INTEGER; 

v_null                         INTEGER      = NULL; 

v_rec_id                       INTEGER;
v_pg_version                   INTEGER; 
v_process_start                TIMESTAMP    WITH TIME ZONE;

v_uuid	                       UUID;
v_insert_str                   VARCHAR(200) = NULL;

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

v_debug                        INTEGER = 1;  -- 0 = Off  1 = On

BEGIN 
--    RAISE NOTICE 'v_debug: %', v_debug;

    vrow_osd.process_name      = 'Unit Test';
    vrow_osd.module_name       = 'f_<funcName>'; 
    vrow_osd.parameters        = NULL;

    vrow_opl.batch_id          = NULL;
    vrow_opl.process_id        = <processId>; 
    vrow_opl.process_status    = NULL; 
    vrow_opl.process_step      = 0;
    vrow_opl.process_start     = NOW(); 
    vrow_opl.process_message   = NULL;
    
    v_rec_id                   = NULL;
    v_num_rows                 = NULL;
    v_process_start            = NOW(); 

    SELECT pg_version_num() INTO v_pg_version; 
    
    SELECT f_omega_process_log_updt('S', NULL, NULL, <processId>, NULL, NULL, NULL, NULL, NULL, NULL) INTO v_return;

    IF v_debug > 0 THEN 
        RAISE NOTICE 'process_step: %', vrow_opl.process_step; 
        RAISE NOTICE 'pg_version:   %', v_pg_version; 
    END IF; 
    
    BEGIN
        vrow_opl.process_step = vrow_opl.process_step + 1;
        v_insert_str = 'Select One...';
        
        INSERT 
        INTO omega_process_ref (
            rec_uuid, process_id, process_name, 
            process_run_ctrl, process_run_ctrl_override, active_flag, status
            )
        VALUES (
            uuid_generate_v4(), -1, v_insert_str, -1, FALSE, TRUE, 'C'
            );

        vrow_opl.rec_insert = COALESCE(vrow_opl.rec_insert, 0) + 1;
            
        SELECT rec_uuid 
        INTO v_uuid 
        FROM omega_process_ref
        WHERE process_name = v_insert_str;

/*---  ---*/

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

        vrow_osd.parameters = v_insert_str;
        
        SELECT f_omega_std_debug (
            NOW(), 
            CAST(vrow_osd.module_name   AS CHAR(50)),  
            CAST(vrow_opl.process_id    AS CHAR(50)),
            CAST(vrow_osd.error_code    AS CHAR(10)),  
            CAST(vrow_osd.error_message AS CHAR(200)), 
            CAST(vrow_osd.parameters    AS CHAR(200)),
            USER
            ) INTO f_return;
    END;
    
/*---*/  
/* Undefined */
/*---*/
    
    BEGIN
        vrow_opl.process_step = vrow_opl.process_step + 1;
        v_insert_str = 'Undefined';
        
        INSERT 
        INTO omega_process_ref (
            rec_uuid, process_id, process_name, 
            process_run_ctrl, process_run_ctrl_override, active_flag, status
            )
         VALUES (
            uuid_generate_v4(), 0, v_insert_str, 0, FALSE, TRUE, 'C'
            );

        vrow_opl.rec_insert = COALESCE(vrow_opl.rec_insert, 0) + 1;
            
        SELECT rec_uuid 
        INTO v_uuid 
        FROM omega_process_ref
        WHERE sys_dict_nm = v_insert_str;

/*---  ---*/

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
        
        vrow_osd.parameters = v_insert_str;
        
        SELECT f_omega_std_debug (
            NOW(), 
            CAST(vrow_osd.module_name   AS CHAR(50)),  
            CAST(vrow_opl.process_id    AS CHAR(50)),
            CAST(vrow_osd.error_code    AS CHAR(10)),  
            CAST(vrow_osd.error_message AS CHAR(200)), 
            CAST(vrow_osd.parameters    AS CHAR(200)),
            USER
            ) INTO f_return;
    END;
    
    SELECT f_omega_process_log_updt(
        'E', NULL, v_return, <processId>, NULL, NULL, 
        NULL, NULL, NULL, 
        vrow_opl.rec_insert
        ) INTO v_return;

    RETURN 0;
    
END; 

$BODY$ 
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION f_omega_process_ref_ld() 
IS 'f_omega_process_ref_ld - This function f_omega_process_ref_ld loads all the enumeration values into the omega_process_ref reference table.';


/*----------------------------------------------------------------------------*/  
/*----------------------------------------------------------------------------*/  

