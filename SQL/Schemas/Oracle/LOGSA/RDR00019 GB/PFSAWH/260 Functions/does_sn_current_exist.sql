CREATE OR REPLACE FUNCTION does_sn_current_exist 
    (
    v_niin      IN pfsawh_item_sn_dim.item_niin%TYPE,
    v_sn        IN pfsawh_item_sn_dim.item_serial_number%TYPE 
    ) 
    RETURN BOOLEAN 

IS

/********************************* TEAM ITSS ***********************************

         NAME: does_sn_current_exist 
      PURPOSE: Tells if the niin is in the pfsawh_item_dim table. . 

   CREATED BY: Gene Belford 
 CREATED DATE: 17 December 2008 

   PARAMETERS: 

        INPUT: niin
               item_serial_number 

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
    FROM   pfsawh_item_sn_dim 
    WHERE  item_niin = v_niin 
        AND item_serial_number = v_sn 
        AND status = 'C'; 

BEGIN

    OPEN any_exist_cur; 
    
    FETCH any_exist_cur 
    INTO  l_dummy; 
    
    l_any_exist := any_exist_cur%FOUND;
    
    RETURN l_any_exist;
    
END does_sn_current_exist ; 
