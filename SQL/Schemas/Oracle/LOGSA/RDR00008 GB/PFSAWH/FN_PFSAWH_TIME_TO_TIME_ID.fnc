/********************************* TEAM ITSS ***********************************

         NAME: fn_time_to_time_id 
      PURPOSE: Convert 00:00:00 time to time_id without using time_dim. 

   CREATED BY: Gene Belford 
 CREATED DATE: 14 April 2008 

   PARAMETERS: 

        INPUT: 'HH24:MI:SS' 

       OUTPUT: ##### 

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
14APR08   RDR00008      Gene Belford       Function Created 

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_time_to_time_id  
    (
    v_time  IN DATE 
    ) 
    RETURN NUMBER 

IS

time_id NUMBER;

BEGIN

    time_id := 0;  
    
    time_id := (TO_CHAR(v_time, 'HH24')*3600) 
             + (TO_CHAR(v_time, 'MI')  *60) 
             +  TO_CHAR(v_time, 'SS')
             +  10001; 
    
    RETURN time_id;
    
    EXCEPTION
        WHEN no_data_found THEN
            NULL;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_time_to_time_id; 

/* 

SELECT * FROM time_dim WHERE full_time_desc_24hour = '00:00:00'; 

SELECT fn_time_to_time_id(TO_DATE('01-Jan-2008 00:00:00', 'dd-mon-yyyy hh24-mi-ss')) from dual; 

SELECT * FROM time_dim WHERE full_time_desc_24hour = '07:45:15'; 

SELECT (7*3600) + (45*60) + 15 + 10001 FROM dual; 

SELECT fn_time_to_time_id(TO_DATE('01-Jan-2008 07:45:15', 'dd-mon-yyyy hh24-mi-ss')) from dual; 

SELECT * FROM time_dim WHERE full_time_desc_24hour = '23:59:59'; 

SELECT fn_time_to_time_id(TO_DATE('01-Jan-2008 23:59:59', 'dd-mon-yyyy hh24-mi-ss')) from dual; 

SELECT (23*3600) + (59*60) + 59 + 10001 FROM dual; 

*/ 