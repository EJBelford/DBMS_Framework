CREATE OR REPLACE TRIGGER tr_i_cbmwh_process_log_seq

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--        NAME: TR_I_CBMWH_PROCESS_LOG_SEQ 
--
--     PURPOSE: To perform work as each row is inserted. 
--   
-- ASSUMPTIONS: 
-- 
-- LIMITATIONS: 
-- 
--       NOTES: 
-- 
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--   Date   ECP #            Author           Description
-- -------  ---------------  ---------------  ---------------------------------
-- 18DEC07                   Gene Belford     Trigger Created
--  
/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/

BEFORE INSERT
ON cbmwh_process_log 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_process_key NUMBER;

BEGIN
   v_process_key := 0;

   SELECT cbmwh_process_log_seq.nextval 
   INTO   v_process_key 
   FROM   dual; 
   
   :new.process_key := v_process_key;

   EXCEPTION
     WHEN others THEN
       -- consider logging the error and then re-raise
       RAISE;
       
END tr_i_cbmwh_process_log_seq;
 