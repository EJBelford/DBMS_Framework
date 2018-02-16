DELIMITER $$

DROP FUNCTION IF EXISTS uuid_v4;

$$
CREATE FUNCTION uuid_v4()
    RETURNS CHAR(36)
    
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'This function build a string of all the remarks related to the parent.'

BEGIN
/* Source File: uuid_v4.sql                                                   */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: uuid_v4                                                       */
/*      Author: Gene Belford                                                  */
/* Description: MySQL only generates a UUID version 1.  Found this on the     */
/*              web.                                                          */
/* https://stackoverflow.com/questions/32965743/how-to-generate-a-uuidv4-in-mysql */
/*        Date: 2017-06-13                                                    */
/* Source File: f_remarks_string.sql                                          */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-13             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

SELECT CONCAT('UUID v1: ', uuid(), '  UUID v4: ', uuid_v4());

SELECT CONCAT('UUID v1: ', uuid(), '  UUID v4: ', uuid_v4());

SELECT CONCAT('UUID v1: ', uuid(), '  UUID v4: ', uuid_v4());

SELECT CONCAT('UUID v1: ', uuid(), '  UUID v4: ', uuid_v4());

SELECT CONCAT('UUID v1: ', uuid(), '  UUID v4: ', uuid_v4());

*/

    -- Generate 8 2-byte strings that we will combine into a UUIDv4
    SET @h1 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h2 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h3 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h6 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h7 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h8 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');

    -- 4th section will start with a 4 indicating the version
    SET @h4 = CONCAT('4', LPAD(HEX(FLOOR(RAND() * 0x0fff)), 3, '0'));

    -- 5th section first half-byte can only be 8, 9 A or B
    SET @h5 = CONCAT(HEX(FLOOR(RAND() * 4 + 8)),
                LPAD(HEX(FLOOR(RAND() * 0x0fff)), 3, '0'));

    -- Build the complete UUID
    RETURN LOWER(CONCAT(
        @h1, @h2, '-', @h3, '-', @h4, '-', @h5, '-', @h6, @h7, @h8
    ));
END $$
