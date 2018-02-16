/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_pfsa_item_sn_dim_seq 
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
-- 12DEC2007                   Gene Belford     Trigger Created 
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_pfsa_item_sn_dim_seq
BEFORE INSERT
ON pfsawh_item_sn_dim
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_sn_dim_id NUMBER;

BEGIN
    v_item_sn_dim_id := 0;

    SELECT pfsawh_item_sn_seq.nextval 
    INTO  v_item_sn_dim_id 
    FROM dual; 
   
    :new.rec_id   := v_item_sn_dim_id;
    :new.status   := 'C';
    :new.lst_updt := SYSDATE;
    :new.updt_by  := USER;

    :new.active_flag := 'Y';
    :new.active_date := sysdate;
    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_pfsa_item_sn_dim_seq;

