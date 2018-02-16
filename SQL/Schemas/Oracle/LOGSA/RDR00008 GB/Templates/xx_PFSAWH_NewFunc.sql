CREATE OR REPLACE FUNCTION %YOUROBJECTNAME% 
RETURN NUMBER 

IS

TMPVAR NUMBER;

/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.

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

BEGIN

    tmpvar := 0;
    
    RETURN tmpvar;
    
    EXCEPTION
        WHEN no_data_found THEN
            NULL;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END %YourObjectName%; 
