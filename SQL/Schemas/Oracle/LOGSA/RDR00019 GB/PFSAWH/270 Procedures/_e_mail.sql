DECLARE

-- functional warnings 

TYPE func_warn_type IS REF CURSOR RETURN pfsawh_functional_warnings%ROWTYPE; 
     cv_func_warn   func_warn_type;
     v_func_warn    pfsawh_functional_warnings%ROWTYPE; 

-- e-mail variables (e_) 

e_from_address        VARCHAR2(500);   -- any string formatted as an email addr 
e_recipient_list      VARCHAR2(500);   -- comma delimited list of email addr 
e_subject             VARCHAR2(500);   -- any string 
e_message             VARCHAR2(500);   -- any string 

e_func_warn           VARCHAR2(4000);  -- any string 

e_cr_lf_str                      VARCHAR2(30)
    := ' ' || CHR(10) || CHR(13);

e_user_env_server_host           VARCHAR2(30);
e_user_env_server_host_nm        VARCHAR2(65);
e_user_env_db_domain             VARCHAR2(30);
e_user_env_db_name               VARCHAR2(30);

-- module variables (v_)

v_debug                          NUMBER        
     := 0;   -- Controls debug options (0 -Off) 
     
BEGIN

-- E-mail setup  
  
    SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST')
    INTO   e_user_env_server_host 
    FROM   dual;

    SELECT SYS_CONTEXT('USERENV', 'DB_DOMAIN')
    INTO   e_user_env_db_domain 
    FROM   dual;
    
    SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
    INTO   e_user_env_db_name 
    FROM   dual;
    
    e_from_address            := 'logas.pfsa@conus.army.mil';   

        e_user_env_server_host_nm := 'PFSAWH@LIWWHDEV';

        e_recipient_list := 'logsa.pfsa@conus.army.mil;, ' || 
             'Eugene.Belford@us.army.mil; ';  

        e_subject := 'Development e-mail message - ' || e_user_env_db_name;    
        
/*----- Build the e-mail body -----*/          

    e_func_warn := NULL; 
    
    OPEN cv_func_warn FOR 
        SELECT fw.warning_time, 
            fw.warning_msg, 
            fw.warning_type, 
            fw.warning_from   
        FROM    pfsawh_functional_warnings fw
        WHERE   fw.warning_status = 'C' 
        GROUP BY fw.warning_type, fw.warning_from, fw.warning_msg
        ORDER BY fw.warning_type, fw.warning_msg; 
            
        FETCH cv_func_warn INTO v_func_warn; 
        
    CLOSE cv_func_warn;


/*----- Send status e-mail -----*/ 

    e_subject := 'Success - ' || e_subject;   
       
    e_message := 'Generated ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI:SS') || e_cr_lf_str 
        || e_user_env_server_host || ' - ' || e_user_env_server_host_nm || e_cr_lf_str 
        || e_user_env_db_domain || e_cr_lf_str 
        || e_user_env_db_name || e_cr_lf_str 
        || 'test' || e_cr_lf_str 
        || 'Success test e-mail message from Eugene.Belford@us.army.mil ' || e_cr_lf_str  
--        || e_cr_lf_str
--        || e_recipient_list  || e_cr_lf_str
        || '/*----- End of Message -----*/';   

    email.send_email(
        e_from_address,     -- any string formatted as an email address
        e_recipient_list,   -- comma delimited list of email addresses
        e_subject,          -- any string
        e_message           -- any string
        );

END; -- end of MAINTAIN_PFSAWH_WORLD procedure 
/
