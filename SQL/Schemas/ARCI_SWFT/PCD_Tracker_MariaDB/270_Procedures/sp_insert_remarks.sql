DELIMITER $$

DROP PROCEDURE IF EXISTS pcd_tracker.sp_remarks_insert;

$$
CREATE PROCEDURE pcd_tracker.sp_remarks_insert(
	IN  p_parent_rec_id    INT,
	IN  p_parent_rec_uuid  VARCHAR(36),
	IN  p_remarks_type     VARCHAR(8),
	IN  p_remarks_date     TIMESTAMP,
	IN  p_remarks_user     VARCHAR(50),
	IN  p_remark           TEXT,
    OUT p_count            INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'This stored procedure will insert a new remark for the parent record into the remarks table.'

BEGIN

/* Source File: sp_remarks_insert.sql                                         */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: sp_remarks_insert                                             */
/*      Author: Gene Belford                                                  */
/* Description: This stored procedure will insert a new remark for the        */
/*              parent record into the remarks table.                         */
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

-- Error tests below:

CALL pcd_tracker.sp_remarks_insert(   UUID(), 'TEST', SYSDATE(), 'TEST', 'This is a test on the insert sp', @p_count);

CALL pcd_tracker.sp_remarks_insert('Error', UUID(), 'TEST', SYSDATE(), 'TEST', 'This is a test on the insert sp', @p_count);

SELECT *
FROM pcd_tracker.remarks 
WHERE UPPER(remark_type) = 'TEST';

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
    
-- insert a new record into remarks
    INSERT INTO pcd_tracker.remarks(
        parent_rec_id, parent_rec_uuid, remark_type, remark_date, remark_user, remark
        )
    VALUES(
        p_parent_rec_id, p_parent_rec_uuid, p_remarks_type, p_remarks_date, p_remarks_user, p_remark
        );
 
-- return tag count for the remarks for rec_id
    SELECT COUNT(*) 
    FROM pcd_tracker.remarks
    WHERE parent_rec_id = p_parent_rec_id;
    
END $$
