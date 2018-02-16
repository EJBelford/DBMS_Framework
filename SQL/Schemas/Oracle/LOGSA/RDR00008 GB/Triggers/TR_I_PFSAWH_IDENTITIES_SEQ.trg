/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_pfsawh_xx_seq.trg
-- 
--     PURPOSE:    To perform work as each row is inserted.
--    
-- ASSUMPTIONS:
-- 
-- LIMITATIONS:
-- 
--       NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- 
-- Date       ECP #            Author           Description
-- ---------  ---------------  ---------------  --------------------------------
-- 04DEC2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

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
    :new.status := 'C';
    :new.lst_updt := sysdate;
    :new.updt_by  := user;

    :new.active_flag := 'Y';
    :new.active_date := sysdate;
    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_gb_pfsa_item_seq;
