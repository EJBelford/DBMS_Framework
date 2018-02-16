-- DROP TABLE omega.enumtype CASCADE; 

CREATE TABLE IF NOT EXISTS omega.enumtype (
    uuid                         TEXT    NOT NULL, 
    enumtype                     TEXT    NOT NULL,
    enumtype_desc                TEXT,
    enumtype_classificationtype  TEXT    DEFAULT 'U',  -- Does it have an enumeration? Yes
    enumtype_hidden              BOOLEAN DEFAULT FALSE,
    enumtype_constant            BOOLEAN DEFAULT FALSE, 
    enumtype_documentation       TEXT
    );


COMMENT ON TABLE omega.enumtype
IS 'enumtype - <description>';

COMMENT ON COLUMN omega.enumtype.uuid 
IS 'uuid - The unique durable single field key assigned to the record.';

COMMENT ON COLUMN omega.enumtype.enumtype 
IS 'enumtype - ';

COMMENT ON COLUMN omega.enumtype.enumtype_desc 
IS 'enumtype_desc';

COMMENT ON COLUMN omega.enumtype.enumtype_classificationtype 
IS 'enumtype_classificationtype - ';

COMMENT ON COLUMN omega.enumtype.enumtype_constant 
IS 'enumtype_constant - ';


ALTER TABLE omega.enumtype 
    ADD PRIMARY KEY (enumtype);

CREATE UNIQUE INDEX enumtype_uuid_udx 
    ON omega.enumtype (uuid);

CREATE UNIQUE INDEX enumtype_udx 
    ON omega.enumtype (UPPER(enumtype));

/*----- Unit Test -----*/

-- DELETE FROM omega.enumtype CASCADE;

INSERT INTO omega.enumtype ( uuid, enumtype, enumtype_desc ) 
VALUES ( uuid_generate_v4(), 'Select one...', 'Test 1' );

INSERT INTO omega.enumtype ( uuid, enumtype, enumtype_desc ) 
VALUES ( uuid_generate_v4(), 'SELECT ONE...', 'Test 2' );

INSERT INTO omega.enumtype ( uuid, enumtype, enumtype_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', 'Engine Type' );

SELECT * FROM omega.enumtype; 

/*----------------------*/
/*----------------------*/

-- DROP TABLE omega.enumvalue CASCADE; 

CREATE TABLE IF NOT EXISTS omega.enumvalue ( 
    uuid                TEXT    NOT NULL, 
    enumvalue           TEXT    NOT NULL,
    enumtype            TEXT    NOT NULL, 
    ordering            SERIAL,
    enumvalue_desc      TEXT    NOT NULL,
    enumvalue_hidden    BOOLEAN DEFAULT FALSE,
    enumvalue_constant  BOOLEAN DEFAULT FALSE 
    ); 


COMMENT ON TABLE omega.enumvalue
IS 'enumvalue - <description>';

COMMENT ON COLUMN omega.enumvalue.uuid 
IS 'uuid - The unique durable single field key assigned to the record.';

COMMENT ON COLUMN omega.enumvalue.enumvalue 
IS 'enumvalue - ';

COMMENT ON COLUMN omega.enumvalue.enumtype 
IS 'enumtype - ';

COMMENT ON COLUMN omega.enumvalue.ordering 
IS 'ordering - ';

COMMENT ON COLUMN omega.enumvalue.enumvalue 
IS 'enumvalue - ';

COMMENT ON COLUMN omega.enumvalue.enumvalue_hidden 
IS 'enumvalue_hidden - ';

COMMENT ON COLUMN omega.enumvalue.enumvalue_constant 
IS 'enumvalue_constant - ';


ALTER TABLE omega.enumvalue 
    ADD PRIMARY KEY (uuid);

ALTER TABLE omega.enumvalue 
    ADD CONSTRAINT enumtype_fk 
    FOREIGN KEY (enumtype) 
    REFERENCES omega.enumtype (enumtype) MATCH FULL;

CREATE UNIQUE INDEX enumtype_enumvalue_udx 
    ON omega.enumvalue (UPPER(enumtype), UPPER(enumvalue));

/*----- Unit Test -----*/

/*----- Generate Re-Load Script -----*/

SELECT 'INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) ' 
|| 'VALUES ( ''' || uuid 
|| ''', ''' || enumtype 
|| ''', ''' || enumvalue 
|| ''', '   || ordering 
|| ', '''   || enumvalue_desc 
|| ''', ''' || enumvalue_hidden
|| ''', ''' || enumvalue_constant
|| '''); '
FROM omega.enumvalue ORDER BY enumtype, ordering; 

-- DELETE FROM omega.enumvalue;

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'Select one...', 'a', 0, 'Test 1' );

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'SELECT ONE...', 'a', 1, 'Test 2' );

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'Select one...', 'b', 2, 'Test 3' );

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'Select one...', 'c', -1, 'Test 4' );

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', 'Select one...', -1, 'Test 5 - Select one...' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 10-CYLINDER', 6, 'Test 5 - 2-CYCLE, 10-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 12-CYLINDER', 7, 'Test 5 - 2-CYCLE, 12-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 16-CYLINDER', 8, 'Test 5 - 2-CYCLE, 16-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 5-CYLINDER', 1, 'Test 5 - 2-CYCLE, 5-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 6-CYLINDER', 2, 'Test 5 - 2-CYCLE, 6-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 7-CYLINDER', 3, 'Test 5 - 2-CYCLE, 7-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 8-CYLINDER', 4, 'Test 5 - 2-CYCLE, 8-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '2-CYCLE, 9-CYLINDER', 5, 'Test 5 - 2-CYCLE, 9-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '4-CYCLE, 16-CYLINDER', 9, 'Test 5 - 4-CYCLE, 16-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '4-CYCLE, 42-CYLINDER', 10, 'Test 5 - 4-CYCLE, 42-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '4-CYCLE, 6-CYLINDER', 11, 'Test 5 - 4-CYCLE, 6-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '4-CYCLE, 8-CYLINDER', 12, 'Test 5 - 4-CYCLE, 8-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', '4-CYCLE,12-CYLINDER', 13, 'Test 5 - 4-CYCLE,12-CYLINDER' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', 'STIRLING ENGINE', 14, 'Test 5 - STIRLING ENGINE' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'engineType', 'UNKNOWN', 0, 'Test 5 - UNKNOWN' );


SELECT * FROM omega.enumvalue ORDER BY enumtype, ordering; 

/*----- Generate Re-Load Script -----*/

SELECT 'INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) ' 
|| 'VALUES ( ''' || uuid 
|| ''', ''' || enumtype 
|| ''', ''' || enumvalue 
|| ''', '   || ordering 
|| ', '''   || enumvalue_desc 
|| ''', ''' || enumvalue_hidden
|| ''', ''' || enumvalue_constant
|| '''); '
FROM omega.enumvalue ORDER BY enumtype, ordering; 

/*----- Re-Load enumValue Script -----*/

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( 'd4541c54-50d2-4f1d-b5e8-ef5a56963c6f', 'engineType', 'Select one...', 0, 'Test 5 - Select one...', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( 'aa1e0b86-8a6e-41f4-a801-d17a1e00b46d', 'engineType', '2-CYCLE, 5-CYLINDER', 1, 'Test 5 - 2-CYCLE, 5-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '90e92e75-ac34-457d-8167-98754b9270e8', 'engineType', 'UNKNOWN', 1, 'Test 5 - UNKNOWN', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '93fcb811-8f55-484e-b889-1b86924c94e9', 'engineType', '2-CYCLE, 6-CYLINDER', 2, 'Test 5 - 2-CYCLE, 6-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '7af7c893-c426-459f-aa95-8a21fa46c749', 'engineType', '2-CYCLE, 7-CYLINDER', 3, 'Test 5 - 2-CYCLE, 7-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '37646e6a-4c50-4b69-b521-8b0f29ad6277', 'engineType', '2-CYCLE, 8-CYLINDER', 4, 'Test 5 - 2-CYCLE, 8-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( 'deda8a97-addd-4815-8350-d72e2c6acf72', 'engineType', '2-CYCLE, 9-CYLINDER', 5, 'Test 5 - 2-CYCLE, 9-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '8aade80d-1233-431b-95df-5b8fe6bba627', 'engineType', '2-CYCLE, 10-CYLINDER', 6, 'Test 5 - 2-CYCLE, 10-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '50783765-bd36-4903-8411-60ac7cdf1966', 'engineType', '2-CYCLE, 12-CYLINDER', 7, 'Test 5 - 2-CYCLE, 12-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '96b0e354-a12c-487f-b72a-494ef8d52627', 'engineType', '2-CYCLE, 16-CYLINDER', 8, 'Test 5 - 2-CYCLE, 16-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '0fa65cb4-a779-40a1-a64d-1a2f44a8ef23', 'engineType', '4-CYCLE, 16-CYLINDER', 9, 'Test 5 - 4-CYCLE, 16-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( 'd0ab9cb5-10a5-4cc2-bdf1-1c4d5b0b2b02', 'engineType', '4-CYCLE, 42-CYLINDER', 10, 'Test 5 - 4-CYCLE, 42-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '8a1b6bb6-433e-453b-9765-4a1525ff1083', 'engineType', '4-CYCLE, 6-CYLINDER', 11, 'Test 5 - 4-CYCLE, 6-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '9d58141e-ca79-49e3-876e-d5b81ba61f70', 'engineType', '4-CYCLE, 8-CYLINDER', 12, 'Test 5 - 4-CYCLE, 8-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '20ebc0fa-949c-41c4-a0d3-62abe1589211', 'engineType', '4-CYCLE,12-CYLINDER', 13, 'Test 5 - 4-CYCLE,12-CYLINDER', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( 'f992a0a5-0f01-4532-8dfb-7ddaefd220b1', 'engineType', 'STIRLING ENGINE', 14, 'Test 5 - STIRLING ENGINE', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '0a8110a0-49c0-4de1-8627-6554453841fb', 'Select one...', 'c', -1, 'Test 4', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( '1e670ad2-5f6e-494e-9a51-a260d35f064d', 'Select one...', 'a', 0, 'Test 1', 'false', 'false'); 
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc, enumvalue_hidden, enumvalue_constant ) VALUES ( 'bb2d5ec3-be40-412a-bd28-2d2aa7397026', 'Select one...', 'b', 2, 'Test 3', 'false', 'false'); 

