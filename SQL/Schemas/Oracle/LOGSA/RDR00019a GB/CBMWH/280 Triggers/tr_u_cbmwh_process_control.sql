/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--        NAME:    tr_u_cbmwh_process_control 
--
--     PURPOSE:    To perform work as each row is updated. process_control
-- 
--      SOURCE:    TR_U_CBMWH_PROCESS_CONTROL.sql 
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
-- 18JAN2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_u_cbmwh_process_control
BEFORE UPDATE
ON     cbmwh_process_control
FOR EACH ROW
DECLARE

-- Exception handling variables (ps_)

ps_procedure_name                std_cbmwh_debug_tbl.ps_procedure%TYPE  
    := 'tr_u_cbmwh_process_control';  /*  */
ps_location                      std_cbmwh_debug_tbl.ps_location%TYPE  
    := 'Begin';                /*  */
ps_oerr                          std_cbmwh_debug_tbl.ps_oerr%TYPE   
    := null;                   /*  */
ps_msg                           std_cbmwh_debug_tbl.ps_msg%TYPE 
    := null;                   /*  */
ps_id_key                        std_cbmwh_debug_tbl.ps_id_key%TYPE 
    := 'tr_u_cbmwh_process_control';  /*  */
    -- coder responsible for identying key for debug

-- module variables (v_)

v_update_date cbmwh_process_control.update_date%TYPE  := sysdate;
v_update_by   cbmwh_process_control.update_by%TYPE    := user;

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
                ps_id_key, ps_msg, sysdate);

--        RAISE;
       
END tr_u_cbmwh_process_control;
