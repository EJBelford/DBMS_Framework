CREATE OR REPLACE FUNCTION fn_cbmwh_get_prcss_run_id  

RETURN NUMBER 

IS

/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

 PARAMETERS: v_process_control_name  

      INPUT: Name of the CBMWH process about to be run.  

     OUTPUT: The status field for that record from the CBMWH_PROCESS_REF 

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ----------------------------------
03NOV08                                    Function Created 
12JAN08                                    Copied from fn_pfsawh_get_prcss_run_id 

*********************************** TEAM ITSS *********************************/

/*----- Test script -----*/

/*

BEGIN

    dbms_output.put_line(FN_PFSAWH_GET_PRCSS_RUN_ID); 
    
END;

*/

tmpvar NUMBER;

BEGIN

    tmpvar := NULL;
    
    SELECT MAX(process_key) 
    INTO   tmpvar
    FROM   cbmwh_process_log 
    WHERE  process_recid = 5 
        AND process_end_date IS NULL; 

    RETURN NVL(tmpvar, -1);
    
    EXCEPTION
        WHEN no_data_found THEN
            RETURN -2;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_cbmwh_get_prcss_run_id; 
/
