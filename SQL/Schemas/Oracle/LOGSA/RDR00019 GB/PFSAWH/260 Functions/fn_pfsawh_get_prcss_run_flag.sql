/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

 PARAMETERS: v_process_control_name  

      INPUT: Name of the PFSAWH process about to be run.  

     OUTPUT: The status field for that record from the PFSAWH_PROCESS_REF 

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ----------------------------------
03NOV08                                    Function Created 

*********************************** TEAM ITSS *********************************/

/*----- Test script -----*/

/*

BEGIN

    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_FLAG(1)); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_FLAG('')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_FLAG('x')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_FLAG('v_keep_n_days_of_debug')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_FLAG('v_keep_n_days_of_log')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_FLAG('etl_pfsawh_world')); 
    
END;

*/

CREATE OR REPLACE FUNCTION fn_pfsawh_get_prcss_run_flag  
    (
    v_process_control_name IN pfsawh_process_control.process_control_name%TYPE
    )
RETURN VARCHAR2 

IS

tmpvar VARCHAR2(1);

BEGIN

    tmpvar := NULL;
    
    SELECT status 
    INTO   tmpvar
    FROM   pfsawh_process_ref 
    WHERE  UPPER(process_description) = UPPER(v_process_control_name) 
        AND active_flag = 'Y' 
        AND sysdate BETWEEN active_date AND inactive_date; 

    RETURN NVL(tmpvar, 'E');
    
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 'E';
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_pfsawh_get_prcss_run_flag; 
/
