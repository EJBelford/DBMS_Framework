/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--        NAME:    ttr_u_cbmwh_force_unit_dim
--
--     PURPOSE:    To perform work as each row is updated. 
-- 
--      SOURCE:    tr_u_pfsawh_force_updt.trg
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
-- 23JAN2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_u_cbmwh_force_unit_dim
BEFORE UPDATE
ON     cbmwh_force_unit_dim
FOR EACH ROW
DECLARE

-- Exception handling variables (ps_)

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'tr_u_cbmawh_force_unit_dim';  /*  */
ps_location                      std_cbmwh_debug_tbl.ps_location%TYPE  
    := 'Begin';                /*  */
ps_oerr                          std_cbmwh_debug_tbl.ps_oerr%TYPE   
    := null;                   /*  */
ps_msg                           std_cbmwh_debug_tbl.ps_msg%TYPE 
    := null;                   /*  */
ps_id_key                        std_cbmwh_debug_tbl.ps_id_key%TYPE 
    := 'tr_u_cbmwh_force_unit_dim';  /*  */
    -- coder responsible for identying key for debug

-- module variables (v_)

v_update_date cbmwh_force_unit_dim.update_date%TYPE  := sysdate;
v_update_by   cbmwh_force_unit_dim.update_by%TYPE    := user;

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
             INTO std_cbmwh_debug_tbl 
                 (
                 ps_procedure, ps_oerr, ps_location, called_by, 
                 ps_id_key, ps_msg, msg_dt
                 )
		     VALUES 
                 (
                 ps_procedure_name, ps_oerr, ps_location, user, 
                 ps_id_key, ps_msg, sysdate
                 );

--        RAISE;
       
END tr_u_cbmwh_force_unit_dim;