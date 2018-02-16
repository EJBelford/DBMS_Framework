-- DELETE FROM omega.enumtype WHERE enumtype = 'ClassificationType';

INSERT INTO omega.enumtype ( uuid, enumtype, enumtype_desc, enumtype_documentation ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'Classification Type', 
    'This simple type is used by the classification attribute to identify the highest level of classification of the information being encoded. It is manifested in portion marks and security banners.

         PERMISSIBLE VALUES

         The permissible values for this simple type are defined in the Controlled Value Enumeration:

         CVEnumISMClassificationAll.xml');

-- DELETE FROM omega.enumvalue WHERE enumtype = 'ClassificationType';

INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'Select one...', -1, 'Select one...' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'U',              1, 'Unclassified' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'C',              2, 'Classified' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'S',              3, 'Secret' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'TS',             4, 'Top Secret' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'R',              5, 'R' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'CTS',            6, 'CTS' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'CTS-B',          7, 'CTS-B' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'CTS-BULK',       8, 'CTS-BULK' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'NU',             9, 'NU' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'NR',            10, 'NR' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'NC',            11, 'NC' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'NS',            12, 'NS' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'CTSA',          13, 'CTSA' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'NSAT',          14, 'NSAT' );
INSERT INTO omega.enumvalue ( uuid, enumtype, enumvalue, ordering, enumvalue_desc ) 
VALUES ( uuid_generate_v4(), 'ClassificationType', 'NCA',           15, 'NCA' );
