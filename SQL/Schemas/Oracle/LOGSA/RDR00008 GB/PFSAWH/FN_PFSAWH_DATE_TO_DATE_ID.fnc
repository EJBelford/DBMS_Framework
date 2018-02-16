/********************************* TEAM ITSS ***********************************

         NAME: fn_date_to_date_id 
      PURPOSE: Convert date to date_id without using date_dim. 

   CREATED BY: Gene Belford 
 CREATED DATE: 10 April 2008 

   PARAMETERS: 

        INPUT: 'DD-MON-YYYY''

       OUTPUT: date_id 'DD-MON-YYYY''

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
10APR08   RDR00008      Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_date_to_date_id 
    (
    v_date  DATE 
    ) 
    RETURN NUMBER 

IS

v_date_id NUMBER;

BEGIN

    v_date_id := 0; 
    
    v_date_id := (TO_DATE(v_date) - TO_DATE('01-Jan-1950')) + 10001;
    
    RETURN v_date_id;
    
    EXCEPTION
        WHEN no_data_found THEN
            NULL;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_date_to_date_id; 


/* 

SELECT fn_date_id_to_date(10001) FROM dual;

SELECT fn_date_to_date_id('01-Jan-1950') FROM dual;

SELECT fn_date_id_to_date(28263) FROM dual;

SELECT fn_date_to_date_id('01-Jan-2000') FROM dual;

SELECT fn_date_id_to_date(31823) FROM dual;

SELECT fn_date_to_date_id('30-Sep-2009') FROM dual;


*/ 
        