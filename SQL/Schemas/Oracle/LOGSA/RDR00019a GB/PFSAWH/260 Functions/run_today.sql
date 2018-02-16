CREATE OR REPLACE FUNCTION run_today ( my_module varchar2 )
    return boolean
is
-- this function checks to see if a module should be run on this day.
-- the module name is passed in checked and a boolean is returned.
--  this will let the function be condition in an if statement around each
-- module that will either allow it to run or not.
/*   The control for this module are
    256 - mid month run
    128 - first of month run
    64  - run on saturday
    32  - run on friday
    16  - run on thursday
    8   - run on wednesday
    4   - run on tuesday
    2   - run on monday
    1   - run on sunday

       for example 62 would run mon-fri
                65  would run sat-sun
                127 7 days a week

    the override flag may be set to 'Y'  and the process will run one time.  the procedure will
    reset the flag to 'N' after it is checked.  This will allow any module to run on demand

    currently mid month run is set to the 21th of the month that can be changed as needed.
*/
-- Exception handling variables (ps_)

ps_procedure_name        VARCHAR2(30)  := 'RUN_TODAY';
ps_location              VARCHAR2(30)  := 'Begin'; 
ps_oerr                  VARCHAR2(6)   := NULL;
ps_msg                   VARCHAR2(200) := NULL;
ps_id_key                VARCHAR2(200) := 'run_today';
                                                      
    module_cntrl                  number;
    rec_id                        number;
    override_flag                 varchar2 ( 1 );
    day_of_week                   varchar2 ( 3 );
    month_of_year                 varchar2 ( 3 );
    day_of_month                  number ( 2 );
    return_bool                   boolean;
    mid_month                     boolean;
    beg_month                     boolean;
    saturday                      boolean;
    friday                        boolean;
    thursday                      boolean;
    wednesday                     boolean;
    tuesday                       boolean;
    monday                        boolean;
    sunday                        boolean;
begin
    return_bool := false;

-- get run module module control from
    select process_recid, run_cntrl, override_run_cntrl
      into rec_id, module_cntrl, override_flag
      from pfsawh_process_ref
     where UPPER(process_description) = UPPER(my_module) and status = 'C';

    if override_flag = 'Y' then
        return_bool := true;

        update pfsawh_process_ref
           set override_run_cntrl = 'N'
         where process_recid = rec_id;
    else
        if module_cntrl > 0 then
            -- determine day of week
            day_of_week := to_char ( sysdate, 'DY' );
            day_of_month := to_number ( to_char ( sysdate, 'DD' ));

            if module_cntrl >= 256 then
                module_cntrl := module_cntrl - 256;
                mid_month := true;
            end if;

            if module_cntrl >= 128 then
                module_cntrl := module_cntrl - 128;
                beg_month := true;
            end if;

            if module_cntrl >= 64 then
                module_cntrl := module_cntrl - 64;
                saturday := true;
            end if;

            if module_cntrl >= 32 then
                module_cntrl := module_cntrl - 32;
                friday := true;
            end if;

            if module_cntrl >= 16 then
                module_cntrl := module_cntrl - 16;
                thursday := true;
            end if;

            if module_cntrl >= 8 then
                module_cntrl := module_cntrl - 8;
                wednesday := true;
            end if;

            if module_cntrl >= 4 then
                module_cntrl := module_cntrl - 4;
                tuesday := true;
            end if;

            if module_cntrl >= 2 then
                module_cntrl := module_cntrl - 2;
                monday := true;
            end if;

            if module_cntrl = 1 then
                sunday := true;
            end if;

            if module_cntrl > 16 then
                module_cntrl := module_cntrl - 16;
                thursday := true;
            end if;

            case day_of_month
                when 1 then
                    if beg_month then
                        return_bool := true;
                    end if;
                when 21 then
                    if mid_month then
                        return_bool := true;
                    end if;
                else
                    return_bool := return_bool;
            end case;

            if return_bool = false then
                case day_of_week
                    when 'SUN' then
                        if sunday = true then
                            return_bool := true;
                        end if;
                    when 'MON' then
                        if monday = true then
                            return_bool := true;
                        end if;
                    when 'TUE' then
                        if tuesday = true then
                            return_bool := true;
                        end if;
                    when 'WED' then
                        if wednesday = true then
                            return_bool := true;
                        end if;
                    when 'THU' then
                        if thursday = true then
                            return_bool := true;
                        end if;
                    when 'FRI' then
                        if friday = true then
                            return_bool := true;
                        end if;
                    when 'SAT' then
                        if saturday = true then
                            return_bool := true;
                        end if;
                    else
                        return_bool := return_bool;
                end case;
            end if;
        end if;
    end if;

    return return_bool;
 EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := 'process not registered - ' || my_module;
        
            INSERT 
            INTO    std_pfsawh_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, 
                called_by, ps_id_key, ps_msg, msg_dt
                )
             VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, 
                'Run_Today', ps_id_key, ps_msg, sysdate
                );
            RETURN (return_bool); 
    
        WHEN OTHERS THEN
            ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := 'error in run_today - ' || my_module;
            
            INSERT 
            INTO    std_pfsawh_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, 
                called_by, ps_id_key, ps_msg, msg_dt
                )
             VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, 
                'Run_Today', ps_id_key, ps_msg, sysdate
                );
               
    RETURN (return_bool);
end run_today;
/
