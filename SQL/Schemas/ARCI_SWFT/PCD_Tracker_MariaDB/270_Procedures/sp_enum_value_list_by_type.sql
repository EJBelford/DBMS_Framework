DELIMITER $$

DROP PROCEDURE IF EXISTS pcd_tracker.sp_enum_value_list_by_type;

$$
CREATE PROCEDURE pcd_tracker.sp_enum_value_list_by_type (
	IN p_enum_type VARCHAR(25)
)

LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'This stored procedure will update the delete flag for the record.'

BEGIN

/* Source File: sp_enum_value_list_by_type.sql                                */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: sp_enum_value_list_by_type                                    */
/*      Author: Gene Belford                                                  */
/* Description: This stored procedure will update the delete flag for         */
/*              the record.                                                   */
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

CALL pcd_tracker.sp_enum_value_list_by_type('HULL'); 

CALL pcd_tracker.sp_enum_value_list_by_type('TASK'); 

CALL pcd_tracker.sp_enum_value_list_by_type(''); 

CALL pcd_tracker.sp_enum_value_list_by_type('A'); 

CALL pcd_tracker.sp_enum_value_list_by_type('X'); 

*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN 
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT; 
            SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text); 
            SELECT @full_error; 
        END;

    SELECT CONCAT(ev.enum_value, ' : ', ev.enum_display_name, ' : ', ev.description)   
    FROM pcd_tracker.enum_values ev 
    WHERE ev.enum_type LIKE CONCAT('%', p_enum_type, '%')  
    ORDER BY ev.enum_type, ev.order_by;

END 
$$