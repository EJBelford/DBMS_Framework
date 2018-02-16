/******************** TEAM ITSS ************************************************

       NAME:    tr_i_pfsawh_item_sn_l_fact_seq.trg

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

-- trigger 

CREATE OR REPLACE TRIGGER PFSAWH.tr_i_pfsawh_item_sn_l_fact_seq
BEFORE INSERT
ON PFSAWH.GB_PFSAWH_ITEM_SN_L_FACT REFERENCING NEW AS new OLD AS old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT pfsawh_item_sn_l_fact_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id   := v_rec_id;
    :new.status   := 'C';
    :new.lst_updt := SYSDATE;
    :new.updt_by  := USER;

    EXCEPTION
        WHEN others THEN
       -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_pfsawh_item_sn_l_fact_seq;
/
