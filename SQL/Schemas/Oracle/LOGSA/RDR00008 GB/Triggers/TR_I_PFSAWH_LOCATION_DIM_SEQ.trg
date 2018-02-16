/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--
--       NAME:    tr_i_pfsawh_location_dim_seq.trg
--
--    PURPOSE:    To perform work as each row is inserted.
--   
-- ASSUMPTIONS:
--
-- LIMITATIONS:
-- 
--      NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
-- Date       ECP #            Author           Description
-- ---------  ---------------  ---------------  --------------------------------
-- 18JAN2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_pfsawh_location_dim_seq
BEFORE INSERT
ON gb_pfsawh_location_dim
REFERENCING NEW AS new OLD AS old
FOR EACH ROW
DECLARE

v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT pfsawh_location_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id   := v_rec_id;
    :new.status   := 'Z';
    :new.lst_updt := sysdate;
    :new.updt_by  := user;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_pfsawh_location_dim_seq;
