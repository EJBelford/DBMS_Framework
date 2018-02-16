
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  <Copyright, Belford DB Consulting LLC, 2017>
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: generic_sys_enum_values_ref_load
--      PURPOSE: Load data into the generic_sys_enum_values_ref table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-12
--
--       SOURCE: generic_sys_enum_values_ref_load.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-12 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

-- DELETE FROM generic_sys_enum_values_ref;

-- Default record --

/* INSERT INTO generic_sys_enum_values_ref (
    enum_type,
    enum_value,
    order_by,	
    constant_flag,
    enum_display_name,
    description 
) 
VALUES ( 'CONSTANT_FLAG', 'N', 0, 'Y', 'No', 'No' );  */

-- Load records --

/* INSERT INTO generic_sys_enum_values_ref (
    enum_type,
    enum_value,
    order_by,	
    constant_flag,
    enum_display_name,
    description 
) 
          SELECT 'CONSTANT_FLAG', 'Y', 0, 'Y', 'Yes', 'Yes' FROM DUAL 
UNION ALL SELECT 'DELETE_FLAG', 'N', 0, 'Y', 'No', 'No' FROM DUAL 
UNION ALL SELECT 'DELETE_FLAG', 'Y', 0, 'Y', 'Yes', 'Yes' FROM DUAL  
UNION ALL SELECT 'HIDDEN_FLAG', 'N', 0, 'Y', 'No', 'No' FROM DUAL 
UNION ALL SELECT 'HIDDEN_FLAG', 'Y', 0, 'Y', 'Yes', 'Yes' FROM DUAL ; */

-- Merge records --

MERGE INTO  generic_sys_enum_values_ref dst
USING  (
           SELECT 'CONSTANT_FLAG' AS enum_type, 'N' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'No' AS enum_display_name, 
			   'No' AS description FROM DUAL 
           UNION ALL SELECT 'CONSTANT_FLAG' AS enum_type, 'Y' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Yes' AS enum_display_name, 
			   'Yes' AS description FROM DUAL

           UNION ALL SELECT 'DELETE_FLAG' AS enum_type, 'N' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'No' AS enum_display_name, 
			   'No' AS description FROM DUAL 
           UNION ALL SELECT 'DELETE_FLAG' AS enum_type, 'Y' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Yes' AS enum_display_name, 
			   'Yes' AS description FROM DUAL

           UNION ALL SELECT 'HIDDEN_FLAG' AS enum_type, 'N' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'No' AS enum_display_name, 
			   'No' AS description FROM DUAL 
           UNION ALL SELECT 'HIDDEN_FLAG' AS enum_type, 'Y' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Yes' AS enum_display_name, 
			   'Yes' AS description FROM DUAL

           UNION ALL SELECT 'ACTIVE_FLAG' AS enum_type, 'N' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'No' AS enum_display_name, 
			   'No' AS description FROM DUAL 
           UNION ALL SELECT 'ACTIVE_FLAG' AS enum_type, 'Y' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Yes' AS enum_display_name, 
			   'Yes' AS description FROM DUAL
           UNION ALL SELECT 'ACTIVE_FLAG' AS enum_type, 'I' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Inactive' AS enum_display_name, 
			   'Inactive' AS description FROM DUAL

     	   UNION ALL SELECT 'STATUS' AS enum_type, 'C' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Current' AS enum_display_name, 
			   'Current' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'D' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Duplicate' AS enum_display_name, 
			   'Duplicate' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'E' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'ErrorError' AS enum_display_name, 
			   'Error' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'H' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Historical' AS enum_display_name, 
			   'Historical' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'L' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Logical' AS enum_display_name, 
			   'Logical' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'P' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Processed' AS enum_display_name, 
			   'Processed' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'Q' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Questionable' AS enum_display_name, 
			   'Questionable' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'R' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Ready to Process' AS enum_display_name, 
			   'Ready to Process' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'T' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, '?????' AS enum_display_name, 
			   '?????' AS description FROM DUAL
           UNION ALL SELECT 'STATUS' AS enum_type, 'Z' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Future' AS enum_display_name, 
			   'Future' AS description FROM DUAL

           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'SELECT_ONE' AS enum_value, -1 AS order_by, 
		       'Y' AS constant_flag, 'Select one...' AS enum_display_name, 
			   'Select one' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'U' AS enum_value, 0 AS order_by, 
		       'Y' AS constant_flag, 'Unclassified' AS enum_display_name, 
			   'Unclassified' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'C' AS enum_value, 5 AS order_by, 
		       'Y' AS constant_flag, 'Classified' AS enum_display_name, 
			   'Classified' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'S' AS enum_value, 10 AS order_by, 
		       'Y' AS constant_flag, 'Secret' AS enum_display_name, 
			   'Secret' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'TS' AS enum_value, 15 AS order_by, 
		       'Y' AS constant_flag, 'Top Secret' AS enum_display_name, 
			   'Top Secret' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'R' AS enum_value, 20 AS order_by, 
		       'Y' AS constant_flag, 'R' AS enum_display_name, 
			   'Restricted' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'CTS' AS enum_value, 25 AS order_by, 
		       'Y' AS constant_flag, 'CTS' AS enum_display_name, 
			   'Cosmic Top Secret' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'CTS-B' AS enum_value, 30 AS order_by, 
		       'Y' AS constant_flag, 'CTS-B' AS enum_display_name, 
			   'Cosmic Top Secret-B' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'CTS-BULK' AS enum_value, 35 AS order_by, 
		       'Y' AS constant_flag, 'CTS-BULK' AS enum_display_name, 
			   'Cosmic Top Secret-BULK' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'NU' AS enum_value, 40 AS order_by, 
		       'Y' AS constant_flag, 'NU' AS enum_display_name, 
			   'NATO Unclassified' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'NR' AS enum_value, 45 AS order_by, 
		       'Y' AS constant_flag, 'NR' AS enum_display_name, 
			   'NATO Restricted' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'NC' AS enum_value, 50 AS order_by, 
		       'Y' AS constant_flag, 'NC' AS enum_display_name, 
			   'NATO Confidental' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'NS' AS enum_value, 55 AS order_by, 
		       'Y' AS constant_flag, 'NS' AS enum_display_name, 
			   'NATO Secret' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'CTSA' AS enum_value, 60 AS order_by, 
		       'Y' AS constant_flag, 'CTSA' AS enum_display_name, 
			   'NATO Cosmic Top Secret Atomal' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'NSAT' AS enum_value, 65 AS order_by, 
		       'Y' AS constant_flag, 'NSAT' AS enum_display_name, 
			   'NSAT' AS description FROM DUAL
           UNION ALL SELECT 'CLASSIFICATION' AS enum_type, 'NCA' AS enum_value, 70 AS order_by, 
		       'Y' AS constant_flag, 'NCA' AS enum_display_name, 
			   'NATO Confidental Atomal' AS description FROM DUAL	   
       ) src
ON    ( dst.enum_type  = src.enum_type 
        AND dst.enum_value  = src.enum_value )
WHEN MATCHED THEN
    UPDATE 
    SET  dst.update_date = SYSDATE,
         dst.update_by = SUBSTR(USER, 1, 50)
WHEN NOT MATCHED THEN
    INSERT ( 
	    dst.enum_type,
        dst.enum_value,
        dst.order_by,	
        dst.constant_flag,
        dst.enum_display_name,
        dst.description
	    )
    VALUES (src.enum_type,
        src.enum_value,
        src.order_by,	
        src.constant_flag,
        src.enum_display_name,
        src.description
		)
;


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Validate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

SELECT enum_type,
    enum_value,
    order_by,
    constant_flag,
    enum_display_name,
    description 
FROM generic_sys_enum_values_ref
ORDER BY enum_type,
    order_by,
    enum_value;

	
/*

SET SERVEROUTPUT ON

DECLARE

BEGIN 

    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.NEW_LINE;
    
    FOR table_load 
    IN  (
        SELECT rec_id, 
            enum_type,
            enum_value
        FROM generic_sys_enum_values_ref 
        ORDER BY enum_type,
            order_by,
            enum_value
        )
    LOOP
        DBMS_OUTPUT.PUT_LINE
            (          table_load.rec_id 
            || ', ' || table_load.enum_type 
            || ', ' || table_load.enum_value
            );
    END LOOP;    -- table_load.. 
    
END;  
/ 

*/
