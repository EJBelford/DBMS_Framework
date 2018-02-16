/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: pfsa_table 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: pfsa_table.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: dd month yyyy 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES: 
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Indexs -----*/

-- DROP INDEX idx_table_field; 

CREATE INDEX idx_table_field 
    ON pfsa_table
    (
    field
    )
    LOGGING 
    TABLESPACE PFSANDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512K
                NEXT             512K
                MINEXTENTS       2
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ); 
/ 



