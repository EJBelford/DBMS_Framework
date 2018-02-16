/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_cbmwh_force_unit_seq.sql 
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

CREATE OR REPLACE TRIGGER tr_i_cbmwh_force_unit_seq
BEFORE INSERT
ON cbmwh_force_unit_dim
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW 
DECLARE
v_rec_id NUMBER;

BEGIN
    v_rec_id := 0;

    SELECT cbmwh_force_unit_dim_seq.nextval 
    INTO   v_rec_id 
    FROM   dual;
   
    :new.rec_id             := v_rec_id;
--    :new.status             := 'Z';
    :new.lst_updt           := sysdate;
    :new.updt_by            := user;

    :new.active_flag        := 'Y'; 
--    :new.wh_record_status   := 'Y';
--    :new.wh_effective_date  := sysdate;
    :new.insert_by          := user;
    :new.insert_date        := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_cbmwh_force_unit_seq;
