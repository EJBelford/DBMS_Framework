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

CREATE OR REPLACE FUNCTION fn_pfsawh_get_item_dim_field 
    (
    v_item_id IN pfsawh_item_dim.item_id%TYPE, 
    v_item    VARCHAR2  
    ) 
    RETURN VARCHAR2 

IS

-- Exception handling variables (ps_) 

ps_exception                 std_pfsa_debug_tbl%ROWTYPE; 

CURSOR rec_cur (item_id_cursor NUMBER) 
    IS 
    SELECT * 
    FROM   pfsawh_item_dim 
    WHERE  item_id = item_id_cursor; 

BEGIN 

    ps_exception.ps_procedure := 'fn_pfsawh_get_item_dim_field'; 
    ps_exception.ps_location  := 'get_item'; 
    ps_exception.ps_id_key    := 'Item rec # not found: ' || v_item_id;

    FOR i IN rec_cur(v_item_id) LOOP 
        
        CASE UPPER(v_item) 
            WHEN 'NIIN'                            THEN RETURN i.niin; 
            WHEN 'LIN'                             THEN RETURN i.lin; 
            WHEN 'ARMY_TYPE_DESIGNATOR'            THEN RETURN i.army_type_designator; 
            WHEN 'FSC'                             THEN RETURN i.fsc; 
            WHEN 'NSN'                             THEN RETURN i.nsn; 
            WHEN 'ITEM_NOMEN_SHORT'                THEN RETURN i.item_nomen_short; 
            WHEN 'ITEM_NOMEN_LONG'                 THEN RETURN i.item_nomen_long; 
            WHEN 'MAT_CAT_CD_4_5_CODE'             THEN RETURN i.mat_cat_cd_4_5_code; 
            ELSE RETURN 'Field name not found... ';
        END CASE;
        
    END LOOP; 
    
    FOR i IN rec_cur(0) LOOP 
            
        RETURN i.niin; 
                
    END LOOP; 
            
END fn_pfsawh_get_item_dim_field; 

/* 

SELECT fn_pfsawh_get_item_dim_field(1, 'NIIN') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_field(141155, '') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_field(141155, 'NIIN') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_field(141155, 'LIN') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_field(141155, 'ARMY_TYPE_DESIGNATOR') FROM dual; 

SELECT fn_pfsawh_get_item_dim_field(141155, 'FSC' ) FROM dual;

SELECT fn_pfsawh_get_item_dim_field(141155, 'NSN' ) FROM dual;

SELECT fn_pfsawh_get_item_dim_field(141155, 'ITEM_NOMEN_SHORT') FROM dual;

SELECT fn_pfsawh_get_item_dim_field(141155, 'ITEM_NOMEN_LONG' ) FROM dual;

SELECT fn_pfsawh_get_item_dim_field(141155, 'MAT_CAT_CD_4_5_CODE' ) FROM dual;
    
*/ 