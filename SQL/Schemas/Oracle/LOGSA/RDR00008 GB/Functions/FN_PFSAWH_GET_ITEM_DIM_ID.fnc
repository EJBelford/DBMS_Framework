/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

 PARAMETERS: 

      INPUT:    

     OUTPUT:  item_id 

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date       ECP #         Author             Description
----------   ------------  -----------------  ---------------------------------
14FEB07                    Gene Belford       Function Created 

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_pfsawh_get_item_dim_id 
    (
    v_item    VARCHAR2  
    ) 
    RETURN NUMBER 

IS

-- Exception handling variables (ps_) 

ps_exception                 std_pfsa_debug_tbl%ROWTYPE; 

s0_userLoginId                   pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_item_id                    NUMBER; 

/*CURSOR rec_cur (niin_cursor NUMBER) 
    IS 
    SELECT * 
    FROM   pfsawh_item_dim 
    WHERE  niin = niin_cursor;*/ 

BEGIN 

    ps_exception.ps_procedure := 'fn_pfsawh_get_item_dim_id'; 
    ps_exception.ps_location  := 'get_itm_id'; 
    ps_exception.ps_id_key    := 'Item not found: ' || v_item;

    SELECT NVL(item_id, 0) 
    INTO   v_item_id 
    FROM   pfsawh_item_dim 
    WHERE  niin = v_item; 
    
    RETURN v_item_id; 
            
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ps_exception.ps_oerr   := sqlcode;
            ps_exception.ps_msg    := sqlerrm;
            ps_exception.ps_id_key := '';

/*            INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
            VALUES 
                (
                ps_exception.ps_procedure, ps_exception.ps_oerr, 
                ps_exception.ps_location, s0_userLoginId, 
                ps_exception.ps_id_key, ps_exception.ps_msg, sysdate
                ); */ 
            
            RETURN 0; 
            
END fn_pfsawh_get_item_dim_id; 

/* 

SELECT fn_pfsawh_get_item_dim_field(141155, 'NIIN') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_id('010883669') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_id('000000000') FROM dual; 
    
SELECT fn_pfsawh_get_item_dim_id('0000error') FROM dual; 
    
*/ 