CREATE OR REPLACE TRIGGER tr_pfsawh_functional_warnings
--
-- This trigger is the base trigger for all PFSA world tables.  It sets the 
-- last update on insert/update and defaults to user for null updt_by 
--
--
--
BEFORE UPDATE OR INSERT ON pfsawh_functional_warnings
FOR EACH ROW

DECLARE

  ps_oerr                        std_pfsawh_debug_tbl.ps_oerr%TYPE   
      := null;
  ps_location                    std_pfsawh_debug_tbl.ps_location%TYPE   
      := 'BEGIN';
  ps_procedure_name              std_pfsawh_debug_tbl.ps_procedure%TYPE   
      := 'TR_PFSAWH_FUNCTIONAL_WARNINGS';
  ps_msg                         std_pfsawh_debug_tbl.ps_msg%TYPE  
      := 'Trigger_failed';
  ps_id_key                      std_pfsawh_debug_tbl.ps_id_key%TYPE  
      := null; -- set in cases

  fail_update                    BOOLEAN       := FALSE;
 
BEGIN 

-- set standards 

    :new.lst_updt := sysdate;
  
    IF :new.updt_by IS NULL THEN 
        :new.updt_by := user; 
    END IF;
      
    IF inserting THEN 
        :new.warning_status := 'C';
    END IF;

    IF updating THEN
-- don't allow initial data to change -
        :new.warning_type := :old.warning_type;
        :new.warning_from := :old.warning_from;
        :new.warning_msg  := :old.warning_msg;
        :new.warning_time := :old.warning_time;
       
-- resolving, ensure action not null (ie, is recorded) - 
        IF :new.warning_status = 'H' AND :old.warning_status = 'C' THEN 
            IF :new.action_taken IS NULL THEN
                fail_update := TRUE;
            END IF;
-- do not get rid of a specific action            
        ELSIF :new.action_taken IS NULL AND :old.action_taken IS NOT NULL THEN 
            fail_update := TRUE;
        END IF;
    END IF;

    IF fail_update THEN
        :new.lst_updt       := :old.lst_updt;
        :new.warning_status := :old.warning_status;
        :new.action_taken   := :old.action_taken;
        :new.updt_by        := :old.updt_by;
    END IF;
     

EXCEPTION WHEN OTHERS THEN
    ps_oerr := sqlcode;
    ps_msg := 'Unknown error'; 
    
    INSERT 
    INTO std_pfsawh_debug_tbl 
        (
        ps_procedure,      ps_oerr, ps_location, called_by, 
        ps_id_key,         ps_msg,  msg_dt
        )
    VALUES 
        (
        ps_procedure_name, ps_oerr, ps_location, null, 
        ps_id_key,         ps_msg,  sysdate
        );

END; -- end of trigger
/

