CREATE OR REPLACE FUNCTION %YourObjectName% 
    (
    v_process_control_name IN pfsawh_process_control.process_control_name%TYPE
    )
RETURN VARCHAR2 

IS

/********************************* TEAM ITSS ***********************************

   Automatically available Auto Replace Keywords:
      Object Name:     %YourObjectName%
      Sysdate:         %SYSDATE%
      Date and Time:   %DATE%, %TIME%, and %DATETIME%
      Username:        %USERNAME% (set in TOAD Options, Proc Templates)
      Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 

********************************************************************************

       NAME: %USERNAME%...
    PURPOSE: 

 PARAMETERS:

      INPUT: process_control_name... 

     OUTPUT: character string...

ASSUMPTIONS:

LIMITATIONS:

      NOTES:

HISTORY of REVISIONS:

  Date       ECP #         Author             Description
-----------  ------------  -----------------  ---------------------------------
%DATE%                %USERNAME%         Function Created...

*********************************** TEAM ITSS *********************************/

/*----- Test script -----*/
/*

DECLARE 

tstname                       pfsawh_process_control.process_control_name%TYPE; 
tmpvar                        pfsawh_process_control.process_control_value%TYPE; 

BEGIN 

    DBMS_OUTPUT.ENABLE(1000000);

-- Test 01: Success - Should return a control value... 
    
    tstname :=  'schema_owner'; 
    tmpvar  :=  NULL; 

    tmpvar  := %YourObjectName% (tstname); 

    DBMS_OUTPUT.PUT_LINE 
       (
          'Test 01: ' 
       || 'process_control_name: '    || tstname 
       || ', process_control_value: ' || tmpvar 
       ); 
            
-- Test 02: Failure - Should return a error code and write to debug table... 
    
    tstname :=  'schema_owner x'; 
    tmpvar  :=  NULL; 

    tmpvar  := %YourObjectName% (tstname); 

    DBMS_OUTPUT.PUT_LINE 
       (
          'Test 02: ' 
       || 'process_control_name: '    || tstname 
       || ', process_control_value: ' || tmpvar 
       ); 
            
-- Test 03: Additional - The value to return is a number... 
    
    tstname :=  'v_keep_n_days_of_log'; 
    tmpvar  :=  NULL; 

    tmpvar  := %YourObjectName% (tstname); 

    DBMS_OUTPUT.PUT_LINE 
       (
          'Test 03: ' 
       || 'process_control_name: '    || tstname 
       || ', process_control_value: ' || tmpvar 
       ); 
            
-- Test 04: Additional - The string is to long... 
    
    tstname :=  'string is to long'; 
    tmpvar  :=  NULL; 

    tmpvar  := %YourObjectName% (tstname); 

    DBMS_OUTPUT.PUT_LINE 
       (
          'Test 04: ' 
       || 'process_control_name: '    || tstname 
       || ', process_control_value: ' || tmpvar 
       ); 
            
-- Test 05: Additional - The is less than max length... 
    
    tstname :=  'short'; 
    tmpvar  :=  NULL; 

    tmpvar  := %YourObjectName% (tstname); 

    DBMS_OUTPUT.PUT_LINE 
       (
          'Test 05: ' 
       || 'process_control_name: '    || tstname 
       || ', process_control_value: ' || tmpvar 
       ); 

    COMMIT;
            
END; 

*/ 

tmpvar                        pfsawh_process_control.process_control_value%TYPE;

-- Exception handling variables (ps_)...

ps_procedure_name                std_pfsa_debug_tbl.ps_procedure%TYPE  
    := '%YourObjectName%';     /*  */
ps_location                      std_pfsa_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsa_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsa_debug_tbl.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        std_pfsa_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
-- coder responsible for identying key for debug

ps_last_process                  pfsa_processes%rowtype;
ps_this_process                  pfsa_processes%rowtype;

BEGIN

    ps_id_key := v_process_control_name;
    tmpvar    := NULL;

    SELECT v_process_control_name -- Replace with value to pass back...
    INTO   tmpvar
    FROM dual
--    FROM   %TableName%
--    WHERE  UPPER(process_control_name) = UPPER(v_process_control_name) 
--        AND status = 'C'
--        AND active_flag = 'Y'
--        AND sysdate BETWEEN active_date AND inactive_date
    ;

    RETURN NVL(tmpvar, -9999);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RETURN -9992;
        WHEN NO_DATA_FOUND THEN
            ps_oerr   := sqlcode;
            ps_msg    := SUBSTR('Insert "' || v_process_control_name 
                                || '" into PFSAWH_PROCESS_CONTROL - ' 
                                || SQLERRM, 
                                1, 200);
            ps_id_key := SUBSTR(ps_id_key, 1, 200);

            INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure,      ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
            VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, NULL, 
                ps_id_key, ps_msg, SYSDATE
                );

            COMMIT; 
                
            RETURN -9993;
        WHEN TOO_MANY_ROWS THEN
            RETURN -9994;
        WHEN ZERO_DIVIDE THEN
            RETURN -9995;
        WHEN INVALID_NUMBER THEN
            RETURN -9996;
        WHEN PROGRAM_ERROR THEN
            RETURN -9997;
        WHEN OTHERS THEN
            ps_oerr   := sqlcode;
            ps_msg    := SUBSTR(SQLERRM,   1, 200);
            ps_id_key := SUBSTR(ps_id_key, 1, 200);

            INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure,      ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
            VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, NULL, 
                ps_id_key, ps_msg, SYSDATE
                );

            COMMIT; 
                
            RETURN -9998;

END %YourObjectName%;
/