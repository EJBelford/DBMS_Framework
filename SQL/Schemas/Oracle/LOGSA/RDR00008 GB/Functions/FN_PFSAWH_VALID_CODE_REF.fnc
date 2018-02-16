CREATE OR REPLACE FUNCTION fn_pfsawh_vaild_code_ref
    (
    v_cat_code  IN pfsawh_code_ref.cat_code%TYPE, 
    v_item_code IN pfsawh_code_ref.item_code%TYPE 
    ) 
    RETURN pfsawh_code_ref.item_code%TYPE 
     
IS 

-- Exception handling variables (ps_)

ps_procedure_name        VARCHAR2(30)  := 'fn_pfsawh_vaild_code_ref';
ps_location              VARCHAR2(30)  := 'Begin'; 
ps_oerr                  VARCHAR2(6)   := NULL;
ps_msg                   VARCHAR2(200) := NULL;
ps_id_key                VARCHAR2(200) := 'fn_pfsawh_vaild_code_ref';
                                                      
-- Process status variables (s0_ & s1_)

s0_userLoginId           VARCHAR2(30)  := USER;

-- module variables (v_)

v_result                 NUMBER;

BEGIN

    SELECT  c.item_code
    INTO    v_result 
    FROM    pfsawh_code_ref c
    WHERE   c.cat_code = v_cat_code 
            AND c.item_code = v_item_code;
            
    RETURN (v_result); 
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN ('-1'); 
    
        WHEN OTHERS THEN
		    ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := 'gb_pfsawh_code_ref';
            
		     INSERT 
            INTO    std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, 
                called_by, ps_id_key, ps_msg, msg_dt
                )
		     VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, 
                s0_userLoginId, ps_id_key, ps_msg, sysdate
                );
               
    RETURN ('-2');
    
END fn_pfsawh_vaild_code_ref;
/
