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
-- 18JAN2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER PFSAWH.TR_I_PFSAWH_SRC_HIST_REF_SEQ
BEFORE INSERT
ON PFSAWH.GB_PFSAWH_SOURCE_HIST_REF REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_dim_id NUMBER;

BEGIN
    v_item_dim_id := 0;

    SELECT PFSAWH_SOURCE_HIST_REF_ID.nextval 
    INTO   v_item_dim_id 
    FROM   dual; 
   
    :new.source_hist_ref_id := v_item_dim_id;
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
       
END tr_i_pfsawh_src_hist_ref_seq;
/
