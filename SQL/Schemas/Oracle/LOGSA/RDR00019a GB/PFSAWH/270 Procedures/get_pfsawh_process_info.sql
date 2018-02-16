CREATE OR REPLACE PROCEDURE get_pfsawh_process_info    
    (
    called_by                IN        VARCHAR2, -- calling procedure name, 
                                                 -- used in debugging, calling 
                                                 -- procedure responsible for 
                                                 -- maintaining heirachy 
    i_process                IN        VARCHAR2,
    o_last_run               IN OUT    DATE,
    o_last_ran_by            IN OUT    VARCHAR2,
    o_last_run_status        IN OUT    VARCHAR2,
    o_last_run_status_time   IN OUT    DATE,
    o_last_run_compl         IN OUT    DATE
    ) 
     
IS

/*

This procedure returns information relating to a specific pfsa_process that 
has been ran

If the process has never been ran, the record is created and proper 
information returned.
         
This procedure accounts for failed processes as follows:  
If the previously ran process was never completed, the
procedure return the values for the last completed process from the history 
table.
If no records found, the procedure will return the default date for a new 
procedure.

Created 17 Apr 2004 by dave hendricks  
         
PRODUCTION DATE 25 Sep 2004 
    
*/

-- Exception handling variables (ps_)

ps_procedure_name                std_pfsawh_debug_tbl.ps_procedure%TYPE  
    := 'get_pfsa_process_info';  /*  */
ps_location                      std_pfsawh_debug_tbl.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          std_pfsawh_debug_tbl.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           std_pfsawh_debug_tbl.ps_msg%TYPE 
    := 'no message defined'; /*  */
ps_id_key                        std_pfsawh_debug_tbl.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- standard variables

l_rec_found        BOOLEAN := FALSE;  -- used create records if required

pfsa_process_rec    pfsawh_processes%ROWTYPE;
pfsa_process_hist   pfsawh_processes_hist%ROWTYPE;

CURSOR get_pfsa_process_rec IS
  select pfsa_process, last_run, who_ran, last_run_status, 
         last_run_status_time, last_run_compl
    from pfsawh_processes
   where pfsa_process = i_process;

CURSOR get_pfsa_process_hist IS
  select pfsa_process, last_run, who_ran, last_run_status, 
         last_run_status_time, last_run_compl
    from pfsawh_processes_hist
   where pfsa_process = i_process and
         last_run_status = 'COMPLETE'
order by last_run DESC;
   
BEGIN

    OPEN get_pfsa_process_rec;
    
    FETCH get_pfsa_process_rec 
    INTO pfsa_process_rec.pfsa_process, pfsa_process_rec.last_run, 
         pfsa_process_rec.who_ran, pfsa_process_rec.last_run_status, 
         pfsa_process_rec.last_run_status_time, pfsa_process_rec.last_run_compl;
    
    IF get_pfsa_process_rec%NOTFOUND THEN
        ps_location := 'NEVERRAN';
        -- new calling process, establish the record by default
        pfsa_process_rec.pfsa_process := i_process;
        pfsa_process_rec.last_run := '1-JAN-1950';
        pfsa_process_rec.who_ran := 'NEVER RAN';
        pfsa_process_rec.last_run_status := 'COMPLETE';
        pfsa_process_rec.last_run_status_time := null;
        pfsa_process_rec.last_run_compl := '1-JAN-1950';
               
        insert 
        into pfsawh_processes 
            (
            pfsa_process, last_run, who_ran, last_run_status, 
            last_run_status_time, last_run_compl
            )
        values 
            (
            pfsa_process_rec.pfsa_process, pfsa_process_rec.last_run, 
            pfsa_process_rec.who_ran, pfsa_process_rec.last_run_status, 
            pfsa_process_rec.last_run_status_time, 
            pfsa_process_rec.last_run_compl
            ); 
            
        commit;
    END IF; 
    
-- set the return values 
    
    o_last_run := pfsa_process_rec.last_run;
    o_last_ran_by := pfsa_process_rec.who_ran;
    o_last_run_status := pfsa_process_rec.last_run_status;
    o_last_run_status_time := pfsa_process_rec.last_run_status_time;
    o_last_run_compl := pfsa_process_rec.last_run_compl; 
    
    CLOSE get_pfsa_process_rec; 
  
    IF o_last_run_status <> 'COMPLETE' THEN
        ps_location := 'FAILEDRUN';
        
        OPEN get_pfsa_process_hist;
        
        FETCH get_pfsa_process_hist 
        INTO pfsa_process_hist.pfsa_process, pfsa_process_hist.last_run, 
            pfsa_process_hist.who_ran, pfsa_process_hist.last_run_status, 
            pfsa_process_hist.last_run_status_time, 
            pfsa_process_hist.last_run_compl;
        
-- never completed, re-set the applicable variables        
        IF get_pfsa_process_hist%NOTFOUND THEN 
            o_last_run := '1-JAN-1950'; 
          
-- consider others
        ELSE
            o_last_run             := pfsa_process_hist.last_run;
            o_last_ran_by          := pfsa_process_hist.who_ran;
            o_last_run_status      := pfsa_process_hist.last_run_status;
            o_last_run_status_time := pfsa_process_hist.last_run_status_time;
            o_last_run_compl       := pfsa_process_hist.last_run_compl;
        END IF;
        
        CLOSE get_pfsa_process_hist;
    END IF;
     
EXCEPTION 
    WHEN OTHERS THEN
        ps_oerr := sqlcode; 
        
        insert 
        into std_pfsawh_debug_tbl 
            (
            ps_procedure,      ps_oerr,   ps_location, 
            called_by,         ps_id_key, ps_msg,      msg_dt)
        values 
            (
            ps_procedure_name, ps_oerr,   ps_location, 
            called_by,         ps_id_key, ps_msg,      sysdate);

END; -- end of procedure
/