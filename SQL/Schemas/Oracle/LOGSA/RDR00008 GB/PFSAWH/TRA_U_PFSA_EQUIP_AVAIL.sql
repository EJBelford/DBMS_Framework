CREATE OR REPLACE TRIGGER tra_u_pfsa_equip_avail 
--
-- This trigger ensures data source heirarchy is maintained when updating data 
--
AFTER UPDATE ON pfsa_equip_avail
FOR EACH ROW
DECLARE

  ps_oerr         VARCHAR2(6) := null;
  ps_location          VARCHAR2(10) := null;
  ps_procedure_name         VARCHAR2(30) := 'TR_U_PFSA_EQUIP_AVAIL';
  ps_msg     VARCHAR2(200) := 'trigger_failed';
  ps_id_key     VARCHAR2(200) := null; -- set in cases


BEGIN

  IF :new.priority > :old.priority THEN -- lower priority source, reset values
     :new.PMCM_HRS := :old.PMCM_HRS;
     :new.PMCS_HRS := :old.PMCS_HRS;
     :new.SOURCE_ID := :old.SOURCE_ID;
     :new.LST_UPDT := :old.LST_UPDT;
     :new.UPDT_BY := :old.UPDT_BY;
     :new.PMCS_USER_HRS := :old.PMCS_USER_HRS;
     :new.PMCS_INT_HRS := :old.PMCS_INT_HRS;
     :new.PMCM_USER_HRS := :old.PMCM_USER_HRS;
     :new.PMCM_INT_HRS := :old.PMCM_INT_HRS;
     :new.DEP_HRS := :old.DEP_HRS;
     :new.HEIR_ID := :old.HEIR_ID;
     :new.PRIORITY := :old.PRIORITY;
     :new.UIC := :old.UIC;
     :new.FROM_DT := :old.FROM_DT;
     :new.TO_DT := :old.TO_DT;
     :new.READY_DATE := :old.READY_DATE;
     :new.DAY_DATE := :old.DAY_DATE;
     :new.MONTH_DATE := :old.MONTH_DATE;
     :new.PFSA_ORG := :old.PFSA_ORG;
     :new.SYS_EI_SN := :old.SYS_EI_SN;
     :new.ITEM_DAYS := :old.ITEM_DAYS;
     :new.PERIOD_HRS := :old.PERIOD_HRS;
     :new.NMCM_HRS := :old.NMCM_HRS;
     :new.NMCS_HRS := :old.NMCS_HRS;
     :new.NMC_HRS := :old.NMC_HRS;
     :new.FMC_HRS := :old.FMC_HRS;
     :new.PMC_HRS := :old.PMC_HRS;
     :new.MC_HRS := :old.MC_HRS;
     :new.NMCM_USER_HRS := :old.NMCM_USER_HRS;
     :new.NMCM_INT_HRS := :old.NMCM_INT_HRS;
     :new.NMCM_DEP_HRS := :old.NMCM_DEP_HRS;
     :new.NMCS_USER_HRS := :old.NMCS_USER_HRS;
     :new.NMCS_INT_HRS := :old.NMCS_INT_HRS;
     :new.NMCS_DEP_HRS := :old.NMCS_DEP_HRS;
     :new.SYS_EI_NIIN := :old.SYS_EI_NIIN;
     :new.PFSA_ITEM_ID := :old.PFSA_ITEM_ID;
     :new.RECORD_TYPE := :old.RECORD_TYPE;
  END IF;


EXCEPTION WHEN OTHERS THEN
    ps_oerr := sqlcode;
    ps_id_key := :new.sys_ei_niin||' '||:new.pfsa_item_id||' '||:new.record_type||' '||:new.from_dt;
    insert into std_pfsa_debug_tbl (ps_procedure, ps_oerr, ps_location, called_by, ps_id_key, ps_msg, msg_dt)
           values (ps_procedure_name, ps_oerr, ps_location, null, ps_id_key, ps_msg, sysdate);

END;
/

