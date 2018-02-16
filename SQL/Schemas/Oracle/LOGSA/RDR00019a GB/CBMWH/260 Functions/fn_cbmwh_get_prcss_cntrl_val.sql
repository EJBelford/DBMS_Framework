/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--            Name: fn_cbmwh_get_prcss_cntrl_val
--            Desc: Captures SQL processing information for debugging 
--                  and monitoring
--
--     Created By: Gene Belford
--   Created Date: 18 December 2007 
--
--          Source: pr_cbmwh_insupd_processlog.sql
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Parameters: 
--           Input:  
 -- 
--          Output:  
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 09JUN08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

CREATE OR REPLACE FUNCTION fn_cbmwh_get_prcss_cntrl_val  
    (
    v_process_control_name IN cbmwh_process_control.process_control_name%TYPE
    )
RETURN NUMBER 

IS

tmpvar NUMBER;

BEGIN

    tmpvar := NULL;
    
    SELECT process_control_value 
    INTO   tmpvar
    FROM   cbmwh_process_control 
    WHERE  process_control_name = v_process_control_name 
        AND status = 'C' 
        AND active_flag = 'Y' 
        AND sysdate BETWEEN active_date AND inactive_date; 

    RETURN NVL(tmpvar, -9999);
    
    EXCEPTION
        WHEN no_data_found THEN
            RETURN -9999;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_cbmwh_get_prcss_cntrl_val ; 

/*----- Test script -----*/

/*

BEGIN

    dbms_output.put_line(fn_cbmwh_get_prcss_cntrl_val (1)); 
    
    dbms_output.put_line(fn_cbmwh_get_prcss_cntrl_val ('')); 
    
    dbms_output.put_line(fn_cbmwh_get_prcss_cntrl_val ('x')); 
    
    dbms_output.put_line(fn_cbmwh_get_prcss_cntrl_val ('v_keep_n_days_of_debug')); 
    
    dbms_output.put_line(fn_cbmwh_get_prcss_cntrl_val ('v_keep_n_days_of_log')); 
    
END;

*/