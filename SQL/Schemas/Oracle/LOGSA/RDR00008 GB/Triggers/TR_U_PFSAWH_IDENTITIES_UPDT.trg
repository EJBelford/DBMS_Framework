/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--        NAME:    tr_u_pfsawh_identities_updt
--
--     PURPOSE:    To perform work as each row is updated. 
-- 
--      SOURCE:    tr_u_pfsawh_identities_updt.trg
--   
-- ASSUMPTIONS:
--
-- LIMITATIONS:
--
--       NOTES:
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- 
-- Date       ECP #            Author           Description
-- ---------  ---------------  ---------------  --------------------------------
-- 01APR2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_u_pfsawh_identities_updt
BEFORE UPDATE
ON     pfsawh_identities
FOR EACH ROW
DECLARE

-- Exception handling variables (ps_) 

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'tr_u_pfsawh_identities_updt';  /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';                /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                   /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                   /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := 'tr_u_pfsawh_identities_updt';  /*  */
    -- coder responsible for identying key for debug

-- module variables (v_)

v_update_date pfsawh_identities.update_date%TYPE  := sysdate;
v_update_by   pfsawh_identities.update_by%TYPE    := user;

BEGIN
    
    :new.update_date := v_update_date;
    :new.update_by   := v_update_by;

    EXCEPTION
        WHEN no_data_found THEN
            NULL;
        WHEN others THEN
		    ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
		     INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
		     VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, user, 
                ps_id_key, ps_msg, sysdate);

--        RAISE;
       
END tr_u_pfsawh_identities_updt;
