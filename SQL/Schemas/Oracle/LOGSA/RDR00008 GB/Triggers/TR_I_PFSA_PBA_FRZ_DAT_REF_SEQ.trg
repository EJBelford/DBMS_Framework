/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_pfsa_pba_frz_dat_ref_seq.trg
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
-- 18JAN2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_pfsa_pba_frz_dat_ref_seq
BEFORE INSERT
ON gb_pfsa_pba_frz_dates_ref
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT pfsa_pba_frz_dat_ref_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id   := v_rec_id;
--    :new.status   := 'Z';
    :new.lst_updt := sysdate;
    :new.updt_by  := user;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_gb_pfsawh_xx_seq;
