CREATE OR REPLACE TRIGGER TR_I_MIMOSA_ITEM_SEQ
BEFORE INSERT
ON PFSAWH.MIMOSA_ITEM_DIM
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
v_rec_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    tr_i_mimosa_item_seq

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

BEGIN
    v_rec_dim_id := 0;
    
    SELECT pfsawh_item_seq.nextval 
    INTO  v_rec_dim_id 
    FROM dual;
    
    :new.rec_id   := v_rec_dim_id;
--    :new.status   := 'Z';
    :new.lst_updt := SYSDATE;
    :new.updt_by  := USER;
    
    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        
        RAISE;
       
END tr_i_mimosa_item_seq;
/