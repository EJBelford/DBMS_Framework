/******************** TEAM ITSS ************************************************

       NAME:    tr_i_pfsawh_identities_seq.trg

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_identities_seq;

CREATE SEQUENCE pfsawh_identities_seq
    START WITH 1
    MAXVALUE 9999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- trigger 

CREATE OR REPLACE TRIGGER tr_i_pfsawh_identities_seq
BEFORE INSERT
ON gb_pfsawh_identities
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
   v_rec_id := 0;

   SELECT pfsawh_identities_seq.nextval 
   INTO   v_rec_id 
   FROM   dual;
   
   :new.rec_id := v_rec_id;
   :new.status := 'Z';
   :new.lst_updt := sysdate;
   :new.updt_by  := user;

   EXCEPTION
     WHEN others THEN
       -- consider logging the error and then re-raise
       RAISE;
       
END tr_i_gb_pfsa_item_seq;
