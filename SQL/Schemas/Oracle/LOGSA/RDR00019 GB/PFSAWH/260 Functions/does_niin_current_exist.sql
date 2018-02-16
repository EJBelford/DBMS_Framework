CREATE OR REPLACE FUNCTION does_niin_current_exist 
    (
    v_niin      IN pfsawh_item_dim.niin%TYPE 
    ) 
    RETURN BOOLEAN 

IS

/********************************* TEAM ITSS ***********************************

         NAME: does_niin_current_exist 
      PURPOSE: Tells if the niin is in the pfsawh_item_dim table. . 

   CREATED BY: Gene Belford 
 CREATED DATE: 17 December 2008 

   PARAMETERS: 

        INPUT: niin 

       OUTPUT: true or false

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
17DEC08                 Gene Belford       Function Created 

*********************************** TEAM ITSS *********************************/

/*----- Test -----*/

/* 

BEGIN 

    IF does_niin_current_exist('014508126') THEN 
        dbms_output.put_line('true'); 
    ELSE
        dbms_output.put_line('false'); 
    END IF; 

    IF does_niin_current_exist('0') THEN 
        dbms_output.put_line('true'); 
    ELSE
        dbms_output.put_line('false'); 
    END IF; 

END;

*/ 

l_dummy                          NUMBER;
l_any_exist                      BOOLEAN; 

CURSOR any_exist_cur 
IS 
    SELECT 1 rec_id 
    FROM   pfsawh_item_dim 
    WHERE  niin = v_niin 
        AND status = 'C'; 

BEGIN

    OPEN any_exist_cur; 
    
    FETCH any_exist_cur 
    INTO  l_dummy; 
    
    l_any_exist := any_exist_cur%FOUND;
    
    RETURN l_any_exist;
    
END does_niin_current_exist ; 
