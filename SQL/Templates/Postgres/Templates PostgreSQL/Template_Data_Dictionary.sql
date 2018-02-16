/*
2014-03-13 - Gene Belford

Found good working examples of data dictionary scripts at the 
address shown below: 

http://www.alberton.info/postgresql_meta_info.html#.UyH6kkdOVAg

The examples where tuned for my needs.
*/

-- Basic table list 

SELECT d.nspname AS schema_name,
    pg_catalog.obj_description(d.oid) AS schema_comment,
    c.relname    AS table_name,
    pg_catalog.obj_description(c.oid) AS table_comment
--    , c.* 
FROM pg_class c
LEFT JOIN pg_namespace d ON d.oid      = c.relnamespace         
WHERE d.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema') 
    AND c.reltype > 0
--    AND c.relname = 'dataobj' 
ORDER BY c.relname;


-- Detailed column table list by schema, table, column 

SELECT d.nspname AS schema_name,
    pg_catalog.obj_description(d.oid) AS schema_comment,
    c.relname    AS table_name,
    pg_catalog.obj_description(c.oid) AS table_comment,
    a.attnum     AS ordinal_position,
    a.attname    AS column_name,
    t.typname    AS data_type,
    a.attlen     AS character_maximum_length,
    pg_catalog.col_description(c.oid, a.attnum) AS field_comment,
    a.atttypmod  AS modifier,
    a.attnotnull AS notnull,
    a.atthasdef  AS hasdefault
FROM pg_class c
LEFT JOIN pg_attribute a ON a.attrelid = c.oid
LEFT JOIN pg_type t      ON a.atttypid = t.oid
LEFT JOIN pg_namespace d ON d.oid      = c.relnamespace         
WHERE d.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema') 
--    AND c.relname = 'dataobj' 
    AND a.attnum > 0 
    AND c.reltype > 0 
ORDER BY c.relname, a.attnum;


-- Column missing comments - needs work - 2014-03-13
-- Better 2014-03-14

SELECT d.nspname AS schema_name,
    pg_catalog.obj_description(d.oid) AS schema_comment,
    c.relname    AS table_name,
    a.attname    AS column_name  
    , t.typname    AS data_type 
    FROM pg_class c
LEFT JOIN pg_attribute a ON a.attrelid = c.oid
LEFT JOIN pg_type t      ON a.atttypid = t.oid
LEFT JOIN pg_namespace d ON d.oid      = c.relnamespace         
WHERE d.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema') 
--    AND c.relname = 'dataobj' 
    AND pg_catalog.col_description(c.oid, a.attnum) IS NULL
    AND a.attnum > 0 
    AND c.reltype > 0 
ORDER BY c.relname, a.attnum;


/*--------------------------------*/
/* Gene Belford work - 2014-03-11 */
/*--------------------------------*/

SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
    , pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pn.nspname = 'public' 
--    AND pc.relname = LOWER('omega_batch_tasks') 
ORDER BY objoid, objsubid;

SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
    , pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pn.nspname = 'public' 
    AND objsubid = 0  
ORDER BY relname, objsubid;


SELECT *
FROM information_schema.tables t
JOIN information_schema.columns c ON t.table_name = c.table_name
WHERE t.table_schema = 'public'
ORDER BY t.table_name, c.ordinal_position;
