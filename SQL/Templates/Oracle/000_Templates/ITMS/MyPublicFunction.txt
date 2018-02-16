-- =======================================================================
--  Function:  %YourObjectName%
--
--  Purpose:   This function ...
--
--  Return Value:
--      ?
--
--  Local Exceptions:
--      -20000  Invalid parameter passed to procedure.
--
--  Notes:
--
--  History:    %SYSDATE%   %USERNAME%      ECP?????
--                                          Initial Creation.
-- =======================================================================
function %YourObjectName%( p_Name in type, p_Name out nocopy type, p_Name in out nocopy type )
return [Return type] is
    DiagLogging         boolean;
    v_DiagCategories    RPA_VARCHAR2_TABLE;

    v_ProcName  varchar2(2000) := '%YourObjectName%';
    v_Result    [Return type];

    --v_params            RPA_VARCHAR2_TABLE;
    v_errMsg            varchar2(2000);

    --e???    exception;
    --PRAGMA EXCEPTION_INIT( e???, <number> );
begin
    DBMS_APPLICATION_INFO.SET_MODULE( $$PLSQL_UNIT, v_ProcName );

    DiagLogging := DIAG.IsLoggingEnabledForUnit( USER, SchemaName, $$PLSQL_UNIT, v_DiagCategories );

    DIAG.LogEnterPublic( v_ProcName, DiagLogging, v_DiagCategories );
    DIAG.LogParameterPublic( v_ProcName, '<input parameter name>', <parameter value>, DiagLogging, v_DiagCategories );

    DIAG.LogMessage( v_ProcName, 'Starting [action being performed by proc]'?, DiagLogging, v_DiagCategories );

    if( <parameter> IS NULL ) then
        -- Invalid parameter passed to procedure.
        v_errMsg := 'Invalid parameter passed to procedure.';
        DIAG.LogApplicationError( v_ProcName, -20000, v_ErrMsg, DiagLogging, v_DiagCategories );
        RAISE_APPLICATION_ERROR( -20000, v_errMsg );
    end if;



--    -- Commit the data changes since it is possible for the client to lose its
--    --   connection to the database before it can properly complete the
--    --   transaction, assuming the CF client code actually would commit.
--    commit;

    DIAG.LogMessage( v_ProcName, '[action being performed by proc] completed'?, DiagLogging, v_DiagCategories );

-- Comment out if returning a REF CURSOR.
-- To facilitate tracing sessions by module/action, do not clear these values
--   so that the client code fetching from the ref cursor will be traced.
    DBMS_APPLICATION_INFO.SET_MODULE( NULL, NULL );

    DIAG.LogParameterPublic( v_ProcName, '<output parameter name>', <parameter value>, DiagLogging, v_DiagCategories );
    DIAG.LogReturnValuePublic( v_ProcName, v_Result, DiagLogging, v_DiagCategories );
    DIAG.LogExitPublic( v_ProcName, DiagLogging, v_DiagCategories );

    return v_Result;
exception
--    when e??? then
--        -- Error string here.
--        v_errMsg := 'Error string here.';
--        DIAG.LogApplicationError( v_ProcName, -20001, v_ErrMsg, DiagLogging, v_DiagCategories );
--        RAISE_APPLICATION_ERROR( -20001, <ErrMsg> );
    when others then
        -- Any cleanup needed

        -- Always log errors from public procedures.
        DIAG.LogError( v_ProcName );
        raise;
end %YourObjectName%;
