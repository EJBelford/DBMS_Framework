--
-- TR_I_PFSAWH_PROCESS_REF_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER tr_i_cbmwh_process_ref_seq 
BEFORE INSERT
ON cbmwh_process_ref
REFERENCING NEW AS new OLD AS old
FOR EACH ROW
DECLARE
v_processes_id NUMBER;

BEGIN
    v_processes_id := 0;

    SELECT cbmwh_process_ref_seq.NEXTVAL 
    INTO   v_processes_id 
    FROM   dual;
                       
    :new.process_RecId := v_processes_id;
    :new.status        := 'C'; 
    :new.lst_updt      := SYSDATE;
    :new.updt_by       := USER;

    :new.active_flag := 'Y';
    :new.active_date := sysdate;
    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_cbmwh_process_ref_seq;