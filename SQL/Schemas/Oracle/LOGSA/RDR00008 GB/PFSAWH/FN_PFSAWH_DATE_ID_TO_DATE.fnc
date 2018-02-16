/********************************* TEAM ITSS ***********************************

         NAME: fn_date_id_to_date 
      PURPOSE: Convert date_id to date without using date_dim. 

   CREATED BY: Gene Belford 
 CREATED DATE: 10 April 2008 

   PARAMETERS: 

        INPUT: date_id 

       OUTPUT: 'DD-MON-YYYY'' 

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
10APR08   RDR00008      Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_date_id_to_date 
    (
    v_date_id  IN NUMBER  
    ) 
    RETURN DATE 

IS

v_date DATE;

BEGIN

    v_date := TO_DATE('01-JAN-1900'); 
    
    v_date := TO_CHAR(TO_DATE('01-JAN-1950') + (v_date_id - 10001), 'DD-MON-YYYY');
    
    RETURN v_date;
    
    EXCEPTION
        WHEN no_data_found THEN
            NULL;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_date_id_to_date; 

/*

SELECT * 
FROM date_dim 
WHERE date_dim_id IN (0, 10001, 28262, 31822);  

SELECT fn_date_id_to_date(10001) FROM dual;

SELECT TO_CHAR(TO_DATE('01-JAN-1950') + 0, 'DD-MON-YYYY') FROM dual;  

SELECT fn_date_id_to_date(28262) FROM dual;

SELECT TO_CHAR(TO_DATE('01-JAN-1950') + 18262, 'DD-MON-YYYY') FROM dual;  

SELECT fn_date_id_to_date(31822) FROM dual;

SELECT TO_CHAR(TO_DATE('01-JAN-1950') + 21822, 'DD-MON-YYYY') FROM dual;  

*/