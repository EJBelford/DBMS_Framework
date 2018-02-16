DELIMITER $$

DROP PROCEDURE IF EXISTS pcd_tracker.sp_enum_type_list_all;

$$
CREATE PROCEDURE pcd_tracker.sp_enum_type_list_all (
	IN p_enum_type VARCHAR(25)
)

LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'List all the enumeration types that match the wildcard search.'

BEGIN

/* Source File: sp_enum_type_list_all.sql                                     */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: sp_enum_type_list_all                                         */
/*      Author: Gene Belford                                                  */
/* Description: List all the enumeration types that match the wildcard        */
/*              search.                                                       */
/*        Date: 2017-06-01                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-06-01             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

CALL pcd_tracker.sp_enum_type_list_all(''); 

CALL pcd_tracker.sp_enum_type_list_all('A'); 

CALL pcd_tracker.sp_enum_type_list_all('Z'); 

*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN 
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT; 
            SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text); 
            SELECT @full_error; 
        END;

    SELECT CONCAT(ev.enum_type, ' : ', ev.enum_type_desc)   
    FROM pcd_tracker.enum_types ev 
    WHERE ev.enum_type LIKE CONCAT('%', p_enum_type, '%')  
    ORDER BY ev.enum_type;

END 
$$