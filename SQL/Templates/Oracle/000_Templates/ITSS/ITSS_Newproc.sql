create or replace procedure %YourObjectname% is
tmpvar number;
--
--
/************ TEAM ITSS********************************************************


       NAME:    %YourObjectName%

    PURPOSE:    To calculate the desired information.


 PARAMETERS:

      INPUT:

     OUTPUT:

ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  
  Date     ECP #            Author           Description
---------  ---------------  ---------------  ----------------------------------
%SYSDATE% CHG00000000000x                   Procedure Created




************* TEAM ITSS *******************************************************/
--
--
begin
   tmpvar := 0;
   exception
     when no_data_found then
       null;
     when others then
       -- consider logging the error and then re-raise
       raise;
end %YourObjectName%;

