/******************** TEAM ITSS ************************************************

       NAME:    TR_I_CBMWH_PROCESS_CNTRL_SEQ

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
01/02/2008                   Gene Belford     Trigger Created
*/

CREATE OR REPLACE TRIGGER tr_i_cbmwh_process_cntrl_seq
BEFORE INSERT
ON cbmwh_process_control REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_dim_id NUMBER;

BEGIN
   v_item_dim_id := 0;

   SELECT cbmwh_process_control_seq.nextval 
   INTO   v_item_dim_id 
   FROM   dual;
       :new.process_control_id := v_item_dim_id;
       :new.status             := 'C';
       :new.lst_updt           := sysdate;
       :new.updt_by            := user;

   EXCEPTION
       WHEN others THEN
       -- consider logging the error and then re-raise
       RAISE;
       
END tr_i_cbmwh_process_cntrl_seq;
/


