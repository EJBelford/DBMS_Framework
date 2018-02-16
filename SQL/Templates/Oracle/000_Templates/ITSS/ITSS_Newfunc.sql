create or replace function %YOUROBJECTNAME% return number is
tmpvar number;
--
--
/********************************* TEAM ITSS ***********************************

       NAME:       %YourObjectName%
    PURPOSE:    To calculate the desired information.

PARAMETERS::

      INPUT:

     OUTPUT:

ASSUMPTIONS:


LIMITATIONS:

      NOTES:


HISTORY of REVISIONS:

  Date       ECP #         Author             Description
----------   ------------  -----------------  ---------------------------------
%SYSDATE%    CHG00000000X                     Function Created






*********************************** TEAM ITSS *********************************/
--
--
begin
   tmpvar := 0;
   return tmpvar;
   exception
     when no_data_found then
       null;
     when others then
       -- consider logging the error and then re-raise
       raise;
end %YourObjectName%; 