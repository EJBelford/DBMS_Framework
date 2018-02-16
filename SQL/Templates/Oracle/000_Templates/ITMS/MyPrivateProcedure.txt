-- =======================================================================
--  Procedure:  %YourObjectName%
--
--  Purpose:   This procedure ...
--
--  Local Exceptions:
--      -20000  Invalid parameter passed to procedure.
--
--  Notes:
--
--  History:    %SYSDATE%   %USERNAME%      ECP?????
--                                          Initial Creation.
-- =======================================================================
procedure %YourObjectName%( p_Name in type, p_Name out nocopy type, p_Name in out nocopy type,
                            DiagLogging in boolean,
                            v_DiagCategories in RPA_VARCHAR2_TABLE ) is
    v_ProcName  varchar2(2000) := '%YourObjectName%';
    --v_params    RPA_VARCHAR2_TABLE;
    v_errMsg    varchar2(2000);

    --e???    exception;
    --PRAGMA EXCEPTION_INIT( e???, <number> );
begin
    DIAG.LogEnterPrivate( v_ProcName, DiagLogging, v_DiagCategories );
    DIAG.LogParameterPrivate( v_ProcName, '<input parameter name>', <parameter value>, DiagLogging, v_DiagCategories );

    DIAG.LogMessage( v_ProcName, 'Starting [action being performed by proc]'?, DiagLogging, v_DiagCategories );

    if( <parameter> is null ) then
        -- Invalid parameter passed to procedure.
        v_ErrMsg := 'Invalid parameter passed to procedure.';
        DIAG.LogApplicationError( v_ProcName, -20000, v_ErrMsg, DiagLogging, v_DiagCategories );
        RAISE_APPLICATION_ERROR( -20000, v_ErrMsg );
    end if;



    DIAG.LogMessage( v_ProcName, '[action being performed by proc] completed'?, DiagLogging, v_DiagCategories );

    DIAG.LogParameterPrivate( v_ProcName, '<output parameter name>', <parameter value>, DiagLogging, v_DiagCategories );
    DIAG.LogExitPrivate( v_ProcName, DiagLogging, v_DiagCategories );

--exception
--    when e??? then
--        -- Error string here.
--        v_ErrMsg := 'Error string here.';
--        DIAG.LogApplicationError( v_ProcName, -20001, v_ErrMsg, DiagLogging, v_DiagCategories );
--        RAISE_APPLICATION_ERROR( -20001, v_ErrMsg );
end %YourObjectName%;
