
CREATE OR REPLACE FUNCTION fn_pfsawh_get_dim_identity 
    (
    in_dimension_tablename   
        gb_pfsawh_identities.dimension_tablename%TYPE
    )
    RETURN gb_pfsawh_identities.last_dimension_identity%TYPE 

IS

/********************************* TEAM ITSS ***********************************

       NAME: Gene Belford
    PURPOSE: To calculate the desired information.
    
   LOCATION: pfsawh@liwwhdev.logsa.army.mil

PARAMETERS::
      INPUT: in_dimension_tablename - the name of the dimension needing a 
                 identity. 

     OUTPUT: v_next_id - the next identity.  
                 If the dimension does not exist, it is inserted into the table
                 and a identity of 1 (one) is returned.
                 If the function fails completely a -1 is returned. 

ASSUMPTIONS:

LIMITATIONS:

      NOTES:

HISTORY of REVISIONS:

Date     ECP #         Author             Description
-------  ------------  -----------------  ---------------------------------
04JAN08                Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/
/*
DECLARE 

-- In and Out parameters

in_dimension_tablename   
    gb_pfsawh_identities.dimension_tablename%TYPE  := 'PFSAWH_ITEM_DIM';
*/
-- Exception handling variables (ps_)

ps_procedure_name        VARCHAR2(30)  := 'fn_PFSAWH_Get_Dim_Identity';
ps_location              VARCHAR2(30)  := 'Begin'; 
ps_oerr                  VARCHAR2(6)   := NULL;
ps_msg                   VARCHAR2(200) := NULL;
ps_id_key                VARCHAR2(200) := NULL;       -- coder responsible for
                                                      -- identying key for debug 
                                                      
-- Process status variables (s0_ & s1_)

s0_userLoginId           VARCHAR2(30)  := USER;

-- module variables (v_)

v_next_id                PLS_INTEGER   := NULL;

BEGIN 

    SELECT	last_dimension_identity + 1
    INTO   v_next_id 
    FROM   gb_pfsawh_identities 
    WHERE  dimension_tablename = UPPER(in_dimension_tablename); 
    
--    DBMS_OUTPUT.PUT_LINE ('    Next: ' || v_next_id || ' - ' || sysdate);
    
    UPDATE gb_pfsawh_identities 
    SET    last_dimension_identity = v_next_id , 
           update_by               = user ,
           update_date             = sysdate
    WHERE  dimension_tablename = UPPER(in_dimension_tablename); 
    
--    COMMIT;
    
    RETURN v_next_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := in_dimension_tablename;
            
		     INSERT 
            INTO    std_pfsa_debug_tbl 
               (
               ps_procedure, ps_oerr, ps_location, 
               called_by, ps_id_key, ps_msg, msg_dt
               )
		     VALUES 
               (
               ps_procedure_name, ps_oerr, ps_location, 
               s0_userLoginId, ps_id_key, ps_msg, sysdate
               );
               
            COMMIT; 
               
            INSERT INTO gb_pfsawh_identities 
                (dimension_tablename, last_dimension_identity) 
                VALUES (UPPER(in_dimension_tablename), 1);
    
            RETURN 1;
            
--            COMMIT; 
    
--            DBMS_OUTPUT.PUT_LINE ('Err Next: ' || v_next_id);
        WHEN OTHERS THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := in_dimension_tablename;
            
		     INSERT 
            INTO    std_pfsa_debug_tbl 
               (
               ps_procedure, ps_oerr, ps_location, 
               called_by, ps_id_key, ps_msg, msg_dt
               )
		     VALUES 
               (
               ps_procedure_name, ps_oerr, ps_location, 
               s0_userLoginId, ps_id_key, ps_msg, sysdate
               );
               
            RETURN -1;
            
--            COMMIT;
            
END; 

/*----- Test script -----*/

/*

DECLARE

    identity gb_pfsawh_identities.last_dimension_identity%TYPE; 

BEGIN 
 
    identity := fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIMx'); 
     
    identity := fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'); 
     
END; 

*/