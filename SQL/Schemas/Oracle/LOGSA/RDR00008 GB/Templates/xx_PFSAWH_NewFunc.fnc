/********************************* TEAM ITSS ***********************************

         NAME: date_id_to_date 
      PURPOSE: Convert date_id to date without using date_dim. 

   CREATED BY: Gene Belford 
 CREATED DATE: 10 April 2008 

   PARAMETERS: 

        INPUT: date_id 

       OUTPUT: 'DD-MON-YYYY'' 

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
10APR08                 Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION xx_PFSAWH_NewFunc 
    (
    v_cat_code  IN gb_pfsawh_code_ref.cat_code%TYPE, 
    v_item_code IN gb_pfsawh_code_ref.item_code%TYPE 
    ) 
    RETURN NUMBER 

IS

TMPVAR NUMBER;

BEGIN

    tmpvar := 0;
    
    RETURN tmpvar;
    
    EXCEPTION
        WHEN no_data_found THEN
            NULL;
        WHEN others THEN
            -- consider logging the error and then re-raise
        RAISE;
        
END xx_PFSAWH_NewFunc; 
