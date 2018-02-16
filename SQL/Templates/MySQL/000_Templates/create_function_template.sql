/*
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  Copyright, Lockheed Martin Corporation, 2017
                        Unpublished, All Rights Reserved
================================================================================
*/

DELIMITER $$

DROP FUNCTION IF EXISTS <fn_name>;
$$

CREATE FUNCTION <fn_name>()
    RETURNS CHAR(36)
    
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT '<description>'

BEGIN
/* Source File: <fn_name>.sql                                                   */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <fn_name>                                                       */
/*      Author: <author>                                                  */
/* Description: <description>     */
/*                                                                            */
/*        Date: <yyyy-mm-dd>                                                    */
/* Source File: <fn_name>.sql                                          */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

SELECT <fn_name>();

*/

    -- Generate 8 2-byte strings that we will combine into a UUIDv4
    SET @x = '';
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
    RETURN @x;
END 
$$ 

DELIMITER ; 

