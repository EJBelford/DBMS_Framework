create or replace trigger %YourObjectname% 
%TriggerOpts%DECLARE
tmpVar NUMBER;
--
--
/******************** TEAM ITSS ************************************************


       NAME:    %YourObjectName%

    PURPOSE:    To perform work as each row is inserted or updated.

   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:


  Date     ECP #            Author           Description
---------  ---------------  ---------------  ---------------------------------
%SYSDATE%  CHG00000000000x                   Trigger Created



******************* TEAM ITSS *************************************************/
--
--
begin
   tmpvar := 0;

   select myseq.nextval into tmpvar from dual;
   :new.sequencecolumn := tmpvar;
   :new.createddate := sysdate;
   :new.createduser := user;

   exception
     when others then
       -- consider logging the error and then re-raise
       raise;
end %YourObjectName%;

