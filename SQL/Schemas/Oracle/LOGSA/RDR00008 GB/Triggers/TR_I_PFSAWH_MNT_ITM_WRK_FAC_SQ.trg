/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_pfsawh_mnt_itm_wrk_fac_sq
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
-- 129FEB2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_pfsawh_mnt_itm_wrk_fac_sq
BEFORE INSERT
ON pfsawh_maint_itm_wrk_fact
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT pfsawh_maint_itm_wrk_fact_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id   := v_rec_id;
    :new.status   := 'C';
--    :new.lst_updt := sysdate;
--    :new.updt_by  := user;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_pfsawh_mnt_itm_wrk_fac_sq;
