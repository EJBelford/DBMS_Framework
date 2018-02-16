/*

https://gist.github.com/sandcastle/03d4f7be338b7d28e7e7

*/

CREATE OR REPLACE FUNCTION raw_to_guid( raw_guid IN RAW ) RETURN VARCHAR2
IS
  hex VARCHAR2(32);
  
BEGIN

  hex := RAWTOHEX(raw_guid);

  RETURN SUBSTR(hex, 7, 2) 
      || SUBSTR(hex, 5, 2) 
      || SUBSTR(hex, 3, 2) 
      || SUBSTR(hex, 1, 2) 
      || '-'
      || SUBSTR(hex, 11, 2) 
      || SUBSTR(hex, 9, 2) 
      || '-'
      || SUBSTR(hex, 15, 2) 
      || SUBSTR(hex, 13, 2) 
      || '-'
      || SUBSTR(hex, 17, 4) 
      || '-'
      || SUBSTR(hex, 21, 12);

END;
/
