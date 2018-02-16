/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_pfsawh_fct_ld_sn_cntl_sq.sql
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
-- 20NOV2008                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_pfsawh_fct_ld_sn_cntl_sq

BEFORE UPDATE OR INSERT
ON pfsawh_fact_ld_sn_cntrl
--REFERENCING NEW AS New OLD AS Old
FOR EACH ROW

DECLARE
v_rec_id NUMBER;

-- module variables (v_)

v_update_date pfsawh_fact_ld_sn_cntrl.update_date%TYPE  := sysdate;
v_update_by   pfsawh_fact_ld_sn_cntrl.update_by%TYPE    := user;

BEGIN 

    :new.lst_updt      := sysdate;
    :new.updt_by       := user;

    IF inserting THEN
        v_rec_id := 0;

        SELECT pfsawh_fact_ld_sn_cntrl_seq.nextval 
        INTO   v_rec_id 
        FROM   dual;
       
        :new.rec_id        := v_rec_id;
        :new.status        := 'Z';
    END IF; 
    
    IF updating THEN 
        :new.update_by     := v_update_by;
        :new.update_date   := v_update_date;
    END IF;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_pfsawh_fct_ld_sn_cntl_sq;
