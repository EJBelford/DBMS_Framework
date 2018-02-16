/******************** TEAM ITSS ************************************************

       NAME:    tr_i_cbmwh_item_sn_p_fact_seq.trg

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

-- trigger 

CREATE OR REPLACE TRIGGER tr_i_cbmwh_item_sn_p_fact_seq
BEFORE INSERT
ON cbmwh_item_sn_p_fact
REFERENCING NEW AS new OLD AS old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT cbmwh_item_sn_p_fact_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id      := v_rec_id;
--    :new.status      := 'C';
--    :new.lst_updt    := SYSDATE;
--    :new.updt_by     := USER;

    :new.active_flag := 'Y';
    :new.active_date := sysdate;
--    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
       -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_cbmwh_item_sn_p_fact_seq;
