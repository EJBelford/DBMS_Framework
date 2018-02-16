/*

https://gist.github.com/sandcastle/03d4f7be338b7d28e7e7

*/

CREATE OR REPLACE FUNCTION guid_to_raw ( guid IN VARCHAR2 ) RETURN RAW
IS
    hex VARCHAR2(32);
BEGIN

    hex := SUBSTR(guid, 7, 2)
    ||     SUBSTR(guid, 5, 2)
    ||     SUBSTR(guid, 3, 2)
    ||     SUBSTR(guid, 1, 2)
    --
    ||     SUBSTR(guid, 12, 2)
    ||     SUBSTR(guid, 10, 2)
    --
    ||     SUBSTR(guid, 17, 2)
    ||     SUBSTR(guid, 15, 2)
    -- 
    ||     SUBSTR(guid, 20, 2)
    ||     SUBSTR(guid, 22, 2)
    -- 
    ||     SUBSTR(guid, 25, 12);
    
    RETURN hextoraw(hex);

END;
/