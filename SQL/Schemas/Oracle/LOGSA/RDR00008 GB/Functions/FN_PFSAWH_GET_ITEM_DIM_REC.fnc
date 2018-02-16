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
    v_item_id IN pfsawh_item_dim.item_id%TYPE 
    ) 
    RETURN pfsawh_item_dim%ROWTYPE 

IS

-- Exception handling variables (ps_) 

ps_exception                 std_pfsa_debug_tbl%ROWTYPE; 

CURSOR rec_cur (item_id_cursor NUMBER) 
    IS 
    SELECT * 
    FROM   pfsawh_item_dim 
    WHERE  item_id = item_id_cursor; 

BEGIN 

    ps_exception.ps_procedure := 'fn_pfsawh_get_item_dim_rec'; 
    ps_exception.ps_location  := 'get_item'; 
    ps_exception.ps_id_key    := 'Item rec # not found: ' || v_item_id;

    FOR i IN rec_cur(v_item_id) LOOP 
    
        RETURN i; 
        
    END LOOP; 
    
    ps_exception.ps_oerr   := sqlcode;
    ps_exception.ps_msg    := sqlerrm;

    INSERT 
    INTO std_pfsa_debug_tbl 
        (
        ps_procedure, ps_oerr, 
        ps_location,  called_by, 
        ps_id_key,    ps_msg, 
        msg_dt
        )
    VALUES 
        (
        ps_exception.ps_procedure, ps_exception.ps_oerr, 
        ps_exception.ps_location,  user, 
        ps_exception.ps_id_key,    ps_exception.ps_msg, 
        sysdate
        );
                
    COMMIT;     
                
    FOR i IN rec_cur(0) LOOP 
            
        RETURN i; 
                
    END LOOP; 
            
    EXCEPTION
        WHEN no_data_found THEN 
            ps_exception.ps_oerr   := sqlcode;
            ps_exception.ps_msg    := sqlerrm;
            ps_exception.ps_id_key := '';

            INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, 
                ps_location,  called_by, 
                ps_id_key,    ps_msg, 
                msg_dt
                )
            VALUES 
                (
                ps_exception.ps_procedure, ps_exception.ps_oerr, 
                ps_exception.ps_location,  user, 
                ps_exception.ps_id_key,    ps_exception.ps_msg, 
                sysdate
                );
                
            COMMIT;     
                
            FOR i IN rec_cur(0) LOOP 
            
                RETURN i; 
                
            END LOOP; 
            
        WHEN others THEN
        
            ps_exception.ps_oerr   := sqlcode;
            ps_exception.ps_msg    := sqlerrm;
            ps_exception.ps_id_key := '';

            INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, 
                ps_location,  called_by, 
                ps_id_key,    ps_msg, 
                msg_dt
                )
            VALUES 
                (
                ps_exception.ps_procedure, ps_exception.ps_oerr, 
                ps_exception.ps_location,  user, 
                ps_exception.ps_id_key,    ps_exception.ps_msg, 
                sysdate
                );
                
            COMMIT;     
                
            FOR i IN rec_cur(0) LOOP 
            
                RETURN i; 
                
            END LOOP; 
            
--            RAISE;  
        
END fn_pfsawh_get_item_dim_rec; 

/* 

DECLARE 

    dim_row pfsawh_item_dim%ROWTYPE; 

BEGIN 

    dim_row := fn_pfsawh_get_item_dim_rec(1); 
    
    dbms_output.put_line( dim_row.item_id || ' - ' || dim_row.niin ); 
    
    dim_row := fn_pfsawh_get_item_dim_rec(141155); 
    
    dbms_output.put_line( dim_row.item_id || ' - ' || dim_row.niin ); 
    
END; 
    
*/ 