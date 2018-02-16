/******************** TEAM ITSS ************************************************/

       NAME:    tr_i_pfsawh_xx_seq.trg

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

-- trigger 

CREATE OR REPLACE TRIGGER tr_i_pfsawh_xx_seq
BEFORE INSERT
ON gb_pfsawh_xx
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT pfsawh_xx_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id   := v_rec_id;
    :new.status   := 'Z';
    :new.lst_updt := sysdate;
    :new.updt_by  := user;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_gb_pfsawh_xx_seq;


/*

CREATE OR REPLACE TRIGGER TR_U_BLD_PFSA_SN_EI_HIST
-- This trigger controls the update of data in the table, setting all standard potential table variables per the PFSA design
--
-- This trigger ensures the same data from multiple sources does not cause the reprocessing of promoted data.
--
-- TDEV - This table has been disabled and will likely be removed/significantly modified to accommodate new usage processing thru this table
--
BEFORE UPDATE ON BLD_PFSA_SN_EI_HIST
FOR EACH ROW
DECLARE

  ps_oerr        VARCHAR2(6) := null;
  ps_location   VARCHAR2(10) := 'BEGIN';
  ps_procedure_name  VARCHAR2(30) := 'TR_U_BLD_PFSA_SN_EI_HIST';
  ps_msg       VARCHAR2(200) := 'trigger_failed';
  ps_id_key       VARCHAR2(200) := null; -- set
in_sys_ei_niin||in_sys_ei_sn||in_event_dt_time

  reset_all_attributes  BOOLEAN := FALSE;

BEGIN

:new.event_dt_time := :old.event_dt_time; IF :new.updt_by IS NULL THEN
   :new.updt_by := substr(user, 1, 30);
END IF;
-- usage mb part of key

IF :old.status = 'P' THEN -- already processed, handle case for usage
   IF :new.reading IS NULL THEN  -- not a usage related record, do not change the values
      reset_all_attributes := TRUE;
   ELSE
      :new.status := 'Q'; -- usage record being tagged for reprocessing due to receipt of non-usage reporting source
   END IF;
ELSIF :new.sys_ei_niin IS NULL OR :new.sys_ei_sn IS NULL THEN
   reset_all_attributes := TRUE;
ELSE
   IF :new.event_dt_time > :old.lst_updt + 86401/86400 THEN -- bad data, do not want to process
      :new.status := 'Q';
      :new.lst_updt := :old.lst_updt;
	  reset_all_attributes := TRUE;
   ELSIF :new.sn_item_state||:new.ready_state||:new.sys_ei_state IS NULL THEN
      reset_all_attributes := TRUE;
   ELSE
      :new.lst_updt := sysdate;
   END IF;
END IF;

IF reset_all_attributes THEN
  :new.sys_ei_niin := :old.sys_ei_niin;
  :new.sys_ei_sn := :old.sys_ei_sn;
  :new.reporting_org := :old.reporting_org;
  :new.sn_item_state := :old.sn_item_state;
  :new.ready_state := :old.ready_state;
  :new.sys_ei_state := :old.sys_ei_state;
  :new.event := :old.event;
  :new.source_id := :old.source_id;
  :new.lst_updt := :old.lst_updt;
  :new.updt_by := :old.updt_by;
  :new.status := :old.status;
  :new.event_end_time := :old.event_end_time;
  :new.reading := :old.reading;
  :new.usage := :old.usage;
  :new.usage_mb := :old.usage_mb;
END IF;

-- unexpected exception
EXCEPTION WHEN OTHERS THEN
          ps_id_key :=
:new.sys_ei_niin||'|'||:new.sys_ei_sn||'|'||:new.event_dt_time;
    ps_oerr := sqlcode;
                  ps_msg := 'Unknown error';
    insert into std_pfsa_debug_tbl (ps_procedure, ps_oerr, ps_location, called_by, ps_id_key, ps_msg, msg_dt)
           values (ps_procedure_name, ps_oerr, ps_location, null, ps_id_key, ps_msg, sysdate);

END; -- end of trigger
/

*/