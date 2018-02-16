--
-- TR_I_PFSAWH_CODE_REF_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER PFSAWH.tr_i_pfsawh_code_ref_seq
BEFORE INSERT
ON PFSAWH.GB_PFSAWH_CODE_REF REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT pfsawh_code_ref_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id      := v_rec_id;
    :new.status      := 'C';
    :new.lst_updt    := sysdate;
    :new.updt_by     := user;

    :new.active_flag := 'Y';
    :new.active_date := sysdate;
    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_gb_pfsawh_code_ref_seq;
/


