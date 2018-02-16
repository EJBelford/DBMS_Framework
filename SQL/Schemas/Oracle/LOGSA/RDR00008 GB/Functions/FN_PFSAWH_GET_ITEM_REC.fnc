/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

 PARAMETERS: 

      INPUT:  item_id 

     OUTPUT:  item record 

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date       ECP #         Author             Description
----------   ------------  -----------------  ---------------------------------
14FEB07                    Gene Belford       Function Created 

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_pfsawh_get_item_dim_rec 
    (
    v_item_id IN gb_pfsawh_item_dim.item_id%TYPE 
    ) 
    RETURN gb_pfsawh_item_dim%ROWTYPE 

IS

dim_no_data gb_pfsawh_item_dim%ROWTYPE;

CURSOR rec_cur (item_id_cursor NUMBER) 
    IS 
    SELECT * 
    FROM   gb_pfsawh_item_dim 
    WHERE  item_id = item_id_cursor; 

BEGIN 

    dim_no_data.rec_id           := 0; 
    dim_no_data.item_id          := 0; 
    dim_no_data.niin             := '000000000'; 
    dim_no_data.item_nomen_short := 'Item not found.'; 

    FOR i IN rec_cur(v_item_id) LOOP 
    
        RETURN i; 
        
    END LOOP; 
    
    EXCEPTION
        WHEN no_data_found THEN
            RETURN dim_no_data; 
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END fn_pfsawh_get_item_dim_rec; 
