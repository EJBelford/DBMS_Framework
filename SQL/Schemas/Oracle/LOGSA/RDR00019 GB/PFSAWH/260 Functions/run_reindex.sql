CREATE OR REPLACE function run_reindex ( myTableName varchar2 )
    RETURN BOOLEAN

IS 

/********************************* TEAM ITSS ***********************************

         NAME: run_reindex  
      PURPOSE: Determines if there has been suufiecent change in the table 
                   to require re-indexing. 

   CREATED BY: Gene Belford 
 CREATED DATE: 10 April 2008 

   PARAMETERS: 

        INPUT: myTableName - Name of the table to be evaluated. 

       OUTPUT: boolean 

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
15DEC08                 Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/ 

/*----- Test script -----*/

/*

DECLARE 

myTableName varchar2(30) := 'Bad_Table_Name';


BEGIN 

    IF run_reindex(myTableName) THEN 
        dbms_output.put_line('true'); 
    ELSE
        dbms_output.put_line('false'); 
    END IF; 

    myTableName := 'PFSA_EQUIP_AVAIL';

    IF run_reindex(myTableName) THEN 
        dbms_output.put_line('true'); 
    ELSE
        dbms_output.put_line('false'); 
    END IF; 

    myTableName := 'PFSA_MAINT_EVENT';

    IF run_reindex(myTableName) THEN 
        dbms_output.put_line('true'); 
    ELSE
        dbms_output.put_line('false'); 
    END IF; 

    COMMIT; 

END; 

*/

-- Exception handling variables (ps_)

ps_procedure_name        VARCHAR2(30)  := 'RUN_REINDEX';
ps_location              VARCHAR2(30)  := 'Begin'; 
ps_oerr                  VARCHAR2(6)   := NULL;
ps_msg                   VARCHAR2(200) := NULL;
ps_id_key                VARCHAR2(200) := 'run_reindex';
                                                      
returnBool                       BOOLEAN; 

currentRowCount                  NUMBER       := NULL;
priorRowCount                    NUMBER       := NULL; 

changeRowCount                   NUMBER       := NULL; 
percentChange                    NUMBER       := NULL; 

changeDiffThreshold              NUMBER       := 250001; 
percentDiffThreshold             NUMBER       := 1.0501; 

BEGIN 
    returnBool := FALSE;
    
    changeDiffThreshold  
        := fn_pfsawh_get_prcss_cntrl_val('v_rowcount_diff_threshold');
    percentDiffThreshold 
        := fn_pfsawh_get_prcss_cntrl_val('v_percent_diff_threshold');

    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || UPPER(myTableName) 
    INTO currentRowCount;
    
--    SELECT num_of_rows 
----        , '|', table_name,
----        chk_date,
----        last_analysis 
--    INTO   priorRowCount  
--    FROM   pfsawh_tab_size_trk 
--    WHERE  table_name = UPPER(myTableName) 
--        AND chk_date = 
--            (
--            SELECT MAX(chk_date) 
--            FROM   pfsawh_tab_size_trk 
--            WHERE  table_name = UPPER(myTableName) 
--            ); 
    
    SELECT num_of_rows 
--        , '|', table_name,
--        chk_date,
--        last_analysis 
    INTO   priorRowCount  
    FROM   pfsawh_tab_size_trk 
    WHERE  table_name = UPPER(myTableName) 
        AND chk_date = 
            (
            SELECT MIN(chk_date) 
            FROM   pfsawh_tab_size_trk 
            WHERE  table_name = UPPER(myTableName) 
                AND last_analysis = 
                    (
                    SELECT MAX(last_analysis) 
                    FROM   pfsawh_tab_size_trk 
                    WHERE  table_name = UPPER(myTableName) 
                    )
            ); 

    changeRowCount := currentRowCount - priorRowCount;        

    IF changeRowCount > changeDiffThreshold THEN
        returnBool := TRUE;
    END IF;  
    
    IF currentRowCount > 0 THEN 
        percentChange  := (priorRowCount/currentRowCount); 
        
        IF percentChange > percentDiffThreshold THEN
            returnBool := TRUE;
        END IF; 
    END IF;  
    
    RETURN returnBool;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ps_oerr   := sqlcode;
        ps_msg    := sqlerrm;
        ps_id_key := 'No table counts exist for ' || myTableName;
        
        INSERT 
        INTO    std_pfsawh_debug_tbl 
            (
            ps_procedure, ps_oerr, ps_location, 
            called_by, ps_id_key, ps_msg, msg_dt
            )
         VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, 
            'Run_Reindex', ps_id_key, ps_msg, sysdate
            );
        RETURN (returnBool); 
    
    WHEN OTHERS THEN
        ps_oerr   := sqlcode;
        ps_msg    := sqlerrm;
        ps_id_key := 'error in run_reindex - ' || myTableName;
            
        INSERT 
        INTO    std_pfsawh_debug_tbl 
            (
            ps_procedure, ps_oerr, ps_location, 
            called_by, ps_id_key, ps_msg, msg_dt
            )
         VALUES 
            (
            ps_procedure_name, ps_oerr, ps_location, 
            'Run_Reindex', ps_id_key, ps_msg, sysdate
            );
               
    RETURN (returnBool);
    
END run_reindex;