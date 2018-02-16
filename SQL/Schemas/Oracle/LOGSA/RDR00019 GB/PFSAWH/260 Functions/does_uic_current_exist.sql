CREATE OR REPLACE FUNCTION does_uic_current_exist 
    (
    v_uic      IN pfsawh_force_unit_dim.uic%TYPE 
    ) 
    RETURN BOOLEAN 

IS

/********************************* TEAM ITSS ***********************************

         NAME: does_uic_current_exist 
      PURPOSE: Tells if the uic is in the pfsawh_force_unit_dim table. . 

   CREATED BY: Gene Belford 
 CREATED DATE: 17 December 2008 

   PARAMETERS: 

        INPUT: uic 

       OUTPUT: true or false

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
17DEC08                 Gene Belford       Function Created 

*********************************** TEAM ITSS *********************************/

l_dummy                          NUMBER;
l_any_exist                      BOOLEAN; 

CURSOR any_exist_cur 
IS 
    SELECT 1 rec_id 
    FROM   pfsawh_force_unit_dim 
    WHERE  uic = v_uic  
        AND status = 'C'; 

BEGIN

    OPEN any_exist_cur; 
    
    FETCH any_exist_cur 
    INTO  l_dummy; 
    
    l_any_exist := any_exist_cur%FOUND;
    
    RETURN l_any_exist;
    
END does_uic_current_exist ; 
