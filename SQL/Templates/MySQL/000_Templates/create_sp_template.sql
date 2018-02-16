/*
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                  Copyright, Lockheed Martin Corporation, 2017
                        Unpublished, All Rights Reserved
================================================================================
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS <schema>.sp_<table>_<name>;
$$

CREATE PROCEDURE <schema>.sp_<table>_<name> (
  IN p_<field01> VARCHAR(25)
)

LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''

BEGIN

/* Source File: sp_<table>_<name>.sql                                */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: sp_<table>_<name>                                    */
/*      Author: <author>                                                  */
/* Description: <description>                                                   */
/*        Date: <yyyy-mm-dd>                                                    */
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

CALL <schema>.sp_<table>_<name>('field01'); 

*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN 
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT; 
            SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text); 
            SELECT @full_error; 
        END;

    SELECT CONCAT(ev.<field01>, ' : ', ev.<field01>)   
    FROM <schema>.<table> ev 
    WHERE ev.<field01> LIKE CONCAT('%x', p_<field01>, '%')  
    ORDER BY ev.<field01>;

END 
$$

DELIMITER ; 
