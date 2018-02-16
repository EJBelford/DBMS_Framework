create or replace type body %YourObjectName% as
--
--
/********************************* TEAM ITSS ***********************************


       NAME:    %YourObjectName%
   
    PURPOSE:    



PARAMETERS::

      INPUT:

     OUTPUT:
 

ASSUMPTIONS:

LIMITATIONS:

      NOTES:

HISTORY of REVISIONS:


  Date     ECP #            Author           Description
---------  ---------------  ---------------  ---------------------------------
%SYSDATE%  CHG00000000000X                   Function Created





******************* TEAM ITSS *************************************************/
--
--
  member function myfunction(param1 in number) return number is
  begin
    return param1;
  end;

  member procedure myprocedure(param1 in number) is
    tmpvar number;
  begin
    tmpvar := param1;
  end;

end %YourObjectName%;

