/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: cbmwh_force_unit_dim
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: cbmwh_force_UNIT_DIM.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 07 April 2008 
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
-- 07APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/

/*----- Constraints - Unique Key -----*/ 

--ALTER TABLE cbmwh_force_unit_dim
--    DROP CONSTRAINT ixu_cbmwh_force_unit_dim; 

ALTER TABLE cbmwh_force_unit_dim
    ADD CONSTRAINT  ixu_cbmwh_force_unit_dim 
    UNIQUE 
    (
    uic, 
    active_date     -- wh_effective_date 
    );

/*

SELECT uic, 
    NVL(active_date, TO_DATE('01-JAN-1900')), 
    COUNT(uic)   
FROM cbmwh_force_unit_dim
GROUP BY uic, NVL(active_date, TO_DATE('01-JAN-1900'))
ORDER BY COUNT(uic) DESC, uic, NVL(active_date, TO_DATE('01-JAN-1900')); 

SELECT uic, 
    NVL(wh_effective_date, TO_DATE('01-JAN-1900')), 
    COUNT(uic)   
FROM cbmwh_force_unit_dim
GROUP BY uic, NVL(wh_effective_date, TO_DATE('01-JAN-1900'))
ORDER BY COUNT(uic) DESC, uic, NVL(wh_effective_date, TO_DATE('01-JAN-1900')); 

SELECT * 
FROM cbmwh_force_unit_dim 
WHERE  uic = 'WAAMAD' 
ORDER BY ari_list_ref_date DESC;  

*/