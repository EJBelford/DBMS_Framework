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

CREATE OR REPLACE TRIGGER tr_i_pfsawh_item_dim_seq
BEFORE INSERT
ON gb_pfsawh_item_dim
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
v_rec_dim_id NUMBER;

BEGIN
    v_rec_dim_id := 0;
    
    SELECT pfsawh_item_seq.nextval 
    INTO  v_rec_dim_id 
    FROM dual;
    
    :new.rec_id   := v_rec_dim_id;
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
       
END tr_i_pfsawh_item_dim_seq;
/

