CREATE OR REPLACE PROCEDURE updt_pfsawh_processes    
    (
    called_by                IN     VARCHAR2, -- calling procedure name, used 
                                              -- in debugging, calling 
                                              -- procedure responsible for 
                                              -- maintaining heirachy
    i_pfsa_process           IN     VARCHAR2,
    i_last_run               IN     DATE,
    i_who_ran                IN     VARCHAR2,
    i_last_run_status        IN     VARCHAR2,
    i_last_run_status_time   IN     DATE,
    i_last_run_compl         IN     DATE
    )
    
IS

/*

This procedure updates a record in the PFSA_PROCESSES table

Created 18 Jan 04 by Dave Hendricks 
Modified June 1, 2005 by Keith Graham 
     
PRODUCTION DATE 01 SEP 2005 

*/

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'UPDT_PFSA_PROCESSES';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'BEGIN';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'No record found to update'; /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- standard variables

file_hand utl_file.file_type;
v_dir  varchar2(30) := '/home/opuamac/pfsawh/logs';
v_file varchar2(50) := 'pfsawh_production.log';

BEGIN

    UPDATE pfsawh_processes 
    SET last_run             = i_last_run,
        who_ran              = i_who_ran,
        last_run_status      = i_last_run_status,
        last_run_status_time = i_last_run_status_time,
        last_run_compl       = i_last_run_compl
    WHERE pfsa_process = i_pfsa_process;

    ps_location := 'Log write';
    ps_msg      := 'Opening log file'; 

-- This section was commented out until process logging on the warehouse 
-- is defined. Gene Belford - 1 July 2008. 
-- 
--    file_hand := utl_file.fopen( v_dir, v_file, 'A' );
--    utl_file.put_line(file_hand, i_pfsa_process||'...'||i_last_run_status);
--    utl_file.fclose(file_hand);

EXCEPTION 
    WHEN OTHERS THEN
        ps_oerr   := sqlcode;
        ps_id_key := i_pfsa_process;
                  
        INSERT 
        INTO std_pfsawh_debug_tbl 
            (
            ps_procedure,      ps_oerr, ps_location, called_by, 
            ps_id_key,         ps_msg,  msg_dt
            )
        VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, called_by, 
            ps_id_key,         ps_msg,  sysdate
            );

END; -- end of procedure 
/