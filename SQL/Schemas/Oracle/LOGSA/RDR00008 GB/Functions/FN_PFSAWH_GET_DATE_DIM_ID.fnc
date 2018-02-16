/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

PARAMETERS::

      INPUT:

     OUTPUT:

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
03MAR07   RDR00008      Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_pfsawh_get_date_dim_id 
    (
    v_date  IN date_dim.oracle_date%TYPE  
    ) 
    RETURN NUMBER 

IS

v_tmpvar NUMBER;

BEGIN

    SELECT date_dim_id
    INTO   v_tmpvar 
    FROM   date_dim 
    WHERE  TO_DATE(TO_CHAR(NVL(v_date, '01-JAN-1950'), 'DD-MON-YYYY')) = TO_DATE(TO_CHAR(oracle_date, 'DD-MON-YYYY'));
    
    RETURN (v_tmpvar);
    
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 10000;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_pfsawh_get_date_dim_id; 

/* 

SELECT fn_pfsawh_get_date_dim_id('03-MAR-1900') FROM dual; 

SELECT fn_pfsawh_get_date_dim_id('03-MAR-2008') FROM dual; 

SELECT fn_pfsawh_get_date_dim_id('03-MAR-2900') FROM dual; 

*/  
