--
-- TR_I_PFSAWH_PROCESS_CNTRL_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER PFSAWH.TR_I_PFSAWH_PROCESS_CNTRL_SEQ
BEFORE INSERT
ON PFSAWH.GB_PFSAWH_PROCESS_CONTROL REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    TR_I_PFSAWH_PROCESS_CNTRL_SEQ

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
01/02/2008                   Gene Belford     Trigger Created
*/

BEGIN
   v_item_dim_id := 0;

   SELECT PFSAWH_PROCESS_CONTROL_SEQ.nextval 
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
       
END TR_I_PFSAWH_PROCESS_CNTRL_SEQ;
/


