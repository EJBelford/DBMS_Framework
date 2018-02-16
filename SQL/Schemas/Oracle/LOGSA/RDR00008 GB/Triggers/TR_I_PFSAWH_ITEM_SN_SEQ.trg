/******************** TEAM ITSS ************************************************

       NAME:    tr_i_gb_pfsa_item_sn_seq

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_sn_seq;

CREATE SEQUENCE pfsawh_item_sn_seq
    START WITH 1
    MAXVALUE 99999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- Trigger 

DROP TRIGGER tr_i_gb_pfsa_item_sn_seq;

CREATE OR REPLACE TRIGGER tr_i_gb_pfsa_item_sn_seq
BEFORE INSERT
ON gb_pfsawh_item_sn_dim
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_sn_dim_id NUMBER;

begin
   v_item_sn_dim_id := 0;

   select pfsawh_item_sn_seq.nextval into v_item_sn_dim_id from dual;
   :new.rec_id := v_item_sn_dim_id;
--   :new.status := 'Z';
   :new.lst_updt := sysdate;
   :new.updt_by  := user;

   exception
     when others then
       -- consider logging the error and then re-raise
       raise;
       
end tr_i_gb_pfsa_item_sn_seq;

