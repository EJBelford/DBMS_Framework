/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--
--        NAME:    tr_i_gb_pfsa_processes_seq 
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
-- 19DEC2007                   Gene Belford     Trigger Created
--
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

CREATE OR REPLACE TRIGGER tr_i_pfsawh_processes_seq
BEFORE INSERT
ON gb_pfsawh_processes
REFERENCING NEW AS new OLD AS old
FOR EACH ROW
DECLARE
v_processes_id NUMBER;

BEGIN
    v_processes_id := 0;

    SELECT gb_pfsa_processes_seq.NEXTVAL 
    INTO   v_processes_id 
    FROM   dual;
                       
    :new.process_RecId := v_processes_id;
    :new.status        := 'C'; 
    :new.lst_updt      := SYSDATE;
    :new.updt_by       := USER;

    :new.active_flag := 'Y';
    :new.active_date := sysdate;
    :new.insert_by   := user;
    :new.insert_date := sysdate;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_pfsawh_processes_seq;