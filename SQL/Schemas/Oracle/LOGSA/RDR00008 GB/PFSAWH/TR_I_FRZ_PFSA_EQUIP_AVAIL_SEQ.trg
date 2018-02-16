/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_frz_pfsa_equip_avail_seq.trg 
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
-- 15APR2008                   Gene Belford     Trigger Created 
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_frz_pfsa_equip_avail_seq
BEFORE INSERT
ON frz_pfsa_equip_avail
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT frz_pfsa_equip_avail_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id      := v_rec_id;
--    :new.status      := 'Z';
--    :new.lst_updt    := sysdate;
--    :new.updt_by     := user;

--    :new.active_flag := 'Y';
--    :new.active_date := sysdate;
    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_frz_pfsa_equip_avail_seq;
