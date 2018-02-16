CREATE OR REPLACE FUNCTION FN_PFSAWH_GET_PRCSS_CNTRL_VAL 
    (
    v_process_control_name IN GB_PFSAWH_PROCESS_CONTROL.process_control_name%TYPE
    )
RETURN NUMBER 

IS

/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

 PARAMETERS:

      INPUT:

     OUTPUT:

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date      ECP #         Author             Description
---------   ------------  -----------------  ----------------------------------
02JAN2007                                    Function Created

*********************************** TEAM ITSS *********************************/

tmpvar NUMBER;

BEGIN

    tmpvar := NULL;
    
    SELECT process_control_value 
    INTO   tmpvar
    FROM   GB_PFSAWH_PROCESS_CONTROL 
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
        
END FN_PFSAWH_GET_PRCSS_CNTRL_VAL; 

/*----- Test script -----*/

/*

BEGIN

    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_CNTRL_VAL(1)); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_CNTRL_VAL('')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_CNTRL_VAL('x')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_CNTRL_VAL('v_keep_n_days_of_debug')); 
    
    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_CNTRL_VAL('v_keep_n_days_of_log')); 
    
END;

*/