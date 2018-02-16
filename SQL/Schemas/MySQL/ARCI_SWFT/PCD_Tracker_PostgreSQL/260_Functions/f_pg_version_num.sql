-- DROP FUNCTION IF EXISTS pcd_tracker.f_pg_version_num();

CREATE OR REPLACE FUNCTION pcd_tracker.f_pg_version_num() 
    RETURNS INT
    
AS 
    
$BODY$ 
    
/* Source File: f_pg_version_num.sql                                          */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_pg_version_num()                                            */
/*      Author: Gene Belford                                                  */
/* Description: This function returns the version of PostgreSQL installed     */
/*              as an integer value.  This allows the developer program for   */
/*              featurse not available in the current installed version, but  */
/*              are available newer releases.                                 */
/*              This function was adapted from the following discusion thread */
/* http://postgresql.1045698.n5.nabble.com/Version-Number-Function-td1992392.html */
/*        Date: 2014-01-20                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2014-01-20             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

SELECT pcd_tracker.f_pg_version_num();

SELECT pg_sleep (1.1); 

*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

DECLARE 

f_return                       INTEGER; 

v_null                         INTEGER      = NULL; 

v_rec_id                       INTEGER;
v_rec_uuid                     UUID;
v_process_start                TIMESTAMP    WITH TIME ZONE;

--vrow_opl                       omega_process_log%ROWTYPE; 

--vrow_osd                       omega_std_debug%ROWTYPE; 
--    insert_date     TIMESTAMP      WITH TIME ZONE,
--    process_name    VARCHAR(50)
--    module_name     VARCHAR(50)
--    error_code      VARCHAR(10)
--    error_message   VARCHAR(200) 
--    parameters      VARCHAR(200)
--    insert_by       VARCHAR(50)

v_num_rows                     INTEGER;

v_debug                        INTEGER      = 0;  -- 0 = Off  1 = On
    
BEGIN 
--    RAISE NOTICE 'v_debug: %', v_debug;

    v_process_start            = CLOCK_TIMESTAMP();

--     vrow_osd.process_name      = 'Unit Test';
--     vrow_osd.module_name       = 'f_pg_version_num'; 
--     vrow_osd.parameters        = NULL;
-- 
--     vrow_opl.batch_id          = NULL;
--     vrow_opl.process_id        = 2; 
--     vrow_opl.process_status    = NULL; 
--     vrow_opl.process_step      = 0;
--     vrow_opl.process_start     = v_process_start; 
--     vrow_opl.process_message   = NULL;
    
    v_rec_id                   = NULL;
    v_rec_uuid                 = NULL;
    v_num_rows                 = NULL;

    IF v_debug > 0 THEN 
        RAISE NOTICE 'process_step: %', vrow_opl.process_step; 
    END IF; 
    
    SELECT 
        10000 * 
        CAST(SUBSTRING(VERSION() 
            FROM '^PostgreSQL +([0-9]+)[.][0-9]+[.][0-9]') AS INT) 
        + 
        100 * 
        CAST(SUBSTRING(VERSION() 
            FROM '^PostgreSQL +[0-9]+[.]([0-9]+)[.][0-9]') AS INT) 
        + 
        CAST(SUBSTRING(VERSION() 
            FROM '^PostgreSQL +[0-9]+[.][0-9]+[.]([0-9])') AS INT) INTO f_return; 

    RETURN f_return;
                
EXCEPTION
    WHEN others THEN 
        RAISE NOTICE 'EXCEPTION';
        
--         GET STACKED DIAGNOSTICS vrow_osd.error_code    = RETURNED_SQLSTATE;
--         GET STACKED DIAGNOSTICS vrow_osd.error_message = MESSAGE_TEXT;
--         
--         SELECT f_omega_std_debug (
--             v_process_start, 
--             vrow_osd.module_name,  
--             vrow_opl.process_id,
--             vrow_osd.error_code,  
--             vrow_osd.error_message, 
--             vrow_osd.parameters,
--             USER
--             ) INTO f_return;  
        
        RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION pcd_tracker.f_pg_version_num() 
IS 'f_pg_version_num() - This function returns the version of PostgreSQL installed as an integer value.  This allows the developer program for featurse not available in the current installed version, but are available newer releases.';


ALTER FUNCTION pcd_tracker.f_pg_version_num() 
    OWNER TO postgres; 
    
