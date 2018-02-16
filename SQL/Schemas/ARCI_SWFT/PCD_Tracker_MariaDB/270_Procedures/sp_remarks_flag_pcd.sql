DELIMITER $$

DROP PROCEDURE IF EXISTS pcd_tracker.sp_remarks_flag_pcd;

$$
CREATE PROCEDURE pcd_tracker.sp_remarks_flag_pcd(
    IN  p_rec_id        INT, 
    IN  p_delete_flag   BOOL,
    OUT p_count         INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'This stored procedure will update the pcd flag for the record.'

BEGIN

/* Source File: sp_remarks_flag_pcd.sql                                       */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: sp_remarks_flag_pcd                                           */
/*      Author: Gene Belford                                                  */
/* Description: This stored procedure will update the pcd flag for            */
/*              the record.                                                   */
/*        Date: 2017-05-31                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-31             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

CALL pcd_tracker.sp_remarks_insert(0, UUID(), 'TEST', SYSDATE(), 'TEST', 'This is a test on the insert sp', @p_count);

SELECT *
FROM pcd_tracker.remarks 
WHERE UPPER(remark_type) = 'TEST';

CALL pcd_tracker.sp_remarks_flag_pcd(128, TRUE, @p_count);

CALL pcd_tracker.sp_remarks_flag_pcd(128, FALSE, @p_count);

-- Error tests below:

CALL pcd_tracker.sp_remarks_flag_pcd();

CALL pcd_tracker.sp_remarks_flag_pcd(-1, 'Bad value type', @p_count);

-- DELETE FROM pcd_tracker.remarks WHERE UPPER(remark_type) = 'TEST';

*/

--    DECLARE table_not_found CONDITION for 1051;
--    DECLARE EXIT HANDLER FOR  table_not_found SELECT 'Please create table abc first';

--    DECLARE EXIT HANDLER FOR 1062 SELECT 'Duplicate keys error encountered';
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN 
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT; 
            SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text); 
            SELECT @full_error; 
        END;
--    DECLARE EXIT HANDLER FOR SQLSTATE '23000' SELECT 'SQLSTATE 23000';
    
-- Update the delete flag for the record 
    UPDATE pcd_tracker.remarks
    SET remark_pcd_flag = p_delete_flag,
        update_date = SYSDATE(),
        update_by   = USER() 
    WHERE UPPER(rec_id) = p_rec_id;
 
-- Return record count for the remarks for rec_id
    SELECT COUNT(*) 
    FROM pcd_tracker.remarks
    WHERE rec_id = p_rec_id;
    
END $$
