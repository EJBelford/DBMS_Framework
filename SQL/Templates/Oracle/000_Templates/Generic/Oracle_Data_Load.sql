
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: %TableName%_%TableType%
--      PURPOSE: Load data into the %TableName%_%TableType% table.
--
--   CREATED BY: %USERNAME%
-- CREATED DATE: %SYSDATE%
--
--       SOURCE: %TableName%_%TableType%.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Automatically available Auto Replace Keywords:
--    Object Name:     %YourObjectName%
--    Sysdate:         %SYSDATE%
--    Date and Time:   %DATE%, %TIME%, and %DATETIME%
--    Username:        %USERNAME% (set in TOAD Options, Procedure Editor)
--    Table Name:      %TableName% (set in the "New PL/SQL Object" dialog) 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- %SYSDATE% - %USERNAME%  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

-- DELETE FROM %TableName%_%TableType%;

-- Default record --

/* INSERT INTO %TableName%_%TableType% (
%FieldNm1%, 
%FieldNm2%, 
%FieldNm3%
) 
VALUES ( 0, 'UNK', 'Unknown Weapon' );  */

-- Load records --

/* INSERT INTO %TableName%_%TableType% (
%FieldNm1%, 
%FieldNm2%, 
%FieldNm3%
) 
          SELECT %Value_1%, %Value_2%, %Value_3% FROM DUAL 
UNION ALL SELECT %Value_1%, %Value_2%, %Value_3% FROM DUAL 
UNION ALL SELECT %Value_1%, %Value_2%, %Value_3% FROM DUAL ; */

-- Merge records --

MERGE INTO  %TableName%_%TableType% dst
USING  (
           SELECT %Value_1% AS %FieldNm1%, %Value_2% AS %FieldNm2%, %Value_3% AS %FieldNm3% FROM DUAL 
		   
           UNION ALL SELECT %Value_1% AS %FieldNm1%, %Value_2% AS %FieldNm2%, %Value_3% AS %FieldNm3% FROM DUAL
       ) src
ON    ( dst.%FieldNm1%  = src.%FieldNm1% 
        AND dst.%FieldNm2%  = src.%FieldNm2% )
WHEN MATCHED THEN
    UPDATE 
    SET  dst.%FieldNm3% = src.%FieldNm3%, 
	     dst.update_date = SYSDATE,
         dst.update_by = SUBSTR(USER, 1, 50)
WHEN NOT MATCHED THEN
    INSERT ( 
	    dst.%FieldNm1%,
        dst.%FieldNm2%,
        dst.%FieldNm3%
	    )
    VALUES (src.%FieldNm1%,
        src.%FieldNm2%,
        src.%FieldNm3%
		)
;


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Validate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

SELECT %FieldNm1%, 
%FieldNm2%, 
%FieldNm3%  
FROM %TableName%_%TableType%
ORDER BY %FieldNm1%;
/  


/*

SET SERVEROUTPUT ON

DECLARE

BEGIN 

    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.NEW_LINE;
    
    FOR table_load 
    IN  (
        SELECT rec_id, 
            xx_code,
            xx_desc
        FROM %YourObjectName% 
        ORDER BY rec_id
        )
    LOOP
        DBMS_OUTPUT.PUT_LINE
            (          table_load.rec_id 
            || ', ' || table_load.xx_code 
            || ', ' || table_load.xx_desc
            );
    END LOOP;    -- table_load.. 
    
END;  
/ 

*/
