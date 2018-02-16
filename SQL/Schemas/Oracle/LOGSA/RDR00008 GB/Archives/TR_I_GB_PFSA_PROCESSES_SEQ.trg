/*----- Sequence  -----*/

DROP SEQUENCE gb_pfsa_processes_seq;

CREATE SEQUENCE gb_pfsa_processes_seq
    START WITH 1000
    MAXVALUE 9999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

/******************** TEAM ITSS ************************************************

       NAME:    tr_i_gb_pfsa_processes_seq

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/19/2007                   Gene Belford     Trigger Created
*/

CREATE OR REPLACE TRIGGER tr_i_gb_pfsa_processes_seq
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
--    :new.status        := 'Z';
    :new.lst_updt      := SYSDATE;
    :new.updt_by       := USER;

    EXCEPTION
        WHEN others THEN
        -- consider logging the error and then re-raise
        RAISE;
       
END tr_i_gb_pfsa_processes_seq;