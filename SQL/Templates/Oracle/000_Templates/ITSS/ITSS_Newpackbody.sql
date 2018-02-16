create or replace package body %YourObjectName% 

as

    function myfuncname ( inval number )
        return number
    is
        tmpvar                        number;
    begin
        tmpvar := 0;
        return tmpvar;
    exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end myfuncname;

    procedure myprocname ( inval number, jobid varchar2 )
    is
        tmpvar                        number;
    begin
        tmpvar := 0;
    exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end myprocname;

end %YourObjectName%;

/

