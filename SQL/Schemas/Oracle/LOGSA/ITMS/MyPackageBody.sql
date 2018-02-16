create or replace package body %YourObjectName% as

-- Global variable declarations
--    pv_<VariableName> <Datatype>;
    pv_SchemaName    varchar2(30);


-- Private routine declarations

-- SchemaName function
function SchemaName return varchar2 is
begin
    if( pv_SchemaName IS NULL ) then
        pv_SchemaName := DIAG.GetSchemaForPackage;
    end if;

    return pv_SchemaName;
end;

-- Function and procedure implementations

--begin
--    NULL;

end %YourObjectName%;
/
